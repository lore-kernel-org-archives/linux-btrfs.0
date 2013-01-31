Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55743 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3AaV6N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 16:58:13 -0500
Date: Thu, 31 Jan 2013 21:58:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: /home on BTRFS on SSD, now highly fragmenting virtuoso database
 - use autodefrag?
Message-ID: <20130131215810.GO16285@carfax.org.uk>
References: <201301311444.12314.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEfizQhTV1P/vojJ"
In-Reply-To: <201301311444.12314.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vEfizQhTV1P/vojJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 02:44:12PM +0100, Martin Steigerwald wrote:
> Hi!
>=20
> Today I converted my /home from Ext4 to BTRFS by reformatting and copying
> all over again.
>=20
> I created the filesystem with -l 16384 -n 16384 -d single -m single on an
> logical volume Intel SSD 320 and mount with compress=3Dlzo,spacecache. Cu=
rrent state:

   The way that compression is implemented in btrfs, compressed files
always look fragmented, even if they're not. Basically, each
compression block shows up as a single fragment. If the blocks are
next to each other, the file's not actually fragmented, but still
looks like it to fiemap.

[snip]
> Except for a highly fragmenting file:
>=20
> martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobac=
kend> ls -lh
> insgesamt 1,2G
> -rw------- 1 martin martin 1,3G Jan 31 14:07 soprano-virtuoso.db
> -rw-r--r-- 1 martin martin   14 Jan 31 14:06 soprano-virtuoso.lck
> -rw------- 1 martin martin    0 Jan 27 17:52 soprano-virtuoso.lock
> -rw-r--r-- 1 martin martin  13K Jan 31 10:22 soprano-virtuoso.log
> -rw-r--r-- 1 martin martin    0 Jan 27 17:52 soprano-virtuoso.pxa
> -rw-r--r-- 1 martin martin 8,0M Jan 31 14:07 soprano-virtuoso-temp.db
> -rw-r--r-- 1 martin martin  14K Jan 31 14:07 soprano-virtuoso.trx
>=20
>=20
> martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobac=
kend> sudo filefrag soprano-virtuoso.db
> [sudo] password for martin:=20
> soprano-virtuoso.db: 481 extents found
> [=E2=80=A6]

> Now I do not perceive any bottle neck so far and this is an SSD.
>=20
> What would be your recommendation: Add autodefrag to mount options or not?

   For an SSD, probably not worth it.

> For now I am inclined to let it run that way and see how it goes. I am a =
bit
> reluctant about autodefrag cause of the additional writes it causes.
>=20
>=20
> Well, a direct dd of the file to memory is still quite fast:
>=20
> merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuos=
obackend> echo 3 >=20
> /proc/sys/vm/drop_caches; LANG=3DC dd if=3Dsoprano-virtuoso.db of=3D/dev/=
null bs=3D1M
> 1322+0 records in
> 1322+0 records out
> 1386217472 bytes (1.4 GB) copied, 5.34167 s, 260 MB/s
>=20
>=20
> Another database is the Akonadi database, but I am using PostgreSQL for t=
his at
> the moment which tends to use lots of (smaller) files and due to KDE PIM =
=66rom
> KDE SC 4.4.11 still in Debian, there is no mail metadata in it, just cont=
acts and
> calendar metadata.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- What do you give the man who has everything? -- Penicillin is --- =20
                             a good start...                            =20

--vEfizQhTV1P/vojJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUQro8r9z9OVl50rAAQIMRg//TZlpJh7/Dke0zbhTjFxSaecLwltGbhvK
sg6m7xThzIlWg+MbvCoVmFE3JuiSGFnPOo1smRRSwa2z5CPZMsmz0Vvl6+8L8Q8f
BjN/U/hG0NDHAyc+Jz2eyalJTb2Weecy4geRMZsOU1Zc6vjLuSX62lEZDhgOKlXS
vROorCnZVl8SecxZcG3heuFRuGEPEo8vz7pYKVud6viaSxjVEvehl03/ow2xZ20w
mYwOdzLY8dnCWp4RZqtLM6y9+fLbIJETAT9KPmkxt7BYgsQOoXE4aY1XlitHFe25
z7rQS4zegzigcWFZlukPTNidh/1ftTR1g2hx6klHaQD3KRRID4TGU69WxApdA+W4
0dsGtarM+/ry/skf2OpA0oORvmELIzU5Ew3xuDxD+dNerhrHH3AkXrNhtm+Z4B7V
C06GapMxvmqLpB43mqNB4djt5Se3Jxq1dk+j3jw/kHSlzOPs66UHiKj0M/wHRqtt
OTClrst0zqZyNg7ha89d1/Di6PKe0bhQHIRuXAOuHTRSX4lg4iy3z+vPszf1iULQ
ZMsNYlN1OwK0zLV7rL09L9MLjoR9SKJtiO/N/r56PBG24Co/VqJRKYYAGvVrRIOX
M5VJyxHJyMgDZT5xv2y3GdoUdozQu2SdIpw7VJN43eTvPAwGE8wyxuZazrSN9JNZ
3Xtvdz0i9mk=
=G2dY
-----END PGP SIGNATURE-----

--vEfizQhTV1P/vojJ--
