Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:36470 "EHLO
	mailgw01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbbFBBbK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 21:31:10 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
	by mailgw01.dd24.net (Postfix) with ESMTP id 46DD15FB40
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2015 01:24:57 +0000 (UTC)
Received: from mailgw01.dd24.net ([192.168.1.35])
	by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
	with ESMTP id ztaK-rR5427K for <linux-btrfs@vger.kernel.org>;
	Tue,  2 Jun 2015 01:24:52 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-188-174-18-198.dynamic.mnet-online.de [188.174.18.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mailgw01.dd24.net (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2015 01:24:52 +0000 (UTC)
Message-ID: <1433208291.7073.52.camel@scientia.net>
Subject: possible raid6 corruption
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Tue, 02 Jun 2015 03:24:51 +0200
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-Q/Xh2M3QiZExG0EPDcJB"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-Q/Xh2M3QiZExG0EPDcJB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi.

The following is a possible corruption of a btrfs with RAID6,... it may
however also be just and issue with the megasas driver or the PERC
controller behind it.
Anyway since RADI56 is quite new in btrfs, an expert may want to have a
look at it whether it's something that needs to be focused on.

I cannot mount the btrfs since the incident:
I.e.
# mount /dev/sd[any disk of the btrfs raid] /mnt/

gives a:
[358466.484374] BTRFS info (device sda): disk space caching is enabled
[358466.484426] BTRFS: has skinny extents
[358466.485421] BTRFS: failed to read the system array on sda
[358466.543422] BTRFS: open_ctree failed

But no valuable data has been on these devices and I haven't really
tried any of the recovery methods.



What I did:
At the university we run a Tier-2 for the LHC computing grid (i.e. we
have loads of storage).
Recently we bought a number of Dell nodes each with 16 6TB SATA disks,
the disks are connected via a Dell PERC H730P controller (which is based
on some LSI Mega*-whatever, AFAIC).

Since I had 10 new nodes I wanted to use the opportunity and do some
extensive benchmarking, i.e. HW RAID vs. MD RAID, vs btrfs-RAID... +
btrfs and ext4, in all reasonable combinations.
The nodes which were used for MD/btrfs-RAID obviously used the PERC in
pass-through-mode.

As said, the nodes are brand new and during the tests the one with
btrfs-raid6 had a fs crash (all others continued to run fine).

System is Debian jessie, except the kernel from sid (or experimental of
that time) 4.0.0 and btrfs-progs 4.0.

The fs was created pretty much standard:=20
# mkfs.btrfs -L data-test -d raid6 -m raid6 /dev/sda /dev/sdb /dev/sdc /dev=
/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sd=
l /dev/sdm /dev/sdn /dev/sdo /dev/sdp

And then there came some heave iozone stressing:=20
# iozone -Rb $(hostname)_1.xls -s 128g -i 0 -i 1 -i 2 -i 5 -j 12 -r 64 -t 1=
 -F /mnt/iozone


Some excerpts from the kerne.log, which might be of interest:=20


May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.479387] Btrfs loaded
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.479680] BTRFS: device label da=
ta-test devid 1 transid 3 /dev/sda
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.482080] BTRFS: device label da=
ta-test devid 2 transid 3 /dev/sdb
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.484047] BTRFS: device label da=
ta-test devid 3 transid 3 /dev/sdc
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.486021] BTRFS: device label da=
ta-test devid 4 transid 3 /dev/sdd
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.487892] BTRFS: device label da=
ta-test devid 5 transid 3 /dev/sde
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.489849] BTRFS: device label da=
ta-test devid 6 transid 3 /dev/sdf
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.491819] BTRFS: device label da=
ta-test devid 7 transid 3 /dev/sdg
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.493919] BTRFS: device label da=
ta-test devid 8 transid 3 /dev/sdh
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.495761] BTRFS: device label da=
ta-test devid 9 transid 3 /dev/sdi
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.497645] BTRFS: device label da=
ta-test devid 10 transid 3 /dev/sdj
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.499477] BTRFS: device label da=
ta-test devid 11 transid 3 /dev/sdk
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.501307] BTRFS: device label da=
ta-test devid 12 transid 3 /dev/sdl
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.503208] BTRFS: device label da=
ta-test devid 13 transid 3 /dev/sdm
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.505037] BTRFS: device label da=
ta-test devid 14 transid 3 /dev/sdn
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.506837] BTRFS: device label da=
ta-test devid 15 transid 3 /dev/sdo
May 10 00:26:39 lcg-lrz-dc10 kernel: [115511.508800] BTRFS: device label da=
ta-test devid 16 transid 3 /dev/sdp
May 10 00:27:34 lcg-lrz-dc10 kernel: [115566.351260] BTRFS info (device sdp=
): disk space caching is enabled
May 10 00:27:34 lcg-lrz-dc10 kernel: [115566.351307] BTRFS: has skinny exte=
nts
May 10 00:27:34 lcg-lrz-dc10 kernel: [115566.351333] BTRFS: flagging fs wit=
h big metadata feature
May 10 00:27:34 lcg-lrz-dc10 kernel: [115566.354089] BTRFS: creating UUID t=
ree



Literally gazillions of these:=20
May 19 02:39:19 lcg-lrz-dc10 kernel: [900318.402678] megasas:span 0 rowData=
Size 1
May 19 02:39:19 lcg-lrz-dc10 kernel: [900318.402705] megasas:span 0 rowData=
Size 1

Wile I saw the above lines on all the other nodes as well, there were
only like 30 once, and that's it.
But on the one node with btrfs the log file was flooded to 1,6GB with
these.


At some point I've had this:=20
May 19 03:25:19 lcg-lrz-dc10 kernel: [903075.511076] megasas: [ 0]waiting f=
or 1 commands to complete for scsi0
May 19 03:25:24 lcg-lrz-dc10 kernel: [903080.526184] megasas: [ 5]waiting f=
or 1 commands to complete for scsi0
May 19 03:25:29 lcg-lrz-dc10 kernel: [903085.541375] megasas: [10]waiting f=
or 1 commands to complete for scsi0
May 19 03:25:34 lcg-lrz-dc10 kernel: [903090.556566] megasas: [15]waiting f=
or 1 commands to complete for scsi0
May 19 03:25:39 lcg-lrz-dc10 kernel: [903095.571755] megasas: [20]waiting f=
or 1 commands to complete for scsi0
May 19 03:25:39 lcg-lrz-dc10 kernel: [903095.585150] megasas: megasas_aen_p=
olling waiting for controller reset to finish for scsi0
May 19 03:25:50 lcg-lrz-dc10 kernel: [903106.581205] sd 0:0:14:0: Device of=
flined - not ready after error recovery

but after that things seemed to have continued for quite a while (except
millions of ("megasas:span 0 rowDataSize 1")... of course I cannot tell
whether this is maybe just because iozone only read during that time and
only a write would have triggered further errors??

First real errors start here:=20
May 28 16:38:01 lcg-lrz-dc10 kernel: [1727446.475425] bash (127422): drop_c=
aches: 3
May 28 16:38:43 lcg-lrz-dc10 kernel: [1727488.984810] sd 0:0:14:0: rejectin=
g I/O to offline device
May 28 16:38:43 lcg-lrz-dc10 kernel: [1727488.985389] sd 0:0:14:0: rejectin=
g I/O to offline device
May 28 16:38:43 lcg-lrz-dc10 kernel: [1727488.985707] sd 0:0:14:0: rejectin=
g I/O to offline device
May 28 16:38:43 lcg-lrz-dc10 kernel: [1727488.986482] sd 0:0:14:0: rejectin=
g I/O to offline device

Again, gazillions of the "rejecting I/O to offline device". As one can
notice, this is the very disk that went offline before.

The drop_caches may be just coincidence. That was I, but it implies
somehow that iozone didn't run at that time and I started only another
round of it afterwards.


In between there were many of these:=20
May 28 16:39:19 lcg-lrz-dc10 kernel: [1727524.067182] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:39:19 lcg-lrz-dc10 kernel: [1727524.067426] BTRFS: bdev /dev/sdm =
errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
May 28 16:39:19 lcg-lrz-dc10 kernel: [1727524.067985] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:39:19 lcg-lrz-dc10 kernel: [1727524.068282] BTRFS: bdev /dev/sdm =
errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
May 28 16:39:19 lcg-lrz-dc10 kernel: [1727524.068992] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:39:19 lcg-lrz-dc10 kernel: [1727524.069370] BTRFS: bdev /dev/sdm =
errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
May 28 16:39:50 lcg-lrz-dc10 kernel: [1727555.332553] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:39:50 lcg-lrz-dc10 kernel: [1727555.332767] BTRFS: bdev /dev/sdm =
errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
May 28 16:39:50 lcg-lrz-dc10 kernel: [1727555.333256] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:39:50 lcg-lrz-dc10 kernel: [1727555.333517] BTRFS: bdev /dev/sdm =
errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
May 28 16:39:50 lcg-lrz-dc10 kernel: [1727555.334111] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:39:50 lcg-lrz-dc10 kernel: [1727555.334432] BTRFS: bdev /dev/sdm =
errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
May 28 16:40:21 lcg-lrz-dc10 kernel: [1727586.739347] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:40:21 lcg-lrz-dc10 kernel: [1727586.739349] BTRFS: bdev /dev/sdm =
errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
May 28 16:40:21 lcg-lrz-dc10 kernel: [1727586.739363] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:40:21 lcg-lrz-dc10 kernel: [1727586.739364] BTRFS: bdev /dev/sdm =
errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
May 28 16:40:21 lcg-lrz-dc10 kernel: [1727586.739372] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:40:21 lcg-lrz-dc10 kernel: [1727586.739373] BTRFS: bdev /dev/sdm =
errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
May 28 16:40:43 lcg-lrz-dc10 kernel: [1727608.168996] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:40:43 lcg-lrz-dc10 kernel: [1727608.169171] BTRFS: bdev /dev/sdm =
errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
May 28 16:40:43 lcg-lrz-dc10 kernel: [1727608.169605] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:40:43 lcg-lrz-dc10 kernel: [1727608.169842] BTRFS: bdev /dev/sdm =
errs: wr 11, rd 0, flush 0, corrupt 0, gen 0
May 28 16:40:43 lcg-lrz-dc10 kernel: [1727608.170401] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:40:43 lcg-lrz-dc10 kernel: [1727608.170703] BTRFS: bdev /dev/sdm =
errs: wr 12, rd 0, flush 0, corrupt 0, gen 0
May 28 16:40:50 lcg-lrz-dc10 kernel: [1727615.608552] BTRFS: bdev /dev/sdm =
errs: wr 12, rd 1, flush 0, corrupt 0, gen 0
May 28 16:41:17 lcg-lrz-dc10 kernel: [1727641.928445] BTRFS: bdev /dev/sdm =
errs: wr 12, rd 2, flush 0, corrupt 0, gen 0
May 28 16:41:20 lcg-lrz-dc10 kernel: [1727645.692650] BTRFS: bdev /dev/sdm =
errs: wr 12, rd 3, flush 0, corrupt 0, gen 0
May 28 16:41:23 lcg-lrz-dc10 kernel: [1727647.999097] BTRFS: bdev /dev/sdm =
errs: wr 12, rd 4, flush 0, corrupt 0, gen 0
May 28 16:41:23 lcg-lrz-dc10 kernel: [1727648.227013] BTRFS: bdev /dev/sdm =
errs: wr 12, rd 5, flush 0, corrupt 0, gen 0
May 28 16:41:30 lcg-lrz-dc10 kernel: [1727654.974354] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:41:30 lcg-lrz-dc10 kernel: [1727654.974512] BTRFS: bdev /dev/sdm =
errs: wr 13, rd 5, flush 0, corrupt 0, gen 0
May 28 16:41:30 lcg-lrz-dc10 kernel: [1727654.974888] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:41:30 lcg-lrz-dc10 kernel: [1727654.975083] BTRFS: bdev /dev/sdm =
errs: wr 14, rd 5, flush 0, corrupt 0, gen 0
May 28 16:41:30 lcg-lrz-dc10 kernel: [1727654.975546] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:41:30 lcg-lrz-dc10 kernel: [1727654.975793] BTRFS: bdev /dev/sdm =
errs: wr 15, rd 5, flush 0, corrupt 0, gen 0
May 28 16:42:00 lcg-lrz-dc10 kernel: [1727685.438868] BTRFS: bdev /dev/sdm =
errs: wr 15, rd 6, flush 0, corrupt 0, gen 0
May 28 16:42:00 lcg-lrz-dc10 kernel: [1727685.816052] BTRFS: bdev /dev/sdm =
errs: wr 15, rd 7, flush 0, corrupt 0, gen 0
May 28 16:42:02 lcg-lrz-dc10 kernel: [1727686.886506] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:42:02 lcg-lrz-dc10 kernel: [1727686.886854] BTRFS: bdev /dev/sdm =
errs: wr 16, rd 7, flush 0, corrupt 0, gen 0
May 28 16:42:02 lcg-lrz-dc10 kernel: [1727686.887694] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:42:02 lcg-lrz-dc10 kernel: [1727686.888158] BTRFS: bdev /dev/sdm =
errs: wr 17, rd 7, flush 0, corrupt 0, gen 0
May 28 16:42:02 lcg-lrz-dc10 kernel: [1727686.889257] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:42:02 lcg-lrz-dc10 kernel: [1727686.889847] BTRFS: bdev /dev/sdm =
errs: wr 18, rd 7, flush 0, corrupt 0, gen 0
May 28 16:42:32 lcg-lrz-dc10 kernel: [1727716.910404] BTRFS: bdev /dev/sdm =
errs: wr 18, rd 8, flush 0, corrupt 0, gen 0
May 28 16:42:32 lcg-lrz-dc10 kernel: [1727717.004055] BTRFS: bdev /dev/sdm =
errs: wr 18, rd 9, flush 0, corrupt 0, gen 0
May 28 16:42:32 lcg-lrz-dc10 kernel: [1727717.019085] BTRFS: bdev /dev/sdm =
errs: wr 18, rd 10, flush 0, corrupt 0, gen 0
May 28 16:42:32 lcg-lrz-dc10 kernel: [1727717.043690] BTRFS: bdev /dev/sdm =
errs: wr 18, rd 11, flush 0, corrupt 0, gen 0
May 28 16:42:34 lcg-lrz-dc10 kernel: [1727719.121839] BTRFS: bdev /dev/sdm =
errs: wr 18, rd 12, flush 0, corrupt 0, gen 0
May 28 16:42:35 lcg-lrz-dc10 kernel: [1727720.029509] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:42:35 lcg-lrz-dc10 kernel: [1727720.029606] BTRFS: bdev /dev/sdm =
errs: wr 19, rd 12, flush 0, corrupt 0, gen 0
May 28 16:42:35 lcg-lrz-dc10 kernel: [1727720.029868] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:42:35 lcg-lrz-dc10 kernel: [1727720.029993] BTRFS: bdev /dev/sdm =
errs: wr 20, rd 12, flush 0, corrupt 0, gen 0
May 28 16:42:35 lcg-lrz-dc10 kernel: [1727720.030405] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:42:35 lcg-lrz-dc10 kernel: [1727720.030651] BTRFS: bdev /dev/sdm =
errs: wr 21, rd 12, flush 0, corrupt 0, gen 0
May 28 16:43:05 lcg-lrz-dc10 kernel: [1727750.366637] BTRFS: bdev /dev/sdm =
errs: wr 21, rd 13, flush 0, corrupt 0, gen 0
May 28 16:43:05 lcg-lrz-dc10 kernel: [1727750.526410] BTRFS: bdev /dev/sdm =
errs: wr 21, rd 14, flush 0, corrupt 0, gen 0
May 28 16:43:05 lcg-lrz-dc10 kernel: [1727750.683487] BTRFS: bdev /dev/sdm =
errs: wr 21, rd 15, flush 0, corrupt 0, gen 0
May 28 16:43:06 lcg-lrz-dc10 kernel: [1727751.683162] BTRFS: bdev /dev/sdm =
errs: wr 21, rd 16, flush 0, corrupt 0, gen 0
May 28 16:43:08 lcg-lrz-dc10 kernel: [1727753.642839] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:43:08 lcg-lrz-dc10 kernel: [1727753.643009] BTRFS: bdev /dev/sdm =
errs: wr 22, rd 16, flush 0, corrupt 0, gen 0
May 28 16:43:08 lcg-lrz-dc10 kernel: [1727753.643421] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:43:08 lcg-lrz-dc10 kernel: [1727753.643646] BTRFS: bdev /dev/sdm =
errs: wr 23, rd 16, flush 0, corrupt 0, gen 0
May 28 16:43:08 lcg-lrz-dc10 kernel: [1727753.644159] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:43:08 lcg-lrz-dc10 kernel: [1727753.644420] BTRFS: bdev /dev/sdm =
errs: wr 24, rd 16, flush 0, corrupt 0, gen 0
May 28 16:43:08 lcg-lrz-dc10 kernel: [1727753.736568] BTRFS: bdev /dev/sdm =
errs: wr 24, rd 17, flush 0, corrupt 0, gen 0
May 28 16:43:08 lcg-lrz-dc10 kernel: [1727753.751826] BTRFS: bdev /dev/sdm =
errs: wr 24, rd 18, flush 0, corrupt 0, gen 0
May 28 16:43:09 lcg-lrz-dc10 kernel: [1727753.803959] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:43:09 lcg-lrz-dc10 kernel: [1727753.803962] BTRFS: bdev /dev/sdm =
errs: wr 25, rd 18, flush 0, corrupt 0, gen 0
May 28 16:43:09 lcg-lrz-dc10 kernel: [1727754.027756] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:43:09 lcg-lrz-dc10 kernel: [1727754.029053] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:43:09 lcg-lrz-dc10 kernel: [1727754.030351] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 16:43:11 lcg-lrz-dc10 kernel: [1727756.068101] btrfs_dev_stat_print_=
on_error: 3 callbacks suppressed
May 28 16:43:11 lcg-lrz-dc10 kernel: [1727756.068730] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 19, flush 0, corrupt 0, gen 0
May 28 16:43:11 lcg-lrz-dc10 kernel: [1727756.070009] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 20, flush 0, corrupt 0, gen 0
May 28 16:43:11 lcg-lrz-dc10 kernel: [1727756.071399] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 21, flush 0, corrupt 0, gen 0
May 28 16:43:11 lcg-lrz-dc10 kernel: [1727756.072835] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 22, flush 0, corrupt 0, gen 0
May 28 16:43:11 lcg-lrz-dc10 kernel: [1727756.074251] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 23, flush 0, corrupt 0, gen 0
May 28 16:43:11 lcg-lrz-dc10 kernel: [1727756.075748] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 24, flush 0, corrupt 0, gen 0
May 28 16:43:11 lcg-lrz-dc10 kernel: [1727756.077288] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 25, flush 0, corrupt 0, gen 0
May 28 16:43:11 lcg-lrz-dc10 kernel: [1727756.078899] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 26, flush 0, corrupt 0, gen 0
May 28 16:43:11 lcg-lrz-dc10 kernel: [1727756.080550] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 27, flush 0, corrupt 0, gen 0
May 28 16:43:11 lcg-lrz-dc10 kernel: [1727756.082246] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 28, flush 0, corrupt 0, gen 0
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.066100] btrfs_dev_stat_print_=
on_error: 21558 callbacks suppressed
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.066369] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 21587, flush 0, corrupt 0, gen 0
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.067067] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 21588, flush 0, corrupt 0, gen 0
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.067741] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 21589, flush 0, corrupt 0, gen 0
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.068568] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 21590, flush 0, corrupt 0, gen 0
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.069722] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 21591, flush 0, corrupt 0, gen 0
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.070814] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 21592, flush 0, corrupt 0, gen 0
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.071788] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 21593, flush 0, corrupt 0, gen 0
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.073280] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 21594, flush 0, corrupt 0, gen 0
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.075350] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 21595, flush 0, corrupt 0, gen 0
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.077607] BTRFS: bdev /dev/sdm =
errs: wr 28, rd 21596, flush 0, corrupt 0, gen 0


Later it finally said goodbye:=20
May 28 21:03:06 lcg-lrz-dc10 kernel: [1743336.347191] sd 0:0:14:0: rejectin=
g I/O to offline device
May 28 21:03:06 lcg-lrz-dc10 kernel: [1743336.369204] sd 0:0:14:0: rejectin=
g I/O to offline device
May 28 21:03:06 lcg-lrz-dc10 kernel: [1743336.369569] BTRFS: lost page writ=
e due to I/O error on /dev/sdm
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.093299] sd 0:0:14:0: rejectin=
g I/O to offline device
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.094348] BTRFS (device sdp): b=
ad tree block start 3328214216270427953 3448651776
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.095019] BTRFS (device sdp): b=
ad tree block start 3328214216270427953 3448651776
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.095354] sd 0:0:14:0: rejectin=
g I/O to offline device
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.095872] BTRFS (device sdp): b=
ad tree block start 3328214216270427953 3448651776
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.096551] BTRFS (device sdp): b=
ad tree block start 3328214216270427953 3448651776
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.096927] BTRFS: error -5 while=
 searching for dev_stats item for device /dev/sdm!
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.097314] BTRFS warning (device=
 sdp): Skipping commit of aborted transaction.
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.097715] ------------[ cut her=
e ]------------
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.098160] WARNING: CPU: 1 PID: =
128693 at /build/linux-cJtoh5/linux-4.0/fs/btrfs/super.c:260 __btrfs_abort_=
transaction+0x4b/0x120 [btrfs]()
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.099170] BTRFS: Transaction ab=
orted (error -5)
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.099172] Modules linked in: bt=
rfs xor raid6_pq udp_diag tcp_diag inet_diag nls_utf8 nls_cp437 vfat fat bi=
nfmt_misc cpufreq_userspace cpufreq_cons
ervative cpufreq_stats cpufreq_powersave deflate ctr twofish_generic twofis=
h_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_common camellia_gen=
eric camellia_aesni_avx2 camellia_aesni_avx_x86_64 camellia_x86_64 serpent_=
avx2 serpent_avx_x86_64 serpent_sse2_x86_64 xts serpent_generic blowfish_ge=
neric blowfish_x86_64 blowfish_common cast5_avx_x86_64 cast5_generic cast_c=
ommon des_generic cbc cmac xcbc rmd160 sha512_ssse3 sha512_generic sha256_s=
sse3 sha256_generic hmac crypto_null af_key xfrm_algo ip6table_filter ip6_t=
ables xt_policy ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_comment nf_conntrack=
_ipv4 nf_defrag_ipv4 xt_multiport xt_conntrack nf_conntrack iptable_filter =
ip_tables x_tables ipmi_devintf evdev iTCO_wdt iTCO_vendor_support x86_pkg_=
temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul crc32_pclmul d=
cdbas crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul =
glue_helper ablk_helper cryptd pcspkr mgag200 ttm drm_kms_helper drm sg ipm=
i_si 8250_fintek ipmi_msghandler processor thermal_sys sb_edac edac_core wm=
i acpi_power_meter ixgbe mdio igb ptp pps_core dca i2c_algo_bit i2c_core bu=
tton xhci_pci xhci_hcd ehci_pci mei_me mei ehci_hcd lpc_ich mfd_core usbcor=
e usb_common coretemp fuse autofs4 ext4 crc16 mbcache jbd2 dm_mod md_mod sd=
_mod megaraid_sas scsi_mod shpchp
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.110677] CPU: 1 PID: 128693 Co=
mm: iozone Not tainted 4.0.0-trunk-amd64 #1 Debian 4.0-1~exp1
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.111893] Hardware name: Dell I=
nc. PowerEdge R730xd/0599V5, BIOS 1.0.4 08/28/2014
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.113136]  0000000000000000 fff=
fffffa0859550 ffffffff8155b12e ffff880de4fdfda8
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.114412]  ffffffff8106d2a1 fff=
f8806ad8680c8 00000000fffffffb ffff880856f41000
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.115714]  ffffffffa0855910 000=
0000000000696 ffffffff8106d31a ffffffffa0859628
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.117050] Call Trace:
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.118385]  [<ffffffff8155b12e>]=
 ? dump_stack+0x40/0x50
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.119749]  [<ffffffff8106d2a1>]=
 ? warn_slowpath_common+0x81/0xb0
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.121060]  [<ffffffff8106d31a>]=
 ? warn_slowpath_fmt+0x4a/0x50
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.122362]  [<ffffffffa07a8d2b>]=
 ? __btrfs_abort_transaction+0x4b/0x120 [btrfs]
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.123696]  [<ffffffffa07d625f>]=
 ? cleanup_transaction+0x6f/0x2c0 [btrfs]
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.125050]  [<ffffffff810aab30>]=
 ? wait_woken+0x90/0x90
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.126400]  [<ffffffff810aa724>]=
 ? __wake_up+0x34/0x50
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.127777]  [<ffffffffa07d6f8e>]=
 ? btrfs_commit_transaction+0x2ae/0xa00 [btrfs]
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.129180]  [<ffffffffa07d7d7c>]=
 ? btrfs_attach_transaction_barrier+0x1c/0x50 [btrfs]
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.130604]  [<ffffffff811f3540>]=
 ? do_fsync+0x70/0x70
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.132039]  [<ffffffff811c6130>]=
 ? iterate_supers+0xb0/0x110
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.133409]  [<ffffffff811f3665>]=
 ? sys_sync+0x55/0xa0
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.134768]  [<ffffffff815614cd>]=
 ? system_call_fast_compare_end+0xc/0x11
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.136150] ---[ end trace 8019cf=
83241ac956 ]---
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.137542] BTRFS: error (device =
sdp) in cleanup_transaction:1686: errno=3D-5 IO failure
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.138973] BTRFS info (device sd=
p): forced readonly
May 28 22:54:48 lcg-lrz-dc10 kernel: [1750032.363543] megasas:span 0 rowDat=
aSize 1
May 28 22:54:48 lcg-lrz-dc10 kernel: [1750032.365440] megasas:span 0 rowDat=
aSize 1
May 28 22:54:48 lcg-lrz-dc10 kernel: [1750032.367233] megasas:span 0 rowDat=
aSize 1
May 28 22:54:48 lcg-lrz-dc10 kernel: [1750032.369001] megasas:span 0 rowDat=
aSize 1

...

May 28 22:55:25 lcg-lrz-dc10 kernel: [1750069.147728] megasas:span 0 rowDat=
aSize 1
May 28 22:55:25 lcg-lrz-dc10 kernel: [1750069.147885] megasas:span 0 rowDat=
aSize 1
May 28 22:55:25 lcg-lrz-dc10 kernel: [1750069.148041] megasas:span 0 rowDat=
aSize 1
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.558937] ------------[ cut her=
e ]------------
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.559193] WARNING: CPU: 4 PID: =
134844 at /build/linux-cJtoh5/linux-4.0/fs/btrfs/extent-tree.c:4890 btrfs_f=
ree_block_groups+0x379/0x460 [btrfs]()
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.559747] Modules linked in: bt=
rfs xor raid6_pq udp_diag tcp_diag inet_diag nls_utf8 nls_cp437 vfat fat bi=
nfmt_misc cpufreq_userspace cpufreq_conservative cpufreq_stats cpufreq_powe=
rsave deflate ctr twofish_generic twofish_avx_x86_64 twofish_x86_64_3way tw=
ofish_x86_64 twofish_common camellia_generic camellia_aesni_avx2 camellia_a=
esni_avx_x86_64 camellia_x86_64 serpent_avx2 serpent_avx_x86_64 serpent_sse=
2_x86_64 xts serpent_generic blowfish_generic blowfish_x86_64 blowfish_comm=
on cast5_avx_x86_64 cast5_generic cast_common des_generic cbc cmac xcbc rmd=
160 sha512_ssse3 sha512_generic sha256_ssse3 sha256_generic hmac crypto_nul=
l af_key xfrm_algo ip6table_filter ip6_tables xt_policy ipt_REJECT nf_rejec=
t_ipv4 xt_tcpudp xt_comment nf_conntrack_ipv4 nf_defrag_ipv4 xt_multiport x=
t_conntrack nf_conntrack iptable_filter ip_tables x_tables ipmi_devintf evd=
ev iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp kvm_i=
ntel kvm crct10dif_pclmul crc32_pclmul dcdbas crc32c_intel ghash_clmulni_in=
tel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd pcsp=
kr mgag200 ttm drm_kms_helper drm sg ipmi_si 8250_fintek ipmi_msghandler pr=
ocessor thermal_sys sb_edac edac_core wmi acpi_power_meter ixgbe mdio igb p=
tp pps_core dca i2c_algo_bit i2c_core button xhci_pci xhci_hcd ehci_pci mei=
_me mei ehci_hcd lpc_ich mfd_core usbcore usb_common coretemp fuse autofs4 =
ext4 crc16 mbcache jbd2 dm_mod md_mod sd_mod megaraid_sas scsi_mod shpchp
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.568590] CPU: 4 PID: 134844 Co=
mm: umount Tainted: G        W       4.0.0-trunk-amd64 #1 Debian 4.0-1~exp1
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.569665] Hardware name: Dell I=
nc. PowerEdge R730xd/0599V5, BIOS 1.0.4 08/28/2014
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.570776]  0000000000000000 fff=
fffffa0859bf8 ffffffff8155b12e 0000000000000000
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.571933]  ffffffff8106d2a1 000=
0000000000000 ffff880857551800 ffff88105796c080
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.573114]  ffff88105796c000 fff=
f88105796c090 ffffffffa07c5d39 ffff88105796c000
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.574316] Call Trace:
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.575546]  [<ffffffff8155b12e>]=
 ? dump_stack+0x40/0x50
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.576712]  [<ffffffff8106d2a1>]=
 ? warn_slowpath_common+0x81/0xb0
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.577886]  [<ffffffffa07c5d39>]=
 ? btrfs_free_block_groups+0x379/0x460 [btrfs]
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.579100]  [<ffffffffa07d2cb4>]=
 ? close_ctree+0x154/0x350 [btrfs]
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.580313]  [<ffffffff811df95c>]=
 ? evict_inodes+0xfc/0x110
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.581542]  [<ffffffff811c4aee>]=
 ? generic_shutdown_super+0x6e/0xf0
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.582787]  [<ffffffff811c4dee>]=
 ? kill_anon_super+0xe/0x20
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.584057]  [<ffffffffa07a8927>]=
 ? btrfs_kill_super+0x17/0x100 [btrfs]
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.585338]  [<ffffffff811c5175>]=
 ? deactivate_locked_super+0x45/0x80
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.586660]  [<ffffffff811e2b1b>]=
 ? cleanup_mnt+0x3b/0x90
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.587986]  [<ffffffff81089ab7>]=
 ? task_work_run+0xb7/0xf0
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.589249]  [<ffffffff81014079>]=
 ? do_notify_resume+0x69/0x90
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.590499]  [<ffffffff8156172b>]=
 ? int_signal+0x12/0x17
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.591765] ---[ end trace 8019cf=
83241ac957 ]---
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.593039] ------------[ cut her=
e ]------------
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.594333] WARNING: CPU: 4 PID: =
134844 at /build/linux-cJtoh5/linux-4.0/fs/btrfs/extent-tree.c:4891 btrfs_f=
ree_block_groups+0x398/0x460 [btrfs]()
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.597086] Modules linked in: bt=
rfs xor raid6_pq udp_diag tcp_diag inet_diag nls_utf8 nls_cp437 vfat fat bi=
nfmt_misc cpufreq_userspace cpufreq_conservative cpufreq_stats cpufreq_powe=
rsave deflate ctr twofish_generic twofish_avx_x86_64 twofish_x86_64_3way tw=
ofish_x86_64 twofish_common camellia_generic camellia_aesni_avx2 camellia_a=
esni_avx_x86_64 camellia_x86_64 serpent_avx2 serpent_avx_x86_64 serpent_sse=
2_x86_64 xts serpent_generic blowfish_generic blowfish_x86_64 blowfish_comm=
on cast5_avx_x86_64 cast5_generic cast_common des_generic cbc cmac xcbc rmd=
160 sha512_ssse3 sha512_generic sha256_ssse3 sha256_generic hmac crypto_nul=
l af_key xfrm_algo ip6table_filter ip6_tables xt_policy ipt_REJECT nf_rejec=
t_ipv4 xt_tcpudp xt_comment nf_conntrack_ipv4 nf_defrag_ipv4 xt_multiport x=
t_conntrack nf_conntrack iptable_filter ip_tables x_tables ipmi_devintf evd=
ev iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp kvm_i=
ntel kvm crct10dif_pclmul crc32_pclmul dcdbas crc32c_intel ghash_clmulni_in=
tel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd pcsp=
kr mgag200 ttm drm_kms_helper drm sg ipmi_si 8250_fintek ipmi_msghandler pr=
ocessor thermal_sys sb_edac edac_core wmi acpi_power_meter ixgbe mdio igb p=
tp pps_core dca i2c_algo_bit i2c_core button xhci_pci xhci_hcd ehci_pci mei=
_me mei ehci_hcd lpc_ich mfd_core usbcore usb_common coretemp fuse autofs4 =
ext4 crc16 mbcache jbd2 dm_mod md_mod sd_mod megaraid_sas scsi_mod shpchp
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.616565] CPU: 4 PID: 134844 Co=
mm: umount Tainted: G        W       4.0.0-trunk-amd64 #1 Debian 4.0-1~exp1
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.618213] Hardware name: Dell I=
nc. PowerEdge R730xd/0599V5, BIOS 1.0.4 08/28/2014
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.619847]  0000000000000000 fff=
fffffa0859bf8 ffffffff8155b12e 0000000000000000
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.621470]  ffffffff8106d2a1 000=
0000000000000 ffff880857551800 ffff88105796c080
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.623068]  ffff88105796c000 fff=
f88105796c090 ffffffffa07c5d58 ffff88105796c000
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.624561] Call Trace:
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.625994]  [<ffffffff8155b12e>]=
 ? dump_stack+0x40/0x50
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.627431]  [<ffffffff8106d2a1>]=
 ? warn_slowpath_common+0x81/0xb0
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.628829]  [<ffffffffa07c5d58>]=
 ? btrfs_free_block_groups+0x398/0x460 [btrfs]
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.630207]  [<ffffffffa07d2cb4>]=
 ? close_ctree+0x154/0x350 [btrfs]
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.631558]  [<ffffffff811df95c>]=
 ? evict_inodes+0xfc/0x110
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.632873]  [<ffffffff811c4aee>]=
 ? generic_shutdown_super+0x6e/0xf0
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.634163]  [<ffffffff811c4dee>]=
 ? kill_anon_super+0xe/0x20
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.635440]  [<ffffffffa07a8927>]=
 ? btrfs_kill_super+0x17/0x100 [btrfs]
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.636662]  [<ffffffff811c5175>]=
 ? deactivate_locked_super+0x45/0x80
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.637836]  [<ffffffff811e2b1b>]=
 ? cleanup_mnt+0x3b/0x90
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.639003]  [<ffffffff81089ab7>]=
 ? task_work_run+0xb7/0xf0
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.640162]  [<ffffffff81014079>]=
 ? do_notify_resume+0x69/0x90
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.641312]  [<ffffffff8156172b>]=
 ? int_signal+0x12/0x17
May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.642454] ---[ end trace 8019cf=
83241ac958 ]---
May 28 22:56:39 lcg-lrz-dc10 kernel: [1750142.765837] megasas:span 0 rowDat=
aSize 1
May 28 22:56:39 lcg-lrz-dc10 kernel: [1750142.767627] megasas:span 0 rowDat=
aSize 1
May 28 22:56:39 lcg-lrz-dc10 kernel: [1750142.769308] megasas:span 0 rowDat=
aSize 1

...


(at some point iozone had also noted that it cannot write anymore)



Well as I've said,.. maybe it's not an issue at all, but at least it's
strange that this happens on brand new hardware only with the
btrfs-raid56 node, especially the gazillions of megasas messages.
The full log (at least that what's left over,... logrotate hat already
taken its tribute) would be available at:
http://christoph.anton.mitterer.name/tmp/public/a8bcf4a6-08c4-11e5-a513-001=
9dbacbbbf/kern.log.xz
for some time (beware, it's some 1,6 G unpacked).


Cheers,
Chris.

--=-Q/Xh2M3QiZExG0EPDcJB
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEZIw
ggW/MIIDp6ADAgECAgMCOakwDQYJKoZIhvcNAQENBQAwVDEUMBIGA1UEChMLQ0FjZXJ0IEluYy4x
HjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0IENsYXNzIDMg
Um9vdDAeFw0xNDA2MTIxNjM2MThaFw0xNjA2MTExNjM2MThaMHwxITAfBgNVBAMTGENocmlzdG9w
aCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9Ac2NpZW50aWEubmV0MTEw
LwYJKoZIhvcNAQkBFiJtYWlsQGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4phP/j9vT9dZT+k3ffHxvRWMOuzBnu5O3Fl4y2+WL7pL
rfLiEhWzGXhHvjSqpt4vCNSdqy43453nnu8+hMb+uEtqSIL1AHU5eLhuDNVN9S4bt9E7nA2WKYBU
LCUi/xCD/GL7ToyJNwhrhzcCZ7pXSc3xVqFoC4f6weU9ExhoEZQNRpTM0BFCOi4fRxvKFNnUYgjK
hqy0Ta5H0Xx86mAp0Q4dxoD7mhI5iTF6TRkUheELxF24JCuAf04M89Cwft6DRH1FpJ3yvgW2B5U5
aFSL4ZnF4N/wyCB7Dkm1rQ7RCAvw5btkf0VdPnU7ccDCx8HEc2nxK/lbCjrznvh3sa1CCwIDAQAB
o4IBcDCCAWwwDAYDVR0TAQH/BAIwADBWBglghkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNl
cnRpZmljYXRlIGZvciBGUkVFIGhlYWQgb3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYD
VR0PAQH/BAQDAgOoMEAGA1UdJQQ5MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYK
KwYBBAGCNwoDAwYJYIZIAYb4QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDov
L29jc3AuY2FjZXJ0Lm9yZzA4BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLmNhY2VydC5vcmcv
Y2xhc3MzLXJldm9rZS5jcmwwRAYDVR0RBD0wO4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0gSJtYWls
QGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMA0GCSqGSIb3DQEBDQUAA4ICAQBefctiLgGl
e5baspuozyA4k7Up7SVhGHbif6pQfoFc/9Thx9GXnYpX+U64PMyWBfWwHZIy52Vg0RVkvPi1t6mi
GyBfoSpC6ooR0bKWtUIogw/ymqKWlTLVR8kbLqRmRk4juMtCXG2K3yMygX/rjkuUSuFj2Bjpkmzg
CtMojbUMYbszePmhQ7DJ62YEdtKpcjN94QAsI5GWlIAbs3KJazAcaNCRJeXCLcUMchyKHJA+NXH5
az/ekBxBMBzJP2An20PP88UI4JW18z31KiG9UVGa2uO4l4aWgVe2GnhNEdCD/o48msJEWKAt5vl2
yMqr7ihmNPocU2+/FW0xPe/vftdOTD9pgXdSGf4prdD+23q2YvpalOCzr2p8yCJZNVBPMxAP4mL0
3OEktXza4wohqAmceXKfGUNwRGBaPvtIGnPrpLhCQ+2YJDg8g1UEsk23bKyZlJWeKJyVqOBsDJmj
aBsN/qKhQFnav+zQdqGhMeaSisF/53mD3gyVYg2JRl18apgGbg32kyLmomqa0JbhnY3Dc3FVtZfe
+P+s2Cyep3pVKvFer2llRoGm8TwraG5Yhyx8Oq/1qETpstjbURJOVBLDCV4AjOEUj0ZnE/tEo/DK
yexgGaViNvjp+IZdFdJhYmsVjw4Q3vG7O0pfsLiYEyQjeDgjNEWDfa5/MufPywIfxzCCBb8wggOn
oAMCAQICAwI5qTANBgkqhkiG9w0BAQ0FADBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UE
CxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290MB4X
DTE0MDYxMjE2MzYxOFoXDTE2MDYxMTE2MzYxOFowfDEhMB8GA1UEAxMYQ2hyaXN0b3BoIEFudG9u
IE1pdHRlcmVyMSQwIgYJKoZIhvcNAQkBFhVjYWxlc3R5b0BzY2llbnRpYS5uZXQxMTAvBgkqhkiG
9w0BCQEWIm1haWxAY2hyaXN0b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDimE/+P29P11lP6Td98fG9FYw67MGe7k7cWXjLb5Yvukut8uISFbMZ
eEe+NKqm3i8I1J2rLjfjneee7z6Exv64S2pIgvUAdTl4uG4M1U31Lhu30TucDZYpgFQsJSL/EIP8
YvtOjIk3CGuHNwJnuldJzfFWoWgLh/rB5T0TGGgRlA1GlMzQEUI6Lh9HG8oU2dRiCMqGrLRNrkfR
fHzqYCnRDh3GgPuaEjmJMXpNGRSF4QvEXbgkK4B/Tgzz0LB+3oNEfUWknfK+BbYHlTloVIvhmcXg
3/DIIHsOSbWtDtEIC/Dlu2R/RV0+dTtxwMLHwcRzafEr+VsKOvOe+HexrUILAgMBAAGjggFwMIIB
bDAMBgNVHRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNh
dGUgZm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEEAYI3
CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8vb2NzcC5j
YWNlcnQub3JnMDgGA1UdHwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuY2FjZXJ0Lm9yZy9jbGFzczMt
cmV2b2tlLmNybDBEBgNVHREEPTA7gRVjYWxlc3R5b0BzY2llbnRpYS5uZXSBIm1haWxAY2hyaXN0
b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwDQYJKoZIhvcNAQENBQADggIBAF59y2IuAaV7ltqym6jP
IDiTtSntJWEYduJ/qlB+gVz/1OHH0Zedilf5Trg8zJYF9bAdkjLnZWDRFWS8+LW3qaIbIF+hKkLq
ihHRspa1QiiDD/KaopaVMtVHyRsupGZGTiO4y0JcbYrfIzKBf+uOS5RK4WPYGOmSbOAK0yiNtQxh
uzN4+aFDsMnrZgR20qlyM33hACwjkZaUgBuzcolrMBxo0JEl5cItxQxyHIockD41cflrP96QHEEw
HMk/YCfbQ8/zxQjglbXzPfUqIb1RUZra47iXhpaBV7YaeE0R0IP+jjyawkRYoC3m+XbIyqvuKGY0
+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
AukCAQEwWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNl
cnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMCOakwDQYJYIZIAWUDBAIDBQCg
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDYwMjAxMjQ1
MVowTwYJKoZIhvcNAQkEMUIEQERDtGEKFO6hPm7pM9F+5/VNp/vUPGBc2TbinRPXLZxyttYbRBj3
ztI81/w6HVKPVKP1OkGQAHkzNmBtcoDn6iUwagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQBoxhnEVQ/Z/2UyEGuL89RJ3YbZS9sN
q9nkLKj70+2UJeMbYeM/erABdikWX56iVmij4LwF8RtTEqmlAzgYCQrEzHcAFtpW99TvN6yX+bX8
LbyopPy/s0/NTtBqQRcsP9W5veuYIvT+sKADgE1zQqhUKpsATQ/y18TOnh7HBASzfcK70wzAh1f+
SHq/bNiVuGiA8IkrJoDI/oD/Ks2IjFKdjl0eO2dt/D0Aco0Pr/NEWSUDHebaMl8l/d5EqeqnF7JO
xDJmAEVz9rjBcSfpmQK+0W3sCJ/acsTT2Wo/bIF8ZjbaV9ufBkFm6bGillGo9P02FlXSKxV5+yA7
zM+HIqWlAAAAAAAA


--=-Q/Xh2M3QiZExG0EPDcJB--


