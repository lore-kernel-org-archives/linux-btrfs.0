Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.ispconfig.waimanu.io ([46.4.54.26]:54818 "EHLO
        mail.ispconfig.waimanu.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbdAOUum (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Jan 2017 15:50:42 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.ispconfig.waimanu.io (Postfix) with ESMTP id F37A920E5038
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jan 2017 21:41:16 +0100 (CET)
Received: from mail.ispconfig.waimanu.io ([127.0.0.1])
        by localhost (mail.ispconfig.waimanu.io [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qJixtlLn70QF for <linux-btrfs@vger.kernel.org>;
        Sun, 15 Jan 2017 21:41:16 +0100 (CET)
Received: from roundcube.waimanu.io (apache [10.23.0.194])
        (Authenticated sender: yosijo@waimanu.io)
        by mail.ispconfig.waimanu.io (Postfix) with ESMTPSA id EB29920E5024
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jan 2017 21:41:15 +0100 (CET)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="=_af246e3981a2e980d35fef8bfa3456cc"
Date: Sun, 15 Jan 2017 21:41:15 +0100
From: York-Simon Johannsen <yosijo@waimanu.io>
To: Linux btrfs <linux-btrfs@vger.kernel.org>
Subject: delete subvolume bad key order
Message-ID: <57b7141f8a502f842383016252e33bd5@yosijo.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)

--=_af246e3981a2e980d35fef8bfa3456cc
Content-Type: multipart/mixed;
 boundary="=_304944cb7a36f7002f4276eb0029a537"

--=_304944cb7a36f7002f4276eb0029a537
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

Hello,

i have the message 'bad key order' and as you can see is the message of 
the debug very creepy. The RAM is ECC based and i have already checked 
this, no errors here. A 'btrfs check --repair' unfortunately did not 
help. What else can I do?

The system builds as follows:

sda ---------------\
sdb --\             \
sdc ----md0(Raid5)-----vg0(Stripe)--btrfs2(lv)--btrfs
sdd --/


Log:
http://pastebin.com/Pu9ENpUM

Overview:
http://pastebin.com/PnddKQYz

Debug:
http://pastebin.com/qmR30AjJ

Greeting York
--=_304944cb7a36f7002f4276eb0029a537
Content-Transfer-Encoding: 7bit
Content-Type: application/pgp-keys;
 name=0xD987052F.asc
Content-Disposition: attachment;
 filename=0xD987052F.asc;
 size=5724

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

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
bkBnbWFpbC5jb20pIDx5b2pvaGFubnNlbkBnbWFpbC5jb20+iQI9BBMBCAAnBQJX
bqYQAhsDBQkBPGFnBQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJECkbqG/ZhwUv
LMgP+gMb4Dm5AHGORVeBbrnVSokCbBRbgXECGEZs/3T77j3EfSqiw+Baj2kTdMki
bNDlY2yiAAtW1crjbbz/GfaosRQS5U9ZUO1mmrEdHB5ibhm+As0TKQUoVyiwj/yH
b6us4LJywaRWqGnYlzUBEa6fL0QD6t8DEliCygbCmuxPmrI1lOmBcsQmfMR067w/
bfBzr9tK2cq6K81S0do+i15mxah53MVa7V6aACm5/KWcRiqDZ09yKYpQNbGwlcue
JT1mKCbomY37do0RFKpxR6dRJEkT8Udmr4QsuocIVpsKzf6XvlcqW7u3QfSRb7LX
H44Bno0jxcR4+EuziFRZVzr5i+t4ysnep0+ghNaWvulO5QVlflXCsLSpL4d0uiHV
wKozam+LsPk/nhsqggtQGTe43F3TjfVKN9xGMsb1zFQNXxFLudEQVWY2gd1OJe8k
YZ6bgpXQVYxraQZIdpHL9HVU596bm+5y71swEWd36ksT0iywBPyzHeyFWgbzze9/
UGQPs6QZNY4qwOUSCqN1tU8rjXS0CTMa1xWlIa8rLtH++v/inH+nS8VUTp2z6gwE
DnAesm8NiKpuA0nFumjPycxe4XOsBTay6UeEylEHRxANgFicJ8lOPNksCoeJCF05
2yi3jMocYVWfox5e8Y7XHliM/yXZNWZ96H/yyE300GyWr24utDxZb3JrLVNpbW9u
IEpvaGFubnNlbiAoeW9zaWpvQHdhaW1hbnUuaW8pIDx5b3Npam9Ad2FpbWFudS5p
bz6JAj0EEwEIACcFAle8cNcCGwMFCQE8YWcFCwkIBwIGFQgJCgsCBBYCAwECHgEC
F4AACgkQKRuob9mHBS9dWBAAgo3rh3JpL6DhENrDMcL97E+90JMyGx7q1MYS42Pp
GBOf4f6CsiQMJ+zGliV4N4XYM8KH/T+FhTBzi27YJDd6YX9dh0VEh4cR2tjnZXxl
ahKl8BJDkBjAdHS96MwxApNYkX51kLGvglqgFDgecAojtswfmFrXwAcMKD4r+AeV
tjwLGMnvRuV57d6QYFrELjmP0GN0kJrdqvS9ZJNakXLy7GKiJ3kNto5b7cql5Jgk
Rb1mCBytoofkER9hkNZ/RYIQtmoX8OQGv6Z/Jpf0fNU+QP9nEIcyfnq6kyVuIp5V
UfbMTa6GMwuD/tAR0A6ID657xamDDoF01mR2CDIQ2fr4nR4kKG0NGbz228wXnwo4
PD/9gGgIYRKgiGV+tqSburLO4ZpJXEClbTAVWMUSl6cVmNeW8RFK3ICxHBmzlNZP
MYLlv6gu8dvPc2P9j9m2wFIf0sJp4ekycX3ClkZheQQWSOXJdsEUwrHOI5Y+XYQA
mHdb+8sx7udaf/E9RRow8ZeEmup0zeETjS/UO11smgMuEz8YZYqABgDtHINQDJ1f
UQeeUAa1fTUZceIrKHi9w2c4BVdGpaLT7H76u6DhG2FU1Z6pDJTmfYGBQWNJUmXM
U7lcz8o9Hf8BC2Z2M1AgNAyUQGwPyVZBcOBZrYoOh9IQLg+lpSn9ucpBS+DmOfiO
DjO5Ag0EV1QMyQEQAMak2vDJv1DumFvPioDim6Vp24NBmWvCexTZvhCDE4t92IfP
kQbpihl+ceDeMKF42N/xAnjuNgCcXDDi9RGWatQja178ygT56Tj2+5X4bPcaJ1Nj
2YIQ7zKO1TxdcJ/dWLKT65dls5ZbSi+gmZlcIXNrdIWSd0uozKjXcS8VoOfoBMNH
rxTMoKEULTHveOsmIKu9lFZtbiC49HnZsO7Dgs1xvDDzvvjIoBFgytBqnO/LUyoP
PVCPcyEqY7jN5AlwBaJYspcJCr6+mYTzPpWiqLHKz1kbUP7cICevqwzVUf1RfVTl
lHatD1UZwwQAucRfuUrdqoiSv4/tPuttZ8efea0OgGAkAE7vuPjBAgiRb2lWMM+V
Y60RAXeb7RvUWzRKL59E/Y7FbUoC6jCkHX2HEUK8Ed1DK21Emz5zpfxUXarGz+So
SLRLLvCrFIaQtncihDRu9sOx5ChcklIWwmptRiqlCGrAZYKcxwBWHCj//hC2fRkR
I2VL62scQuKvMDLwFDiQD3DM7zH2uQQa8T3V8CAH47A4p2auSfun3iYqe+s2W9s+
SdKAuFis5nX4FIb775drBkckCc4tBtyAjv7vhkLkZkdXHAslBZMC4rUhraqnu/Nb
ZAw9D7+59c+DAfBcglyKvqAeyaCHxfK2x44NfEwCMHeFim5w+4uBcCPnV2gHABEB
AAGJAiUEGAEIAA8FAldUDMkCGwwFCQE8YWcACgkQKRuob9mHBS8p3g/9FXSM3ra6
V92dtnXTWkMUCYHJ7s4miHN6VyapowUz6zPgthJ56lxMLx4Ag7DC6NCY9xCNfcDD
insVuuHcoI4muOf7OJGOcibAOnRZhmJ1ORZ1Ko39HVpztgkLOu/mgVPE4E+Aim+5
q01K/Azei/pBc3rBe0y/gtESkLXbAL3zgG6PjbLVWi6FW8Jyi171Q5eJjBFDrn6G
l+WlqXnj21oopFTDwCjGCDaze9uFzzEZ+QtsiaYWCsnGf3jLRPdHSw+Zcf9MWjwO
xLOKqxpPfLyEA1yRdW45jHCDgdPDOtRhzS14eFofLhl4L/d90pbpcaLvWnit0CdS
2ObdAI8nEkTgjZB3VyCCU18kDco3IsdKsf5xKuxZwVyxOh75PWUwoYLXHIh8udF7
vTmuC22Z6W43uo7V/SRM+xaAAJN4cPXSfxqX+yRr8zx2QYhUCLGyGaLhWczCwMSx
m6ofD/aSPov44zgVDViPJElSxTOBtkbID4jOnlojvKmdr4TgvF9kX2RslHvJxJIW
0KyJpnWGn5wMJZaua4gdLpEH8WsdyvWieEbZnnnzjEyJLQIf05kSutYR0ae3RtTS
ooXgAYUrvGcxIVIva9NZSznT5xdQKD4t6Dw6rIs8fWCLWvoLtF/MSDGeMsKV4kxk
JYYX+uCVHYhF0sD2tmqzTsSJGixDPHWcqR4=
=WDo7
-----END PGP PUBLIC KEY BLOCK-----

--=_304944cb7a36f7002f4276eb0029a537--


--=_af246e3981a2e980d35fef8bfa3456cc
Content-Type: application/pgp-signature;
 name=signature.asc
Content-Disposition: attachment;
 filename=signature.asc;
 size=819
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYe95rAAoJECkbqG/ZhwUvVlIP/0Fiaa+uyqqp5yagGXT0Bn+3
GgGijM+LV1nqlhKkAwmsXCduyUKYiX8ExN0j1pFxeHWIZD8DqfUAjHJTmJxPP2po
0krbsyQlf0n3AF4O1DLFyVu6zElWha/isRDGuLk1OhdfzoKMNWUTWvi3plEGptso
wpHTDLLQJGPh0wx731dFQ6CmFOIM+arPbc5lLT6gvemhBeRcDMUmZiN2w9pp8/yP
wbISxrmOAzMfO2TIBE2uyZbXqzy4NBXB1O5urgnRU8uiAjCWXbqcQz68tEYRP9Li
qsx4J7PpkLA5Tx7jp+MV7z3yR2oT7f6MBNnMQwRSlPoVbplqw8C55SM25kTftaBA
GPDjx1CnHmt4ww7ngWwRuXoKiW3i80O6PtY+rkmqbICkvTqsOT0Gngqe739aHVTp
OCl/W0UOymalpLdbGywpfDbo9XasEDkejrzEZyJ10z5QRI7F1y09FMA8M/ZlRt2u
ew5g4P5EBG0xt/2yQu+k0dm7C3qBEiczfTb3E51W8hq627crjjQJzp+vr8NuSog1
BjjspRrsdaNQJuDu3DyoZTKS+9DjoXL+3ZfGP8ZyXAC0yBlFF33yB0SykNzZpWNd
x8H8xcH4RR6miBcqdFOubqiNJxNuIbK34KRTHB5MhtcgwDPBcEThxGj7VmDYkbC9
GdwnQrrjHARjfuoMrXyM
=vvPy
-----END PGP SIGNATURE-----

--=_af246e3981a2e980d35fef8bfa3456cc--
