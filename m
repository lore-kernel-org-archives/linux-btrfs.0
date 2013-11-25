Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:36294 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab3KYSca (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 13:32:30 -0500
Message-ID: <52939624.1020603@friendlyvirus.org>
Date: Mon, 25 Nov 2013 18:25:40 +0000
From: =?ISO-8859-1?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
MIME-Version: 1.0
To: "list, btrfs" <linux-btrfs@vger.kernel.org>
Subject: btrfsck errors - what to do ?
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Fn77a6cxUm5I8Ukvp4bPFxCeje7NRitge"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Fn77a6cxUm5I8Ukvp4bPFxCeje7NRitge
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi

I have a filesystem which I can mount without problems and use. I've
done a scrub on it two days ago which came back with 0 errors.
Today I ran a btrfsck which displayed quite a lot of errors, I tried
correcting them with the --repair flat, but after, running btrfsck
without the --repair again displays the same errors, so it appears it
didn't correct them.

What do the errors mean ? What should I do with this filesystem ? Format
and copy data back from backup ? Besides the btrfsck errors the
filesystem is behaving normally, no errors or problems. Can I still
trust this filesystem ?

I would really apreciate some advice here.

best,
Miguel Negr=E3o

entire btrfsck output: http://ubuntuone.com/5eezQ0UqSHomKBbqXTKOLa
it's a 50MB file zipped to 3.5MB.

scrub status for 155b2835-4900-47e3-be45-a32f9d27ec8f
	scrub started at Sat Nov 23 23:28:47 2013, running for 37956 seconds
	total bytes scrubbed: 1.13TiB with 0 errors


Incorrect global backref count on 1908117016576 found 1 wanted 2
backpointer mismatch on [1908117016576 4096]
ref mismatch on [1908117020672 4096] extent item 1, found 2
Incorrect global backref count on 1908117020672 found 1 wanted 2
backpointer mismatch on [1908117020672 4096]
ref mismatch on [1908117024768 4096] extent item 1, found 2
Incorrect global backref count on 1908117024768 found 1 wanted 2
backpointer mismatch on [1908117024768 4096]
ref mismatch on [1908117032960 4096] extent item 1, found 2
Incorrect global backref count on 1908117032960 found 1 wanted 2
backpointer mismatch on [1908117032960 4096]
ref mismatch on [1908117041152 4096] extent item 1, found 2
Incorrect global backref count on 1908117041152 found 1 wanted 2
backpointer mismatch on [1908117041152 4096]
ref mismatch on [1908117405696 4096] extent item 1, found 2
Incorrect global backref count on 1908117405696 found 1 wanted 2
backpointer mismatch on [1908117405696 4096]
ref mismatch on [1908117409792 4096] extent item 1, found 2
Incorrect global backref count on 1908117409792 found 1 wanted 2
backpointer mismatch on [1908117409792 4096]
ref mismatch on [1908117684224 4096] extent item 2, found 3
Incorrect global backref count on 1908117684224 found 2 wanted 3
backpointer mismatch on [1908117684224 4096]
ref mismatch on [1908117696512 4096] extent item 2, found 3
Incorrect global backref count on 1908117696512 found 2 wanted 3
backpointer mismatch on [1908117696512 4096]
ref mismatch on [1908117741568 4096] extent item 2, found 3
Incorrect global backref count on 1908117741568 found 2 wanted 3
backpointer mismatch on [1908117741568 4096]
ref mismatch on [1908117749760 4096] extent item 2, found 3
Incorrect global backref count on 1908117749760 found 2 wanted 3
backpointer mismatch on [1908117749760 4096]
ref mismatch on [1908117811200 4096] extent item 2, found 3
Incorrect global backref count on 1908117811200 found 2 wanted 3
backpointer mismatch on [1908117811200 4096]
ref mismatch on [1908117905408 4096] extent item 2, found 3
Incorrect global backref count on 1908117905408 found 2 wanted 3
backpointer mismatch on [1908117905408 4096]
ref mismatch on [1908117913600 4096] extent item 2, found 3
Incorrect global backref count on 1908117913600 found 2 wanted 3
backpointer mismatch on [1908117913600 4096]
ref mismatch on [1908118331392 4096] extent item 1, found 2
Incorrect global backref count on 1908118331392 found 1 wanted 2
backpointer mismatch on [1908118331392 4096]
ref mismatch on [1908130492416 4096] extent item 1, found 2
Incorrect global backref count on 1908130492416 found 1 wanted 2
backpointer mismatch on [1908130492416 4096]
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/sdc1
UUID: 155b2835-4900-47e3-be45-a32f9d27ec8f
cache and super generation don't match, space cache will be invalidated
found 148859392835 bytes used err is 0
total csum bytes: 1870992636
total tree bytes: 9800355840
total fs tree bytes: 6846132224
total extent tree bytes: 673153024
btree space waste bytes: 2150974105
file data blocks allocated: 5702728269824
 referenced 3158280015872
Btrfs v0.20-rc1-335-gf00dd83



--Fn77a6cxUm5I8Ukvp4bPFxCeje7NRitge
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSk5YkAAoJEPo6SjfPe12DHd8IALEwe2rG6qTX78TJGj8OqX2l
Ghn3kzcc6lgHRyJtXlA5iVwSzi/n02QXNkVYkHMbJSBxVFWJ5xygfqenYh1jP0JE
tDqJZb6ol34JY4ff+2l0CFX+8bmYW+Q3DvtpEQYS5wRk/YMm6QuG9E+Ew0TOLD0i
z3Dd57HevDQdPKxnX4hQSQ/8blDlq0N3HoY/F5ZuacfzEchKHuoi4VWIDaL1dqBC
yNyFRq1CJQ/so1DREt8/3MPSdWxeo43erI4LH5qrvdbi0/RXYaa6obqU65gqZzUg
WJ8O9aWpMS30ntpn3jnV9XMuCVLyxRWHJXWsAQhI/Kje8GTj/zlFBUnqdzUz1mM=
=KcZj
-----END PGP SIGNATURE-----

--Fn77a6cxUm5I8Ukvp4bPFxCeje7NRitge--
