TARGET = ft_turing
OBJS = src/tm.cmo
PACKAGE = yojson

all: $(TARGET)

$(TARGET) : $(OBJS)
	ocamlfind ocamlc -o $(TARGET) -package $(PACKAGE) -linkpkg -g $(OBJS)

%.cmi : %.mli
	ocamlfind ocamlc -c -package $(PACKAGE) -linkpkg -g $<

%.cmo : %.ml
	ocamlfind ocamlc -c -package $(PACKAGE) -linkpkg -g $<

clean:
	rm -rf src/*.cmi src/*.cmo

fclean: clean
	rm -rf $(TARGET)

re: fclean all

install:
	opam install ocamlfind
	opam install yojson

.PHONY: all clean fclean re format
