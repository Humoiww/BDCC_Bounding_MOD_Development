extends SceneBase

var bratCounter = 0
var craftingItemsTags = []
var craftingItems = [
	"NanoBrick"
	]
var sortedItemsIds = []
var finalcraftingItemsObjects = []

var lockedInto = false

func _init():
	sceneID = "NanoBlueprintHumoi"

func displayCoreCount(coreAmount):
	if coreAmount > 1:
		saynn("You have "+ str(coreAmount) +" cores.")
	elif coreAmount > 0:
		saynn("You have only one core.")
	else:
		saynn("You don't have any core.")

func sayCharater(ch,text):
	saynn("[say=" +ch+ "]" +text + "[/say]")

func _initScene(_args = []):
	if(_args.size() > 0):
		lockedInto = true
		setState(_args[0])
		if(_args.size() > 1):
			craftingItemsTags = _args[1]
	var craftableItem = GM.main.getModuleFlag("NanoRevolutionModule", "NanoCraftableItem", {})
	for itemID in craftableItem:
		if craftableItem[itemID] == true:
			craftingItems.append(itemID)
	var craftableTag = GM.main.getModuleFlag("NanoRevolutionModule", "NanoCraftableTag", {})
	for tag in craftableTag:
		if craftableItem[tag] == true:
			craftingItemsTags.append(tag)

func _run():
	if(state == ""):
		
		addCharacter("humoi")
		playAnimation(StageScene.Duo, "stand", {npc="humoi"})
		if (!getModuleFlag("NanoRevolutionModule","NanoAfterFirstBlueprintHumoi",false)):
			sayCharater("humoi","Great, you’re interested in blueprints for using those nano cores! I’ve got you covered. I offer two types of blueprints:")

			sayCharater("humoi","First, these are general Blueprint Sets and can be used to craft a variety of common items.")

			sayCharater("humoi","Second, these are for special Blueprints, unique items. Think of them as powerful tools or weapons that can give you an edge in combat.")

			
		saynn("[say=humoi]?[/say]")


		
		addButton("Leave","I think that's it","endthescene")







	if(state == "debug_message_state"):
		addCharacter("humoi")
		playAnimation(StageScene.Duo, "stand", {npc="humoi"})
		saynn("[say=humoi]So, you want to know more about me? You’re so sweet! But for now, sorry for breaking the fourth wall—I have to tell you that this scene hasn’t been implemented yet. This is the only part you’ll see for now.[/say]")
		
		saynn("Humoi playfully made a pouty face, tilting her head slightly.")

		saynn("[say=humoi]But I can give you a hint about what to expect in the future. It doesn’t make much sense for you to learn how to craft something with nano cores by kicking those androids' asses, right? You can get familiar with them, sure, but you’ll need to learn some techniques from others. That’s why I’m here—to offer advice and blueprints related to those nano things.[/say]")

		saynn("Humoi paused for a moment, thinking, then continued speaking.")

		saynn("[say=humoi]In this mod, I initially thought about having Alex teach you these things. But then I realized it would be out of character for him to teach something dangerous, like nano weapons or anything like that. So, there needs to be a “bad guy” to offer some forbidden knowledge for a bit of fun. That’s where I come in. In the next update, you’ll be able to get some really cool stuff from me. And if you have any great ideas, just remember there’s an issue option in the survey part.[/say]")
		
		saynn("Humoi flashed a mischievous grin.")
		
		saynn("[say=humoi]Well, since this scene is set up, let’s do a little test. See that Trade button? You can click it to give me one core, and I’ll give you 3 credits. Great deal, isn’t it?~[/say]")
		var coreAmount = GM.pc.getInventory().getAmountOf("NanoCore")
		displayCoreCount(coreAmount)
		if(coreAmount >= 1):
			addButton("Trade","Trade one core","trade")
		else:
			addDisabledButton("Trade","You don't have any core, better go and get some for me?")
		addButton("Leave","Seems like there's not much to talk about right now, is there? But trust me, there'll be something in the future. X3","endthescene")
	if(state == "trade"):
		var coreAmount = GM.pc.getInventory().getAmountOf("NanoCore")
		displayCoreCount(coreAmount)
		if(coreAmount >= 1):
			addButton("Trade","Trade one core","trade")
		else:
			addDisabledButton("Trade","You don't have any core, better go and get some for me?")
		addButton("Leave","Seems like there's not much to talk about right now, is there? But trust me, there'll be something in the future. X3","endthescene")

func _react(_action: String, _args):
	if(_action == "endthescene"):
		endScene()
		return

	if(_action == "trade"):
		GM.pc.getInventory().removeXOfOrDestroy("NanoCore",1)
		GM.pc.addCredits(3)
		setState("trade")
		return

	if(_action == "ask_key"):
		GM.main.setModuleFlag("NanoRevolutionModule", "NanoAskHumoiKey", true)

	if(_action == "aftercare"):
		processTime(30*60)

	setState(_action)

func saveData():
	var data = .saveData()

	return data

func loadData(data):
	.loadData(data)

