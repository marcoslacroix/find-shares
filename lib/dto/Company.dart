import 'package:json_annotation/json_annotation.dart';
part 'Company.g.dart';

@JsonSerializable()
class Company {
    int? id;
    int? companyid;
    String? companyname;
    String? ticker;
    double? price;
    double? p_l;
    double? dy;
    double? p_vp;
    double? p_ebit;
    double? p_ativo;
    double? ev_ebit;
    double? margembruta;
    double? margemebit;
    double? margemliquida;
    double? p_sr;
    double? p_capitalgiro;
    double? p_ativocirculante;
    double? giroativos;
    double? roe;
    double? roa;
    double? roic;
    double? dividaliquidapatrimonioliquido;
    double? dividaLiquidaebit;
    double? pl_ativo;
    double? passivo_ativo;
    double? liquidezcorrente;
    double? peg_ratio;
    double? receitas_cagr5;
    double? lucros_cagr5;
    double? liquidezmediadiaria;
    double? vpa;
    double? lpa;
    double? valormercado;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? segmentid;
    int? sectorid;
    int? subsectorid;
    String? subsectorname;
    String? segmentname;
    String? sectorname;
    double? vi;
    double? percent_more;


    Company({this.id, this.companyid, this.companyname, this.ticker,
      this.price, this.p_l, this.dy, this.p_vp, this.p_ebit, this.p_ativo,
      this.ev_ebit, this.margembruta, this.margemebit, this.margemliquida,
      this.p_sr, this.p_capitalgiro, this.p_ativocirculante, this.giroativos,
      this.roe, this.roa, this.roic, this.peg_ratio, this.dividaliquidapatrimonioliquido,
      this.dividaLiquidaebit, this.pl_ativo, this.passivo_ativo,
      this.liquidezcorrente, this.receitas_cagr5, this.lucros_cagr5,
      this.liquidezmediadiaria, this.vpa, this.lpa, this.valormercado,
      this.createdAt, this.updatedAt, this.segmentid, this.sectorid,
      this.subsectorid, this.subsectorname, this.segmentname, this.sectorname,
      this.vi, this.percent_more});

    factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);


    Company toJson() => _$CompanyFromJson(this as Map<String, dynamic>);


}
