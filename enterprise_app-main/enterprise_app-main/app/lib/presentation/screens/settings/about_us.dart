import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de cadenas de texto para cada punto
    final List<String> bulletPoints = [
      'Bienvenido a Callejea, tu compañero digital para buscar y encontrar los mejores locales y comercios cerca tuya.',
      'En Callejea nos dedicamos a ofrecerte la mejor experiencia posible para todo tipo de necesidades. Desde nuestro lanzamiento, nos hemos comprometido a brindar soluciones innovadoras y prácticas que simplifiquen tu vida diaria.',
      'Nuestro equipo está formado por apasionados expertos en tecnología, diseño y experiencia del usuario, dedicados a crear y mejorar constantemente nuestra aplicación para cumplir con tus necesidades y expectativas.', 
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre Nosotros'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: ListView.separated(
          itemCount: bulletPoints.length,
          itemBuilder: (context, index) => BulletText(text: bulletPoints[index]),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
        ),
      ),
    );
  }
}

class BulletText extends StatelessWidget {
  final String text;
  final Color bulletColor;
  final TextStyle? textStyle;

  const BulletText({
    super.key,
    required this.text,
    this.bulletColor = Colors.yellow, // Valor predeterminado que puede ser sobrescrito
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 10.0,
          width: 10.0,
          margin: const EdgeInsets.only(right: 12.0, top: 5.0),
          decoration: BoxDecoration(
            color: bulletColor, // Usa el color pasado como parámetro
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: textStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.0), // Usa el estilo pasado como parámetro o uno predeterminado
          ),
        ),
      ],
    );
  }
}
