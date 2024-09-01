extends Control

signal onInteractButtonPressed(item)
signal onItemSelected(item)
onready var itemNameLabel = $HBoxContainer/Control/Info/Label
onready var itemTextureRect = $HBoxContainer/Control/Info/TextureRect

var item: ItemBase
var isSelected = false
var isFightMode = false
var selectedMode = ""
var isBuy = false
var isSell = false
var isLoot = false
var isStash = false
var isTake = false
var isGive = false
var isEquipTake = false

func _ready():
	var minSizeInv = OPTIONS.getInventoryIconSize()
	$HBoxContainer/Control/Info/TextureRect.rect_min_size.x = minSizeInv
	$HBoxContainer/Control/Info/TextureRect.rect_min_size.y = minSizeInv
	setSelected(false)

func setItem(theItem:ItemBase, theMode):
	isFightMode = (theMode == "fight")
	isBuy = (theMode == "buy")
	isSell = (theMode == "sell")
	isLoot = (theMode == "loot")
	isStash = (theMode == "stash")
	isTake = (theMode == "take")
	isGive = (theMode == "give")
	isEquipTake = (theMode == "equiptake")
	selectedMode = theMode
	item = theItem
	updateInfo()
	
	if(isBuy):
		$HBoxContainer/HBoxContainer/InteractButton.text = "Craft"
	if(isSell):
		$HBoxContainer/HBoxContainer/InteractButton.text = "Sell"
	if(isLoot):
		$HBoxContainer/HBoxContainer/InteractButton.text = "Take"
	if(isStash):
		$HBoxContainer/HBoxContainer/InteractButton.text = "Stash"
	if(isTake):
		$HBoxContainer/HBoxContainer/InteractButton.text = "Take"
	if(isGive):
		$HBoxContainer/HBoxContainer/InteractButton.text = "Give"
	if(isEquipTake):
		if(item.getClothingSlot() != null):
			if(item.isWornByWearer()):
				$HBoxContainer/HBoxContainer/InteractButton.text = "Unequip"
			else:
				$HBoxContainer/HBoxContainer/InteractButton.text = "Equip"
		else:
			$HBoxContainer/HBoxContainer/InteractButton.text = "Take"
		
func getItem():
	return item

func canDoAction(action):
	if(isFightMode && action.has("onlyWhenCalm") && action["onlyWhenCalm"]):
		return false
		
	return true

func updateInfo():
	if(item == null):
		return
	
	if(item.isWornByWearer()):
		itemNameLabel.text = "(worn) "+item.getInventoryName()
	else:
		itemNameLabel.text = item.getInventoryName()
	
	if(isBuy):
		var price = ceil(item.getPrice()/5.0) if (item.getPrice()>0) else 1.0
		var priceStr = (str(price)+" core") if price == 1 else (str(price)+" cores")
		itemNameLabel.text = item.getVisibleName()+" ("+priceStr+")"
		if(item.getBuyAmount() > 1):
			itemNameLabel.text = str(item.getBuyAmount())+"x"+itemNameLabel.text
	if(isSell && !item.isImportant()):
		var sellPrice = item.getStackSellPrice()
		var priceStr = (str(sellPrice)+" credit") if sellPrice == 1 else (str(sellPrice)+" credits")
		itemNameLabel.text += " ("+priceStr+")"
		
	
	var imagePath = item.getInventoryImage()
	if(imagePath != null):
		var theImage = load(imagePath)
		if(theImage != null):
			itemTextureRect.texture = theImage
			itemTextureRect.self_modulate = item.getInventoryImageColor()
	
	if(isFightMode):
		var possibleActions = item.getPossibleActions()
		if(possibleActions.size() == 1 && canDoAction(possibleActions[0])):
			showUseButton(true)
		else:
			showUseButton(false)
	else:
		showUseButton(false)
		
		if(isTake || isStash || isGive):
			showUseButton(true)
		
		if(isEquipTake):
			showUseButton(true)
		
		if(isBuy || isSell || isLoot):
			showUseButton(true)
			if(isSell):
				if(item.isImportant()):
					showUseButton(false)
			if(isBuy):
				var price = ceil(item.getPrice()/5.0) if (item.getPrice()>0) else 1.0
				if(GM.pc.getInventory().getAmountOf("NanoCore") < price):
					$HBoxContainer/HBoxContainer/InteractButton.disabled = true
				else:
					$HBoxContainer/HBoxContainer/InteractButton.disabled = false
			

func _on_InteractButton_pressed():
	emit_signal("onInteractButtonPressed", item)

func _on_SelectButton_pressed():
	emit_signal("onItemSelected", item)

func setSelected(isNewSelected):
	if(isNewSelected != isSelected):
		if(isNewSelected):
			$ColorRect.color.a = 0.0
		else:
			$ColorRect.color.a = 1.0
	isSelected = isNewSelected


var showingTooltip = false
func _on_SelectButton_mouse_entered():
	showingTooltip = true
	GlobalTooltip.showTooltip(item.getStackName(), item.getVisibleDescription(), false, true)

func _on_SelectButton_mouse_exited():
	if(showingTooltip):
		showingTooltip = false
		GlobalTooltip.hideTooltip()

func showUseButton(isShow):
	$HBoxContainer/HBoxContainer.visible = isShow


func _on_InventoryEntry_hide():
	_on_SelectButton_mouse_exited()
