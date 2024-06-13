import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "Aplikasiku",
        theme: ThemeData(useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan)),
        home: MyHomePage(),
      ),
    );
  }
} 


class MyAppState extends ChangeNotifier {
  var current = WordPair.random(); 

  void getNext(){

    current = WordPair.random();
    notifyListeners();
  }

  

  var favorites = <WordPair>[];

  void toggleFavorite(){
    if(favorites.contains(current)){
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  var history = <WordPair>[];

  void toggleHistory(){
    history.add(current);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; 

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch(selectedIndex) {
      case 0:
      page = const GeneratorPage();
      case 1:
      page = FavoritePage();
      case 2:
      page = HistoryPage();
      default:
      page =  const Placeholder();
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        selectedIndex: selectedIndex,
        destinations: const [
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',),
        NavigationDestination(
          selectedIcon: Icon(Icons.favorite),
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Favorite',),
        NavigationDestination(
          selectedIcon: Icon(Icons.history),
          icon: Icon(Icons.history_outlined),
          label: 'History',),
          ],
          ),
      body: Container(decoration: BoxDecoration(
            //jumlah stop berbanding lurus dengan jumlah warna
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                //jumlah stop berbanding lurus dengan jumlah warna
                stops: [0.3, 0.6, 0.9],
                colors: [
                  Color.fromRGBO(12, 235, 235, 1),
                  Color.fromRGBO(32, 227, 178, 1),
                  Color.fromRGBO(41, 255, 198, 1),
                ],
              ),
            ),
        child: page,
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({
    super.key,
    
  });

  

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Look at this undefined word :", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 19, 81, 81)),),
        BigCard(pair: pair),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(onPressed: (){
              appState.toggleFavorite();
              //snackbar
              ScaffoldMessenger.of(context)
              ..hideCurrentMaterialBanner()
              ..showSnackBar(SnackBar(content: Text('Congrats, ${appState.current} she choose you'),
              ),
              );
            }, 
            icon: Icon(icon),
            label: const Text("Favorite"),
            ),
            const SizedBox(width: 25),
            ElevatedButton.icon(onPressed: () {
              appState.getNext();
              appState.toggleHistory();
              print("button pressed");
            }, 
            icon: Icon(Icons.arrow_forward),
            label: const Text("Click for Surprise"),
            ),
          ],
        ),
      ],
       ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
      final pairTextStyle = theme.textTheme.displayMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 50.0
      );


      return Card(
        child: Padding(padding: const EdgeInsets.all(10.0),
        child: Text(
          pair.asLowerCase,
          style: pairTextStyle,
        ),
        ),
      );
    }
}

class FavoritePage extends StatelessWidget{
  const FavoritePage({super.key});
  
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    return Container(
      child: ListView(
        children: [
           Text('You have ${appState.favorites.length} favorite words:',
           style: Theme.of(context).textTheme.titleLarge, 
           ),

           ...appState.favorites.map(
            (wp) => ListTile(
              title: Text(wp.asCamelCase),
            )
           )
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Container(
      child: ListView(
        children: [
           Text('You have ${appState.history.length} history:',
           style: Theme.of(context).textTheme.titleLarge,
           ),

           ...appState.history.map(
            (wp) => ListTile(
              title: Text(wp.asCamelCase),
            )
           )
        ],
      ),
    );
  }
}
