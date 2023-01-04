// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCalendarItemCollection on Isar {
  IsarCollection<CalendarItem> get calendarItems => this.collection();
}

const CalendarItemSchema = CollectionSchema(
  name: r'CalendarItem',
  id: -1993930713209739591,
  properties: {
    r'begin': PropertySchema(
      id: 0,
      name: r'begin',
      type: IsarType.dateTime,
    ),
    r'end': PropertySchema(
      id: 1,
      name: r'end',
      type: IsarType.dateTime,
    ),
    r'scheduleType': PropertySchema(
      id: 2,
      name: r'scheduleType',
      type: IsarType.byte,
      enumMap: _CalendarItemscheduleTypeEnumValueMap,
    ),
    r'title': PropertySchema(
      id: 3,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _calendarItemEstimateSize,
  serialize: _calendarItemSerialize,
  deserialize: _calendarItemDeserialize,
  deserializeProp: _calendarItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'begin': IndexSchema(
      id: -8718096985349195235,
      name: r'begin',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'begin',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _calendarItemGetId,
  getLinks: _calendarItemGetLinks,
  attach: _calendarItemAttach,
  version: '3.0.5',
);

int _calendarItemEstimateSize(
  CalendarItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _calendarItemSerialize(
  CalendarItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.begin);
  writer.writeDateTime(offsets[1], object.end);
  writer.writeByte(offsets[2], object.scheduleType.index);
  writer.writeString(offsets[3], object.title);
}

CalendarItem _calendarItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CalendarItem(
    scheduleType: _CalendarItemscheduleTypeValueEnumMap[
            reader.readByteOrNull(offsets[2])] ??
        ScheduleType.relative,
    title: reader.readStringOrNull(offsets[3]) ?? "",
  );
  object.begin = reader.readDateTime(offsets[0]);
  object.end = reader.readDateTime(offsets[1]);
  object.id = id;
  return object;
}

P _calendarItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (_CalendarItemscheduleTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ScheduleType.relative) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CalendarItemscheduleTypeEnumValueMap = {
  'relative': 0,
  'fixed': 1,
};
const _CalendarItemscheduleTypeValueEnumMap = {
  0: ScheduleType.relative,
  1: ScheduleType.fixed,
};

Id _calendarItemGetId(CalendarItem object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _calendarItemGetLinks(CalendarItem object) {
  return [];
}

void _calendarItemAttach(
    IsarCollection<dynamic> col, Id id, CalendarItem object) {
  object.id = id;
}

extension CalendarItemQueryWhereSort
    on QueryBuilder<CalendarItem, CalendarItem, QWhere> {
  QueryBuilder<CalendarItem, CalendarItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterWhere> anyBegin() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'begin'),
      );
    });
  }
}

extension CalendarItemQueryWhere
    on QueryBuilder<CalendarItem, CalendarItem, QWhereClause> {
  QueryBuilder<CalendarItem, CalendarItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterWhereClause> beginEqualTo(
      DateTime begin) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'begin',
        value: [begin],
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterWhereClause> beginNotEqualTo(
      DateTime begin) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'begin',
              lower: [],
              upper: [begin],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'begin',
              lower: [begin],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'begin',
              lower: [begin],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'begin',
              lower: [],
              upper: [begin],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterWhereClause> beginGreaterThan(
    DateTime begin, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'begin',
        lower: [begin],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterWhereClause> beginLessThan(
    DateTime begin, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'begin',
        lower: [],
        upper: [begin],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterWhereClause> beginBetween(
    DateTime lowerBegin,
    DateTime upperBegin, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'begin',
        lower: [lowerBegin],
        includeLower: includeLower,
        upper: [upperBegin],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CalendarItemQueryFilter
    on QueryBuilder<CalendarItem, CalendarItem, QFilterCondition> {
  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> beginEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'begin',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition>
      beginGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'begin',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> beginLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'begin',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> beginBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'begin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> endEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition>
      endGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> endLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> endBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'end',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition>
      scheduleTypeEqualTo(ScheduleType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition>
      scheduleTypeGreaterThan(
    ScheduleType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduleType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition>
      scheduleTypeLessThan(
    ScheduleType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduleType',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition>
      scheduleTypeBetween(
    ScheduleType lower,
    ScheduleType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduleType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension CalendarItemQueryObject
    on QueryBuilder<CalendarItem, CalendarItem, QFilterCondition> {}

extension CalendarItemQueryLinks
    on QueryBuilder<CalendarItem, CalendarItem, QFilterCondition> {}

extension CalendarItemQuerySortBy
    on QueryBuilder<CalendarItem, CalendarItem, QSortBy> {
  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> sortByBegin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'begin', Sort.asc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> sortByBeginDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'begin', Sort.desc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> sortByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.asc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> sortByEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.desc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> sortByScheduleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.asc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy>
      sortByScheduleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.desc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension CalendarItemQuerySortThenBy
    on QueryBuilder<CalendarItem, CalendarItem, QSortThenBy> {
  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> thenByBegin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'begin', Sort.asc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> thenByBeginDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'begin', Sort.desc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> thenByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.asc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> thenByEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.desc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> thenByScheduleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.asc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy>
      thenByScheduleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleType', Sort.desc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension CalendarItemQueryWhereDistinct
    on QueryBuilder<CalendarItem, CalendarItem, QDistinct> {
  QueryBuilder<CalendarItem, CalendarItem, QDistinct> distinctByBegin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'begin');
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QDistinct> distinctByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'end');
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QDistinct> distinctByScheduleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduleType');
    });
  }

  QueryBuilder<CalendarItem, CalendarItem, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension CalendarItemQueryProperty
    on QueryBuilder<CalendarItem, CalendarItem, QQueryProperty> {
  QueryBuilder<CalendarItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CalendarItem, DateTime, QQueryOperations> beginProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'begin');
    });
  }

  QueryBuilder<CalendarItem, DateTime, QQueryOperations> endProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'end');
    });
  }

  QueryBuilder<CalendarItem, ScheduleType, QQueryOperations>
      scheduleTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduleType');
    });
  }

  QueryBuilder<CalendarItem, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
