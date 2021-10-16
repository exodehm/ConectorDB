--
-- PostgreSQL database dump
--

-- Dumped from database version 10.15 (Ubuntu 10.15-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.15 (Ubuntu 10.15-0ubuntu0.18.04.1)

-- Started on 2021-02-19 19:27:41 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 39238)
-- Name: sdmed; Type: SCHEMA; Schema: -; Owner: sdmed
--

CREATE SCHEMA IF NOT EXISTS sdmed;


ALTER SCHEMA sdmed OWNER TO sdmed;

--
-- TOC entry 1 (class 3079 OID 13081)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3255 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 751 (class 1247 OID 39244)
-- Name: tp_certificacion; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_certificacion' AND typnamespace = 'sdmed'::regnamespace) THEN
      CREATE TYPE sdmed.tp_certificacion AS (
              fecha date,
              actual boolean
      );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_certificacion OWNER TO sdmed;

--
-- TOC entry 754 (class 1247 OID 39266)
-- Name: tp_color; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_color' AND typnamespace = 'sdmed'::regnamespace) THEN
      CREATE TYPE sdmed.tp_color AS ENUM (
          'NORMAL',
          'BLOQUEADO',
          'DESCOMPUESTO',
          'PORCENTAJE',
          'CAPITULO',
          'SUBCAPITULO'
      );
    END IF;
END
$$;


ALTER TYPE sdmed.tp_color OWNER TO sdmed;

--
-- TOC entry 738 (class 1247 OID 39281)
-- Name: tp_concepto; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_concepto' AND typnamespace = 'sdmed'::regnamespace) THEN
    CREATE TYPE sdmed.tp_concepto AS (
            codigo character varying(20),
            resumen character varying(80),
            descripcion text,
            descripcionhtml text,
            preciomed numeric(15,3),
            preciobloq numeric(15,3),
            naturaleza integer,
            fecha date,
            ud character varying(5),
            preciocert numeric(15,3)
    );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_concepto OWNER TO sdmed;

--
-- TOC entry 741 (class 1247 OID 39284)
-- Name: tp_copiarconcepto; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_copiarconcepto' AND typnamespace = 'sdmed'::regnamespace) THEN
    CREATE TYPE sdmed.tp_copiarconcepto AS (
            idcopiar integer,
            paso integer,
            c sdmed.tp_concepto
    );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_copiarconcepto OWNER TO sdmed;

--
-- TOC entry 823 (class 1247 OID 39883)
-- Name: tp_relacion; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_relacion' AND typnamespace = 'sdmed'::regnamespace) THEN
    CREATE TYPE sdmed.tp_relacion AS (
            id integer,
            codpadre character varying,
            codhijo character varying,
            canpres numeric(13,3),
            cancert numeric(13,3),
            posicion smallint,
            nivel smallint
    );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_relacion OWNER TO sdmed;

--
-- TOC entry 826 (class 1247 OID 39886)
-- Name: tp_copiarrelacion; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_copiarrelacion' AND typnamespace = 'sdmed'::regnamespace) THEN
    CREATE TYPE sdmed.tp_copiarrelacion AS (
            idcopiar integer,
            grupo integer,
            r sdmed.tp_relacion
    );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_copiarrelacion OWNER TO sdmed;

--
-- TOC entry 763 (class 1247 OID 39308)
-- Name: tp_guardarconcepto; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_guardarconcepto' AND typnamespace = 'sdmed'::regnamespace) THEN
    CREATE TYPE sdmed.tp_guardarconcepto AS (
            idguardar integer,
            paso integer,
            c sdmed.tp_concepto
    );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_guardarconcepto OWNER TO sdmed;

--
-- TOC entry 750 (class 1247 OID 39296)
-- Name: tp_medicion; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_medicion' AND typnamespace = 'sdmed'::regnamespace) THEN
    CREATE TYPE sdmed.tp_medicion AS (
            id integer,
            num_certif integer,
            tipo integer,
            comentario character varying(120),
            ud numeric,
            longitud numeric(7,3),
            anchura numeric(7,3),
            altura numeric(7,3),
            formula character varying(80),
            codpadre character varying,
            codhijo character varying,
            posicion integer
    );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_medicion OWNER TO sdmed;

--
-- TOC entry 760 (class 1247 OID 39305)
-- Name: tp_guardarmedicion; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_guardarmedicion' AND typnamespace = 'sdmed'::regnamespace) THEN
    CREATE TYPE sdmed.tp_guardarmedicion AS (
            idguardar integer,
            paso integer,
            m sdmed.tp_medicion
            );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_guardarmedicion OWNER TO sdmed;

--
-- TOC entry 829 (class 1247 OID 39889)
-- Name: tp_guardarrelacion; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_guardarrelacion' AND typnamespace = 'sdmed'::regnamespace) THEN
    CREATE TYPE sdmed.tp_guardarrelacion AS (
            idguardar integer,
            paso integer,
            r sdmed.tp_relacion
    );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_guardarrelacion OWNER TO sdmed;

--
-- TOC entry 757 (class 1247 OID 39299)
-- Name: tp_lineamedicion; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_lineamedicion' AND typnamespace = 'sdmed'::regnamespace) THEN
    CREATE TYPE sdmed.tp_lineamedicion AS (
            fase integer,
            comentario character varying,
            ud numeric,
            longitud numeric,
            anchura numeric,
            altura numeric,
            formula character varying,
            parcial numeric,
            subtotal numeric,
            id integer,
            pos integer
    );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_lineamedicion OWNER TO sdmed;

--
-- TOC entry 747 (class 1247 OID 39293)
-- Name: tp_partida; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_partida' AND typnamespace = 'sdmed'::regnamespace) THEN
    CREATE TYPE sdmed.tp_partida AS (
            codigopadre character varying,
            codigohijo character varying,
            pos smallint,
            ud character varying,
            resumen character varying,
            descripcion text,
            precio numeric,
            cantidad numeric,
            nat integer,
            fec character varying
    );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_partida OWNER TO sdmed;

--
-- TOC entry 744 (class 1247 OID 39290)
-- Name: tp_propiedades; Type: TYPE; Schema: sdmed; Owner: sdmed
--

DO $$
BEGIN
    IF NOT EXISTS (SELECT true FROM pg_type WHERE typname = 'tp_propiedades' AND typnamespace = 'sdmed'::regnamespace) THEN
    CREATE TYPE sdmed.tp_propiedades AS (
            id smallint,
            familia character varying,
            propiedades jsonb
    );
    END IF;
END
$$;

ALTER TYPE sdmed.tp_propiedades OWNER TO sdmed;

--
-- TOC entry 244 (class 1255 OID 39313)
-- Name: actualizar_certificacion_actual(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.actualizar_certificacion_actual(_nombretabla character varying, _fecha character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
tabla_listado_certificaciones character varying := _nombretabla || '_ListadoCertificaciones';
BEGIN
EXECUTE FORMAT ('UPDATE %I SET actual = ''false''',tabla_listado_certificaciones);
EXECUTE FORMAT ('UPDATE %I SET actual = ''true'' WHERE fecha::character varying = $1',tabla_listado_certificaciones) USING _fecha;
END;
$_$;


ALTER FUNCTION sdmed.actualizar_certificacion_actual(_nombretabla character varying, _fecha character varying) OWNER TO sdmed;

--
-- TOC entry 341 (class 1255 OID 39314)
-- Name: actualizar_desde_nodo(character varying, character varying, integer, double precision); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.actualizar_desde_nodo(_nombretabla character varying, _codigonodo character varying, _num_cert integer DEFAULT 0, _coste_indirecto double precision DEFAULT NULL::double precision) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    nuevo_precio numeric := 0;
    var_r record;
    existe boolean;
    bloqueado numeric(7,3);
    tablaconceptos character varying := _nombretabla || '_Conceptos';
    tablarelacion character varying := _nombretabla || '_Relacion';
    tablapropiedades character varying := _nombretabla || '_Propiedades';
    str_null_case character varying;
    columnacantidad character varying;
    columnaprecio character varying;
    CI float;    
    cadenaimporte character varying;
    nivel smallint;
    texto text;
    naturaleza smallint;
BEGIN
  RAISE INFO 'aCTUALIZO EL NODO: %', _codigonodo;
--PRIMER PASO, DEFINIR SI MODIFICO LAS COLUMNAS preciomed/canpres o preciocert/cancert
IF _num_cert = 0 THEN
    columnaprecio := 'preciomed';
    columnacantidad := 'canpres';
ELSE
    columnaprecio := 'preciocert';
    columnacantidad := 'cancert';
END IF;
--definimos la cadena del codigo padre, por si es nula
IF (_codigonodo = '') IS NOT FALSE THEN
	str_null_case := ' IS NULL';
ELSE
	str_null_case := ' = '||quote_literal(_codigonodo);
END IF;
--establezco el coste indirecto. Si el parametro es nulo, entonces busco el que haya en la base de datos (propiedad de la obra) y si no, uso el parametro
IF _coste_indirecto IS NULL THEN
	EXECUTE FORMAT ('SELECT propiedades->>''Valor'' FROM %I WHERE propiedades->>''Propiedad'' = ''Costes indirectos''',tablapropiedades) INTO CI;
ELSE
	CI = _coste_indirecto;
END IF;
--por ultimo veo la naturaleza del codigo a acutalizar. Si es capitulo multiplicare por los costes indirectos
EXECUTE FORMAT ('SELECT naturaleza FROM %I WHERE codigo = $1',tablaconceptos) INTO naturaleza USING  _codigonodo;
--primera comprobacion, que sea un precio bloqueado
EXECUTE FORMAT ('SELECT preciobloq FROM %I WHERE codigo %s',tablaconceptos,str_null_case) INTO bloqueado;
IF (bloqueado IS NOT NULL) THEN 
    nuevo_precio = bloqueado;
ELSE
    EXECUTE FORMAT ('SELECT EXISTS (SELECT codpadre FROM %I WHERE codpadre %s)',tablarelacion,str_null_case) INTO existe;
    IF existe = FALSE--si no hay hijos de este nodo
        THEN
            EXECUTE FORMAT ('SELECT %s FROM %I WHERE codigo %s',columnaprecio,tablaconceptos,str_null_case) INTO nuevo_precio;		
        ELSE
            FOR var_r IN EXECUTE FORMAT ('SELECT C.codigo, C.naturaleza, C.preciomed, R.canpres, R.cancert FROM %I AS C,%I AS R WHERE R.codpadre %s AND R.codhijo = C.codigo', 
		tablaconceptos,tablarelacion, str_null_case) LOOP		
			IF naturaleza = 6 AND var_r.naturaleza != 6 THEN
				nuevo_precio = nuevo_precio + (var_r.preciomed*var_r.canpres) * (CI+100)/100;
			ELSE
				nuevo_precio = nuevo_precio + (var_r.preciomed*var_r.canpres);
				--RAISE NOTICE ' nuevo precio %',nuevo_precio;						
			END IF;		
		END LOOP;
    END IF;
END IF;
IF nuevo_precio IS NULL THEN nuevo_precio = 0; END IF;
EXECUTE FORMAT ('UPDATE %I SET %s = %L WHERE codigo %s', tablaconceptos, columnaprecio, nuevo_precio, str_null_case);
--RAISE NOTICE 'El valor del nodo es: %', nuevo_precio;
EXECUTE FORMAT ('SELECT EXISTS (SELECT codhijo FROM %I WHERE codhijo %s)', tablarelacion, str_null_case) INTO existe;
IF existe = TRUE THEN
	FOR var_r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codhijo %s', tablarelacion, str_null_case)
	LOOP
		--RAISE NOTICE 'Hay que seguir para arriba con: %,%',r.codpadre,r.codhijo;
		EXECUTE FORMAT ('SELECT actualizar_desde_nodo(%s,%s,%s,%s)', quote_literal(_nombretabla), 
		CASE WHEN var_r.codpadre IS NULL THEN 'NULL' ELSE quote_literal(var_r.codpadre) END,
		_num_cert,
		CI);
	END LOOP;
END IF;
END;
$_$;


ALTER FUNCTION sdmed.actualizar_desde_nodo(_nombretabla character varying, _codigonodo character varying, _num_cert integer, _coste_indirecto double precision) OWNER TO sdmed;

--
-- TOC entry 260 (class 1255 OID 39315)
-- Name: ajustar(character varying, double precision); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ajustar(_nombretabla character varying, _nuevo_valor double precision) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablarelacion character varying := _nombretabla || '_Relacion';
tablaconceptos character varying := _nombretabla || '_Conceptos';
codigo character varying;
precio_inicial float;
coeficiente float;
BEGIN
--primer paso, hallar el importe total de la obra
EXECUTE FORMAT ('SELECT preciomed FROM %I WHERE codigo = $1',tablaconceptos) USING _nombretabla INTO precio_inicial;
RAISE INFO '%', precio_inicial;
coeficiente = _nuevo_valor/precio_inicial;
RAISE INFO '%', coeficiente;
FOR codigo IN EXECUTE FORMAT(' SELECT DISTINCT codhijo from %I WHERE codhijo NOT IN (SELECT DISTINCT codpadre FROM %I WHERE codpadre IS NOT NULL)',tablarelacion,tablarelacion) LOOP
	EXECUTE FORMAT ('UPDATE %I SET preciomed = preciomed * %s WHERE codigo = $1',tablaconceptos,coeficiente) USING codigo;
	PERFORM actualizar_desde_nodo(_nombretabla,codigo);
END LOOP;
END;
$_$;


ALTER FUNCTION sdmed.ajustar(_nombretabla character varying, _nuevo_valor double precision) OWNER TO sdmed;

--
-- TOC entry 257 (class 1255 OID 39316)
-- Name: anadir_certificacion(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.anadir_certificacion(_nombretabla character varying, _fecha character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tabla_listado_certificaciones character varying := _nombretabla || '_ListadoCertificaciones';
fecha date := procesar_cadena_fecha(_fecha);
resultado boolean := false;
actual boolean := true;
existe boolean;
ultima_fecha date;

BEGIN
--PRIMERO CREO LA TABLA DE CERTIFICACIONES Y LA SECUENCIA, SI NO ESTA YA CREADA
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tabla_listado_certificaciones) INTO existe;
IF existe IS FALSE THEN
	EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I of tp_certificacion (PRIMARY KEY (fecha))',tabla_listado_certificaciones);	
END IF;
--AHORA INSERTO LA NUEVA CERTIFICACION. LA FUNCION COMPRUEBA QUE LA FECHA SEA MAYOR A LA ULTIMA INGRESADA.SI NO LO ES, NO HACE NADA Y RETORNA FALSE
EXECUTE FORMAT ('SELECT MAX(fecha) FROM %I',tabla_listado_certificaciones) INTO ultima_fecha;
IF ultima_fecha IS NULL OR fecha > ultima_fecha THEN
	EXECUTE FORMAT ('INSERT INTO %I (fecha, actual) VALUES ($1,$2)',tabla_listado_certificaciones) USING fecha, actual;
	--pongo el resto de certificaciones a false el dato de actual
	EXECUTE FORMAT ('UPDATE %I SET actual = ''false'' WHERE fecha <>$1',tabla_listado_certificaciones) USING fecha;
	resultado = true;
END IF;
return resultado;
END;
$_$;


ALTER FUNCTION sdmed.anadir_certificacion(_nombretabla character varying, _fecha character varying) OWNER TO sdmed;

--
-- TOC entry 258 (class 1255 OID 39317)
-- Name: anadir_obra_a_listado(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.anadir_obra_a_listado(codigo character varying, resumen character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
noexiste boolean;
BEGIN
EXECUTE format (
		'CREATE TABLE IF NOT EXISTS listaobras
		(id serial NOT NULL,
		codigo character varying(20),
		resumen character varying(50),
		CONSTRAINT "listado_pkey" PRIMARY KEY (id));'
		);
EXECUTE FORMAT ('SELECT NOT EXISTS (SELECT codigo FROM listaobras WHERE codigo = %s)', quote_literal(codigo)) INTO noexiste;
IF noexiste = TRUE THEN

EXECUTE format ('INSERT INTO %I(codigo,resumen) VALUES
		(%s,%s)',
		'listaobras',quote_literal(codigo),quote_literal(resumen));

RETURN 0;
END IF;
RETURN -1;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -1;
END;
$$;


ALTER FUNCTION sdmed.anadir_obra_a_listado(codigo character varying, resumen character varying) OWNER TO sdmed;

--
-- TOC entry 259 (class 1255 OID 39318)
-- Name: bloquear_precio(character varying, character varying, numeric, boolean); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.bloquear_precio(_nombretabla character varying, _codigo character varying, _precio numeric, _bloquear boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablaconceptos character varying := _nombretabla || '_Conceptos';
BEGIN
IF _bloquear = TRUE THEN	
    EXECUTE FORMAT ('UPDATE %I SET preciobloq = $1 WHERE codigo= $2',tablaconceptos) USING _precio, _codigo;
ELSE
    EXECUTE FORMAT ('UPDATE %I SET preciobloq = NULL WHERE codigo= $1',tablaconceptos) USING _codigo;
END IF;
END;
$_$;


ALTER FUNCTION sdmed.bloquear_precio(_nombretabla character varying, _codigo character varying, _precio numeric, _bloquear boolean) OWNER TO sdmed;

--
-- TOC entry 261 (class 1255 OID 39319)
-- Name: borrar_certificacion(character varying, date); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.borrar_certificacion(_nombretabla character varying, _fecha date) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
tabla_mediciones character varying := _nombretabla || '_Mediciones';
tabla_listado_certificaciones character varying := _nombretabla || '_ListadoCertificaciones';
num_cert integer;
BEGIN
--obtengo el num de certificacion con la fecha dada
	EXECUTE FORMAT ('SELECT num_cert FROM (SELECT *, count(*) OVER (ORDER BY fecha ) AS num_cert 
		FROM %I) AS tabla WHERE fecha = $1',tabla_listado_certificaciones) USING _fecha INTO num_cert;
--borro de la tabla de mediciones las filas con ese numero de certificacion
	EXECUTE FORMAT ('DELETE FROM %I WHERE num_certif = $1',tabla_mediciones) USING num_cert;
--modifico los numeros de certificacion de las que tengan un numero superior
	EXECUTE FORMAT ('UPDATE %I SET num_certif = num_certif-1 WHERE num_certif > $1',tabla_mediciones) USING num_cert;
--por ultimo borro la certificacion de la tabla de listado de certificaciones
	EXECUTE FORMAT ('DELETE FROM %I WHERE fecha = $1',tabla_listado_certificaciones) USING _fecha;
RETURN num_cert;	
END;
$_$;


ALTER FUNCTION sdmed.borrar_certificacion(_nombretabla character varying, _fecha date) OWNER TO sdmed;

--
-- TOC entry 265 (class 1255 OID 39320)
-- Name: borrar_hijos(character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.borrar_hijos(_nombretabla character varying, _codigopadre character varying, _codigohijos character varying DEFAULT NULL::character varying, _guardar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
--la funcion borrar los hijos de un nodo y lo que hay debajo de ellos y los guarda en una tabla para su posterior restauracion
--si se deshace la accion. Tambien se definira el tipo de accion que -pegado o borrado- para tenerlo en cuenta a la hora
-- de sacarlo de la tabla
num_paso integer;
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';

tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';
tablaguardarcertificacion character varying := _nombretabla || '_GuardarCertificaciones';
arraycodigoshijos character varying[];

r tp_relacion%ROWTYPE;
rg tp_guardarrelacion%ROWTYPE;
c tp_concepto%ROWTYPE;
cg tp_guardarconcepto%ROWTYPE;
existe boolean;
BEGIN
IF _codigohijos IS NULL THEN --SI NO HAY ARRAY DE CODIGOS HIJO BORRO TODOS LOS QUE PENDEN DEL PADRE
	EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = $1', tablarelacion) INTO arraycodigoshijos USING _codigopadre;
ELSE --SI HAY CADENA DE ARRAY DE CODIGOS, LOS METO EN EL ARRAY DE LA FUNCION
	arraycodigoshijos = string_to_array(_codigohijos,',');
	raise notice 'el array a borrar es: %',arraycodigoshijos;
END IF;
--FINALMENTE EJECUTO LA FUNCION
PERFORM borrar_lineas_principal(_nombretabla,_codigopadre,arraycodigoshijos,_guardar);
--ACTUALIZO LOS NUMEROS DE PASO DE LAS TABLAS SI GUARDAR ES TRUE
IF _guardar IS TRUE THEN
	num_paso = (SELECT ultimo_paso(_nombretabla)) + 1;
	--para la tabla de guardar relacion no hago comprobacion previa porque siempre va a haber en el momento de borrar...se puede añadir esa comprobacion
	EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarrelacion,num_paso);
	--actualizar tabla guardar conceptos
	EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablaguardarconceptos) INTO existe;
	IF existe IS TRUE THEN
		EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarconceptos,num_paso);
	END IF;
	--actualizar tabla guardar medicion
	EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablaguardarmedicion) INTO existe;
	IF existe IS TRUE THEN
		EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarmedicion,num_paso);
	END IF;
	--actualizar tabla guardar certificacion
	EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablaguardarcertificacion) INTO existe;
	IF existe IS TRUE THEN
		EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarcertificacion,num_paso);
	END IF;
END IF;
--Por ultimo actualizamos las cantidades
PERFORM actualizar_desde_nodo(_nombretabla,_codigopadre);
END;
$_$;


ALTER FUNCTION sdmed.borrar_hijos(_nombretabla character varying, _codigopadre character varying, _codigohijos character varying, _guardar boolean) OWNER TO sdmed;

--
-- TOC entry 262 (class 1255 OID 39322)
-- Name: borrar_lineas_medcert(character varying, integer[], integer, boolean, boolean); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.borrar_lineas_medcert(_nombretabla character varying, _ids integer[], _num_cert integer DEFAULT NULL::integer, _guardar boolean DEFAULT true, _solomedicion boolean DEFAULT false) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
    tamanno integer := array_length(_ids, 1);    
    tablamedcert character varying := _nombretabla || '_Mediciones';
    tablaguardarmedcert character varying := _nombretabla || '_GuardarMediciones';
    codigopadre character varying;
    codigohijo character varying;
    m tp_medicion%ROWTYPE;
    num_paso integer := NULL;
    existe boolean;
    pos integer := 0;
--SI LA FUNCION ES LLAMADA DESDE LA FUNCION borrar_lineas_principal, SERA ESTA LA QUE PONGA EL num_paso, PERO SI SE LLAMA
--DE FORMA DIRECTA SE PONDRA DESDE LA PROPIA FUNCION
BEGIN
raise notice 'array de hijos a borrar: % ',_ids;
--AHORA CREO LA TABLA DE GUARDAR
IF _guardar IS TRUE THEN
	EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_guardarmedicion (PRIMARY KEY (idguardar))',tablaguardarmedcert);
END IF;
--SOLO EJECUTO SI HAY ARRAY DE LINEAS DE MEDICION
IF tamanno IS NOT NULL THEN
	EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE id = %L',tablamedcert,_ids[1]) INTO codigopadre;
	EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE id = %L',tablamedcert,_ids[1]) INTO codigohijo;
	
	FOR i IN 1..tamanno LOOP
		IF _guardar IS TRUE THEN  --solo guardare en la tabla de guardar medicion si guardar es true
			EXECUTE FORMAT ('SELECT * FROM %I WHERE %I.id = %L',tablamedcert,tablamedcert, _ids[i]) INTO m;
			PERFORM insertar_registro_guardarmedicion(tablaguardarmedcert,NULL,m);
		END IF;
		EXECUTE FORMAT ('DELETE FROM %I WHERE %I.id = %L',tablamedcert,tablamedcert,_ids[i]);
	END LOOP;
	--reorganizamos las posiciones (solo si borro en una tabla concreta)
	IF _num_cert IS NOT NULL THEN
		FOR m IN EXECUTE FORMAT('SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3 ORDER BY posicion',tablamedcert) USING codigopadre,codigohijo,_num_cert
		LOOP
			EXECUTE FORMAT ('UPDATE %I SET posicion = $1 WHERE id = $2', tablamedcert)
			USING pos, m.id;
			pos = pos +1;
		END LOOP;
	END IF;
	--ponemos el numero de paso solo si es borrado directo de medicion. Si las mediciones se borran porque se han borrado partidas esta parte no se ejecuta
	--y el numero de paso lo pone la funcion que borra la partida
	IF _solomedicion IS TRUE THEN
		num_paso = (SELECT ultimo_paso(_nombretabla));		
		EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarmedcert,num_paso+1);--aumento el num_paso una unidad
	END IF;
	--por ultimo recalculamos las cantidades
	PERFORM modificar_cantidad(_nombretabla,codigopadre,codigohijo,_num_cert);
END IF;    
   END;
$_$;


ALTER FUNCTION sdmed.borrar_lineas_medcert(_nombretabla character varying, _ids integer[], _num_cert integer, _guardar boolean, _solomedicion boolean) OWNER TO sdmed;

--
-- TOC entry 266 (class 1255 OID 39321)
-- Name: borrar_lineas_medcert(character varying, character varying, character varying, integer, integer[], boolean, boolean); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.borrar_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _posiciones integer[] DEFAULT NULL::integer[], _guardar boolean DEFAULT true, _solomedicion boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $_$
--EL OBJETIVO DE LA FUNCION ES CREAR UN ARRAY DE id CON LA TABLA,CODIGOPADRE,CODIGOHIJO,NUM DE CERTIF Y POSICIONES SELECCIONADAS
--SI NO HAY POSICIONES SELECCIONADAS, SE INCLUYEN TODAS LAS LINEAS DE MEDICION CON ESE CODPADRE,CODHIJO Y NURMCERT
DECLARE
    tablamedcert character varying := _nombretabla || '_Mediciones';
    ids integer[];
    id integer;
    m tp_medicion%rowtype;
    pos integer;
BEGIN
IF _posiciones IS NULL THEN
	FOR m in EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3',tablamedcert)	
	USING _codigopadre,_codigohijo,_num_cert
	LOOP
		_posiciones:= array_append(_posiciones,m.posicion);
	END LOOP;
END IF;
--AÑADO id AL ARRAY
FOR I IN array_lower(_posiciones, 1)..array_upper(_posiciones, 1)
LOOP
	EXECUTE FORMAT ('SELECT id FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3 AND posicion = $4', tablamedcert)
		USING _codigopadre,_codigohijo,_num_cert,_posiciones[I] INTO id;
	ids:= array_append(ids,id);	
END LOOP;
--LUEGO LLAMO A LA FUNCION
PERFORM borrar_lineas_medcert(_nombretabla,ids,_num_cert,_guardar,_solomedicion);
   END;
$_$;


ALTER FUNCTION sdmed.borrar_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _posiciones integer[], _guardar boolean, _solomedicion boolean) OWNER TO sdmed;

--
-- TOC entry 263 (class 1255 OID 39323)
-- Name: borrar_lineas_principal(character varying, character varying, character varying[], boolean); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.borrar_lineas_principal(_nombretabla character varying, _codigopadre character varying, _codigoshijo character varying[], _guardar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablamediciones character varying := _nombretabla || '_Mediciones';
tablarelacion character varying := _nombretabla || '_Relacion';
tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';
existe boolean;
posicion integer;
r tp_relacion%ROWTYPE;
c tp_concepto%ROWTYPE;
idmediciones integer[];
arraycodigoshijos character varying[];
indice integer;
solomedicion boolean := false; --false porque la llamo desde la funcion
num_cert integer := NULL;
insertar boolean := false;--esta variable controla si se va a insertar o a borrar la linea. En este caso se borra y se usa en la funcion de ordenar_posiciones
BEGIN
--CREO LA TABLA DE RELACIONES BORRAR SI RESTAURAR ES TRUE Y NO EXISTE PREVIEMENTE
IF _guardar IS TRUE THEN
	EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_guardarrelacion (PRIMARY KEY (idguardar))',tablaguardarrelacion);
END IF;
--EMPIEZO A EJECUTAR
IF _codigoshijo IS NOT NULL THEN	
	--ITERO SOBRE EL ARRAY DE CODIGOS HIJO
	FOR I IN array_lower(_codigoshijo, 1)..array_upper(_codigoshijo, 1) LOOP
		--METO LA RELACION PADRE HIJO EN LA TABLA DE RELACION EN UN REGISTRO SI RESTAURAR ES TRUE
		IF _guardar IS TRUE THEN
			EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 ORDER BY posicion', tablarelacion) INTO r USING _codigopadre, _codigoshijo[I];
			--METO ESE REGISTRO EN LA TABLA DE RELACION BORRAR			
			PERFORM insertar_registro_guardarrelacion(tablaguardarrelacion,NULL,r);
		END IF;
		--GUARDO LA POSICION DE LA RELACION A BORRAR PARA LA POSTERIOR REORDENACION DE LAS POSICIONES LOS HIJOS RESTANTES
		--EXECUTE FORMAT ('SELECT posicion FROM %I where codpadre = $1 AND codhijo = $2',tablarelacion) USING _codigopadre,_codigoshijo[I] INTO posicion;
		--LO PRIMERO SERA REORDENAR LAS POSICIONES DE LOS REGISTROS DE LA TABLA RELACION POSTERIORES AL REGISTRO QUE VA A SER BORRADO
		PERFORM ordenar_posiciones(_nombretabla, _codigopadre,_codigoshijo[I],insertar);
		--BORRO LA RELACION PADRE-HIJO EN LA TABLA ORIGINAL
		EXECUTE FORMAT ('DELETE FROM %I WHERE codpadre = $1 AND codhijo = $2', tablarelacion) USING _codigopadre,_codigoshijo[I];
		--VEO SI QUEDAN MAS HIJOS EN LA TABLA RELACION
		EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codhijo = $1 )',	tablarelacion) INTO existe USING _codigoshijo[I];
		--SI NO QUEDAN MAS HIJOS:
		IF existe = FALSE THEN
		   --CREO LA TABLA DE CONCEPTOS BORRAR Y METO EL CONCEPTO Y LO BORRO DE LA TABLA DE CONCEPTOS SI restaurar ES TRUE
			IF _guardar IS TRUE THEN
				EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_guardarconcepto (PRIMARY KEY (idguardar))',tablaguardarconceptos);			
				EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = $1',tablaconceptos) INTO c USING _codigoshijo[I];
				PERFORM insertar_registro_guardarconcepto(tablaguardarconceptos,NULL,c);				
			END IF;
			--BORRO DE LA TABLA DE CONCEPTOS LOS HIJOS QUE CORRESPONDAN
			EXECUTE FORMAT ('DELETE FROM %I WHERE codigo = $1', tablaconceptos) USING _codigoshijo[I];
			--METO LOS HIJOS EN UN ARRAY Y LLAMO DE NUEVO A LA FUNCION
			EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = $1',	tablarelacion) INTO arraycodigoshijos USING _codigoshijo[I];
				PERFORM borrar_lineas_principal(_nombretabla,_codigoshijo[I],arraycodigoshijos,_guardar);			
		END IF;
		--AHORA LAS MEDICIONES
		EXECUTE FORMAT('SELECT array_agg(id) from %I WHERE codpadre = $1 AND codhijo = $2', tablamediciones) INTO idmediciones USING _codigopadre,_codigoshijo[I];
		IF idmediciones IS NOT NULL THEN
		    PERFORM borrar_lineas_medcert(_nombretabla,idmediciones,num_cert,_guardar,solomedicion);
		END IF;		
		--queda la ordenacion de los elementos restantes		
		/*FOR r IN EXECUTE FORMAT('SELECT * FROM %I WHERE codpadre = $1 AND posicion >$2',tablarelacion) USING _codigopadre, posicion			
		LOOP
			EXECUTE FORMAT ('UPDATE %I SET posicion = posicion-1 WHERE codpadre = $1 AND codhijo = $2', tablarelacion) USING r.codpadre, r.codhijo;
		END LOOP;*/
	END LOOP;
END IF;
END;
$_$;


ALTER FUNCTION sdmed.borrar_lineas_principal(_nombretabla character varying, _codigopadre character varying, _codigoshijo character varying[], _guardar boolean) OWNER TO sdmed;

--
-- TOC entry 264 (class 1255 OID 39325)
-- Name: borrar_obra(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.borrar_obra(_nombretabla character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
--tablas
tabla_conceptos character varying := _nombretabla || '_Conceptos';
tabla_relacion character varying  := _nombretabla || '_Relacion';
tabla_mediciones character varying := _nombretabla || '_Mediciones';
tabla_propiedades character varying := _nombretabla || '_Propiedades';
tabla_guardar_conceptos character varying := _nombretabla || '_GuardarConceptos';
tabla_guardar_relaciones character varying := _nombretabla || '_GuardarRelaciones';
tabla_guardar_mediciones character varying := _nombretabla || '_GuardarMediciones';
tabla_listado_certificaciones character varying := _nombretabla || '_ListadoCertificaciones';
--secuencias
secuencia_relacion character varying := tabla_relacion || '_id_seq';
secuencia_mediciones character varying := tabla_mediciones || '_id_seq';
secuencia_propiedades character varying := tabla_propiedades || '_id_seq';
secuencia_listado_certificaciones character varying := tabla_listado_certificaciones || '_id_seq';
BEGIN
--borrar tablas
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_conceptos);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_mediciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_relacion);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_propiedades);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_conceptos);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_relaciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_mediciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_listado_certificaciones);
--borrar secuencias
EXECUTE FORMAT ('DROP SEQUENCE IF EXISTS %I',secuencia_relacion);
EXECUTE FORMAT ('DROP SEQUENCE IF EXISTS %I',secuencia_mediciones);
EXECUTE FORMAT ('DROP SEQUENCE IF EXISTS %I',secuencia_propiedades);
EXECUTE FORMAT ('DROP SEQUENCE IF EXISTS %I',secuencia_listado_certificaciones);
END;
$$;


ALTER FUNCTION sdmed.borrar_obra(_nombretabla character varying) OWNER TO sdmed;

--
-- TOC entry 269 (class 1255 OID 39326)
-- Name: borrar_relacion(character varying, integer, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.borrar_relacion(nombretabla character varying, idpadre integer, idhijo integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  r record;
  pos integer;
  tablarelacion character varying;
  str_null_case character varying;
BEGIN
IF idpadre IS NULL THEN
	str_null_case := ' IS NULL';
ELSE
	str_null_case := ' = '||idpadre;
END IF;
tablarelacion = nombretabla || '_Relacion';
RAISE NOTICE 'Funcion borrar_relacion(%,%,%)',nombretabla,idpadre,idhijo;
EXECUTE FORMAT ('SELECT posicion FROM %I WHERE id_padre %s AND id_hijo = %s',tablarelacion,str_null_case,idhijo) INTO pos;
--pos = (SELECT posicion FROM relacion WHERE id_padre = idpadre AND id_hijo = idhijo);
RAISE NOTICE 'borrar_relacion con % - % en la posicion: %', str_null_case, idhijo, pos;
EXECUTE FORMAT ('DELETE FROM %I WHERE id_padre %s AND id_hijo = %s',tablarelacion,str_null_case,idhijo);
--DELETE FROM relacion WHERE id_padre = idpadre AND id_hijo = idhijo;
--ahora ordeno los hijos
FOR r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE id_padre %s', tablarelacion, str_null_case)
--FOR r IN SELECT * FROM relacion WHERE id_padre = idpadre
	LOOP
	 IF(r.posicion>=pos AND r.id_hijo<>idhijo) THEN
	 	EXECUTE FORMAT ('UPDATE %I SET posicion = %I.posicion-1 WHERE id_hijo = %s',
			tablarelacion, tablarelacion, quote_literal(r.id_hijo));
		RAISE NOTICE 'Ordenar los hijos % que esten despues de la posicion %',r.id_hijo,pos;
	 	
	 END IF;
	END LOOP;
END;
$$;


ALTER FUNCTION sdmed.borrar_relacion(nombretabla character varying, idpadre integer, idhijo integer) OWNER TO sdmed;

--
-- TOC entry 270 (class 1255 OID 39327)
-- Name: cambiar_codigo_obra(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.cambiar_codigo_obra(_nombretabla character varying, _codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
--tablas
resultado integer := 0;
existe boolean := false;
tabla_conceptos character varying := _codigo || '_Conceptos';
BEGIN
--lo primero es ver si ya existe una tabla con el nombre al que deseamos cambiar esta
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tabla_conceptos) INTO existe;
RAISE INFO '%',FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tabla_conceptos);
IF existe IS TRUE THEN
	RETURN -1;
END IF;
--si no existe cambio los nombres
EXECUTE FORMAT ('ALTER TABLE IF EXISTS %I RENAME TO %s',_nombretabla|| '_Conceptos', quote_ident(_codigo || '_Conceptos'));
EXECUTE FORMAT ('ALTER TABLE IF EXISTS %I RENAME TO %s',_nombretabla|| '_Relacion', quote_ident(_codigo || '_Relacion'));
EXECUTE FORMAT ('ALTER TABLE IF EXISTS %I RENAME TO %s',_nombretabla|| '_Mediciones', quote_ident(_codigo || '_Mediciones'));
EXECUTE FORMAT ('ALTER TABLE IF EXISTS %I RENAME TO %s',_nombretabla|| '_Propiedades', quote_ident(_codigo || '_Propiedades'));
EXECUTE FORMAT ('ALTER TABLE IF EXISTS %I RENAME TO %s',_nombretabla|| '_GuardarConceptos', quote_ident(_codigo || '_GuardarConceptos'));
EXECUTE FORMAT ('ALTER TABLE IF EXISTS %I RENAME TO %s',_nombretabla|| '_GuardarRelaciones', quote_ident(_codigo || '_GuardarRelaciones'));
EXECUTE FORMAT ('ALTER SEQUENCE IF EXISTS %s RENAME TO %s', quote_ident(_nombretabla||'_Relacion_id_seq'),quote_ident(_codigo||'_Relacion_id_seq'));
EXECUTE FORMAT ('ALTER SEQUENCE IF EXISTS %s RENAME TO %s', quote_ident(_nombretabla||'_Mediciones_id_seq'),quote_ident(_codigo||'_Mediciones_id_seq'));
EXECUTE FORMAT ('ALTER SEQUENCE IF EXISTS %s RENAME TO %s', quote_ident(_nombretabla||'_Propiedades_id_seq'),quote_ident(_codigo||'_Propiedades_id_seq'));
--cambiamos el codigo raiz en tablas de conceptos y mediciones
EXECUTE FORMAT ('UPDATE %I SET codigo = $1 WHERE codigo = $2',_codigo || '_Conceptos') USING _codigo, _nombretabla;-- TABLA CONCEPTOS
EXECUTE FORMAT ('UPDATE %I SET codhijo = $1 WHERE codpadre IS NULL',_codigo || '_Relacion') USING _codigo;-- TABLA RELACION
--cambio el codigo en la tabla de Propiedades
EXECUTE FORMAT ('WITH dato AS (
  SELECT (''{Valor,''||index-1||'',Valor}'')::text[] as path
  FROM  %I, jsonb_array_elements(propiedades->''Valor'') with ordinality arr(contact,index)
  WHERE propiedades->>''Propiedad'' = ''Datos generales''
  AND contact->>''Variable'' = ''zRaíz''
  )
   UPDATE %I
   SET propiedades = jsonb_set(propiedades, dato.path, ''%s'', false)
   FROM dato
   WHERE propiedades->>''Propiedad'' = ''Datos generales''',_codigo || '_Propiedades',_codigo || '_Propiedades',quote_ident(_codigo));
RETURN resultado;
END;
$_$;


ALTER FUNCTION sdmed.cambiar_codigo_obra(_nombretabla character varying, _codigo character varying) OWNER TO sdmed;

--
-- TOC entry 271 (class 1255 OID 39328)
-- Name: cambiar_resumen_obra(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.cambiar_resumen_obra(_nombretabla character varying, _resumen character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
--tablas
tabla_conceptos character varying := _nombretabla || '_Conceptos';
tabla_propiedades character varying := _nombretabla || '_Propiedades';

BEGIN
--cambio el resumen en la tabla de Conceptos
EXECUTE FORMAT ('UPDATE %I SET resumen = $1 WHERE codigo = $2', tabla_conceptos) USING _resumen, _nombretabla;
--cambio el resumen en la tabla de Propiedades
EXECUTE FORMAT ('WITH dato AS (
  SELECT (''{Valor,''||index-1||'',Valor}'')::text[] as path
  FROM  %I, jsonb_array_elements(propiedades->''Valor'') with ordinality arr(contact,index)
  WHERE propiedades->>''Propiedad'' = ''Datos generales''
  AND contact->>''Variable'' = ''zNombre''
  )
   UPDATE %I
   SET propiedades = jsonb_set(propiedades, dato.path, ''%s'', false)
   FROM dato
   WHERE propiedades->>''Propiedad'' = ''Datos generales''',tabla_propiedades,tabla_propiedades,quote_ident(_resumen));
END;
$_$;


ALTER FUNCTION sdmed.cambiar_resumen_obra(_nombretabla character varying, _resumen character varying) OWNER TO sdmed;

--
-- TOC entry 272 (class 1255 OID 39329)
-- Name: cerrar_obra(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.cerrar_obra(_nombretabla character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
--tablas
tabla_guardar_conceptos character varying := _nombretabla || '_GuardarConceptos';
tabla_guardar_relaciones character varying := _nombretabla || '_GuardarRelaciones';
tabla_guardar_mediciones character varying := _nombretabla || '_GuardarMediciones';
tabla_guardar_certificaciones character varying := _nombretabla || '_GuardarCertificaciones';
BEGIN
--borrar tablas
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_conceptos);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_relaciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_mediciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_certificaciones);
END;
$$;


ALTER FUNCTION sdmed.cerrar_obra(_nombretabla character varying) OWNER TO sdmed;

--
-- TOC entry 268 (class 1255 OID 39330)
-- Name: cerrar_tablas_auxiliares(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.cerrar_tablas_auxiliares(_nombretabla character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
--tablas
tabla_guardar_conceptos character varying := _nombretabla || '_GuardarConceptos';
tabla_guardar_relaciones character varying := _nombretabla || '_GuardarRelaciones';
tabla_guardar_mediciones character varying := _nombretabla || '_GuardarMediciones';
tabla_guardar_certificaciones character varying := _nombretabla || '_GuardarCertificaciones';
BEGIN
--borrar tablas
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_conceptos);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_relaciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_mediciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_certificaciones);
END;
$$;


ALTER FUNCTION sdmed.cerrar_tablas_auxiliares(_nombretabla character varying) OWNER TO sdmed;

--
-- TOC entry 273 (class 1255 OID 39331)
-- Name: certificar(character varying, character varying, character varying, character varying[]); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.certificar(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _indices character varying[]) RETURNS integer
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
tablamedicion character varying := _nombretabla || '_Mediciones';
tablacertificacion character varying := _nombretabla || '_Certificaciones';
M tp_medicion%rowtype;
existe boolean;
fecha character varying;
posicion integer;
num_cert integer DEFAULT 0;
BEGIN
--comprobamos que hay alguna certificacion en vigor, por lo que debe de existir una tabla de certificaciones. Si no la hay salimos de la funcion con false
existe = hay_certificacion(_nombretabla);
IF existe IS FALSE THEN
	RETURN -1;
END IF;
--si no hemos salido, buscamos la certificacion activa
EXECUTE FORMAT ('SELECT * FROM  ver_certificacion_actual($1)') USING _nombretabla INTO num_cert,fecha;
IF num_cert = 0 THEN
	RETURN -2;
END IF;
--las lineas certificadas se copiaran al final de las lineas existentes en la tabla dada, asi que hallo esa posicion
EXECUTE FORMAT ('SELECT MAX(posicion) FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3',tablamedicion)
	USING _codigopadre, _codigohijo, num_cert
	INTO posicion;
--si no hay lineas de certificacion, el select anterior me dara null, luego empiezo en 0
--si ya hay lineas, empiezo en la posicion siguiente a la ultima
IF posicion IS NULL THEN 
	posicion = 0;
ELSE
    posicion = posicion +1;
END IF;
--RECORRO EL ARRAY DE INDICES SELECCIONADOS
FOR I IN array_lower(_indices, 1)..array_upper(_indices, 1)
LOOP
	FOR M IN EXECUTE FORMAT('SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = 0 AND posicion = $3',tablamedicion) 
		USING _codigopadre, _codigohijo, _indices[I]::integer
		LOOP
		PERFORM insertar_lineas_medcert(_nombretabla,_codigopadre,_codigohijo,1,posicion,num_cert,M.tipo,M.comentario,M.ud,M.longitud,M.anchura,M.altura,M.formula);	
		posicion = posicion +1;		
		END LOOP;
END LOOP;
RETURN num_cert;
END;
$_$;


ALTER FUNCTION sdmed.certificar(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _indices character varying[]) OWNER TO sdmed;

--
-- TOC entry 275 (class 1255 OID 39332)
-- Name: copiar(character varying, character varying, character varying[], boolean); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.copiar(_nombretabla character varying, _codigopadre character varying, _codigos character varying[], _primer_paso boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';
tablamedicion character varying := _nombretabla || '_Mediciones';


tablacopiarconceptos character varying := '__CopiarConceptos';
tablacopiarrelacion character varying := '__CopiarRelacion';
tablacopiarmediciones character varying := '__CopiarMediciones';

r tp_relacion%ROWTYPE;
c tp_concepto%ROWTYPE;

existe boolean;
arraycodigoshijos character varying[];

BEGIN
--primer paso, crear las tablas copiar conceptos, relaciones y mediciones y por si ya existieran, borrar su contenido
--Esta operacion solo se realizara en la primera llamada a la funcion
IF _primer_paso IS TRUE THEN
    EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_relacion (PRIMARY KEY (id))',tablacopiarrelacion);
    EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_concepto (PRIMARY KEY (codigo))',tablacopiarconceptos);
    EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_medicion (PRIMARY KEY (id))',tablacopiarmediciones);
    -- Luego se limpiaran por si ya existieran y tuvieran contenido
    EXECUTE FORMAT ('TRUNCATE %I,%I,%I',tablacopiarrelacion,tablacopiarconceptos,tablacopiarmediciones);
END IF;
--segundo paso, recorrer los codigos seleccionados
IF _codigos IS NOT NULL THEN	
	--ITERO SOBRE EL ARRAY DE CODIGOS HIJO
	FOR I IN array_lower(_codigos, 1)..array_upper(_codigos, 1)
	LOOP
		--copio las primeras relaciones
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = %L AND codhijo = %L ON CONFLICT DO NOTHING',
							tablacopiarrelacion,
							tablarelacion,
							_codigopadre,
							_codigos[I]);
		--pongo nulos los conceptos raiz
		IF _primer_paso IS TRUE THEN
				EXECUTE FORMAT ('UPDATE %I SET codpadre = NULL WHERE codpadre = %L AND codhijo = %L',
						tablacopiarrelacion,
						_codigopadre,
						_codigos[I]);
		END IF;
		--ahora meto los conceptos
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codigo = %L ON CONFLICT DO NOTHING',
			tablacopiarconceptos,
			tablaconceptos,
			_codigos[I]);
		--mediciones
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = %L AND codhijo = %L ON CONFLICT DO NOTHING',
			tablacopiarmediciones,
			tablamedicion,
			_codigopadre,
			_codigos[I]);		
		--selecciono los hijos de cada hijo y llamo de nuevo a la funcion
		EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = %L',
			tablarelacion,_codigos[I]) INTO arraycodigoshijos;
		PERFORM copiar(_nombretabla,_codigos[I], arraycodigoshijos,'FALSE');		
	END LOOP;
END IF;
END;
$$;


ALTER FUNCTION sdmed.copiar(_nombretabla character varying, _codigopadre character varying, _codigos character varying[], _primer_paso boolean) OWNER TO sdmed;

--
-- TOC entry 277 (class 1255 OID 39333)
-- Name: copiar_medicion(character varying, character varying, character varying, integer, integer[]); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.copiar_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _lineas integer[] DEFAULT NULL::integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
tablamedicion character varying := _nombretabla || '_Mediciones';
tablacopiarmediciones character varying := '__CopiarMediciones';
tamanno integer := array_length(_lineas, 1);
BEGIN
--primer paso, crear las tablas copiar conceptos, relaciones y mediciones y por si ya existieran, borrar su contenido
EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_medicion (PRIMARY KEY (id))',tablacopiarmediciones);
-- Luego se limpiara por si ya existiera y tuviera contenido
EXECUTE FORMAT ('TRUNCATE %I',tablacopiarmediciones);
--finalmente, recorrer los codigos seleccionados
--si no hay un listado de lineas seleccionadas se meten todas
IF _lineas IS NULL THEN
	EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3 ON CONFLICT DO NOTHING',
				tablacopiarmediciones, tablamedicion) USING
				_codigopadre,
				_codigohijo,
				_num_cert;
ELSE
--si hay lineas seleccionadas solo copio esas lineas	
	FOR i IN 1..tamanno LOOP
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3 AND posicion = $4 ON CONFLICT DO NOTHING',
				tablacopiarmediciones, tablamedicion) USING
				_codigopadre,
				_codigohijo,
				_num_cert,
				_lineas[i];
	END LOOP;
END IF;
END;
$_$;


ALTER FUNCTION sdmed.copiar_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _lineas integer[]) OWNER TO sdmed;

--
-- TOC entry 344 (class 1255 OID 39334)
-- Name: crear_obra(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.crear_obra(codigo character varying, resumen character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
resultado integer;
tablaconceptos character varying;
tablarelacion character varying;
var_r character varying;
existe boolean;
contador integer:=1;
primer_digito character varying:='0';
codigo_corregido character varying;
BEGIN
codigo_corregido = codigo;
SELECT existe_obra(codigo_corregido) INTO existe;
RAISE NOTICE 'existe = %',existe;
WHILE existe = True LOOP
	codigo_corregido = concat (codigo,'_',primer_digito,contador::character varying);
	RAISE NOTICE 'codigo = %',codigo_corregido;
	SELECT existe_obra(codigo_corregido) INTO existe;
	contador = contador +1;
	IF contador>9 THEN
		primer_digito = '';
	END IF;
END LOOP;
codigo = codigo_corregido;
resultado = (SELECT crear_tabla_conceptos(codigo));
IF resultado != 0 THEN
PERFORM borrar_obra (codigo);
RETURN resultado;
END IF;
resultado = (SELECT crear_tabla_relacion(codigo));
IF resultado != 0 THEN
PERFORM borrar_obra (codigo);
RETURN resultado;
END IF;
resultado = (SELECT crear_tabla_mediciones(codigo));
IF resultado != 0 THEN
PERFORM borrar_obra (codigo);
RETURN resultado;
END IF;
--si todo esta correcto:
tablaconceptos := codigo||'_Conceptos';
tablarelacion := codigo||'_Relacion';
--insertamos el nodo raiz
EXECUTE format ('INSERT INTO %I(codigo,resumen,naturaleza,fecha) VALUES(%s,%s,6,NOW())',tablaconceptos,quote_literal(codigo),quote_literal(resumen));
--insertamos la primera relacion
EXECUTE format ('INSERT INTO %I VALUES(0,NULL,%s,1,1,0)',tablarelacion,quote_literal(codigo));
--por ultimo con los datos raiz insertados en la tabla conceptos y relaciones creo la tabla de propiedades
resultado = (SELECT crear_tabla_propiedades(codigo));
IF resultado != 0 THEN
PERFORM borrar_obra (codigo);
RETURN resultado;
END IF;
return 0;
END;
$$;


ALTER FUNCTION sdmed.crear_obra(codigo character varying, resumen character varying) OWNER TO sdmed;

--
-- TOC entry 347 (class 1255 OID 72807)
-- Name: crear_tabla_aceros(); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.crear_tabla_aceros() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
existe boolean;
BEGIN
SELECT EXISTS (
   SELECT FROM pg_catalog.pg_class c
   JOIN   pg_catalog.pg_namespace n ON n.oid = c.relnamespace
   WHERE  n.nspname = 'sdmed'
   AND    c.relname = 'tAcero'
   ) INTO existe;
   RAISE NOTICE '%',existe;
IF existe IS FALSE THEN
   
  CREATE TABLE sdmed."tAcero" (
    id integer NOT NULL PRIMARY KEY,
    area numeric,
    masa numeric,
    tipo character varying(15),
    tamanno character varying(13)
);

CREATE SEQUENCE "tCorrugados_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	
	INSERT INTO sdmed."tAcero" (id, area, masa, tipo, tamanno) VALUES
	('44','65.30','502000','HEB','180'),
	('45','78.10','601000','HEB','200'),
	('46','91.00','701000','HEB','220'),
	('47','106.00','816000','HEB','240'),
	('48','118.40','912000','HEB','260'),
	('49','131.40','1010000','HEB','280'),
	('50','149.10','1148000','HEB','300'),
	('51','161.30','1246000','HEB','320'),
	('52','170.90','1315000','HEB','340'),
	('53','180.60','1393000','HEB','360'),
	('54','197.80','1521000','HEB','400'),
	('55','218.00','1678000','HEB','450'),
	('56','238.60','1834000','HEB','500'),
	('57','254.10','1952000','HEB','550'),
	('58','270.00','2080000','HEB','600'),
	('59','21.20','164000','HEA','100'),('60','25.30','195000','HEA','120'),('61','31.40','242000','HEA','140'),('62','38.80','298000','HEA','160'),('63','45.30','348000','HEA','180'),('64','53.80','415000','HEA','200'),('65','64.30','495000','HEA','220'),('66','76.80','592000','HEA','240'),('67','86.80','669000','HEA','260'),('68','97.30','749000','HEA','280'),('69','112.50','866000','HEA','300'),('70','124.40','957000','HEA','320'),('71','133.50','1030000','HEA','340'),('72','142.80','1099000','HEA','360'),('73','159.00','1226000','HEA','400'),('74','178.00','1373000','HEA','450'),('75','197.50','1521000','HEA','500'),('76','211.80','1628000','HEA','550'),('77','226.50','178000','HEA','600'),('78','53.20','410000','HEM','100'),('79','66.40','511000','HEM','120'),('80','80.60','620000','HEM','140'),('81','97.10','748000','HEM','160'),('82','113.30','872000','HEM','180'),('83','131.30','1010000','HEM','200'),('84','149.40','1148000','HEM','220'),('85','199.60','1540000','HEM','240'),('86','219.60','1687000','HEM','260'),('87','240.20','1854000','HEM','280'),('88','303.10','2335000','HEM','300'),('89','312.00','2403000','HEM','320'),('90','315.80','2433000','HEM','340'),('91','318.80','2453000','HEM','360'),('92','325.80','2511000','HEM','400'),('93','335.40','2580000','HEM','450'),('94','344.30','2649000','HEM','500'),('95','354.40','2727000','HEM','550'),('96','363.70','2796000','HEM','600'),('97','11.00','84800','UPN','80'),('98','13.50','104000','UPN','100'),('99','17.00','131000','UPN','120'),('100','20.40','157000','UPN','140'),('101','24.00','184000','UPN','160'),('102','28.00','216000','UPN','180'),('103','32.20','248000','UPN','200'),('104','37.40','288000','UPN','220'),('105','42.30','326000','UPN','240'),('106','48.30','372000','UPN','260'),('107','53.30','410000','UPN','280'),('108','58.80','453000','UPN','300'),('109','3.08','23700','L','40.4'),('110','3.79','29100','L','40.5'),('111','4.48','34500','L','40.6'),('112','3.49','26900','L','45.4'),('113','4.30','33200','L','45.5'),('114','5.09','39200','L','45.6'),('115','3.89','30000','L','50.4'),('116','4.80','37000','L','50.5'),('117','5.69','43900','L','50.6'),('118','6.56','50500','L','50.7'),('119','7.41','57100','L','50.8'),('120','5.82','44800','L','60.5'),('121','6.91','53200','L','60.6'),('122','9.03','69600','L','60.8'),('123','11.10','85200','L','60.10'),('124','8.13','62600','L','70.6'),('125','9.40','72400','L','70.7'),('126','10.60','82000','L','70.8'),('127','13.10','101000','L','70.10'),('128','12.30','94500','L','80.8'),('129','15.10','117000','L','80.10'),('130','17.90','137000','L','80.12'),('131','13.90','107000','L','90.8'),('132','17.10','131000','L','90.10'),('133','20.30','156000','L','90.12'),('134','15.50','120000','L','100.8'),('135','19.20','147000','L','100.10'),('136','22.70','175000','L','100.12'),('137','27.90','215000','L','100.15'),('138','23.20','179000','L','120.10'),('139','27.50','212000','L','120.12'),('140','33.90','261000','L','120.15'),('141','34.80','268000','L','150.12'),('142','43.00','332000','L','150.15'),('143','51.00','393000','L','150.18'),('144','52.10','401000','L','180.15'),('145','61.90','477000','L','180.18'),('146','68.30','527000','L','180.20'),('147','61.80','476000','L','200.16'),('148','69.10','532000','L','200.18'),('149','76.30','588000','L','200.20'),('150','90.60','697000','L','200.24'),('151','2.46','18900','LD','40.25.4'),('152','3.02','23200','LD','40.25.5'),('153','2.86','22000','LD','45.30.4'),('154','3.52','27100','LD','45.30.5'),('155','4.29','33100','LD','60.30.5'),('156','5.08','39100','LD','60.30.6'),('157','4.79','36900','LD','60.40.5'),('158','5.68','43800','LD','60.40.6'),('159','6.55','50400','LD','60.40.7'),('160','5.54','42700','LD','65.50.5'),('161','6.58','50600','LD','65.50.6'),('162','7.60','58500','LD','65.50.7'),('163','8.60','66200','LD','65.50.8'),('164','6.05','46600','LD','75.50.5'),('165','7.19','55400','LD','75.50.6'),('166','8.31','64100','LD','75.50.7'),('167','9.41','72500','LD','75.50.8'),('168','5.80','44700','LD','80.40.5'),('169','6.89','53100','LD','80.40.6'),('170','7.96','61300','LD','80.40.7'),('171','9.01','69400','LD','80.40.8'),('172','8.11','62500','LD','80.60.6'),('173','9.38','72200','LD','80.60.7'),('174','10.60','81800','LD','80.60.8'),('175','8.73','67200','LD','100.50.6'),('176','10.10','77800','LD','100.50.7'),('177','11.40','88200','LD','100.50.8'),('178','14.10','109000','LD','100.50.10'),('179','11.20','86000','LD','100.65.7'),('180','12.70','97500','LD','100.65.8'),('181','15.60','121000','LD','100.65.10'),('182','13.50','104000','LD','100.75.8'),('183','16.60','128000','LD','100.75.10'),('184','19.70','151000','LD','100.75.12'),('185','15.50','120000','LD','120.80.8'),('186','19.10','147000','LD','120.80.10'),('188','15.10','116000','LD','130.65.8'),('189','18.60','143000','LD','130.65.10'),('190','22.10','170000','LD','130.65.12'),('191','19.60','151000','LD','150.75.9'),('192','21.60','167000','LD','150.75.10'),('193','25.70','198000','LD','150.75.12'),('194','31.60','243000','LD','150.75.15'),('195','23.20','179000','LD','150.90.10'),('196','27.50','212000','LD','150.90.12'),('197','33.90','261000','LD','150.90.15'),('198','29.20','226000','LD','200.100.10'),('199','34.80','268000','LD','200.100.12'),('200','43.00','331000','LD','200.100.15'),('201','34.20','264000','LD','200.150.10'),('202','40.80','314000','LD','200.150.12'),('203','50.50','388000','LD','200.150.15'),('204','60.00','462000','LD','200.150.18'),('205','177.00','17400','T','30'),('206','297.00','22900','T','35'),('207','377.00','29000','T','40'),('208','566.00','43600','T','50'),('209','794.00','61100','T','60'),('210','1060.00','81600','T','70'),('211','1360.00','105000','T','80'),('212','2090.00','160900','T','100'),('213','2960.00','227600','T','120'),('214','3990.00','307100','T','140'),('215','0.28','2200','?','6'),('216','0.39','3000','?','7'),('217','0.50','3900','?','8'),('218','0.79','6100','?','10'),('219','1.13','8700','?','12'),('220','1.54','11900','?','14'),('221','2.01','15500','?','16'),('222','2.55','19600','?','18'),('223','3.14','24200','?','20'),('224','3.80','29200','?','22'),('225','4.91','37800','?','25'),('226','6.16','47400','?','28'),('227','7.07','54400','?','30'),('228','8.04','61900','?','32'),('229','10.20','78400','?','36'),('230','12.60','96700','?','40'),('231','15.90','122600','?','45'),('232','19.60','151100','?','50'),('233','1.08','3500','?','6'),('234','2.00','4800','?','7'),('235','3.41','6300','?','8'),('236','8.33','9800','?','10'),('237','17.30','14100','?','12'),('238','32.00','19200','?','14'),('239','54.60','25100','?','16'),('240','87.50','31800','?','18'),('241','133.00','39200','?','20'),('242','195.00','47500','?','22'),('243','326.00','61300','?','25'),('244','512.00','76900','?','28'),('245','675.00','88300','?','30'),('246','874.00','100100','?','32'),('247','1400.00','127500','?','36'),('248','2130.00','157000','?','40'),('249','3420.00','199100','?','45'),('250','5210.00','245300','?','50'),('251','80.00','6160','Rectangular','20·4'),('252','100.00','7700','Rectangular','20·5'),('253','120.00','9240','Rectangular','20·6'),('254','160.00','12400','Rectangular','20·8'),('255','200.00','15400','Rectangular','20·10'),('256','240.00','18400','Rectangular','20·12'),('257','300.00','23200','Rectangular','20·15'),('258','100.00','7700','Rectangular','25·4'),('259','125.00','9620','Rectangular','25·5'),('260','150.00','11600','Rectangular','25·6'),('261','200.00','15400','Rectangular','25·8'),('262','250.00','19200','Rectangular','25·10'),('263','300.00','23200','Rectangular','25·12'),('264','375.00','28800','Rectangular','25·15'),('265','500.00','38600','Rectangular','25·20'),('266','120.00','9240','Rectangular','30·4'),('267','150.00','11600','Rectangular','30·5'),('268','180.00','13800','Rectangular','30·6'),('269','240.00','18400','Rectangular','30·8'),('270','300.00','23200','Rectangular','30·10'),('271','360.00','27800','Rectangular','30·12'),('272','450.00','34600','Rectangular','30·15'),('273','600.00','46200','Rectangular','30·20'),('274','750.00','57800','Rectangular','30·25'),('275','140.00','10800','Rectangular','35·4'),('276','175.00','13400','Rectangular','35·5'),('277','210.00','16200','Rectangular','35·6'),('278','280.00','21600','Rectangular','35·8'),('279','350.00','27000','Rectangular','35·10'),('280','420.00','32400','Rectangular','35·12'),('281','525.00','40400','Rectangular','35·15'),('282','700.00','54000','Rectangular','35·20'),('283','875.00','67400','Rectangular','35·25'),('284','1050.00','80800','Rectangular','35·30'),('285','160.00','12400','Rectangular','40·4'),('286','200.00','15400','Rectangular','40·5'),('287','240.00','18400','Rectangular','40·6'),('288','320.00','24600','Rectangular','40·8'),('289','400.00','30800','Rectangular','40·10'),('290','480.00','37000','Rectangular','40·12'),('291','600.00','46200','Rectangular','40·15'),('292','800.00','61600','Rectangular','40·20'),('293','1000.00','77000','Rectangular','40·25'),('294','1200.00','92400','Rectangular','40·30'),('295','1400.00','108000','Rectangular','40·35'),('296','180.00','13800','Rectangular','45·4'),('297','225.00','17400','Rectangular','45·5'),('298','270.00','20800','Rectangular','45·6'),('299','360.00','27800','Rectangular','45·8'),('300','450.00','34600','Rectangular','45·10'),('301','540.00','41600','Rectangular','45·12'),('302','675.00','52000','Rectangular','45·15'),('303','900.00','69400','Rectangular','45·20'),('304','1120.00','86600','Rectangular','45·25'),('305','1350.00','104000','Rectangular','45·30'),('306','1580.00','122000','Rectangular','45·35'),('307','1800.00','138000','Rectangular','45·40'),('308','200.00','15400','Rectangular','50·4'),('309','250.00','19200','Rectangular','50·5'),('310','300.00','23200','Rectangular','50·6'),('311','400.00','30800','Rectangular','50·8'),('312','500.00','38600','Rectangular','50·10'),('313','600.00','46200','Rectangular','50·12'),('314','750.00','57800','Rectangular','50·15'),('315','1000.00','77000','Rectangular','50·20'),('316','1250.00','96200','Rectangular','50·25'),('317','1500.00','116000','Rectangular','50·30'),('318','1750.00','134000','Rectangular','50·35'),('319','2000.00','154000','Rectangular','50·40'),('320','220.00','17000','Rectangular','55·4'),('321','275.00','21200','Rectangular','55·5'),('322','330.00','25400','Rectangular','55·6'),('323','440.00','33800','Rectangular','55·8'),('324','550.00','42400','Rectangular','55·10'),('325','660.00','50800','Rectangular','55·12'),('326','825.00','63600','Rectangular','55·15'),('327','1100.00','84800','Rectangular','55·20'),('328','1380.00','106000','Rectangular','55·25'),('329','1650.00','128000','Rectangular','55·30'),('330','1930.00','148000','Rectangular','55·35'),('331','2200.00','170000','Rectangular','55·40'),('332','240.00','18400','Rectangular','60·4'),('333','300.00','23200','Rectangular','60·5'),('334','360.00','27800','Rectangular','60·6'),('335','480.00','37000','Rectangular','60·8'),('336','600.00','46200','Rectangular','60·10'),('337','720.00','55400','Rectangular','60·12'),('338','900.00','69400','Rectangular','60·15'),('339','1200.00','92400','Rectangular','60·20'),('340','1500.00','116000','Rectangular','60·25'),('341','1800.00','138000','Rectangular','60·30'),('342','2100.00','162000','Rectangular','60·35'),('343','2400.00','184000','Rectangular','60·40'),('344','280.00','21600','Rectangular','70·4'),('345','350.00','27000','Rectangular','70·5'),('346','420.00','32400','Rectangular','70·6'),('347','560.00','43200','Rectangular','70·8'),('348','700.00','54000','Rectangular','70·10'),('349','840.00','64600','Rectangular','70·12'),('350','1050.00','80800','Rectangular','70·15'),('351','1400.00','108000','Rectangular','70·20'),('352','1750.00','134000','Rectangular','70·25'),('353','2100.00','162000','Rectangular','70·30'),('354','2450.00','188000','Rectangular','70·35'),('355','2800.00','216000','Rectangular','70·40'),('356','300.00','23200','Rectangular','75·4'),('357','375.00','28800','Rectangular','75·5'),('358','450.00','34600','Rectangular','75·6'),('359','600.00','46200','Rectangular','75·8'),('360','750.00','57800','Rectangular','75·10'),('361','900.00','69400','Rectangular','75·12'),('362','1120.00','86600','Rectangular','75·15'),('363','1500.00','116000','Rectangular','75·20'),('364','1880.00','144000','Rectangular','75·25'),('365','2250.00','174000','Rectangular','75·30'),('366','2620.00','202000','Rectangular','75·35'),('367','3000.00','232000','Rectangular','75·40'),('368','320.00','24600','Rectangular','80·4'),('369','400.00','30800','Rectangular','80·5'),('370','480.00','37000','Rectangular','80·6'),('371','640.00','49200','Rectangular','80·8'),('372','800.00','61600','Rectangular','80·10'),('373','960.00','74000','Rectangular','80·12'),('374','1200.00','92400','Rectangular','80·15'),('375','1600.00','124000','Rectangular','80·20'),('376','2000.00','154000','Rectangular','80·25'),('377','2400.00','184000','Rectangular','80·30'),('378','2800.00','216000','Rectangular','80·35'),('379','3200.00','246000','Rectangular','80·40'),('380','360.00','28000','Rectangular','90·4'),('381','450.00','34600','Rectangular','90·5'),('382','540.00','41600','Rectangular','90·6'),('383','720.00','57400','Rectangular','90·8'),('384','900.00','69400','Rectangular','90·10'),('385','1080.00','83200','Rectangular','90·12'),('386','1350.00','104000','Rectangular','90·15'),('387','1800.00','119000','Rectangular','90·20'),('388','2250.00','174000','Rectangular','90·25'),('389','2700.00','208000','Rectangular','90·30'),('390','3150.00','242000','Rectangular','90·35'),('391','3600.00','278000','Rectangular','90·40'),('392','400.00','30800','Rectangular','100·4'),('393','500.00','38600','Rectangular','100·5'),('394','600.00','46200','Rectangular','100·6'),('395','800.00','61100','Rectangular','100·8'),('396','1000.00','77000','Rectangular','100·10'),('397','1200.00','92400','Rectangular','100·12'),('398','1500.00','116000','Rectangular','100·15'),('399','2000.00','154000','Rectangular','100·20'),('400','2500.00','192000','Rectangular','100·25'),('401','3000.00','232000','Rectangular','100·30'),('402','3500.00','270000','Rectangular','100·35'),('403','4000.00','308000','Rectangular','100·40'),('404','440.00','33800','Rectangular','110·4'),('405','550.00','42400','Rectangular','110·5'),('406','680.00','50800','Rectangular','110·6'),('407','880.00','67800','Rectangular','110·8'),('408','1100.00','84800','Rectangular','110·10'),('409','1320.00','102000','Rectangular','110·12'),('410','1650.00','128000','Rectangular','110·15'),('411','2200.00','170000','Rectangular','110·20'),('412','2750.00','212000','Rectangular','110·25'),('413','3300.00','254000','Rectangular','110·30'),('414','3850.00','296000','Rectangular','110·35'),('415','4400.00','338000','Rectangular','110·40'),('416','480.00','37000','Rectangular','120·4'),('417','600.00','46200','Rectangular','120·5'),('418','720.00','55400','Rectangular','120·6'),('419','960.00','74000','Rectangular','120·8'),('420','1200.00','92400','Rectangular','120·10'),('421','1440.00','111000','Rectangular','120·12'),('422','1880.00','138000','Rectangular','120·15'),('423','2400.00','184000','Rectangular','120·20'),('424','3000.00','232000','Rectangular','120·25'),('425','3600.00','280000','Rectangular','120·30'),('426','4200.00','324000','Rectangular','120·35'),('427','4800.00','370000','Rectangular','120·40'),('428','1120.00','86200','Rectangular','140·8'),('429','1400.00','108000','Rectangular','140·10'),('430','1680.00','129000','Rectangular','140·12'),('431','2100.00','162000','Rectangular','140·15'),('432','2800.00','216000','Rectangular','140·20'),('433','3500.00','270000','Rectangular','140·25'),('434','4200.00','324000','Rectangular','140·30'),('435','4900.00','378000','Rectangular','140·35'),('436','5600.00','432000','Rectangular','140·40'),('437','1200.00','92400','Rectangular','150·8'),('438','1500.00','116000','Rectangular','150·10'),('439','1800.00','138000','Rectangular','150·12'),('440','2250.00','174000','Rectangular','150·15'),('441','3000.00','232000','Rectangular','150·20'),('442','3750.00','288000','Rectangular','150·25'),('443','4500.00','346000','Rectangular','150·30'),('444','5250.00','404000','Rectangular','150·35'),('445','6000.00','462000','Rectangular','150·40'),('446','1280.00','98100','Rectangular','160·8'),('447','1600.00','124000','Rectangular','160·10'),('448','1920.00','148000','Rectangular','160·12'),('449','2400.00','184000','Rectangular','160·15'),('450','3200.00','246000','Rectangular','160·20'),('451','4000.00','308000','Rectangular','160·25'),('452','4800.00','370000','Rectangular','160·30'),('453','5600.00','432000','Rectangular','160·35'),('454','6400.00','492000','Rectangular','160·40'),('455','1440.00','111000','Rectangular','180·8'),('456','1800.00','138000','Rectangular','180·10'),('457','2160.00','167000','Rectangular','180·12'),('458','2700.00','208000','Rectangular','180·15'),('459','3600.00','278000','Rectangular','180·20'),('460','4500.00','346000','Rectangular','180·25'),('461','5400.00','416000','Rectangular','180·30'),('462','6300.00','486000','Rectangular','180·35'),('463','7200.00','554000','Rectangular','180·40'),('464','1600.00','124000','Rectangular','200·8'),('465','2000.00','154000','Rectangular','200·10'),('466','2400.00','184000','Rectangular','200·12'),('467','3000.00','232000','Rectangular','200·15'),('468','4000.00','308000','Rectangular','200·20'),('469','5000.00','385000','Rectangular','200·25'),('470','6000.00','462000','Rectangular','200·30'),('471','7000.00','540000','Rectangular','200·35'),('472','8000.00','616000','Rectangular','200·40'),('473','2000.00','154000','Rectangular','250·8'),('474','2500.00','192000','Rectangular','250·10'),('475','3000.00','232000','Rectangular','250·12'),('476','3750.00','288000','Rectangular','250·15'),('477','5000.00','385000','Rectangular','250·20'),('478','6250.00','482000','Rectangular','250·25'),('479','7500.00','578000','Rectangular','250·30'),('480','8750.00','674000','Rectangular','250·35'),('481','10000.00','770000','Rectangular','250·40'),('482','2400.00','184000','Rectangular','300·8'),('483','3000.00','232000','Rectangular','300·10'),('484','3600.00','278000','Rectangular','300·12'),('485','4500.00','346000','Rectangular','300·15'),('486','6000.00','462000','Rectangular','300·20'),('487','7500.00','578000','Rectangular','300·25'),('488','9000.00','693000','Rectangular','300·30'),('489','10500.00','808000','Rectangular','300·35'),('490','12000.00','924000','Rectangular','300·40'),('491','3200.00','246000','Rectangular','400·8'),('492','4000.00','308000','Rectangular','400·10'),('493','4800.00','370000','Rectangular','400·12'),('494','6000.00','462000','Rectangular','400·15'),('495','8000.00','616000','Rectangular','400·20'),('496','10000.00','770000','Rectangular','400·25'),('497','12000.00','924000','Rectangular','400·30'),('498','14000.00','1079000','Rectangular','400·35'),('499','16000.00','1236000','Rectangular','400·40'),('500','2.39','18400','?','40.2'),('501','3.49','26900','?','40.3'),('502','4.52','34800','?','40.4'),('503','2.70','20800','?','45.2'),('504','3.96','30500','?','45.3'),('505','5.15','39600','?','45.4'),('506','3.02','23200','?','50.2'),('507','4.43','34000','?','50.3'),('508','5.78','44400','?','50.4'),('509','3.33','25600','?','55.2'),('510','4.90','37800','?','55.3'),('511','6.41','49300','?','55.4'),('512','3.64','28100','?','60.2'),('513','5.37','41300','?','60.3'),('514','7.04','54200','?','60.4'),('515','3.96','30500','?','65.2'),('516','5.84','44900','?','65.3'),('517','7.67','59100','?','65.4'),('518','4.27','32900','?','70.2'),('519','6.31','48600','?','70.3'),('520','8.29','63900','?','70.4'),('521','4.58','35300','?','75.2'),('522','6.78','52200','?','75.3'),('523','8.92','68700','?','75.4'),('524','4.90','37800','?','80.2'),('525','7.26','55900','?','80.3'),('526','9.55','73600','?','80.4'),('527','8.19','63100','?','90.3'),('528','10.80','83200','?','90.4'),('529','13.40','103000','?','90.5'),('530','9.14','70300','?','100.3'),('531','12.10','92900','?','100.4'),('532','14.90','115000','?','100.5'),('533','17.70','136000','?','100.6'),('534','15.20','117000','?','125.4'),('535','18.80','145000','?','125.5'),('536','22.40','173000','?','125.6'),('537','23.60','181000','?','155.5'),('538','28.10','217000','?','155.6'),('539','36.90','284000','?','155.8'),('540','26.70','206000','?','175.5'),('541','31.90','245000','?','175.6'),('542','42.00','324000','?','175.8'),('543','30.60','235000','?','200.5'),('544','36.60','282000','?','200.6'),('545','48.30','372000','?','200.8'),('546','2.90','22400','#','40.2'),('547','4.13','31800','#','40.3'),('548','5.21','40100','#','40.4'),('549','3.30','25400','#','45.2'),('550','4.73','36400','#','45.3'),('551','6.01','46300','#','45.4'),('552','3.70','28500','#','50.2'),('553','5.33','41000','#','50.3'),('554','5.81','52500','#','50.4'),('555','4.10','31600','#','55.2'),('556','5.93','45700','#','55.3'),('557','7.61','58600','#','55.4'),('558','4.50','34600','#','60.2'),('559','6.53','50300','#','60.3'),('560','8.41','64700','#','60.4'),('561','10.10','78100','#','60.5'),('562','5.30','40800','#','70.2'),('563','7.73','59500','#','70.3'),('564','10.00','77100','#','70.4'),('565','12.10','93500','#','70.5'),('566','8.90','68800','#','80.3'),('567','11.60','89400','#','80.4'),('568','14.10','109000','#','80.5'),('569','16.50','128000','#','80.6'),('570','10.10','78000','#','90.3'),('571','13.20','102000','#','90.4'),('572','16.10','125000','#','90.5'),('573','18.90','146000','#','90.6'),('574','11.30','87200','#','100.3'),('575','14.80','114000','#','100.4'),('576','18.10','139000','#','100.5'),('577','21.30','164000','#','100.6'),('578','18.00','138000','#','120.4'),('579','22.10','171000','#','120.5'),('580','26.10','201000','#','120.6'),('581','26.10','201000','#','140.5'),('582','30.90','238000','#','140.6'),('583','40.00','308000','#','140.8'),('584','30.10','232000','#','160.5'),('585','35.70','275000','#','160.6'),('586','46.40','358000','#','160.8'),('587','32.10','247000','#','170.5'),('588','38.10','293000','#','170.6'),('589','149.00','487000','#','170.8'),('590','1.53','1200','LF','40.2'),('591','2.25','1770','LF','40.3'),('592','2.90','2280','LF','40.4'),('593','1.93','1510','LF','50.2'),('594','2.81','2210','LF','50.3'),('595','3.67','2880','LF','50.4'),('596','3.41','2680','LF','60.3'),('597','4.47','3510','LF','60.4'),('598','5.48','4300','LF','60.5'),('599','6.07','4760','LF','80.4'),('600','7.48','5870','LF','80.5'),('601','8.85','6950','LF','80.6'),('602','7.48','7070','LF','100.5'),('603','8.87','7070','LF','100.6'),('604','10.20','7070','LF','100.7'),('605','9.05','8490','LF','120.5'),('606','10.80','8490','LF','120.6'),('607','12.40','8490','LF','120.7'),('608','1.13','887','LD','40.20.2'),('609','1.65','1300','LD','40.20.3'),('610','1.43','1120','LD','50.25.2'),('611','2.10','1650','LD','50.25.3'),('612','2.55','2000','LD','60.30.3'),('613','3.30','2590','LD','60.30.4'),('614','4.50','3530','LD','80.40.4'),('615','5.52','4340','LD','80.40.5'),('616','7.02','5510','LD','100.50.5'),('617','8.30','6520','LD','100.50.6'),('618','8.52','6690','LD','120.60.5'),('619','10.10','7930','LD','120.60.6'),('620','3.30','2590','UF','60.3'),('621','4.20','3300','UF','60.4'),('622','4.50','3530','UF','80.3'),('623','5.80','4550','UF','80.4'),('624','7.04','5520','UF','80.5'),('625','4.48','3100','UF','100.3'),('626','5.81','3120','UF','100.4'),('627','7.09','3120','UF','100.5'),('628','7.06','3750','UF','120.4'),('629','8.66','3750','UF','120.5'),('630','10.20','3750','UF','120.6'),('631','8.32','4380','UF','140.4'),('632','10.20','4380','UF','140.5'),('633','12.10','4380','UF','140.6'),('634','2.72','2130','OF','40.2.0'),('635','3.34','2620','OF','40.2.5'),('636','3.91','3070','OF','40.3.0'),('637','3.40','2670','OF','50.2.0'),('638','4.19','3290','OF','50.2.5'),('639','4.93','3870','OF','50.3.0'),('640','3.72','2920','OF','60.2.0'),('641','4.59','3600','OF','60.2.5'),('642','5.41','4250','OF','60.3.0'),('643','6.09','4780','OF','80.2.5'),('644','7.21','5660','OF','80.3.0'),('645','5.76','8480','OF','100.2.5'),('646','6.94','8450','OF','100.3.0'),('647','3.12','2450','CF','60.2.0'),('648','3.84','3010','CF','60.2.5'),('649','4.50','3530','CF','60.3.0'),('650','3.52','2760','CF','80.2.0'),('651','4.34','3400','CF','80.2.5'),('652','5.10','4000','CF','80.3.0'),('653','3.92','3080','CF','100.2.0'),('654','4.84','3800','CF','100.2.5'),('655','5.70','4480','CF','100.3.0'),('656','4.92','3860','CF','120.2.0'),('657','6.09','4780','CF','120.2.5'),('658','7.20','5650','CF','120.3.0'),('659','5.32','4170','CF','140.2.0'),('660','6.59','5170','CF','140.2.5'),('661','7.80','6130','CF','140.3.0'),('662','6.12','4800','CF','160.2.0'),('663','7.59','5950','CF','160.2.5'),('664','9.00','7070','CF','160.3.0'),('665','6.52','5120','CF','180.2.0'),('666','8.09','6350','CF','180.2.5'),('667','9.60','7540','CF','180.3.0'),('668','6.92','5430','CF','200.2.0'),('669','8.59','6740','CF','200.2.5'),('670','10.20','8010','CF','200.3.0'),('671','10.50','8210','CF','225.2.5'),('672','12.50','9780','CF','225.3.0'),('673','16.20','12700','CF','225.4.0'),('674','11.10','8700','CF','250.2.5'),('675','13.20','10400','CF','250.3.0'),('676','17.20','13500','CF','250.4.0'),('677','11.70','9190','CF','275.2.5'),('678','14.00','11000','CF','275.3.0'),('679','18.20','14300','CF','275.4.0'),('680','12.30','9680','CF','300.2.5'),('681','14.70','11500','CF','300.3.0'),('682','19.20','15100','CF','300.4.0'),('683','4.72','3700','ZF','100.2.0'),('684','5.84','4580','ZF','100.2.5'),('685','6.91','5420','ZF','100.3.0'),('686','5.12','4020','ZF','120.2.0'),('687','6.34','4980','ZF','120.2.5'),('688','7.51','5890','ZF','120.3.0'),('689','5.52','4330','ZF','140.2.0'),('690','6.84','5370','ZF','140.2.5'),('691','8.11','6360','ZF','140.3.0'),('692','5.92','4650','ZF','160.2.0'),('693','7.34','5760','ZF','160.2.5'),('694','8.71','6840','ZF','160.3.0'),('695','6.32','4960','ZF','180.2.0'),('696','7.84','6150','ZF','180.2.5'),('697','9.31','7310','ZF','180.3.0'),('698','7.66','6010','ZF','200.2.0'),('699','9.51','7470','ZF','200.2.5'),('1','7.58','58400','IPN','80'),('2','10.60','81600','IPN','100'),('3','14.20','110000','IPN','120'),('4','18.30','141000','IPN','140'),('5','22.80','176000','IPN','160'),('6','27.90','215000','IPN','180'),('7','33.50','258000','IPN','200'),('8','39.60','305000','IPN','220'),('9','46.10','355000','IPN','240'),('10','53.40','411000','IPN','260'),('11','61.10','471000','IPN','280'),('12','69.10','532000','IPN','300'),('13','77.80','599000','IPN','320'),('14','86.80','668000','IPN','340'),('15','97.10','748000','IPN','360'),('16','107.00','824000','IPN','380'),('17','118.00','908000','IPN','400'),('18','147.00','1128000','IPN','450'),('19','180.00','1383000','IPN','500'),('20','213.00','1638000','IPN','550'),('21','254.00','1952000','IPN','600'),('22','7.64','58900','IPE','80'),('23','10.30','79500','IPE','100'),('24','13.20','102000','IPE','120'),('25','16.40','127000','IPE','140'),('26','20.10','155000','IPE','160'),('27','23.90','184000','IPE','180'),('28','28.50','220000','IPE','200'),('29','33.40','257000','IPE','220'),('30','39.10','301000','IPE','240'),('31','45.90','354000','IPE','270'),('32','53.80','414000','IPE','300'),('33','62.60','482000','IPE','330'),('34','72.70','560000','IPE','360'),('35','84.50','650000','IPE','400'),('36','98.80','761000','IPE','450'),('37','116.00','890000','IPE','500'),('38','134.00','1040000','IPE','550'),('39','155.00','1197000','IPE','600'),('40','26.00','200000','HEB','100'),('41','34.00','262000','HEB','120'),('42','43.00','331000','HEB','140'),('43','54.30','418000','HEB','160'),('187','22.70','175000','LD','120.80.12'),('700','11.30','8880','ZF','200.3.0'),('701','10.10','7960','ZF','225.2.5'),('702','12.10','9470','ZF','225.3.0'),('703','15.70','12300','ZF','225.4.0'),('704','10.80','8450','ZF','250.2.5'),('705','12.80','10100','ZF','250.3.0'),('706','16.70','13100','ZF','250.4.0'),('707','11.40','8940','ZF','275.2.5'),('708','13.60','10700','ZF','275.3.0'),('709','17.70','13900','ZF','275.4.0'),('710','12.00','9430','ZF','300.2.5'),('711','14.30','11200','ZF','300.3.0'),('712','18.70','14700','ZF','300.4.0'),('713','500.00','43800','Ondulada','0.5'),('714','600.00','52000','Ondulada','0.6'),('715','800.00','70000','Ondulada','0.8'),('716','1000.00','87700','Ondulada','1.0'),('717','1200.00','105000','Ondulada','1.2'),('718','525.00','58900','Grecada','0.5'),('719','630.00','70700','Grecada','0.6'),('720','840.00','94200','Grecada','0.8'),('721','1050.00','118000','Grecada','1.0'),('722','1260.00','141000','Grecada','1.2'),('723','28.30','222','Corrugado','6'),('724','50.30','395','Corrugado','8'),('725','78.50','617','Corrugado','10'),('726','113.00','888','Corrugado','12'),('727','154.00','1210','Corrugado','14'),('728','201.00','1580','Corrugado','16'),('729','314.00','2470','Corrugado','20'),('730','491.00','3850','Corrugado','25'),('731','616.00','4830','Corrugado','28'),('732','804.00','6310','Corrugado','32'),('733','1257.00','9860','Corrugado','40'),('734','1963.00','15400','Corrugado','50')
	;
RETURN 0;
ELSE
RETURN -1;
END IF;


END;
$$;


ALTER FUNCTION sdmed.crear_tabla_aceros() OWNER TO sdmed;

--
-- TOC entry 274 (class 1255 OID 39335)
-- Name: crear_tabla_conceptos(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.crear_tabla_conceptos(codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
cadena text;
BEGIN
EXECUTE format ('CREATE TABLE IF NOT EXISTS %I OF tp_concepto (PRIMARY KEY (codigo))',codigo||'_Conceptos');		
RETURN 0;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -1;
END;
$$;


ALTER FUNCTION sdmed.crear_tabla_conceptos(codigo character varying) OWNER TO sdmed;

--
-- TOC entry 276 (class 1255 OID 39336)
-- Name: crear_tabla_mediciones(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.crear_tabla_mediciones(codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
tablamedicion character varying := codigo||'_Mediciones';
secuencia character varying := tablamedicion||'_id_seq';
BEGIN
EXECUTE format ('CREATE TABLE IF NOT EXISTS %I OF tp_medicion (PRIMARY KEY (id))',tablamedicion);
EXECUTE FORMAT ('CREATE SEQUENCE %I',codigo||'_Mediciones_id_seq');
EXECUTE FORMAT ('ALTER TABLE %I ALTER COLUMN id SET NOT NULL, ALTER COLUMN id SET DEFAULT nextval (''%I''::regclass)',
tablamedicion, secuencia);
RETURN 0;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -3;
END;
$$;


ALTER FUNCTION sdmed.crear_tabla_mediciones(codigo character varying) OWNER TO sdmed;

--
-- TOC entry 278 (class 1255 OID 39337)
-- Name: crear_tabla_propiedades(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.crear_tabla_propiedades(_codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
tablapropiedades character varying := _codigo||'_Propiedades';
secuencia character varying := tablapropiedades||'_id_seq';
valores text[] := '{"Variable", "Tipo", "Valor","Nombre"}';
jsonb_datos_generales text;
jsonb_porcentajes text;
jsonb_proyectista text;
jsonb_direccion_obra text;
jsonb_direccion_ejecucion_obra text;
jsonb_promotor text;
jsonb_constructor text;
jsonb_calculo text;
BEGIN
SELECT generar_json_datos_generales(_codigo,valores) INTO jsonb_datos_generales;
SELECT generar_json_porcentajes(valores) INTO jsonb_porcentajes;
SELECT generar_json_datos_intervinientes('Proyectista', valores) INTO jsonb_proyectista;
SELECT generar_json_datos_intervinientes('Director de obra', valores) INTO jsonb_direccion_obra;
SELECT generar_json_datos_intervinientes('Director de ejecución', valores) INTO jsonb_direccion_ejecucion_obra;
SELECT generar_json_datos_intervinientes('El promotor', valores) INTO jsonb_promotor;
SELECT generar_json_datos_intervinientes('El constructor', valores) INTO jsonb_constructor;

EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_propiedades (PRIMARY KEY (id))',tablapropiedades);
EXECUTE FORMAT ('CREATE SEQUENCE %I',_codigo||'_Propiedades_id_seq');
EXECUTE FORMAT ('ALTER TABLE %I ALTER COLUMN id SET NOT NULL, ALTER COLUMN id SET DEFAULT nextval (''%I''::regclass)', tablapropiedades, secuencia);
EXECUTE FORMAT ('INSERT INTO %I (propiedades) VALUES (%s),(%s),(%s),(%s),(%s),(%s),(%s)',_codigo||'_Propiedades', 
	jsonb_datos_generales,jsonb_porcentajes,jsonb_proyectista,jsonb_direccion_obra,jsonb_direccion_ejecucion_obra,jsonb_promotor,jsonb_constructor);
--antes de seguir, introduzco en la columna familia el valor "Datos generales"
EXECUTE FORMAT ('UPDATE %I SET familia = ''Varios''',tablapropiedades);
--ahora introduzco el registo donde se almacenaran los valores para el calculo
SELECT generar_json_calculo() INTO jsonb_calculo;
EXECUTE FORMAT ('INSERT INTO %I (familia,propiedades) VALUES (''Calculo'',%s)',_codigo||'_Propiedades', jsonb_calculo);


RETURN 0;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -4;
END;
$$;


ALTER FUNCTION sdmed.crear_tabla_propiedades(_codigo character varying) OWNER TO sdmed;

--
-- TOC entry 279 (class 1255 OID 39338)
-- Name: crear_tabla_relacion(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.crear_tabla_relacion(codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying;
secuencia character varying;
BEGIN
tablarelacion := codigo||'_Relacion';
secuencia := tablarelacion||'_id_seq';
EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_relacion (PRIMARY KEY (id))',tablarelacion);
EXECUTE FORMAT ('CREATE SEQUENCE %I',codigo||'_Relacion_id_seq');
EXECUTE FORMAT ('ALTER TABLE %I ALTER COLUMN id SET NOT NULL, ALTER COLUMN id SET DEFAULT nextval (''%I''::regclass)',
tablarelacion, secuencia);
RETURN 0;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -2;
END;
$$;


ALTER FUNCTION sdmed.crear_tabla_relacion(codigo character varying) OWNER TO sdmed;

--
-- TOC entry 336 (class 1255 OID 39448)
-- Name: create_role_if_not_exists(name); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.create_role_if_not_exists(rolename name) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (SELECT * FROM pg_roles WHERE rolname = rolename) THEN
        EXECUTE format('CREATE ROLE %I', rolename);
        RETURN 'CREATE ROLE';
    ELSE
        RETURN format('ROLE ''%I'' ALREADY EXISTS', rolename);
    END IF;
END;
$$;


ALTER FUNCTION sdmed.create_role_if_not_exists(rolename name) OWNER TO sdmed;

--
-- TOC entry 287 (class 1255 OID 39339)
-- Name: es_ancestro(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.es_ancestro(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
r character varying;
hayAncestro boolean;
str_null_case character varying;
tablarelacion character varying;
BEGIN
IF codigopadre IS NULL THEN
	str_null_case := ' IS NULL';
ELSE
	str_null_case := ' = '||quote_literal(codigopadre);
END IF;
hayAncestro = false;
tablarelacion := nombretabla||'_Relacion';
--primera comprobacion, que padre e hijo no sean el mismo codigo
IF codigopadre = codigohijo THEN
	RAISE NOTICE 'el codigo padre es igual al hijo';
RETURN true;
END IF;
FOR r in EXECUTE FORMAT('SELECT codpadre FROM %I WHERE codhijo %s',tablarelacion,str_null_case)
LOOP
	RAISE NOTICE 'Estudio el par : %-%',r,codigohijo;
	IF r = codigohijo THEN
	RAISE NOTICE 'Existe la relacion : %-%',codigopadre,codigohijo;
	hayAncestro =  true;
	RAISE NOTICE 'El ancestro recente es: %',HayAncestro;
	RETURN hayAncestro;	
	ELSE
	hayAncestro =  es_ancestro(nombretabla, r, codigohijo);
	END IF;
END LOOP;
RAISE NOTICE 'El ancestro es: %',hayAncestro;
RETURN hayAncestro;
END;
$$;


ALTER FUNCTION sdmed.es_ancestro(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO sdmed;

--
-- TOC entry 281 (class 1255 OID 39340)
-- Name: es_porcentaje(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.es_porcentaje(_codigo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
resultado boolean;
BEGIN
SELECT _codigo LIKE '%\%%' INTO resultado;
RETURN resultado;
END;
$$;


ALTER FUNCTION sdmed.es_porcentaje(_codigo character varying) OWNER TO sdmed;

--
-- TOC entry 282 (class 1255 OID 39341)
-- Name: es_precio_bloqueado(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.es_precio_bloqueado(nombretabla character varying, codigo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
resultado boolean;
BEGIN
EXECUTE FORMAT ('SELECT preciobloq IS NOT NULL FROM %I WHERE codigo = %s',tablaconceptos,quote_literal(codigo)) INTO resultado;
RETURN resultado;
END;
$$;


ALTER FUNCTION sdmed.es_precio_bloqueado(nombretabla character varying, codigo character varying) OWNER TO sdmed;

--
-- TOC entry 283 (class 1255 OID 39342)
-- Name: establecer_naturaleza(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.establecer_naturaleza(_nombretabla character varying, _codigoapdre character varying, _codigohijo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
--esta funcion establecera la naturaleza en funcion de varios factores, entre otros de la codicacion establecida, que todavia no esta implementada
DECLARE
--tablas
tabla_conceptos character varying := _nombretabla || '_Conceptos';
tabla_relacion character varying := _nombretabla || '_Relacion';
naturaleza integer;
cod character varying;
porcentaje boolean;
BEGIN
--veo si es porcentaje. el porcentaje en principio se pone como material 
porcentaje = (SELECT es_porcentaje(_codigohijo));
IF porcentaje IS TRUE THEN 
	naturaleza = 3;
	RETURN naturaleza;
END IF;
EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE codhijo = %s',tabla_relacion, quote_literal(_codigoapdre)) INTO cod;
IF cod IS NULL THEN --si es nulo es que estamos bajo el raiz y en principio lo que hay son capitulos (6)
	naturaleza = 6;
ELSE--a falta de establecer la codificacion, el resto seran partidas (7)
	naturaleza = 7;
END IF;
RETURN naturaleza;
END;
$$;


ALTER FUNCTION sdmed.establecer_naturaleza(_nombretabla character varying, _codigoapdre character varying, _codigohijo character varying) OWNER TO sdmed;

--
-- TOC entry 350 (class 1255 OID 40550)
-- Name: evaluar_formula(numeric, numeric, numeric, numeric, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.evaluar_formula(_unidad numeric, _longitud numeric, _anchura numeric, _altura numeric, _formula character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
resultado numeric(10,2);
BEGIN
IF _unidad IS NOT NULL THEN
	_formula :=  REPLACE (_formula, 'a', _unidad::character varying);
END IF;
IF _longitud IS NOT NULL THEN
	_formula :=  REPLACE (_formula, 'b', _longitud::character varying);
END IF;
IF _anchura IS NOT NULL THEN	
	_formula :=  REPLACE (_formula, 'c', _anchura::character varying);
END IF;
IF _altura IS NOT NULL THEN
	_formula :=  REPLACE (_formula, 'd', _altura::character varying);
END IF;
_formula :=  REPLACE (_formula, 'PI', 'PI()');
--formateo la expresion annadiendo la palabra SELECT y parentesis de apertura y cierre
_formula := CONCAT(' ' ,'SELECT(',_formula);
_formula := CONCAT(' ',_formula,')');
EXECUTE _formula INTO resultado;
RETURN resultado;
END;
$$;


ALTER FUNCTION sdmed.evaluar_formula(_unidad numeric, _longitud numeric, _anchura numeric, _altura numeric, _formula character varying) OWNER TO sdmed;

--
-- TOC entry 280 (class 1255 OID 39344)
-- Name: existe_codigo(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.existe_codigo(_nombretabla character varying, _codigo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablaconceptos character varying := _nombretabla || '_Conceptos';
existe boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codigo = $1 )', tablaconceptos) USING _codigo INTO existe;
RETURN existe;
END;
$_$;


ALTER FUNCTION sdmed.existe_codigo(_nombretabla character varying, _codigo character varying) OWNER TO sdmed;

--
-- TOC entry 286 (class 1255 OID 39345)
-- Name: existe_hermano(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.existe_hermano(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
--r relacion%ROWTYPE;
r character varying;

BEGIN
RAISE NOTICE 'FUNCION EXISTE HERMANO CON %-%-%',nombretabla,codigopadre,codigohijo;
FOR r in EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE codpadre = %s', nombretabla||'_Relacion', quote_literal(codigopadre))
 LOOP
 	RAISE NOTICE 'Estudio el par : %-%',r,codigohijo;
 	--IF quote_literal(r) = codigohijo THEN
 	IF r = codigohijo THEN
 	RETURN TRUE;
 	END IF;
 END LOOP;
RETURN FALSE;
END;
$$;


ALTER FUNCTION sdmed.existe_hermano(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO sdmed;

--
-- TOC entry 303 (class 1255 OID 53597)
-- Name: existe_obra(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.existe_obra(_obra character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
var_r character varying;
BEGIN
FOR var_r in SELECT ret_codigo FROM ver_obras_bbdd()
LOOP
RAISE NOTICE '%',var_r;
	IF var_r = _obra THEN		
		return True;		 
	END IF;
END LOOP;
RETURN false;
END;
$$;


ALTER FUNCTION sdmed.existe_obra(_obra character varying) OWNER TO sdmed;

--
-- TOC entry 285 (class 1255 OID 39346)
-- Name: exportarbc3(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.exportarbc3(tabla character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
C record;
D record;
M record;
tablaconceptos character varying;
tablarelacion character varying;
tablamedicion character varying;
haydescomposicion boolean;
haymedicion boolean;
salida text;
cadenamedicion text;
BEGIN
cadenamedicion = '';
tablaconceptos := tabla||'_Conceptos';
tablarelacion := tabla||'_Relacion';
tablamedicion := tabla||'_Mediciones';
--REGISTRO C	
FOR C IN EXECUTE FORMAT ('SELECT codigo, ud, resumen, preciomed, fecha, naturaleza,descripcion FROM %I',tablaconceptos)
	LOOP
	salida := concat (salida,'~C|');
	salida := concat(salida,poner_almohadilla(tabla, C.codigo));salida:=concat(salida,'|');
	salida := concat(salida,C.ud);salida:=concat(salida,'|');
	salida := concat(salida,C.resumen);salida:=concat(salida,'|');
	salida := concat(salida,C.preciomed);salida:=concat(salida,'|');
	salida := concat(salida,fecha_a_bc3(C.fecha));salida:=concat(salida,'|');
	salida := concat(salida,C.naturaleza);salida:=concat(salida,'|');
	salida := concat(salida,chr(10));
	--REGISTRO D
	haydescomposicion = hay_descomposicion(tabla,C.codigo);
	IF haydescomposicion IS TRUE THEN
		RAISE INFO 'HAY DESCOMPOSICION EN %', C.codigo;
	    salida := concat (salida,'~D|',poner_almohadilla(tabla, C.codigo),'|');
	END IF;
	FOR D IN EXECUTE FORMAT ('SELECT codhijo, canpres FROM %I WHERE codpadre = %s ORDER BY posicion',tablarelacion, quote_literal(C.codigo))	    
	    LOOP		
		IF haydescomposicion IS TRUE THEN		    		    
		    salida := concat(salida, D.codhijo);salida:=concat(salida,chr(92),'1',chr(92),D.canpres,chr(92));		    
		END IF;
		--AQUI CONSTRUYO LA CADENA DE MEDICION EN CASO DE QUE HAYA
		haymedicion = hay_medcert(tabla,C.codigo,D.codhijo);		
		IF haymedicion IS TRUE THEN
		    cadenamedicion := concat (cadenamedicion,'~M|',poner_almohadilla(tabla, C.codigo),chr(92),D.codhijo,'||',D.canpres,'|');
		    FOR M IN EXECUTE FORMAT('SELECT tipo,comentario,ud,longitud,anchura,altura FROM %I WHERE codpadre = %s AND codhijo = %s AND num_certif = 0',
		    tablamedicion, quote_literal(C.codigo), quote_literal(D.codhijo))
		        LOOP
		            cadenamedicion:=concat(cadenamedicion,M.tipo,'\',M.comentario,'\',M.ud,'\',M.longitud,'\',M.anchura,'\',M.altura,'\');
		        END LOOP;
		    cadenamedicion := concat (cadenamedicion,'|',chr(10));		    
		END IF;
		--FIN DE LA CONSTRUCCION DE LA CADENA DE MEDICION
	    END LOOP;
	IF haydescomposicion IS TRUE THEN
	    salida := concat(salida,'|',chr(10));
	END IF;
	--REGISTRO M	
	IF haymedicion IS TRUE THEN--SI HAY MEDICION AÑADO LA CADENA CREADA ANTERIORMENTE A LA CADENA PRINCIPAL Y LA PONGO A 0
	    salida := concat (salida,cadenamedicion);
	    cadenamedicion := '';	   
	END IF;	
	--REGISTRO T
	raise notice 'texto: %',C.descripcion;
	IF (C.descripcion <> '') IS TRUE THEN
	    salida := concat(salida,'~T|',C.codigo,'|',C.descripcion,'|',chr(10));
	END IF;
	END LOOP;
RAISE NOTICE 'salida %',salida;
RETURN salida;
END;
$$;


ALTER FUNCTION sdmed.exportarbc3(tabla character varying) OWNER TO sdmed;

--
-- TOC entry 284 (class 1255 OID 39347)
-- Name: fecha_a_bc3(date); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.fecha_a_bc3(fecha date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
fechabc3 character varying;
dia character varying;
mes character varying;
anno character varying;
BEGIN
fechabc3 := fecha::character varying;
dia := substring(fechabc3 from 9 for 2);
mes := substring(fechabc3 from 6 for 2);
anno := substring(fechabc3 from 1 for 4);
fechabc3 := concat(dia,mes,anno);
RETURN fechabc3;
END;
$$;


ALTER FUNCTION sdmed.fecha_a_bc3(fecha date) OWNER TO sdmed;

--
-- TOC entry 288 (class 1255 OID 39348)
-- Name: fx_letras(numeric); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.fx_letras(numero numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  e TEXT;
  n bigint;
  
BEGIN

n:=TRUNC(numero,0);
--n2:=PARSENAME(numero,1);

WITH Below20(Word, Id) AS
  (
    VALUES
      ('Cero', 0), ('Un', 1),( 'Dos', 2 ), ( 'Tres', 3),
      ( 'Cuatro', 4 ), ( 'Cinco', 5 ), ( 'Seis', 6 ), ( 'Siete', 7 ),
      ( 'Ocho', 8), ( 'Nueve', 9), ( 'Diez', 10), ( 'Once', 11 ),
      ( 'Doce', 12 ), ( 'Trece', 13 ), ( 'Catorce', 14),
      ( 'Quince', 15 ), ('Dieciséis', 16 ), ( 'Diecisiete', 17),
      ('Dieciocho', 18 ), ( 'Diecinueve', 19 ), ( 'Veinte', 20 )
   ),
   Below100(Word, Id) AS
   (
      VALUES
       ('Veinti', 2), ('Treinta', 3),('Cuarenta', 4), ('Cincuenta', 5),
       ('Sesenta', 6), ('Setenta', 7), ('Ochenta', 8), ('Noventa', 9) , ('Cien',100), ('Quinientos ',500)
   )
   SELECT
     CASE
	WHEN n = 0 THEN  ''
	WHEN n BETWEEN 1 AND 20 THEN (SELECT Word FROM Below20 WHERE ID=n)
	WHEN n BETWEEN 21 AND 99 THEN (SELECT Word FROM Below100 WHERE ID=n/10) || (case when (n>29 AND n % 10 > 0) THEN ' y ' else '' end) || fx_letras( n % 10)
	WHEN n = 100 THEN (SELECT Word FROM Below100 WHERE ID=n)
	WHEN (n BETWEEN 101 AND 499 OR n BETWEEN 600 AND 999) THEN (case when n>199 THEN (fx_letras( n / 100)) else '' end) ||  case when n>199 then 'cientos ' else 'Ciento ' end || fx_letras( n % 100)
	WHEN n BETWEEN 500 AND 599 THEN (SELECT Word FROM Below100 WHERE ID=(n-n%100)) || fx_letras(n % 100)
	WHEN n BETWEEN 1000 AND 999999 THEN (case when n>1999 THEN (fx_letras( n / 1000)) else '' end) || ' Mil ' || fx_letras( n % 1000)
	WHEN n BETWEEN 1000000 AND 999999999 THEN (fx_letras( n / 1000000)) || case when n> 1999999 then ' Millones ' else ' Millón ' end || fx_letras( n % 1000000)
	WHEN n BETWEEN 1000000000 AND 999999999999 THEN (case when n>1999999999 THEN (fx_letras( n / 1000000000)) else '' end) || ' Mil ' || fx_letras( n % 1000000000)
	WHEN n BETWEEN 1000000000000 AND 999999999999999 THEN (fx_letras( n / 1000000000000)) || case when n> 1999999999999 then  ' Billones ' else ' Billón ' end  || fx_letras( n % 1000000000000)	
	
     ELSE ' INVALID INPUT' END INTO e;

  e := RTRIM(e);

  IF RIGHT(e,1)='-' THEN
    e := RTRIM(LEFT(e,length(e)-1));
  END IF;
--ajustes finales
e := replace (e,'Nuevecientos','Novecientos');
e := replace (e,'Sietecientos','Setecientos');

  RETURN e;
END;
$$;


ALTER FUNCTION sdmed.fx_letras(numero numeric) OWNER TO sdmed;

--
-- TOC entry 291 (class 1255 OID 39349)
-- Name: generar_json_calculo(); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.generar_json_calculo() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
cadena_jsonb text := '';
coste_indirecto character varying := 0;
BEGIN
--cadena inicial
cadena_jsonb = CONCAT (cadena_jsonb, '''{"Propiedad" : "Costes indirectos" , "Valor" : "');
cadena_jsonb = CONCAT(cadena_jsonb,coste_indirecto);
cadena_jsonb = CONCAT (cadena_jsonb, '"}''');
--RAISE INFO  '%', cadena_jsonb;
RETURN cadena_jsonb;
END;
$$;


ALTER FUNCTION sdmed.generar_json_calculo() OWNER TO sdmed;

--
-- TOC entry 267 (class 1255 OID 39350)
-- Name: generar_json_datos_generales(character varying, text[]); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.generar_json_datos_generales(_nombretabla character varying, _valores text[]) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
cadena_jsonb text := '';
variables text[] := '{"zRaíz","zNombre","zLibDenominación","zDivisa","zDirección","zCiudad","zProvincia","zCPostal","zPaís","zComentario1","zComentario2","zComentario3","zTeléfono","zTeléfono2","zComentario4","zFax","zCorreo"}';
nombres text[] := '{"Código del concepto raíz","Nombre completo de la obra","Denominación específica","Divisa general de la obra","Dirección de la obra","Ciudad de la obra","Provincia de la obra","Código Postal de la obra","País de la obra","Comentario 1","Comentario 2","Comentario 3","Comentario 4","Teléfono principal de la obra","Teléfono secundario de la obra","Fax de la obra","Correo electrónico de la obra"}';
nombre_completo text;
divisa character varying;
tablaconceptos character varying := _nombretabla || '_Conceptos';
valor text[];
j integer := 1;
tam_array_valores integer;

BEGIN
--relleno el array valor con los tres valores iniciales de la obra, (codigo, nombre y divisa) y el resto con cadenas vacías
EXECUTE FORMAT ('SELECT resumen FROM %I WHERE codigo = $1',tablaconceptos) USING _nombretabla INTO nombre_completo;
valor := array_append(valor, '"'|| _nombretabla ||'"');--codigo
valor := array_append(valor, '"'|| nombre_completo ||'"');--nombre completo de la obra
valor := array_append(valor, '""');--denominacion especifica
valor := array_append(valor,'"EUR"');--divisa
FOR i IN 4 .. array_upper(variables,1) LOOP
	valor := array_append(valor,'""');--resto de valores
END LOOP;


--RAISE NOTICE 'nombre completo: % ', nombre_completo;
--cadena inicial
cadena_jsonb = CONCAT (cadena_jsonb, '''{"Propiedad" : "Datos generales" , "Valor" : [{"');
SELECT array_length(_valores, 1) INTO tam_array_valores;
FOR i IN array_lower(variables,1) .. array_upper(variables,1) LOOP	
		cadena_jsonb = CONCAT (cadena_jsonb, _valores[j],'" : "');
		cadena_jsonb = CONCAT (cadena_jsonb, variables[i],'" , "');
		j=j+1;
		cadena_jsonb = CONCAT (cadena_jsonb, _valores[j],'" : "');
		cadena_jsonb = CONCAT (cadena_jsonb, 'A','" , "');
		j=j+1;
		cadena_jsonb = CONCAT (cadena_jsonb, _valores[j],'" : ');
		cadena_jsonb = CONCAT (cadena_jsonb, valor[i],' , "');
		j=j+1;
		cadena_jsonb = CONCAT (cadena_jsonb, _valores[j],'" : "');
		cadena_jsonb = CONCAT (cadena_jsonb, nombres[i]);		
		IF (i < array_length(variables,1)) THEN
			cadena_jsonb = CONCAT (cadena_jsonb,'"},{"');
		END IF;		
		j=1;					
END LOOP;
--cadena final
cadena_jsonb = CONCAT (cadena_jsonb, '"}]}''');
--RAISE INFO  '%', cadena_jsonb;
RETURN cadena_jsonb;
END;
$_$;


ALTER FUNCTION sdmed.generar_json_datos_generales(_nombretabla character varying, _valores text[]) OWNER TO sdmed;

--
-- TOC entry 290 (class 1255 OID 39351)
-- Name: generar_json_datos_intervinientes(character varying, text[]); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.generar_json_datos_intervinientes(_interviniente character varying, _valores text[]) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
cadena_jsonb text := '';
variables text[];
nombres text[];
valor text[];
j integer := 1;
tam_array_valores integer;
prefijo character varying;
sufijo character varying;
primer_valor character varying;

BEGIN
--hallo el prefijo, sufijo y primer valor
IF _interviniente = 'Proyectista' THEN
	prefijo := 'Pry';
	sufijo := 'del proyectista';
	primer_valor :='El redactor del proyecto';
ELSIF _interviniente = 'Director de obra' THEN
	prefijo := 'Dir';
	sufijo := 'de la dirección de obra';
	primer_valor :='La dirección facultativa';
ELSIF _interviniente = 'Director de ejecución' THEN
	prefijo := 'Deo';
	sufijo := 'del director de la ejecución de la obra';
	primer_valor :='La dirección facultativa';
ELSIF _interviniente = 'El promotor' THEN
	prefijo := 'Pro';
	sufijo := 'del promotor';
	primer_valor :='El promotor';
ELSIF _interviniente = 'El constructor' THEN
	prefijo := 'Con';
	sufijo := 'de la empresa constructora';
	primer_valor :='La empresa constructora';
END IF;
--defino arrays
variables := FORMAT('{"z%sEncabezamiento","z%sNombre1","z%sNombre2","z%sDirección","z%sCiudad","z%sProvincia","z%sCPostal","z%sPaís","z%sTeléfono","z%sTeléfono2","z%sFax","z%sCorreo","z%sNIF"}',prefijo,prefijo,prefijo,prefijo,prefijo,prefijo,prefijo,prefijo,prefijo,prefijo,prefijo,prefijo,prefijo);
nombres := FORMAT('{"Encabezamiento %s","Nombre 1 %s","Nombre 2 %s","Dirección %s","Ciudad %s","Provincia %s","Código postal %s","País %s","Teléfono 1 %s","Teléfono 2 %s","Fax %s","Correo electrónico %s","NIF %s"}',sufijo,sufijo,sufijo,sufijo,sufijo,sufijo,sufijo,sufijo,sufijo,sufijo,sufijo,sufijo,sufijo);
--relleno el array valor con el primer valor estandar 
valor := array_append(valor,FORMAT(quote_ident('%s'),primer_valor));
FOR i IN 2 .. array_upper(variables,1) LOOP
	valor := array_append(valor,'""');--resto de valores
END LOOP;
--cadena inicial
cadena_jsonb = FORMAT(CONCAT (cadena_jsonb, '''{"Propiedad" : %s , "Valor" : [{"'),quote_ident(_interviniente));
SELECT array_length(_valores, 1) INTO tam_array_valores;
FOR i IN array_lower(variables,1) .. array_upper(variables,1) LOOP	
		cadena_jsonb = CONCAT (cadena_jsonb, _valores[j],'" : "');
		cadena_jsonb = CONCAT (cadena_jsonb, variables[i],'" , "');
		j=j+1;
		cadena_jsonb = CONCAT (cadena_jsonb, _valores[j],'" : "');
		cadena_jsonb = CONCAT (cadena_jsonb, 'A','" , "');
		j=j+1;
		cadena_jsonb = CONCAT (cadena_jsonb, _valores[j],'" : ');
		cadena_jsonb = CONCAT (cadena_jsonb, valor[i],' , "');
		j=j+1;
		cadena_jsonb = CONCAT (cadena_jsonb, _valores[j],'" : "');
		cadena_jsonb = CONCAT (cadena_jsonb, nombres[i]);		
		IF (i < array_length(variables,1)) THEN
			cadena_jsonb = CONCAT (cadena_jsonb,'"},{"');
		END IF;		
		j=1;					
END LOOP;
--cadena final
cadena_jsonb = CONCAT (cadena_jsonb, '"}]}''');
--RAISE INFO  '%', cadena_jsonb;
RETURN cadena_jsonb;
END;
$$;


ALTER FUNCTION sdmed.generar_json_datos_intervinientes(_interviniente character varying, _valores text[]) OWNER TO sdmed;

--
-- TOC entry 355 (class 1255 OID 39352)
-- Name: generar_json_porcentajes(text[]); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.generar_json_porcentajes(valores text[]) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
cadena_jsonb text := '';
--valores text[] := '{"Variable", "Tipo", "Valor","Nombre"}';
variables text[] := '{"zPorGastosGenerales","zPorBenIndustrial","zPorIVAEjecucion","zPorIVAHonorarios","zPorRetCliente","zPorRetFiscal","zPorHonProyecto","zPorHonDireccion1","zPorHonDireccion2"}';
nombres text[] := '{"Porcentaje de gastos generales","Porcentaje de beneficio industrial","Porcentaje de IVA sobre ejecución material","Porcentaje de IVA sobre honorarios","Porcentaje de retención del cliente","Porcentaje de retención fiscal (IRPF)","Porcentaje de honorarios de proyecto","Porcentaje de honorarios de dirección 1","Porcentaje de honorarios de dirección 2"}';
valor smallint[] := '{13,6,21,21,0,0,0,0,0}';
j integer := 1;
tam_array_valores integer := 0;
BEGIN
--cadena inicial
cadena_jsonb = CONCAT (cadena_jsonb, '''{"Propiedad" : "Porcentajes" , "Valor" : [{"');
SELECT array_length(valores, 1) INTO tam_array_valores;
FOR i IN array_lower(variables,1) .. array_upper(variables,1) LOOP	
		cadena_jsonb = CONCAT (cadena_jsonb, valores[j],'" : "');
		cadena_jsonb = CONCAT (cadena_jsonb, variables[i],'" , "');
		j=j+1;
		cadena_jsonb = CONCAT (cadena_jsonb, valores[j],'" : "');
		cadena_jsonb = CONCAT (cadena_jsonb, 'N','" , "');
		j=j+1;
		cadena_jsonb = CONCAT (cadena_jsonb, valores[j],'" : ');
		cadena_jsonb = CONCAT (cadena_jsonb, valor[i],' , "');
		j=j+1;
		cadena_jsonb = CONCAT (cadena_jsonb, valores[j],'" : "');
		cadena_jsonb = CONCAT (cadena_jsonb, nombres[i]);		
		IF (i < array_length(variables,1)) THEN
			cadena_jsonb = CONCAT (cadena_jsonb,'"},{"');
		END IF;		
		j=1;					
END LOOP;
--cadena final
cadena_jsonb = CONCAT (cadena_jsonb, '"}]}''');
--RAISE INFO  '%', cadena_jsonb;
RETURN cadena_jsonb;
END;
$$;


ALTER FUNCTION sdmed.generar_json_porcentajes(valores text[]) OWNER TO sdmed;

--
-- TOC entry 289 (class 1255 OID 39353)
-- Name: hallar_cantidad_porcentaje(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.hallar_cantidad_porcentaje(_nombretabla character varying, _codigopadre character varying, _codigoporcentaje character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
var_r record;
str_null_case character varying;
tablarelacion character varying := _nombretabla||'_Relacion';
tablaconceptos character varying := _nombretabla||'_Conceptos';
posicion smallint = 0;
canpres numeric (7,3) := 0;
coincide_patron boolean;
precio numeric;
BEGIN
IF _codigopadre IS NULL THEN
	str_null_case := ' IS NULL';
ELSE
	str_null_case := ' = '||quote_literal(_codigopadre);
END IF;
--HALLO LA POSCICION DEL NODO CON PORCENTAJE DENTRO DE LOS HIJOS DEL NODO PADRE
EXECUTE FORMAT ('SELECT posicion FROM %I WHERE codpadre %s AND codhijo = $1',tablarelacion, str_null_case) USING _codigoporcentaje INTO posicion;
--RECORRO LOS HIJOS DEL NODO DADO ANTERIORES AL NODO CON PORCENTAJE. SI ALGUNO PERTENECE AL PATRON DEL PORCENTAJE, SE SUMA SU IMPORTE
FOR var_r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre %s AND posicion < $1', tablarelacion, str_null_case) USING posicion
		LOOP			
			EXECUTE FORMAT ('SELECT $1 LIKE substring ($2 FROM 0 FOR position (%L in $2)+1)','%') USING var_r.codhijo, _codigoporcentaje INTO coincide_patron;
			IF coincide_patron IS TRUE THEN			
				precio = (SELECT ver_precio(_nombretabla,var_r.codhijo));
				canpres = canpres + (var_r.canpres*precio);							
			END IF;			
		END LOOP;
RETURN canpres/100;
END;
$_$;


ALTER FUNCTION sdmed.hallar_cantidad_porcentaje(_nombretabla character varying, _codigopadre character varying, _codigoporcentaje character varying) OWNER TO sdmed;

--
-- TOC entry 292 (class 1255 OID 39354)
-- Name: hay_certificacion(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.hay_certificacion(_nombretabla character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$ 
DECLARE
tablacertificacion character varying := _nombretabla || '_ListadoCertificaciones';
existe boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablacertificacion) INTO existe;
IF existe = false THEN
	RETURN existe;
ELSE
	EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I)', tablacertificacion) INTO existe;
END IF;
RETURN existe;
END;
$$;


ALTER FUNCTION sdmed.hay_certificacion(_nombretabla character varying) OWNER TO sdmed;

--
-- TOC entry 293 (class 1255 OID 39355)
-- Name: hay_descomposicion(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.hay_descomposicion(_nombretabla character varying, _codigo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying := _nombretabla || '_Relacion';
resultado boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codpadre = %L )',tablarelacion , _codigo) INTO resultado;
RETURN resultado;
END;
$$;


ALTER FUNCTION sdmed.hay_descomposicion(_nombretabla character varying, _codigo character varying) OWNER TO sdmed;

--
-- TOC entry 294 (class 1255 OID 39356)
-- Name: hay_medcert(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.hay_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _tipocandidad integer DEFAULT 0) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablamedcert character varying := _nombretabla||'_Mediciones';
cadenanumcert character varying;
resultado boolean;
--tipocantidad hace referencia a si hablamos de la cantidad presupuestada (canpres) o certificada (cancert) y en funcion de eso buscaremos las 
--lineas de medicion que tengan el num_certif = 0 (las de medicion) o las que sean mayores a esta (las de certificacion)
BEGIN
IF _tipocandidad = 0 THEN 
    cadenanumcert = '= 0';
ELSE
    cadenanumcert = '> 0';
END IF;
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif %s)', tablamedcert, cadenanumcert)
	INTO resultado
	USING _codigopadre, _codigohijo;
RETURN resultado;
END;
$_$;


ALTER FUNCTION sdmed.hay_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _tipocandidad integer) OWNER TO sdmed;

--
-- TOC entry 295 (class 1255 OID 39357)
-- Name: id_por_posicion(character varying, character varying, character varying, integer, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.id_por_posicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _posicion integer, _num_cert integer DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
tablamedcert character varying := _nombretabla || '_Mediciones';
idseleccionado integer;

BEGIN
EXECUTE FORMAT ('SELECT id FROM %I WHERE codpadre = $1 AND codhijo = $2 AND posicion = $3 AND num_certif = $4',tablamedcert) INTO idseleccionado 
	USING _codigopadre,_codigohijo, _posicion, _num_cert;
RETURN idseleccionado;
END;
$_$;


ALTER FUNCTION sdmed.id_por_posicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _posicion integer, _num_cert integer) OWNER TO sdmed;

--
-- TOC entry 313 (class 1255 OID 77575)
-- Name: importar_bc3_copy(character varying, character varying, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.importar_bc3_copy(
    _nombretabla character varying,
    _ruta character varying,
    _tipotabla integer)
  RETURNS boolean AS
$BODY$
DECLARE
tabla character varying;
texto text;
BEGIN
	IF _tipotabla = 1 THEN 
		tabla = _nombretabla || '_Conceptos';
	ELSIF _tipotabla = 2 THEN 
		tabla = _nombretabla || '_Relacion';
	END IF;
	--texto = FORMAT ('COPY sdmed.%I FROM %s WITH CSV DELIMITER %s NULL AS ''NULL'' QUOTE %s ESCAPE %s', 
	texto = FORMAT ('COPY sdmed.%I FROM %s WITH CSV DELIMITER %s NULL AS ''NULL'' QUOTE ''"'' ESCAPE ''\'' ', 
	tabla, 
	quote_literal(_ruta), 
	quote_literal(chr(9)))
	--quote_nullable(null),
	--quote_literal (34)
	--quote_literal (92)
	;
	execute (texto);
	RETURN TRUE;
	EXCEPTION
		WHEN others THEN
		RAISE NOTICE '%; SQLSTATE: %', SQLERRM, SQLSTATE; 
		RETURN FALSE;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION sdmed.importar_bc3_copy(character varying, character varying, integer) OWNER TO sdmed;

--
-- TOC entry 353 (class 1255 OID 39358)
-- Name: insertar_concepto(character varying, character varying, character varying, character varying, text, numeric, integer, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_concepto(nombretabla character varying, codigopadre character varying, u character varying DEFAULT ''::character varying, resumen character varying DEFAULT ''::character varying, texto text DEFAULT ''::text, precio numeric DEFAULT 0, nat integer DEFAULT 7, fecha character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$

DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
--fecha date;
existe boolean;

BEGIN
--fecha = procesar_cadena_fecha(fec);
EXECUTE FORMAT ('SELECT NOT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)', tablaconceptos, codigopadre) INTO existe;
IF existe = TRUE THEN
EXECUTE FORMAT ('INSERT INTO %I (codigo,ud,resumen,descripcion,descripcionhtml,preciomed,preciocert,naturaleza,fecha) VALUES
		($1,$2,$3,$4,$4,$5,$6,$7,$8)',tablaconceptos)
		USING		
		codigopadre,
		u,
		resumen,
		texto,		
		precio,
		precio,
		nat,	
		procesar_cadena_fecha(fecha);
END IF;
END;
$_$;


ALTER FUNCTION sdmed.insertar_concepto(nombretabla character varying, codigopadre character varying, u character varying, resumen character varying, texto text, precio numeric, nat integer, fecha character varying) OWNER TO sdmed;

--
-- TOC entry 354 (class 1255 OID 39359)
-- Name: insertar_lineas_medcert(character varying, character varying, character varying, integer, integer, integer, integer, character varying, numeric, numeric, numeric, numeric, character varying, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_lineas integer DEFAULT 1, _posicion integer DEFAULT (- (1)::smallint), _num_cert integer DEFAULT 0, _tipo integer DEFAULT NULL::integer, _comentario character varying DEFAULT NULL::character varying, _ud numeric DEFAULT (0)::numeric, _longitud numeric DEFAULT (0)::numeric, _anchura numeric DEFAULT (0)::numeric, _altura numeric DEFAULT (0)::numeric, _formula character varying DEFAULT NULL::character varying, _idfila integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablamedcert character varying :=_nombretabla || '_Mediciones';
nuevaid integer;
r record;
formula character varying;
BEGIN
--defino el tipo si hay formula en caso de no tener el tipo definido
IF _tipo IS NULL THEN
	IF _formula!= 'NULL' THEN _tipo = 3; END IF;
END IF;
--en caso de BC3 y tipo 3 (formula) paso el campo de comentario a formula
IF _tipo = 3 AND (_formula <> '') IS NOT TRUE THEN--formula	
	formula = _comentario;
ELSE
	formula = _formula;
END IF;
--tratamos el comentario
IF _comentario = 'NULL' THEN _comentario = ''; END IF;
--iteramos por cada linea insertada (_num_lineas)
FOR i IN 1.._num_lineas LOOP
--ahora ordenar las lineas
FOR r IN EXECUTE FORMAT ('SELECT * FROM ver_medcert(%L,%L,%L,%L)', _nombretabla,_codigopadre,_codigohijo,_num_cert)
LOOP
	IF r.pos>=_posicion THEN
		EXECUTE FORMAT ('UPDATE %I SET posicion = posicion+1 WHERE id = $1', tablamedcert)
		USING r.id;
	END IF;
END LOOP;
--RAISE NOTICE 'INSERTAR EN % LA UD: %, LA LONGITUD %, LA ANCHURA % Y LA ALTURA %', tablamediciones, ud,longitud,anchura,altura;
EXECUTE FORMAT ('INSERT INTO %I (comentario,ud,longitud,anchura,altura,formula,tipo,codpadre,codhijo,posicion,num_certif)
	VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)',tablamedcert)
USING 
_comentario,
_ud,
_longitud,
_anchura,
_altura,
formula, --la formula es un poco diferente (ver arriba) porque en caso de BC3 hay que cogerla del campo de comentario
_tipo,
_codigopadre,
_codigohijo,
_posicion,
_num_cert
;

END LOOP;
PERFORM modificar_cantidad(_nombretabla,_codigopadre,_codigohijo,_num_cert);
--ahora hallo la id de la linea recien insertada
EXECUTE FORMAT ('SELECT MAX(id) FROM %I',tablamedcert) INTO nuevaid;
RETURN nuevaid;
END;
$_$;


ALTER FUNCTION sdmed.insertar_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_lineas integer, _posicion integer, _num_cert integer, _tipo integer, _comentario character varying, _ud numeric, _longitud numeric, _anchura numeric, _altura numeric, _formula character varying, _idfila integer) OWNER TO sdmed;

--
-- TOC entry 345 (class 1255 OID 39360)
-- Name: insertar_partida(character varying, character varying, character varying, smallint, numeric, character varying, character varying, text, numeric, integer, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_partida(nombretabla character varying, codigopadre character varying, codigohijo character varying, pos smallint DEFAULT (- (1)::smallint), cantidad numeric DEFAULT 1, u character varying DEFAULT ''::character varying, res character varying DEFAULT ''::character varying, texto text DEFAULT ''::text, precio numeric DEFAULT 0, nat integer DEFAULT 7, fec character varying DEFAULT ''::character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
fechapartida DATE;
eshermano boolean := false;
esancestro boolean := false;
existe boolean;
tablaconceptos character varying := nombretabla||'_Conceptos';
tablarelacion character varying := nombretabla || '_Relacion';
naturaleza integer DEFAULT 7;
BEGIN
-- lo primero es ver si el hijo ya existe. Si no existe, annadimos el nuevo concepto y su relacion, sin hacer mas comprobaciones
EXECUTE FORMAT ('SELECT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)',tablaconceptos,codigohijo) INTO existe;
IF (existe is FALSE) THEN --si es NULL es que no existe
	RAISE NOTICE 'Creo e inserto nuevo nodo';
	--creo el nuevo concepto (nodo)
	--hallo la naturaleza del codigo
	EXECUTE FORMAT ('SELECT establecer_naturaleza($1,$2,$3)') 
	    USING
	    nombretabla,
	    codigopadre,
	    codigohijo
	    INTO naturaleza;
	EXECUTE FORMAT ('SELECT insertar_concepto($1, $2, $3, $4, $5, $6, $7, $8)') USING nombretabla, codigohijo, u, res, texto, precio, naturaleza, fec;
		
ELSE  --si ya existe hay que hacer comprobaciones de si es padre o referencia circular. Si ocurre alguna
	--de estas dos cosas salimos de la funcion con codigo de error
	--primera comprobacion. Que no exista ya esl codigo bajo ese padre, es decir, que no haya un hermano
	--RAISE NOTICE 'COMPROBAR HERMANOS';
	EXECUTE FORMAT ('SELECT existe_hermano($1,$2,$3)')
	USING
	nombretabla,
	codigopadre,
	codigohijo
	INTO eshermano;	
	IF eshermano IS TRUE
		THEN RAISE NOTICE 'El codigo % ya tiene un codigo hijo = a %',codigopadre,codigohijo;
		RETURN 1;
	--segunda comprobacion, si no es hermano comprobamos que no haya un ancestro directo con el mcismo codigo
	ELSE
	    EXECUTE FORMAT ('SELECT es_ancestro($1,$2,$3)') 
	    USING
	    nombretabla,
	    codigopadre,
	    codigohijo
	    INTO esancestro;
	    IF esancestro IS TRUE	    
		THEN RAISE NOTICE 'Hay referencia circular';
		RETURN 2;
	    END IF;
	END IF;
END IF;
--RAISE NOTICE 'HE LLEGADO HASTA AQUI y voy con la cantidad: %',cantidad;
PERFORM insertar_relacion(nombretabla, codigopadre, codigohijo, cantidad, pos);
PERFORM actualizar_desde_nodo(nombretabla,codigopadre);
RETURN 0;
END;
$_$;


ALTER FUNCTION sdmed.insertar_partida(nombretabla character varying, codigopadre character varying, codigohijo character varying, pos smallint, cantidad numeric, u character varying, res character varying, texto text, precio numeric, nat integer, fec character varying) OWNER TO sdmed;

--
-- TOC entry 296 (class 1255 OID 39361)
-- Name: insertar_registro_guardarconcepto(character varying, integer, sdmed.tp_concepto); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_registro_guardarconcepto(_nombretabla character varying, _paso integer, _dato sdmed.tp_concepto) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES
	(CASE WHEN (SELECT MAX(idguardar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idguardar)+1 FROM %I) END,$1,$2)',_nombretabla,_nombretabla,_nombretabla) USING
	_paso,	
	_dato
	;
END;
$_$;


ALTER FUNCTION sdmed.insertar_registro_guardarconcepto(_nombretabla character varying, _paso integer, _dato sdmed.tp_concepto) OWNER TO sdmed;

--
-- TOC entry 297 (class 1255 OID 39362)
-- Name: insertar_registro_guardarmedicion(character varying, integer, sdmed.tp_medicion); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_registro_guardarmedicion(_nombretabla character varying, _paso integer, _dato sdmed.tp_medicion) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES
        (CASE WHEN (SELECT MAX(idguardar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idguardar)+1 FROM %I) END, $1, $2)',_nombretabla,_nombretabla,_nombretabla)
	USING 
	_paso,        
        _dato;  
END;
$_$;


ALTER FUNCTION sdmed.insertar_registro_guardarmedicion(_nombretabla character varying, _paso integer, _dato sdmed.tp_medicion) OWNER TO sdmed;

--
-- TOC entry 337 (class 1255 OID 39890)
-- Name: insertar_registro_guardarrelacion(character varying, integer, sdmed.tp_relacion); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_registro_guardarrelacion(_nombretabla character varying, _paso integer, _dato sdmed.tp_relacion) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES(
	CASE WHEN (SELECT MAX(idguardar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idguardar)+1 FROM %I) END,$1,$2)',_nombretabla,_nombretabla,_nombretabla) USING
	_paso,	
	_dato;	
END;
$_$;


ALTER FUNCTION sdmed.insertar_registro_guardarrelacion(_nombretabla character varying, _paso integer, _dato sdmed.tp_relacion) OWNER TO sdmed;

--
-- TOC entry 339 (class 1255 OID 39891)
-- Name: insertar_registro_relacion(character varying, integer, sdmed.tp_relacion); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_registro_relacion(_nombretabla character varying, _paso integer, _dato sdmed.tp_relacion) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES(
	CASE WHEN (SELECT MAX(idborrar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idborrar)+1 FROM %I) END,
	%L,
	(%L,%L,%L,%L,%L,%L,%L))',_nombretabla,_nombretabla,_nombretabla,
	_paso,
	_dato.id,
	_dato.codpadre,
	_dato.codhijo,
	_dato.canpres,
	COALESCE(_dato.cancert,0),
	_dato.posicion,
	_dato.nivel
	);
END;
$$;


ALTER FUNCTION sdmed.insertar_registro_relacion(_nombretabla character varying, _paso integer, _dato sdmed.tp_relacion) OWNER TO sdmed;

--
-- TOC entry 298 (class 1255 OID 39365)
-- Name: insertar_relacion(character varying, character varying, character varying, numeric, smallint); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_relacion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _cantidad numeric, _pos smallint) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
r record;
tablarelacion character varying := _nombretabla||'_Relacion';
nivel smallint;
esporcentaje boolean := false;
canpres numeric(13,3) := 0;
cancert numeric(13,3) := 0;
posicion smallint;
BEGIN
canpres = _cantidad;
cancert = _cantidad;
--hallo el nivel del codigo padre
EXECUTE FORMAT ('SELECT nivel FROM %I WHERE codhijo = $1', tablarelacion) USING _codigopadre INTO nivel;
IF nivel IS NULL THEN nivel = 0; END IF;
--RAISE NOTICE 'insertar_relacion con % - % en la posicion: % y cantidad: %',codigopadre,codigohijo,pos,cantidad;
EXECUTE FORMAT ('INSERT INTO %I (codpadre,codhijo,canpres,cancert,posicion,nivel) VALUES($1,$2,$3,$4,$5,$6)', tablarelacion)
USING 
_codigopadre,
_codigohijo,
canpres,
cancert,
_pos,
nivel+1;
--ahora ordeno los hijos
IF _pos = -1 THEN	
	EXECUTE FORMAT ('UPDATE %I SET posicion = (SELECT MAX(posicion)+1 FROM %I WHERE codpadre = $1) WHERE codpadre = $2 AND codhijo = $3',
	tablarelacion,tablarelacion)
	USING
	_codigopadre,
	_codigopadre,
	_codigohijo;		 
ELSE 
	FOR r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = %L', tablarelacion, _codigopadre)
		LOOP
			--RAISE NOTICE 'Listado: %- %- %- % - %', r.id, r.codpadre, r.codhijo, r.canpres, r.posicion;
			IF(r.posicion>=_pos AND r.codhijo!=_codigohijo) THEN
				EXECUTE FORMAT ('UPDATE %I SET posicion = %I.posicion+1 WHERE codpadre = $1 AND codhijo = $2', tablarelacion, tablarelacion)
				USING _codigopadre, r.codhijo;				
			END IF;
		END LOOP;
END IF;
--DESPUES DE INSERTAR LA RELACION, COMPRUEBO SI ES UN PORCENTAJE Y ESTABLEZCO SU PRECIO
EXECUTE FORMAT ('SELECT es_porcentaje($1)')
	USING
	_codigohijo
	INTO esporcentaje;
IF esporcentaje IS TRUE THEN
	--RAISE NOTICE 'El codigo % es porcentaje',_codigohijo;	
	--EXECUTE FORMAT ('SELECT posicion FROM %I WHERE codpadre = $1 AND codhijo = $2',tablarelacion) USING _codigopadre,_codigohijo INTO posicion;
	--RAISE NOTICE 'La posicion es: %',posicion;
	--EXECUTE FORMAT ('SELECT SUM(canpres) FROM %I WHERE codpadre = $1 AND codhijo = $2 AND posicion < $3',tablarelacion) USING _codigopadre,_codigohijo,posicion INTO canpres;
	/*canpres = 0;
	FOR r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = %L', tablarelacion, _codigopadre)
		LOOP
		IF r.posicion < posicion THEN
			canpres = canpres + r.canpres;
		END IF;
		END LOOP;	
	canpres = -1;*/
	canpres = (SELECT hallar_cantidad_porcentaje(_nombretabla,_codigopadre,_codigohijo));
	EXECUTE FORMAT ('UPDATE %I SET canpres = $1 WHERE codpadre = $2 AND codhijo = $3',tablarelacion) USING canpres,_codigopadre,_codigohijo;
	
END IF;
END;
$_$;


ALTER FUNCTION sdmed.insertar_relacion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _cantidad numeric, _pos smallint) OWNER TO sdmed;

--
-- TOC entry 300 (class 1255 OID 39366)
-- Name: insertar_texto(character varying, character varying, text); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_texto(_nombretabla character varying, _cod character varying, _texto text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
BEGIN
EXECUTE FORMAT ('UPDATE %I SET descripcion = %L WHERE codigo = %L',tablaconceptos,_texto,_cod);
EXECUTE FORMAT ('UPDATE %I SET descripcionhtml = %L WHERE codigo = %L',tablaconceptos,_texto,_cod);

END;
$$;


ALTER FUNCTION sdmed.insertar_texto(_nombretabla character varying, _cod character varying, _texto text) OWNER TO sdmed;

--
-- TOC entry 301 (class 1255 OID 39367)
-- Name: insertar_tipo_concepto(character varying, sdmed.tp_concepto); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_tipo_concepto(nombretabla character varying, _dato sdmed.tp_concepto) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
existe boolean := true;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)', tablaconceptos, _dato.codigo) INTO existe;
IF existe = FALSE THEN
	EXECUTE FORMAT ('INSERT INTO %I (codigo,resumen,descripcion,descripcionhtml,preciomed,preciobloq,naturaleza,fecha,ud,preciocert) VALUES
			($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)',tablaconceptos)
			USING		
			left(_dato.codigo,20),
			left(_dato.resumen,80),
			COALESCE(_dato.descripcion,''),
			COALESCE(_dato.descripcionhtml,''),
			_dato.preciomed,
			_dato.preciobloq,
			_dato.naturaleza,
			_dato.fecha,
			COALESCE(_dato.ud,''),
			_dato.preciocert
			;	
END IF;
RETURN existe;
END;
$_$;


ALTER FUNCTION sdmed.insertar_tipo_concepto(nombretabla character varying, _dato sdmed.tp_concepto) OWNER TO sdmed;

--
-- TOC entry 302 (class 1255 OID 39368)
-- Name: insertar_tipo_medcert(character varying, sdmed.tp_medicion, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_tipo_medcert(_nombretabla character varying, _dato sdmed.tp_medicion, _num_cert integer DEFAULT 0) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablamedcert character varying := _nombretabla||'_Mediciones';
existe boolean := true;
r record;
codigopadre character varying := _dato.codpadre;
codigohijo character varying := _dato.codhijo;
posicion integer := _dato.posicion;
BEGIN
--ordenar las lineas
FOR r IN EXECUTE FORMAT ('SELECT * FROM ver_medcert($1,$2,$3,$4)') USING _nombretabla,codigopadre,codigohijo,_num_cert 
LOOP
	IF r.pos>=posicion THEN
		EXECUTE FORMAT ('UPDATE %I SET posicion = posicion+1 WHERE id = $1', tablamedcert)
		USING r.id;
	END IF;
END LOOP;
/*RAISE NOTICE 'INSERTAR TIPO MEDICION %-%-%-%-%-%-%-%-%-%-%-%',_dato.id,_dato.tipo,_dato.comentario,_dato.ud,_dato.longitud,_dato.anchura,_dato.altura,
		_dato.formula,_dato.codpadre,_dato.codhijo,_dato.posicion,_dato.num_certif;*/
EXECUTE FORMAT ('INSERT INTO %I VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)',tablamedcert)
	USING
	_dato.id,
	COALESCE(_dato.num_certif,NULL),
	COALESCE(_dato.tipo,NULL),
	COALESCE(_dato.comentario,''),
	COALESCE(_dato.ud,NULL),
	COALESCE(_dato.longitud,NULL),
	COALESCE(_dato.anchura,NULL),
	COALESCE(_dato.altura,NULL),	
	COALESCE(_dato.formula,''),
	_dato.codpadre::character varying,
	_dato.codhijo::character varying,				
	COALESCE(_dato.posicion,NULL)
	;
RETURN existe;
END;
$_$;


ALTER FUNCTION sdmed.insertar_tipo_medcert(_nombretabla character varying, _dato sdmed.tp_medicion, _num_cert integer) OWNER TO sdmed;

--
-- TOC entry 340 (class 1255 OID 39892)
-- Name: insertar_tipo_relacion(character varying, sdmed.tp_relacion); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.insertar_tipo_relacion(_nombretabla character varying, _dato sdmed.tp_relacion) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablarelacion character varying := _nombretabla || '_Relacion';
existe boolean := true;
BEGIN
--EXECUTE FORMAT ('SELECT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)', tablaconceptos, _dato.codigo) INTO existe;
--IF existe = FALSE THEN
	EXECUTE FORMAT ('INSERT INTO %I VALUES($1,$2,$3,$4,$5,$6,$7)',tablarelacion)
	USING
	_dato.id,
	_dato.codpadre,
	_dato.codhijo,
	_dato.canpres,
	COALESCE(_dato.cancert,0),
	_dato.posicion,
	_dato.nivel
	;
--END IF;
RETURN existe;
END;
$_$;


ALTER FUNCTION sdmed.insertar_tipo_relacion(_nombretabla character varying, _dato sdmed.tp_relacion) OWNER TO sdmed;

--
-- TOC entry 299 (class 1255 OID 39370)
-- Name: modificar_campo_medcert(character varying, character varying, character varying, character varying, integer, integer, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.modificar_campo_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _valor character varying, _idfila integer, _columna integer, _num_cert integer DEFAULT 0) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablamedcert character varying := _nombretabla||'_Mediciones';
texto text;
BEGIN
IF (_columna!=1 AND _columna!=6 AND _valor = '') THEN _valor =0;END IF;--PONGO A 0 LOS CAMPOS VACIOS QUE NO SEAN COMENTARIOS O FORMULAS
CASE _columna
WHEN 1 THEN texto := ' comentario = '||quote_literal(_valor);
WHEN 2 THEN texto := ' ud = '||quote_literal(_valor);
WHEN 3 THEN texto := ' longitud = '||quote_literal(_valor);
WHEN 4 THEN texto := ' anchura = '||quote_literal(_valor);
WHEN 5 THEN texto := ' altura = '||quote_literal(_valor);
WHEN 6 THEN texto := 'formula = '||quote_literal(_valor);
WHEN 8 THEN texto := ' tipo = '||quote_literal(_valor);--8 por la posicion de la columna de subtotal
END CASE;
raise notice 'text: %, id: %',texto,_idfila;
EXECUTE FORMAT ('UPDATE %I SET %s WHERE id = %s',tablamedcert, texto, _idfila);
IF _columna = 2 or _columna = 3 or _columna = 4 or _columna = 5 or _columna = 6 THEN
	PERFORM modificar_cantidad(_nombretabla,_codigopadre,_codigohijo,_num_cert);
END IF;
END;
$$;


ALTER FUNCTION sdmed.modificar_campo_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _valor character varying, _idfila integer, _columna integer, _num_cert integer) OWNER TO sdmed;

--
-- TOC entry 306 (class 1255 OID 39371)
-- Name: modificar_cantidad(character varying, character varying, character varying, integer, boolean, numeric); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.modificar_cantidad(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer DEFAULT 0, _guardar boolean DEFAULT true, _cantidad numeric DEFAULT NULL::numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablarelacion character varying := _nombretabla||'_Relacion';
tablamedcert character varying := _nombretabla||'_Mediciones';
nuevacantidad numeric = 0;
tipocantidad character varying;
indices int[];
certificaciones integer;
haymedicion boolean := false;
BEGIN
IF _num_cert = 0 THEN    
    tipocantidad := 'canpres';
ELSE    
    tipocantidad := 'cancert';
END IF;
--si la cantidad no es nula tengo que borrar todas las lineas de medicion y sustituir la cantidad por la cantidad dada
IF _cantidad IS NOT NULL THEN
    raise notice 'entro en la funcion con una cantidad dada: %',_cantidad;
    --guardo los indices de las lineas de medicion de esa partida (si los hubiera)
    EXECUTE FORMAT ('SELECT array_agg(id) FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3' , tablamedcert) 
	INTO indices 
	USING _codigopadre, _codigohijo, _num_cert;
    IF array_length(indices,1)>0 THEN
	haymedicion = true;
    END IF;
    --borro las posibles lineas de medicion
    PERFORM borrar_lineas_medcert(_nombretabla, indices,_num_cert,_guardar,'t');
    --sustituyo la cantidad. 
    nuevacantidad = _cantidad;
--si el argumento de cantidad es nulo, la calculo a partir de sus mediciones
ELSE
    IF _num_cert = 0 THEN --cuando estamos en la tabla de medicion
	EXECUTE FORMAT('SELECT SUM(parcial) FROM ver_medcert($1,$2,$3,$4)') INTO nuevacantidad USING _nombretabla, _codigopadre, _codigohijo, _num_cert;
    ELSE 
	EXECUTE FORMAT('SELECT SUM(parcial) FROM ver_todas_certificaciones($1,$2,$3)') INTO nuevacantidad USING _nombretabla, _codigopadre, _codigohijo;
    END IF;
    
    IF nuevacantidad IS NULL THEN nuevacantidad =0; END IF;
END IF;
--por ultimo cambio la cantidad y recalculo el total
--raise notice 'poner cantidad: % en padre % e hijo %',nuevacantidad, _codigopadre, _codigohijo;
EXECUTE FORMAT ('UPDATE %I SET %s = $1 WHERE codpadre = $2 AND codhijo = $3', tablarelacion, tipocantidad) USING nuevacantidad, _codigopadre, _codigohijo;
--IF existe_codigo(_nombretabla,_codigohijo) THEN
IF COALESCE(_codigohijo,'') IS NOT NULL THEN
    IF _num_cert IS NULL THEN--SI num_cert es nulo, actualizo tanto las mediciones como las certificaciones
	PERFORM actualizar_desde_nodo(_nombretabla,_codigohijo,0);
	PERFORM actualizar_desde_nodo(_nombretabla,_codigohijo,1);
    ELSE-- y si no, pues solo actualizo la tabla que corresponda a ese _num_cert
	PERFORM actualizar_desde_nodo(_nombretabla,_codigohijo,_num_cert);
    END IF;
END IF;
RETURN haymedicion;
END;
$_$;


ALTER FUNCTION sdmed.modificar_cantidad(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _guardar boolean, _cantidad numeric) OWNER TO sdmed;

--
-- TOC entry 348 (class 1255 OID 39372)
-- Name: modificar_codigo(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.modificar_codigo(_nombretabla character varying, _codigoantiguo character varying, _codigonuevo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
tablarelacion character varying := _nombretabla||'_Relacion';
tablamediciones character varying := _nombretabla||'_Mediciones';
existe boolean;--la funcion solo se ejecuta si el nuevo codigo no existe, para no pisar uno existente
BEGIN
EXECUTE FORMAT ('SELECT EXISTS(SELECT codigo FROM %I WHERE codigo = %L)',tablaconceptos, _codigonuevo) INTO existe;
IF existe IS FALSE THEN
    EXECUTE FORMAT ('UPDATE %I SET codigo = %L WHERE codigo = %L',tablaconceptos,_codigonuevo, _codigoantiguo);
    EXECUTE FORMAT ('UPDATE %I SET codpadre = %L WHERE codpadre = %L',tablarelacion,_codigonuevo, _codigoantiguo);
    EXECUTE FORMAT ('UPDATE %I SET codhijo = %L WHERE codhijo = %L',tablarelacion,_codigonuevo, _codigoantiguo);
    EXECUTE FORMAT ('UPDATE %I SET codhijo = %L WHERE codhijo = %L',tablamediciones,_codigonuevo, _codigoantiguo);
END IF;
RETURN existe;
END;
$$;


ALTER FUNCTION sdmed.modificar_codigo(_nombretabla character varying, _codigoantiguo character varying, _codigonuevo character varying) OWNER TO sdmed;

--
-- TOC entry 304 (class 1255 OID 39373)
-- Name: modificar_naturaleza(character varying, character varying, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.modificar_naturaleza(_nombretabla character varying, _cod character varying, _nat integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
BEGIN
EXECUTE FORMAT ('UPDATE %I SET naturaleza = %s WHERE codigo = %L', tablaconceptos, _nat , _cod);
END;  
$$;


ALTER FUNCTION sdmed.modificar_naturaleza(_nombretabla character varying, _cod character varying, _nat integer) OWNER TO sdmed;

--
-- TOC entry 352 (class 1255 OID 39374)
-- Name: modificar_precio(character varying, character varying, character varying, numeric, integer, boolean); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.modificar_precio(nombretabla character varying, codpadre character varying, codhijo character varying, precio numeric, opcion integer, restaurar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaborrarconceptos character varying;
tablaborrarrelacion character varying;
BEGIN
tablaborrarconceptos = nombretabla || '_BorrarConceptos';
tablaborrarrelacion = nombretabla || '_BorrarRelacion';
--opcion = 1 suprimir
--opcion = 2 bloquear
--opcion = 3 ajustar
--opcion = 4 desbloquear
IF opcion = 2 OR opcion = 4 THEN--bloquear/desbloquear el precio
	IF opcion = 2 THEN
		PERFORM bloquear_precio(nombretabla,codhijo,precio,'t');
	ELSE
		PERFORM bloquear_precio(nombretabla,codhijo,precio,'f');
	END IF;
ELSE
	IF restaurar IS TRUE THEN
		PERFORM borrar_hijos(nombretabla,codhijo);
	ELSE
		PERFORM restaurar_lineas_borradas(nombretabla);
	END IF;	
	--por ultimo actualizo el campo precio	
	EXECUTE FORMAT ('UPDATE %I SET preciomed = %s WHERE codigo=%s',nombretabla||'_Conceptos',quote_literal(precio),quote_literal(codhijo));	
	EXECUTE FORMAT ('UPDATE %I SET preciocert = %s WHERE codigo=%s',nombretabla||'_Conceptos',quote_literal(precio),quote_literal(codhijo));	
END IF;
PERFORM actualizar_desde_nodo(nombretabla,codhijo);
END;
$$;


ALTER FUNCTION sdmed.modificar_precio(nombretabla character varying, codpadre character varying, codhijo character varying, precio numeric, opcion integer, restaurar boolean) OWNER TO sdmed;

--
-- TOC entry 305 (class 1255 OID 39375)
-- Name: modificar_resumen(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.modificar_resumen(_nombretabla character varying, _cod character varying, _res character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
BEGIN
EXECUTE FORMAT ('UPDATE %I SET resumen = %L WHERE codigo = %L', tablaconceptos,_res,_cod);
END;
$$;


ALTER FUNCTION sdmed.modificar_resumen(_nombretabla character varying, _cod character varying, _res character varying) OWNER TO sdmed;

--
-- TOC entry 307 (class 1255 OID 39376)
-- Name: modificar_texto(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.modificar_texto(nombretabla character varying, cod character varying, textoplano character varying, textohtml character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

EXECUTE FORMAT ('UPDATE %I SET descripcion = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,quote_literal(textoplano),quote_literal(cod));
EXECUTE FORMAT ('UPDATE %I SET descripcionhtml = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,quote_literal(textohtml),quote_literal(cod));
END;
$$;


ALTER FUNCTION sdmed.modificar_texto(nombretabla character varying, cod character varying, textoplano character varying, textohtml character varying) OWNER TO sdmed;

--
-- TOC entry 308 (class 1255 OID 39377)
-- Name: modificar_unidad(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.modificar_unidad(_nombretabla character varying, _cod character varying, _ud character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
EXECUTE FORMAT ('UPDATE %I SET ud = %L WHERE codigo = %L',_nombretabla||'_Conceptos' ,_ud,_cod);

END;
$$;


ALTER FUNCTION sdmed.modificar_unidad(_nombretabla character varying, _cod character varying, _ud character varying) OWNER TO sdmed;

--
-- TOC entry 309 (class 1255 OID 39378)
-- Name: mostrar_ruta(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.mostrar_ruta(tabla character varying, codigo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
existe boolean;
tablarelacion character varying := tabla || '_Relacion';
codigopadre character varying;
ruta character varying := $2;
BEGIN
EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE codhijo = %L', tablarelacion , codigo) INTO codigopadre;
--SI NO ESTAMOS EN EL NODO RAIZ:
/*IF codigopadre IS NOT NULL THEN
	EXECUTE FORMAT('SELECT mostrar_ruta(%I,%L)',tabla,codigopadre);*/
ruta := ruta || '/' || codigopadre;
--END IF;
RETURN ruta;
END;
$_$;


ALTER FUNCTION sdmed.mostrar_ruta(tabla character varying, codigo character varying) OWNER TO sdmed;

--
-- TOC entry 310 (class 1255 OID 39379)
-- Name: nivel_capitulo(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.nivel_capitulo(_nombretabla character varying, _codigo character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
tablarelacion character varying := _nombretabla||'_Relacion';
nat integer;
existe boolean;
--la funcion retorna por defecto 0
--si la naturaleza del codigo es de capitulo, veo si aparece como subcapitulo en alguna parte de la tabla de relacion
--si no es asi, retorno 1 (capitulo) y si figura como subcapitulo retorno 2
tipo smallint := 0;
BEGIN
--primero, compruebo si el codigo es capitulo
EXECUTE FORMAT ('SELECT naturaleza FROM %I WHERE codigo = $1', tablaconceptos) USING _codigo INTO nat;
--si es capitulo, mirare si aparece como subcapitulo en alguna fila de la tabla de relaciones
IF nat = 6 THEN --capitulo...habra que cambiar ese numero
	EXECUTE FORMAT ('SELECT EXISTS(SELECT codhijo FROM %I WHERE codhijo = $1 AND codpadre <> $2)',tablarelacion) USING _codigo,_nombretabla INTO existe;
	IF existe IS FALSE THEN
	    tipo = 1;
	ELSE
		tipo =2;
	END IF;
END IF;
RETURN tipo;
END;
$_$;


ALTER FUNCTION sdmed.nivel_capitulo(_nombretabla character varying, _codigo character varying) OWNER TO sdmed;

--
-- TOC entry 311 (class 1255 OID 39380)
-- Name: numero_en_euro(numeric); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.numero_en_euro(numero numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  cantidad TEXT;
  entero bigint;
  decimal integer;
  moneda varchar(20) := ' Euros';
  centimos varchar(20) := ' Céntimos';

BEGIN

entero=TRUNC(numero,0);
decimal = (numero-entero)*100;
cantidad := fx_letras(entero) || moneda;
IF decimal > 0 THEN
	cantidad := cantidad|| ' con ' ||fx_letras(decimal) || centimos;
END If;

cantidad :=  UPPER(cantidad);

  RETURN cantidad;
END;
$$;


ALTER FUNCTION sdmed.numero_en_euro(numero numeric) OWNER TO sdmed;

--
-- TOC entry 312 (class 1255 OID 39381)
-- Name: ordenar_posiciones(character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ordenar_posiciones(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _insertar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
--la funcion ordena las posiciones de los registros de la tabla relacion que tengan el mismo codigo padre que la relacion a borrar/insertar
--si el parametro _insertar es verdadero, se aumentaran las posiciones de los registros cuya posicion sea mayor a la de la posicion del codigohijo a borrar
--si el parametro _insertar es negativo, estaremos hablando de borrar un registro, y entonces las posiciones  mayores se disminuiran en una unidad
tablarelacion character varying := _nombretabla || '_Relacion';
cadena_posicion character varying;
r tp_relacion%ROWTYPE;
posicion integer;
BEGIN
IF _insertar IS TRUE THEN--si estamos insertando aumentamos la posicion 
	cadena_posicion:='posicion=posicion+1';
	RAISE NOTICE 'AUMENTO LO QUE HAY TRAS %-%',_codigopadre,_codigohijo;
ELSE --si no, estamos borrando y decrecemos las posiciones de los elementos posteriores
	cadena_posicion:='posicion=posicion-1';
	RAISE NOTICE 'DISMINUYO LO QUE HAY TRAS %-%',_codigopadre,_codigohijo;
END IF;
--primero, cojo la posicion del codigohijo a insertar/borrar
EXECUTE FORMAT ('SELECT posicion FROM %I where codpadre = $1 AND codhijo = $2',tablarelacion) USING _codigopadre,_codigohijo INTO posicion;
raise notice 'possioccion: %',posicion;
--segundo, itero sobre todos los registros cuyo codigo padre sea igual al codigo padre del codigo a insertar/borrar y la posicion mayor a la posicion del codigo hijo a insertar/borrar
FOR r IN EXECUTE FORMAT('SELECT * FROM %I WHERE codpadre = $1 AND codhijo != $2 AND posicion >=$3 ORDER BY posicion',tablarelacion) USING _codigopadre, _codigohijo,posicion
	LOOP
		EXECUTE FORMAT ('UPDATE %I SET %s WHERE codpadre = $1 AND codhijo = $2', tablarelacion,cadena_posicion) USING r.codpadre, r.codhijo;
	END LOOP;
END;
$_$;


ALTER FUNCTION sdmed.ordenar_posiciones(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _insertar boolean) OWNER TO sdmed;

--
-- TOC entry 317 (class 1255 OID 39382)
-- Name: pegar(character varying, character varying, smallint, boolean); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.pegar(_nombretabla character varying, _codigodestino character varying, OUT nodos_insertados character varying, _pos smallint DEFAULT (- (1)::smallint), _primer_paso boolean DEFAULT true) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
R tp_relacion%ROWTYPE;
C tp_concepto%ROWTYPE;
M tp_medicion%ROWTYPE;
tablacopiar character varying := '__CopiarRelacion';
tablaconceptos character varying :='__CopiarConceptos';
tablacopiarmediciones character varying := '__CopiarMediciones';
codpadre character varying;
resultado integer;
posicion smallint := _pos;
existe boolean;
existe_concepto boolean;
BEGIN
nodos_insertados :='';
IF _primer_paso IS TRUE THEN
	codpadre := ' IS NULL';
	_primer_paso := FALSE;
ELSE
	codpadre := ' = '||quote_literal(_codigodestino);	
END IF;
FOR R IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre %s ORDER BY posicion',tablacopiar,codpadre)
LOOP
	--insertar el concepto (solo lo hara si no existe en la tabla. ademas retornara falso si no existia)
	EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %L',tablaconceptos,R.codhijo) INTO C;	
	EXECUTE FORMAT ('SELECT insertar_tipo_concepto($1,$2)') USING _nombretabla, C INTO existe_concepto;	
	--insertar la partida (se insertará la relacion, el concepto se ha hecho anteriormente)
	SELECT insertar_partida(_nombretabla,_codigodestino,R.codhijo,posicion,R.canpres) INTO resultado;
	posicion = posicion +1;
	--Solo si no existia el concepto insertado seguimos adelante con las ediciones e hijos de ese concepto.
	IF resultado = 0 THEN
		FOR M IN EXECUTE FORMAT('SELECT * FROM %I WHERE codpadre %s AND codhijo = %L',tablacopiarmediciones,codpadre,R.codhijo) LOOP
			PERFORM insertar_lineas_medcert(_nombretabla,_codigodestino,R.codhijo,1,M.posicion,M.num_certif,M.tipo,M.comentario,M.ud,M.longitud,M.anchura,M.altura,M.formula);
			--PERFORM insertar_tipo_medcert(_nombretabla,M,'0');--tabla mediciones
			--PERFORM insertar_tipo_medcert(_nombretabla,M,'1');--tabla certificaciones
		END LOOP;
	END IF;
	IF existe_concepto IS FALSE THEN	
		nodos_insertados := nodos_insertados || C.codigo||',';
		RAISE NOTICE 'LOS NODOS SON: %' ,C.codigo;
		
		--ver si cada conceptos insertado tiene hijos
		EXECUTE FORMAT ('SELECT EXISTS (SELECT codhijo FROM %I WHERE codpadre = %L)', tablacopiar, R.codhijo) INTO existe;
		IF existe IS TRUE THEN 
			PERFORM pegar(_nombretabla,R.codhijo,'0',_primer_paso);
		END IF;
	END IF;
END LOOP;
nodos_insertados := left(nodos_insertados,-1);
END;
$_$;


ALTER FUNCTION sdmed.pegar(_nombretabla character varying, _codigodestino character varying, OUT nodos_insertados character varying, _pos smallint, _primer_paso boolean) OWNER TO sdmed;

--
-- TOC entry 351 (class 1255 OID 39383)
-- Name: pegar_medicion(character varying, character varying, character varying, integer, smallint); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.pegar_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer DEFAULT 0, _pos smallint DEFAULT (- (1)::smallint)) RETURNS character varying[]
    LANGUAGE plpgsql
    AS $$ 
DECLARE
M tp_medicion%ROWTYPE;
tablacopiarmediciones character varying := '__CopiarMediciones';
posicion smallint := _pos;
id character varying;
listaIds character varying[];
BEGIN
FOR M IN EXECUTE FORMAT('SELECT * FROM %I',tablacopiarmediciones) LOOP
	PERFORM insertar_lineas_medcert(_nombretabla,_codigopadre,_codigohijo,1,posicion,_num_cert,M.tipo,M.comentario,M.ud,M.longitud,M.anchura,M.altura,M.formula);	
	listaIds := array_append (listaIds,id_por_posicion(_nombretabla,_codigopadre,_codigohijo,posicion,_num_cert)::character varying);
	posicion = posicion +1;	
	END LOOP;
RETURN listaIds;
END;
$$;


ALTER FUNCTION sdmed.pegar_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _pos smallint) OWNER TO sdmed;

--
-- TOC entry 314 (class 1255 OID 39384)
-- Name: poner_almohadilla(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.poner_almohadilla(tabla character varying, codigo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying;
r record;
padre character varying;
abuelo character varying;
nuevocodigo character varying;
BEGIN
nuevocodigo = codigo;
tablarelacion := tabla||'_Relacion';
EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE codhijo = %s',tablarelacion, quote_literal(codigo)) INTO padre;
IF padre IS NULL THEN
    nuevocodigo := concat(codigo,'##');
ELSE
    EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE codhijo = %s',tablarelacion, quote_literal(padre)) INTO abuelo;
    IF abuelo IS NULL THEN
        nuevocodigo := concat(codigo,'#');
    END IF;
END IF;
RETURN nuevocodigo;
END;
$$;


ALTER FUNCTION sdmed.poner_almohadilla(tabla character varying, codigo character varying) OWNER TO sdmed;

--
-- TOC entry 315 (class 1255 OID 39385)
-- Name: procesar_cadena_fecha(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.procesar_cadena_fecha(cadenafecha character varying DEFAULT ''::character varying) RETURNS date
    LANGUAGE plpgsql
    AS $_$
DECLARE
fecha DATE;

BEGIN
--comprobacion de si hay digitos. Si no son todos digitos se retorna fecha actual
IF cadenafecha ~ '^(-)?[0-9]+$' IS NOT TRUE THEN
   fecha = NOW();
--empezamos definiendo la fecha
ELSIF char_length(cadenafecha) = 6 THEN 
   fecha = to_date(cadenafecha,'DDMMYY');
ELSIF char_length(cadenafecha) = 8 THEN 
   fecha = to_date(cadenafecha,'DDMMYYYY');
ELSE
   fecha = NOW();
END IF;
RETURN fecha;
END;
$_$;


ALTER FUNCTION sdmed.procesar_cadena_fecha(cadenafecha character varying) OWNER TO sdmed;

--
-- TOC entry 342 (class 1255 OID 39386)
-- Name: procesar_linea_medicion(numeric, numeric, numeric, numeric, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.procesar_linea_medicion(unidad numeric, longitud numeric, anchura numeric, altura numeric, formula character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
IF formula IS NULL OR formula = '' IS TRUE THEN
	IF unidad IS NULL THEN unidad = 0; END IF;
	IF longitud IS NULL OR longitud = 0 THEN longitud =1; END IF;
	IF anchura IS NULL OR anchura = 0 THEN anchura =1; END IF;
	IF altura IS NULL OR altura = 0 THEN altura =1; END IF;
	RETURN unidad*longitud*anchura*altura;
ELSE
	RETURN evaluar_formula(unidad,longitud,anchura,altura,formula);
END IF;
END;
$$;


ALTER FUNCTION sdmed.procesar_linea_medicion(unidad numeric, longitud numeric, anchura numeric, altura numeric, formula character varying) OWNER TO sdmed;

--
-- TOC entry 316 (class 1255 OID 39387)
-- Name: recalcular(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.recalcular(_nombretabla character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying := _nombretabla || '_Relacion';
codigo character varying;
BEGIN
FOR codigo IN EXECUTE FORMAT(' SELECT DISTINCT codhijo from %I WHERE codhijo NOT IN (SELECT DISTINCT codpadre FROM %I WHERE codpadre IS NOT NULL)',tablarelacion,tablarelacion) LOOP
	PERFORM actualizar_desde_nodo(_nombretabla,codigo);	
END LOOP;
END;
$$;


ALTER FUNCTION sdmed.recalcular(_nombretabla character varying) OWNER TO sdmed;

--
-- TOC entry 318 (class 1255 OID 39388)
-- Name: recorrer_principal(character varying, character varying, integer, boolean); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.recorrer_principal(nombretabla character varying, codigopadre character varying DEFAULT NULL::character varying, _nivel integer DEFAULT 0, primer_elemento boolean DEFAULT true) RETURNS TABLE(codigo character varying, naturaleza integer, ud character varying, resumen character varying, preciomed numeric, nivel integer)
    LANGUAGE plpgsql
    AS $$ 
DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
tablarelacion character varying := nombretabla || '_Relacion';
existe boolean;
nombre_codigo character varying;
codpadre character varying := codigopadre;
c tp_concepto%ROWTYPE;
indice integer;
str_null_case character varying;
BEGIN
IF (codigopadre = '') IS NOT FALSE THEN
	str_null_case := ' IS NULL';	
ELSE
	str_null_case := ' = '||quote_literal(codigopadre);
END IF;
--ELEMENTO RAIZ
IF primer_elemento IS TRUE THEN
	EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE codpadre %s',tablarelacion,str_null_case) INTO nombre_codigo;
	EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %s',tablaconceptos, quote_literal(nombre_codigo)) INTO c;
	codigo := c.codigo;
	nivel := _nivel;
	ud := c.ud;
	naturaleza := c.naturaleza;
	resumen := c.resumen;
	preciomed := c.preciomed;
	RETURN NEXT;
	codpadre := c.codigo;--si es el primer nivel cambio codpadre a este en lugar de al parametro de la funcion
END IF;
--EMPIEZO A ITERAR
FOR nombre_codigo in EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE codpadre = %s', tablarelacion, quote_literal(codpadre))
LOOP
 	EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %s', tablaconceptos, quote_literal(nombre_codigo)) INTO c;
	codigo := nombre_codigo;
	nivel := _nivel+1;
	ud := c.ud;
	naturaleza := c.naturaleza;
	resumen := c.resumen;
	preciomed := c.preciomed;
	RETURN NEXT;
	EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codpadre = %s )', tablarelacion , quote_literal(nombre_codigo)) INTO existe;
	--SI QUEDAN MAS HIJOS:	
	IF existe = TRUE THEN
		RETURN QUERY SELECT * FROM recorrer_principal(nombretabla,nombre_codigo,nivel,'false');				
	END IF;	
 END LOOP;
END;
$$;


ALTER FUNCTION sdmed.recorrer_principal(nombretabla character varying, codigopadre character varying, _nivel integer, primer_elemento boolean) OWNER TO sdmed;

--
-- TOC entry 321 (class 1255 OID 39389)
-- Name: recorrercte(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.recorrercte(_nombretabla character varying) RETURNS TABLE(ret_codigo character varying, ret_naturaleza integer, ret_ud character varying, ret_resumen character varying, ret_preciomed numeric, ret_depth integer, ret_camino text)
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';
punto char :='.';
BEGIN
RETURN QUERY EXECUTE FORMAT(
'WITH RECURSIVE tree AS(
SELECT codpadre, codhijo, canpres, 0 AS depth, cast(posicion AS text)  AS camino,posicion FROM %I
WHERE codpadre is NULL
UNION ALL
SELECT rel.codpadre, rel.codhijo, rel.canpres, depth+1, camino || ''.'' || CAST(rel.posicion AS text) , rel.posicion
FROM %I AS rel
JOIN tree t ON rel.codpadre = t.codhijo
)
SELECT 
conceptos.codigo, 
conceptos.naturaleza, 
conceptos.ud,
conceptos.resumen,
--tree.canpres,
--tree.cancert,
conceptos.preciomed,
--conceptos.preciomed*tree.canpres AS "Importe", 
tree.depth,
tree.camino
FROM tree, %I AS conceptos 
WHERE conceptos.codigo = tree.codhijo
ORDER BY string_to_array(camino, ''.'')::int[]', tablarelacion,tablarelacion,tablaconceptos);
END; 
$$;


ALTER FUNCTION sdmed.recorrercte(_nombretabla character varying) OWNER TO sdmed;

--
-- TOC entry 322 (class 1255 OID 39390)
-- Name: restaurar_lineas_borradas(character varying, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.restaurar_lineas_borradas(_nombretabla character varying, _tipotabla integer DEFAULT 0) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
num_paso integer;
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';
tablamedicion character varying := _nombretabla || '_Mediciones';
tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';
existe boolean;
insertar boolean :=true;--indica a la funcion ordenar_posiciones que hay que aumentar las posiciones restantes a la dada

c tp_concepto%ROWTYPE;
cg tp_guardarconcepto%ROWTYPE;
r tp_relacion%ROWTYPE;
rg tp_guardarrelacion%ROWTYPE;
m tp_medicion%ROWTYPE;
mg tp_guardarmedicion%ROWTYPE;
BEGIN
--PRIMER PASO, HALLAR EL PASO MAS ALTO DE LAS TRES TABLAS
EXECUTE FORMAT('SELECT ultimo_paso($1)') INTO num_paso USING _nombretabla;
RAISE NOTICE 'ULTIMO PASO: %',num_paso;
--AHORA VOY RESTAURANDO ELEMENTOS DE CADA TABLA. SIEMPRE COMPRUEBO PRIMERO SI EXISTEN.
--TABLA RELACION
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarrelacion;
IF existe IS TRUE THEN
    FOR rg IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1 ORDER BY idguardar DESC',tablaguardarrelacion) USING num_paso
	LOOP
	    r=rg.r;
	    /*EXECUTE FORMAT ('INSERT INTO %I VALUES(%s,%L,%L,%s,%s,%s)',tablarelacion,
	    r.id, r.codpadre, r.codhijo, r.canpres,r.cancert,r.posicion);*/
	    PERFORM insertar_tipo_relacion(_nombretabla,r);
	    PERFORM ordenar_posiciones(_nombretabla,r.codpadre,r.codhijo,insertar);
	END LOOP;
    EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaguardarrelacion,num_paso);
END IF;
--TABLA CONCEPTOS
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarconceptos;
IF existe IS TRUE THEN
    FOR cg IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1',tablaguardarconceptos) USING num_paso
	LOOP
	    c=cg.c;	
	    PERFORM insertar_tipo_concepto(_nombretabla,c);
	    PERFORM actualizar_desde_nodo(_nombretabla,c.codigo);
	END LOOP;
    EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaguardarconceptos,num_paso);
END IF;
--TABLA MEDICIONES
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarmedicion; 
IF existe IS TRUE THEN
    FOR mg IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1',tablaguardarmedicion) USING num_paso
	LOOP
	m=mg.m;
	PERFORM insertar_tipo_medcert(_nombretabla,m,m.num_certif);
	END LOOP;
	--PERFORM actualizar_desde_nodo(_nombretabla,m.codpadre);
	PERFORM modificar_cantidad(_nombretabla,m.codpadre,m.codhijo,m.num_certif);
    EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaguardarmedicion,num_paso);
END IF;
END;
$_$;


ALTER FUNCTION sdmed.restaurar_lineas_borradas(_nombretabla character varying, _tipotabla integer) OWNER TO sdmed;

--
-- TOC entry 323 (class 1255 OID 39391)
-- Name: total_cantidad_por_partida(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.total_cantidad_por_partida(nombretabla character varying, codigohijo character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
r record;
tablarelacion character varying;
codigo_abuelo character varying;
cantidad_total numeric := 0;
cantidad_padre numeric := 0;
BEGIN
tablarelacion := nombretabla||'_Relacion';
FOR r in EXECUTE FORMAT('SELECT codpadre, canpres FROM %I WHERE codhijo = $1',tablarelacion) USING codigohijo
LOOP
	EXECUTE FORMAT ('SELECT codpadre, canpres FROM %I WHERE codhijo = $1',tablarelacion) USING r.codpadre INTO codigo_abuelo, cantidad_padre;
	
	IF codigo_abuelo IS NOT NULL THEN
		--RAISE NOTICE 'Lista : %, %, %',r.codpadre,r.canpres,cantidad_padre;
		cantidad_total = cantidad_total + r.canpres * (total_cantidad_por_partida(nombretabla,r.codpadre));
	--	RAISE NOTICE 'La cantidad total es: % * % = %',cantidad_padre,r.canpres,cantidad_total;
	ELSE
		cantidad_total = cantidad_total + r.canpres * cantidad_padre;	
	END IF;	
END LOOP;
RETURN cantidad_total;
END;
$_$;


ALTER FUNCTION sdmed.total_cantidad_por_partida(nombretabla character varying, codigohijo character varying) OWNER TO sdmed;

--
-- TOC entry 324 (class 1255 OID 39392)
-- Name: ultimo_paso(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ultimo_paso(_nombretabla character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';

ultimo_paso_conceptos integer :=0;
ultimo_paso_relacion integer :=0;
ultimo_paso_mediciones integer :=0;
ultimo_paso integer :=0;
num_registros integer :=0;
existe boolean;
BEGIN
--maximo paso tabla conceptos
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarconceptos;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT COUNT(*) FROM %I',tablaguardarconceptos) INTO num_registros;
	IF num_registros>0 THEN
		EXECUTE FORMAT ('SELECT MAX(paso) FROM %I',tablaguardarconceptos) INTO ultimo_paso_conceptos;	
	END IF;
END IF;
--maximo paso tabla relacion
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarrelacion;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT COUNT(*) FROM %I',tablaguardarrelacion) INTO num_registros;
	IF num_registros>0 THEN
		EXECUTE FORMAT ('SELECT MAX(paso) FROM %I',tablaguardarrelacion) INTO ultimo_paso_relacion;
	END IF;
END IF;
--maximo paso tabla medicion
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarmedicion;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT COUNT(*) FROM %I',tablaguardarmedicion) INTO num_registros;
	IF num_registros>0 THEN		
		EXECUTE FORMAT ('SELECT MAX(paso) FROM %I',tablaguardarmedicion) INTO ultimo_paso_mediciones;
	END IF;
END IF;

CREATE TEMP TABLE IF NOT EXISTS temp_maximos (paso integer);
INSERT INTO temp_maximos VALUES(ultimo_paso_conceptos);   
INSERT INTO temp_maximos VALUES(ultimo_paso_relacion);
INSERT INTO temp_maximos VALUES(ultimo_paso_mediciones);
ultimo_paso = (SELECT MAX(paso) FROM temp_maximos);
IF ultimo_paso IS NULL THEN ultimo_paso =0;END IF;
DROP TABLE temp_maximos;
RETURN ultimo_paso;
END;
$_$;


ALTER FUNCTION sdmed.ultimo_paso(_nombretabla character varying) OWNER TO sdmed;

--
-- TOC entry 319 (class 1255 OID 39393)
-- Name: ver_anterior(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_anterior(nombretabla character varying, codpadre character varying, codhijo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying := nombretabla||'_Relacion';
str_null_case character varying;
codigo_anterior character varying;
BEGIN
IF (codpadre = '') IS NOT FALSE THEN
	str_null_case := 'codpadre IS NULL';
ELSE
	str_null_case := 'codpadre = '||quote_literal(codpadre);
END IF;
EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE %s AND posicion = (SELECT posicion FROM %I WHERE %s AND codhijo = %L)- 1',
tablarelacion,str_null_case,tablarelacion,str_null_case,codhijo) INTO codigo_anterior;
IF codigo_anterior = '' IS NOT FALSE THEN codigo_anterior = codhijo; END IF;
RETURN codigo_anterior;
END;
$$;


ALTER FUNCTION sdmed.ver_anterior(nombretabla character varying, codpadre character varying, codhijo character varying) OWNER TO sdmed;

--
-- TOC entry 320 (class 1255 OID 39394)
-- Name: ver_certificacion_actual(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_certificacion_actual(_nombretabla character varying, OUT _num_cert integer, OUT _fecha character varying) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
tabla_listado_certificaciones character varying := _nombretabla || '_ListadoCertificaciones';
indice integer := 1;
var_r record;
existe boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tabla_listado_certificaciones) INTO existe;
IF existe IS FALSE THEN
	_num_cert = 0;
	_fecha = '';
ELSE
FOR var_r IN EXECUTE FORMAT ('SELECT ROW_NUMBER () OVER (ORDER BY fecha) AS num, fecha, actual FROM %I',tabla_listado_certificaciones)
	LOOP
	    IF var_r.actual IS TRUE THEN
		_num_cert = indice;
		_fecha = to_char(var_r.fecha,'DDMMYYYY');
	    END IF;
	    indice = indice + 1;
	END LOOP;
END IF;
END;
$$;


ALTER FUNCTION sdmed.ver_certificacion_actual(_nombretabla character varying, OUT _num_cert integer, OUT _fecha character varying) OWNER TO sdmed;

--
-- TOC entry 325 (class 1255 OID 39395)
-- Name: ver_certificaciones(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_certificaciones(_nombretabla character varying) RETURNS TABLE(num_cert integer, fecha character varying, actual boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
tablalistadocertificaciones character varying := _nombretabla || '_ListadoCertificaciones';
var_r record;
indice integer:=1;
BEGIN
FOR var_r IN EXECUTE FORMAT ('SELECT fecha, actual FROM %I ORDER BY fecha',tablalistadocertificaciones) LOOP
	num_cert = indice;
	fecha = to_char(var_r.fecha,'DDMMYYYY');
	actual = var_r.actual;
	RETURN NEXT;
	indice = indice +1;

END LOOP;
END;
$$;


ALTER FUNCTION sdmed.ver_certificaciones(_nombretabla character varying) OWNER TO sdmed;

--
-- TOC entry 328 (class 1255 OID 39396)
-- Name: ver_color_hijos(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_color_hijos(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) RETURNS TABLE(ret_codigo integer, ret_naturaleza integer, ret_ud integer, ret_resumen integer, ret_canpres integer, ret_cancert integer, ret_portcertpres integer, ret_preciomed integer, ret_preciocert integer, ret_imppres integer, ret_impcert integer)
    LANGUAGE plpgsql
    AS $_$
DECLARE 
    var_r record;
    tablaconceptos character varying := _nombretabla || '_Conceptos';
    tablarelacion character varying := _nombretabla || '_Relacion';
    str_null_case character varying;
BEGIN
IF (_codigopadre = '') IS NOT FALSE THEN
	str_null_case := 'R.codpadre IS NULL';
ELSE
	str_null_case := 'R.codpadre = '||quote_literal(_codigopadre);
END IF;
--nodo padre	
 FOR var_r IN EXECUTE FORMAT('SELECT 
        C.codigo,
	C.naturaleza,
	C.ud,
	C.resumen,
	R.canpres,
	R.cancert,
	R.cancert / NULLIF(R.canpres,0) AS portcertpres,
	C.preciomed,
	C.preciocert,
	R.canpres * C.preciomed as imppres,
	R.cancert * C.preciocert as impcert
 FROM %I AS C, %I AS R 
 WHERE C.codigo = $1
 AND %s
 AND R.codhijo = C.codigo',tablaconceptos,tablarelacion,str_null_case) USING _codigohijo
 LOOP
        ret_codigo := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_naturaleza := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_ud := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_resumen := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_canpres := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_cancert := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_portcertpres := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_preciomed := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_preciocert := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_imppres := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_impcert := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        RETURN NEXT;
 END LOOP;
 --nodos hijos
 FOR var_r IN EXECUTE FORMAT ('SELECT 
	C.codigo,
	C.naturaleza,
	C.ud,
	C.resumen,
	R.canpres,
	R.cancert,
	R.cancert/NULLIF(R.canpres,0) AS portcertpres,
	C.preciomed,
	C.preciocert,
	R.canpres * C.preciomed as imppres,
	R.cancert * C.preciocert as impcert
 FROM %I AS C, %I AS R 
 WHERE R.codpadre = $1 
 AND C.codigo = R.codhijo ORDER BY R.posicion',tablaconceptos,tablarelacion) USING _codigohijo
 LOOP        
        ret_codigo := 	CASE
			WHEN (es_porcentaje(var_r.codigo) IS TRUE) THEN
				array_length(enum_range(NULL, 'PORCENTAJE'::tp_color), 1)
			ELSE 
				CASE
					WHEN (nivel_capitulo(_nombretabla,var_r.codigo)) = 1 THEN
					array_length(enum_range(NULL, 'CAPITULO'::tp_color), 1)
					WHEN (nivel_capitulo(_nombretabla,var_r.codigo)) = 2 THEN
					array_length(enum_range(NULL, 'SUBCAPITULO'::tp_color), 1)
					ELSE 
					array_length(enum_range(NULL, 'NORMAL'::tp_color), 1)
				END
			END;
        ret_naturaleza := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_ud := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_resumen := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_canpres := CASE WHEN (hay_medcert(_nombretabla, _codigohijo, var_r.codigo) IS TRUE OR es_porcentaje(var_r.codigo) IS TRUE) THEN
			array_length(enum_range(NULL, 'DESCOMPUESTO'::tp_color), 1)
		ELSE 
			array_length(enum_range(NULL, 'NORMAL'::tp_color), 1)
		END;
        ret_cancert := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_portcertpres := array_length(enum_range(NULL, 'DESCOMPUESTO'::tp_color), 1);
        ret_preciomed := CASE WHEN (es_precio_bloqueado(_nombretabla, var_r.codigo)) IS TRUE THEN 
			array_length(enum_range(NULL, 'BLOQUEADO'::tp_color), 1)
		     --ELSE 
			WHEN (hay_descomposicion(_nombretabla, var_r.codigo)) IS TRUE THEN 
			array_length(enum_range(NULL, 'DESCOMPUESTO'::tp_color), 1)
		     ELSE
			array_length(enum_range(NULL, 'NORMAL'::tp_color), 1)
		     END;
        ret_preciocert := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_imppres := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        ret_impcert := array_length(enum_range(NULL, 'NORMAL'::tp_color), 1);
        RETURN NEXT;
 END LOOP;
 END; $_$;


ALTER FUNCTION sdmed.ver_color_hijos(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) OWNER TO sdmed;

--
-- TOC entry 329 (class 1255 OID 39397)
-- Name: ver_conceptos_cantidad(character varying, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_conceptos_cantidad(_nombretabla character varying, _tipo_concepto integer DEFAULT 0) RETURNS TABLE(codigo character varying, cantidad numeric, ud character varying, resumen character varying, precio numeric, importe numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    var_r record;
    tablaconceptos character varying := _nombretabla||'_Conceptos';
    tablarelacion character varying := _nombretabla || '_Relacion';
    str_null_case character varying;
    cadenafiltro character varying :='';
BEGIN
--si el tipo_concepto es mayor que uno filtro la seleccion y creando la cadena
IF (_tipo_concepto =1 OR _tipo_concepto =2 OR _tipo_concepto =3) THEN
	cadenafiltro := ' WHERE naturaleza = '||quote_literal(_tipo_concepto);
END IF;
FOR var_r IN EXECUTE FORMAT('SELECT codigo,ud,resumen,preciomed FROM %I %s ORDER BY naturaleza, codigo',tablaconceptos,cadenafiltro)
	LOOP
		codigo := var_r.codigo;
		cantidad = total_cantidad_por_partida(_nombretabla,codigo);
		ud := var_r.ud;
		resumen :=var_r.resumen;
		precio :=var_r.preciomed;
		importe:= cantidad*precio;
		RETURN NEXT;
	END LOOP;
END;
$$;


ALTER FUNCTION sdmed.ver_conceptos_cantidad(_nombretabla character varying, _tipo_concepto integer) OWNER TO sdmed;

--
-- TOC entry 338 (class 1255 OID 40032)
-- Name: ver_conceptos_unitarios(character varying, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_conceptos_unitarios(_nombretabla character varying, _tipo_concepto integer DEFAULT NULL::integer) RETURNS TABLE(codigo character varying, cantidad numeric, ud character varying, resumen character varying, precio numeric, importe numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    var_r record;
    tablaconceptos character varying := _nombretabla||'_Conceptos';
    tablarelacion character varying := _nombretabla ||'_Relacion';
    str_null_case character varying;
    cadenafiltro character varying :='';
BEGIN
--si el tipo_concepto es mayor que uno filtro la seleccion y creando la cadena
IF (_tipo_concepto IS NULL OR _tipo_concepto = 0) THEN
	cadenafiltro := ' WHERE naturaleza = ''1'' OR naturaleza = ''2'' OR naturaleza = ''3''';
ELSE
	cadenafiltro := ' WHERE naturaleza = '||quote_literal(_tipo_concepto);
END IF;
FOR var_r IN EXECUTE FORMAT('SELECT codigo,ud,resumen,preciomed FROM %I %s ORDER BY naturaleza, codigo',tablaconceptos,cadenafiltro)
	LOOP
		codigo := var_r.codigo;
		cantidad = total_cantidad_por_partida(_nombretabla,codigo);
		ud := var_r.ud;
		resumen := var_r.resumen;
		precio := var_r.preciomed;
		importe := cantidad*precio;
		RETURN NEXT;
	END LOOP;
END;
$$;


ALTER FUNCTION sdmed.ver_conceptos_unitarios(_nombretabla character varying, _tipo_concepto integer) OWNER TO sdmed;

--
-- TOC entry 326 (class 1255 OID 39398)
-- Name: ver_hijos(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_hijos(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) RETURNS TABLE(ret_codigo character varying, ret_naturaleza integer, ret_ud character varying, ret_resumen character varying, ret_canpres numeric, ret_cancert numeric, ret_portcertpres numeric, ret_preciomed numeric, ret_preciocert numeric, ret_imppres numeric, ret_impcert numeric)
    LANGUAGE plpgsql
    AS $_$
DECLARE 
    var_r record;
    tabla_conceptos character varying := CONCAT(_nombretabla,'_Conceptos');
    tabla_relacion character varying := CONCAT(_nombretabla,'_Relacion');
    tabla_propiedades character varying := CONCAT(_nombretabla,'_Propiedades');
    str_null_case character varying;
    coste_indirecto float;
    nat_codigo_abuelo smallint;
    nat_codigo_padre smallint;
BEGIN
IF (_codigopadre = '') IS NOT FALSE THEN
	str_null_case := 'R.codpadre IS NULL';
ELSE
	str_null_case := 'R.codpadre = '||quote_literal(_codigopadre);
END IF;
--obtengo el coste indirecto:
EXECUTE FORMAT ('SELECT propiedades->>''Valor'' FROM %I WHERE propiedades->>''Propiedad'' = ''Costes indirectos''',tabla_propiedades) INTO coste_indirecto;
coste_indirecto = (100+coste_indirecto)/100;
--averiguo la naturaleza del nodo abuelo para ver si tengo que multiplicar por el coste indirecto
EXECUTE FORMAT ('SELECT naturaleza FROM %I WHERE codigo = $1', tabla_conceptos) INTO nat_codigo_abuelo USING _codigopadre;
--averiguo la naturaleza del nodo padre para ver si tengo que multiplicar por el coste indirecto
EXECUTE FORMAT ('SELECT naturaleza FROM %I WHERE codigo = $1', tabla_conceptos) INTO nat_codigo_padre USING _codigohijo;
--nodo padre	
 FOR var_r IN EXECUTE FORMAT ('SELECT  
        C.codigo,
	C.naturaleza,
	C.ud,
	C.resumen,
	R.canpres,
	R.cancert,
	R.cancert / NULLIF(R.canpres,0) AS portcertpres,
	C.preciomed,
	C.preciocert,
	R.canpres * C.preciomed as imppres,
	R.cancert * C.preciocert as impcert
FROM  %I AS C, %I AS R WHERE C.codigo = $1 
AND %s
AND R.codhijo = C.codigo',tabla_conceptos, tabla_relacion , str_null_case) USING _codigohijo
 LOOP
        ret_codigo := var_r.codigo;
        ret_naturaleza := var_r.naturaleza;
        ret_ud := var_r.ud;
        ret_resumen := var_r.resumen;
        ret_canpres := var_r.canpres;
        ret_cancert := var_r.cancert;
        ret_portcertpres := var_r.portcertpres;
        ret_preciomed := var_r.preciomed;
        ret_preciocert := var_r.preciocert;
        ret_imppres := var_r.imppres;
        ret_impcert := var_r.impcert;
	IF nat_codigo_abuelo = 6 AND nat_codigo_padre != 6 THEN
		ret_imppres := var_r.imppres * coste_indirecto;
		ret_impcert := var_r.impcert * coste_indirecto;
	END IF;
        RETURN NEXT;
 END LOOP;
 --nodos hijos
 FOR var_r IN EXECUTE FORMAT ('SELECT
	C.codigo,
	C.naturaleza,
	C.ud,
	C.resumen,
	R.canpres,
	R.cancert,
	R.cancert/NULLIF(R.canpres,0) AS portcertpres,
	C.preciomed,
	C.preciocert,
	R.canpres * C.preciomed as imppres,
	R.cancert * C.preciocert as impcert
 FROM %I AS C,%I AS R WHERE R.codpadre = $1
 AND C.codigo = R.codhijo ORDER BY R.posicion', tabla_conceptos, tabla_relacion) USING _codigohijo
 LOOP
        ret_codigo := var_r.codigo;
        ret_naturaleza := var_r.naturaleza;
        ret_ud := var_r.ud;
        ret_resumen := var_r.resumen;
        ret_canpres := var_r.canpres;
        ret_cancert := var_r.cancert;
        ret_portcertpres := var_r.portcertpres;
        ret_preciomed := var_r.preciomed;
        ret_preciocert := var_r.preciocert;
	ret_imppres := var_r.imppres;
	ret_impcert := var_r.impcert;
	IF nat_codigo_padre = 6 AND var_r.naturaleza != 6 THEN
		ret_imppres := var_r.imppres * coste_indirecto;
		ret_impcert := var_r.impcert * coste_indirecto;
	END IF;        
        RETURN NEXT;
 END LOOP;
 END; $_$;


ALTER FUNCTION sdmed.ver_hijos(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) OWNER TO sdmed;

--
-- TOC entry 327 (class 1255 OID 39399)
-- Name: ver_lineas_medcert(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _tipocantidad integer) RETURNS TABLE(tipo integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric)
    LANGUAGE plpgsql
    AS $_$
DECLARE
idpadre integer;
idhijo integer;
var_r record;
tablamediciones character varying := _nombretabla || '_Mediciones';
tablaconceptos character varying := _nombretabla || '_Conceptos';
numcert character varying;
str_null_case character varying;
BEGIN
--construimos la cadena del padre
IF _codigopadre = '' IS NOT FALSE THEN
	str_null_case := quote_ident(tablamediciones)||'.codpadre IS NULL';
ELSE
	str_null_case := quote_ident(tablamediciones)||'.codpadre = '||quote_literal(_codigopadre);
END IF;
--la cadena de numcert
IF _tipocantidad = 0 THEN
    numcert = '= 0';
ELSE
    numcert = '>0';
END IF;
--RAISE NOTICE 'lOS DATOS SON: %, %',idpadre,idhijo;

FOR var_r IN EXECUTE FORMAT('SELECT 
	%I.tipo,
	%I.comentario,
	%I.ud,
	%I.longitud,
	%I.anchura,
	%I.altura
  FROM %I WHERE %I.codhijo = $1
  AND %s AND num_certif %s
  ORDER BY %I.id',tablamediciones,tablamediciones,tablamediciones,tablamediciones,tablamediciones,tablamediciones,tablamediciones,tablamediciones,str_null_case,numcert,tablamediciones) USING _codigohijo
 LOOP
        tipo := var_r.tipo;
        comentario := var_r.comentario;
        ud := var_r.ud;
        longitud := var_r.longitud;
        anchura := var_r.anchura;
        altura := var_r.altura;         
        RETURN NEXT;
END LOOP;
END;
$_$;


ALTER FUNCTION sdmed.ver_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _tipocantidad integer) OWNER TO sdmed;

--
-- TOC entry 346 (class 1255 OID 39400)
-- Name: ver_medcert(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_certif integer DEFAULT 0) RETURNS TABLE(fase integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric, formula character varying, parcial numeric, subtotal numeric, tipo integer, id integer, pos integer)
    LANGUAGE plpgsql
    AS $_$
DECLARE 
    var_r record;
    tablamedcert character varying := _nombretabla||'_Mediciones';
    str_null_case character varying;
    acum numeric(10,2) := 0;    
    subt_parc numeric(10,2) := 0;
BEGIN
acum = 0;
IF (_codigopadre = '') IS NOT FALSE THEN
	str_null_case := 'codpadre IS NULL';
ELSE
	str_null_case := 'codpadre = '||quote_literal(_codigopadre);
END IF;
FOR var_r IN EXECUTE FORMAT('SELECT * FROM %I WHERE codhijo = $1 AND %s AND num_certif = $2 ORDER BY posicion',tablamedcert,str_null_case) USING _codigohijo,_num_certif
 LOOP
        fase := var_r.num_certif;
        comentario := var_r.comentario;
        ud := var_r.ud;
        longitud := var_r.longitud;
        anchura := var_r.anchura;
        altura := var_r.altura;
        formula := var_r.formula;        
        parcial := procesar_linea_medicion(var_r.ud, var_r.longitud, var_r.anchura, var_r.altura, var_r.formula);
        --RAISE NOTICE 'El parcial es: %',parcial;
        acum = acum+parcial;
        IF var_r.tipo =1 THEN		
		subtotal = acum - subt_parc;
		subt_parc = acum;
	ELSIF var_r.tipo =2 THEN
		subtotal = acum;
		subt_parc = acum;
	ELSE
		subtotal = 0;
	END IF;
	tipo := var_r.tipo;
        id :=var_r.id;
        pos := var_r.posicion;	
        RETURN NEXT;
 END LOOP;
 END; $_$;


ALTER FUNCTION sdmed.ver_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_certif integer) OWNER TO sdmed;

--
-- TOC entry 330 (class 1255 OID 39401)
-- Name: ver_obra(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_obra(_nombretabla character varying) RETURNS TABLE(codigo character varying, naturaleza integer, ud character varying, resumen character varying, canpres numeric, cancert numeric, portcertpres numeric, preciomed numeric, preciocert numeric, imppres numeric, impcert numeric, depth integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';
punto char :='.';
texto text;

BEGIN
texto := FORMAT ('WITH RECURSIVE tree AS(SELECT codpadre, codhijo, canpres, cancert, 1 AS depth, cast(posicion as text) as camino,posicion from %I
WHERE codpadre is NULL
UNION ALL
SELECT rel.codpadre, rel.codhijo, rel.canpres, rel.cancert, depth+1, camino ||''.''||cast(rel.posicion as text) , rel.posicion
FROM %I rel
JOIN tree t ON rel.codpadre = t.codhijo
)
SELECT C.codigo, C.naturaleza, C.ud, C.resumen, C.descripcion, tree.canpres,tree.cancert, C.preciocert/C.preciomed AS "Porcentaje", C.preciomed, C.preciocert, C.preciomed*tree.canpres as "Importe presupuesto", 
	C.preciocert*tree.cancert as "Importe certifi.", tree.depth 
FROM tree, %I AS C 
WHERE C.codigo=tree.codhijo
ORDER BY string_to_array(camino, ''.'')::int[]',tablarelacion, tablarelacion, tablaconceptos);
raise notice '%', texto;
EXECUTE  (texto);
RETURN NEXT;
END; 
$$;


ALTER FUNCTION sdmed.ver_obra(_nombretabla character varying) OWNER TO sdmed;

--
-- TOC entry 331 (class 1255 OID 39402)
-- Name: ver_obras_bbdd(); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_obras_bbdd() RETURNS TABLE(ret_codigo character varying, ret_resumen character varying)
    LANGUAGE plpgsql
    AS $_$
DECLARE 
    var_r record;
    codigo character varying;
    resumen character varying;
    tablaconceptos character varying;
BEGIN
FOR var_r IN SELECT * FROM pg_tables WHERE tableowner = 'sdmed' AND tablename like '%\_Relacion'
	LOOP        
		EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE codpadre IS NULL',var_r.tablename) INTO codigo;
		tablaconceptos = CONCAT(codigo,'_Conceptos');
		raise notice '%',tablaconceptos;
		EXECUTE FORMAT ('SELECT resumen FROM %I WHERE codigo = $1',tablaconceptos) INTO resumen USING codigo;
		ret_codigo :=codigo;
		ret_resumen := resumen;	
		RETURN NEXT;
	END LOOP;
END; $_$;


ALTER FUNCTION sdmed.ver_obras_bbdd() OWNER TO sdmed;

--
-- TOC entry 332 (class 1255 OID 39403)
-- Name: ver_precio(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_precio(_nombretabla character varying, _cod character varying DEFAULT NULL::character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
precio_partida numeric;
tipo_precio character varying := 'preciomed';
BEGIN
IF _cod IS NULL or _cod = '' THEN
	_cod = _nombretabla;
END IF;
EXECUTE FORMAT ('SELECT preciobloq FROM %I WHERE codigo = %L',tablaconceptos,_cod) INTO precio_partida;
IF precio_partida IS NULL THEN
	EXECUTE FORMAT ('SELECT preciomed FROM %I WHERE codigo = %L',tablaconceptos,_cod) INTO precio_partida;
END IF;
return precio_partida;
END;
$$;


ALTER FUNCTION sdmed.ver_precio(_nombretabla character varying, _cod character varying) OWNER TO sdmed;

--
-- TOC entry 343 (class 1255 OID 40028)
-- Name: ver_resumen_capitulos(character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_resumen_capitulos(_nombretabla character varying) RETURNS TABLE(codigo character varying, resumen character varying, cantidad numeric, total numeric, porcentaje numeric)
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablarelacion character varying := _nombretabla || '_Relacion';
tablaconceptos character varying := _nombretabla || '_Conceptos';
var_r record;
BEGIN
FOR var_r IN EXECUTE FORMAT('SELECT codigo,resumen,canpres, canpres*preciomed as total, 100.0 * canpres * preciomed / sum(canpres * preciomed) over() AS porcentaje
FROM  %I AS C INNER JOIN %I AS R 
ON C.codigo = R.codhijo AND R.codpadre = $1 ORDER BY codigo',tablaconceptos,tablarelacion) USING _nombretabla
 LOOP
        codigo := var_r.codigo;
        resumen := var_r.resumen;
        cantidad := var_r.canpres;
        total := var_r.total;
        porcentaje := var_r.porcentaje;                
        RETURN NEXT;
END LOOP;
END;
$_$;


ALTER FUNCTION sdmed.ver_resumen_capitulos(_nombretabla character varying) OWNER TO sdmed;

--
-- TOC entry 333 (class 1255 OID 39404)
-- Name: ver_siguiente(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_siguiente(nombretabla character varying, codpadre character varying, codhijo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying := nombretabla||'_Relacion';
str_null_case character varying;
cod_siguiente character varying;
BEGIN
IF (codpadre = '') IS NOT FALSE THEN
	str_null_case := 'codpadre IS NULL';
ELSE
	str_null_case := 'codpadre = '||quote_literal(codpadre);
END IF;
EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE %s AND posicion = (SELECT posicion FROM %I WHERE %s AND codhijo = %L)+ 1',
tablarelacion,str_null_case,tablarelacion,str_null_case,codhijo) INTO cod_siguiente;
IF cod_siguiente = '' IS NOT FALSE THEN cod_siguiente = codhijo; END IF;
return cod_siguiente;
END;
$$;


ALTER FUNCTION sdmed.ver_siguiente(nombretabla character varying, codpadre character varying, codhijo character varying) OWNER TO sdmed;

--
-- TOC entry 334 (class 1255 OID 39405)
-- Name: ver_texto(character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_texto(nombretabla character varying, cod character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := nombretabla||'_Conceptos';
texto_partida text;
BEGIN
EXECUTE FORMAT ('SELECT descripcionhtml FROM %I WHERE codigo = %L',tablaconceptos,cod) INTO texto_partida;
return texto_partida;
END;
$$;


ALTER FUNCTION sdmed.ver_texto(nombretabla character varying, cod character varying) OWNER TO sdmed;

--
-- TOC entry 335 (class 1255 OID 39406)
-- Name: ver_todas_certificaciones(character varying, character varying, character varying); Type: FUNCTION; Schema: sdmed; Owner: sdmed
--

CREATE OR REPLACE FUNCTION sdmed.ver_todas_certificaciones(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) RETURNS TABLE(fase integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric, formula character varying, parcial numeric, subtotal numeric, tipo integer, id integer, pos integer)
    LANGUAGE plpgsql
    AS $_$
DECLARE 
    var_r record;
    tablamedcert character varying := _nombretabla||'_Mediciones';
    str_null_case character varying;
    acum numeric(7,3) := 0;    
    subt_parc numeric(7,3) := 0;
BEGIN
acum = 0;
IF (_codigopadre = '') IS NOT FALSE THEN
	str_null_case := 'codpadre IS NULL';
ELSE
	str_null_case := 'codpadre = '||quote_literal(_codigopadre);
END IF;
FOR var_r IN EXECUTE FORMAT('SELECT * FROM %I WHERE codhijo = $1 AND %s AND num_certif > 0 ORDER BY posicion',tablamedcert,str_null_case) USING _codigohijo
 LOOP
        fase := var_r.num_certif;
        comentario := var_r.comentario;
        ud := var_r.ud;
        longitud := var_r.longitud;
        anchura := var_r.anchura;
        altura := var_r.altura;
        formula := var_r.formula;        
        parcial := procesar_linea_medicion(var_r.ud, var_r.longitud, var_r.anchura, var_r.altura, var_r.formula);
        --RAISE NOTICE 'El parcial es: %',parcial;
        acum = acum+parcial;
        IF var_r.tipo =1 THEN		
		subtotal = acum - subt_parc;
		subt_parc = acum;
	ELSIF var_r.tipo =2 THEN
		subtotal = acum;
		acum = acum - parcial;
	ELSE
		subtotal = 0;
	END IF;
	tipo := var_r.tipo;
        id :=var_r.id;
        pos := var_r.posicion;	
        RETURN NEXT;
 END LOOP;
 END; $_$;


ALTER FUNCTION sdmed.ver_todas_certificaciones(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) OWNER TO sdmed;

SET default_tablespace = '';

SET default_with_oids = false;

SELECT sdmed.crear_tabla_aceros();

ALTER TABLE sdmed."tAcero" OWNER TO sdmed;
ALTER SEQUENCE sdmed."tCorrugados_id_seq" OWNER TO sdmed;

-- Completed on 2021-02-19 19:27:41 CET

--
-- PostgreSQL database dump complete
--
