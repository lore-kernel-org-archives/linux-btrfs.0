Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ngcobalt08.manitu.net ([217.11.48.108]:41737 "EHLO
	ngcobalt08.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAERuu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jan 2014 12:50:50 -0500
Message-ID: <52C99B76.2020604@dergleichrichter.de>
Date: Sun, 05 Jan 2014 18:50:46 +0100
From: Justus Seifert <justus.seifert@dergleichrichter.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: "dhan.war" <wardhan.v.1.0@gmail.com>
Subject: Re: how to properly mount an external usb hard drive & other questions
References: <52C8E0D1.2070904@gmail.com> <52C999D2.4000006@dergleichrichter.de>
In-Reply-To: <52C999D2.4000006@dergleichrichter.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="PNeoE9xOP0ASx86XdB3rTJmiRp8CA09oB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PNeoE9xOP0ASx86XdB3rTJmiRp8CA09oB
Content-Type: multipart/mixed;
 boundary="------------020902070008070709000902"

This is a multi-part message in MIME format.
--------------020902070008070709000902
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05.01.2014 18:43, Justus Seifert wrote:
> On 05.01.2014 05:34, dhan.war wrote:
>> hi all
>>
>> i am using up to date debian sid with xfce desktop environment. i am
>> using Linux 3.13-rc6-amd64 #1 SMP Debian 3.13~rc6-1~exp1 (2013-12-30)
>> x86_64 GNU/Linux from experimental.
>> i have installed usbmount to auto mount all the devices connected
>> through USB.
>> [=E2=80=A6]
>>
>> [e] what is the appropriate fstab entry for my device ? [ i don't want=

>> to remove usbmount].
>=20
> /dev/sdc /path/to/your/favorite/mountpoint/that/has/to/exist/already
> btrfs compress,noauto 0 0

oh i forgot: if you want to mount it without su privileges you have to us=
e:
/dev/sdc /path/to/your/favorite/mountpoint compress,noauto,users,user 0 0=


also look into subvolume mounting with "subvol=3Dmyfirstsubvolume" in you=
r
list of mount options, if you want to do cool stuff with subvolumes.



--------------020902070008070709000902
Content-Type: text/x-vcard; charset=utf-8;
 name="justus_seifert.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="justus_seifert.vcf"

YmVnaW46dmNhcmQNCmZuOkp1c3R1cyBTZWlmZXJ0DQpuOlNlaWZlcnQ7SnVzdHVzDQphZHI6
Ozs7RHJlc2RlbjtTYXhvbnk7O0dlcm1hbnkNCmVtYWlsO2ludGVybmV0Omp1c3R1cy5zZWlm
ZXJ0QGRlcmdsZWljaHJpY2h0ZXIuZGUNCnRlbDtjZWxsOis0OTE1NzMwNjQwNTA5DQp4LW1v
emlsbGEtaHRtbDpGQUxTRQ0KdmVyc2lvbjoyLjENCmVuZDp2Y2FyZA0KDQo=
--------------020902070008070709000902--

--PNeoE9xOP0ASx86XdB3rTJmiRp8CA09oB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSyZt2AAoJELFJh75Z+IvIx8gQAMsQlvIVV+Y4kFmmQI8qadDk
4e3ffDRB5CDvostIfYVrBjSLTtEYI3IrKb/qsY73x4MKcKwFDjejtpY/yIicXH3d
9R89hVMeTlN1MLIp5U9S5nCGyUYyemP7TSOtSZCCeaqEHctukkBWe+nqheWwep3P
+7k9YWNMkF2FsUfzvLWf+r8kl0hz1K1gKIKjh1K2QyrhU8JLqGwgFQgVx+wWkcq0
0QpLIsL3KtXdRd0HzHTQTnmxcDIRzS15GaCAGxb++rUUHCR2g8RE8z1jvlfR5hgZ
Irfgvv4UWopDQ75gSOcQyavJdO8+tj2b09mO6LcRjsEhOtkOKSH5yCBjtR33TrES
sZPQ1/wzayhg9839rPMt02bK9re5Ki5ffEIO2mI3OSdeUKgxnv31c2yvTEsvu1ki
YNsBab2i6TkqdGGECK1ws2ilzcNzZFcDYDXvfGqPW9SG7ggPwhNTF+5dPGvcEh8y
WZY1JhEn0xCYX8Ed/5/4XoFO4FtjeShpMQfCYSFIHzpmplaJ5Ssj7LQlSdSWY5jD
BdDYwP88pwxWoe3d9kDUuezP1cvAyZRgvv7Jh0SPkqILL3XjYGAP7zOvdryH4BqE
x486AS/CcBiA1V0YOx3KCs91EBaLuWwtUgb/H8+TRam/6qNkNUy+ikMYnPMhc694
LMd68nDZWCyU0GOuZQG3
=Rf82
-----END PGP SIGNATURE-----

--PNeoE9xOP0ASx86XdB3rTJmiRp8CA09oB--
