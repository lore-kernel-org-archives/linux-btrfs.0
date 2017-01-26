Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.physik.uni-muenchen.de ([192.54.42.129]:33452 "EHLO
        mail.physik.uni-muenchen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752538AbdAZXiA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 18:38:00 -0500
Message-ID: <1485473476.7613.12.camel@lmu.de>
Subject: Re: [PATCH 0/9] Lowmem mode fsck fixes with fsck-tests framework
 update
From: Christoph Anton Mitterer <christoph.anton.mitterer@lmu.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: Fri, 27 Jan 2017 00:31:16 +0100
In-Reply-To: <bb42c075-fcbd-2248-8e9f-ea5d2a836273@cn.fujitsu.com>
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
         <1485276845.12065.1.camel@scientia.net>
         <35be430d-1210-9b33-3b18-c22127cc64a7@cn.fujitsu.com>
         <1485305208.12065.9.camel@scientia.net>
         <8d21a04e-7035-5b5d-5b58-9ac0d7f93f02@cn.fujitsu.com>
         <1485399036.23328.7.camel@scientia.net>
         <bb42c075-fcbd-2248-8e9f-ea5d2a836273@cn.fujitsu.com>
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-3+kId3WlJ+LXQPQhnYb0"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-3+kId3WlJ+LXQPQhnYb0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-26 at 11:10 +0800, Qu Wenruo wrote:
> Would you please try lowmem_tests branch of my repo?
>=C2=A0
> That branch contains a special debug output for the case you=C2=A0
> encountered, which should help to debug the case.
> pecial debug output for the case you encountered, which

Here the output with your patches (again, not having applied the
unnecessary fs-tests patches):

In the output below I've replaced filenames with "[snip..snap]" and
exchanged some of the xattr values.
In case you should need their original values for testing, just tell me
and I send them to you off-list.

btrfs-progs v4.9 WITH patches:
******************************
# btrfs check --mode=3Dlowmem /dev/nbd0 ; echo $?
checking extents
checking free space cache
checking fs roots
ERROR: root 6031 EXTENT_DATA[277 524288] datasum missing, have: 36864, expe=
ct: 45056 ret: 0
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
=3D=3D=3D fs tree leaf dump: slot: 136 =3D=3D=3D
leaf 5960902508544 items 191 free space 60 generation 2775 owner 6031
fs uuid 326d292d-f97b-43ca-b1e8-c722d3474719
chunk uuid 5da7e818-7f0b-43c1-b465-fdfaa52da633
	item 0 key (274 EXTENT_DATA 7733248) itemoff 16230 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807724716032 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 1 key (274 EXTENT_DATA 7864320) itemoff 16177 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807724834816 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 2 key (274 EXTENT_DATA 7995392) itemoff 16124 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807724953600 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 3 key (274 EXTENT_DATA 8126464) itemoff 16071 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807725076480 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 4 key (274 EXTENT_DATA 8257536) itemoff 16018 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807725199360 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 5 key (274 EXTENT_DATA 8388608) itemoff 15965 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807725318144 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 6 key (274 EXTENT_DATA 8519680) itemoff 15912 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807725432832 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 7 key (274 EXTENT_DATA 8650752) itemoff 15859 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807725551616 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 8 key (274 EXTENT_DATA 8781824) itemoff 15806 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807725670400 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 9 key (274 EXTENT_DATA 8912896) itemoff 15753 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807725789184 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 10 key (274 EXTENT_DATA 9043968) itemoff 15700 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807725912064 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 11 key (274 EXTENT_DATA 9175040) itemoff 15647 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807726026752 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 12 key (274 EXTENT_DATA 9306112) itemoff 15594 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807726141440 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 13 key (274 EXTENT_DATA 9437184) itemoff 15541 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807726260224 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 14 key (274 EXTENT_DATA 9568256) itemoff 15488 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807726379008 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 15 key (274 EXTENT_DATA 9699328) itemoff 15435 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807726501888 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 16 key (274 EXTENT_DATA 9830400) itemoff 15382 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807726620672 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 17 key (274 EXTENT_DATA 9961472) itemoff 15329 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807726739456 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 18 key (274 EXTENT_DATA 10092544) itemoff 15276 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807726858240 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 19 key (274 EXTENT_DATA 10223616) itemoff 15223 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807726977024 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 20 key (274 EXTENT_DATA 10354688) itemoff 15170 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807727099904 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 21 key (274 EXTENT_DATA 10485760) itemoff 15117 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807727218688 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 22 key (274 EXTENT_DATA 10616832) itemoff 15064 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807727341568 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 23 key (274 EXTENT_DATA 10747904) itemoff 15011 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807727460352 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 24 key (274 EXTENT_DATA 10878976) itemoff 14958 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807727575040 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 25 key (274 EXTENT_DATA 11010048) itemoff 14905 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807727693824 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 26 key (274 EXTENT_DATA 11141120) itemoff 14852 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807727812608 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 27 key (274 EXTENT_DATA 11272192) itemoff 14799 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807727931392 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 28 key (274 EXTENT_DATA 11403264) itemoff 14746 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807728054272 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 29 key (274 EXTENT_DATA 11534336) itemoff 14693 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807728177152 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 30 key (274 EXTENT_DATA 11665408) itemoff 14640 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807728291840 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 31 key (274 EXTENT_DATA 11796480) itemoff 14587 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807728406528 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 32 key (274 EXTENT_DATA 11927552) itemoff 14534 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807728525312 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 33 key (274 EXTENT_DATA 12058624) itemoff 14481 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807728648192 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 34 key (274 EXTENT_DATA 12189696) itemoff 14428 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807728771072 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 35 key (274 EXTENT_DATA 12320768) itemoff 14375 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807728893952 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 36 key (274 EXTENT_DATA 12451840) itemoff 14322 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807729016832 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 37 key (274 EXTENT_DATA 12582912) itemoff 14269 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807729131520 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 38 key (274 EXTENT_DATA 12713984) itemoff 14216 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807729246208 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 39 key (274 EXTENT_DATA 12845056) itemoff 14163 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807729364992 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 40 key (274 EXTENT_DATA 12976128) itemoff 14110 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807729483776 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 41 key (274 EXTENT_DATA 13107200) itemoff 14057 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807729606656 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 42 key (274 EXTENT_DATA 13238272) itemoff 14004 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807729725440 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 43 key (274 EXTENT_DATA 13369344) itemoff 13951 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807729840128 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 44 key (274 EXTENT_DATA 13500416) itemoff 13898 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807729954816 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 45 key (274 EXTENT_DATA 13631488) itemoff 13845 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807730069504 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 46 key (274 EXTENT_DATA 13762560) itemoff 13792 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807730188288 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 47 key (274 EXTENT_DATA 13893632) itemoff 13739 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807730311168 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 48 key (274 EXTENT_DATA 14024704) itemoff 13686 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807730429952 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 49 key (274 EXTENT_DATA 14155776) itemoff 13633 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807730548736 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 50 key (274 EXTENT_DATA 14286848) itemoff 13580 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807730663424 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 51 key (274 EXTENT_DATA 14417920) itemoff 13527 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807730782208 nr 45056
		extent data offset 0 nr 53248 ram 53248
		extent compression 1 (zlib)
	item 52 key (275 INODE_ITEM 0) itemoff 13367 itemsize 160
		inode generation 2775 transid 2775 size 136 nbytes 0
		block group 0 mode 40755 links 1 uid 1000 gid 1000 rdev 0
		sequence 0 flags 0xa(none)
		atime 1471659949.935831165 (2016-08-20 04:25:49)
		ctime 1473986193.679587164 (2016-09-16 02:36:33)
		mtime 1471659958.979930414 (2016-08-20 04:25:58)
		otime 1473986193.595586129 (2016-09-16 02:36:33)
	item 53 key (275 INODE_REF 268) itemoff 13340 itemsize 27
		inode ref index 4 namelen 17 name: [snip..snap]
	item 54 key (275 DIR_ITEM 332901471) itemoff 13261 itemsize 79
		location key (276 INODE_ITEM 0) type FILE
		transid 2775 data_len 0 name_len 49
		name: [snip..snap]
	item 55 key (275 DIR_ITEM 2370206775) itemoff 13212 itemsize 49
		location key (277 INODE_ITEM 0) type FILE
		transid 2775 data_len 0 name_len 19
		name: [snip..snap]
	item 56 key (275 DIR_INDEX 2) itemoff 13133 itemsize 79
		location key (276 INODE_ITEM 0) type FILE
		transid 2775 data_len 0 name_len 49
		name: [snip..snap]
	item 57 key (275 DIR_INDEX 3) itemoff 13084 itemsize 49
		location key (277 INODE_ITEM 0) type FILE
		transid 2775 data_len 0 name_len 19
		name: [snip..snap]
	item 58 key (276 INODE_ITEM 0) itemoff 12924 itemsize 160
		inode generation 2775 transid 2775 size 9185394 nbytes 9187328
		block group 0 mode 100644 links 1 uid 1000 gid 1000 rdev 0
		sequence 0 flags 0x23(none)
		atime 1471659943.443759931 (2016-08-20 04:25:43)
		ctime 1473986193.663586968 (2016-09-16 02:36:33)
		mtime 1471659958.975930370 (2016-08-20 04:25:58)
		otime 1473986193.595586129 (2016-09-16 02:36:33)
	item 59 key (276 INODE_REF 275) itemoff 12865 itemsize 59
		inode ref index 2 namelen 49 name: [snip..snap]
	item 60 key (276 XATTR_ITEM 1330394165) itemoff 12683 itemsize 182
		location key (0 UNKNOWN.0 0) type XATTR
		transid 2775 data_len 128 name_len 24
		name: user.scinet.hash.SHA-512
		data 54a9b51b6914470bb549457c63250c59bc60ed4aa954bde3fc199313cfbbbda2d318=
e896652bb8d2971be18f0d2afaba1c48e08efa7472208f950aba2c3287ca
	item 61 key (276 EXTENT_DATA 0) itemoff 12630 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807730827264 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 62 key (276 EXTENT_DATA 131072) itemoff 12577 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807730954240 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 63 key (276 EXTENT_DATA 262144) itemoff 12524 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807731081216 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 64 key (276 EXTENT_DATA 393216) itemoff 12471 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807731204096 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 65 key (276 EXTENT_DATA 524288) itemoff 12418 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807731326976 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 66 key (276 EXTENT_DATA 655360) itemoff 12365 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807731445760 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 67 key (276 EXTENT_DATA 786432) itemoff 12312 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807731568640 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 68 key (276 EXTENT_DATA 917504) itemoff 12259 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807731695616 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 69 key (276 EXTENT_DATA 1048576) itemoff 12206 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807731822592 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 70 key (276 EXTENT_DATA 1179648) itemoff 12153 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807731949568 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 71 key (276 EXTENT_DATA 1310720) itemoff 12100 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807732072448 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 72 key (276 EXTENT_DATA 1441792) itemoff 12047 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807732195328 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 73 key (276 EXTENT_DATA 1572864) itemoff 11994 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807732314112 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 74 key (276 EXTENT_DATA 1703936) itemoff 11941 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807732436992 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 75 key (276 EXTENT_DATA 1835008) itemoff 11888 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807732559872 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 76 key (276 EXTENT_DATA 1966080) itemoff 11835 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807732682752 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 77 key (276 EXTENT_DATA 2097152) itemoff 11782 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807732805632 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 78 key (276 EXTENT_DATA 2228224) itemoff 11729 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807732924416 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 79 key (276 EXTENT_DATA 2359296) itemoff 11676 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807733047296 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 80 key (276 EXTENT_DATA 2490368) itemoff 11623 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807733170176 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 81 key (276 EXTENT_DATA 2621440) itemoff 11570 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807733293056 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 82 key (276 EXTENT_DATA 2752512) itemoff 11517 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807733411840 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 83 key (276 EXTENT_DATA 2883584) itemoff 11464 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807733538816 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 84 key (276 EXTENT_DATA 3014656) itemoff 11411 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807733665792 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 85 key (276 EXTENT_DATA 3145728) itemoff 11358 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807733792768 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 86 key (276 EXTENT_DATA 3276800) itemoff 11305 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807733915648 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 87 key (276 EXTENT_DATA 3407872) itemoff 11252 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807734030336 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 88 key (276 EXTENT_DATA 3538944) itemoff 11199 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807734153216 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 89 key (276 EXTENT_DATA 3670016) itemoff 11146 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807734272000 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 90 key (276 EXTENT_DATA 3801088) itemoff 11093 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807734390784 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 91 key (276 EXTENT_DATA 3932160) itemoff 11040 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807734509568 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 92 key (276 EXTENT_DATA 4063232) itemoff 10987 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807734624256 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 93 key (276 EXTENT_DATA 4194304) itemoff 10934 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807734747136 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 94 key (276 EXTENT_DATA 4325376) itemoff 10881 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807734865920 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 95 key (276 EXTENT_DATA 4456448) itemoff 10828 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807734988800 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 96 key (276 EXTENT_DATA 4587520) itemoff 10775 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807735103488 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 97 key (276 EXTENT_DATA 4718592) itemoff 10722 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807735222272 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 98 key (276 EXTENT_DATA 4849664) itemoff 10669 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807735341056 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 99 key (276 EXTENT_DATA 4980736) itemoff 10616 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807735459840 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 100 key (276 EXTENT_DATA 5111808) itemoff 10563 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807735582720 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 101 key (276 EXTENT_DATA 5242880) itemoff 10510 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807735705600 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 102 key (276 EXTENT_DATA 5373952) itemoff 10457 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807735828480 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 103 key (276 EXTENT_DATA 5505024) itemoff 10404 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807735951360 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 104 key (276 EXTENT_DATA 5636096) itemoff 10351 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807736074240 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 105 key (276 EXTENT_DATA 5767168) itemoff 10298 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807736193024 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 106 key (276 EXTENT_DATA 5898240) itemoff 10245 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807736315904 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 107 key (276 EXTENT_DATA 6029312) itemoff 10192 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807736438784 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 108 key (276 EXTENT_DATA 6160384) itemoff 10139 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807736557568 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 109 key (276 EXTENT_DATA 6291456) itemoff 10086 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807736680448 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 110 key (276 EXTENT_DATA 6422528) itemoff 10033 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807736807424 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 111 key (276 EXTENT_DATA 6553600) itemoff 9980 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807736930304 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 112 key (276 EXTENT_DATA 6684672) itemoff 9927 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807737053184 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 113 key (276 EXTENT_DATA 6815744) itemoff 9874 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807737176064 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 114 key (276 EXTENT_DATA 6946816) itemoff 9821 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807737298944 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 115 key (276 EXTENT_DATA 7077888) itemoff 9768 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807737417728 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 116 key (276 EXTENT_DATA 7208960) itemoff 9715 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807737536512 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 117 key (276 EXTENT_DATA 7340032) itemoff 9662 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807737659392 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 118 key (276 EXTENT_DATA 7471104) itemoff 9609 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807737778176 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 119 key (276 EXTENT_DATA 7602176) itemoff 9556 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807737896960 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 120 key (276 EXTENT_DATA 7733248) itemoff 9503 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807738015744 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 121 key (276 EXTENT_DATA 7864320) itemoff 9450 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807738134528 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 122 key (276 EXTENT_DATA 7995392) itemoff 9397 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807738257408 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 123 key (276 EXTENT_DATA 8126464) itemoff 9344 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807738376192 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 124 key (276 EXTENT_DATA 8257536) itemoff 9291 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807738499072 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 125 key (276 EXTENT_DATA 8388608) itemoff 9238 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807738617856 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 126 key (276 EXTENT_DATA 8519680) itemoff 9185 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807738740736 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 127 key (276 EXTENT_DATA 8650752) itemoff 9132 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807738863616 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 128 key (276 EXTENT_DATA 8781824) itemoff 9079 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807738982400 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 129 key (276 EXTENT_DATA 8912896) itemoff 9026 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807739101184 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 130 key (276 EXTENT_DATA 9043968) itemoff 8973 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807739219968 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 131 key (276 EXTENT_DATA 9175040) itemoff 8920 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807739338752 nr 8192
		extent data offset 0 nr 12288 ram 12288
		extent compression 1 (zlib)
	item 132 key (277 INODE_ITEM 0) itemoff 8760 itemsize 160
		inode generation 2775 transid 2775 size 565664 nbytes 569344
		block group 0 mode 100644 links 1 uid 1000 gid 1000 rdev 0
		sequence 8 flags 0xb(NOCOMPRESS)
		atime 1471659953.967875410 (2016-08-20 04:25:53)
		ctime 1473986193.679587164 (2016-09-16 02:36:33)
		mtime 1471659957.51909254 (2016-08-20 04:25:57)
		otime 1473986193.663586968 (2016-09-16 02:36:33)
	item 133 key (277 INODE_REF 275) itemoff 8731 itemsize 29
		inode ref index 3 namelen 19 name: [snip..snap]
	item 134 key (277 XATTR_ITEM 1330394165) itemoff 8549 itemsize 182
		location key (0 UNKNOWN.0 0) type XATTR
		transid 2775 data_len 128 name_len 24
		name: user.scinet.hash.SHA-512
		data a6e286c88c1b290294e5367513e670c3d50456d81ba59486d00fa15509042e464116=
c0f061711d9fdd0c94ed642106868660b7ae984713b498d28a87732822b7
	item 135 key (277 EXTENT_DATA 0) itemoff 8496 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807739346944 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 136 key (277 EXTENT_DATA 524288) itemoff 8443 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6805694144512 nr 36864
		extent data offset 0 nr 45056 ram 45056
		extent compression 1 (zlib)
	item 137 key (278 INODE_ITEM 0) itemoff 8283 itemsize 160
		inode generation 2775 transid 2775 size 140 nbytes 0
		block group 0 mode 40755 links 1 uid 1000 gid 1000 rdev 0
		sequence 0 flags 0x9(none)
		atime 1471659969.700048076 (2016-08-20 04:26:09)
		ctime 1473986193.803588694 (2016-09-16 02:36:33)
		mtime 1471659997.828356911 (2016-08-20 04:26:37)
		otime 1473986193.679587164 (2016-09-16 02:36:33)
	item 138 key (278 INODE_REF 268) itemoff 8247 itemsize 36
		inode ref index 5 namelen 26 name: [snip..snap]
	item 139 key (278 DIR_ITEM 3019993287) itemoff 8147 itemsize 100
		location key (279 INODE_ITEM 0) type FILE
		transid 2775 data_len 0 name_len 70
		name: [snip..snap]
	item 140 key (278 DIR_INDEX 2) itemoff 8047 itemsize 100
		location key (279 INODE_ITEM 0) type FILE
		transid 2775 data_len 0 name_len 70
		name: [snip..snap]
	item 141 key (279 INODE_ITEM 0) itemoff 7887 itemsize 160
		inode generation 2775 transid 2775 size 18033093 nbytes 18034688
		block group 0 mode 100644 links 1 uid 1000 gid 1000 rdev 0
		sequence 8 flags 0xb(NOCOMPRESS)
		atime 1471659959.995941565 (2016-08-20 04:25:59)
		ctime 1473986193.803588694 (2016-09-16 02:36:33)
		mtime 1471659997.824356866 (2016-08-20 04:26:37)
		otime 1473986193.679587164 (2016-09-16 02:36:33)
	item 142 key (279 INODE_REF 278) itemoff 7807 itemsize 80
		inode ref index 2 namelen 70 name: [snip..snap]
	item 143 key (279 XATTR_ITEM 1330394165) itemoff 7625 itemsize 182
		location key (0 UNKNOWN.0 0) type XATTR
		data 3da14e71e11761b072cf710044fa3403276d7d540618407a104209c10345b0b9295d=
24c6624e902b174cde2a63aaa07b0fa36ee1af39c05517cf85300bc70b92
		transid 2775 data_len 128 name_len 24
		name: user.scinet.hash.SHA-512
	item 144 key (279 EXTENT_DATA 0) itemoff 7572 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807739871232 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 145 key (279 EXTENT_DATA 131072) itemoff 7519 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807739998208 nr 393216
		extent data offset 0 nr 393216 ram 393216
		extent compression 0 (none)
	item 146 key (279 EXTENT_DATA 524288) itemoff 7466 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807740391424 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 147 key (279 EXTENT_DATA 1048576) itemoff 7413 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807740915712 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 148 key (279 EXTENT_DATA 1179648) itemoff 7360 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807741042688 nr 393216
		extent data offset 0 nr 393216 ram 393216
		extent compression 0 (none)
	item 149 key (279 EXTENT_DATA 1572864) itemoff 7307 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807741435904 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 150 key (279 EXTENT_DATA 1703936) itemoff 7254 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807741562880 nr 393216
		extent data offset 0 nr 393216 ram 393216
		extent compression 0 (none)
	item 151 key (279 EXTENT_DATA 2097152) itemoff 7201 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807741956096 nr 122880
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 152 key (279 EXTENT_DATA 2228224) itemoff 7148 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807742078976 nr 393216
		extent data offset 0 nr 393216 ram 393216
		extent compression 0 (none)
	item 153 key (279 EXTENT_DATA 2621440) itemoff 7095 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807742472192 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 154 key (279 EXTENT_DATA 3145728) itemoff 7042 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807742996480 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 155 key (279 EXTENT_DATA 3670016) itemoff 6989 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807743520768 nr 126976
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 156 key (279 EXTENT_DATA 3801088) itemoff 6936 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807743647744 nr 393216
		extent data offset 0 nr 393216 ram 393216
		extent compression 0 (none)
	item 157 key (279 EXTENT_DATA 4194304) itemoff 6883 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807744040960 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 158 key (279 EXTENT_DATA 4718592) itemoff 6830 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807744565248 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 159 key (279 EXTENT_DATA 5242880) itemoff 6777 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807745089536 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 160 key (279 EXTENT_DATA 5767168) itemoff 6724 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807745613824 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 161 key (279 EXTENT_DATA 6291456) itemoff 6671 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807746138112 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 162 key (279 EXTENT_DATA 6815744) itemoff 6618 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807746662400 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 163 key (279 EXTENT_DATA 7340032) itemoff 6565 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807747186688 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 164 key (279 EXTENT_DATA 7864320) itemoff 6512 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807747710976 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 165 key (279 EXTENT_DATA 8388608) itemoff 6459 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807748235264 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 166 key (279 EXTENT_DATA 8912896) itemoff 6406 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807748759552 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 167 key (279 EXTENT_DATA 9437184) itemoff 6353 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807749283840 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 168 key (279 EXTENT_DATA 9961472) itemoff 6300 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807749808128 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 169 key (279 EXTENT_DATA 10485760) itemoff 6247 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807750332416 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 170 key (279 EXTENT_DATA 11010048) itemoff 6194 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807750856704 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 171 key (279 EXTENT_DATA 11534336) itemoff 6141 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807751380992 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 172 key (279 EXTENT_DATA 12058624) itemoff 6088 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807751905280 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 173 key (279 EXTENT_DATA 12582912) itemoff 6035 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807752429568 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 174 key (279 EXTENT_DATA 13107200) itemoff 5982 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807752953856 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 175 key (279 EXTENT_DATA 13631488) itemoff 5929 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807753478144 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 176 key (279 EXTENT_DATA 14155776) itemoff 5876 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807754002432 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 177 key (279 EXTENT_DATA 14680064) itemoff 5823 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807754526720 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 178 key (279 EXTENT_DATA 15204352) itemoff 5770 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807755051008 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 179 key (279 EXTENT_DATA 15728640) itemoff 5717 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807755575296 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 180 key (279 EXTENT_DATA 16252928) itemoff 5664 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807756099584 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 181 key (279 EXTENT_DATA 16777216) itemoff 5611 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807756623872 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 182 key (279 EXTENT_DATA 17301504) itemoff 5558 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807757148160 nr 524288
		extent data offset 0 nr 524288 ram 524288
		extent compression 0 (none)
	item 183 key (279 EXTENT_DATA 17825792) itemoff 5505 itemsize 53
		generation 2775 type 1 (regular)
		extent data disk byte 6807757672448 nr 208896
		extent data offset 0 nr 208896 ram 208896
		extent compression 0 (none)
	item 184 key (280 INODE_ITEM 0) itemoff 5345 itemsize 160
		inode generation 2775 transid 2775 size 202 nbytes 0
		block group 0 mode 40755 links 1 uid 1000 gid 1000 rdev 0
		sequence 0 flags 0x1a(none)
		atime 1471659982.48183634 (2016-08-20 04:26:22)
		ctime 1473986194.95592295 (2016-09-16 02:36:34)
		mtime 1471660037.872796836 (2016-08-20 04:27:17)
		otime 1473986193.803588694 (2016-09-16 02:36:33)
	item 185 key (280 INODE_REF 268) itemoff 5317 itemsize 28
		inode ref index 6 namelen 18 name: [snip..snap]
	item 186 key (280 DIR_ITEM 38578281) itemoff 5232 itemsize 85
		location key (281 INODE_ITEM 0) type FILE
		transid 2775 data_len 0 name_len 55
		name: [snip..snap]
	item 187 key (280 DIR_ITEM 2341083723) itemoff 5156 itemsize 76
		location key (282 INODE_ITEM 0) type FILE
		transid 2775 data_len 0 name_len 46
		name: [snip..snap]
	item 188 key (280 DIR_INDEX 2) itemoff 5071 itemsize 85
		location key (281 INODE_ITEM 0) type FILE
		transid 2775 data_len 0 name_len 55
		name: J[snip..snap]
	item 189 key (280 DIR_INDEX 3) itemoff 4995 itemsize 76
		location key (282 INODE_ITEM 0) type FILE
		transid 2775 data_len 0 name_len 46
		name: [snip..snap]
	item 190 key (281 INODE_ITEM 0) itemoff 4835 itemsize 160
		inode generation 2775 transid 2775 size 28025786 nbytes 28028928
		block group 0 mode 100644 links 1 uid 1000 gid 1000 rdev 0
		sequence 8 flags 0x1f(NOCOMPRESS)
		atime 1471659973.56084916 (2016-08-20 04:26:13)
		ctime 1473986194.23591408 (2016-09-16 02:36:34)
		mtime 1471660037.868796793 (2016-08-20 04:27:17)
		otime 1473986193.803588694 (2016-09-16 02:36:33)
=3D=3D=3D csum tree dump =3D=3D=3D
leaf 4983028940800 items 22 free space 6853 generation 3093 owner 7
fs uuid 326d292d-f97b-43ca-b1e8-c722d3474719
chunk uuid 5da7e818-7f0b-43c1-b465-fdfaa52da633
	item 0 key (EXTENT_CSUM EXTENT_CSUM 6805691457536) itemoff 16279 itemsize =
4
		extent csum item
	item 1 key (EXTENT_CSUM EXTENT_CSUM 6805691461632) itemoff 16275 itemsize =
4
		extent csum item
	item 2 key (EXTENT_CSUM EXTENT_CSUM 6805691465728) itemoff 16263 itemsize =
12
		extent csum item
	item 3 key (EXTENT_CSUM EXTENT_CSUM 6805691478016) itemoff 16231 itemsize =
32
		extent csum item
	item 4 key (EXTENT_CSUM EXTENT_CSUM 6805691510784) itemoff 16223 itemsize =
8
		extent csum item
	item 5 key (EXTENT_CSUM EXTENT_CSUM 6805691518976) itemoff 16199 itemsize =
24
		extent csum item
	item 6 key (EXTENT_CSUM EXTENT_CSUM 6805691543552) itemoff 16183 itemsize =
16
		extent csum item
	item 7 key (EXTENT_CSUM EXTENT_CSUM 6805691559936) itemoff 15159 itemsize =
1024
		extent csum item
	item 8 key (EXTENT_CSUM EXTENT_CSUM 6805692608512) itemoff 15151 itemsize =
8
		extent csum item
	item 9 key (EXTENT_CSUM EXTENT_CSUM 6805692616704) itemoff 15055 itemsize =
96
		extent csum item
	item 10 key (EXTENT_CSUM EXTENT_CSUM 6805692715008) itemoff 14903 itemsize=
 152
		extent csum item
	item 11 key (EXTENT_CSUM EXTENT_CSUM 6805693132800) itemoff 14519 itemsize=
 384
		extent csum item
	item 12 key (EXTENT_CSUM EXTENT_CSUM 6805693526016) itemoff 14391 itemsize=
 128
		extent csum item
	item 13 key (EXTENT_CSUM EXTENT_CSUM 6805693919232) itemoff 14135 itemsize=
 256
		extent csum item
	item 14 key (EXTENT_CSUM EXTENT_CSUM 6805694443520) itemoff 12727 itemsize=
 1408
		extent csum item
	item 15 key (EXTENT_CSUM EXTENT_CSUM 6805695885312) itemoff 11811 itemsize=
 916
		extent csum item
	item 16 key (EXTENT_CSUM EXTENT_CSUM 6805696823296) itemoff 11007 itemsize=
 804
		extent csum item
	item 17 key (EXTENT_CSUM EXTENT_CSUM 6805697646592) itemoff 10211 itemsize=
 796
		extent csum item
	item 18 key (EXTENT_CSUM EXTENT_CSUM 6805698461696) itemoff 9799 itemsize =
412
		extent csum item
	item 19 key (EXTENT_CSUM EXTENT_CSUM 6805698883584) itemoff 9259 itemsize =
540
		extent csum item
	item 20 key (EXTENT_CSUM EXTENT_CSUM 6805699436544) itemoff 8827 itemsize =
432
		extent csum item
	item 21 key (EXTENT_CSUM EXTENT_CSUM 6805699878912) itemoff 7403 itemsize =
1424
		extent csum item
=3D=3D=3D csum tree dump =3D=3D=3D
leaf 4983028940800 items 22 free space 6853 generation 3093 owner 7
fs uuid 326d292d-f97b-43ca-b1e8-c722d3474719
chunk uuid 5da7e818-7f0b-43c1-b465-fdfaa52da633
	item 0 key (EXTENT_CSUM EXTENT_CSUM 6805691457536) itemoff 16279 itemsize =
4
		extent csum item
	item 1 key (EXTENT_CSUM EXTENT_CSUM 6805691461632) itemoff 16275 itemsize =
4
		extent csum item
	item 2 key (EXTENT_CSUM EXTENT_CSUM 6805691465728) itemoff 16263 itemsize =
12
		extent csum item
	item 3 key (EXTENT_CSUM EXTENT_CSUM 6805691478016) itemoff 16231 itemsize =
32
		extent csum item
	item 4 key (EXTENT_CSUM EXTENT_CSUM 6805691510784) itemoff 16223 itemsize =
8
		extent csum item
	item 5 key (EXTENT_CSUM EXTENT_CSUM 6805691518976) itemoff 16199 itemsize =
24
		extent csum item
	item 6 key (EXTENT_CSUM EXTENT_CSUM 6805691543552) itemoff 16183 itemsize =
16
		extent csum item
	item 7 key (EXTENT_CSUM EXTENT_CSUM 6805691559936) itemoff 15159 itemsize =
1024
		extent csum item
	item 8 key (EXTENT_CSUM EXTENT_CSUM 6805692608512) itemoff 15151 itemsize =
8
		extent csum item
	item 9 key (EXTENT_CSUM EXTENT_CSUM 6805692616704) itemoff 15055 itemsize =
96
		extent csum item
	item 10 key (EXTENT_CSUM EXTENT_CSUM 6805692715008) itemoff 14903 itemsize=
 152
		extent csum item
	item 11 key (EXTENT_CSUM EXTENT_CSUM 6805693132800) itemoff 14519 itemsize=
 384
		extent csum item
	item 12 key (EXTENT_CSUM EXTENT_CSUM 6805693526016) itemoff 14391 itemsize=
 128
		extent csum item
	item 13 key (EXTENT_CSUM EXTENT_CSUM 6805693919232) itemoff 14135 itemsize=
 256
		extent csum item
	item 14 key (EXTENT_CSUM EXTENT_CSUM 6805694443520) itemoff 12727 itemsize=
 1408
		extent csum item
	item 15 key (EXTENT_CSUM EXTENT_CSUM 6805695885312) itemoff 11811 itemsize=
 916
		extent csum item
	item 16 key (EXTENT_CSUM EXTENT_CSUM 6805696823296) itemoff 11007 itemsize=
 804
		extent csum item
	item 17 key (EXTENT_CSUM EXTENT_CSUM 6805697646592) itemoff 10211 itemsize=
 796
		extent csum item
	item 18 key (EXTENT_CSUM EXTENT_CSUM 6805698461696) itemoff 9799 itemsize =
412
		extent csum item
	item 19 key (EXTENT_CSUM EXTENT_CSUM 6805698883584) itemoff 9259 itemsize =
540
		extent csum item
	item 20 key (EXTENT_CSUM EXTENT_CSUM 6805699436544) itemoff 8827 itemsize =
432
		extent csum item
	item 21 key (EXTENT_CSUM EXTENT_CSUM 6805699878912) itemoff 7403 itemsize =
1424
		extent csum item
ERROR: errors found in fs roots
found 7519512838144 bytes used, error(s) found
total csum bytes: 7330834320
total tree bytes: 10902437888
total fs tree bytes: 2019704832
total extent tree bytes: 1020149760
btree space waste bytes: 925714197
file data blocks allocated: 7509228494848
 referenced 7630551511040
1


Cheers,
Chris.
--=-3+kId3WlJ+LXQPQhnYb0
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCCrAw
ggVUMIIEPKADAgECAgcaxwkCGxwKMA0GCSqGSIb3DQEBCwUAMFgxCzAJBgNVBAYTAkRFMRMwEQYD
VQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJMSIwIAYDVQQDExlERk4tVmVyZWluIFBD
QSBHcmlkIC0gRzAxMB4XDTE2MDEyNjE1MDYyN1oXDTE3MDIyMjE1MDYyN1oweTELMAkGA1UEBhMC
REUxFDASBgNVBAoMC0dyaWRHZXJtYW55MTEwLwYDVQQLDChMdWR3aWctTWF4aW1pbGlhbnMtVW5p
dmVyc2l0YWV0IE11ZW5jaGVuMSEwHwYDVQQDDBhDaHJpc3RvcGggQW50b24gTWl0dGVyZXIwggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDGxxmy4+et82RWI9HAk1bzXsQCBRXSRovVbhbc
EfHXqxnSbTwLFcKVtxGSPax6vJ2xijtusKNaocXRJ91Y5470twfPWWcZ+T5WN0mdPPJKcJc9D+EX
sNk6KTB9HJhqlxqOWv/AmXjYKQavy4i1ojMjB8RyFtzS2EFIrDJqpQnmhE8npXhnuFqYIm4+ByGh
83P1ni2KecLqrFzJ51bzH39aPIttW8YBKcBxJBsT9a+iOWocfKjOs/agrQwo6ntLOLjXtvTkX/TT
w6iRDM2CmukNRtZx+YsD491RroAxOkYQeEL2K8/0eRmOzP7FAmdOt8ihiXdABXnjm3qgmwGgqmnV
AgMBAAGjggIAMIIB/DAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIEsDAdBgNVHSUEFjAUBggr
BgEFBQcDAgYIKwYBBQUHAwQwHQYDVR0OBBYEFG84ZPHmdMMOIKtYmsdzOhyRw2XeMB8GA1UdIwQY
MBaAFJbs3K2aw/5Qozwi5T3Cxf/K2SLGMCoGA1UdEQQjMCGBH2NocmlzdG9waC5hbnRvbi5taXR0
ZXJlckBsbXUuZGUwKgYDVR0gBCMwITARBg8rBgEEAYGtIYIsAQEDAQYwDAYKKoZIhvdMBQICATCB
gwYDVR0fBHwwejA7oDmgN4Y1aHR0cDovL2NkcDEucGNhLmRmbi5kZS9ncmlkLXJvb3QtY2EvcHVi
L2NybC9jYWNybC5jcmwwO6A5oDeGNWh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ3JpZC1yb290LWNh
L3B1Yi9jcmwvY2FjcmwuY3JsMIGeBggrBgEFBQcBAQSBkTCBjjBFBggrBgEFBQcwAoY5aHR0cDov
L2NkcDEucGNhLmRmbi5kZS9ncmlkLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MEUGCCsG
AQUFBzAChjlodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dyaWQtcm9vdC1jYS9wdWIvY2FjZXJ0L2Nh
Y2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAKX99KphzebNy9XJEwAphG7eRywBPsOy8lhdIfrs
YJzDJcxMCJqesio4fZgrxCdbqoHl2ffbgTk6TlMsIdRHvZRWd4+fJv6HsKNJVJfoQ+rVinzRSOAr
sgKe4P+XejyJ1P0xferyxxHswE9ZvVnu5aRl2vRkjvLtxY0NsnN6Y0AlSY4KjaVfMG+nZ3XqNYni
hAejky5J25wg4dSNu2ZQECE9YGmVBA24jIKxFiroeGOm7nunzxitVRax1Kk9EmMXq97kEeVSWMfK
M+zjhYG0rpLcAxvdAZ38L5G+diH2eGTJIwZSJDJHyURzF9zWwxzjYpJ+3vZ7TCLbdN0IlPYIrv0w
ggVUMIIEPKADAgECAgcaxwkCGxwKMA0GCSqGSIb3DQEBCwUAMFgxCzAJBgNVBAYTAkRFMRMwEQYD
VQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJMSIwIAYDVQQDExlERk4tVmVyZWluIFBD
QSBHcmlkIC0gRzAxMB4XDTE2MDEyNjE1MDYyN1oXDTE3MDIyMjE1MDYyN1oweTELMAkGA1UEBhMC
REUxFDASBgNVBAoMC0dyaWRHZXJtYW55MTEwLwYDVQQLDChMdWR3aWctTWF4aW1pbGlhbnMtVW5p
dmVyc2l0YWV0IE11ZW5jaGVuMSEwHwYDVQQDDBhDaHJpc3RvcGggQW50b24gTWl0dGVyZXIwggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDGxxmy4+et82RWI9HAk1bzXsQCBRXSRovVbhbc
EfHXqxnSbTwLFcKVtxGSPax6vJ2xijtusKNaocXRJ91Y5470twfPWWcZ+T5WN0mdPPJKcJc9D+EX
sNk6KTB9HJhqlxqOWv/AmXjYKQavy4i1ojMjB8RyFtzS2EFIrDJqpQnmhE8npXhnuFqYIm4+ByGh
83P1ni2KecLqrFzJ51bzH39aPIttW8YBKcBxJBsT9a+iOWocfKjOs/agrQwo6ntLOLjXtvTkX/TT
w6iRDM2CmukNRtZx+YsD491RroAxOkYQeEL2K8/0eRmOzP7FAmdOt8ihiXdABXnjm3qgmwGgqmnV
AgMBAAGjggIAMIIB/DAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIEsDAdBgNVHSUEFjAUBggr
BgEFBQcDAgYIKwYBBQUHAwQwHQYDVR0OBBYEFG84ZPHmdMMOIKtYmsdzOhyRw2XeMB8GA1UdIwQY
MBaAFJbs3K2aw/5Qozwi5T3Cxf/K2SLGMCoGA1UdEQQjMCGBH2NocmlzdG9waC5hbnRvbi5taXR0
ZXJlckBsbXUuZGUwKgYDVR0gBCMwITARBg8rBgEEAYGtIYIsAQEDAQYwDAYKKoZIhvdMBQICATCB
gwYDVR0fBHwwejA7oDmgN4Y1aHR0cDovL2NkcDEucGNhLmRmbi5kZS9ncmlkLXJvb3QtY2EvcHVi
L2NybC9jYWNybC5jcmwwO6A5oDeGNWh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ3JpZC1yb290LWNh
L3B1Yi9jcmwvY2FjcmwuY3JsMIGeBggrBgEFBQcBAQSBkTCBjjBFBggrBgEFBQcwAoY5aHR0cDov
L2NkcDEucGNhLmRmbi5kZS9ncmlkLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MEUGCCsG
AQUFBzAChjlodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dyaWQtcm9vdC1jYS9wdWIvY2FjZXJ0L2Nh
Y2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAKX99KphzebNy9XJEwAphG7eRywBPsOy8lhdIfrs
YJzDJcxMCJqesio4fZgrxCdbqoHl2ffbgTk6TlMsIdRHvZRWd4+fJv6HsKNJVJfoQ+rVinzRSOAr
sgKe4P+XejyJ1P0xferyxxHswE9ZvVnu5aRl2vRkjvLtxY0NsnN6Y0AlSY4KjaVfMG+nZ3XqNYni
hAejky5J25wg4dSNu2ZQECE9YGmVBA24jIKxFiroeGOm7nunzxitVRax1Kk9EmMXq97kEeVSWMfK
M+zjhYG0rpLcAxvdAZ38L5G+diH2eGTJIwZSJDJHyURzF9zWwxzjYpJ+3vZ7TCLbdN0IlPYIrv0x
ggMFMIIDAQIBATBjMFgxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQL
EwdERk4tUEtJMSIwIAYDVQQDExlERk4tVmVyZWluIFBDQSBHcmlkIC0gRzAxAgcaxwkCGxwKMA0G
CWCGSAFlAwQCAwUAoIIBczAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0xNzAxMjYyMzMxMTZaME8GCSqGSIb3DQEJBDFCBEArTs4D5ss5phtN0KHuLOxLWlNoUCNMfU2Z
C158VtozrQkL5SFU3T1XE075jQRQwSn4FwM6Va5UVTTdc9+i/8s/MHIGCSsGAQQBgjcQBDFlMGMw
WDELMAkGA1UEBhMCREUxEzARBgNVBAoTCkRGTi1WZXJlaW4xEDAOBgNVBAsTB0RGTi1QS0kxIjAg
BgNVBAMTGURGTi1WZXJlaW4gUENBIEdyaWQgLSBHMDECBxrHCQIbHAowdAYLKoZIhvcNAQkQAgsx
ZaBjMFgxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJ
MSIwIAYDVQQDExlERk4tVmVyZWluIFBDQSBHcmlkIC0gRzAxAgcaxwkCGxwKMA0GCSqGSIb3DQEB
AQUABIIBAGRRzZtw4uFccBgMHBE+B5zop2OeMfJGmytWK6lyGiBmlpcToysaJgoOVBY+Q3qZINNr
P4WU8CtojL1E/hlkEGLMCQ4YEFErTdjKsIX70Ud2EjN5TvddFrhf/EwX6pvBAPfZkLxo1lSHVU+6
BzCegqWe4yZbwLvgFWuTngJMw5Mw+lWL4Fan+QD32HEUSuYCHOMs/zdDcIhZkgeva5+n03KEA7Jh
88VOhgSkXBAihjQmCOpE5sa8YQ52AuKEgzapcUePZ0m7vivOiV3NlPvAXVAwmY7l2vQbnBlF7yRd
3WLjwAHpmPkwMd0UH5jvtCW/kmKUuVG3dCG4Pk2jtdO9ZgUAAAAAAAA=


--=-3+kId3WlJ+LXQPQhnYb0--

