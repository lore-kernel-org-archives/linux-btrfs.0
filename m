Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wolfsden.cz ([37.205.8.62]:59616 "EHLO wolfsden.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753851AbeAHWch (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 17:32:37 -0500
Received: from localhost (unknown [128.0.188.242])
        by wolfsden.cz (Postfix) with ESMTPSA id 75377301DC
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Jan 2018 22:27:28 +0000 (UTC)
Date: Mon, 8 Jan 2018 23:27:27 +0100
From: Wolf <wolf@wolfsden.cz>
To: linux-btrfs@vger.kernel.org
Subject: btrfs scrub not repair corruption
Message-ID: <20180108222727.oafq5mdoqel7r36y@wolfsden.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="udsneuuxdzxh6w3g"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--udsneuuxdzxh6w3g
Content-Type: multipart/mixed; boundary="tbqjquqi6sis5zy5"
Content-Disposition: inline


--tbqjquqi6sis5zy5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greetings,
I'm running btrfs scrub on my raid each week (is that too often?) and
I'm having a problem that it reports corruption, says it's repaired but
next week reports it again. Here is from dmesg:

$ cat btrfs_error_2017_12_18
[390739.538838] BTRFS warning (device dm-13): checksum error at logical 539=
39989975040 on dev /dev/mapper/data2, sector 1565559688, root 5, inode 1193=
0, offset 2866180096, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 d=
uch=C5=AF.mp4)
[390739.538850] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr=
 0, rd 0, flush 0, corrupt 1, gen 0
[390739.555187] BTRFS error (device dm-13): fixed up error at logical 53939=
989975040 on dev /dev/mapper/data2
[390739.555735] BTRFS warning (device dm-13): checksum error at logical 539=
39989979136 on dev /dev/mapper/data2, sector 1565559696, root 5, inode 1193=
0, offset 2866184192, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 d=
uch=C5=AF.mp4)
[390739.555743] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr=
 0, rd 0, flush 0, corrupt 2, gen 0
[390739.556273] BTRFS error (device dm-13): fixed up error at logical 53939=
989979136 on dev /dev/mapper/data2
[390739.556557] BTRFS warning (device dm-13): checksum error at logical 539=
39989983232 on dev /dev/mapper/data2, sector 1565559704, root 5, inode 1193=
0, offset 2866188288, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 d=
uch=C5=AF.mp4)
[390739.556562] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr=
 0, rd 0, flush 0, corrupt 3, gen 0
[390739.560065] BTRFS error (device dm-13): fixed up error at logical 53939=
989983232 on dev /dev/mapper/data2
[390739.560871] BTRFS warning (device dm-13): checksum error at logical 539=
39989987328 on dev /dev/mapper/data2, sector 1565559712, root 5, inode 1193=
0, offset 2866192384, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 d=
uch=C5=AF.mp4)
[390739.560876] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr=
 0, rd 0, flush 0, corrupt 4, gen 0
[390739.561310] BTRFS error (device dm-13): fixed up error at logical 53939=
989987328 on dev /dev/mapper/data2
[390739.561652] BTRFS warning (device dm-13): checksum error at logical 539=
39989991424 on dev /dev/mapper/data2, sector 1565559720, root 5, inode 1193=
0, offset 2866196480, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 d=
uch=C5=AF.mp4)
[390739.561657] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr=
 0, rd 0, flush 0, corrupt 5, gen 0
[390739.562054] BTRFS error (device dm-13): fixed up error at logical 53939=
989991424 on dev /dev/mapper/data2
[390794.712097] BTRFS warning (device dm-13): checksum error at logical 539=
41063716864 on dev /dev/mapper/data1, sector 1565559688, root 5, inode 1193=
0, offset 3805704192, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 d=
uch=C5=AF.mp4)
[390794.712105] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr=
 0, rd 0, flush 0, corrupt 1, gen 0
[390794.734505] BTRFS error (device dm-13): fixed up error at logical 53941=
063716864 on dev /dev/mapper/data1
[390794.745848] BTRFS warning (device dm-13): checksum error at logical 539=
41063720960 on dev /dev/mapper/data1, sector 1565559696, root 5, inode 1193=
0, offset 3805708288, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 d=
uch=C5=AF.mp4)
[390794.745859] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr=
 0, rd 0, flush 0, corrupt 2, gen 0
[390794.749087] BTRFS error (device dm-13): fixed up error at logical 53941=
063720960 on dev /dev/mapper/data1
[390794.766806] BTRFS warning (device dm-13): checksum error at logical 539=
41063725056 on dev /dev/mapper/data1, sector 1565559704, root 5, inode 1193=
0, offset 3805712384, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 d=
uch=C5=AF.mp4)
[390794.766816] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr=
 0, rd 0, flush 0, corrupt 3, gen 0
[390794.769624] BTRFS error (device dm-13): fixed up error at logical 53941=
063725056 on dev /dev/mapper/data1
[390794.775683] BTRFS warning (device dm-13): checksum error at logical 539=
41063729152 on dev /dev/mapper/data1, sector 1565559712, root 5, inode 1193=
0, offset 3805716480, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 d=
uch=C5=AF.mp4)
[390794.775694] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr=
 0, rd 0, flush 0, corrupt 4, gen 0
[390794.789669] BTRFS error (device dm-13): fixed up error at logical 53941=
063729152 on dev /dev/mapper/data1
[390794.803555] BTRFS warning (device dm-13): checksum error at logical 539=
41063733248 on dev /dev/mapper/data1, sector 1565559720, root 5, inode 1193=
0, offset 3805720576, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 d=
uch=C5=AF.mp4)
[390794.803566] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr=
 0, rd 0, flush 0, corrupt 5, gen 0
[390794.824942] BTRFS error (device dm-13): fixed up error at logical 53941=
063733248 on dev /dev/mapper/data1



$ cat btrfs_error_2018_01_01
[439232.021975] BTRFS warning (device dm-13): checksum error at logical 539=
39989975040 on dev /dev/mapper/data2, sector 1565559688, root 5, inode 1196=
9, offset 17240064, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[439232.021988] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr=
 0, rd 0, flush 0, corrupt 1, gen 0
[439232.052840] BTRFS error (device dm-13): fixed up error at logical 53939=
989975040 on dev /dev/mapper/data2
[439232.114347] BTRFS warning (device dm-13): checksum error at logical 539=
39989979136 on dev /dev/mapper/data2, sector 1565559696, root 5, inode 1196=
9, offset 17244160, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[439232.114358] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr=
 0, rd 0, flush 0, corrupt 2, gen 0
[439232.115494] BTRFS error (device dm-13): fixed up error at logical 53939=
989979136 on dev /dev/mapper/data2
[439232.118377] BTRFS warning (device dm-13): checksum error at logical 539=
39989983232 on dev /dev/mapper/data2, sector 1565559704, root 5, inode 1196=
9, offset 17248256, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[439232.118389] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr=
 0, rd 0, flush 0, corrupt 3, gen 0
[439232.120403] BTRFS error (device dm-13): fixed up error at logical 53939=
989983232 on dev /dev/mapper/data2
[439232.120704] BTRFS warning (device dm-13): checksum error at logical 539=
39989987328 on dev /dev/mapper/data2, sector 1565559712, root 5, inode 1196=
9, offset 17252352, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[439232.120712] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr=
 0, rd 0, flush 0, corrupt 4, gen 0
[439232.121256] BTRFS error (device dm-13): fixed up error at logical 53939=
989987328 on dev /dev/mapper/data2
[439232.121485] BTRFS warning (device dm-13): checksum error at logical 539=
39989991424 on dev /dev/mapper/data2, sector 1565559720, root 5, inode 1196=
9, offset 17256448, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[439232.121491] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr=
 0, rd 0, flush 0, corrupt 5, gen 0
[439232.121926] BTRFS error (device dm-13): fixed up error at logical 53939=
989991424 on dev /dev/mapper/data2
[439310.719870] BTRFS warning (device dm-13): checksum error at logical 539=
41063716864 on dev /dev/mapper/data1, sector 1565559688, root 5, inode 1196=
9, offset 956764160, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 du=
ch=C5=AF.mp4)
[439310.719881] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr=
 0, rd 0, flush 0, corrupt 1, gen 0
[439310.753413] BTRFS error (device dm-13): fixed up error at logical 53941=
063716864 on dev /dev/mapper/data1
[439310.762325] BTRFS warning (device dm-13): checksum error at logical 539=
41063720960 on dev /dev/mapper/data1, sector 1565559696, root 5, inode 1196=
9, offset 956768256, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 du=
ch=C5=AF.mp4)
[439310.762332] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr=
 0, rd 0, flush 0, corrupt 2, gen 0
[439310.767720] BTRFS error (device dm-13): fixed up error at logical 53941=
063720960 on dev /dev/mapper/data1
[439310.772661] BTRFS warning (device dm-13): checksum error at logical 539=
41063725056 on dev /dev/mapper/data1, sector 1565559704, root 5, inode 1196=
9, offset 956772352, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 du=
ch=C5=AF.mp4)
[439310.772671] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr=
 0, rd 0, flush 0, corrupt 3, gen 0
[439310.846667] BTRFS error (device dm-13): fixed up error at logical 53941=
063725056 on dev /dev/mapper/data1
[439310.855831] BTRFS warning (device dm-13): checksum error at logical 539=
41063729152 on dev /dev/mapper/data1, sector 1565559712, root 5, inode 1196=
9, offset 956776448, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 du=
ch=C5=AF.mp4)
[439310.855841] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr=
 0, rd 0, flush 0, corrupt 4, gen 0
[439310.871916] BTRFS error (device dm-13): fixed up error at logical 53941=
063729152 on dev /dev/mapper/data1
[439310.880178] BTRFS warning (device dm-13): checksum error at logical 539=
41063733248 on dev /dev/mapper/data1, sector 1565559720, root 5, inode 1196=
9, offset 956780544, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 du=
ch=C5=AF.mp4)
[439310.880187] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr=
 0, rd 0, flush 0, corrupt 5, gen 0
[439310.906991] BTRFS error (device dm-13): fixed up error at logical 53941=
063733248 on dev /dev/mapper/data1



$ cat btrfs_error_2018_01_03=20
[ 7107.909033] BTRFS warning (device dm-13): checksum error at logical 5393=
9989975040 on dev /dev/mapper/data2, sector 1565559688, root 5, inode 11969=
, offset 17240064, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[ 7107.909040] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 1, gen 0
[ 7107.924923] BTRFS error (device dm-13): fixed up error at logical 539399=
89975040 on dev /dev/mapper/data2
[ 7107.934160] BTRFS warning (device dm-13): checksum error at logical 5393=
9989979136 on dev /dev/mapper/data2, sector 1565559696, root 5, inode 11969=
, offset 17244160, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[ 7107.934165] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 2, gen 0
[ 7107.935673] BTRFS error (device dm-13): fixed up error at logical 539399=
89979136 on dev /dev/mapper/data2
[ 7107.938041] BTRFS warning (device dm-13): checksum error at logical 5393=
9989983232 on dev /dev/mapper/data2, sector 1565559704, root 5, inode 11969=
, offset 17248256, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[ 7107.938045] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 3, gen 0
[ 7107.938445] BTRFS error (device dm-13): fixed up error at logical 539399=
89983232 on dev /dev/mapper/data2
[ 7107.939317] BTRFS warning (device dm-13): checksum error at logical 5393=
9989987328 on dev /dev/mapper/data2, sector 1565559712, root 5, inode 11969=
, offset 17252352, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[ 7107.939321] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 4, gen 0
[ 7107.941047] BTRFS error (device dm-13): fixed up error at logical 539399=
89987328 on dev /dev/mapper/data2
[ 7107.941249] BTRFS warning (device dm-13): checksum error at logical 5393=
9989991424 on dev /dev/mapper/data2, sector 1565559720, root 5, inode 11969=
, offset 17256448, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[ 7107.941253] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 5, gen 0
[ 7107.941607] BTRFS error (device dm-13): fixed up error at logical 539399=
89991424 on dev /dev/mapper/data2
[ 7265.049575] BTRFS warning (device dm-13): checksum error at logical 5394=
1063716864 on dev /dev/mapper/data1, sector 1565559688, root 5, inode 11969=
, offset 956764160, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[ 7265.049579] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 1, gen 0
[ 7265.093679] BTRFS error (device dm-13): fixed up error at logical 539410=
63716864 on dev /dev/mapper/data1
[ 7265.097435] BTRFS warning (device dm-13): checksum error at logical 5394=
1063720960 on dev /dev/mapper/data1, sector 1565559696, root 5, inode 11969=
, offset 956768256, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[ 7265.097439] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 2, gen 0
[ 7265.098007] BTRFS error (device dm-13): fixed up error at logical 539410=
63720960 on dev /dev/mapper/data1
[ 7265.098189] BTRFS warning (device dm-13): checksum error at logical 5394=
1063725056 on dev /dev/mapper/data1, sector 1565559704, root 5, inode 11969=
, offset 956772352, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[ 7265.098192] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 3, gen 0
[ 7265.098541] BTRFS error (device dm-13): fixed up error at logical 539410=
63725056 on dev /dev/mapper/data1
[ 7265.099092] BTRFS warning (device dm-13): checksum error at logical 5394=
1063729152 on dev /dev/mapper/data1, sector 1565559712, root 5, inode 11969=
, offset 956776448, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[ 7265.099097] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 4, gen 0
[ 7265.099500] BTRFS error (device dm-13): fixed up error at logical 539410=
63729152 on dev /dev/mapper/data1
[ 7265.100105] BTRFS warning (device dm-13): checksum error at logical 5394=
1063733248 on dev /dev/mapper/data1, sector 1565559720, root 5, inode 11969=
, offset 956780544, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[ 7265.100108] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 5, gen 0
[ 7265.124480] BTRFS error (device dm-13): fixed up error at logical 539410=
63733248 on dev /dev/mapper/data1



$ cat btrfs_error_2018_01_08
[52488.615929] BTRFS warning (device dm-13): checksum error at logical 5393=
9989975040 on dev /dev/mapper/data2, sector 1565559688, root 5, inode 11969=
, offset 17240064, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[52488.615938] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 1, gen 0
[52488.636891] BTRFS error (device dm-13): fixed up error at logical 539399=
89975040 on dev /dev/mapper/data2
[52488.652788] BTRFS warning (device dm-13): checksum error at logical 5393=
9989979136 on dev /dev/mapper/data2, sector 1565559696, root 5, inode 11969=
, offset 17244160, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[52488.652794] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 2, gen 0
[52488.654453] BTRFS error (device dm-13): fixed up error at logical 539399=
89979136 on dev /dev/mapper/data2
[52488.655520] BTRFS warning (device dm-13): checksum error at logical 5393=
9989983232 on dev /dev/mapper/data2, sector 1565559704, root 5, inode 11969=
, offset 17248256, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[52488.655527] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 3, gen 0
[52488.657344] BTRFS error (device dm-13): fixed up error at logical 539399=
89983232 on dev /dev/mapper/data2
[52488.658041] BTRFS warning (device dm-13): checksum error at logical 5393=
9989987328 on dev /dev/mapper/data2, sector 1565559712, root 5, inode 11969=
, offset 17252352, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[52488.658047] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 4, gen 0
[52488.658514] BTRFS error (device dm-13): fixed up error at logical 539399=
89987328 on dev /dev/mapper/data2
[52488.659223] BTRFS warning (device dm-13): checksum error at logical 5393=
9989991424 on dev /dev/mapper/data2, sector 1565559720, root 5, inode 11969=
, offset 17256448, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[52488.659227] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 5, gen 0
[52488.659631] BTRFS error (device dm-13): fixed up error at logical 539399=
89991424 on dev /dev/mapper/data2
[52569.683784] BTRFS warning (device dm-13): checksum error at logical 5394=
1063716864 on dev /dev/mapper/data1, sector 1565559688, root 5, inode 11969=
, offset 956764160, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[52569.683788] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 1, gen 0
[52569.703754] BTRFS error (device dm-13): fixed up error at logical 539410=
63716864 on dev /dev/mapper/data1
[52569.707782] BTRFS warning (device dm-13): checksum error at logical 5394=
1063720960 on dev /dev/mapper/data1, sector 1565559696, root 5, inode 11969=
, offset 956768256, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[52569.707786] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 2, gen 0
[52569.708117] BTRFS error (device dm-13): fixed up error at logical 539410=
63720960 on dev /dev/mapper/data1
[52569.708871] BTRFS warning (device dm-13): checksum error at logical 5394=
1063725056 on dev /dev/mapper/data1, sector 1565559704, root 5, inode 11969=
, offset 956772352, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[52569.708876] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 3, gen 0
[52569.709121] BTRFS error (device dm-13): fixed up error at logical 539410=
63725056 on dev /dev/mapper/data1
[52569.709321] BTRFS warning (device dm-13): checksum error at logical 5394=
1063729152 on dev /dev/mapper/data1, sector 1565559712, root 5, inode 11969=
, offset 956776448, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[52569.709324] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 4, gen 0
[52569.709525] BTRFS error (device dm-13): fixed up error at logical 539410=
63729152 on dev /dev/mapper/data1
[52569.709697] BTRFS warning (device dm-13): checksum error at logical 5394=
1063733248 on dev /dev/mapper/data1, sector 1565559720, root 5, inode 11969=
, offset 956780544, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[52569.709699] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 5, gen 0
[52569.710079] BTRFS error (device dm-13): fixed up error at logical 539410=
63733248 on dev /dev/mapper/data1



It points to the same place every time, so I at first suspected HDD
failure, however smarctl says disks are ok (/dev/sdj =3D=3D data1, /dev/sdi
=3D=3D data2):

$ smartctl -l selftest /dev/sdj
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.14.12-1-hardened] (local buil=
d)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)=
  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     13167       =
  -
# 2  Extended offline    Completed without error       00%       782       =
  -

$ smartctl -H /dev/sdj
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.14.12-1-hardened] (local buil=
d)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED



$  smartctl -l selftest /dev/sdi
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.14.12-1-hardened] (local buil=
d)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)=
  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     13167       =
  -
# 2  Extended offline    Completed without error       00%       782       =
  -

$ smartctl -H /dev/sdi
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.14.12-1-hardened] (local buil=
d)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED



Here is details about my array:

$ btrfs fi usage /raid
Overall:
    Device size:		  29.11TiB
    Device allocated:		  14.06TiB
    Device unallocated:		  15.04TiB
    Device missing:		     0.00B
    Used:			  14.06TiB
    Free (estimated):		   7.52TiB	(min: 7.52TiB)
    Data ratio:			      2.00
    Metadata ratio:		      2.00
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,RAID1: Size:7.02TiB, Used:7.02TiB
   /dev/mapper/data1	 848.00GiB
   /dev/mapper/data2	 846.00GiB
   /dev/mapper/data5	 847.00GiB
   /dev/mapper/data6	 848.00GiB
   /dev/mapper/data7	   5.37TiB
   /dev/mapper/data8	   5.37TiB

Metadata,RAID1: Size:10.00GiB, Used:8.51GiB
   /dev/mapper/data2	   2.00GiB
   /dev/mapper/data5	   1.00GiB
   /dev/mapper/data7	   8.00GiB
   /dev/mapper/data8	   9.00GiB

System,RAID1: Size:64.00MiB, Used:1.00MiB
   /dev/mapper/data2	  32.00MiB
   /dev/mapper/data5	  32.00MiB
   /dev/mapper/data7	  32.00MiB
   /dev/mapper/data8	  32.00MiB

Unallocated:
   /dev/mapper/data1	   1.90TiB
   /dev/mapper/data2	   1.90TiB
   /dev/mapper/data3	   1.82TiB
   /dev/mapper/data4	   1.82TiB
   /dev/mapper/data5	   1.90TiB
   /dev/mapper/data6	   1.90TiB
   /dev/mapper/data7	   1.90TiB
   /dev/mapper/data8	   1.90TiB


`btrfs device stats /raid` is also all zeros (only time when it's not is
[/dev/mapper/data(1,2)].corruption_errs  5 after/during the scurbs,
everything else is always 0).

My system

$ uname -a
Linux dennas 4.14.12-1-hardened #1 SMP PREEMPT Sat Jan 6 13:16:10 CET 2018 =
x86_64 GNU/Linux

NOTE: I switched to -hardened yesterday, so only last scrub was run
under it.

Complete dmesg from last time is attached to this mail.

Can someone please point me in correct direction to what could be wrong?
:)

Thank you all for help

W.

--=20
There are only two hard things in Computer Science:
cache invalidation, naming things and off-by-one errors.

--tbqjquqi6sis5zy5
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg.log"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 4.14.12-1-hardened (builduser@anthraxx) (gcc v=
ersion 7.2.1 20171128 (GCC)) #1 SMP PREEMPT Sat Jan 6 13:16:10 CET 2018
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-linux-hardened root=
=3DUUID=3Ddb7e86f5-649d-44ce-9514-53c7ee0fbe09 rw cryptdevice=3DUUID=3Deb40=
11d2-38cd-467d-b515-7acf3ef68f01:storage1:allow-discards cryptkey=3Drootfs:=
/boot/crypto_keyfile.bin cryptdevice2=3DUUID=3Ddd0821ae-8fc4-41d2-aab8-f313=
e2f6d0e8:storage2:allow-discards cryptkey2=3Drootfs:/boot/crypto_keyfile2.b=
in root=3D/dev/mapper/storage1-root intel_idle.max_cstate=3D1 i915.semaphor=
es=3D1 amdgpu.powerplay=3D1
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point=
 registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registe=
rs'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is 960 b=
ytes, using 'compacted' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x00000000000997ff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000099800-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007fd13fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fd14000-0x000000007fd14fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x000000007fd15000-0x000000007fd15fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000007fd16000-0x0000000088a97fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000088a98000-0x000000008a1c7fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000008a1c8000-0x000000008a208fff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x000000008a209000-0x000000008a9cffff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x000000008a9d0000-0x000000008b2a1fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000008b2a2000-0x000000008b2fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000008b300000-0x000000008fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000086effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] random: fast init done
[    0.000000] SMBIOS 3.0.0 present.
[    0.000000] DMI: ASUSTeK COMPUTER INC. P10S WS/P10S WS, BIOS 3105 08/11/=
2017
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x86f000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00C0000000 mask 7FC0000000 uncachable
[    0.000000]   1 base 00A0000000 mask 7FE0000000 uncachable
[    0.000000]   2 base 0090000000 mask 7FF0000000 uncachable
[    0.000000]   3 base 008C000000 mask 7FFC000000 uncachable
[    0.000000]   4 base 008B800000 mask 7FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT=
 =20
[    0.000000] e820: last_pfn =3D 0x8b300 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fcca0-0x000fccaf] mapped at =
[ffffffffff200ca0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff8b6340093000] 93000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x7b964a000, 0x7b964afff] PGTABLE
[    0.000000] BRK [0x7b964b000, 0x7b964bfff] PGTABLE
[    0.000000] BRK [0x7b964c000, 0x7b964cfff] PGTABLE
[    0.000000] BRK [0x7b964d000, 0x7b964dfff] PGTABLE
[    0.000000] BRK [0x7b964e000, 0x7b964efff] PGTABLE
[    0.000000] BRK [0x7b964f000, 0x7b964ffff] PGTABLE
[    0.000000] BRK [0x7b9650000, 0x7b9650fff] PGTABLE
[    0.000000] BRK [0x7b9651000, 0x7b9651fff] PGTABLE
[    0.000000] BRK [0x7b9652000, 0x7b9652fff] PGTABLE
[    0.000000] BRK [0x7b9653000, 0x7b9653fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x2f98f000-0x33cbefff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F05B0 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x000000008A1D50A8 0000C4 (v01 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x000000008A1FD7F0 000114 (v06 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x000000008A1D5200 0285EA (v02 ALASKA A M I    01=
072009 INTL 20160422)
[    0.000000] ACPI: FACS 0x000000008A9CFC40 000040
[    0.000000] ACPI: APIC 0x000000008A1FD908 000084 (v03 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x000000008A1FD990 000044 (v01 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: DMAR 0x000000008A2083D0 0000B0 (v01 INTEL  KBL      00=
000001 INTL 00000001)
[    0.000000] ACPI: MCFG 0x000000008A1FDA30 00003C (v01 ALASKA A M I    01=
072009 MSFT 00000097)
[    0.000000] ACPI: SSDT 0x000000008A1FDA70 000390 (v01 SataRe SataTabl 00=
001000 INTL 20160422)
[    0.000000] ACPI: FIDT 0x000000008A1FDE00 00009C (v01 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x000000008A1FDEA0 003154 (v02 SaSsdt SaSsdt   00=
003000 INTL 20160422)
[    0.000000] ACPI: SSDT 0x000000008A200FF8 00253E (v02 PegSsd PegSsdt  00=
001000 INTL 20160422)
[    0.000000] ACPI: HPET 0x000000008A203538 000038 (v01 INTEL  SKL      00=
000001 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x000000008A203570 000024 (v02 INTEL  OEM_RTD3 00=
001000 INTL 20160422)
[    0.000000] ACPI: SSDT 0x000000008A203598 000B13 (v02 INTEL  xh_rvp08 00=
000000 INTL 20160422)
[    0.000000] ACPI: UEFI 0x000000008A2040B0 000042 (v01 INTEL  EDK2     00=
000002      01000013)
[    0.000000] ACPI: SSDT 0x000000008A2040F8 000EDE (v02 CpuRef CpuSsdt  00=
003000 INTL 20160422)
[    0.000000] ACPI: LPIT 0x000000008A204FD8 000094 (v01 INTEL  SKL      00=
000000 MSFT 0000005F)
[    0.000000] ACPI: WSMT 0x000000008A205070 000028 (v01 INTEL  SKL      00=
000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x000000008A205098 00029F (v02 INTEL  sensrhub 00=
000000 INTL 20160422)
[    0.000000] ACPI: SSDT 0x000000008A205338 003002 (v02 INTEL  PtidDevc 00=
001000 INTL 20160422)
[    0.000000] ACPI: DBGP 0x000000008A208340 000034 (v01 INTEL           00=
000002 MSFT 0000005F)
[    0.000000] ACPI: DBG2 0x000000008A208378 000054 (v00 INTEL           00=
000002 MSFT 0000005F)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000086effffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x86effc000-0x86effffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000086effffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000098fff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000007fd13fff]
[    0.000000]   node   0: [mem 0x000000007fd16000-0x0000000088a97fff]
[    0.000000]   node   0: [mem 0x000000008b2a2000-0x000000008b2fffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000086effffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000086efff=
fff]
[    0.000000] On node 0 totalpages: 8354444
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3992 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8684 pages used for memmap
[    0.000000]   DMA32 zone: 555764 pages, LIFO batch:31
[    0.000000]   Normal zone: 121792 pages used for memmap
[    0.000000]   Normal zone: 7794688 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics memory at 0x000000008c000000-0x0000=
00008fffffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] e820: [mem 0x90000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 6370452778343963 ns
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] percpu: Embedded 42 pages/cpu @ffff8b6baec00000 s134232 r819=
2 d29608 u524288
[    0.000000] pcpu-alloc: s134232 r8192 d29608 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 82238=
83
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: audit=3D0 BOOT_IMAGE=3D/boot/vmlinuz-li=
nux-hardened root=3DUUID=3Ddb7e86f5-649d-44ce-9514-53c7ee0fbe09 rw cryptdev=
ice=3DUUID=3Deb4011d2-38cd-467d-b515-7acf3ef68f01:storage1:allow-discards c=
ryptkey=3Drootfs:/boot/crypto_keyfile.bin cryptdevice2=3DUUID=3Ddd0821ae-8f=
c4-41d2-aab8-f313e2f6d0e8:storage2:allow-discards cryptkey2=3Drootfs:/boot/=
crypto_keyfile2.bin root=3D/dev/mapper/storage1-root intel_idle.max_cstate=
=3D1 i915.semaphores=3D1 amdgpu.powerplay=3D1
[    0.000000] audit: disabled (until reboot)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 32734976K/33417776K available (10252K kernel code, 1=
179K rwdata, 2840K rodata, 1356K init, 1016K bss, 682800K reserved, 0K cma-=
reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Kernel/User page tables isolation: enabled
[    0.000000] ftrace: allocating 29748 entries in 117 pages
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D128 to nr_cpu_ids=3D4.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[    0.000000] NR_IRQS: 8448, nr_irqs: 1024, preallocated irqs: 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 79635855245 ns
[    0.000000] hpet clockevent registered
[    0.003333] tsc: Detected 3200.000 MHz processor
[    0.003333] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6386.00 BogoMIPS (lpj=3D10640000)
[    0.003333] pid_max: default: 32768 minimum: 301
[    0.003333] ACPI: Core revision 20170728
[    0.033142] ACPI: 9 ACPI AML tables successfully acquired and loaded
[    0.033166] Security Framework initialized
[    0.033166] Yama: becoming mindful.
[    0.036731] Dentry cache hash table entries: 4194304 (order: 13, 3355443=
2 bytes)
[    0.038487] Inode-cache hash table entries: 2097152 (order: 12, 16777216=
 bytes)
[    0.038547] Mount-cache hash table entries: 65536 (order: 7, 524288 byte=
s)
[    0.038611] Mountpoint-cache hash table entries: 65536 (order: 7, 524288=
 bytes)
[    0.038757] CPU: Physical Processor ID: 0
[    0.038757] CPU: Processor Core ID: 0
[    0.038761] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.038761] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.038765] mce: CPU supports 8 MCE banks
[    0.038771] CPU0: Thermal monitoring enabled (TM1)
[    0.038782] process: using mwait in idle threads
[    0.038783] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.038784] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.039492] Freeing SMP alternatives memory: 20K
[    0.040062] smpboot: Max logical packages: 2
[    0.040065] DMAR: Host address width 39
[    0.040066] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.040070] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660=
462 ecap 7e3ff0505e
[    0.040071] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.040073] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c406604=
62 ecap f050da
[    0.040074] DMAR: RMRR base: 0x00000089158000 end: 0x00000089177fff
[    0.040075] DMAR: RMRR base: 0x0000008b800000 end: 0x0000008fffffff
[    0.040076] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.040076] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.040077] DMAR-IR: Queued invalidation will be enabled to support x2ap=
ic and Intr-remapping.
[    0.041598] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.041599] x2apic enabled
[    0.041608] Switched APIC routing to cluster x2apic.
[    0.046000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.079033] TSC deadline timer enabled
[    0.079038] smpboot: CPU0: Intel(R) Core(TM) i3-6100T CPU @ 3.20GHz (fam=
ily: 0x6, model: 0x5e, stepping: 0x3)
[    0.090018] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR,=
 full-width counters, Intel PMU driver.
[    0.090100] ... version:                4
[    0.090100] ... bit width:              48
[    0.090101] ... generic registers:      4
[    0.090101] ... value mask:             0000ffffffffffff
[    0.090102] ... max period:             00007fffffffffff
[    0.090102] ... fixed-purpose events:   3
[    0.090102] ... event mask:             000000070000000f
[    0.096672] Hierarchical SRCU implementation.
[    0.110176] NMI watchdog: Enabled. Permanently consumes one hw-PMU count=
er.
[    0.116671] smp: Bringing up secondary CPUs ...
[    0.143376] x86: Booting SMP configuration:
[    0.143379] .... node  #0, CPUs:      #1 #2 #3
[    0.197236] smp: Brought up 1 node, 4 CPUs
[    0.197236] smpboot: Total of 4 processors activated (25546.00 BogoMIPS)
[    0.200396] devtmpfs: initialized
[    0.200396] x86/mm: Memory block size: 128MB
[    0.201645] PM: Registering ACPI NVS region [mem 0x7fd14000-0x7fd14fff] =
(4096 bytes)
[    0.201645] PM: Registering ACPI NVS region [mem 0x8a209000-0x8a9cffff] =
(8155136 bytes)
[    0.201645] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 6370867519511994 ns
[    0.201645] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.201645] pinctrl core: initialized pinctrl subsystem
[    0.201645] RTC time: 14:15:26, date: 01/07/18
[    0.201645] NET: Registered protocol family 16
[    0.201645] cpuidle: using governor ladder
[    0.201645] cpuidle: using governor menu
[    0.201645] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.201645] ACPI: bus type PCI registered
[    0.201645] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.201645] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    0.201645] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.201645] PCI: Using configuration type 1 for base access
[    0.203360] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.203360] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.203373] ACPI: Added _OSI(Module Device)
[    0.203373] ACPI: Added _OSI(Processor Device)
[    0.203374] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.203374] ACPI: Added _OSI(Processor Aggregator Device)
[    0.204196] ACPI: Executed 35 blocks of module-level executable AML code
[    0.213240] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.216416] ACPI: Dynamic OEM Table Load:
[    0.216421] ACPI: SSDT 0xFFFF8B6B8A619010 0006D5 (v02 PmRef  Cpu0Ist  00=
003000 INTL 20160422)
[    0.216536] ACPI: Executed 1 blocks of module-level executable AML code
[    0.216598] ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
[    0.217623] ACPI: Dynamic OEM Table Load:
[    0.217627] ACPI: SSDT 0xFFFF8B6B8A610C18 0003FF (v02 PmRef  Cpu0Cst  00=
003001 INTL 20160422)
[    0.217728] ACPI: Executed 1 blocks of module-level executable AML code
[    0.217846] ACPI: Dynamic OEM Table Load:
[    0.217849] ACPI: SSDT 0xFFFF8B6B8A6BB0C0 000130 (v02 PmRef  Cpu0Hwp  00=
003000 INTL 20160422)
[    0.217934] ACPI: Executed 1 blocks of module-level executable AML code
[    0.217987] ACPI: Dynamic OEM Table Load:
[    0.217990] ACPI: SSDT 0xFFFF8B6B8A6B9248 0001A4 (v02 PmRef  HwpLvt   00=
003000 INTL 20160422)
[    0.218070] ACPI: Executed 1 blocks of module-level executable AML code
[    0.218337] ACPI: Dynamic OEM Table Load:
[    0.218341] ACPI: SSDT 0xFFFF8B6B8A61B030 00065C (v02 PmRef  ApIst    00=
003000 INTL 20160422)
[    0.218603] ACPI: Executed 1 blocks of module-level executable AML code
[    0.218712] ACPI: Dynamic OEM Table Load:
[    0.218715] ACPI: SSDT 0xFFFF8B6B8A6B9C70 000197 (v02 PmRef  ApHwp    00=
003000 INTL 20160422)
[    0.218814] ACPI: Executed 1 blocks of module-level executable AML code
[    0.218928] ACPI: Dynamic OEM Table Load:
[    0.218931] ACPI: SSDT 0xFFFF8B6B8A6B8820 00018A (v02 PmRef  ApCst    00=
003000 INTL 20160422)
[    0.219029] ACPI: Executed 1 blocks of module-level executable AML code
[    0.221003] ACPI: Interpreter enabled
[    0.221030] ACPI: (supports S0 S3 S5)
[    0.221031] ACPI: Using IOAPIC for interrupt routing
[    0.221065] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.221852] ACPI: Enabled 9 GPEs in block 00 to 7F
[    0.224124] ACPI: Power Resource [PG00] (on)
[    0.224422] ACPI: Power Resource [PG01] (on)
[    0.224710] ACPI: Power Resource [PG02] (on)
[    0.227034] ACPI: Power Resource [WRST] (on)
[    0.227341] ACPI: Power Resource [WRST] (on)
[    0.227647] ACPI: Power Resource [WRST] (on)
[    0.227969] ACPI: Power Resource [WRST] (on)
[    0.228289] ACPI: Power Resource [WRST] (on)
[    0.228672] ACPI: Power Resource [WRST] (on)
[    0.228977] ACPI: Power Resource [WRST] (on)
[    0.229275] ACPI: Power Resource [WRST] (on)
[    0.229573] ACPI: Power Resource [WRST] (on)
[    0.229949] ACPI: Power Resource [WRST] (on)
[    0.230249] ACPI: Power Resource [WRST] (on)
[    0.230555] ACPI: Power Resource [WRST] (on)
[    0.230852] ACPI: Power Resource [WRST] (on)
[    0.231158] ACPI: Power Resource [WRST] (on)
[    0.231459] ACPI: Power Resource [WRST] (on)
[    0.231763] ACPI: Power Resource [WRST] (on)
[    0.232067] ACPI: Power Resource [WRST] (on)
[    0.233261] ACPI: Power Resource [WRST] (on)
[    0.233567] ACPI: Power Resource [WRST] (on)
[    0.233864] ACPI: Power Resource [WRST] (on)
[    0.246670] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.246674] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cloc=
kPM Segments MSI]
[    0.246701] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.247453] PCI host bridge to bus 0000:00
[    0.247455] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.247456] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.247457] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f window]
[    0.247457] pci_bus 0000:00: root bus resource [mem 0x90000000-0xdffffff=
f window]
[    0.247458] pci_bus 0000:00: root bus resource [mem 0xfd000000-0xfe7ffff=
f window]
[    0.247459] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.247464] pci 0000:00:00.0: [8086:190f] type 00 class 0x060000
[    0.247730] pci 0000:00:02.0: [8086:1912] type 00 class 0x030000
[    0.247737] pci 0000:00:02.0: reg 0x10: [mem 0xde000000-0xdeffffff 64bit]
[    0.247741] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit=
 pref]
[    0.247743] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.247902] pci 0000:00:14.0: [8086:a12f] type 00 class 0x0c0330
[    0.247920] pci 0000:00:14.0: reg 0x10: [mem 0xdf510000-0xdf51ffff 64bit]
[    0.247974] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.248149] pci 0000:00:16.0: [8086:a13a] type 00 class 0x078000
[    0.248171] pci 0000:00:16.0: reg 0x10: [mem 0xdf52d000-0xdf52dfff 64bit]
[    0.248233] pci 0000:00:16.0: PME# supported from D3hot
[    0.248354] pci 0000:00:17.0: [8086:a102] type 00 class 0x010601
[    0.248368] pci 0000:00:17.0: reg 0x10: [mem 0xdf528000-0xdf529fff]
[    0.248373] pci 0000:00:17.0: reg 0x14: [mem 0xdf52c000-0xdf52c0ff]
[    0.248379] pci 0000:00:17.0: reg 0x18: [io  0xf090-0xf097]
[    0.248385] pci 0000:00:17.0: reg 0x1c: [io  0xf080-0xf083]
[    0.248390] pci 0000:00:17.0: reg 0x20: [io  0xf060-0xf07f]
[    0.248396] pci 0000:00:17.0: reg 0x24: [mem 0xdf52b000-0xdf52b7ff]
[    0.248428] pci 0000:00:17.0: PME# supported from D3hot
[    0.248535] pci 0000:00:1b.0: [8086:a167] type 01 class 0x060400
[    0.248590] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.248731] pci 0000:00:1c.0: [8086:a110] type 01 class 0x060400
[    0.248782] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.248912] pci 0000:00:1c.4: [8086:a114] type 01 class 0x060400
[    0.248963] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.249090] pci 0000:00:1d.0: [8086:a118] type 01 class 0x060400
[    0.249141] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.249260] pci 0000:00:1d.2: [8086:a11a] type 01 class 0x060400
[    0.249310] pci 0000:00:1d.2: PME# supported from D0 D3hot D3cold
[    0.249426] pci 0000:00:1d.3: [8086:a11b] type 01 class 0x060400
[    0.249476] pci 0000:00:1d.3: PME# supported from D0 D3hot D3cold
[    0.249609] pci 0000:00:1f.0: [8086:a149] type 00 class 0x060100
[    0.249801] pci 0000:00:1f.2: [8086:a121] type 00 class 0x058000
[    0.249814] pci 0000:00:1f.2: reg 0x10: [mem 0xdf524000-0xdf527fff]
[    0.249958] pci 0000:00:1f.3: [8086:a170] type 00 class 0x040300
[    0.249981] pci 0000:00:1f.3: reg 0x10: [mem 0xdf520000-0xdf523fff 64bit]
[    0.250009] pci 0000:00:1f.3: reg 0x20: [mem 0xdf500000-0xdf50ffff 64bit]
[    0.250052] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.250211] pci 0000:00:1f.4: [8086:a123] type 00 class 0x0c0500
[    0.250270] pci 0000:00:1f.4: reg 0x10: [mem 0xdf52a000-0xdf52a0ff 64bit]
[    0.250339] pci 0000:00:1f.4: reg 0x20: [io  0xf040-0xf05f]
[    0.250547] pci 0000:00:1b.0: PCI bridge to [bus 01]
[    0.250595] pci 0000:02:00.0: [1b4b:9130] type 00 class 0x010601
[    0.250611] pci 0000:02:00.0: reg 0x10: [io  0xe050-0xe057]
[    0.250618] pci 0000:02:00.0: reg 0x14: [io  0xe040-0xe043]
[    0.250625] pci 0000:02:00.0: reg 0x18: [io  0xe030-0xe037]
[    0.250633] pci 0000:02:00.0: reg 0x1c: [io  0xe020-0xe023]
[    0.250640] pci 0000:02:00.0: reg 0x20: [io  0xe000-0xe01f]
[    0.250647] pci 0000:02:00.0: reg 0x24: [mem 0xdf410000-0xdf4107ff]
[    0.250654] pci 0000:02:00.0: reg 0x30: [mem 0xdf400000-0xdf40ffff pref]
[    0.250665] pci 0000:02:00.0: Enabling fixed DMA alias to 00.1
[    0.250700] pci 0000:02:00.0: PME# supported from D3hot
[    0.250774] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.250776] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    0.250778] pci 0000:00:1c.0:   bridge window [mem 0xdf400000-0xdf4fffff]
[    0.250821] pci 0000:03:00.0: [1b4b:9130] type 00 class 0x010601
[    0.250837] pci 0000:03:00.0: reg 0x10: [io  0xd050-0xd057]
[    0.250845] pci 0000:03:00.0: reg 0x14: [io  0xd040-0xd043]
[    0.250852] pci 0000:03:00.0: reg 0x18: [io  0xd030-0xd037]
[    0.250859] pci 0000:03:00.0: reg 0x1c: [io  0xd020-0xd023]
[    0.250866] pci 0000:03:00.0: reg 0x20: [io  0xd000-0xd01f]
[    0.250873] pci 0000:03:00.0: reg 0x24: [mem 0xdf310000-0xdf3107ff]
[    0.250880] pci 0000:03:00.0: reg 0x30: [mem 0xdf300000-0xdf30ffff pref]
[    0.250891] pci 0000:03:00.0: Enabling fixed DMA alias to 00.1
[    0.250925] pci 0000:03:00.0: PME# supported from D3hot
[    0.250997] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    0.250999] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.251000] pci 0000:00:1c.4:   bridge window [mem 0xdf300000-0xdf3fffff]
[    0.251048] pci 0000:04:00.0: [1b21:1242] type 00 class 0x0c0330
[    0.251076] pci 0000:04:00.0: reg 0x10: [mem 0xdf200000-0xdf207fff 64bit]
[    0.251123] pci 0000:04:00.0: enabling Extended Tags
[    0.251184] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    0.251277] pci 0000:00:1d.0: PCI bridge to [bus 04]
[    0.251280] pci 0000:00:1d.0:   bridge window [mem 0xdf200000-0xdf2fffff]
[    0.251337] pci 0000:05:00.0: [8086:1533] type 00 class 0x020000
[    0.251368] pci 0000:05:00.0: reg 0x10: [mem 0xdf100000-0xdf17ffff]
[    0.251391] pci 0000:05:00.0: reg 0x18: [io  0xc000-0xc01f]
[    0.251403] pci 0000:05:00.0: reg 0x1c: [mem 0xdf180000-0xdf183fff]
[    0.251520] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.251621] pci 0000:00:1d.2: PCI bridge to [bus 05]
[    0.251623] pci 0000:00:1d.2:   bridge window [io  0xc000-0xcfff]
[    0.251625] pci 0000:00:1d.2:   bridge window [mem 0xdf100000-0xdf1fffff]
[    0.251682] pci 0000:06:00.0: [8086:1533] type 00 class 0x020000
[    0.251713] pci 0000:06:00.0: reg 0x10: [mem 0xdf000000-0xdf07ffff]
[    0.251736] pci 0000:06:00.0: reg 0x18: [io  0xb000-0xb01f]
[    0.251748] pci 0000:06:00.0: reg 0x1c: [mem 0xdf080000-0xdf083fff]
[    0.251865] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.251967] pci 0000:00:1d.3: PCI bridge to [bus 06]
[    0.251968] pci 0000:00:1d.3:   bridge window [io  0xb000-0xbfff]
[    0.251970] pci 0000:00:1d.3:   bridge window [mem 0xdf000000-0xdf0fffff]
[    0.253720] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.253758] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15=
) *0
[    0.253796] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 1=
5)
[    0.253833] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 *1=
5)
[    0.253870] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15=
) *0
[    0.253906] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15=
) *0
[    0.253943] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15=
) *0
[    0.253980] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15=
) *0
[    0.254302] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.254302] pci 0000:00:02.0: vgaarb: VGA device added: decodes=3Dio+mem=
,owns=3Dio+mem,locks=3Dnone
[    0.254302] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.254302] vgaarb: loaded
[    0.254302] EDAC MC: Ver: 3.0.0
[    0.254302] PCI: Using ACPI for IRQ routing
[    0.281612] PCI: pci_cache_line_size set to 64 bytes
[    0.281667] e820: reserve RAM buffer [mem 0x00099800-0x0009ffff]
[    0.281668] e820: reserve RAM buffer [mem 0x7fd14000-0x7fffffff]
[    0.281669] e820: reserve RAM buffer [mem 0x88a98000-0x8bffffff]
[    0.281670] e820: reserve RAM buffer [mem 0x8b300000-0x8bffffff]
[    0.281670] e820: reserve RAM buffer [mem 0x86f000000-0x86fffffff]
[    0.281731] NetLabel: Initializing
[    0.281732] NetLabel:  domain hash size =3D 128
[    0.281732] NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
[    0.281744] NetLabel:  unlabeled traffic allowed by default
[    0.281753] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.281753] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[    0.283347] clocksource: Switched to clocksource hpet
[    0.289330] VFS: Disk quotas dquot_6.6.0
[    0.289339] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[    0.289374] pnp: PnP ACPI init
[    0.289575] system 00:00: [io  0x0290-0x029f] has been reserved
[    0.289582] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.289873] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.289874] system 00:01: [io  0xffff] has been reserved
[    0.289875] system 00:01: [io  0xffff] has been reserved
[    0.289875] system 00:01: [io  0xffff] has been reserved
[    0.289876] system 00:01: [io  0x1800-0x18fe] has been reserved
[    0.289877] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.289879] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.289950] system 00:02: [io  0x0800-0x087f] has been reserved
[    0.289952] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.289966] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.289991] system 00:04: [io  0x1854-0x1857] has been reserved
[    0.289993] system 00:04: Plug and Play ACPI device, IDs INT3f0d PNP0c02=
 (active)
[    0.290205] system 00:05: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.290205] system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.290206] system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.290207] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[    0.290208] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.290209] system 00:05: [mem 0xfed90000-0xfed93fff] could not be reser=
ved
[    0.290210] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.290210] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
[    0.290211] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    0.290212] system 00:05: [mem 0xdffc0000-0xdffdffff] has been reserved
[    0.290214] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.290243] system 00:06: [mem 0xfd000000-0xfdabffff] has been reserved
[    0.290244] system 00:06: [mem 0xfdad0000-0xfdadffff] has been reserved
[    0.290245] system 00:06: [mem 0xfdac0000-0xfdacffff] has been reserved
[    0.290245] system 00:06: [mem 0xfdae0000-0xfdaeffff] has been reserved
[    0.290246] system 00:06: [mem 0xfdaf0000-0xfdafffff] has been reserved
[    0.290247] system 00:06: [mem 0xfdb00000-0xfdffffff] has been reserved
[    0.290248] system 00:06: [mem 0xfe000000-0xfe01ffff] could not be reser=
ved
[    0.290249] system 00:06: [mem 0xfe036000-0xfe03bfff] has been reserved
[    0.290249] system 00:06: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    0.290250] system 00:06: [mem 0xfe410000-0xfe7fffff] has been reserved
[    0.290252] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.290494] system 00:07: [io  0xff00-0xfffe] has been reserved
[    0.290497] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.291403] system 00:08: [mem 0xfdaf0000-0xfdafffff] has been reserved
[    0.291404] system 00:08: [mem 0xfdae0000-0xfdaeffff] has been reserved
[    0.291405] system 00:08: [mem 0xfdac0000-0xfdacffff] has been reserved
[    0.291407] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.292095] pnp: PnP ACPI: found 9 devices
[    0.299255] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, m=
ax_idle_ns: 2085701024 ns
[    0.299285] pci 0000:00:1b.0: PCI bridge to [bus 01]
[    0.299294] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.299295] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    0.299298] pci 0000:00:1c.0:   bridge window [mem 0xdf400000-0xdf4fffff]
[    0.299302] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    0.299303] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.299305] pci 0000:00:1c.4:   bridge window [mem 0xdf300000-0xdf3fffff]
[    0.299309] pci 0000:00:1d.0: PCI bridge to [bus 04]
[    0.299312] pci 0000:00:1d.0:   bridge window [mem 0xdf200000-0xdf2fffff]
[    0.299316] pci 0000:00:1d.2: PCI bridge to [bus 05]
[    0.299317] pci 0000:00:1d.2:   bridge window [io  0xc000-0xcfff]
[    0.299319] pci 0000:00:1d.2:   bridge window [mem 0xdf100000-0xdf1fffff]
[    0.299324] pci 0000:00:1d.3: PCI bridge to [bus 06]
[    0.299325] pci 0000:00:1d.3:   bridge window [io  0xb000-0xbfff]
[    0.299327] pci 0000:00:1d.3:   bridge window [mem 0xdf000000-0xdf0fffff]
[    0.299332] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.299333] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.299333] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[    0.299334] pci_bus 0000:00: resource 7 [mem 0x90000000-0xdfffffff windo=
w]
[    0.299335] pci_bus 0000:00: resource 8 [mem 0xfd000000-0xfe7fffff windo=
w]
[    0.299336] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.299336] pci_bus 0000:02: resource 1 [mem 0xdf400000-0xdf4fffff]
[    0.299337] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.299338] pci_bus 0000:03: resource 1 [mem 0xdf300000-0xdf3fffff]
[    0.299338] pci_bus 0000:04: resource 1 [mem 0xdf200000-0xdf2fffff]
[    0.299339] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.299339] pci_bus 0000:05: resource 1 [mem 0xdf100000-0xdf1fffff]
[    0.299340] pci_bus 0000:06: resource 0 [io  0xb000-0xbfff]
[    0.299341] pci_bus 0000:06: resource 1 [mem 0xdf000000-0xdf0fffff]
[    0.299452] NET: Registered protocol family 2
[    0.299768] TCP established hash table entries: 262144 (order: 9, 209715=
2 bytes)
[    0.300100] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.300162] TCP: Hash tables configured (established 262144 bind 65536)
[    0.300245] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.300340] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    0.300406] NET: Registered protocol family 1
[    0.300414] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x0=
00c0000-0x000dffff]
[    0.300774] PCI: CLS 0 bytes, default 64
[    0.300807] Unpacking initramfs...
[    0.325743] Freeing initrd memory: 68800K
[    0.325767] DMAR: [Firmware Bug]: RMRR entry for device 04:00.0 is broke=
n - applying workaround
[    0.325772] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.325774] software IO TLB [mem 0x84a98000-0x88a98000] (64MB) mapped at=
 [ffff8b63c4a98000-ffff8b63c8a97fff]
[    0.325937] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2e0=
2c4a121d, max_idle_ns: 440795236083 ns
[    0.326041] Scanning for low memory corruption every 60 seconds
[    0.326422] Initialise system trusted keyrings
[    0.326429] Key type blacklist registered
[    0.326505] workingset: timestamp_bits=3D41 max_order=3D23 bucket_order=
=3D0
[    0.327521] zbud: loaded
[    0.330274] Key type asymmetric registered
[    0.330297] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 247)
[    0.330342] io scheduler noop registered
[    0.330343] io scheduler deadline registered
[    0.330364] io scheduler cfq registered (default)
[    0.330365] io scheduler mq-deadline registered
[    0.330365] io scheduler kyber registered
[    0.330385] io scheduler bfq registered
[    0.331078] vesafb: mode is 1920x1080x32, linelength=3D7680, pages=3D0
[    0.331079] vesafb: scrolling: redraw
[    0.331079] vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    0.331087] vesafb: framebuffer at 0xc0000000, mapped to 0xffffade283800=
000, using 8128k, total 8128k
[    0.466562] Console: switching to colour frame buffer device 240x67
[    0.601483] fb0: VESA VGA frame buffer device
[    0.601493] intel_idle: MWAIT substates: 0x142120
[    0.601494] intel_idle: v0.4.1 model 0x5E
[    0.601495] intel_idle: max_cstate 1 reached
[    0.601630] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.602139] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.602876] rtc_cmos 00:03: RTC can wake from S4
[    0.603259] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.603363] rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes nvram=
, hpet irqs
[    0.603373] intel_pstate: Intel P-state driver initializing
[    0.603819] intel_pstate: HWP enabled
[    0.603926] ledtrig-cpu: registered to indicate activity on CPUs
[    0.603956] vlv2_plat_clk vlv2_plat_clk: vlv2_plat_clk initialized
[    0.604107] NET: Registered protocol family 10
[    0.606816] Segment Routing with IPv6
[    0.606828] NET: Registered protocol family 17
[    0.607082] RAS: Correctable Errors collector initialized.
[    0.607115] microcode: sig=3D0x506e3, pf=3D0x2, revision=3D0xba
[    0.607188] microcode: Microcode Update Driver: v2.2.
[    0.607195] sched_clock: Marking stable (607186400, 0)->(607732609, -546=
209)
[    0.607476] registered taskstats version 1
[    0.607483] Loading compiled-in X.509 certificates
[    0.607516] zswap: loaded using pool lzo/zbud
[    0.609676] Key type big_key registered
[    0.610688]   Magic number: 2:697:282
[    0.610700] tty tty19: hash matches
[    0.610737] memory memory148: hash matches
[    0.610871] rtc_cmos 00:03: setting system clock to 2018-01-07 14:15:26 =
UTC (1515334526)
[    0.612195] Freeing unused kernel memory: 1356K
[    0.612196] Write protecting the kernel read-only data: 16384k
[    0.612554] Freeing unused kernel memory: 2024K
[    0.614232] Freeing unused kernel memory: 1256K
[    0.614327] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    0.614327] x86/mm: Checking user space page tables
[    0.614337] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    0.627670] Linux agpgart interface v0.103
[    0.641137] amdgpu: unknown parameter 'powerplay' ignored
[    0.641506] [drm] amdgpu kernel modesetting enabled.
[    0.695028] i8042: PNP: No PS/2 controller found.
[    0.706559] SCSI subsystem initialized
[    0.737184] i8042: PNP: No PS/2 controller found.
[    0.738009] ACPI: bus type USB registered
[    0.738028] usbcore: registered new interface driver usbfs
[    0.738035] usbcore: registered new interface driver hub
[    0.738055] usbcore: registered new device driver usb
[    0.739014] libata version 3.00 loaded.
[    0.740262] ahci 0000:00:17.0: version 3.0
[    0.740428] AVX2 version of gcm_enc/dec engaged.
[    0.740429] AES CTR mode by8 optimization enabled
[    0.750614] ahci 0000:00:17.0: AHCI 0001.0301 32 slots 8 ports 6 Gbps 0x=
ff impl SATA mode
[    0.750616] ahci 0000:00:17.0: flags: 64bit ncq sntf led clo only pio sl=
um part ems deso sadm sds apst=20
[    0.822158] scsi host0: ahci
[    0.822520] scsi host1: ahci
[    0.822827] scsi host2: ahci
[    0.823055] scsi host3: ahci
[    0.823274] scsi host4: ahci
[    0.823558] scsi host5: ahci
[    0.823911] scsi host6: ahci
[    0.824170] scsi host7: ahci
[    0.824269] ata1: SATA max UDMA/133 abar m2048@0xdf52b000 port 0xdf52b10=
0 irq 122
[    0.824272] ata2: SATA max UDMA/133 abar m2048@0xdf52b000 port 0xdf52b18=
0 irq 122
[    0.824274] ata3: SATA max UDMA/133 abar m2048@0xdf52b000 port 0xdf52b20=
0 irq 122
[    0.824277] ata4: SATA max UDMA/133 abar m2048@0xdf52b000 port 0xdf52b28=
0 irq 122
[    0.824279] ata5: SATA max UDMA/133 abar m2048@0xdf52b000 port 0xdf52b30=
0 irq 122
[    0.824282] ata6: SATA max UDMA/133 abar m2048@0xdf52b000 port 0xdf52b38=
0 irq 122
[    0.824284] ata7: SATA max UDMA/133 abar m2048@0xdf52b000 port 0xdf52b40=
0 irq 122
[    0.824287] ata8: SATA max UDMA/133 abar m2048@0xdf52b000 port 0xdf52b48=
0 irq 122
[    0.824738] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.824754] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 1
[    0.825994] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x1=
00 quirks 0x00109810
[    0.826002] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.826579] hub 1-0:1.0: USB hub found
[    0.826630] hub 1-0:1.0: 16 ports detected
[    0.831444] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.831456] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 2
[    0.831944] hub 2-0:1.0: USB hub found
[    0.831972] hub 2-0:1.0: 10 ports detected
[    0.836050] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    0.836062] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus =
number 3
[    0.836900] ahci 0000:02:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0x=
ff impl SATA mode
[    0.836904] ahci 0000:02:00.0: flags: 64bit ncq pio=20
[    0.838838] scsi host8: ahci
[    0.839090] scsi host9: ahci
[    0.839327] scsi host10: ahci
[    0.839561] scsi host11: ahci
[    0.839798] scsi host12: ahci
[    0.840047] scsi host13: ahci
[    0.841270] scsi host14: ahci
[    0.841497] scsi host15: ahci
[    0.841599] ata9: SATA max UDMA/133 abar m2048@0xdf410000 port 0xdf41010=
0 irq 124
[    0.841602] ata10: SATA max UDMA/133 abar m2048@0xdf410000 port 0xdf4101=
80 irq 124
[    0.841605] ata11: SATA max UDMA/133 abar m2048@0xdf410000 port 0xdf4102=
00 irq 124
[    0.841609] ata12: SATA max UDMA/133 abar m2048@0xdf410000 port 0xdf4102=
80 irq 124
[    0.841612] ata13: SATA max UDMA/133 abar m2048@0xdf410000 port 0xdf4103=
00 irq 124
[    0.841615] ata14: SATA max UDMA/133 abar m2048@0xdf410000 port 0xdf4103=
80 irq 124
[    0.841617] ata15: SATA max UDMA/133 abar m2048@0xdf410000 port 0xdf4104=
00 irq 124
[    0.841620] ata16: SATA max UDMA/133 abar m2048@0xdf410000 port 0xdf4104=
80 irq 124
[    0.852194] ahci 0000:03:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0x=
ff impl SATA mode
[    0.852199] ahci 0000:03:00.0: flags: 64bit ncq pio=20
[    0.854216] scsi host16: ahci
[    0.854454] scsi host17: ahci
[    0.854679] scsi host18: ahci
[    0.854897] scsi host19: ahci
[    0.855158] scsi host20: ahci
[    0.855391] scsi host21: ahci
[    0.855560] scsi host22: ahci
[    0.856439] scsi host23: ahci
[    0.856503] ata17: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3101=
00 irq 125
[    0.856506] ata18: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3101=
80 irq 125
[    0.856509] ata19: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3102=
00 irq 125
[    0.856513] ata20: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3102=
80 irq 125
[    0.856516] ata21: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3103=
00 irq 125
[    0.856518] ata22: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3103=
80 irq 125
[    0.856520] ata23: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3104=
00 irq 125
[    0.856522] ata24: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3104=
80 irq 125
[    0.894855] xhci_hcd 0000:04:00.0: hcc params 0x0200eec1 hci version 0x1=
10 quirks 0x00000010
[    0.895102] hub 3-0:1.0: USB hub found
[    0.895109] hub 3-0:1.0: 2 ports detected
[    0.895295] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    0.895299] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus =
number 4
[    0.895301] xhci_hcd 0000:04:00.0: Host supports USB 3.1 Enhanced SuperS=
peed
[    0.895333] usb usb4: We don't know the algorithms for LPM for this host=
, disabling LPM.
[    0.895473] hub 4-0:1.0: USB hub found
[    0.895482] hub 4-0:1.0: 2 ports detected
[    1.136845] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.136873] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.136896] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.136916] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.136935] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.136956] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.136977] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.136997] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.137408] ata1.00: ATA-9: WDC WD30EFRX-68EUZN0, 82.00A82, max UDMA/133
[    1.137412] ata1.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.137441] ata7.00: ATA-9: WDC WD20EZRZ-00Z5HB0, 80.00A80, max UDMA/133
[    1.137444] ata7.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.137523] ata8.00: ATA-9: WDC WD20EZRZ-00Z5HB0, 80.00A80, max UDMA/133
[    1.137525] ata8.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.137589] ata4.00: ATA-9: WDC WD30EFRX-68EUZN0, 82.00A82, max UDMA/133
[    1.137592] ata4.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.137967] ata7.00: configured for UDMA/133
[    1.138010] ata1.00: configured for UDMA/133
[    1.138051] ata8.00: configured for UDMA/133
[    1.138183] ata4.00: configured for UDMA/133
[    1.138420] scsi 0:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A=
82 PQ: 0 ANSI: 5
[    1.140179] ata3.00: ATA-9: WDC WD80EFZX-68UW8N0, 83.H0A83, max UDMA/133
[    1.140183] ata3.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
[    1.140210] ata2.00: ATA-9: WDC WD80EFZX-68UW8N0, 83.H0A83, max UDMA/133
[    1.140212] ata2.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
[    1.141041] ata6.00: ATA-9: KINGSTON SM2280S3G2120G, SAFM01.W, max UDMA/=
133
[    1.141044] ata6.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 31/32)=
, AA
[    1.141086] ata5.00: ATA-9: KINGSTON SM2280S3G2120G, SAFM01.W, max UDMA/=
133
[    1.141089] ata5.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 31/32)=
, AA
[    1.141220] ata6.00: configured for UDMA/133
[    1.141264] ata5.00: configured for UDMA/133
[    1.141585] sd 0:0:0:0: [sda] 5860533168 512-byte logical blocks: (3.00 =
TB/2.73 TiB)
[    1.141590] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.141626] sd 0:0:0:0: [sda] Write Protect is off
[    1.141631] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.141699] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.145720] ata3.00: configured for UDMA/133
[    1.145744] ata2.00: configured for UDMA/133
[    1.146062] scsi 1:0:0:0: Direct-Access     ATA      WDC WD80EFZX-68U 0A=
83 PQ: 0 ANSI: 5
[    1.146556] sd 1:0:0:0: [sdb] 15628053168 512-byte logical blocks: (8.00=
 TB/7.28 TiB)
[    1.146561] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.146623] sd 1:0:0:0: [sdb] Write Protect is off
[    1.146628] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.146692] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.147039] scsi 2:0:0:0: Direct-Access     ATA      WDC WD80EFZX-68U 0A=
83 PQ: 0 ANSI: 5
[    1.147922] scsi 3:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A=
82 PQ: 0 ANSI: 5
[    1.148036] sd 2:0:0:0: [sdc] 15628053168 512-byte logical blocks: (8.00=
 TB/7.28 TiB)
[    1.148042] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    1.148074] sd 2:0:0:0: [sdc] Write Protect is off
[    1.148079] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.148138] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.149168] scsi 4:0:0:0: Direct-Access     ATA      KINGSTON SM2280S 01=
=2EW PQ: 0 ANSI: 5
[    1.149262] sd 3:0:0:0: [sdd] 5860533168 512-byte logical blocks: (3.00 =
TB/2.73 TiB)
[    1.149267] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    1.149297] sd 3:0:0:0: [sdd] Write Protect is off
[    1.149302] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.149361] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.150085] scsi 5:0:0:0: Direct-Access     ATA      KINGSTON SM2280S 01=
=2EW PQ: 0 ANSI: 5
[    1.150339] sd 4:0:0:0: [sde] 234441648 512-byte logical blocks: (120 GB=
/112 GiB)
[    1.150373] sd 4:0:0:0: [sde] Write Protect is off
[    1.150378] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    1.150439] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.150944] scsi 6:0:0:0: Direct-Access     ATA      WDC WD20EZRZ-00Z 0A=
80 PQ: 0 ANSI: 5
[    1.151063] sd 5:0:0:0: [sdf] 234441648 512-byte logical blocks: (120 GB=
/112 GiB)
[    1.151096] sd 5:0:0:0: [sdf] Write Protect is off
[    1.151100] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    1.151189] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.151613] sd 6:0:0:0: [sdg] 3907029168 512-byte logical blocks: (2.00 =
TB/1.82 TiB)
[    1.151619] sd 6:0:0:0: [sdg] 4096-byte physical blocks
[    1.151657] sd 6:0:0:0: [sdg] Write Protect is off
[    1.151661] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    1.151723] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.152050] scsi 7:0:0:0: Direct-Access     ATA      WDC WD20EZRZ-00Z 0A=
80 PQ: 0 ANSI: 5
[    1.152519]  sdf: sdf1
[    1.152551] sd 7:0:0:0: [sdh] 3907029168 512-byte logical blocks: (2.00 =
TB/1.82 TiB)
[    1.152556] sd 7:0:0:0: [sdh] 4096-byte physical blocks
[    1.152586] sd 7:0:0:0: [sdh] Write Protect is off
[    1.152590] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    1.152646] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.153259]  sde: sde1
[    1.153466] sd 5:0:0:0: [sdf] Attached SCSI disk
[    1.153987] ata9: SATA link down (SStatus 0 SControl 310)
[    1.154049] sd 4:0:0:0: [sde] Attached SCSI disk
[    1.156775] ata12: SATA link down (SStatus 0 SControl 310)
[    1.156812] ata14: SATA link down (SStatus 0 SControl 310)
[    1.156849] ata16: SATA link up 1.5 Gbps (SStatus 113 SControl 330)
[    1.156884] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
[    1.156968] ata16.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.157073] ata15: SATA link down (SStatus 0 SControl 310)
[    1.157198] ata16.00: configured for UDMA/66
[    1.157541] ata10.00: ATA-9: WDC WD30EFRX-68EUZN0, 82.00A82, max UDMA/133
[    1.157546] ata10.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/3=
2), AA
[    1.158160] ata13: SATA link down (SStatus 0 SControl 310)
[    1.158210] ata11: SATA link down (SStatus 0 SControl 310)
[    1.158278] ata10.00: configured for UDMA/133
[    1.158704] scsi 9:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A=
82 PQ: 0 ANSI: 5
[    1.159415] sd 9:0:0:0: [sdi] 5860533168 512-byte logical blocks: (3.00 =
TB/2.73 TiB)
[    1.159421] sd 9:0:0:0: [sdi] 4096-byte physical blocks
[    1.159454] sd 9:0:0:0: [sdi] Write Protect is off
[    1.159459] sd 9:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[    1.159514] sd 9:0:0:0: [sdi] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.159744] scsi 15:0:0:0: Processor         Marvell  91xx Config      1=
=2E01 PQ: 0 ANSI: 5
[    1.160069] usb 1-3: new full-speed USB device number 2 using xhci_hcd
[    1.170171] ata20: SATA link down (SStatus 0 SControl 310)
[    1.170211] ata22: SATA link down (SStatus 0 SControl 310)
[    1.170271] ata18: SATA link down (SStatus 0 SControl 310)
[    1.170308] ata21: SATA link down (SStatus 0 SControl 310)
[    1.170350] ata17: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
[    1.170380] ata24: SATA link up 1.5 Gbps (SStatus 113 SControl 330)
[    1.170410] ata23: SATA link down (SStatus 0 SControl 310)
[    1.170451] ata19: SATA link down (SStatus 0 SControl 310)
[    1.170488] ata24.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.170657] ata24.00: configured for UDMA/66
[    1.170998] ata17.00: ATA-9: WDC WD30EFRX-68EUZN0, 82.00A82, max UDMA/133
[    1.171003] ata17.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/3=
2), AA
[    1.171696] ata17.00: configured for UDMA/133
[    1.172039] scsi 16:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0=
A82 PQ: 0 ANSI: 5
[    1.172791] sd 16:0:0:0: [sdj] 5860533168 512-byte logical blocks: (3.00=
 TB/2.73 TiB)
[    1.172796] sd 16:0:0:0: [sdj] 4096-byte physical blocks
[    1.172834] sd 16:0:0:0: [sdj] Write Protect is off
[    1.172839] sd 16:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[    1.172899] sd 16:0:0:0: [sdj] Write cache: enabled, read cache: enabled=
, doesn't support DPO or FUA
[    1.173126] scsi 23:0:0:0: Processor         Marvell  91xx Config      1=
=2E01 PQ: 0 ANSI: 5
[    1.191280]  sdd: sdd1
[    1.191817] sd 3:0:0:0: [sdd] Attached SCSI disk
[    1.193509]  sda: sda1
[    1.194078] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.204633]  sdb: sdb1
[    1.205158] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.208640]  sdc: sdc1
[    1.209129] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.218448]  sdi: sdi1
[    1.218931] sd 9:0:0:0: [sdi] Attached SCSI disk
[    1.235412]  sdj: sdj1
[    1.235906] sd 16:0:0:0: [sdj] Attached SCSI disk
[    1.308323] hidraw: raw HID events driver (C) Jiri Kosina
[    1.316895] usbcore: registered new interface driver usbhid
[    1.316897] usbhid: USB HID core driver
[    1.320185] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: US=
B HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-3/input2
[    1.333513] clocksource: Switched to clocksource tsc
[    1.426706] usb 1-4: new low-speed USB device number 3 using xhci_hcd
[    1.631669] hid-generic 0003:051D:0002.0005: hiddev1,hidraw1: USB HID v1=
=2E10 Device [American Power Conversion Back-UPS XS 700U   FW:924.Z3 .I USB=
 FW:Z3 ] on usb-0000:00:14.0-4/input0
[    1.677574]  sdh: sdh1
[    1.678183] sd 7:0:0:0: [sdh] Attached SCSI disk
[    1.689597]  sdg: sdg1
[    1.689793] sd 6:0:0:0: [sdg] Attached SCSI disk
[    1.719436] random: crng init done
[    2.338744] input: Logitech K400 Plus as /devices/pci0000:00/0000:00:14.=
0/usb1/1-3/1-3:1.2/0003:046D:C52B.0003/0003:046D:404D.0004/input/input0
[    2.338842] logitech-hidpp-device 0003:046D:404D.0004: input,hidraw2: US=
B HID v1.11 Keyboard [Logitech K400 Plus] on usb-0000:00:14.0-3:1
[    2.555497] device-mapper: uevent: version 1.0.3
[    2.555551] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised:=
 dm-devel@redhat.com
[    7.354649] NET: Registered protocol family 38
[   10.563336] raid6: sse2x1   gen() 11751 MB/s
[   10.620003] raid6: sse2x1   xor()  8607 MB/s
[   10.676667] raid6: sse2x2   gen() 14459 MB/s
[   10.733335] raid6: sse2x2   xor()  9817 MB/s
[   10.790003] raid6: sse2x4   gen() 16852 MB/s
[   10.846667] raid6: sse2x4   xor() 10285 MB/s
[   10.903334] raid6: avx2x1   gen() 23479 MB/s
[   10.959999] raid6: avx2x1   xor() 16341 MB/s
[   11.016668] raid6: avx2x2   gen() 28792 MB/s
[   11.073333] raid6: avx2x2   xor() 18078 MB/s
[   11.130000] raid6: avx2x4   gen() 32737 MB/s
[   11.186666] raid6: avx2x4   xor() 19884 MB/s
[   11.186667] raid6: using algorithm avx2x4 gen() 32737 MB/s
[   11.186667] raid6: .... xor() 19884 MB/s, rmw enabled
[   11.186667] raid6: using avx2x2 recovery algorithm
[   11.187795] xor: automatically using best checksumming function   avx   =
   =20
[   11.195862] Btrfs loaded, crc32c=3Dcrc32c-intel
[   11.200292] BTRFS: device fsid db7e86f5-649d-44ce-9514-53c7ee0fbe09 devi=
d 1 transid 310193 /dev/dm-2
[   19.348876] BTRFS: device fsid db7e86f5-649d-44ce-9514-53c7ee0fbe09 devi=
d 2 transid 310193 /dev/dm-5
[   19.410664] BTRFS info (device dm-5): disk space caching is enabled
[   19.410665] BTRFS info (device dm-5): has skinny extents
[   19.416985] BTRFS info (device dm-5): enabling ssd optimizations
[   19.579125] ip_tables: (C) 2000-2006 Netfilter Core Team
[   19.587722] systemd[1]: systemd 236 running in system mode. (+PAM -AUDIT=
 -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNU=
TLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN default-hierar=
chy=3Dhybrid)
[   19.587884] systemd[1]: Detected architecture x86-64.
[   19.589329] systemd[1]: Set hostname to <dennas>.
[   19.661469] systemd[1]: Created slice User and Session Slice.
[   19.662203] systemd[1]: Set up automount Arbitrary Executable File Forma=
ts File System Automount Point.
[   19.663115] systemd[1]: Reached target Remote File Systems.
[   19.663682] systemd[1]: Started Forward Password Requests to Wall Direct=
ory Watch.
[   19.664436] systemd[1]: Started Dispatch Password Requests to Console Di=
rectory Watch.
[   19.665195] systemd[1]: Reached target Paths.
[   19.665821] systemd[1]: Created slice System Slice.
[   19.754219] BTRFS info (device dm-5): disk space caching is enabled
[   19.773753] systemd-journald[417]: Received request to flush runtime jou=
rnal from PID 1
[   19.952105] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0E:00/input/input1
[   19.952115] ACPI: Sleep Button [SLPB]
[   19.952290] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input2
[   19.952297] ACPI: Power Button [PWRB]
[   19.952595] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input3
[   19.953534] ACPI: Power Button [PWRF]
[   19.996977] media: Linux media interface: v0.10
[   20.009498] i8042: PNP: No PS/2 controller found.
[   20.009883] Linux video capture interface: v2.00
[   20.028091] ov5693: module is from the staging directory, the quality is=
 unknown, you have been warned.
[   20.038120] ov5693: module is from the staging directory, the quality is=
 unknown, you have been warned.
[   20.060402] i8042: PNP: No PS/2 controller found.
[   20.117671] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[   20.117701] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[   20.118181] mousedev: PS/2 mouse device common for all mice
[   20.120047] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[   20.128356] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   20.133511] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   20.137647] dca service started, version 1.12.1
[   20.139441] pps_core: LinuxPPS API ver. 1 registered
[   20.139442] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[   20.142310] PTP clock support registered
[   20.163262] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360=
 ms ovfl timer
[   20.163263] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[   20.163263] RAPL PMU: hw unit of domain package 2^-14 Joules
[   20.163263] RAPL PMU: hw unit of domain dram 2^-14 Joules
[   20.163264] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[   20.163264] RAPL PMU: hw unit of domain psys 2^-14 Joules
[   20.165543] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.=
0-k
[   20.165543] igb: Copyright (c) 2007-2014 Intel Corporation.
[   20.206815] Bluetooth: Core ver 2.22
[   20.206830] NET: Registered protocol family 31
[   20.206830] Bluetooth: HCI device and connection manager initialized
[   20.206833] Bluetooth: HCI socket layer initialized
[   20.206835] Bluetooth: L2CAP socket layer initialized
[   20.206840] Bluetooth: SCO socket layer initialized
[   20.238785] Bluetooth: HCI UART driver ver 2.3
[   20.238787] Bluetooth: HCI UART protocol H4 registered
[   20.238787] Bluetooth: HCI UART protocol BCSP registered
[   20.238806] Bluetooth: HCI UART protocol LL registered
[   20.238807] Bluetooth: HCI UART protocol ATH3K registered
[   20.238807] Bluetooth: HCI UART protocol Three-wire (H5) registered
[   20.238827] Bluetooth: HCI UART protocol Intel registered
[   20.238859] Bluetooth: HCI UART protocol Broadcom registered
[   20.238859] Bluetooth: HCI UART protocol QCA registered
[   20.238860] Bluetooth: HCI UART protocol AG6XX registered
[   20.238860] Bluetooth: HCI UART protocol Marvell registered
[   20.243534] asus_wmi: ASUS WMI generic driver loaded
[   20.244282] asus_wmi: Initialization: 0x0
[   20.244303] asus_wmi: BIOS WMI version: 0.9
[   20.244333] asus_wmi: SFUN value: 0x0
[   20.244619] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/inp=
ut/input5
[   20.246446] asus_wmi: Number of fans: 1
[   20.277221] iTCO_vendor_support: vendor-support=3D0
[   20.279274] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   20.279433] iTCO_wdt: Found a Intel PCH TCO device (Version=3D4, TCOBASE=
=3D0x0400)
[   20.279778] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   20.296185] Setting dangerous option semaphores - tainting kernel
[   20.299255] [drm] Memory usable by graphics device =3D 4096M
[   20.299257] checking generic (c0000000 7f0000) vs hw (c0000000 10000000)
[   20.299257] fb: switching to inteldrmfb from VESA VGA
[   20.299319] Console: switching to colour dummy device 80x25
[   20.299387] [drm] Replacing VGA console driver
[   20.305371] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   20.305373] [drm] Driver supports precise vblank timestamp query.
[   20.306992] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[   20.308779] [drm] Finished loading DMC firmware i915/skl_dmc_ver1_26.bin=
 (v1.26)
[   20.312070] [drm] Initialized i915 1.6.0 20170818 for 0000:00:02.0 on mi=
nor 0
[   20.314553] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: n=
o)
[   20.314688] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08=
:00/LNXVIDEO:00/input/input6
[   20.331348] Adding 8388604k swap on /dev/mapper/storage2-swap.  Priority=
:-2 extents:1 across:8388604k SSFS
[   20.332340] Adding 8388604k swap on /dev/mapper/storage1-swap.  Priority=
:-3 extents:1 across:8388604k SSFS
[   20.356454] intel_rapl: Found RAPL domain package
[   20.356456] intel_rapl: Found RAPL domain core
[   20.356457] intel_rapl: Found RAPL domain uncore
[   20.356458] intel_rapl: Found RAPL domain dram
[   20.390542] pps pps0: new PPS source ptp0
[   20.390544] igb 0000:05:00.0: added PHC on eth0
[   20.390545] igb 0000:05:00.0: Intel(R) Gigabit Ethernet Network Connecti=
on
[   20.390546] igb 0000:05:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 2c:fd:a1:34:=
10:8b
[   20.390586] igb 0000:05:00.0: eth0: PBA No: 000300-000
[   20.390588] igb 0000:05:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 t=
x queue(s)
[   20.396820] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops i915_aud=
io_component_bind_ops [i915])
[   20.397324] fbcon: inteldrmfb (fb0) is primary device
[   20.434533] snd_hda_codec_realtek hdaudioC0D0: ALC1150: SKU not ready 0x=
00000000
[   20.435080] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC1150: l=
ine_outs=3D4 (0x14/0x15/0x16/0x17/0x0) type:line
[   20.435081] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=3D0 (0x0/=
0x0/0x0/0x0/0x0)
[   20.435083] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=3D1 (0x1b/0x0/=
0x0/0x0/0x0)
[   20.435084] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=3D0x0
[   20.435085] snd_hda_codec_realtek hdaudioC0D0:    dig-out=3D0x11/0x1e
[   20.435085] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   20.435087] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=3D0x19
[   20.435088] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=3D0x18
[   20.435089] snd_hda_codec_realtek hdaudioC0D0:      Line=3D0x1a
[   20.443626] Console: switching to colour frame buffer device 240x67
[   20.465801] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   20.483869] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1f.=
3/sound/card0/input7
[   20.484597] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:0=
0:1f.3/sound/card0/input8
[   20.484640] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00=
:1f.3/sound/card0/input9
[   20.484684] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1f.=
3/sound/card0/input10
[   20.484723] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0=
000:00:1f.3/sound/card0/input11
[   20.484764] input: HDA Intel PCH Line Out Surround as /devices/pci0000:0=
0/0000:00:1f.3/sound/card0/input12
[   20.484810] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/00=
00:00:1f.3/sound/card0/input13
[   20.484856] input: HDA Intel PCH Line Out Side as /devices/pci0000:00/00=
00:00:1f.3/sound/card0/input14
[   20.484899] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input15
[   20.484943] input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input16
[   20.484989] input: HDA Intel PCH HDMI/DP,pcm=3D7 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input17
[   20.485030] input: HDA Intel PCH HDMI/DP,pcm=3D8 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input18
[   20.485075] input: HDA Intel PCH HDMI/DP,pcm=3D9 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input19
[   20.485118] input: HDA Intel PCH HDMI/DP,pcm=3D10 as /devices/pci0000:00=
/0000:00:1f.3/sound/card0/input20
[   20.607217] pps pps1: new PPS source ptp1
[   20.607219] igb 0000:06:00.0: added PHC on eth1
[   20.607220] igb 0000:06:00.0: Intel(R) Gigabit Ethernet Network Connecti=
on
[   20.607222] igb 0000:06:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 2c:fd:a1:34:=
10:8c
[   20.607262] igb 0000:06:00.0: eth1: PBA No: 000300-000
[   20.607264] igb 0000:06:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 t=
x queue(s)
[   20.611163] igb 0000:05:00.0 enp5s0: renamed from eth0
[   20.631424] igb 0000:06:00.0 enp6s0: renamed from eth1
[   21.357012] [drm] RC6 on
[   28.310910] BTRFS: device label RAID devid 3 transid 851654 /dev/dm-6
[   28.397324] BTRFS: device label RAID devid 2 transid 851654 /dev/dm-7
[   28.572915] BTRFS: device label RAID devid 4 transid 851654 /dev/dm-9
[   29.071061] BTRFS: device label RAID devid 1 transid 851654 /dev/dm-8
[   34.292182] BTRFS: device label RAID devid 5 transid 851654 /dev/dm-10
[   34.336128] BTRFS: device label RAID devid 6 transid 851654 /dev/dm-11
[   37.693646] BTRFS: device label RAID devid 8 transid 851654 /dev/dm-12
[   43.938506] BTRFS: device label RAID devid 7 transid 851654 /dev/dm-13
[   43.982858] BTRFS info (device dm-13): enabling auto defrag
[   43.982860] BTRFS info (device dm-13): disk space caching is enabled
[   43.982861] BTRFS info (device dm-13): has skinny extents
[   75.066321] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   75.344779] bridge: filtering via arp/ip/ip6tables is no longer availabl=
e by default. Update your scripts to load br_netfilter if you need this.
[   75.394767] device enp6s0 entered promiscuous mode
[   75.394787] IPv6: ADDRCONF(NETDEV_UP): enp6s0: link is not ready
[   75.398683] lxc_bridge: port 1(enp6s0) entered blocking state
[   75.398691] lxc_bridge: port 1(enp6s0) entered disabled state
[   75.399568] IPv6: ADDRCONF(NETDEV_UP): lxc_bridge: link is not ready
[   75.541620] lxc_bridge: port 2(vethKCA4P8) entered blocking state
[   75.541629] lxc_bridge: port 2(vethKCA4P8) entered disabled state
[   75.541657] device vethKCA4P8 entered promiscuous mode
[   75.541686] lxc_bridge: port 3(vethUESLM0) entered blocking state
[   75.541695] lxc_bridge: port 3(vethUESLM0) entered disabled state
[   75.541729] device vethUESLM0 entered promiscuous mode
[   75.541771] IPv6: ADDRCONF(NETDEV_UP): vethKCA4P8: link is not ready
[   75.541774] lxc_bridge: port 2(vethKCA4P8) entered blocking state
[   75.541775] lxc_bridge: port 2(vethKCA4P8) entered forwarding state
[   75.544225] IPv6: ADDRCONF(NETDEV_UP): vethUESLM0: link is not ready
[   75.544229] lxc_bridge: port 3(vethUESLM0) entered blocking state
[   75.544230] lxc_bridge: port 3(vethUESLM0) entered forwarding state
[   75.544259] lxc_bridge: port 2(vethKCA4P8) entered disabled state
[   75.544285] lxc_bridge: port 3(vethUESLM0) entered disabled state
[   75.586929] eth0: renamed from vethBOLGA3
[   75.600086] eth0: renamed from vethEODREB
[   75.623933] IPv6: ADDRCONF(NETDEV_CHANGE): vethKCA4P8: link becomes ready
[   75.623948] lxc_bridge: port 2(vethKCA4P8) entered blocking state
[   75.623949] lxc_bridge: port 2(vethKCA4P8) entered forwarding state
[   75.623964] IPv6: ADDRCONF(NETDEV_CHANGE): vethUESLM0: link becomes ready
[   75.623973] lxc_bridge: port 3(vethUESLM0) entered blocking state
[   75.623974] lxc_bridge: port 3(vethUESLM0) entered forwarding state
[   75.624016] IPv6: ADDRCONF(NETDEV_CHANGE): lxc_bridge: link becomes ready
[   78.250517] igb 0000:06:00.0 enp6s0: igb: enp6s0 NIC Link is Up 1000 Mbp=
s Full Duplex, Flow Control: RX/TX
[   78.250800] IPv6: ADDRCONF(NETDEV_CHANGE): enp6s0: link becomes ready
[   78.250874] lxc_bridge: port 1(enp6s0) entered blocking state
[   78.250880] lxc_bridge: port 1(enp6s0) entered forwarding state
[   83.328965] tun: Universal TUN/TAP device driver, 1.6
[48739.443440] perf: interrupt took too long (2506 > 2500), lowering kernel=
=2Eperf_event_max_sample_rate to 79800
[50268.619526] perf: interrupt took too long (3143 > 3132), lowering kernel=
=2Eperf_event_max_sample_rate to 63600
[52488.615929] BTRFS warning (device dm-13): checksum error at logical 5393=
9989975040 on dev /dev/mapper/data2, sector 1565559688, root 5, inode 11969=
, offset 17240064, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[52488.615938] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 1, gen 0
[52488.636891] BTRFS error (device dm-13): fixed up error at logical 539399=
89975040 on dev /dev/mapper/data2
[52488.652788] BTRFS warning (device dm-13): checksum error at logical 5393=
9989979136 on dev /dev/mapper/data2, sector 1565559696, root 5, inode 11969=
, offset 17244160, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[52488.652794] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 2, gen 0
[52488.654453] BTRFS error (device dm-13): fixed up error at logical 539399=
89979136 on dev /dev/mapper/data2
[52488.655520] BTRFS warning (device dm-13): checksum error at logical 5393=
9989983232 on dev /dev/mapper/data2, sector 1565559704, root 5, inode 11969=
, offset 17248256, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[52488.655527] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 3, gen 0
[52488.657344] BTRFS error (device dm-13): fixed up error at logical 539399=
89983232 on dev /dev/mapper/data2
[52488.658041] BTRFS warning (device dm-13): checksum error at logical 5393=
9989987328 on dev /dev/mapper/data2, sector 1565559712, root 5, inode 11969=
, offset 17252352, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[52488.658047] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 4, gen 0
[52488.658514] BTRFS error (device dm-13): fixed up error at logical 539399=
89987328 on dev /dev/mapper/data2
[52488.659223] BTRFS warning (device dm-13): checksum error at logical 5393=
9989991424 on dev /dev/mapper/data2, sector 1565559720, root 5, inode 11969=
, offset 17256448, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duch=
=C5=AF.mp4)
[52488.659227] BTRFS error (device dm-13): bdev /dev/mapper/data2 errs: wr =
0, rd 0, flush 0, corrupt 5, gen 0
[52488.659631] BTRFS error (device dm-13): fixed up error at logical 539399=
89991424 on dev /dev/mapper/data2
[52569.683784] BTRFS warning (device dm-13): checksum error at logical 5394=
1063716864 on dev /dev/mapper/data1, sector 1565559688, root 5, inode 11969=
, offset 956764160, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[52569.683788] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 1, gen 0
[52569.703754] BTRFS error (device dm-13): fixed up error at logical 539410=
63716864 on dev /dev/mapper/data1
[52569.707782] BTRFS warning (device dm-13): checksum error at logical 5394=
1063720960 on dev /dev/mapper/data1, sector 1565559696, root 5, inode 11969=
, offset 956768256, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[52569.707786] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 2, gen 0
[52569.708117] BTRFS error (device dm-13): fixed up error at logical 539410=
63720960 on dev /dev/mapper/data1
[52569.708871] BTRFS warning (device dm-13): checksum error at logical 5394=
1063725056 on dev /dev/mapper/data1, sector 1565559704, root 5, inode 11969=
, offset 956772352, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[52569.708876] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 3, gen 0
[52569.709121] BTRFS error (device dm-13): fixed up error at logical 539410=
63725056 on dev /dev/mapper/data1
[52569.709321] BTRFS warning (device dm-13): checksum error at logical 5394=
1063729152 on dev /dev/mapper/data1, sector 1565559712, root 5, inode 11969=
, offset 956776448, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[52569.709324] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 4, gen 0
[52569.709525] BTRFS error (device dm-13): fixed up error at logical 539410=
63729152 on dev /dev/mapper/data1
[52569.709697] BTRFS warning (device dm-13): checksum error at logical 5394=
1063733248 on dev /dev/mapper/data1, sector 1565559720, root 5, inode 11969=
, offset 956780544, length 4096, links 1 (path: pw/Filmy/Krotitel=C3=A9 duc=
h=C5=AF.mp4)
[52569.709699] BTRFS error (device dm-13): bdev /dev/mapper/data1 errs: wr =
0, rd 0, flush 0, corrupt 5, gen 0
[52569.710079] BTRFS error (device dm-13): fixed up error at logical 539410=
63733248 on dev /dev/mapper/data1
[53619.549720] perf: interrupt took too long (3936 > 3928), lowering kernel=
=2Eperf_event_max_sample_rate to 50700
[56736.309785] perf: interrupt took too long (4922 > 4920), lowering kernel=
=2Eperf_event_max_sample_rate to 40500
[65944.074429] perf: interrupt took too long (6154 > 6152), lowering kernel=
=2Eperf_event_max_sample_rate to 32400

--tbqjquqi6sis5zy5--

--udsneuuxdzxh6w3g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEKUV4RjubkPramXVZs4umGUJTxRIFAlpT8E8ACgkQs4umGUJT
xRJl+g/+NH2BiQqN79ZNEiRJTwwbVISDtEyEE5ucWUfShK//wWtkUBrCvRKkxSom
0x1K2DZetLuFsbgUYP7RNLhn58tZ5XCXYdR1NTLBtbBEFUcbEekAy909NPlDSKV2
iDZ9pjqueq4jHkrtKSgvghtOkfU28MzD2aLM0Ic6ptJetMir/bOTe2dqEafj0Les
DQAUzdsSF++xQ2EZLSEAhnTZhyoz8NHbotNgW6ZyqE4DyxkpjAMrdRJcwmu2JahT
lYicda1N9hTg4GmjVuyJrANITsvHq5XqYLfRXtTVnCP8KAN9FryxiNjys2xEICFs
zWD+s8XcXfjuR6s69psRLwfWtg9h7BeEqczril3f/TL0/F7y2pIwKBTMXvwBXmo6
d3L3bMVmX+Q7xa9WQrwUWA0hEwhxGjlm+0l78sZo4GYrUbEb95+XgEfT+kb6G85K
nCUdPyme4ujpfpb/MQt1TsIQNPV5Ce9O6xnjK2REISOnkQhqpaVosjdOJpvqIe2o
5pf8NzIkRrMTAqF6r2HgxvIqlM8GgBlFnHVuQEtBuyJ6Ra+cEFfotNtD02CIggYX
138ZD2tZG6WdpdQfjxdUNd8lJIswoydof48VqlBBPyMk0R6Imlb07vnFOIsb2tFv
xmoVLHqG+cn/osyKI9ya452vfJZbRekHMHa8jqkh8+sfzbO1Wzc=
=E92R
-----END PGP SIGNATURE-----

--udsneuuxdzxh6w3g--
