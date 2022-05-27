// ----------------------------------
// Grow into a bigger form of critter
// ----------------------------------
/datum/targetable/critter/boilgib
	name = "Blood Boil"
	desc = "Expend all of your energy to self-destruct and spray boiling changeling blood on nearby targets."
	cooldown = 0
	start_on_cooldown = 0
	icon_state = "blood_boil"

	cast(atom/target)
		if (..())
			return 1
		var/mob/ow = holder.owner

		if(alert(ow, "This will destroy your body to scald all nearby targets! Are you sure?",,"Yes","No") == "No")
			return

		for (var/turf/splat in view(2,ow.loc))
			if (prob(50))
				var/obj/decal/cleanable/blood/B = make_cleanable(/obj/decal/cleanable/blood,splat)
				B.sample_reagent = "bloodc"

		ow.visible_message(text("<span class='alert'><B>[holder.owner] boils and bursts open violently!</B></span>"))

		var/dmg = 20
		//Increase the power of the boilgib if we have collected DNA!
		if (istype(holder.owner, /mob/living/critter/changeling/handspider))
			dmg += holder.owner:absorbed_dna * 3.3
		for (var/mob/M in view(3,ow.loc))
			if(iscarbon(M))
				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					if(istype(H.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(H.head, /obj/item/clothing/head/bio_hood))
						boutput(M, "<span class='notice'>You are sprayed with blood, but your biosuit protects you!</span>")
						continue
				M.emote("scream")
				M.TakeDamage("chest", 0, dmg, 0, DAMAGE_BURN)
				if (M.reagents)
					M.reagents.add_reagent("bloodc", dmg, null, T0C)
				boutput(M, "<span class='alert'>You are sprayed with sizzling hot blood!</span>")
		ow.gib()

// A version that doesn't gib you or add reagents, for some basic attack variety
/datum/targetable/critter/boilblood
	name = "Blood Boil"
	desc = "Spray boiling blood on nearby targets."
	cooldown = 40 SECONDS
	start_on_cooldown = 0
	icon_state = "blood_boil"

	// "sound/effects/screech_tone.ogg", 40, 1, 0.1, 0.8

	cast(atom/target)
		if (..())
			return 1
		var/mob/ow = holder.owner

		for (var/turf/splat in view(2,ow.loc))
			if (prob(50))
				var/obj/decal/cleanable/blood/B = make_cleanable(/obj/decal/cleanable/blood,splat)
				B.sample_reagent = "blood"

		ow.visible_message(text("<span class='alert'><B>[holder.owner] boils and splatters blood everywhere!</B></span>"))

		for (var/mob/M in view(1,ow.loc))
			if(iscarbon(M))
				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					if(istype(H.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(H.head, /obj/item/clothing/head/bio_hood))
						boutput(M, "<span class='notice'>You are sprayed with blood, but your biosuit protects you!</span>")
						continue
				M.emote("scream")
				M.TakeDamage("chest", 0, rand(5,10), 0, DAMAGE_BURN)
				playsound(M, "sound/impact_sounds/Slimy_Splat_1.ogg", 30, 1, -1)
				boutput(M, "<span class='alert'>You are sprayed with sizzling hot blood!</span>")
