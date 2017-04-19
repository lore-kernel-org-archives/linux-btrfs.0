Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxd2.seznam.cz ([77.75.76.95]:44879 "EHLO mxd2.seznam.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764888AbdDSPYK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 11:24:10 -0400
From: =?utf-8?q?Tade=C3=A1=C5=A1_Berkman?= <T.Berkman@email.cz>
To: <linux-btrfs@vger.kernel.org>
Subject: "No such entry" recurring error
Date: Wed, 19 Apr 2017 17:24:04 +0200 (CEST)
Message-Id: <89F.pCfC.7gfMeXxC2oI.1Ozu4K@seznam.cz>
Mime-Version: 1.0 (szn-mime-2.0.14)
Content-Type: multipart/mixed;
        boundary="=_26b328e854d747d31ff43555=c838966b-ae96-573b-a85b-4142a5c7acdc_="
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=_26b328e854d747d31ff43555=c838966b-ae96-573b-a85b-4142a5c7acdc_=
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

i have btrfs on my root partition (openSUSE Tumbleweed) for a year and hal=
f, but recently i've ran into the following issue - after an attempt to re=
store a snapper snapshot the system stopped booting, claiming:

> BTRFS: error (device sda3) in __btrfs_free_extent:6944: errno=3D-2 no su=
ch entry
> BTRFS: error (device sda3) in btrfs_run_delayed_refs:2956: errno=3D-2 no=
 such entry

after some searching i ran "btrfs check --repair" on the partition. it fix=
ed some errors and the system would start again. but after few days the er=
ror returned, same as before. so i decided to seek help of someone more kn=
owledgeable than me.

system and partition info:
Linux Niddhog 4.10.8-1-default #1 SMP PREEMPT Fri Mar 31 17:16:00 UTC 2017=
 (ea9dcd4) x86_64 x86_64 x86_64 GNU/Linux
btrfs-progs v4.9+20170104
Label: none uuid: 08fb0009-baab-44d4-9a3b-1131d9a17719
Total devices 1 FS bytes used 24.05GiB
devid 1 size 40.00GiB used 28.07GiB path /dev/sda3

Data, single: total=3D24.01GiB, used=3D22.62GiB
System, DUP: total=3D32.00MiB, used=3D16.00KiB
Metadata, DUP: total=3D2.00GiB, used=3D1.43GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

attaching check --repair output.
dmesg output: https://pastebin.com/DRrNbe4H

thank you,
Tade=C3=A1=C5=A1 Berkman
--=_26b328e854d747d31ff43555=c838966b-ae96-573b-a85b-4142a5c7acdc_=
Content-Type: application/octet-stream;
	charset=us-ascii;
	name=repair.log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	size=9347;
	filename=repair.log

ubuntu@ubuntu:~$ sudo btrfs check --repair -p /dev/sda3=0A=
enabling repair mode=0A=
Checking filesystem on /dev/sda3=0A=
UUID: 08fb0009-baab-44d4-9a3b-1131d9a17719=0A=
Incorrect local backref count on 2187468800 root 0 owner 0 offset 0 found =
0 wanted 1 back 0x55737a209070=0A=
Backref disk bytenr does not match extent record, bytenr=3D2187468800, ref=
 bytenr=3D72620543991349252=0A=
Backref 2187468800 parent 201929113600 owner 0 offset 0 num_refs 0 not fou=
nd in extent tree=0A=
Incorrect local backref count on 2187468800 parent 201929113600 owner 0 of=
fset 0 found 1 wanted 0 back 0x557379a470c0=0A=
backpointer mismatch on [2187468800 86016]=0A=
repair deleting extent record: key 2187468800 168 86016=0A=
adding new data backref on 2187468800 root 2205 owner 5853473 offset 0 fou=
nd 1=0A=
adding new data backref on 2187468800 root 258 owner 5853473 offset 0 foun=
d 1=0A=
adding new data backref on 2187468800 parent 199245807616 owner 0 offset 0=
 found 1=0A=
adding new data backref on 2187468800 parent 140226822144 owner 0 offset 0=
 found 1=0A=
adding new data backref on 2187468800 parent 16822583296 owner 0 offset 0 =
found 1=0A=
adding new data backref on 2187468800 parent 16533716992 owner 0 offset 0 =
found 1=0A=
adding new data backref on 2187468800 parent 12417351680 owner 0 offset 0 =
found 1=0A=
adding new data backref on 2187468800 parent 201929113600 owner 0 offset 0=
 found 1=0A=
Backref 12071763968 parent 4277403648 not referenced back 0x557379e549a0=
=0A=
Backref 12071763968 parent 180371062784 root 180371062784 not found in ext=
ent tree=0A=
Incorrect global backref count on 12071763968 found 2 wanted 1=0A=
backpointer mismatch on [12071763968 16384]=0A=
repair deleting extent record: key 12071763968 169 0=0A=
adding new tree backref on start 12071763968 len 16384 parent 180371062784=
 root 180371062784=0A=
Backref 12209799168 parent 3770351616 not referenced back 0x557379eca5f0=
=0A=
Backref 12209799168 parent 12360286208 root 12360286208 not found in exten=
t tree=0A=
Incorrect global backref count on 12209799168 found 2 wanted 1=0A=
backpointer mismatch on [12209799168 16384]=0A=
repair deleting extent record: key 12209799168 169 0=0A=
adding new tree backref on start 12209799168 len 16384 parent 12360286208 =
root 12360286208=0A=
ref mismatch on [12245352448 16384] extent item 0, found 1=0A=
adding new tree backref on start 12245352448 len 16384 parent 0 root 2175=
=0A=
Backref 12245352448 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [12245352448 16384]=0A=
ref mismatch on [12253724672 16384] extent item 0, found 1=0A=
adding new tree backref on start 12253724672 len 16384 parent 0 root 2175=
=0A=
Backref 12253724672 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [12253724672 16384]=0A=
ref mismatch on [12326780928 16384] extent item 0, found 1=0A=
repair deleting extent record: key 12326780928 169 1=0A=
adding new tree backref on start 12326780928 len 16384 parent 0 root 2175=
=0A=
Backref 12326780928 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [12326780928 16384]=0A=
owner ref check failed [12326780928 16384]=0A=
ref mismatch on [16826564608 16384] extent item 0, found 1=0A=
adding new tree backref on start 16826564608 len 16384 parent 0 root 2175=
=0A=
Backref 16826564608 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [16826564608 16384]=0A=
ref mismatch on [140241010688 16384] extent item 0, found 1=0A=
adding new tree backref on start 140241010688 len 16384 parent 0 root 2175=
=0A=
Backref 140241010688 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [140241010688 16384]=0A=
ref mismatch on [140299845632 16384] extent item 0, found 1=0A=
adding new tree backref on start 140299845632 len 16384 parent 0 root 2175=
=0A=
Backref 140299845632 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [140299845632 16384]=0A=
ref mismatch on [140301910016 16384] extent item 0, found 1=0A=
adding new tree backref on start 140301910016 len 16384 parent 0 root 2175=
=0A=
Backref 140301910016 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [140301910016 16384]=0A=
ref mismatch on [145654972416 16384] extent item 0, found 1=0A=
adding new tree backref on start 145654972416 len 16384 parent 0 root 2175=
=0A=
Backref 145654972416 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [145654972416 16384]=0A=
ref mismatch on [180283965440 16384] extent item 0, found 1=0A=
adding new tree backref on start 180283965440 len 16384 parent 0 root 2175=
=0A=
Backref 180283965440 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180283965440 16384]=0A=
ref mismatch on [180287815680 16384] extent item 0, found 1=0A=
adding new tree backref on start 180287815680 len 16384 parent 0 root 2175=
=0A=
Backref 180287815680 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180287815680 16384]=0A=
ref mismatch on [180287881216 16384] extent item 0, found 1=0A=
adding new tree backref on start 180287881216 len 16384 parent 0 root 2175=
=0A=
Backref 180287881216 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180287881216 16384]=0A=
ref mismatch on [180301692928 16384] extent item 0, found 1=0A=
adding new tree backref on start 180301692928 len 16384 parent 0 root 2175=
=0A=
Backref 180301692928 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180301692928 16384]=0A=
ref mismatch on [180330086400 16384] extent item 0, found 1=0A=
adding new tree backref on start 180330086400 len 16384 parent 0 root 2175=
=0A=
Backref 180330086400 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180330086400 16384]=0A=
ref mismatch on [180330201088 16384] extent item 0, found 1=0A=
adding new tree backref on start 180330201088 len 16384 parent 0 root 2175=
=0A=
Backref 180330201088 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180330201088 16384]=0A=
ref mismatch on [180330610688 16384] extent item 0, found 1=0A=
adding new tree backref on start 180330610688 len 16384 parent 0 root 2175=
=0A=
Backref 180330610688 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180330610688 16384]=0A=
ref mismatch on [180330659840 16384] extent item 0, found 1=0A=
adding new tree backref on start 180330659840 len 16384 parent 0 root 2175=
=0A=
Backref 180330659840 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180330659840 16384]=0A=
ref mismatch on [180330725376 16384] extent item 0, found 1=0A=
adding new tree backref on start 180330725376 len 16384 parent 0 root 2175=
=0A=
Backref 180330725376 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180330725376 16384]=0A=
ref mismatch on [180333477888 16384] extent item 0, found 1=0A=
adding new tree backref on start 180333477888 len 16384 parent 0 root 2175=
=0A=
Backref 180333477888 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180333477888 16384]=0A=
ref mismatch on [180334084096 16384] extent item 0, found 1=0A=
adding new tree backref on start 180334084096 len 16384 parent 0 root 2175=
=0A=
Backref 180334084096 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180334084096 16384]=0A=
ref mismatch on [180334198784 16384] extent item 0, found 1=0A=
adding new tree backref on start 180334198784 len 16384 parent 0 root 2175=
=0A=
Backref 180334198784 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180334198784 16384]=0A=
ref mismatch on [180335656960 16384] extent item 0, found 1=0A=
adding new tree backref on start 180335656960 len 16384 parent 0 root 2175=
=0A=
Backref 180335656960 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180335656960 16384]=0A=
ref mismatch on [180337115136 16384] extent item 0, found 1=0A=
adding new tree backref on start 180337115136 len 16384 parent 0 root 2175=
=0A=
Backref 180337115136 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180337115136 16384]=0A=
ref mismatch on [180348698624 16384] extent item 0, found 1=0A=
adding new tree backref on start 180348698624 len 16384 parent 0 root 2175=
=0A=
Backref 180348698624 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180348698624 16384]=0A=
ref mismatch on [180360740864 16384] extent item 0, found 1=0A=
adding new tree backref on start 180360740864 len 16384 parent 0 root 2175=
=0A=
Backref 180360740864 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180360740864 16384]=0A=
ref mismatch on [180360970240 16384] extent item 0, found 1=0A=
adding new tree backref on start 180360970240 len 16384 parent 0 root 2175=
=0A=
Backref 180360970240 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180360970240 16384]=0A=
ref mismatch on [180361330688 16384] extent item 0, found 1=0A=
adding new tree backref on start 180361330688 len 16384 parent 0 root 2175=
=0A=
Backref 180361330688 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180361330688 16384]=0A=
ref mismatch on [180363182080 16384] extent item 0, found 1=0A=
adding new tree backref on start 180363182080 len 16384 parent 0 root 2175=
=0A=
Backref 180363182080 parent 2175 root 2175 not found in extent tree=0A=
backpointer mismatch on [180363182080 16384]=0A=
repaired damaged extent references=0A=
 =0A=
Fixed 0 roots.=0A=
cache and super generation don't match, space cache will be invalidated=
=0A=
checking fs roots [o]=0A=
checking csums=0A=
checking root refs=0A=
found 24754855936 bytes used err is 0=0A=
total csum bytes: 22426472=0A=
total tree bytes: 1467465728=0A=
total fs tree bytes: 1383120896=0A=
total extent tree bytes: 52117504=0A=
btree space waste bytes: 281061131=0A=
file data blocks allocated: 1827836456960=0A=
 referenced 82504736768
--=_26b328e854d747d31ff43555=c838966b-ae96-573b-a85b-4142a5c7acdc_=--

