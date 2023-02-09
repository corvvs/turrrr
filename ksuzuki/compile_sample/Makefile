# NAME := fact10

# $(NAME):
# 	ocamlc -o $(NAME) fact.ml main.ml

TARGET = fact10
OBJS = fact.cmo main.cmo

all: $(TARGET)

fact10 : $(OBJS)
	ocamlc -o $(TARGET) $(OBJS)

%.cmi : %.mli
	ocamlc -c $<

%.cmo : %.ml
	ocamlc -c $<

clean:
	rm -rf *.cmi *.cmo $(TARGETS)

fclean: clean
	rm -rf $(TARGETS)

re: fclean all

.PHONY: all clean fclean re format
