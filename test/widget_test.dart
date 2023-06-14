import 'dart:convert';
import 'package:find_shares/constants.dart';
import 'package:find_shares/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:find_shares/dto/Company.dart';

// Mock http.Client class using the Mockito library
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('fetchCompanies', () {
    test('returns a list of companies if the http call completes successfully', () async {
      final client = MockHttpClient();

      // Simulated response data
      final companies = [
        Company(
          companyname: 'Company 1',
          ticker: 'TICK1',
          price: 10.0,
          vi: 20.0,
          dy: 2.5,
          percent_more: 5.0,
          sectorname: 'Sector 1',
          segmentname: 'Segment 1',
          subsectorname: 'Subsector 1',
          tagAlong: 'Tag Along 1',
        ),
        Company(
          companyname: 'Company 2',
          ticker: 'TICK2',
          price: 15.0,
          vi: 25.0,
          dy: 3.0,
          percent_more: 7.0,
          sectorname: 'Sector 2',
          segmentname: 'Segment 2',
          subsectorname: 'Subsector 2',
          tagAlong: 'Tag Along 2',
        ),
      ];

      when(client.get(Uri.parse(fetchCompaniesUrl)))
          .thenAnswer((_) async => http.Response(json.encode(companies), 200));

      expect(await fetchCompanies(), equals(companies));
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockHttpClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(fetchCompaniesUrl)))
          .thenAnswer((_) async => http.Response('Failed to fetch companies', 500));

      expect(fetchCompanies(), throwsException);
    });
  });

  group('updateFavoriteStatus', () {
    test('updates the favorite status of a company if the http call completes successfully', () async {
      final client = MockHttpClient();
      final ticker = 'TICK1';
      final isFavorite = true;

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.post(Uri.parse(updateFavoriteUrl),
          body: {'ticker': ticker, 'favorite': isFavorite.toString()}))
          .thenAnswer((_) async => http.Response('', 200));

    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockHttpClient();
      final ticker = 'TICK1';
      final isFavorite = true;

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.post(Uri.parse(updateFavoriteUrl),
          body: {'ticker': ticker, 'favorite': isFavorite.toString()}))
          .thenAnswer((_) async => http.Response('Failed to update favorite status', 500));

      expect(updateStatus(ticker, isFavorite), throwsException);
    });
  });

  group('CompaniesBuilder', () {
    late MyApp app;
    late MockHttpClient mockHttpClient;

    setUp(() {
      app = const MyApp();
      mockHttpClient = MockHttpClient();
    });

    testWidgets('Renders app correctly', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(CompaniesBuilder), findsOneWidget);
    });

    testWidgets('Fetches and displays companies', (WidgetTester tester) async {
      final companies = [
        Company(
          companyname: 'Company 1',
          ticker: 'TICK1',
          price: 10.0,
          vi: 20.0,
          dy: 2.5,
          percent_more: 5.0,
          sectorname: 'Sector 1',
          segmentname: 'Segment 1',
          subsectorname: 'Subsector 1',
          tagAlong: 'Tag Along 1',
        ),
        Company(
          companyname: 'Company 2',
          ticker: 'TICK2',
          price: 15.0,
          vi: 25.0,
          dy: 3.0,
          percent_more: 7.0,
          sectorname: 'Sector 2',
          segmentname: 'Segment 2',
          subsectorname: 'Subsector 2',
          tagAlong: 'Tag Along 2',
        ),
      ];

      when(mockHttpClient.get(Uri.parse(fetchCompaniesUrl)))
          .thenAnswer((_) async => http.Response(json.encode(companies), 200));


      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Company 1'), findsOneWidget);
      expect(find.text('TICK1'), findsOneWidget);
      expect(find.text('R\$ 10.0'), findsOneWidget);
      expect(find.text('R\$ 20.0'), findsOneWidget);
      expect(find.text('2.5'), findsOneWidget);
      expect(find.text('5.0%'), findsOneWidget);
      expect(find.text('Sector 1'), findsOneWidget);
      expect(find.text('Segment 1'), findsOneWidget);
      expect(find.text('Subsector 1'), findsOneWidget);
      expect(find.text('Tag Along 1'), findsOneWidget);

      expect(find.text('Company 2'), findsOneWidget);
      expect(find.text('TICK2'), findsOneWidget);
      expect(find.text('R\$ 15.0'), findsOneWidget);
      expect(find.text('R\$ 25.0'), findsOneWidget);
      expect(find.text('3.0'), findsOneWidget);
      expect(find.text('7.0%'), findsOneWidget);
      expect(find.text('Sector 2'), findsOneWidget);
      expect(find.text('Segment 2'), findsOneWidget);
      expect(find.text('Subsector 2'), findsOneWidget);
      expect(find.text('Tag Along 2'), findsOneWidget);
    });

    testWidgets('Displays error message on fetch failure', (WidgetTester tester) async {
      when(mockHttpClient.get(Uri.parse(fetchCompaniesUrl)))
          .thenAnswer((_) async => http.Response('Failed to fetch companies', 500));

      http.Client client = mockHttpClient;

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Erro: Failed to fetch companies'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('Filters companies by name', (WidgetTester tester) async {
      final companies = [
        Company(
          companyname: 'Company 1',
          ticker: 'TICK1',
          price: 10.0,
          vi: 20.0,
          dy: 2.5,
          percent_more: 5.0,
          sectorname: 'Sector 1',
          segmentname: 'Segment 1',
          subsectorname: 'Subsector 1',
          tagAlong: 'Tag Along 1',
        ),
        Company(
          companyname: 'Company 2',
          ticker: 'TICK2',
          price: 15.0,
          vi: 25.0,
          dy: 3.0,
          percent_more: 7.0,
          sectorname: 'Sector 2',
          segmentname: 'Segment 2',
          subsectorname: 'Subsector 2',
          tagAlong: 'Tag Along 2',
        ),
        Company(
          companyname: 'Company 3',
          ticker: 'TICK3',
          price: 20.0,
          vi: 30.0,
          dy: 3.5,
          percent_more: 8.0,
          sectorname: 'Sector 1',
          segmentname: 'Segment 2',
          subsectorname: 'Subsector 1',
          tagAlong: 'Tag Along 2',
        ),
      ];

      when(mockHttpClient.get(Uri.parse(fetchCompaniesUrl)))
          .thenAnswer((_) async => http.Response(json.encode(companies), 200));


      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Company 1'), findsOneWidget);
      expect(find.text('Company 2'), findsOneWidget);
      expect(find.text('Company 3'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Company 1');
      await tester.pumpAndSettle();

      expect(find.text('Company 1'), findsOneWidget);
      expect(find.text('Company 2'), findsNothing);
      expect(find.text('Company 3'), findsNothing);
    });

    testWidgets('Updates favorite status on icon tap', (WidgetTester tester) async {
      final companies = [
        Company(
          companyname: 'Company 1',
          ticker: 'TICK1',
          price: 10.0,
          vi: 20.0,
          dy: 2.5,
          percent_more: 5.0,
          sectorname: 'Sector 1',
          segmentname: 'Segment 1',
          subsectorname: 'Subsector 1',
          tagAlong: 'Tag Along 1',
        ),
      ];

      when(mockHttpClient.get(Uri.parse(fetchCompaniesUrl)))
          .thenAnswer((_) async => http.Response(json.encode(companies), 200));

      when(mockHttpClient.post(Uri.parse(updateFavoriteUrl)))
          .thenAnswer((_) async => http.Response('', 200));


      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsOneWidget);

      verify(mockHttpClient.post(Uri.parse(updateFavoriteUrl),
          body: {'ticker': 'TICK1', 'favorite': 'true'})).called(1);

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      verify(mockHttpClient.post(Uri.parse(updateFavoriteUrl),
          body: {'ticker': 'TICK1', 'favorite': 'false'})).called(1);
    });
  });
}
