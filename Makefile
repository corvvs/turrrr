TARGET = ft_turing
OBJS = src/tm.cmo
PACKAGE = yojson

all: $(TARGET)

$(TARGET) : $(OBJS)
	eval $$(opam env) && ocamlfind ocamlc -o $(TARGET) -package $(PACKAGE) -linkpkg -g $(OBJS)

%.cmi : %.mli
	@make install
	eval $$(opam env) && ocamlfind ocamlc -c -package $(PACKAGE) -linkpkg -g $<

%.cmo : %.ml
	@make install
	eval $$(opam env) && ocamlfind ocamlc -c -package $(PACKAGE) -linkpkg -g $<

clean:
	rm -rf src/*.cmi src/*.cmo

fclean: clean
	rm -rf $(TARGET)

re: fclean all

install:
	@opam install -y ocamlfind
	@opam install -y yojson

uninstall:
	@opam uninstall -y ocamlfind
	@opam uninstall -y yojson

.PHONY: all clean fclean re format
