From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
Date: Sun, 11 Jul 2010 14:28:09 +0200
Message-ID: <201007111428.10005.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

It's getting worse. The /home partition is now affected too. I get the Oops on 
simple unmounting the fs. btrfsck gives me this output on this fs:

btrfsck /dev/mapper/sdb3 
leaf 123780497408 items 49 free space 271 generation 62207 owner 2
fs uuid 7f013285-88d8-452f-a139-7d44bffd14b6
chunk uuid 365526c9-e209-46a1-8963-3157306d9e05
        item 0 key (123780108288 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
                extent refs 1 gen 45309 flags 2
                tree block key (836797 6c 0) level 1
                tree block backref root 5
        item 1 key (123780112384 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
                extent refs 1 gen 45309 flags 2
                tree block key (836955 c 416051) level 0
                tree block backref root 5
        item 2 key (123780116480 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
                extent refs 1 gen 24599 flags 2
                tree block key (18446744073709551606 80 122869407744) level 0
                tree block backref root 7
        item 3 key (123780120576 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
                extent refs 1 gen 49958 flags 2
                tree block key (979249 1 0) level 0
                tree block backref root 5
        item 4 key (123780124672 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
                extent refs 1 gen 62191 flags 2
                tree block key (1220 1 0) level 0
                tree block backref root 5
        item 5 key (123780128768 EXTENT_ITEM 4096) itemoff 3689 itemsize 51
                extent refs 1 gen 54817 flags 2
                tree block key (1001168 c 455590) level 0
                tree block backref root 5
        item 6 key (123780132864 EXTENT_ITEM 4096) itemoff 3638 itemsize 51
                extent refs 1 gen 62201 flags 2
                tree block key (28712 1 0) level 1
                tree block backref root 5
        item 7 key (123780136960 EXTENT_ITEM 4096) itemoff 3587 itemsize 51
                extent refs 1 gen 62191 flags 2
                tree block key (34645 c 33037) level 0
                tree block backref root 5
        item 8 key (123780141056 EXTENT_ITEM 4096) itemoff 3536 itemsize 51
                extent refs 1 gen 50007 flags 2
                tree block key (31007 60 4044) level 0
                tree block backref root 5
        item 9 key (123780145152 EXTENT_ITEM 4096) itemoff 3485 itemsize 51
                extent refs 1 gen 62202 flags 2
                tree block key (123644329984 a8 4096) level 0
                tree block backref root 2
        item 10 key (123780149248 EXTENT_ITEM 4096) itemoff 3434 itemsize 51
                extent refs 1 gen 62202 flags 2
                tree block key (123644854272 a8 4096) level 0
                tree block backref root 2
        item 11 key (123780153344 EXTENT_ITEM 4096) itemoff 3383 itemsize 51
                extent refs 1 gen 62202 flags 2
                tree block key (123645849600 a8 4096) level 0
                tree block backref root 2
        item 12 key (123780157440 EXTENT_ITEM 4096) itemoff 3332 itemsize 51
                extent refs 1 gen 62207 flags 2
                tree block key (123411308544 a8 4096) level 2
                tree block backref root 2
        item 13 key (123780161536 EXTENT_ITEM 4096) itemoff 3281 itemsize 51
                extent refs 1 gen 62200 flags 2
                tree block key (1325101 c 1264) level 0
                tree block backref root 5
        item 14 key (123780165632 EXTENT_ITEM 4096) itemoff 3230 itemsize 51
                extent refs 1 gen 56401 flags 2
                tree block key (59621 1 0) level 1
                tree block backref root 5
        item 15 key (123780169728 EXTENT_ITEM 4096) itemoff 3179 itemsize 51
                extent refs 1 gen 24613 flags 2
                tree block key (18446744073709551606 80 125996056576) level 0
                tree block backref root 7
        item 16 key (123780173824 EXTENT_ITEM 4096) itemoff 3128 itemsize 51
                extent refs 1 gen 62189 flags 2
                tree block key (1324334 1 0) level 0
                tree block backref root 5
        item 17 key (123780177920 EXTENT_ITEM 4095) itemoff 3077 itemsize 51
                extent refs 1 gen 62207 flags 2
                tree block key (123682791424 a8 4096) level 1
                tree block backref root 2
        item 18 key (123780182016 EXTENT_ITEM 4096) itemoff 3026 itemsize 51
                extent refs 1 gen 62202 flags 2
                tree block key (123648741376 a8 4096) level 0
                tree block backref root 2
        item 19 key (123780186112 EXTENT_ITEM 4096) itemoff 2975 itemsize 51
                extent refs 1 gen 62201 flags 2
                tree block key (28854 54 1781866506) level 0
                tree block backref root 5
        item 20 key (123780190208 EXTENT_ITEM 4096) itemoff 2924 itemsize 51
                extent refs 1 gen 62192 flags 2
                tree block key (1456 6c 3231744) level 0
                tree block backref root 5
        item 21 key (123780194304 EXTENT_ITEM 4096) itemoff 2873 itemsize 51
                extent refs 1 gen 62189 flags 2
                tree block key (123646390272 a8 4096) level 0
                tree block backref root 2
        item 22 key (123780198400 EXTENT_ITEM 4096) itemoff 2822 itemsize 51
                extent refs 1 gen 58732 flags 2
                tree block key (145006825472 a8 8192) level 0
                tree block backref root 2
        item 23 key (123780202496 EXTENT_ITEM 4096) itemoff 2771 itemsize 51
                extent refs 1 gen 62191 flags 2
                tree block key (123656515584 a8 4096) level 0
                tree block backref root 2
        item 24 key (123780206592 EXTENT_ITEM 4096) itemoff 2720 itemsize 51
                extent refs 1 gen 59061 flags 2
                tree block key (34873 1 0) level 0
                tree block backref root 5
        item 25 key (123780210688 EXTENT_ITEM 4096) itemoff 2669 itemsize 51
                extent refs 1 gen 62207 flags 2
                tree block key (123778146304 a8 4096) level 0
                tree block backref root 2
        item 26 key (123780214784 EXTENT_ITEM 4096) itemoff 2618 itemsize 51
                extent refs 1 gen 62201 flags 2
                tree block key (28848 c 2786) level 0
                tree block backref root 5
        item 27 key (123780218880 EXTENT_ITEM 4096) itemoff 2567 itemsize 51
                extent refs 1 gen 62189 flags 2
                tree block key (123657785344 a8 4096) level 0
                tree block backref root 2
        item 28 key (123780222976 EXTENT_ITEM 4096) itemoff 2516 itemsize 51
                extent refs 1 gen 62201 flags 2
                tree block key (133719777280 a8 4096) level 1
                tree block backref root 2
        item 29 key (123780227072 EXTENT_ITEM 4096) itemoff 2465 itemsize 51
                extent refs 1 gen 62189 flags 2
                tree block key (123659431936 a8 4096) level 0
                tree block backref root 2
        item 30 key (123780231168 EXTENT_ITEM 4096) itemoff 2414 itemsize 51
                extent refs 1 gen 62202 flags 2
                tree block key (123658563584 a8 4096) level 1
                tree block backref root 2
        item 31 key (123780235264 EXTENT_ITEM 4096) itemoff 2363 itemsize 51
                extent refs 1 gen 46988 flags 2
                tree block key (34911 6c 282624) level 0
                tree block backref root 5
        item 32 key (123780239360 EXTENT_ITEM 4096) itemoff 2312 itemsize 51
                extent refs 1 gen 58714 flags 2
                tree block key (63797821440 a8 4096) level 0
                tree block backref root 2
        item 33 key (123780243456 EXTENT_ITEM 4096) itemoff 2261 itemsize 51
                extent refs 1 gen 62201 flags 2
                tree block key (133728186368 a8 4096) level 0
                tree block backref root 2
        item 34 key (123780247552 EXTENT_ITEM 4096) itemoff 2210 itemsize 51
                extent refs 1 gen 56401 flags 2
                tree block key (59654 60 7) level 0
                tree block backref root 5
        item 35 key (123780251648 EXTENT_ITEM 4096) itemoff 2159 itemsize 51
                extent refs 1 gen 62207 flags 2
                tree block key (123778404352 a8 4096) level 0
                tree block backref root 2
        item 36 key (123780255744 EXTENT_ITEM 4096) itemoff 2108 itemsize 51
                extent refs 1 gen 62202 flags 2
                tree block key (123659759616 a8 4096) level 0
                tree block backref root 2
        item 37 key (123780259840 EXTENT_ITEM 4096) itemoff 2057 itemsize 51
                extent refs 1 gen 62204 flags 2
                tree block key (145014075392 a8 12288) level 0
                tree block backref root 2
        item 38 key (123780263936 EXTENT_ITEM 4096) itemoff 2006 itemsize 51
                extent refs 1 gen 62193 flags 2
                tree block key (145016651776 a8 8192) level 0
                tree block backref root 2
        item 39 key (123780268032 EXTENT_ITEM 4096) itemoff 1955 itemsize 51
                extent refs 1 gen 62207 flags 2
                tree block key (123778617344 a8 4096) level 0
                tree block backref root 2
        item 40 key (123780272128 EXTENT_ITEM 4096) itemoff 1904 itemsize 51
                extent refs 1 gen 59985 flags 2
                tree block key (18446744073709551606 80 62746009600) level 0
                tree block backref root 7
        item 41 key (123780276224 EXTENT_ITEM 4096) itemoff 1853 itemsize 51
                extent refs 1 gen 62202 flags 2
                tree block key (123660300288 a8 4096) level 0
                tree block backref root 2
        item 42 key (123780280320 EXTENT_ITEM 4096) itemoff 1802 itemsize 51
                extent refs 1 gen 22901 flags 2
                tree block key (66305400832 a8 4096) level 0
                tree block backref root 2
        item 43 key (123780284416 EXTENT_ITEM 4096) itemoff 1751 itemsize 51
                extent refs 1 gen 62207 flags 2
                tree block key (123778818048 a8 4096) level 0
                tree block backref root 2
        item 44 key (123780288512 EXTENT_ITEM 4096) itemoff 1700 itemsize 51
                extent refs 1 gen 51582 flags 2
                tree block key (455590 54 3842052003) level 0
                tree block backref root 5
        item 45 key (123780292608 EXTENT_ITEM 4096) itemoff 1649 itemsize 51
                extent refs 1 gen 62200 flags 2
                tree block key (1283 54 2984231802) level 0
                tree block backref root 5
        item 46 key (123780296704 EXTENT_ITEM 4096) itemoff 1598 itemsize 51
                extent refs 1 gen 56398 flags 2
                tree block key (54879 c 54735) level 0
                tree block backref root 5
        item 47 key (123780300800 EXTENT_ITEM 4096) itemoff 1547 itemsize 51
                extent refs 1 gen 62201 flags 2
                tree block key (2786 54 1989163538) level 1
                tree block backref root 5
        item 48 key (123780304896 EXTENT_ITEM 4096) itemoff 1496 itemsize 51
                extent refs 1 gen 59040 flags 2
                tree block key (123812081664 a8 4096) level 0
                tree block backref root 2
failed to find block number 123780177920
Aborted

Mounting the fs read-only an reading the content works fine so far.

I've three systems running with btrfs, a dual Opteron (252), a Pentium 4 
system and a netbook with N270 Atom. The netbook is the only one that shows 
the errors. It's also the only system where I'm using gcc-4.5. Perhaps it's 
related, but I doubt it's the only reason as I'm using gcc-4.5 since May.


regards,
  Johannes
