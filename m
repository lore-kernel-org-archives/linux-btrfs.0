Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36444 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbcAFBbi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 20:31:38 -0500
Received: by mail-wm0-f53.google.com with SMTP id l65so43193307wmf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 17:31:37 -0800 (PST)
Date: Wed, 6 Jan 2016 01:31:34 +0000
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Crash, boot mount failure: "corrupt leaf, slot offset bad"
Message-ID: <20160106013134.GA13956@localhost>
References: <20160104170553.GA4975@localhost>
 <568B2304.8090205@cn.fujitsu.com>
 <CAP-bSRYB4mH1TK9uQnHQaMazxOnMcmCYkhF9xXmrVHPbveZLQQ@mail.gmail.com>
 <568C6678.8020803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <568C6678.8020803@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 06, 2016 at 08:57:28AM +0800, Qu Wenruo wrote:
> 
> Since you took the image of the corrupted fs, would you please try the
> following commands on the corrupted fs?
> 
> $ btrfs-debug-tree -b 67239936 <dumped image>

Command runs then segfaults:

leaf 67239936 items 92 free space 9138 generation 276688 owner 2
fs uuid b1103526-98a3-4b40-a782-cf66721ed600
chunk uuid 16e767e3-a321-4d0f-9c72-6ebac9d305c4
	item 0 key (61513990144 EXTENT_ITEM 16384) itemoff 16232 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (61617864704 EXTENT_ITEM 16384) level 0
		tree block backref root 2
	item 1 key (61514006528 EXTENT_ITEM 16384) itemoff 16181 itemsize 51
		extent refs 1 gen 276285 flags TREE_BLOCK
		tree block key (27627 DIR_INDEX 3576) level 0
		tree block backref root 260
	item 2 key (61514022912 EXTENT_ITEM 16384) itemoff 16130 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 99424354304) level 0
		tree block backref root 7
	item 3 key (61514039296 EXTENT_ITEM 16384) itemoff 16079 itemsize 51
		extent refs 1 gen 275904 flags TREE_BLOCK
		tree block key (1555518 INODE_ITEM 0) level 0
		tree block backref root 260
	item 4 key (61514055680 EXTENT_ITEM 16384) itemoff 16028 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (61702111232 EXTENT_ITEM 16384) level 0
		tree block backref root 2
	item 5 key (61514088448 EXTENT_ITEM 16384) itemoff 15977 itemsize 51
		extent refs 1 gen 276285 flags TREE_BLOCK
		tree block key (1906872 INODE_REF 34185) level 0
		tree block backref root 260
	item 6 key (61514104832 EXTENT_ITEM 16384) itemoff 15926 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (61741957120 EXTENT_ITEM 16384) level 0
		tree block backref root 2
	item 7 key (61514121216 EXTENT_ITEM 16384) itemoff 15875 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 99654656000) level 0
		tree block backref root 7
	item 8 key (61514137600 EXTENT_ITEM 16384) itemoff 15824 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 99620417536) level 0
		tree block backref root 7
	item 9 key (61514153984 EXTENT_ITEM 16384) itemoff 15773 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 99669962752) level 0
		tree block backref root 7
	item 10 key (61514170368 EXTENT_ITEM 16384) itemoff 15722 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 99639615488) level 0
		tree block backref root 7
	item 11 key (61514186752 EXTENT_ITEM 16384) itemoff 15671 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 99681320960) level 0
		tree block backref root 7
	item 12 key (61514203136 EXTENT_ITEM 16384) itemoff 15620 itemsize 51
		extent refs 1 gen 276285 flags TREE_BLOCK
		tree block key (882130 INODE_ITEM 0) level 0
		tree block backref root 260
	item 13 key (61514219520 EXTENT_ITEM 16384) itemoff 15569 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (61831168000 EXTENT_ITEM 16384) level 0
		tree block backref root 2
	item 14 key (61514268672 EXTENT_ITEM 16384) itemoff 15518 itemsize 51
		extent refs 1 gen 275904 flags TREE_BLOCK
		tree block key (1553336 INODE_ITEM 0) level 0
		tree block backref root 260
	item 15 key (61514285056 EXTENT_ITEM 16384) itemoff 15467 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (62053400576 EXTENT_ITEM 16384) level 0
		tree block backref root 2
	item 16 key (61514334208 EXTENT_ITEM 16384) itemoff 15416 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 99928444928) level 0
		tree block backref root 7
	item 17 key (61514350592 EXTENT_ITEM 16384) itemoff 15365 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 99940794368) level 0
		tree block backref root 7
	item 18 key (61514366976 EXTENT_ITEM 16384) itemoff 15314 itemsize 51
		extent refs 1 gen 274438 flags TREE_BLOCK
		tree block key (1532894 EXTENT_DATA 0) level 1
		tree block backref root 3098
	item 19 key (61514383360 EXTENT_ITEM 16384) itemoff 15263 itemsize 51
		extent refs 1 gen 258313 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 121949413376) level 0
		tree block backref root 7
	item 20 key (61514399744 EXTENT_ITEM 16384) itemoff 15212 itemsize 51
		extent refs 1 gen 274438 flags TREE_BLOCK
		tree block key (1535799 INODE_ITEM 0) level 0
		tree block backref root 3098
	item 21 key (61514416128 EXTENT_ITEM 16384) itemoff 15161 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (62136385536 EXTENT_ITEM 16384) level 0
		tree block backref root 2
	item 22 key (61514432512 EXTENT_ITEM 16384) itemoff 15110 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (62174904320 EXTENT_ITEM 16384) level 0
		tree block backref root 2
	item 23 key (61514448896 EXTENT_ITEM 16384) itemoff 15059 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 99996536832) level 0
		tree block backref root 7
	item 24 key (61514465280 EXTENT_ITEM 16384) itemoff 15008 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100002021376) level 0
		tree block backref root 7
	item 25 key (61514481664 EXTENT_ITEM 16384) itemoff 14957 itemsize 51
		extent refs 1 gen 276285 flags TREE_BLOCK
		tree block key (115779 DIR_ITEM 305173055) level 0
		tree block backref root 260
	item 26 key (61514498048 EXTENT_ITEM 16384) itemoff 14906 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (63221645312 EXTENT_ITEM 28672) level 0
		tree block backref root 2
	item 27 key (61514547200 EXTENT_ITEM 16384) itemoff 14855 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100013899776) level 0
		tree block backref root 7
	item 28 key (61514579968 EXTENT_ITEM 16384) itemoff 14804 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100037701632) level 0
		tree block backref root 7
	item 29 key (61514596352 EXTENT_ITEM 16384) itemoff 14753 itemsize 51
		extent refs 1 gen 276285 flags TREE_BLOCK
		tree block key (1902695 INODE_ITEM 0) level 0
		tree block backref root 260
	item 30 key (61514629120 EXTENT_ITEM 16384) itemoff 14702 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (65896304640 EXTENT_ITEM 16384) level 0
		tree block backref root 2
	item 31 key (61514645504 EXTENT_ITEM 16384) itemoff 14651 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100167794688) level 0
		tree block backref root 7
	item 32 key (61514661888 EXTENT_ITEM 16384) itemoff 14600 itemsize 51
		extent refs 1 gen 276285 flags TREE_BLOCK
		tree block key (884400 INODE_ITEM 0) level 0
		tree block backref root 260
	item 33 key (61514678272 EXTENT_ITEM 16384) itemoff 14549 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (65969061888 EXTENT_ITEM 20480) level 0
		tree block backref root 2
	item 34 key (61514694656 EXTENT_ITEM 16384) itemoff 14498 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (65975934976 EXTENT_ITEM 8192) level 0
		tree block backref root 2
	item 35 key (61514711040 EXTENT_ITEM 16384) itemoff 14447 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100226453504) level 0
		tree block backref root 7
	item 36 key (61514727424 EXTENT_ITEM 16384) itemoff 14396 itemsize 51
		extent refs 1 gen 276285 flags TREE_BLOCK
		tree block key (27641 DIR_INDEX 3636) level 0
		tree block backref root 260
	item 37 key (61514743808 EXTENT_ITEM 16384) itemoff 14345 itemsize 51
		extent refs 1 gen 276285 flags TREE_BLOCK
		tree block key (115779 DIR_INDEX 13840) level 0
		tree block backref root 260
	item 38 key (61514760192 EXTENT_ITEM 16384) itemoff 14294 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100303273984) level 0
		tree block backref root 7
	item 39 key (61514776576 EXTENT_ITEM 16384) itemoff 14243 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100324823040) level 0
		tree block backref root 7
	item 40 key (61514792960 EXTENT_ITEM 16384) itemoff 14192 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100288327680) level 0
		tree block backref root 7
	item 41 key (61514809344 EXTENT_ITEM 16384) itemoff 14141 itemsize 51
		extent refs 1 gen 276285 flags TREE_BLOCK
		tree block key (115778 DIR_INDEX 15836) level 0
		tree block backref root 260
	item 42 key (61514825728 EXTENT_ITEM 16384) itemoff 14072 itemsize 69
		extent refs 3 gen 270120 flags TREE_BLOCK|FULL_BACKREF
		tree block key (1468220 INODE_ITEM 0) level 0
		shared block backref parent 61683843072
		shared block backref parent 743489536
		shared block backref parent 121651200
	item 43 key (61514842112 EXTENT_ITEM 16384) itemoff 13994 itemsize 78
		extent refs 4 gen 270120 flags TREE_BLOCK
		tree block key (1468243 EXTENT_DATA 53248) level 0
		tree block backref root 257
		shared block backref parent 61683843072
		shared block backref parent 743489536
		shared block backref parent 121651200
	item 44 key (61514858496 EXTENT_ITEM 16384) itemoff 13943 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100277510144) level 0
		tree block backref root 7
	item 45 key (61514874880 EXTENT_ITEM 16384) itemoff 13892 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (66766774272 EXTENT_ITEM 4096) level 0
		tree block backref root 2
	item 46 key (61514891264 EXTENT_ITEM 16384) itemoff 13841 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (66770665472 EXTENT_ITEM 4096) level 0
		tree block backref root 2
	item 47 key (61514907648 EXTENT_ITEM 16384) itemoff 13790 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (66785505280 EXTENT_ITEM 4096) level 0
		tree block backref root 2
	item 48 key (61514924032 EXTENT_ITEM 16384) itemoff 13739 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100388798464) level 0
		tree block backref root 7
	item 49 key (61514940416 EXTENT_ITEM 16384) itemoff 13688 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100400062464) level 0
		tree block backref root 7
	item 50 key (61514956800 EXTENT_ITEM 16384) itemoff 13637 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (66799345664 EXTENT_ITEM 16384) level 0
		tree block backref root 2
	item 51 key (61514973184 EXTENT_ITEM 16384) itemoff 13586 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100672151552) level 0
		tree block backref root 7
	item 52 key (61514989568 EXTENT_ITEM 16384) itemoff 13535 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (66819731456 EXTENT_ITEM 4096) level 0
		tree block backref root 2
	item 53 key (61515005952 EXTENT_ITEM 16384) itemoff 13484 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (67328659456 EXTENT_ITEM 4096) level 0
		tree block backref root 2
	item 54 key (61515022336 EXTENT_ITEM 16384) itemoff 13433 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (68718272512 EXTENT_ITEM 135168) level 0
		tree block backref root 2
	item 55 key (61515038720 EXTENT_ITEM 16384) itemoff 13382 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100768583680) level 0
		tree block backref root 7
	item 56 key (61515055104 EXTENT_ITEM 16384) itemoff 13331 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100871962624) level 0
		tree block backref root 7
	item 57 key (61515071488 EXTENT_ITEM 16384) itemoff 13262 itemsize 69
		extent refs 3 gen 270120 flags TREE_BLOCK|FULL_BACKREF
		tree block key (1461920 INODE_ITEM 0) level 0
		shared block backref parent 61683843072
		shared block backref parent 743489536
		shared block backref parent 121651200
	item 58 key (61515087872 EXTENT_ITEM 16384) itemoff 13193 itemsize 69
		extent refs 3 gen 270120 flags TREE_BLOCK|FULL_BACKREF
		tree block key (1327416 INODE_ITEM 0) level 0
		shared block backref parent 62029692928
		shared block backref parent 1062486016
		shared block backref parent 699891712
	item 59 key (61515120640 EXTENT_ITEM 16384) itemoff 13115 itemsize 78
		extent refs 4 gen 262494 flags TREE_BLOCK
		tree block key (1419842 INODE_ITEM 0) level 0
		tree block backref root 257
		shared block backref parent 61683843072
		shared block backref parent 730775552
		shared block backref parent 121651200
	item 60 key (61515137024 EXTENT_ITEM 16384) itemoff 13037 itemsize 78
		extent refs 4 gen 270120 flags TREE_BLOCK
		tree block key (1192152 INODE_REF 7310) level 0
		tree block backref root 257
		shared block backref parent 61548216320
		shared block backref parent 1087340544
		shared block backref parent 748519424
	item 61 key (61515153408 EXTENT_ITEM 16384) itemoff 12986 itemsize 51
		extent refs 1 gen 276285 flags TREE_BLOCK
		tree block key (35908 DIR_ITEM 1968783234) level 0
		tree block backref root 260
	item 62 key (61515169792 EXTENT_ITEM 16384) itemoff 12935 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (70525399040 EXTENT_ITEM 8192) level 0
		tree block backref root 2
	item 63 key (61515186176 EXTENT_ITEM 16384) itemoff 12884 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100904398848) level 0
		tree block backref root 7
	item 64 key (61515202560 EXTENT_ITEM 16384) itemoff 12815 itemsize 69
		extent refs 3 gen 270120 flags TREE_BLOCK|FULL_BACKREF
		tree block key (1057465 INODE_ITEM 0) level 0
		shared block backref parent 61506486272
		shared block backref parent 970948608
		shared block backref parent 768196608
	item 65 key (61515218944 EXTENT_ITEM 16384) itemoff 12764 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (70638366720 EXTENT_ITEM 40960) level 0
		tree block backref root 2
	item 66 key (61515235328 EXTENT_ITEM 16384) itemoff 12713 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (70894116864 EXTENT_ITEM 12288) level 0
		tree block backref root 2
	item 67 key (61515251712 EXTENT_ITEM 16384) itemoff 12662 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100967411712) level 0
		tree block backref root 7
	item 68 key (61515268096 EXTENT_ITEM 16384) itemoff 12611 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (70952181760 EXTENT_ITEM 40960) level 0
		tree block backref root 2
	item 69 key (61515284480 EXTENT_ITEM 16384) itemoff 12560 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 100994502656) level 0
		tree block backref root 7
	item 70 key (61515317248 EXTENT_ITEM 16384) itemoff 12509 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 101000675328) level 0
		tree block backref root 7
	item 71 key (61515333632 EXTENT_ITEM 16384) itemoff 12458 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 101020729344) level 0
		tree block backref root 7
	item 72 key (61515350016 EXTENT_ITEM 16384) itemoff 12407 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (74755063808 EXTENT_ITEM 8192) level 0
		tree block backref root 2
	item 73 key (61515382784 EXTENT_ITEM 16384) itemoff 12356 itemsize 51
		extent refs 1 gen 276285 flags TREE_BLOCK
		tree block key (1953118 INODE_REF 19532) level 0
		tree block backref root 260
	item 74 key (61515399168 EXTENT_ITEM 16384) itemoff 12305 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 101086830592) level 0
		tree block backref root 7
	item 75 key (61515415552 EXTENT_ITEM 16384) itemoff 12254 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (75363184640 EXTENT_ITEM 4096) level 0
		tree block backref root 2
	item 76 key (61515431936 EXTENT_ITEM 16384) itemoff 12203 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 101246300160) level 0
		tree block backref root 7
	item 77 key (61515448320 EXTENT_ITEM 16384) itemoff 12152 itemsize 51
		extent refs 1 gen 266026 flags TREE_BLOCK
		tree block key (EXTENT_CSUM EXTENT_CSUM 101663543296) level 0
		tree block backref root 7
	item 78 key (61515464704 EXTENT_ITEM 16384) itemoff 12101 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (75372187648 EXTENT_ITEM 1097728) level 0
		tree block backref root 2
	item 79 key (61515481088 EXTENT_ITEM 16384) itemoff 12050 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (75427885056 EXTENT_ITEM 20480) level 0
		tree block backref root 2
	item 80 key (61515497472 EXTENT_ITEM 16384) itemoff 11999 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (75457257472 EXTENT_ITEM 8192) level 0
		tree block backref root 2
	item 81 key (61515513856 EXTENT_ITEM 16384) itemoff 11948 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (76215603200 EXTENT_ITEM 4096) level 0
		tree block backref root 2
	item 82 key (61515530240 EXTENT_ITEM 16384) itemoff 11897 itemsize 51
		extent refs 1 gen 276685 flags TREE_BLOCK
		tree block key (76529934336 EXTENT_ITEM 12288) level 0
		tree block backref root 2
	item 83 key (61515546624 EXTENT_ITEM 16384) itemoff 5451334 itemsize 262144

Program received signal SIGSEGV, Segmentation fault.
0x000000000041b5c9 in btrfs_extent_flags (s=0x532eab, eb=0x672c30) at ctree.h:1511
1511	BTRFS_SETGET_FUNCS(extent_flags, struct btrfs_extent_item, flags, 64);
(gdb) bt
#0  0x000000000041b5c9 in btrfs_extent_flags (s=0x532eab, eb=0x672c30) at ctree.h:1511
#1  print_extent_item (eb=eb@entry=0x672c30, slot=slot@entry=83, metadata=metadata@entry=0) at print-tree.c:374
#2  0x000000000041c1cd in btrfs_print_leaf (root=root@entry=0x6699a0, l=l@entry=0x672c30) at print-tree.c:903
#3  0x000000000041c75b in btrfs_print_tree (root=root@entry=0x6699a0, eb=eb@entry=0x672c30, follow=follow@entry=0) at print-tree.c:1065
#4  0x00000000004355d2 in main (ac=<optimised out>, av=<optimised out>) at btrfs-debug-tree.c:232

> And, what the kernel mount option for the fs before crash?

Nothing unusual, just defaults and noatime
mount shows: rw,noatime,ssd,noacl,space_cache
