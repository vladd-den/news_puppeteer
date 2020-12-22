import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/src/commonWidget/customWidget.dart';
import 'package:flutter_news_app/src/models/newsResponseModel.dart';
import 'package:flutter_news_app/src/pages/homePage/bloc/bloc.dart';
import 'package:flutter_news_app/src/pages/homePage/widget/newsCard.dart';
import 'package:flutter_news_app/src/pages/newsDetail/bloc/bloc.dart';
import 'package:flutter_news_app/src/theme/theme.dart';

class VideoNewsPage extends StatelessWidget {
  Widget _headerNews(BuildContext context, Article article) {
    return InkWell(
        onTap: () {
          BlocProvider.of<DetailBloc>(context)
              .add(SelectNewsForDetail(article: article));
          Navigator.pushNamed(context, '/detail');
        },
        child: Container(
            width: MediaQuery.of(context).size.width * 6,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    customImage(article.urlToImage, fit: BoxFit.fitWidth),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 10, bottom: 20),
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(article.title,
                              style: AppTheme.h2Style.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                          Text(article.getTime(),
                              style: AppTheme.subTitleStyle.copyWith(
                                  color: Theme.of(context).disabledColor))
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: _playWidget(context),
                        ))
                  ],
                ))));
  }

  Widget _playWidget(BuildContext context) {
    return SizedBox(
        height: 25,
        child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).bottomAppBarColor),
                child: Icon(
                  Icons.play_arrow,
                  color: Theme.of(context).disabledColor,
                  size: 25,
                ))));
  }

  final cutOffYValue = 0.0;
  final yearTextStyle =
      TextStyle(fontSize: 5, color: Colors.white, fontWeight: FontWeight.bold);

  Widget _body(
    BuildContext context,
    List<Article> list, {
    String type,
  }) {
    return Column(children: [
      Container(
        width: 330,
        height: 180,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 0),
                  FlSpot(1, 1),
                  FlSpot(2, 3),
                  FlSpot(3, 3),
                  FlSpot(4, 5),
                  FlSpot(4, 4)
                ],
                isCurved: false,
                barWidth: 1,
                colors: [
                  Colors.white,
                ],
                belowBarData: BarAreaData(
                  show: true,
                  colors: [Colors.deepPurple.withOpacity(0.4)],
                  cutOffY: cutOffYValue,
                  applyCutOffY: true,
                ),
                aboveBarData: BarAreaData(
                  show: true,
                  colors: [Colors.red.withOpacity(0.6)],
                  cutOffY: cutOffYValue,
                  applyCutOffY: true,
                ),
                dotData: FlDotData(
                  show: false,
                ),
              ),
            ],
            minY: 0,
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 6,
                  textStyle: yearTextStyle,
                  getTitles: (value) {
                    switch (value.toInt()) {
                      case 0:
                        return '2015';
                      case 1:
                        return '2016';
                      case 2:
                        return '2017';
                      case 3:
                        return '2018';
                      case 4:
                        return '2019';
                      default:
                        return '';
                    }
                  }),
              leftTitles: SideTitles(
                showTitles: true,
                getTitles: (value) {
                  return '\$ ${value + 20}';
                },
              ),
            ),
            gridData: FlGridData(
              show: false,
              checkToShowHorizontalLine: (double value) {
                return value == 1 || value == 2 || value == 3 || value == 4;
              },
            ),
          ),
        ),
      ),
      Flexible(
        child: SingleChildScrollView(
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            slivers: <Widget>[
              SliverAppBar(
                centerTitle: true,
                backgroundColor: Theme.of(context).bottomAppBarColor,
                pinned: true,
              ),
              SliverToBoxAdapter(
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: PageView.builder(
                        itemBuilder: (context, index) {
                          return _headerNews(context, list[index]);
                        },
                        itemCount: 5,
                      ))),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => NewsCard(
                            artical: list[index],
                            isVideoNews: true,
                            type: type.toUpperCase(),
                          ),
                      childCount: list.length)),
            ],
          ),
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            child: BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
          if (state == null) {
            return Center(child: Text('Null block'));
          }
          if (state is Failure) {
            return Center(child: Text('Something went wrong'));
          }
          if (state is Loaded) {
            if (state.items == null || state.items.isEmpty) {
              return Text('No content avilable');
            } else {
              return _body(context, state.items, type: state.type);
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        })));
  }
}
