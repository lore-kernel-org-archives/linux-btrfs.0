Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48078 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932939AbeGJDvK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2018 23:51:10 -0400
Date: Mon, 9 Jul 2018 20:50:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, Su Yue <Damenly_Su@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20180710035057.bdbilddtss5mcfhg@merlins.org>
References: <b1b2d361-eb1a-f172-45d3-409abd131d2b@cn.fujitsu.com>
 <20180705153023.GA30566@merlins.org>
 <trinity-d028b6bd-31d9-41c0-a091-47bcb810cdc3-1530808069711@msvc-mesg-gmx023>
 <20180705165049.t56dvqpz7ljjan5c@merlins.org>
 <trinity-79578bdf-a849-4342-a082-f2b882f2251e-1530810500266@msvc-mesg-gmx024>
 <20180706160523.kxwxjzwneseaamnt@merlins.org>
 <20180706175636.53ebp7drifiqu5b7@merlins.org>
 <20180707172114.bfc26eoahullffgg@merlins.org>
 <4176efa9-0753-ed28-cf15-69f0b1f1a09b@cn.fujitsu.com>
 <4576731a-ce45-60f4-d409-decf77910cd2@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4576731a-ce45-60f4-d409-decf77910cd2@gmx.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 10, 2018 at 09:34:36AM +0800, Qu Wenruo wrote:
> >>>> Ok, this is where I am now:
> >>>> WARNING: debug: end of checking extent item[18457780273152 169 1]
> >>>> type: 176 offset: 2
> >>>> checking extent items [18457780273152/18457780273152]
> >>>> ERROR: errors found in extent allocation tree or chunk allocation
> >>>> checking fs roots
> >>>> ERROR: root 17592 EXTENT_DATA[25937109 4096] gap exists, expected:
> >>>> EXTENT_DATA[25937109 4033]
> 
> The expected end is not even aligned to sectorsize.
> 
> I think there is something wrong.
> Dump tree on this INODE would definitely help in this case.
> 
> Marc, would you please try dump using the following command?
> 
> # btrfs ins dump-tree -t 17592 <dev> | grep -C 40 25937109
 
Sure, there you go:
gargamel:~# btrfs ins dump-tree -t 17592 /dev/mapper/dshelf2  | grep -C 40 25937109
		extent data disk byte 3259370151936 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 144 key (2009526 EXTENT_DATA 1179648) itemoff 7931 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259370266624 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 145 key (2009526 EXTENT_DATA 1310720) itemoff 7878 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259370385408 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 146 key (2009526 EXTENT_DATA 1441792) itemoff 7825 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259370504192 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 147 key (2009526 EXTENT_DATA 1572864) itemoff 7772 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259370622976 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 148 key (2009526 EXTENT_DATA 1703936) itemoff 7719 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259370737664 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 149 key (2009526 EXTENT_DATA 1835008) itemoff 7666 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259370856448 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 150 key (2009526 EXTENT_DATA 1966080) itemoff 7613 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259370975232 nr 118784
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 151 key (2009526 EXTENT_DATA 2097152) itemoff 7560 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259371094016 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 152 key (2009526 EXTENT_DATA 2228224) itemoff 7507 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259371208704 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 153 key (2009526 EXTENT_DATA 2359296) itemoff 7454 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259371323392 nr 110592
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 154 key (2009526 EXTENT_DATA 2490368) itemoff 7401 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259371433984 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 155 key (2009526 EXTENT_DATA 2621440) itemoff 7348 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259371548672 nr 110592
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 156 key (2009526 EXTENT_DATA 2752512) itemoff 7295 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259371659264 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 157 key (2009526 EXTENT_DATA 2883584) itemoff 7242 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259371773952 nr 106496
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 158 key (2009526 EXTENT_DATA 3014656) itemoff 7189 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259371880448 nr 114688
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
	item 159 key (2009526 EXTENT_DATA 3145728) itemoff 7136 itemsize 53
		generation 18462 type 1 (regular)
		extent data disk byte 3259371995136 nr 114688
--
		location key (14379106 INODE_ITEM 0) type FILE
		transid 22300 data_len 0 name_len 35
		name: thumb1024_712_20150620_EDC_Day3.jpg
	item 133 key (14354867 DIR_ITEM 729404427) itemoff 6716 itemsize 109
		location key (14379951 INODE_ITEM 0) type FILE
		transid 22301 data_len 0 name_len 79
		name: thumb1024_AllBest-Dive7-1_Dos_Amigos_Pequena-128_Dive7-1_Dos_Amigos_Pequena.jpg
	item 134 key (14354867 DIR_ITEM 729583157) itemoff 6639 itemsize 77
		location key (17112358 INODE_ITEM 0) type FILE
		transid 32826 data_len 0 name_len 47
		name: thumb1024_151_20180126_Sydney_Australia_Day.jpg
	item 135 key (14354867 DIR_ITEM 729620534) itemoff 6565 itemsize 74
		location key (17112383 INODE_ITEM 0) type FILE
		transid 32826 data_len 0 name_len 44
		name: thumb1024_185_20180127_Powerhouse_Museum.jpg
	item 136 key (14354867 DIR_ITEM 729673586) itemoff 6487 itemsize 78
		location key (15382518 INODE_ITEM 0) type FILE
		transid 22518 data_len 0 name_len 48
		name: thumb1024_144_20170209_Sapporo_Snow_Festival.jpg
	item 137 key (14354867 DIR_ITEM 729690560) itemoff 6420 itemsize 67
		location key (14375605 INODE_ITEM 0) type FILE
		transid 22299 data_len 0 name_len 37
		name: thumb1024_4114_Thu_Penguin_Dinner.jpg
	item 138 key (14354867 DIR_ITEM 729891652) itemoff 6341 itemsize 79
		location key (16747032 INODE_ITEM 0) type FILE
		transid 30141 data_len 0 name_len 49
		name: thumb1024_161_20180106_Tignes_Val_Disere_Day1.jpg
	item 139 key (14354867 DIR_ITEM 730070272) itemoff 6276 itemsize 65
		location key (16884158 INODE_ITEM 0) type FILE
		transid 30467 data_len 0 name_len 35
		name: thumb1024_118_20180117_Lausanne.jpg
	item 140 key (14354867 DIR_ITEM 730123776) itemoff 6198 itemsize 78
		location key (14366570 INODE_ITEM 0) type FILE
		transid 22294 data_len 0 name_len 48
		name: thumb1024_140_20120629_Glenwood_Springs_Day2.jpg
	item 141 key (14354867 DIR_ITEM 730385272) itemoff 6141 itemsize 57
		location key (15324008 INODE_ITEM 0) type FILE
		transid 22507 data_len 0 name_len 27
		name: thumb1024_623_BRC_After.jpg
	item 142 key (14354867 DIR_ITEM 730586073) itemoff 6069 itemsize 72
		location key (25937109 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 42
		name: thumb1024_112_DiveB-1_Oslob_Whaleshark.jpg
	item 143 key (14354867 DIR_ITEM 730655025) itemoff 5998 itemsize 71
		location key (14360632 INODE_ITEM 0) type FILE
		transid 22291 data_len 0 name_len 41
		name: 2_Marativa_Island-100_Marativa_Island.jpg
	item 144 key (14354867 DIR_ITEM 731081108) itemoff 5929 itemsize 69
		location key (14370078 INODE_ITEM 0) type FILE
		transid 22295 data_len 0 name_len 39
		name: thumb1024_2139_NaturalHistoryMuseum.jpg
	item 145 key (14354867 DIR_ITEM 731116607) itemoff 5857 itemsize 72
		location key (15024560 INODE_ITEM 0) type FILE
		transid 22427 data_len 0 name_len 42
		name: thumb1024_131_20160420_Day01_Singapore.jpg
	item 146 key (14354867 DIR_ITEM 731261277) itemoff 5777 itemsize 80
		location key (15080260 INODE_ITEM 0) type FILE
		transid 22471 data_len 0 name_len 50
		name: thumb1024_166_20160723_Day12_Okayama_Hiroshima.jpg
	item 147 key (14354867 DIR_ITEM 731272028) itemoff 5702 itemsize 75
		location key (14371298 INODE_ITEM 0) type FILE
		transid 22296 data_len 0 name_len 45
		name: thumb1024_243_20141110_Day17_Wulai_Sanxia.jpg
	item 148 key (14354867 DIR_ITEM 731674484) itemoff 5636 itemsize 66
		location key (15951111 INODE_ITEM 0) type FILE
		transid 27634 data_len 0 name_len 36
		name: thumb1024_836_20171105_Hong_Kong.jpg
	item 149 key (14354867 DIR_ITEM 731720973) itemoff 5559 itemsize 77
		location key (15003569 INODE_ITEM 0) type FILE
		transid 22421 data_len 0 name_len 47
		name: thumb1024_238_20160120_Whistler_Heli_Skiing.jpg
	item 150 key (14354867 DIR_ITEM 731839840) itemoff 5494 itemsize 65
		location key (14377852 INODE_ITEM 0) type FILE
		transid 22300 data_len 0 name_len 35
		name: thumb1024_565_Glide_Down_Grouse.jpg
	item 151 key (14354867 DIR_ITEM 731977726) itemoff 5402 itemsize 92
		location key (14364355 INODE_ITEM 0) type FILE
		transid 22293 data_len 0 name_len 62
		name: thumb1024_117_20110812_ComputerHistoryMuseum_Dad_Genevieve.jpg
	item 152 key (14354867 DIR_ITEM 731982080) itemoff 5330 itemsize 72
		location key (15401745 INODE_ITEM 0) type FILE
--
		location key (25937099 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 46
		name: thumb1024_111_20180529_Presidential_Museum.jpg
	item 47 key (14354867 DIR_INDEX 33609) itemoff 12751 itemsize 67
		location key (25937100 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 37
		name: thumb1024_111_20180612_Cebu_Bohol.jpg
	item 48 key (14354867 DIR_INDEX 33611) itemoff 12680 itemsize 71
		location key (25937101 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 41
		name: thumb1024_111_Dive1-3_Wallstreet_West.jpg
	item 49 key (14354867 DIR_INDEX 33613) itemoff 12615 itemsize 65
		location key (25937102 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 35
		name: thumb1024_111_Dive7-1N_Thalatta.jpg
	item 50 key (14354867 DIR_INDEX 33615) itemoff 12549 itemsize 66
		location key (25937103 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 36
		name: thumb1024_111_DiveC-1_Lighthouse.jpg
	item 51 key (14354867 DIR_INDEX 33617) itemoff 12475 itemsize 74
		location key (25937104 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 44
		name: thumb1024_1126_20180518_EDC_Vegas_People.jpg
	item 52 key (14354867 DIR_INDEX 33619) itemoff 12401 itemsize 74
		location key (25937105 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 44
		name: thumb1024_1127_20180518_EDC_Vegas_People.jpg
	item 53 key (14354867 DIR_INDEX 33621) itemoff 12338 itemsize 63
		location key (25937106 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 33
		name: thumb1024_112_20180525_Manila.jpg
	item 54 key (14354867 DIR_INDEX 33623) itemoff 12271 itemsize 67
		location key (25937107 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 37
		name: thumb1024_112_20180612_Cebu_Bohol.jpg
	item 55 key (14354867 DIR_INDEX 33625) itemoff 12205 itemsize 66
		location key (25937108 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 36
		name: thumb1024_112_Dive3-3_Black_Rock.jpg
	item 56 key (14354867 DIR_INDEX 33627) itemoff 12133 itemsize 72
		location key (25937109 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 42
		name: thumb1024_112_DiveB-1_Oslob_Whaleshark.jpg
	item 57 key (14354867 DIR_INDEX 33629) itemoff 12059 itemsize 74
		location key (25937110 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 44
		name: thumb1024_1130_20180518_EDC_Vegas_People.jpg
	item 58 key (14354867 DIR_INDEX 33631) itemoff 11985 itemsize 74
		location key (25937111 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 44
		name: thumb1024_1134_20180518_EDC_Vegas_People.jpg
	item 59 key (14354867 DIR_INDEX 33633) itemoff 11911 itemsize 74
		location key (25937112 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 44
		name: thumb1024_1135_20180518_EDC_Vegas_People.jpg
	item 60 key (14354867 DIR_INDEX 33635) itemoff 11837 itemsize 74
		location key (25937113 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 44
		name: thumb1024_1136_20180518_EDC_Vegas_People.jpg
	item 61 key (14354867 DIR_INDEX 33637) itemoff 11775 itemsize 62
		location key (25937114 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 32
		name: thumb1024_113_20180519_Vegas.jpg
	item 62 key (14354867 DIR_INDEX 33639) itemoff 11712 itemsize 63
		location key (25937115 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 33
		name: thumb1024_113_20180524_Manila.jpg
	item 63 key (14354867 DIR_INDEX 33641) itemoff 11649 itemsize 63
		location key (25937116 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 33
		name: thumb1024_113_20180525_Manila.jpg
	item 64 key (14354867 DIR_INDEX 33643) itemoff 11574 itemsize 75
		location key (25937117 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 45
		name: thumb1024_113_20180525_Manila_Mind_Museum.jpg
	item 65 key (14354867 DIR_INDEX 33645) itemoff 11505 itemsize 69
		location key (25937118 INODE_ITEM 0) type FILE
		transid 137680 data_len 0 name_len 39
		name: thumb1024_113_20180528_Taal_Volcano.jpg
	item 66 key (14354867 DIR_INDEX 33647) itemoff 11418 itemsize 87
		location key (25937119 INODE_ITEM 0) type FILE
--
	item 22 key (25937106 EXTENT_DATA 0) itemoff 14343 itemsize 53
		generation 137680 type 1 (regular)
		extent data disk byte 42296578048 nr 163840
		extent data offset 0 nr 163840 ram 163840
		extent compression 0 (none)
	item 23 key (25937107 INODE_ITEM 0) itemoff 14183 itemsize 160
		generation 137680 transid 137680 size 217631 nbytes 221184
		block group 0 mode 100644 links 1 uid 500 gid 500 rdev 0
		sequence 976 flags 0x0(none)
		atime 1529023119.0 (2018-06-14 17:38:39)
		ctime 1529023119.806610768 (2018-06-14 17:38:39)
		mtime 1528945892.0 (2018-06-13 20:11:32)
		otime 1529023119.802610815 (2018-06-14 17:38:39)
	item 24 key (25937107 INODE_REF 14354867) itemoff 14136 itemsize 47
		index 33623 namelen 37 name: thumb1024_112_20180612_Cebu_Bohol.jpg
	item 25 key (25937107 EXTENT_DATA 0) itemoff 14083 itemsize 53
		generation 137680 type 1 (regular)
		extent data disk byte 42297749504 nr 221184
		extent data offset 0 nr 221184 ram 221184
		extent compression 0 (none)
	item 26 key (25937108 INODE_ITEM 0) itemoff 13923 itemsize 160
		generation 137680 transid 137680 size 202071 nbytes 204800
		block group 0 mode 100644 links 1 uid 500 gid 500 rdev 0
		sequence 371 flags 0x8(NOCOMPRESS)
		atime 1529023149.0 (2018-06-14 17:39:09)
		ctime 1529023158.154151505 (2018-06-14 17:39:18)
		mtime 1528885173.0 (2018-06-13 03:19:33)
		otime 1529023119.806610768 (2018-06-14 17:38:39)
	item 27 key (25937108 INODE_REF 14354867) itemoff 13877 itemsize 46
		index 33625 namelen 36 name: thumb1024_112_Dive3-3_Black_Rock.jpg
	item 28 key (25937108 EXTENT_DATA 0) itemoff 13824 itemsize 53
		generation 137680 type 1 (regular)
		extent data disk byte 1286512640 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0 (none)
	item 29 key (25937108 EXTENT_DATA 4096) itemoff 13771 itemsize 53
		generation 137680 type 1 (regular)
		extent data disk byte 42297970688 nr 200704
		extent data offset 0 nr 200704 ram 200704
		extent compression 0 (none)
	item 30 key (25937109 INODE_ITEM 0) itemoff 13611 itemsize 160
		generation 137680 transid 137680 size 85312 nbytes 85953
		block group 0 mode 100644 links 1 uid 500 gid 500 rdev 0
		sequence 253 flags 0x0(none)
		atime 1529023177.0 (2018-06-14 17:39:37)
		ctime 1529023181.625870411 (2018-06-14 17:39:41)
		mtime 1528885147.0 (2018-06-13 03:19:07)
		otime 1529023159.138139719 (2018-06-14 17:39:19)
	item 31 key (25937109 INODE_REF 14354867) itemoff 13559 itemsize 52
		index 33627 namelen 42 name: thumb1024_112_DiveB-1_Oslob_Whaleshark.jpg
	item 32 key (25937109 EXTENT_DATA 0) itemoff 11563 itemsize 1996
		generation 137680 type 0 (inline)
		inline extent data size 1975 ram_bytes 4033 compression 2 (lzo)
	item 33 key (25937109 EXTENT_DATA 4033) itemoff 11510 itemsize 53
		generation 143349 type 1 (regular)
		extent data disk byte 0 nr 0
		extent data offset 0 nr 63 ram 63
		extent compression 0 (none)
	item 34 key (25937109 EXTENT_DATA 4096) itemoff 11457 itemsize 53
		generation 137680 type 1 (regular)
		extent data disk byte 1286516736 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0 (none)
	item 35 key (25937109 EXTENT_DATA 8192) itemoff 11404 itemsize 53
		generation 137680 type 1 (regular)
		extent data disk byte 1286520832 nr 8192
		extent data offset 0 nr 12288 ram 12288
		extent compression 2 (lzo)
	item 36 key (25937109 EXTENT_DATA 20480) itemoff 11351 itemsize 53
		generation 137680 type 1 (regular)
		extent data disk byte 4199424000 nr 65536
		extent data offset 0 nr 65536 ram 65536
		extent compression 0 (none)
	item 37 key (25937110 INODE_ITEM 0) itemoff 11191 itemsize 160
		generation 137680 transid 137680 size 135515 nbytes 139264
		block group 0 mode 100644 links 1 uid 500 gid 500 rdev 0
		sequence 145 flags 0x0(none)
		atime 1529023187.0 (2018-06-14 17:39:47)
		ctime 1529023190.13769960 (2018-06-14 17:39:50)
		mtime 1527198648.0 (2018-05-24 14:50:48)
		otime 1529023182.589858866 (2018-06-14 17:39:42)
	item 38 key (25937110 INODE_REF 14354867) itemoff 11137 itemsize 54
		index 33629 namelen 44 name: thumb1024_1130_20180518_EDC_Vegas_People.jpg
	item 39 key (25937110 EXTENT_DATA 0) itemoff 11084 itemsize 53
		generation 137680 type 1 (regular)
		extent data disk byte 34841370624 nr 139264
		extent data offset 0 nr 139264 ram 139264
		extent compression 0 (none)
	item 40 key (25937111 INODE_ITEM 0) itemoff 10924 itemsize 160
		generation 137680 transid 137680 size 151659 nbytes 155648
		block group 0 mode 100644 links 1 uid 500 gid 500 rdev 0
		sequence 479 flags 0x0(none)
		atime 1529023192.0 (2018-06-14 17:39:52)
		ctime 1529023194.61721484 (2018-06-14 17:39:54)
		mtime 1527198649.0 (2018-05-24 14:50:49)
		otime 1529023190.625762632 (2018-06-14 17:39:50)
	item 41 key (25937111 INODE_REF 14354867) itemoff 10870 itemsize 54
		index 33631 namelen 44 name: thumb1024_1134_20180518_EDC_Vegas_People.jpg
	item 42 key (25937111 EXTENT_DATA 0) itemoff 10817 itemsize 53
		generation 137680 type 1 (regular)
		extent data disk byte 37451919360 nr 155648
		extent data offset 0 nr 155648 ram 155648
		extent compression 0 (none)
	item 43 key (25937112 INODE_ITEM 0) itemoff 10657 itemsize 160
		generation 137680 transid 137680 size 81989 nbytes 81920
		block group 0 mode 100644 links 1 uid 500 gid 500 rdev 0
		sequence 265 flags 0x8(NOCOMPRESS)
		atime 1529023198.0 (2018-06-14 17:39:58)
		ctime 1529023198.929663188 (2018-06-14 17:39:58)

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
