#===============================================================================
#
#===============================================================================
class PokemonTrainerCard_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    addBackgroundPlane(@sprites, "bg", "Trainer Card/bg", @viewport)
    @sprites["card"] = IconSprite.new(0, 0, @viewport)
    @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card")
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    # @sprites["trainer"] = IconSprite.new(336, 112, @viewport)
    # @sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
    # @sprites["trainer"].x -= (@sprites["trainer"].bitmap.width - 128) / 2
    # @sprites["trainer"].y -= (@sprites["trainer"].bitmap.height - 128)
    # @sprites["trainer"].z = 2
    pbDrawTrainerCardFront
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbDrawTrainerCardFront
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    pbSetSmallFont(overlay)
    baseColor   = Color.new(240, 240, 240)
    shadowColor = Color.new(40, 40, 40)
    totalsec = $stats.play_time.to_i
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    time = (hour > 0) ? _INTL("{1}h {2}m", hour, min) : _INTL("{1}m", min)
    $PokemonGlobal.startTime = pbGetTimeNow if !$PokemonGlobal.startTime
    starttime = _INTL("{1} {2}, {3}",
                      pbGetAbbrevMonthName($PokemonGlobal.startTime.mon),
                      $PokemonGlobal.startTime.day,
                      $PokemonGlobal.startTime.year)
    textPositions = [
      [_INTL("TRAINER CARD"), 24, 244, 0, baseColor, shadowColor],
      [_INTL("Name") + ": " + $player.name, 24, 274, 0, baseColor, shadowColor],
      #[, 302, 70, 1, baseColor, shadowColor],
      [_INTL("ID No." + sprintf(" %05d", $player.public_ID)), 24, 298, 0, baseColor, shadowColor],
      [_INTL("Money") + ": " + _INTL("${1}", $player.money.to_s_formatted), 24, 322, 0, baseColor, shadowColor],
      [_INTL("Pokédex") + ": " + sprintf("%d/%d", $player.pokedex.owned_count, $player.pokedex.seen_count), 200, 274, 0, baseColor, shadowColor],
      #[, 302, 166, 1, baseColor, shadowColor],
      [_INTL("Time") + ": " + time, 200, 298, 0, baseColor, shadowColor],
      #[, 302, 214, 1, baseColor, shadowColor],
      [_INTL("Started") + ": " + starttime, 200, 322, 0, baseColor, shadowColor],
      #[starttime, 302, 262, 1, baseColor, shadowColor]
    ]
    pbDrawTextPositions(overlay, textPositions)
  end

  def pbTrainerCard
    pbSEPlay("GUI trainer card open")
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

#===============================================================================
#
#===============================================================================
class PokemonTrainerCardScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbTrainerCard
    @scene.pbEndScene
  end
end
