Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35669 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751349AbdHaSpB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 14:45:01 -0400
Received: by mail-qk0-f176.google.com with SMTP id p67so2216327qkd.2
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 11:45:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170831183302.GB30990@carfax.org.uk>
References: <CAJ_hD5By15sSvur7849XWQ8jkBoGj0cO5vQfY8MguVDCneMX8Q@mail.gmail.com>
 <20170831183302.GB30990@carfax.org.uk>
From: Eric Wolf <19wolf@gmail.com>
Date: Thu, 31 Aug 2017 14:44:39 -0400
Message-ID: <CAJ_hD5D49amQEq7YMu=d-EhRK-CkJerbT=uAc1+rpg+_12KFsQ@mail.gmail.com>
Subject: Re: BTRFS critical (device sda2): corrupt leaf, bad key order:
 block=293438636032, root=1, slot=11
To: Hugo Mills <hugo@carfax.org.uk>, Eric Wolf <19wolf@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

leaf 293438636032 items 153 free space 2820 generation 5389981 owner 267

fs uuid b2c9ff7b-[snip]-48a02cc4f508

chunk uuid e60d16b9-ca53-45b3-a47a-e0a146046894

item 0 key (890550 INODE_REF 31762) itemoff 16260 itemsize 23

inode ref index 2727 namelen 13 name: dpkg.status.0

item 1 key (890550 EXTENT_DATA 0) itemoff 16207 itemsize 53

extent data disk byte 243952738304 nr 864256

extent data offset 0 nr 864256 ram 864256

extent compression 0

item 2 key (890551 INODE_ITEM 0) itemoff 16047 itemsize 160

inode generation 5386763 transid 5386764 size 209058 nbytes 212992

block group 0 mode 100644 links 1 uid 100000 gid 100000

rdev 0 flags 0x0

item 3 key (890551 INODE_REF 31762) itemoff 16021 itemsize 26

inode ref index 2726 namelen 16 name: dpkg.status.1.gz

item 4 key (890551 EXTENT_DATA 0) itemoff 15968 itemsize 53

extent data disk byte 243376005120 nr 212992

extent data offset 0 nr 212992 ram 212992

extent compression 0

item 5 key (890552 INODE_ITEM 0) itemoff 15808 itemsize 160

inode generation 5386763 transid 5386764 size 616 nbytes 616

block group 0 mode 100644 links 1 uid 100000 gid 100000

rdev 0 flags 0x0

item 6 key (890552 INODE_REF 31762) itemoff 15781 itemsize 27

inode ref index 2736 namelen 17 name: dpkg.diversions.0

item 7 key (890552 EXTENT_DATA 0) itemoff 15144 itemsize 637

inline extent data size 616 ram 616 compress 0

item 8 key (890553 INODE_ITEM 0) itemoff 14984 itemsize 160

inode generation 5386763 transid 5386764 size 248 nbytes 248

block group 0 mode 100644 links 1 uid 100000 gid 100000

rdev 0 flags 0x0

item 9 key (890553 INODE_REF 31762) itemoff 14954 itemsize 30

inode ref index 2735 namelen 20 name: dpkg.diversions.1.gz

item 10 key (890553 EXTENT_DATA 0) itemoff 14685 itemsize 269

inline extent data size 248 ram 248 compress 0

item 11 key (890554 INODE_ITEM 0) itemoff 14525 itemsize 160

inode generation 5386763 transid 5386764 size 135 nbytes 135

block group 0 mode 100644 links 1 uid 100000 gid 100000

rdev 0 flags 0x0

item 12 key (856762 INODE_REF 31762) itemoff 14496 itemsize 29

inode ref index 2745 namelen 19 name: dpkg.statoverride.0

item 13 key (890554 EXTENT_DATA 0) itemoff 14340 itemsize 156

inline extent data size 135 ram 135 compress 0

item 14 key (890555 INODE_ITEM 0) itemoff 14180 itemsize 160

inode generation 5386763 transid 5386764 size 129 nbytes 129

block group 0 mode 100644 links 1 uid 100000 gid 100000

rdev 0 flags 0x0

item 15 key (890555 INODE_REF 31762) itemoff 14148 itemsize 32

inode ref index 2744 namelen 22 name: dpkg.statoverride.1.gz

item 16 key (890555 EXTENT_DATA 0) itemoff 13998 itemsize 150

inline extent data size 129 ram 129 compress 0

item 17 key (890557 INODE_ITEM 0) itemoff 13838 itemsize 160

inode generation 5386763 transid 5386763 size 787062 nbytes 790528

block group 0 mode 100640 links 1 uid 100104 gid 100004

rdev 0 flags 0x0

item 18 key (890557 INODE_REF 29289) itemoff 13817 itemsize 21

inode ref index 1372 namelen 11 name: syslog.2.gz

item 19 key (890557 EXTENT_DATA 0) itemoff 13764 itemsize 53

extent data disk byte 243948204032 nr 790528

extent data offset 0 nr 790528 ram 790528

extent compression 0

item 20 key (890558 INODE_ITEM 0) itemoff 13604 itemsize 160

inode generation 5386763 transid 5389981 size 4047291 nbytes 4050944

block group 0 mode 100640 links 1 uid 100104 gid 100004

rdev 0 flags 0x0

item 21 key (890558 INODE_REF 29289) itemoff 13588 itemsize 16

inode ref index 1374 namelen 6 name: syslog

item 22 key (890558 EXTENT_DATA 0) itemoff 13535 itemsize 53

extent data disk byte 240840228864 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 23 key (890558 EXTENT_DATA 8192) itemoff 13482 itemsize 53

extent data disk byte 240837672960 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 24 key (890558 EXTENT_DATA 12288) itemoff 13429 itemsize 20

extent data disk byte 240820076544 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 25 key (890558 EXTENT_DATA 16384) itemoff 13376 itemsize 53

extent data disk byte 240784408576 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 26 key (890558 EXTENT_DATA 20480) itemoff 13323 itemsize 53

extent data disk byte 240785170432 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 27 key (890558 EXTENT_DATA 24576) itemoff 13270 itemsize 53

extent data disk byte 242839834624 nr 36864

extent data offset 0 nr 32768 ram 36864

extent compression 0

item 28 key (890558 EXTENT_DATA 57344) itemoff 13217 itemsize 53

extent data disk byte 242836987904 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 29 key (890558 EXTENT_DATA 61440) itemoff 13164 itemsize 53

extent data disk byte 243400761344 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 30 key (890558 EXTENT_DATA 65536) itemoff 13111 itemsize 53

extent data disk byte 243412983808 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 31 key (890558 EXTENT_DATA 69632) itemoff 13058 itemsize 53

extent data disk byte 243380326400 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 32 key (890558 EXTENT_DATA 73728) itemoff 13005 itemsize 53

extent data disk byte 243412807680 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 33 key (890558 EXTENT_DATA 77824) itemoff 12952 itemsize 53

extent data disk byte 243375525888 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 34 key (890558 EXTENT_DATA 81920) itemoff 12899 itemsize 53

extent data disk byte 322139365376 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 35 key (890558 EXTENT_DATA 86016) itemoff 12846 itemsize 53

extent data disk byte 322304024576 nr 36864

extent data offset 0 nr 32768 ram 36864

extent compression 0

item 36 key (890558 EXTENT_DATA 118784) itemoff 12793 itemsize 53

extent data disk byte 322257489920 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 37 key (890558 EXTENT_DATA 126976) itemoff 12740 itemsize 53

extent data disk byte 322257702912 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 38 key (890558 EXTENT_DATA 131072) itemoff 12687 itemsize 53

extent data disk byte 322257780736 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 39 key (890558 EXTENT_DATA 135168) itemoff 12634 itemsize 53

extent data disk byte 322257821696 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 40 key (890558 EXTENT_DATA 139264) itemoff 12581 itemsize 53

extent data disk byte 322257883136 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 41 key (890558 EXTENT_DATA 143360) itemoff 12528 itemsize 53

extent data disk byte 322261303296 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 42 key (890558 EXTENT_DATA 151552) itemoff 12475 itemsize 53

extent data disk byte 322270244864 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 43 key (890558 EXTENT_DATA 155648) itemoff 12422 itemsize 53

extent data disk byte 322277580800 nr 28672

extent data offset 0 nr 24576 ram 28672

extent compression 0

item 44 key (890558 EXTENT_DATA 180224) itemoff 12369 itemsize 53

extent data disk byte 322280173568 nr 20480

extent data offset 0 nr 16384 ram 20480

extent compression 0

item 45 key (890558 UNKNOWN.4 8585216) itemoff 12316 itemsize 53

item 46 key (890558 EXTENT_DATA 200704) itemoff 12263 itemsize 53

extent data disk byte 322257473536 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 47 key (890558 EXTENT_DATA 204800) itemoff 12210 itemsize 53

extent data disk byte 322257534976 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 48 key (890558 EXTENT_DATA 208896) itemoff 12157 itemsize 53

extent data disk byte 322257657856 nr 28672

extent data offset 0 nr 24576 ram 28672

extent compression 0

item 49 key (890558 EXTENT_DATA 233472) itemoff 12104 itemsize 53

extent data disk byte 322268020736 nr 143360

extent data offset 0 nr 139264 ram 143360

extent compression 0

item 50 key (890558 EXTENT_DATA 372736) itemoff 12051 itemsize 53

extent data disk byte 322260267008 nr 69632

extent data offset 0 nr 65536 ram 69632

extent compression 0

item 51 key (890558 EXTENT_DATA 438272) itemoff 11998 itemsize 53

extent data disk byte 322257743872 nr 24576

extent data offset 0 nr 20480 ram 24576

extent compression 0

item 52 key (890558 EXTENT_DATA 458752) itemoff 11945 itemsize 53

extent data disk byte 322257575936 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 53 key (890524 EXTENT_DATA 462848) itemoff 11892 itemsize 53

extent data disk byte 322258919424 nr 36864

extent data offset 0 nr 32768 ram 36864

extent compression 0

item 54 key (890558 EXTENT_DATA 495616) itemoff 11839 itemsize 53

extent data disk byte 322257625088 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 55 key (890558 EXTENT_DATA 499712) itemoff 11786 itemsize 53

extent data disk byte 322257694720 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 56 key (890558 EXTENT_DATA 503808) itemoff 11733 itemsize 53

extent data disk byte 322257768448 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 57 key (890558 EXTENT_DATA 507904) itemoff 11680 itemsize 53

extent data disk byte 322257788928 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 58 key (890558 EXTENT_DATA 512000) itemoff 11627 itemsize 53

extent data disk byte 322257797120 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 59 key (890558 EXTENT_DATA 516096) itemoff 11574 itemsize 53

extent data disk byte 322257596416 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 60 key (890558 EXTENT_DATA 520192) itemoff 11521 itemsize 53

extent data disk byte 322257805312 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 61 key (890558 EXTENT_DATA 524288) itemoff 11468 itemsize 53

extent data disk byte 322257813504 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 62 key (890558 EXTENT_DATA 528384) itemoff 11415 itemsize 53

extent data disk byte 322257833984 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 63 key (890558 EXTENT_DATA 532480) itemoff 11362 itemsize 53

extent data disk byte 322257842176 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 64 key (890558 EXTENT_DATA 536576) itemoff 11309 itemsize 53

extent data disk byte 322257891328 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 65 key (890558 EXTENT_DATA 540672) itemoff 11256 itemsize 53

extent data disk byte 322257899520 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 66 key (890558 EXTENT_DATA 544768) itemoff 11203 itemsize 53

extent data disk byte 322257907712 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 67 key (890558 EXTENT_DATA 548864) itemoff 11150 itemsize 53

extent data disk byte 322258141184 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 68 key (890558 EXTENT_DATA 557056) itemoff 11097 itemsize 53

extent data disk byte 322258956288 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 69 key (890558 EXTENT_DATA 561152) itemoff 11044 itemsize 53

extent data disk byte 322259525632 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 70 key (890558 EXTENT_DATA 565248) itemoff 10991 itemsize 53

extent data disk byte 322259533824 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 71 key (890558 EXTENT_DATA 569344) itemoff 10938 itemsize 53

extent data disk byte 322259542016 nr 20480

extent data offset 0 nr 16384 ram 20480

extent compression 0

item 72 key (890558 EXTENT_DATA 585728) itemoff 10885 itemsize 53

extent data disk byte 322259705856 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 73 key (890558 EXTENT_DATA 593920) itemoff 10832 itemsize 53

extent data disk byte 322259718144 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 74 key (890558 EXTENT_DATA 598016) itemoff 10779 itemsize 53

extent data disk byte 322259726336 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 75 key (890558 EXTENT_DATA 606208) itemoff 10726 itemsize 53

extent data disk byte 322257502208 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 76 key (890558 EXTENT_DATA 610304) itemoff 10673 itemsize 53

extent data disk byte 322257481728 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 77 key (890558 EXTENT_DATA 614400) itemoff 10620 itemsize 53

extent data disk byte 322257645568 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 78 key (890558 EXTENT_DATA 618496) itemoff 10567 itemsize 53

extent data disk byte 322257711104 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 79 key (890558 EXTENT_DATA 622592) itemoff 10514 itemsize 53

extent data disk byte 322257719296 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 80 key (890558 EXTENT_DATA 626688) itemoff 10461 itemsize 53

extent data disk byte 322257850368 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 81 key (890558 EXTENT_DATA 630784) itemoff 10408 itemsize 53

extent data disk byte 322257858560 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 82 key (890558 EXTENT_DATA 634880) itemoff 10355 itemsize 53

extent data disk byte 322257960960 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 83 key (890558 EXTENT_DATA 638976) itemoff 62 itemsize 53

inline extent data size 32 ram 32 compress 0

item 84 key (890558 EXTENT_DATA 643072) itemoff 10249 itemsize 53

extent data disk byte 322259746816 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 85 key (890558 EXTENT_DATA 647168) itemoff 10196 itemsize 53

extent data disk byte 322259755008 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 86 key (890558 EXTENT_DATA 651264) itemoff 10143 itemsize 53

extent data disk byte 322260045824 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 87 key (890558 EXTENT_DATA 655360) itemoff 10090 itemsize 53

extent data disk byte 322260094976 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 88 key (890558 EXTENT_DATA 659456) itemoff 10037 itemsize 5

extent data disk byte 322260103168 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 89 key (890558 EXTENT_DATA 663552) itemoff 9984 itemsize 53

extent data disk byte 322260111360 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 90 key (890558 EXTENT_DATA 667648) itemoff 9931 itemsize 53

extent data disk byte 322260389888 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 91 key (890558 EXTENT_DATA 671744) itemoff 9878 itemsize 53

extent data disk byte 322260606976 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 92 key (890558 EXTENT_DATA 675840) itemoff 9825 itemsize 53

extent data disk byte 322260615168 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 93 key (890558 EXTENT_DATA 679936) itemoff 9772 itemsize 53

extent data disk byte 322260635648 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 94 key (890558 EXTENT_DATA 684032) itemoff 9719 itemsize 53

extent data disk byte 322260643840 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 95 key (890558 EXTENT_DATA 688128) itemoff 9666 itemsize 53

extent data disk byte 322260881408 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 96 key (890558 EXTENT_DATA 692224) itemoff 9613 itemsize 53

extent data disk byte 322260889600 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 97 key (890558 EXTENT_DATA 696320) itemoff 9560 itemsize 53

extent data disk byte 322260897792 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 98 key (890558 EXTENT_DATA 700416) itemoff 9507 itemsize 53

extent data disk byte 322260905984 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 99 key (890558 EXTENT_DATA 704512) itemoff 9454 itemsize 53

extent data disk byte 322261118976 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 100 key (890558 EXTENT_DATA 708608) itemoff 9401 itemsize 53

extent data disk byte 322261155840 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 101 key (890558 EXTENT_DATA 712704) itemoff 9348 itemsize 53

extent data disk byte 322261164032 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 102 key (890558 EXTENT_DATA 716800) itemoff 9295 itemsize 53

extent data disk byte 322261172224 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 103 key (890558 EXTENT_DATA 720896) itemoff 9242 itemsize 53

extent data disk byte 322261180416 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 104 key (890558 EXTENT_DATA 724992) itemoff 9189 itemsize 53

extent data disk byte 322261200896 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 105 key (890558 EXTENT_DATA 729088) itemoff 9136 itemsize 53

extent data disk byte 322261413888 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 106 key (890558 EXTENT_DATA 733184) itemoff 9083 itemsize 53

extent data disk byte 373953429504 nr 40960

extent data offset 0 nr 36864 ram 40960

extent compression 0

item 107 key (890558 EXTENT_DATA 770048) itemoff 9030 itemsize 53

extent data disk byte 244316987392 nr 36864

extent data offset 0 nr 32768 ram 36864

extent compression 0

item 108 key (890558 EXTENT_DATA 802816) itemoff 8977 itemsize 53

extent data disk byte 402186268672 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 109 key (890558 UNKNOWN.36 806912) itemoff 8924 itemsize 53

item 110 key (890558 EXTENT_DATA 811008) itemoff 8871 itemsize 53

extent data disk byte 403036618752 nr 16384

extent data offset 0 nr 12288 ram 16384

extent compression 0

item 111 key (890558 EXTENT_DATA 823296) itemoff 8818 itemsize 53

extent data disk byte 403046576128 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 112 key (890558 EXTENT_DATA 827392) itemoff 8765 itemsize 53

extent data disk byte 403055026176 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 113 key (890558 EXTENT_DATA 831488) itemoff 8712 itemsize 53

extent data disk byte 403080712192 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 114 key (890558 EXTENT_DATA 835584) itemoff 8659 itemsize 53

extent data disk byte 403161362432 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 115 key (890558 EXTENT_DATA 839680) itemoff 8606 itemsize 53

extent data disk byte 402228609024 nr 20480

extent data offset 0 nr 16384 ram 20480

extent compression 0

item 116 key (890558 EXTENT_DATA 856064) itemoff 8553 itemsize 53

extent data disk byte 402229116928 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 117 key (890390 EXTENT_DATA 864256) itemoff 8500 itemsize 53

extent data disk byte 402229321728 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 118 key (890558 EXTENT_DATA 872448) itemoff 8447 itemsize 53

extent data disk byte 402229764096 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 119 key (890558 EXTENT_DATA 876544) itemoff 8394 itemsize 53

extent data disk byte 402238205952 nr 20480

extent data offset 0 nr 16384 ram 20480

extent compression 0

item 120 key (890558 EXTENT_DATA 892928) itemoff 8341 itemsize 53

extent data disk byte 402242666496 nr 16384

extent data offset 0 nr 12288 ram 16384

extent compression 0

item 121 key (890558 EXTENT_DATA 905216) itemoff 8288 itemsize 53

extent data disk byte 402246287360 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 122 key (890558 EXTENT_DATA 909312) itemoff 8235 itemsize 53

extent data disk byte 402248134656 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 123 key (890558 EXTENT_DATA 913408) itemoff 8182 itemsize 53

extent data disk byte 402249940992 nr 20480

extent data offset 0 nr 16384 ram 20480

extent compression 0

item 124 key (890558 EXTENT_DATA 929792) itemoff 8000 itemsize 53

inline extent data size 32 ram 0 compress 32

item 125 key (890558 EXTENT_DATA 937984) itemoff 8076 itemsize 53

extent data disk byte 402262298624 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 126 key (890558 EXTENT_DATA 942080) itemoff 8023 itemsize 53

extent data disk byte 402263646208 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 127 key (890558 EXTENT_DATA 946176) itemoff 7970 itemsize 53

extent data disk byte 402264412160 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 128 key (890558 EXTENT_DATA 954368) itemoff 7917 itemsize 53

extent data disk byte 402266554368 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 129 key (890558 EXTENT_DATA 958464) itemoff 7864 itemsize 53

extent data disk byte 402268008448 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 130 key (890558 EXTENT_DATA 962560) itemoff 7811 itemsize 53

extent data disk byte 402270887936 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 131 key (890558 EXTENT_DATA 966656) itemoff 7758 itemsize 53

extent data disk byte 402271469568 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 132 key (890558 EXTENT_DATA 970752) itemoff 7705 itemsize 53

extent data disk byte 402273902592 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 133 key (890558 EXTENT_DATA 978944) itemoff 7652 itemsize 53

extent data disk byte 402279186432 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 134 key (890558 EXTENT_DATA 987136) itemoff 7599 itemsize 53

extent data disk byte 402300633088 nr 28672

extent data offset 0 nr 24576 ram 28672

extent compression 0

item 135 key (890558 EXTENT_DATA 1011712) itemoff 7546 itemsize 53

extent data disk byte 402302214144 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 136 key (890558 EXTENT_DATA 1015808) itemoff 7493 itemsize 53

extent data disk byte 402304045056 nr 8192

extent data offset 0 nr 8192 ram 8192

extent compression 0

item 137 key (890558 EXTENT_DATA 1024000) itemoff 7440 itemsize 53

extent data disk byte 402306953216 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 138 key (890558 EXTENT_DATA 1028096) itemoff 7387 itemsize 53

extent data disk byte 402308796416 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 139 key (890558 EXTENT_DATA 1036288) itemoff 7334 itemsize 53

extent data disk byte 402310840320 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 140 key (857278 EXTENT_DATA 1044480) itemoff 7281 itemsize 53

extent data disk byte 402313179136 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 141 key (890558 EXTENT_DATA 1048576) itemoff 7228 itemsize 53

extent data disk byte 402658066432 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 142 key (890558 EXTENT_DATA 1056768) itemoff 7175 itemsize 53

extent data disk byte 402697449472 nr 16384

extent data offset 0 nr 12288 ram 16384

extent compression 0

item 143 key (890558 EXTENT_DATA 1069056) itemoff 7122 itemsize 53

extent data disk byte 402701127680 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 144 key (890558 EXTENT_DATA 1077248) itemoff 7069 itemsize 53

extent data disk byte 402703929344 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 145 key (890558 EXTENT_DATA 1081344) itemoff 7016 itemsize 53

extent data disk byte 402704723968 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 146 key (890558 EXTENT_DATA 1089536) itemoff 6963 itemsize 53

extent data disk byte 402707312640 nr 12288

extent data offset 0 nr 8192 ram 12288

extent compression 0

item 147 key (890558 EXTENT_DATA 1097728) itemoff 6910 itemsize 53

extent data disk byte 402708541440 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 148 key (890558 EXTENT_DATA 1101824) itemoff 6857 itemsize 53

extent data disk byte 402713112576 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 149 key (890558 EXTENT_DATA 1105920) itemoff 6804 itemsize 53

extent data disk byte 402714587136 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 150 key (890558 EXTENT_DATA 1110016) itemoff 6751 itemsize 53

extent data disk byte 402716921856 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 151 key (890558 EXTENT_DATA 1114112) itemoff 6698 itemsize 53

extent data disk byte 402717990912 nr 8192

extent data offset 0 nr 4096 ram 8192

extent compression 0

item 152 key (890558 EXTENT_DATA 1118208) itemoff 6645 itemsize 53

extent data disk byte 402721890304 nr 20480

extent data offset 0 nr 16384 ram 20480

extent compression 0
---
Eric Wolf
(201) 316-6098
19wolf@gmail.com


On Thu, Aug 31, 2017 at 2:33 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Aug 31, 2017 at 01:53:58PM -0400, Eric Wolf wrote:
>> I'm having issues with a bad block(?) on my root ssd.
>>
>> dmesg is consistently outputting "BTRFS critical (device sda2):
>> corrupt leaf, bad key order: block=293438636032, root=1, slot=11"
>>
>> "btrfs scrub stat /" outputs "scrub status for b2c9ff7b-[snip]-48a02cc4f508
>> scrub started at Wed Aug 30 11:51:49 2017 and finished after 00:02:55
>> total bytes scrubbed: 53.41GiB with 2 errors
>> error details: verify=2
>> corrected errors: 0, uncorrectable errors: 2, unverified errors: 0"
>>
>> Running "btrfs check --repair /dev/sda2" from a live system stalls
>> after telling me corrupt leaf etc etc then "11 12". CPU usage hits
>> 100% and disk activity remains at 0.
>
>    This error is usually attributable to bad hardware. Typically RAM,
> but might also be marginal power regulation (blown capacitor
> somewhere) or a slightly broken CPU.
>
>    Can you show us the output of "btrfs-debug-tree -b 293438636032 /dev/sda2"?
>
>    Hugo.
>
> --
> Hugo Mills             | "You got very nice eyes, Deedee. Never noticed them
> hugo@... carfax.org.uk | before. They real?"
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                                 Don Logan, Sexy Beast
