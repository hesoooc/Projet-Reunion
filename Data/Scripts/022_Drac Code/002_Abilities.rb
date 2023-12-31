Battle::AbilityEffects::EndOfRoundEffect.add(:DOUBLENOTHING,
  proc { |item, battler, battle|
      stats = [:ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :ACCURACY, :EVASION]
      case rand(2)
      when 0     
          battler.pbRaiseStatStageByAbility(stats[rand(stats.length)], rand(2) + 1, battler)
      when 1
          battler.pbLowerStatStageByAbility(stats[rand(stats.length)], rand(2) + 1, battler)
      end
  }
)

Battle::AbilityEffects::OnBeingHit.add(:SECONDCHANCE,
  proc { |ability, user, target, move, battle|
    next if target.fainted?
    next if target.effects[PBEffects::SecondChance]
    next if target.hp >= (target.totalhp * 0.25).to_i
    battle.pbShowAbilitySplash(target)
    battle.pbDisplay(_INTL("Le Pokémon reçoit un Second Souffle grâce à son lien avec Lilith !"))
    target.pbRecoverHP(target.totalhp)
    target.pbLowerStatStageByAbility(:DEFENSE,1,target)
    target.pbLowerStatStageByAbility(:SPECIAL_DEFENSE,1,target)
    target.effects[PBEffects::SecondChance] = true
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::CriticalCalcFromUser.add(:TOTHELIMIT,
  proc { |item, user, target, c|
    if user.hp <= (user.totalhp * 0.25).to_i
      user.battle.pbDisplay(_INTL("Le Pokémon est rempli de rage !")) if !user.effects[PBEffects::SecondChance]
      user.effects[PBEffects::SecondChance] = true
      next 99 
    end
  }
)
