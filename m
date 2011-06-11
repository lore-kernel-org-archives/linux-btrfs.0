From: Libor =?utf-8?q?Klep=C3=A1=C4=8D?= <libor.klepac@bcom.cz>
Subject: crash on linux 2.6.39-1-amd64(debian)
Date: Sat, 11 Jun 2011 13:29:42 +0200
Message-ID: <201106111329.44623.libor.klepac@bcom.cz>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1397573.qblmsj5Dpq";
  protocol="application/pgp-signature";
  micalg=pgp-sha256
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1397573.qblmsj5Dpq
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi, last week i have had crash on btrfs.
 After powerdown (magic sysrq did not work) i wasn't able to boot - system =
was=20
running out of memory. I tried btrfsck from another debian system run from =
usb=20
flash stick, it produced some errors but i was able to mount my filesystem.

hw info
dell latitude 13 with ssd disk OCZ-VERTEX2 120GB

system info
debian unstable with 2.6.39-1-amd64=20
btrfs-tools 0.19+20101101-1

btrfs filesystem is mounted on /home build on top of (now degraded) /dev/md0

mount info=20
/dev/md0 on /home type btrfs (rw,noatime,ssd,compress,space_cache)

i'm running snapbtr every *:12 minutes, crash happened shortly after this, =
all=20
snap subvolumes are gone. I have seen similar crashes before, on 2.6.38,=20
without any problems after reboot.

I'm also using autofs to mount some samba shares from work server , i think=
,=20
that this kind of crash was affected by autofs, because i remember autofs i=
n=20
kernel oops several times

kernel oops (not whole, sorry)
http://klepac.cz/btrfs/07062011104.jpg
after reboot
http://klepac.cz/btrfs/07062011105.jpg
after fsck
http://klepac.cz/btrfs/07062011106.jpg

with regards
Libor

--nextPart1397573.qblmsj5Dpq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJN81GnAAoJEPDvjG7Cn0eO1XsP/idEKi9L++22wxTtHGv2sFhU
+eXolPNIFBudtXE+MmnVOuU9KfZjDgDx/xpYcJ1u89nnXFCIE+MEl7GY4hBUU/V/
ZQuEO/5I7IIkP5Bl0x7GfGk3mHvm0W9fuBvBhOEULRFBshBChiGrxQgpZvKAE6V2
MFabcU/InbrK87ZPbCFdi0H4RMjnTape7AmnUmloeViVjfaGBPqmZvkCXkw8Y3v4
S+J21LYOu6HzMoJzW2Z0TrHADTi8Ibs7ZS0RfrJ/2ancncRljUJvC3hHtakBoajy
HwqqnWlVoD10UU7/SAo6z+/XccJFKGcFT+a5PPO5CHbV8v5oQ5PtxiGGuj5+dM60
DGEnKJ62RH84npyCW/dtjL3a794BpzP2LUO0YZmN3I5WBK0ZwFS4rSWq3Yyg+Arm
fsfFeoLvwuLZEr/vQO4pOaMyisNJlCO65kUhO5p6vyZqWTNEJZbvypibgG3p1yzR
XqqDI61GEkhF6GkCD9lafgMssMCiOHfhf6Y+G5VROfjHK0v3+z2LFJu5x1hw79ng
eav71d8mQwnbm/oz8F+GEAOD3pphGuQSpTFVbhv+pZoqYuCrCkIIQTviij0dha61
7qIeuKdRvMgrrnCR2h8r3VAuaspHxPRVSquno/SJe3rmCZcwoureXNiSJBqukYAT
uWM34Mw+B522vfNcSosm
=jegH
-----END PGP SIGNATURE-----

--nextPart1397573.qblmsj5Dpq--
