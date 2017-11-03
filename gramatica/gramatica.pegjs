Dynota = c:Cabecalho _ p:Pentagrama _ {return [c, p];}

Cabecalho = t:Titulo? _ c:Compositor? _ m:Tempo? _ l:TempoNota? {let a = {}; if(t!=null) a.T=t; if(c!=null) a.C=c; if(m!=null) a.M=m; if(l!=null) a.L=l; return a;}

Titulo = "Titulo:" _ titulo:([^\n]*) [\n] {return titulo.join("");}

Compositor = "Compositor:" _ compositor:([^\n]*) [\n] {return compositor.join("");}

Tempo = "Tempo:" _ s:([^\n]*) [\n] {return s.join("");}

TempoNota = "Nota:" _  s:([^\n]*) [\n] {return s.join("");}

Pentagrama
  = Simbolo*

Simbolo
  = _ n:Nota aci:Acidente? temp:Temporizacao? {if (aci!=null) n.push(aci); if (temp!=null) n[2]*=temp; return n}

Acidente
  = "#" / "##" / "b" / "bb"

Temporizacao
  = "/" val:Inteiro {return 1/val;} / Fracao

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
 
Fracao "Fração"
  = num:Inteiro "/"? den:Inteiro? {let resp = num; if(den!=null) resp/=den; return resp} 

_ "espaços brancos"
  = [ \t\n\r]*