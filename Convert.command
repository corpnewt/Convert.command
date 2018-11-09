#!/usr/bin/env python
import sys, os, re, binascii, base64, shlex

def cls():
    os.system('cls' if os.name=='nt' else 'clear')

def grab(prompt):
    if sys.version_info >= (3, 0):
        return input(prompt)
    else:
        return str(raw_input(prompt))

def _check_hex(value):
    # Remove 0x/0X
    return re.sub(r'[^0-9A-Fa-f]+', '', value.replace("0x", "").replace("0X", ""))

def _ascii_to_base64(value):
    return base64.b64encode(value.encode("utf-8")).decode("utf-8")

def _ascii_to_hex(value):
    return binascii.hexlify(value.encode("utf-8")).decode("utf-8")

def _base64_to_ascii(value):
    return base64.b64decode(value.encode("utf-8")).decode("utf-8")

def _base64_to_hex(value):
    return binascii.hexlify(base64.b64decode(value.encode("utf-8"))).decode("utf-8")

def _hex_to_ascii(value):
    return binascii.unhexlify(_check_hex(value).encode("utf-8")).decode("utf-8")

def _hex_to_base64(value):
    return base64.b64encode(binascii.unhexlify(_check_hex(value).encode("utf-8"))).decode("utf-8")

def _hex_dec(value):
    value = _check_hex(value)
    try:
        dec = int(value, 16)
    except:
        return None
    return dec

def _dec_hex(value):
    try:
        input_dec = int(value)
    except:
        return None
    min_length = 2
    hex_str = "{:x}".format(input_dec).upper()
    hex_str = "0"*(len(hex_str)%min_length)+hex_str
    return "0x"+hex_str

def _hex_swap(value):
    input_hex = _check_hex(value)
    if not len(input_hex):
        return None
    # Normalize hex into pairs
    input_hex = list("0"*(len(input_hex)%2)+input_hex)
    hex_pairs = [input_hex[i:i + 2] for i in range(0, len(input_hex), 2)]
    hex_rev = hex_pairs[::-1]
    hex_str = "".join(["".join(x) for x in hex_rev])
    return hex_str.upper()

def main():
    cls()
    while True:
        i = grab("What to convert? (h=hex, a=ascii, b=base64, d=decimal, s=hexswap [from_type(optional for hexswap) to_type value]):  ")
        if i.lower() == "q":
            exit()
        i = shlex.split(i)
        print("")
        if len(i) != 3:
            # Check for hexswap
            if i[0][0].lower()=="s":
                # Swaptime!
                v = _hex_swap(i[1])
                if v:
                    print(v)
                    print("")
                    continue
            print("Missing info - make sure input is [from_type(optional for hexswap) to_type value].  Valid types are h (hex), a (ascii), b (base64), d (decimal), and s (hexswap).")
            continue
        f, t, v = i[0][0].lower(), i[1][0].lower(), i[2]
        types = ["a", "b", "d", "h"]
        if not f in types or not t in types:
            print("Invalid from/to types.  Valid types are h (hex), a (ascii), b (base64), d (decimal), and s (hexswap).")
            continue
        if f==t:
            print(v)
            print("")
        r = None
        if f=="a":
            if t=="b":
                r = _ascii_to_base64(v)
            elif t=="h":
                r = _ascii_to_hex(v)
        elif f=="b":
            if t=="a":
                r = _base64_to_ascii(v)
            elif t=="h":
                r = _base64_to_hex(v)
        elif f=="h":
            if t=="a":
                r = _hex_to_ascii(v)
            elif t=="b":
                r = _hex_to_base64(v)
            elif t=="d":
                r = _hex_dec(v)
        elif f=="d":
            if t=="h":
                r = _dec_hex(v)

        if not r:
            print("Looks like I couldn't get that value.  May not be valid.")
        else:
            print(r)
        print("")

main()
