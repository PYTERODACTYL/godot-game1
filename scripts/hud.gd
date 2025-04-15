extends CanvasLayer

func _on_characterzombie_zumbi_morto():
	
	if Audio.zumbis <= 0:
		$Label.visible = false 
		$ContZumbis.visible = false
		$RestamZumbis.visible = true
		$ContRestantes.visible = true
		$ContRestantes.text = str(Audio.zumbis_vivos - 1)
	else:
		$ContZumbis.text = str(Audio.zumbis)
		$RestamZumbis.visible = false
		$ContRestantes.visible = false


func _on_player_livinha_dano(dano):
	$VidaQtd.text = str(dano)
	$VidaBarra.value = dano
	if(dano) == 25.0:
		$VidaBaixa.visible = true
	else:
		$VidaBaixa.visible = false


func _on_player_menos_bala(balas):
	$BalasAtual.text = str(balas)


func _on_player_recarregando_state():
	$BalasMax.visible = false
	$BalasAtual.visible = false
	$Recarregando.visible = true


func _on_player_recarregando_state_fim():
	$BalasMax.visible = true
	$BalasAtual.visible = true
	$Recarregando.visible = false
	$BalasAtual.text = str(6)


func _on_player_efeito_cafe():
	$Cafezinho.visible = true


func _on_player_efeito_cafe_passou():
	$Cafezinho.visible = false
