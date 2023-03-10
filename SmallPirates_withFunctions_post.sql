PGDMP     !    9                 y            SmallPirates    13.1    13.1     ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            ?           1262    24846    SmallPirates    DATABASE     k   CREATE DATABASE "SmallPirates" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_Canada.1252';
    DROP DATABASE "SmallPirates";
                postgres    false            ?            1255    24865    get_stock(text)    FUNCTION     ?   CREATE FUNCTION public.get_stock(text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE stock_val integer;
BEGIN
    SELECT stock INTO stock_val FROM products WHERE product_code=$1;
RETURN stock_val;
END; $_$;
 &   DROP FUNCTION public.get_stock(text);
       public          postgres    false            ?            1255    24867 $   insert_order(integer, text, integer)    FUNCTION     ?  CREATE FUNCTION public.insert_order(integer, text, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
   new_order_id integer;
BEGIN
    SELECT MAX(order_id) INTO new_order_id FROM order_info;
    new_order_id := new_order_id + 1;
    INSERT INTO order_info (order_id, customer_id, product_code, qty) VALUES
        (new_order_id, $1, $2, $3);
RETURN new_order_id;
END; $_$;
 ;   DROP FUNCTION public.insert_order(integer, text, integer);
       public          postgres    false            ?            1255    24866    update_stock()    FUNCTION       CREATE FUNCTION public.update_stock() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    stock_qty integer;
    _order_id integer;
    _prod_code TEXT;
BEGIN
    SELECT max(order_id) INTO _order_id FROM order_info; 
    SELECT qty INTO stock_qty FROM order_info WHERE order_id= _order_id;
    SELECT product_code INTO _prod_code FROM order_info WHERE order_id=_order_id;
    stock_qty := get_stock(_prod_code) - stock_qty;
    UPDATE products SET stock = stock_qty WHERE product_code=_prod_code; 
RETURN stock_qty;
END; $$;
 %   DROP FUNCTION public.update_stock();
       public          postgres    false            ?            1259    24847 	   customers    TABLE     v   CREATE TABLE public.customers (
    customer_id integer,
    first_name text,
    last_name text,
    address text
);
    DROP TABLE public.customers;
       public         heap    postgres    false            ?            1259    24853 
   order_info    TABLE     z   CREATE TABLE public.order_info (
    order_id integer,
    customer_id integer,
    product_code text,
    qty integer
);
    DROP TABLE public.order_info;
       public         heap    postgres    false            ?            1259    24859    products    TABLE     Z   CREATE TABLE public.products (
    product_code text,
    name text,
    stock integer
);
    DROP TABLE public.products;
       public         heap    postgres    false            ?          0    24847 	   customers 
   TABLE DATA           P   COPY public.customers (customer_id, first_name, last_name, address) FROM stdin;
    public          postgres    false    200   ?       ?          0    24853 
   order_info 
   TABLE DATA           N   COPY public.order_info (order_id, customer_id, product_code, qty) FROM stdin;
    public          postgres    false    201   :       ?          0    24859    products 
   TABLE DATA           =   COPY public.products (product_code, name, stock) FROM stdin;
    public          postgres    false    202   ?       ?   ?   x?U?=
?0??Y>ENP?????0?c	"? [?ܾ??~??o?y?=????,?ݳf
W????5?$?Ll;86???y?;.?7?V?F???j?TD??MeU!????/???o|!?/jf7w      ?   I   x?%?A@@D?u?aDuS? 2?;???a?????BЍ?Ǒ??\???{?r????
??K????????      ?   }   x?˱
?0 ???+ns?6?(Z?`L??4j?l?$C?^]<??Zi?A?$????O?[E?y񡝼a?&8Ӏ?2?ޠw?SQ?3??\萇???nZ?Ƙ???|????+s?a??"~;2!?     