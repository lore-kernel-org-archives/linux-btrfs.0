Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 5.mo3.mail-out.ovh.net ([87.98.178.36]:33185 "EHLO
        5.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeGUHbC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jul 2018 03:31:02 -0400
Received: from player763.ha.ovh.net (unknown [10.109.143.209])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 868881BF0BE
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Jul 2018 08:39:20 +0200 (CEST)
Subject: Re: btrfs filesystem corruptions with 4.18. git kernels
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
 <eed6fd0d-c89e-5f3e-026e-0364b0bffda1@gmx.com>
From: Alexander Wetzel <alexander.wetzel@web.de>
Message-ID: <aa82a6ba-b961-25db-2487-59aa64193257@web.de>
Date: Sat, 21 Jul 2018 08:39:11 +0200
MIME-Version: 1.0
In-Reply-To: <eed6fd0d-c89e-5f3e-026e-0364b0bffda1@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>
>> I'm running my normal workstation with git kernels from
>> git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testing.git
>> and just got the second file system corruption in three weeks. I do not
>> have issues with stable kernels, and just want to give you a heads up
>> that there might be something seriously broken in current development
>> kernels.
>>
>> The first corruption was with a kernel based on 4.18.0-rc1
>> (wt-2018-06-20) and the second one today based on 4.18.0-rc4
>> (wt-2018-07-09).
>> The first corruption definitely destroyed data, the second one has not
>> been looked at all, yet.
>>
>> After the reinstall I did run some scrubs, the last working one one week
>> ago.
>>
>> Of course this could be unrelated to the development kernels or even
>> btrfs, but two corruptions within weeks after years without problems is
>> very suspect.
>> And since btrfs also allowed to read corrupted data (with a stable
>> ubuntu kernel, see below for more details) it looks like this is indeed
>> an issue in btrfs, correct?
> 
> Not in newer kernel anymore.
> 
> Btrfs kernel module will do *restrict* check on tree blocks.
> So anything unexpected (or doesn't follow btrfs on-disk format) will be
> rejected by btrfs module.
> 
> To avoid further corrupting the whole btrfs.

Not sure I can follow that. Shouldn't I get a read error for a file due 
to checksum mismatch if btrfs did not write it out itself?
I could copy the complete git tree without any noticeable errors.
> 
>>
>> A btrfs subvolume is used as the rootfs on a "Samsung SSD 850 EVO mSATA
>> 1TB" and I'm running Gentoo ~amd64 on a Thinkpad W530. Discard is
>> enabled as mount option and there were roughly 5 other subvolumes.
>>
>> I'm currently backing up the full btrfs partition after the second
>> corruption which announced itself with the following log entries:
>>
>> [  979.223767] BTRFS critical (device sdc2): corrupt leaf: root=2
>> block=1029783552 slot=1, unexpected item end, have 16161 expect 16250
> 
> This shows enough info of what's going wrong.
> Items overlaps or has holes in extent tree.
> 
> Please dump the tree block by using the following command:
> 
> # btrfs inspect dump-tree -b 1029783552 /dev/sdc2

# btrfs inspect dump-tree -b 1029783552 /dev/sdc2
btrfs-progs v4.12
leaf 1029783552 items 204 free space 4334 generation 13058 owner 2
leaf 1029783552 flags 0x1(WRITTEN) backref revision 1
fs uuid 4e36fe70-0613-410b-b1a1-6d4923f9cc8f
chunk uuid c55861e9-91f6-413f-85f6-5014d942c2bd 
 

         item 0 key (844283904 METADATA_ITEM 0) itemoff 16250 itemsize 
33 

                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF 
 

                 tree block skinny level 0 
 

                 shared block backref parent 166690816 
 
 
 
 

         item 1 key (844300288 METADATA_ITEM 0) itemoff 16128 itemsize 
33 
 
 
 

                 extent refs 72620543991349248 gen 51228445761339392 
flags |FULL_BACKREF 
 
 
 

                 tree block skinny level 0 
 
 
 
 

         item 2 key (844316672 METADATA_ITEM 0) itemoff 16128 itemsize 
33 
 
 
 

                 extent refs 72620543991349248 gen 51228445761339392 
flags |FULL_BACKREF 
 
 
 

                 tree block skinny level 0 
 
 
 
 

         item 3 key (844333056 METADATA_ITEM 0) itemoff 16151 itemsize 
33 
 
 
 

                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF 
 
 
 
 

                 tree block skinny level 0 
 
 
 
 

                 shared block backref parent 166690816 
 
 
 
 

         item 4 key (844349440 METADATA_ITEM 0) itemoff 16118 itemsize 
33 
 
 
 

                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF 
 
 
 
 

                 tree block skinny level 0 
 
 
 
 

                 shared block backref parent 166690816 
 
 
 
 

         item 5 key (844365824 METADATA_ITEM 0) itemoff 16085 itemsize 
33 
 
 
 

                 extent refs 1 gen 11022 flags TREE_BLOCK 
 
 
 
 

                 tree block skinny level 0
                 tree block backref root 528
         item 6 key (844382208 METADATA_ITEM 0) itemoff 16052 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 7 key (844398592 METADATA_ITEM 0) itemoff 16019 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 8 key (844414976 METADATA_ITEM 0) itemoff 15986 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 9 key (844431360 METADATA_ITEM 0) itemoff 15953 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 10 key (844447744 METADATA_ITEM 0) itemoff 15920 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 11 key (844464128 METADATA_ITEM 0) itemoff 15887 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 12 key (844480512 METADATA_ITEM 0) itemoff 15854 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 13 key (844496896 METADATA_ITEM 0) itemoff 15821 itemsize 33
                 extent refs 1 gen 986 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 19696173056
         item 14 key (844513280 METADATA_ITEM 0) itemoff 15779 itemsize 42
                 extent refs 2 gen 986 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 833306624
         item 15 key (844529664 METADATA_ITEM 0) itemoff 15737 itemsize 42
                 extent refs 2 gen 986 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 833306624
         item 16 key (844546048 METADATA_ITEM 0) itemoff 15704 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 17 key (844562432 METADATA_ITEM 0) itemoff 15662 itemsize 42
                 extent refs 2 gen 986 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 833306624
         item 18 key (844578816 METADATA_ITEM 0) itemoff 15629 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 19 key (844595200 METADATA_ITEM 0) itemoff 15596 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 20 key (844611584 METADATA_ITEM 0) itemoff 15563 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 21 key (844627968 METADATA_ITEM 0) itemoff 15530 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 22 key (844644352 METADATA_ITEM 0) itemoff 15497 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 23 key (844660736 METADATA_ITEM 0) itemoff 15464 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 24 key (844677120 METADATA_ITEM 0) itemoff 15431 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 25 key (844693504 METADATA_ITEM 0) itemoff 15398 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 26 key (844709888 METADATA_ITEM 0) itemoff 15365 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 27 key (844726272 METADATA_ITEM 0) itemoff 15332 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 28 key (844742656 METADATA_ITEM 0) itemoff 15299 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 29 key (844759040 METADATA_ITEM 0) itemoff 15266 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 30 key (844775424 METADATA_ITEM 0) itemoff 15233 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 31 key (844791808 METADATA_ITEM 0) itemoff 15200 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 32 key (844808192 METADATA_ITEM 0) itemoff 15167 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 33 key (844824576 METADATA_ITEM 0) itemoff 15134 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 34 key (844840960 METADATA_ITEM 0) itemoff 15101 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 35 key (844857344 METADATA_ITEM 0) itemoff 15068 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 36 key (844873728 METADATA_ITEM 0) itemoff 15035 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 37 key (844890112 METADATA_ITEM 0) itemoff 15002 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 38 key (844906496 METADATA_ITEM 0) itemoff 14969 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 39 key (844922880 METADATA_ITEM 0) itemoff 14936 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 40 key (844939264 METADATA_ITEM 0) itemoff 14903 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 41 key (844955648 METADATA_ITEM 0) itemoff 14870 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 42 key (844972032 METADATA_ITEM 0) itemoff 14837 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 43 key (844988416 METADATA_ITEM 0) itemoff 14804 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 44 key (845004800 METADATA_ITEM 0) itemoff 14771 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 45 key (845021184 METADATA_ITEM 0) itemoff 14738 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 46 key (845037568 METADATA_ITEM 0) itemoff 14705 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 47 key (845053952 METADATA_ITEM 0) itemoff 14672 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 48 key (845070336 METADATA_ITEM 0) itemoff 14639 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 49 key (845086720 METADATA_ITEM 0) itemoff 14606 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 50 key (845103104 METADATA_ITEM 0) itemoff 14573 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 51 key (845119488 METADATA_ITEM 0) itemoff 14540 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 52 key (845135872 METADATA_ITEM 0) itemoff 14507 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 53 key (845152256 METADATA_ITEM 0) itemoff 14474 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 54 key (845168640 METADATA_ITEM 0) itemoff 14441 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 55 key (845185024 METADATA_ITEM 0) itemoff 14408 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 56 key (845201408 METADATA_ITEM 0) itemoff 14375 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 57 key (845217792 METADATA_ITEM 0) itemoff 14342 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 58 key (845234176 METADATA_ITEM 0) itemoff 14309 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 59 key (845250560 METADATA_ITEM 0) itemoff 14276 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 60 key (845266944 METADATA_ITEM 0) itemoff 14243 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 61 key (845283328 METADATA_ITEM 0) itemoff 14210 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 62 key (845299712 METADATA_ITEM 0) itemoff 14177 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 63 key (845316096 METADATA_ITEM 0) itemoff 14144 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 64 key (845332480 METADATA_ITEM 0) itemoff 14111 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 65 key (845348864 METADATA_ITEM 0) itemoff 14078 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 66 key (845381632 METADATA_ITEM 0) itemoff 14045 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 67 key (845398016 METADATA_ITEM 0) itemoff 14012 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 68 key (845414400 METADATA_ITEM 0) itemoff 13979 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 69 key (845430784 METADATA_ITEM 0) itemoff 13946 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 70 key (845447168 METADATA_ITEM 0) itemoff 13913 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 71 key (845463552 METADATA_ITEM 0) itemoff 13880 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 72 key (845479936 METADATA_ITEM 0) itemoff 13847 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 73 key (845496320 METADATA_ITEM 0) itemoff 13814 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 74 key (845512704 METADATA_ITEM 0) itemoff 13781 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 75 key (845529088 METADATA_ITEM 0) itemoff 13748 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 76 key (845545472 METADATA_ITEM 0) itemoff 13715 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 1063567360
         item 77 key (845561856 METADATA_ITEM 0) itemoff 13682 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 1063567360
         item 78 key (845578240 METADATA_ITEM 0) itemoff 13649 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 79 key (845594624 METADATA_ITEM 0) itemoff 13616 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 80 key (845611008 METADATA_ITEM 0) itemoff 13583 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 81 key (845627392 METADATA_ITEM 0) itemoff 13550 itemsize 33
                 extent refs 1 gen 12190 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
         item 82 key (845643776 METADATA_ITEM 0) itemoff 13517 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 23035904
         item 83 key (845660160 METADATA_ITEM 0) itemoff 13484 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 84 key (845676544 METADATA_ITEM 0) itemoff 13442 itemsize 42
                 extent refs 2 gen 7462 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 19822444544
         item 85 key (845692928 METADATA_ITEM 0) itemoff 13409 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 86 key (845709312 METADATA_ITEM 0) itemoff 13376 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 87 key (845725696 METADATA_ITEM 0) itemoff 13334 itemsize 42
                 extent refs 2 gen 7462 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 584237056
         item 88 key (845742080 METADATA_ITEM 0) itemoff 13301 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 89 key (845758464 METADATA_ITEM 0) itemoff 13268 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 169934848
         item 90 key (845774848 METADATA_ITEM 0) itemoff 13235 itemsize 33
                 extent refs 1 gen 1713 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 7
         item 91 key (845791232 METADATA_ITEM 0) itemoff 13193 itemsize 42
                 extent refs 2 gen 7462 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 19822444544
         item 92 key (845807616 METADATA_ITEM 0) itemoff 13160 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 93 key (845824000 METADATA_ITEM 0) itemoff 13127 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 94 key (845840384 METADATA_ITEM 0) itemoff 13094 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 95 key (845856768 METADATA_ITEM 0) itemoff 13061 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 96 key (845873152 METADATA_ITEM 0) itemoff 13028 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 97 key (845889536 METADATA_ITEM 0) itemoff 12995 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 98 key (845905920 METADATA_ITEM 0) itemoff 12962 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 99 key (845922304 METADATA_ITEM 0) itemoff 12929 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 100 key (845938688 METADATA_ITEM 0) itemoff 12896 itemsize 33
                 extent refs 1 gen 12190 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
         item 101 key (845955072 METADATA_ITEM 0) itemoff 12863 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 102 key (845971456 METADATA_ITEM 0) itemoff 12830 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 103 key (845987840 METADATA_ITEM 0) itemoff 12788 itemsize 42
                 extent refs 2 gen 6575 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 367935488
         item 104 key (846004224 METADATA_ITEM 0) itemoff 12755 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 105 key (846020608 METADATA_ITEM 0) itemoff 12722 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 106 key (846036992 METADATA_ITEM 0) itemoff 12689 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 107 key (846053376 METADATA_ITEM 0) itemoff 12656 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 108 key (846069760 METADATA_ITEM 0) itemoff 12623 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 109 key (846102528 METADATA_ITEM 0) itemoff 12590 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 110 key (846118912 METADATA_ITEM 0) itemoff 12557 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 111 key (846135296 METADATA_ITEM 0) itemoff 12515 itemsize 42
                 extent refs 2 gen 7462 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 19822444544
         item 112 key (846168064 METADATA_ITEM 0) itemoff 12482 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 129335296
         item 113 key (846200832 METADATA_ITEM 0) itemoff 12449 itemsize 33
                 extent refs 1 gen 6575 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 7
         item 114 key (846217216 METADATA_ITEM 0) itemoff 12416 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 115 key (846233600 METADATA_ITEM 0) itemoff 12383 itemsize 33
                 extent refs 1 gen 6575 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 7
         item 116 key (846249984 METADATA_ITEM 0) itemoff 12350 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 117 key (846266368 METADATA_ITEM 0) itemoff 12317 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 118 key (846331904 METADATA_ITEM 0) itemoff 12284 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 19884867584
         item 119 key (846348288 METADATA_ITEM 0) itemoff 12251 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 129335296
         item 120 key (846381056 METADATA_ITEM 0) itemoff 12218 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 121 key (846397440 METADATA_ITEM 0) itemoff 12185 itemsize 33
                 extent refs 1 gen 6575 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
         item 122 key (846413824 METADATA_ITEM 0) itemoff 12152 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 123 key (846430208 METADATA_ITEM 0) itemoff 12119 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 124 key (846446592 METADATA_ITEM 0) itemoff 12086 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 125 key (846462976 METADATA_ITEM 0) itemoff 12053 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 166690816
         item 126 key (846479360 METADATA_ITEM 0) itemoff 12020 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 23035904
         item 127 key (846495744 METADATA_ITEM 0) itemoff 11987 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 128 key (846512128 METADATA_ITEM 0) itemoff 11954 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 129 key (846528512 METADATA_ITEM 0) itemoff 11921 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 130 key (846544896 METADATA_ITEM 0) itemoff 11888 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 169934848
         item 131 key (846561280 METADATA_ITEM 0) itemoff 11855 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 132 key (846577664 METADATA_ITEM 0) itemoff 11822 itemsize 33
                 extent refs 1 gen 1841 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 7
         item 133 key (846594048 METADATA_ITEM 0) itemoff 11789 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 23035904
         item 134 key (846610432 METADATA_ITEM 0) itemoff 11756 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 135 key (846626816 METADATA_ITEM 0) itemoff 11723 itemsize 33
                 extent refs 1 gen 6575 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
         item 136 key (846643200 METADATA_ITEM 0) itemoff 11690 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 129335296
         item 137 key (846659584 METADATA_ITEM 0) itemoff 11657 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 129335296
         item 138 key (846675968 METADATA_ITEM 0) itemoff 11624 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 139 key (846692352 METADATA_ITEM 0) itemoff 11591 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 169984000
         item 140 key (846741504 METADATA_ITEM 0) itemoff 11558 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 19884867584
         item 141 key (846757888 METADATA_ITEM 0) itemoff 11516 itemsize 42
                 extent refs 2 gen 7462 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 584237056
         item 142 key (846774272 METADATA_ITEM 0) itemoff 11483 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 143 key (846807040 METADATA_ITEM 0) itemoff 11450 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 144 key (846823424 METADATA_ITEM 0) itemoff 11417 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 145 key (846839808 METADATA_ITEM 0) itemoff 11384 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 146 key (846856192 METADATA_ITEM 0) itemoff 11351 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 147 key (846872576 METADATA_ITEM 0) itemoff 11318 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 148 key (846888960 METADATA_ITEM 0) itemoff 11285 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 1063567360
         item 149 key (846905344 METADATA_ITEM 0) itemoff 11252 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 150 key (846921728 METADATA_ITEM 0) itemoff 11219 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 168919040
         item 151 key (846938112 METADATA_ITEM 0) itemoff 11186 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 168919040
         item 152 key (846954496 METADATA_ITEM 0) itemoff 11153 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 153 key (846970880 METADATA_ITEM 0) itemoff 11120 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 154 key (846987264 METADATA_ITEM 0) itemoff 11087 itemsize 33
                 extent refs 1 gen 987 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 833306624
         item 155 key (847003648 METADATA_ITEM 0) itemoff 11045 itemsize 42
                 extent refs 2 gen 3435 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 536
                 tree block backref root 257
         item 156 key (847020032 METADATA_ITEM 0) itemoff 11012 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 157 key (847036416 METADATA_ITEM 0) itemoff 10979 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 158 key (847052800 METADATA_ITEM 0) itemoff 10946 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 129335296
         item 159 key (847069184 METADATA_ITEM 0) itemoff 10913 itemsize 33
                 extent refs 1 gen 987 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 833306624
         item 160 key (847085568 METADATA_ITEM 0) itemoff 10880 itemsize 33
                 extent refs 1 gen 987 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 833306624
         item 161 key (847101952 METADATA_ITEM 0) itemoff 10847 itemsize 33
                 extent refs 1 gen 987 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 833306624
         item 162 key (847118336 METADATA_ITEM 0) itemoff 10814 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 163 key (847134720 METADATA_ITEM 0) itemoff 10781 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 164 key (847151104 METADATA_ITEM 0) itemoff 10748 itemsize 33
                 extent refs 1 gen 987 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 833306624
         item 165 key (847183872 METADATA_ITEM 0) itemoff 10715 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 166 key (847200256 METADATA_ITEM 0) itemoff 10682 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 167 key (847216640 METADATA_ITEM 0) itemoff 10649 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 168 key (847249408 METADATA_ITEM 0) itemoff 10616 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 169 key (847282176 METADATA_ITEM 0) itemoff 10583 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 170 key (847298560 METADATA_ITEM 0) itemoff 10550 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 171 key (847364096 METADATA_ITEM 0) itemoff 10508 itemsize 42
                 extent refs 2 gen 7462 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 584237056
         item 172 key (847396864 METADATA_ITEM 0) itemoff 10475 itemsize 33
                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 19768377344
         item 173 key (847413248 METADATA_ITEM 0) itemoff 10442 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 174 key (847446016 METADATA_ITEM 0) itemoff 10409 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 175 key (847462400 METADATA_ITEM 0) itemoff 10376 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 176 key (847478784 METADATA_ITEM 0) itemoff 10334 itemsize 42
                 extent refs 2 gen 7462 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 584237056
         item 177 key (847495168 METADATA_ITEM 0) itemoff 10292 itemsize 42
                 extent refs 2 gen 7462 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 257
                 shared block backref parent 839991296
         item 178 key (847511552 METADATA_ITEM 0) itemoff 10259 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 179 key (847527936 METADATA_ITEM 0) itemoff 10226 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 180 key (847544320 METADATA_ITEM 0) itemoff 10193 itemsize 33
                 extent refs 1 gen 987 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 833306624
         item 181 key (847593472 METADATA_ITEM 0) itemoff 10160 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 182 key (847609856 METADATA_ITEM 0) itemoff 10127 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 183 key (847626240 METADATA_ITEM 0) itemoff 10094 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 184 key (847642624 METADATA_ITEM 0) itemoff 10061 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 185 key (847675392 METADATA_ITEM 0) itemoff 10028 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 186 key (847691776 METADATA_ITEM 0) itemoff 9995 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 187 key (847708160 METADATA_ITEM 0) itemoff 9962 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 188 key (847724544 METADATA_ITEM 0) itemoff 9929 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 189 key (847740928 METADATA_ITEM 0) itemoff 9896 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 190 key (847757312 METADATA_ITEM 0) itemoff 9863 itemsize 33
                 extent refs 1 gen 987 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 833306624
         item 191 key (847790080 METADATA_ITEM 0) itemoff 9830 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 192 key (847806464 METADATA_ITEM 0) itemoff 9797 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 193 key (847822848 METADATA_ITEM 0) itemoff 9764 itemsize 33
                 extent refs 1 gen 987 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 833306624
         item 194 key (847839232 METADATA_ITEM 0) itemoff 9731 itemsize 33
                 extent refs 1 gen 987 flags TREE_BLOCK|FULL_BACKREF
                 tree block skinny level 0
                 shared block backref parent 833306624
         item 195 key (847855616 METADATA_ITEM 0) itemoff 9698 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 196 key (847872000 METADATA_ITEM 0) itemoff 9665 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 197 key (847921152 METADATA_ITEM 0) itemoff 9632 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 198 key (847937536 METADATA_ITEM 0) itemoff 9599 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 199 key (847970304 METADATA_ITEM 0) itemoff 9566 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 200 key (847986688 METADATA_ITEM 0) itemoff 9533 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 201 key (848003072 METADATA_ITEM 0) itemoff 9500 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 202 key (848019456 METADATA_ITEM 0) itemoff 9467 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
         item 203 key (848035840 METADATA_ITEM 0) itemoff 9434 itemsize 33
                 extent refs 1 gen 11022 flags TREE_BLOCK
                 tree block skinny level 0
                 tree block backref root 528
> 
> And please run "btrfs check" on the filesystem to show any other problems.
> (I assume there will be more problem than our expectation)

Compared to the first crash this looks harmless:
btrfs check --repair /dev/sdc2 2>&1 | tee repair
checking extents
incorrect offsets 16250 16161
corrupt extent record: key 844300288 169 16384
corrupt extent record: key 844316672 169 16384
ref mismatch on [844300288 16384] extent item 72620543991349248, found 1
Backref 844300288 parent 166690816 root 166690816 not found in extent tree
backpointer mismatch on [844300288 16384]
repair deleting extent record: key 844300288 169 0
adding new tree backref on start 844300288 len 16384 parent 166690816 
root 166690816
Repaired extent references for 844300288
bad extent [844300288, 844316672), type mismatch with chunk
ref mismatch on [844316672 16384] extent item 72620543991349248, found 1
Backref 844316672 parent 528 root 528 not found in extent tree
backpointer mismatch on [844316672 16384]
repair deleting extent record: key 844316672 169 0
adding new tree backref on start 844316672 len 16384 parent 0 root 528
Repaired extent references for 844316672
bad extent [844316672, 844333056), type mismatch with chunk
Incorrect local backref count on 1325674496 root 534 owner 0 offset 0 
found 0 wanted 1 back 0x557cc1a41cd0
Backref disk bytenr does not match extent record, bytenr=1325674496, ref 
bytenr=208
Backref 1325674496 root 534 owner 979 offset 0 num_refs 0 not found in 
extent tree
Incorrect local backref count on 1325674496 root 534 owner 979 offset 0 
found 1 wanted 0 back 0x557cc3ca1530
backpointer mismatch on [1325674496 4096]
repair deleting extent record: key 1325674496 168 4096
adding new data backref on 1325674496 root 534 owner 979 offset 0 found 1
Repaired extent references for 1325674496
Fixed 0 roots.
checking free space cache
checking fs roots
checking csums
checking root refs
enabling repair mode
Checking filesystem on /dev/sdc2
UUID: 4e36fe70-0613-410b-b1a1-6d4923f9cc8f
Shifting item nr 1 by 89 bytes in block 4341760
Shifting item nr 2 by 56 bytes in block 4341760
cache and super generation don't match, space cache will be invalidated
found 381207048192 bytes used, no error found
total csum bytes: 85216324
total tree bytes: 1095172096
total fs tree bytes: 907313152
total extent tree bytes: 89915392
btree space waste bytes: 226140034
file data blocks allocated: 244093546496
  referenced 236476338176


> 
>> [  979.223808] BTRFS: error (device sdc2) in __btrfs_cow_block:1080:
>> errno=-5 IO failure
>> [  979.223810] BTRFS info (device sdc2): forced readonly
>> [  979.224599] BTRFS warning (device sdc2): Skipping commit of aborted
>> transaction.
>> [  979.224603] BTRFS: error (device sdc2) in cleanup_transaction:1847:
>> errno=-5 IO failure
>>
>> I'll restore the system from a backup - and stick to stable kernels for
>> now - after that, but if needed I can of course also restore the
>> partition backup to another disk for testing.
> 
> Since it is your fs corrupted, using older kernel ignores such problem
> is not the long term solution in my opinion.

I agree. I just want to verify it's indeed stable again.
It may well be some no kernel issue at all and just bad timing with some 
HW breakdown.

> 
>>
>> Here what I can say from the first crash:
>>
>> On Jul 4th I discovered severe file system corruptions and when booting
>> with init=/bin/bash even tools like parted failed with some report about
>> invalid ELF headers for some library. I started an Ubuntu 17.10 install
>> on another physical disk and copied some data from the damaged btrfs
>> volume to the Ubuntu disk. And while I COULD copy the files quite many
>> of the interesting ones were broken:
>> e.g. the git tree I rescued from the broken btrfs disk is unusable. The
>> broken files I found all look about the correct size but contain only 0x01:
>> $ hexdump -C .git/objects/9d/732f6506e4cecd6d2b50c5008f9d1255198c1e
>> 00000000  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01
>> |................|
>> *
>> 00000e26
>>
>> After copying the files I tried a "btrfs check --repair" which was
>> finding countless errors and I aborted after I got more than 3 million
>> lines output.
> 
> --repair should never be your first try by all means.
> And in fact, sometimes it could even further corrupt the fs.

Ups, I just notice I have called it with --repair again. At least this 
time I have a backup and can restore to the old state....

I was aware of that the first time but lazy.
Problem was, that many basic system binaries were broken and it looked 
like repairing it was more work than starting over from scratch.
I was already set on reinstalling and just kind of wanted to see what 
happens.

Greetings,

Alexander
