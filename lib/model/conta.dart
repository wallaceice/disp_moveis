abstract class Conta {
  double _Saldo = 0;
  static var _IDConta = 0;
  String _extratobancario = "";

  Conta() {
    _IDConta++;
  }

  int get id {
    return _IDConta;
  }

  set Saldo(saldo) {
    _Saldo = saldo;
  }

  double get Saldo {
    return _Saldo;
  }

  displayError(erro) {
    switch (erro) {
      case "transferencia":
        _extratobancario += "Erro na transferencia verifique ambos seu saldo e a conta destino e tente novamente.";
        break;

      case "transferencia_CcxP":
        _extratobancario += "Erro na transferencia contas poupança podem transferir apenas para outras contas poupanças gratuitamente.";
        break;

      case "limiteCc":
        _extratobancario += "Erro na transferencia, contas corrente podem transferir apenas um valor de até 900 por transferencia.";
        break;

      case "saque":
        _extratobancario += "Erro ao sacar, verifique seu saldo e tente novamente.";
        break;

      default:
        return "";
    }
  }

  void sacar(montante) {
    if (_Saldo >= montante) {
      _Saldo -= montante;
      _extratobancario = """saque bem sucedido
      Saque: $montante
      """;
    } else
      displayError("saque");
  }

  void depositar(montante) {
    _Saldo += montante;
    _extratobancario = """deposito bem sucedido
    Deposito: $montante
    """;
  }

  void transferir(montante, contadestino) {
    if (_Saldo >= montante) {
      contadestino.Saldo(montante);
      _Saldo -= montante;
      _extratobancario = """transferencia bem sucedida
      Valor: $montante , ContaDestino: $contadestino._IDConta
      """;
      try {
        contadestino.depositar(montante);
      } catch (e) {
        throw RangeError.range(contadestino, 0, _IDConta);
      }
    } else
      displayError("transferencia");
  }

  set extrato(msg) {
    _extratobancario = msg;
  }

  get extrato {
    return _extratobancario;
  }

  displayInfo();
}

class contacorrente extends Conta {
  int _LimiteTranfer = 900;

  @override
  void transferir(valor, ContaDestino) {
    if (valor > _LimiteTranfer)
      displayError("limiteCc");
    else
      super.transferir(valor, ContaDestino);
  }

  displayInfo() {
    return """
    Conta corrente
    Saldo: $_Saldo
    Transacao: $_extratobancario  
    """;
  }
}

class contapoupanca extends Conta {
  @override
  void transferir(valor, contadestino) {
    if (contadestino is! contapoupanca) {
      displayError("transferencia_CcxP");
    } else {
      super.transferir(valor, contadestino);
    }
  }

  displayInfo() {
    return """
    Conta poupança
    Saldo: $_Saldo
    Transacao: $_extratobancario  
    """;
  }
}
