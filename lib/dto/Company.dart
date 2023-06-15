import 'package:json_annotation/json_annotation.dart';
part 'Company.g.dart';

@JsonSerializable()
class Company {

    int? companyid;
    String? companyname;
    String? ticker;
    double? price;
    String? subsectorname;
    String? segmentname;
    String? sectorname;
    double? dy;
    double? vi;
    double? valormercado;
    double? percent_more;
    String? tagAlong;
    bool? favorite;

    Company({this.companyid, this.companyname, this.ticker, this.price,
      this.subsectorname, this.dy, this.segmentname, this.sectorname,
      this.vi, this.percent_more, this.tagAlong, this.favorite, this.valormercado});

    factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);


    Company toJson() => _$CompanyFromJson(this as Map<String, dynamic>);


}
