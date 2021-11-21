import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/injection_container.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/components/components.dart';

class NumberTriviaView extends StatelessWidget {
  const NumberTriviaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NumberTrivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaLoading) {
                    return LoadingCircle();
                  } else if (state is NumberTriviaLoaded) {
                    return TriviaDisplay(
                      numberTrivia: state.trivia,
                    );
                  } else if (state is NumberTriviaError) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return MessageDisplay(
                      message: 'Start searching',
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
