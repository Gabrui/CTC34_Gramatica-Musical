{
var tg = 1;
var og = 0;
}
Dynota = _ cabecalho:Cabecalho _ vozes:Vozes _ {return {cabecalho, vozes};}

Cabecalho = t:Titulo? _ c:Compositor? _ m:Tempo? _ l:TempoNota? _ v:Velocidade? _ k:Escala? _ d:Diretiva?
{let a = {}; if(t!=null) a.T=t; if(c!=null) a.C=c; if(m!=null) a.M=m; if(l!=null) a.L=l; if(v!=null) a.Q=v; if(k!=null) a.K=k; if(d!=null) a["%%score"]=d; return a;}

Titulo = "Titulo:" _ titulo:([^\n]*) [\n] {return titulo.join("");}

Compositor = "Compositor:" _ compositor:([^\n]*) [\n] {return compositor.join("");}

Tempo = "Tempo:" _ s:([^\n]*) [\n] {return s.join("");}

Velocidade = "Velocidade:" _ s:([^\n]*) [\n] {return s.join("");}

Diretiva = "Juntos:" s:([^\n]*) [\n] {return s.join("");}

TempoNota = "Nota:" _  s:([^\n]*) [\n] {return s.join("");}

Escala = "Escala:" _  s:([^\n]*) [\n] {return s.join("");}

Vozes = p:VozPrincipal v:Voz* {let r = [p]; return r.concat(v);}

VozPrincipal = _ nomeVoz:IdVoz? _ notas:Pentagrama {return {nomeVoz, notas};}
Voz = _ nomeVoz:IdVoz _ notas:Pentagrama {return {nomeVoz, notas};}

IdVoz = "Instrumento:" _ s:([^\n]*) [\n] {tg=1; og=0; return s.join("");}

Pentagrama
  = Simbolo*

Simbolo
= _ n:Nota aci:Acidente? temp:Temporizacao? _ Comando? {if (aci!=null) n["acidente"]=(aci); if (temp!=null) n["tempo"]*=temp; return n}

Comando = 
  "maisLento" {tg*=2; return null;}
  /"maisRapido" {tg/=2; return null;}
  /"sobeOitava" {og++; return null;}
  /"desceOitava" {og--; return null;}

Acidente
  = "#" / "##" / "b" / "bb"

Temporizacao
  = "/" val:Inteiro {return 1/val;} / Fracao

Nota "nota"
  = NotaNormalAumentada
  / NotaOitavaAcimaAumentada
  / NotaNormal
  / NotaOitavaAcima
  / "pausa" {return {nota:"pausa", oitava:og, tempo:tg}}
  / s:([^ \t\n\r:]*) [ \t\n\r] {return {nota:s.join(""), especial:true};}

NotaNormal
  = ("do" / "re" / "mi" / "fa" / "sol" / "la" / "si") {return {nota:text(), oitava:og, tempo:tg};}

NotaNormalAumentada
  = n:("doo" / "ree" / "mii" / "faa" / "sool" / "laa" / "sii") {return {nota:(n[0]+n.slice(2)), oitava:og, tempo:2*tg};}

NotaOitavaAcima
  = n:("Do" / "Re" / "Mi"/ "Fa" / "Sol" / "La"/ "Si") {return {nota:text().toLowerCase(), oitava:og+1, tempo:tg};}

NotaOitavaAcimaAumentada
  = n:("Doo" / "Ree" / "Mii"/ "Faa" / "Sool" / "Laa"/ "Sii") {return {nota:(n[0]+n.slice(2)).toLowerCase(), oitava:og+1, tempo:2*tg};}


Inteiro "inteiro"
  = [0-9]+ { return parseInt(text(), 10); }
 
Fracao "Fração"
  = num:Inteiro "/"? den:Inteiro? {let resp = num; if(den!=null) resp/=den; return resp} 

_ "espaços brancos"
  = [ \t\n\r]*
  
