create function hex_to_decimal(hex_string text)
returns text
language plpgsql immutable as $pgsql$
declare
    bits bit varying;
    result numeric := 0;
    exponent numeric := 0;
    chunk_size integer := 31;
    start integer;
begin
    execute 'SELECT x' || quote_literal(hex_string) INTO bits;
    while length(bits) > 0 loop
        start := greatest(1, length(bits) - chunk_size);
        result := result + (substring(bits from start for chunk_size)::bigint)::numeric * pow(2::numeric, exponent);
        exponent := exponent + chunk_size;
        bits := substring(bits from 1 for greatest(0, length(bits) - chunk_size));
    end loop;
    return trunc(result, 0);
end
$pgsql$;