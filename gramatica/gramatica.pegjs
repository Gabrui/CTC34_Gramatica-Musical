Dynota = c:Cabecalho _ p:Pentagrama _ {return [c, p];}

Cabecalho = "Titulo:" _ titulo:([^\n]*) [\n] {return {"T": titulo.join("")};}

Pentagrama
  = Simbolo*

Simbolo
  = _ n:Nota aci:Acidente? temp:Temporizacao? {if (aci!=null) n.push(aci); if (temp!=null) n[2]*=temp; return n}

Acidente
  = "#" / "##" / "b" / "bb"

Temporizacao
  = div:"/"? val:Inteiro {if (div!=null) val = 1/val; return val}

Nota "nota"
  = NotaNormalAumentada
  / NotaOitavaAcimaAumentada
  / NotaNormal
  / NotaOitavaAcima
  / "pausa" {return ["pausa", 0, 1]}

NotaNormal
  = ("do" / "re" / "mi" / "fa" / "sol" / "la" / "si") {return [text(), 0, 1];}

NotaNormalAumentada
  = n:("doo" / "ree" / "mii" / "faa" / "sool" / "laa" / "sii") {return [n[0]+n.slice(2), 0, 2];}

NotaOitavaAcima
  = n:("Do" / "Re" / "Mi"/ "Fa" / "Sol" / "La"/ "Si") {return [text().toLowerCase(), 1, 1];}

NotaOitavaAcimaAumentada
  = n:("Doo" / "Ree" / "Mii"/ "Faa" / "Sool" / "Laa"/ "Sii") {return [(n[0]+n.slice(2)).toLowerCase(), 1, 2];}


Inteiro "inteiro"
  = [0-9]+ { return parseInt(text(), 10); }

_ "espaços brancos"
  = [ \t\n\r]*