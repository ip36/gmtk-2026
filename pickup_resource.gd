extends Resource
class_name PickupResource

## Text that will display in the game. E.g. Gravity, Health, Speed, Size
@export var name: String
## Which property this pickup will reduce. See player.gd for the list. E.g. speed, jumpspeed, fallspeed, health
enum PropertyKey {size, speed, jump, gravity, block_size, world_size, health, windspeed}
@export var property: PropertyKey
## Pickup sprite texture. Matches up with name of animations in the AnimatedSprite2D in the propertymover scene.
@export_enum("red", "green", "blue") var texture: String
