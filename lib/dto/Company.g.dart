// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      companyid: json['companyid'] as int?,
      companyname: json['companyname'] as String?,
      ticker: json['ticker'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      subsectorname: json['subsectorname'] as String?,
      dy: (json['dy'] as num?)?.toDouble(),
      segmentname: json['segmentname'] as String?,
      sectorname: json['sectorname'] as String?,
      vi: (json['vi'] as num?)?.toDouble(),
      percent_more: (json['percent_more'] as num?)?.toDouble(),
      tagAlong: json['tagAlong'] as String?,
      favorite: json['favorite'] as bool?,
      valormercado: (json['valormercado'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'companyid': instance.companyid,
      'companyname': instance.companyname,
      'ticker': instance.ticker,
      'price': instance.price,
      'subsectorname': instance.subsectorname,
      'segmentname': instance.segmentname,
      'sectorname': instance.sectorname,
      'dy': instance.dy,
      'vi': instance.vi,
      'valormercado': instance.valormercado,
      'percent_more': instance.percent_more,
      'tagAlong': instance.tagAlong,
      'favorite': instance.favorite,
    };
