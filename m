From: devzero@web.de
Subject: multiple device usage
Date: Sat, 27 Dec 2008 00:15:18 +0100
Message-ID: <556243856@web.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=-------------12303333195948709461"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--=-------------12303333195948709461
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

hello,

i have some difficulty in understanding multi-device handling in depth.

as http://btrfs.wiki.kernel.org/index.php/Using=5FBtrfs=5Fwith=5FMultiple=5FDevice=
s=20
tells,

btrfs can span over multiple devices at the same time. (great feature, btw=
 !)

ok then:
=20
mkfs.btrfs -m single -d single  /dev/sdb /dev/sdc - creates a btrfs spanni=
ng=20
over /dev/sdb and sdc

mount /dev/sdb /btrfs - mounts it

btrfs-vol -b /btrfs - does a rebalancing of all data and metadata

btrfs-vol -r /dev/sdc - removes one of the volumes and redistributes any=20
extends in use on sdc to sdb (killer feature!!!)

but what if i want to remove /dev/sdb =3F (as that one is in use for the=20
mount)

regards
roland
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=

Verschicken Sie SMS direkt vom Postfach aus - in alle deutschen und viele=20
ausl=E4ndische Netze zum gleichen Preis!=20
https://produkte.web.de/webde=5Fsms/sms




--=-------------12303333195948709461
Content-Type: message/delivery-status;
 name=""
Content-Disposition: attachment;
 filename=""
Content-Transfer-Encoding: base64


UmVwb3J0aW5nLU1UQTogZG5zOyBmbW1haWxnYXRlMDEud2ViLmRlClgtUG9zdGZpeC1RdWV1
ZS1JRDogMUFEMTBGQjE1OUMxClgtUG9zdGZpeC1TZW5kZXI6IHJmYzgyMjsgZGV2emVyb0B3
ZWIuZGUKQXJyaXZhbC1EYXRlOiBGcmksIDI2IERlYyAyMDA4IDIwOjQwOjA5ICswMTAwIChD
RVQpCgpGaW5hbC1SZWNpcGllbnQ6IHJmYzgyMjsgYnRyZnMtbGludXhAdmdlci5rZXJuZWwu
b3JnCkFjdGlvbjogZmFpbGVkClN0YXR1czogNS4wLjAKRGlhZ25vc3RpYy1Db2RlOiBYLVBv
c3RmaXg7IGhvc3Qgdmdlci5rZXJuZWwub3JnWzIwOS4xMzIuMTc2LjE2N10gc2FpZDogNTU0
CiAgICA1LjAuMCBIaSBbMjE3LjcyLjE5Mi4yMjFdLCB1bnJlc29sdmFibGUgYWRkcmVzczoK
ICAgIDxidHJmcy1saW51eEB2Z2VyLmtlcm5lbC5vcmc+OyBub3N1Y2h1c2VyOyBidHJmcy1s
aW51eEB2Z2VyLmtlcm5lbC5vcmcgKGluCiAgICByZXBseSB0byBSQ1BUIFRPIGNvbW1hbmQp
Cgo=
--=-------------12303333195948709461--
