/**
 * Formata a nota em ABC
 * @param {Nota} nota
 * @returns {String}
 */
function imprimir (nota) {
    var abc = {"la":"A", "si":"B", "do":"C", "re":"D", "mi":"E", "fa":"F", 
        "sol":"G", "#":"^", "##":"^^", "b":"_", "bb":"__", "pausa":"z"};
    let resultado = "";
    if (nota.acidente)
        resultado += abc[nota.acidente];
    if (!nota.especial) {
        resultado += abc[nota.nota];
        if (nota.oitava===1) 
            resultado += "'";
        if (nota.tempo !== 1)
            resultado += imprimirFracaoDe2(nota.tempo);
    } else {
        resultado += nota.nota;
    }
    return resultado;
}

/**
 * Retorna uma fração a/b
 * @param {Float} fracao
 * @returns {String}
 */
function imprimirFracaoDe2(fracao) {
    let numerador = fracao;
    let denominador = 1;
    while (Math.abs(numerador-Math.round(numerador))>0.0001) {
        numerador *= 2;
        denominador *= 2;
    }
    if (denominador === 1)
        return numerador.toString();
    return numerador.toString().split(".")[0]+"/"+denominador.toString();
}

/**
 * Retorna uma String abc correspondente à voz
 * @param {List|Notas} partitura
 * @param {Float} maxDivisao
 * @param {int} quantMaxBlocosNaLinha
 * @returns {String|imprimirVoz.impressaoVoz}
 */
function imprimirVoz(partitura, maxDivisao, quantMaxBlocosNaLinha) {
    let impressaoVoz = "";
    var tCompasso = 0;
    let quantBlocosNaLinha = 1;
    for (let i = 0; i<partitura.length; i++) {
        let nota = partitura[i];
        if (nota.tempo !== undefined) {
            let valor = nota.tempo;
            tCompasso += valor;
            if (tCompasso >= maxDivisao) {
                tCompasso -= valor;
                let lig = " ";
                let resto = valor;
                while (resto > 0) {
                    let sobrando = maxDivisao - tCompasso;
                    if (sobrando < resto) {
                        nota.tempo = sobrando;
                        tCompasso = 0;
                        resto -= sobrando;
                        lig = "-|";
                        quantBlocosNaLinha++;
                    } else if (sobrando === resto) {
                        nota.tempo = resto;
                        tCompasso = 0;
                        resto = 0;
                        lig = " | ";
                        quantBlocosNaLinha++;
                    } else {
                        nota.tempo = resto;
                        tCompasso += resto;
                        resto = 0;
                        lig = " ";
                    }
                    impressaoVoz += imprimir(nota) + lig;
                    if (quantBlocosNaLinha > quantMaxBlocosNaLinha) {
                        impressaoVoz += "\n";
                        quantBlocosNaLinha = 1;
                    }
                }
            } else {
                impressaoVoz += imprimir(nota)+" ";
            }
        } else {
            impressaoVoz += imprimir(nota)+" "; // Nota especial
        }
    }
    var diminuir = 0;
    if (impressaoVoz.endsWith("\n"))
        diminuir = 3;
    if (impressaoVoz.endsWith("| "))
        diminuir=2;
    impressaoVoz = impressaoVoz.substr(0, impressaoVoz.length - diminuir);
    impressaoVoz += "|]\n";
    return impressaoVoz;
}


function traduzirAbc (arvoreLexical) {
    var saidaAbc = "X: 1\n";

    // Formata o cabeçalho
    var cabecalho = arvoreLexical.cabecalho;
    if (cabecalho.M === undefined) // O padrão é 4/4
        cabecalho.M = "4/4";
    if (cabecalho.L === undefined) // Unidades sendo mínimas
        cabecalho.L = "1/4";
    if (cabecalho.K === undefined) // Unidades sendo mínimas
        cabecalho.K = "C";
    for (let chave in cabecalho)
        saidaAbc += chave + ": " + cabecalho[chave] + "\n";

    var maxDivisao = eval(cabecalho.M);  // Atenção, risco de segurança //TODO
    var valorPadrao = eval(cabecalho.L); // Atenção, risco de segurança //TODO

    var vozes = arvoreLexical.vozes;
    var saidaVoz = [];
    var quantMaxBlocosNaLinha = 4;
    
    for (let qVoz = 0; qVoz<vozes.length; qVoz++)
        saidaVoz[qVoz] = imprimirVoz(vozes[qVoz].notas, maxDivisao/valorPadrao, quantMaxBlocosNaLinha);
    
    if (saidaVoz.length === 1)
        return saidaAbc + saidaVoz[0];
    
    let instrumento = {null:0, "piano":0, "violino":40};
    for (let qVoz = 0; qVoz<vozes.length; qVoz++) {
        saidaAbc += "V: "+(qVoz+1)+"\n";
        saidaAbc += "%%MIDI program "+instrumento[vozes[qVoz].nomeVoz.toLowerCase()]+"\n";
        saidaAbc += saidaVoz[qVoz];
    }
    
    return saidaAbc;
}
