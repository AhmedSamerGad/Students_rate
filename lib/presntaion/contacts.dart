import 'package:flutter/material.dart';
import 'package:news_app/constant.dart';

class Conacts extends StatelessWidget {
  const Conacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Choose users',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              // i want to change it and make it like what's up
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [buildListViewItem(), buildListViewItem()],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return buildListViewItem();
                    })),
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, initGroup);
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildListViewItem() {
    return Card(
      elevation: 10,
      child: ListTile(
        title: const Text('name'),
        subtitle: const Text('0112933059'),
        leading: const Icon(Icons.person),
        trailing: Checkbox(
            value: false,
            onChanged: (value) {
              // here i want to use groub object to add values in members list
            }),
      ),
    );
  }
}
