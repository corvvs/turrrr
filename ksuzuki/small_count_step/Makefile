# NAME := fact10

# $(NAME):
# 	ocamlc -o $(NAME) fact.ml main.ml

TARGET = count_step
OBJS = main.cmo

all: $(TARGET)

$(TARGET) : $(OBJS)
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
