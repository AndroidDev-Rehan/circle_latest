import 'package:flutter/material.dart';


class CarScreen extends StatelessWidget {
  const CarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(210, 247, 245,1),
      appBar: AppBar(
        title: const Text("Car Detail", style: TextStyle(color: Colors.black),),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,

                ),
                child: const Icon(Icons.arrow_back, color: Colors.black,),
              ),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back_ios_sharp),
                    Expanded(
                      child: Image(
                          image: AssetImage("assets/images/cars.png")          ),
                    ),
                    Icon(Icons.arrow_forward_ios_sharp),

                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Scarlet Pulp", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),),
                const SizedBox(height: 6,),
                Row(children: [
                  const Text("#123456"),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.currency_bitcoin),
                      Text("100", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                    ],
                  ),
                ],),
                const SizedBox(height: 40,),
                
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    row(Icons.water_drop, "SFC", "11.2"),
                    row(Icons.water_drop, "Nitro", "11.2"),
                    row(Icons.water_drop, "ODO", "11.2"),
                    row(Icons.settings, "Inspection", "11.2"),
                    row(Icons.propane_tank, "Feul Tank", "11.2"),
                    row(Icons.car_crash, "Interior", "11.2"),
                  ],
                ),

                const SizedBox(height: 40,),

                Row(
                  children: [
                    const Icon(Icons.timer),
                    const SizedBox(width: 8,),

                    const Text("2h", style: TextStyle(fontSize: 20),),
                    const SizedBox(width: 30,),
                    Expanded(
                        child: Theme(
                          data: ThemeData(
                            primarySwatch: Colors.green
                          ),
                          child: ElevatedButton(
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text("Rent", style: TextStyle(fontSize: 18),),
                            ),
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),

                              ),
                              primary: const Color.fromRGBO(86, 189, 147, 1)
                            ),
                          ),
                        ))
                  ],
                )

              ],
            ),
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }

  row(IconData icon,String title, String value ){
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: const Color.fromRGBO(121, 130, 156, 1),),
          const SizedBox(width: 4,),
          Text(title, style: const TextStyle(color: Color.fromRGBO(121, 130, 156, 1)),),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
