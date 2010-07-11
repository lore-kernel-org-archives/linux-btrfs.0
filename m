From: Yee-Ting Li <yee379@gmail.com>
Subject: Re: volume broken? btrfsck fails
Date: Sun, 11 Jul 2010 01:19:34 -0700
Message-ID: <BC6F2F1C-B57E-4FCB-9B25-ACD9C35858C2@gmail.com>
References: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
To: The development of BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

so after leaving the array for a while, with the disk churning away for a few days, it stopped. i copied some files off the disk (everything seems okay) and decided to unmount and run btrfsck again - this time i get a different error:

$ sudo /usr/local/bin/btrfsck /dev/sdf
failed to read /dev/sr0
parent transid verify failed on 2703919247360 wanted 9066 found 7543
parent transid verify failed on 2703914500096 wanted 9066 found 7543
parent transid verify failed on 2703873781760 wanted 9074 found 9022
parent transid verify failed on 2703877693440 wanted 9070 found 9062
parent transid verify failed on 2703921868800 wanted 9066 found 7543
parent transid verify failed on 2703922647040 wanted 9066 found 7543
parent transid verify failed on 2703919247360 wanted 9066 found 7543
parent transid verify failed on 2703919255552 wanted 9066 found 7543
parent transid verify failed on 2703917125632 wanted 9066 found 7543
parent transid verify failed on 2703879294976 wanted 9075 found 9055
parent transid verify failed on 2703883194368 wanted 9075 found 9057
parent transid verify failed on 2703922688000 wanted 9066 found 7543
parent transid verify failed on 2703873781760 wanted 9074 found 9022
parent transid verify failed on 2703877693440 wanted 9070 found 9062
parent transid verify failed on 2703921868800 wanted 9066 found 7543
parent transid verify failed on 2703922647040 wanted 9066 found 7543
parent transid verify failed on 2703919247360 wanted 9066 found 7543
parent transid verify failed on 2703919255552 wanted 9066 found 7543
bad block 2703873781760
Extent back ref already exists for 365342720 parent 0 root 2 
Extent back ref already exists for 2221870616576 parent 0 root 2 
Extent back ref already exists for 383959040 parent 0 root 2 
Extent back ref already exists for 367714304 parent 0 root 2 
Extent back ref already exists for 706744320 parent 0 root 2 
Extent back ref already exists for 368672768 parent 0 root 2 
Extent back ref already exists for 315338752 parent 0 root 2 
Extent back ref already exists for 377356288 parent 0 root 2 
Extent back ref already exists for 368914432 parent 0 root 2 
Extent back ref already exists for 369807360 parent 0 root 2 
Extent back ref already exists for 2221957713920 parent 0 root 2 
Extent back ref already exists for 370139136 parent 0 root 2 
Extent back ref already exists for 369811456 parent 0 root 2 
Extent back ref already exists for 370122752 parent 0 root 2 
Extent back ref already exists for 365936640 parent 0 root 2 
Extent back ref already exists for 2221948424192 parent 0 root 2 
Extent back ref already exists for 3624002596864 parent 0 root 2 
Extent back ref already exists for 706789376 parent 0 root 2 
Extent back ref already exists for 2703778734080 parent 0 root 2 
Extent back ref already exists for 372252672 parent 0 root 2 
Extent back ref already exists for 372109312 parent 0 root 2 
Extent back ref already exists for 372989952 parent 0 root 2 
Extent back ref already exists for 373657600 parent 0 root 2 
Extent back ref already exists for 374521856 parent 0 root 2 
Extent back ref already exists for 374628352 parent 0 root 2 
Extent back ref already exists for 374976512 parent 0 root 2 
Extent back ref already exists for 2221948403712 parent 0 root 2 
Extent back ref already exists for 375586816 parent 0 root 2 
Extent back ref already exists for 375906304 parent 0 root 2 
Extent back ref already exists for 376639488 parent 0 root 2 
Extent back ref already exists for 706818048 parent 0 root 2 
Extent back ref already exists for 383778816 parent 0 root 2 
Extent back ref already exists for 377626624 parent 0 root 2 
leaf parent key incorrect 2703874203648
bad block 2703874203648
leaf 2222080487424 items 37 free space 1183 generation 10279 owner 2
fs uuid ea7ea0b3-bc42-4b0c-9173-346df61d4454
chunk uuid 886b0dfb-fa34-49c7-9ab0-2589603f8ae4
	item 0 key (364388352 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200172044288) level 0
		tree block backref root 7
	item 1 key (364392448 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200220258304) level 0
		tree block backref root 7
	item 2 key (364396544 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200179384320) level 0
		tree block backref root 7
	item 3 key (364400640 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200220258304) level 0
		tree block backref root 7
	item 4 key (364404736 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200184492032) level 0
		tree block backref root 7
	item 5 key (364408832 EXTENT_ITEM 4096) itemoff 3689 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200183775232) level 0
		tree block backref root 7
	item 6 key (364412928 EXTENT_ITEM 4096) itemoff 3638 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200192163840) level 0
		tree block backref root 7
	item 7 key (364417024 EXTENT_ITEM 4096) itemoff 3587 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200189181952) level 0
		tree block backref root 7
	item 8 key (364421120 EXTENT_ITEM 4096) itemoff 3536 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200220258304) level 0
		tree block backref root 7
	item 9 key (364425216 EXTENT_ITEM 4096) itemoff 3485 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200198520832) level 0
		tree block backref root 7
	item 10 key (364429312 EXTENT_ITEM 4096) itemoff 3434 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200201732096) level 0
		tree block backref root 7
	item 11 key (364433408 EXTENT_ITEM 4096) itemoff 3383 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200208547840) level 0
		tree block backref root 7
	item 12 key (364437504 EXTENT_ITEM 4096) itemoff 3332 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200215756800) level 0
		tree block backref root 7
	item 13 key (364441600 EXTENT_ITEM 4096) itemoff 3281 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200219885568) level 0
		tree block backref root 7
	item 14 key (364445696 EXTENT_ITEM 4096) itemoff 3230 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200213725184) level 0
		tree block backref root 7
	item 15 key (364449792 EXTENT_ITEM 4096) itemoff 3179 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200208547840) level 0
		tree block backref root 7
	item 16 key (364453888 EXTENT_ITEM 4096) itemoff 3128 itemsize 51
		extent refs 1 gen 8461 flags 2
		tree block key (104423 1 0) level 0
		tree block backref root 5
	item 17 key (364462080 EXTENT_ITEM 4096) itemoff 3077 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200657076224) level 0
		tree block backref root 7
	item 18 key (364466176 EXTENT_ITEM 4096) itemoff 3026 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200663105536) level 0
		tree block backref root 7
	item 19 key (364470272 EXTENT_ITEM 4096) itemoff 2975 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200674902016) level 0
		tree block backref root 7
	item 20 key (364474368 EXTENT_ITEM 4096) itemoff 2924 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200666513408) level 0
		tree block backref root 7
	item 21 key (364478464 EXTENT_ITEM 4096) itemoff 2873 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200687484928) level 0
		tree block backref root 7
	item 22 key (364482560 EXTENT_ITEM 4096) itemoff 2822 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200670707712) level 0
		tree block backref root 7
	item 23 key (364486656 EXTENT_ITEM 4096) itemoff 2771 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200699871232) level 0
		tree block backref root 7
	item 24 key (364490752 EXTENT_ITEM 4096) itemoff 2720 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200674902016) level 0
		tree block backref root 7
	item 25 key (364494848 EXTENT_ITEM 4096) itemoff 2669 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200683290624) level 0
		tree block backref root 7
	item 26 key (364498944 EXTENT_ITEM 4096) itemoff 2618 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200708128768) level 0
		tree block backref root 7
	item 27 key (364503040 EXTENT_ITEM 4096) itemoff 2567 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200699871232) level 0
		tree block backref root 7
	item 28 key (364507136 EXTENT_ITEM 4096) itemoff 2516 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200720515072) level 0
		tree block backref root 7
	item 29 key (364511232 EXTENT_ITEM 4096) itemoff 2465 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200704000000) level 0
		tree block backref root 7
	item 30 key (364515328 EXTENT_ITEM 4096) itemoff 2414 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200712257536) level 0
		tree block backref root 7
	item 31 key (364519424 EXTENT_ITEM 4096) itemoff 2363 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200724643840) level 0
		tree block backref root 7
	item 32 key (364523520 EXTENT_ITEM 4096) itemoff 2312 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200666513408) level 0
		tree block backref root 7
	item 33 key (364527616 EXTENT_ITEM 4096) itemoff 2261 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200669659136) level 0
		tree block backref root 7
	item 34 key (364531712 EXTENT_ITEM 4096) itemoff 2210 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200670707712) level 0
		tree block backref root 7
	item 35 key (364535808 EXTENT_ITEM 4096) itemoff 2159 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200691613696) level 0
		tree block backref root 7
	item 36 key (364539904 EXTENT_ITEM 4096) itemoff 2108 itemsize 51
		extent refs 1 gen 1061 flags 2
		tree block key (18446744073709551606 80 200682242048) level 0
		tree block backref root 7
failed to find block number 364457984
Aborted


any ideas?