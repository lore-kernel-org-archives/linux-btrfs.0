Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ngcobalt08.manitu.net ([217.11.48.108]:41899 "EHLO
	ngcobalt08.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaAERxe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jan 2014 12:53:34 -0500
Message-ID: <52C999D2.4000006@dergleichrichter.de>
Date: Sun, 05 Jan 2014 18:43:46 +0100
From: Justus Seifert <justus.seifert@dergleichrichter.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: "dhan.war" <wardhan.v.1.0@gmail.com>
Subject: Re: how to properly mount an external usb hard drive & other questions
References: <52C8E0D1.2070904@gmail.com>
In-Reply-To: <52C8E0D1.2070904@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DOe8CH7qlbSx0p2EErOCjGUt3SnVsN7Lb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DOe8CH7qlbSx0p2EErOCjGUt3SnVsN7Lb
Content-Type: multipart/mixed;
 boundary="------------050804040003010500070900"

This is a multi-part message in MIME format.
--------------050804040003010500070900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05.01.2014 05:34, dhan.war wrote:
> hi all
>=20
> i am using up to date debian sid with xfce desktop environment. i am
> using Linux 3.13-rc6-amd64 #1 SMP Debian 3.13~rc6-1~exp1 (2013-12-30)
> x86_64 GNU/Linux from experimental.
> i have installed usbmount to auto mount all the devices connected
> through USB.
>=20
> [cmd# 1] i have created btrfs partition on my external USB hard drive
> using the following command :
>=20
> # mkfs.btrfs -f -L btrfs -m single /dev/sdc
> Turning ON incompat feature 'extref': increased hardlink limit per file=

> to 65536
> fs created label btrfs on /dev/sdc
>     nodesize 16384 leafsize 16384 sectorsize 4096 size 931.51GiB
> Btrfs v3.12
>=20
> [cmd# 2] my permissions of the device :
> # ls -l /dev/sdc
> brw-rw---- 1 root floppy 8, 32 Jan  5 09:47 /dev/sdc
>=20
> my questions :
> [a] does the partition created by me is appropriate ?

it seems ok

> [b] how do i specify lzo compression in fstab ? last time when i tried
> to create entry fstab it is complaining about the auto mounting of the
> device by automount.

if you dont want the partition to be mounted with the fstab during boot
then you should add "noauto" to the list of options in the respective
fstab line.

> [c] what compression method is used by btrfs by default for the
> partitions created using the command mentioned above. [ cmd# 1]

none.  if you order mount to use compression without spezifieng the
algo, it will use zlib (thats like gz).  if you do not use the option
"compression" then it will not compress new files.

> [d] does the file permissions for my device are accurate ? [ cmd# 2]

i dont know.  are you member of the group floppy?  what is the purpose
of the group floppy on your machine?  what users are members of the
group floppy?

> [e] what is the appropriate fstab entry for my device ? [ i don't want
> to remove usbmount].

/dev/sdc /path/to/your/favorite/mountpoint/that/has/to/exist/already
btrfs compress,noauto 0 0

> [f] should i use single or dup for the device ?

maybe use single

>=20
> please provide suggestions for configuring my device appropriately.
> thank you for reading the message patiently.
>=20
> please alway cc me.
>=20
> regards,
> wardhan.


i tried to keep it short.  feel free to ask for more.

cheers
justus

--------------050804040003010500070900
Content-Type: text/x-vcard; charset=utf-8;
 name="justus_seifert.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="justus_seifert.vcf"

begin:vcard
fn:Justus Seifert
n:Seifert;Justus
adr:;;;Dresden;Saxony;;Germany
email;internet:justus.seifert@dergleichrichter.de
tel;cell:+4915730640509
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------050804040003010500070900--

--DOe8CH7qlbSx0p2EErOCjGUt3SnVsN7Lb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSyZnYAAoJELFJh75Z+IvIbboP/RUN02TaqblsM3riZ61bhbnF
NWU/6HWetoDqloxApj4MJdDGjlMtEqCG+HeEt8fLjDZBY0487fkiRxi+6AidYs8z
1wtQ4jYAV2rTbItnCaLbmTZcJW10sV1jlTyy3tRgiW6SrRtHbpASjZnlPXjijYc5
v80cKKklus0FNoCmXy1jYdMK/G/ws+rK5qc3W1t2PGT+lj73AiU5ZeSsd7DRcxqn
ug9ZVwDRcQd5TuxduvG1jQUb9oCOhQdGcwkDgjRZ2RsRnHIlvgn53x2DsPljNbmg
/tJ3NifpptiyVEiIu4UTxkZkVS1S35YTbTqA1nCuLMyp/0Iz750eITLw13qLzeCK
W2CHyxxuBhikb1qtMj6uEsf7kTyqB4qaUIc1rma8Nr52RejOgaHmdvQP1i0gRiEp
2GN6/Qj9Mwcdvo6OBtZv34G2DekA4pHB94S83z095CYDKodxH3nxz/ugYvf1Fxxh
obOFMj4PSrwPbeYFNM2xwM0oKJt5tgME5xXg1aQAmSGQsWoBK8ohOwr/qsVk9vnc
zw+wNAtRg6O4TJRcUuEjvQHXm8VpLwQgngauzfAaQ1PvVlzwFsVyKHhXjLme4cYa
08EN654AerU6rpNEGNhn7ahbT0FSLlgpRa2Xj6lz7QvV9CHOJrRy0JR2FAyBJhvC
4bBOk4kB3Q7xAn4pm+9p
=6UJK
-----END PGP SIGNATURE-----

--DOe8CH7qlbSx0p2EErOCjGUt3SnVsN7Lb--
