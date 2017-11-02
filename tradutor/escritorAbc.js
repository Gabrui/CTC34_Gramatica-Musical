function imprimir (nota) {
    var abc = {"la":"A", "si":"B", "do":"C", "re":"D", "mi":"E", "fa":"F", "sol":"G"};
    let resultado = "";
    resultado += abc[nota[0]];
    if (nota[1]) resultado += "'";
    if (nota[2] != 1)
        resultado += imprimirFracaoDe2(nota[2]);
    return resultado;
}

function imprimirFracaoDe2 (fracao) {
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

function traduzirAbc (arvoreLexical) {
    var saidaAbc = "";

    // Formata o cabeçalho
    var cabecalho = arvoreLexical[0];
    if (cabecalho.X === undefined) // ID
        cabecalho.X = "1";
    if (cabecalho.K === undefined) // O padrão é 4/4
        cabecalho.K = "4/4";
    if (cabecalho.L === undefined) // Unidades sendo mínimas
        cabecalho.L = "1/4";
    for (let chave in cabecalho)
        saidaAbc += chave + ": " + cabecalho[chave] + "\n";

    var maxDivisao = eval(cabecalho.K);  // Atenção, risco de segurança //TODO
    var valorPadrao = eval(cabecalho.L); // Atenção, risco de segurança //TODO

    var partitura = arvoreLexical[1];
    var resto = 0;
    var quantMaxBlocosNaLinha = 4;
    var quantBlocosNaLinha = 1;

    for (let i = 0; i<partitura.length; i++) {
        nota = partitura[i];
        if (nota[2] !== undefined) {
            let valor = nota[2] * valorPadrao;
            let imprimiu = false;
            resto += valor;
            while (resto >= maxDivisao) {
                imprimiu = true;
                let pular = "";
                if (quantBlocosNaLinha >= quantMaxBlocosNaLinha) {
                    pular = "\n";
                    quantBlocosNaLinha = 0;
                }
                if (resto == maxDivisao) {
                    saidaAbc += imprimir(nota) + " | " + pular;
                } else {
                    saidaAbc += " (" + imprimir([nota[0], nota[1], (maxDivisao+valor-resto)/valorPadrao]) +
                                "|"+ pular+ imprimir([nota[0], nota[1], (resto - maxDivisao)/valorPadrao]) + ") ";
                }
                quantBlocosNaLinha++;
                resto -= maxDivisao;
            }
            if (!imprimiu)
                saidaAbc += imprimir(nota)+" ";
        }
    }
    saidaAbc += "|]";
    return saidaAbc;
}