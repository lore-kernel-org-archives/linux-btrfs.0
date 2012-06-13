Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Transportmtw01.mindtree.com ([119.226.208.135]:52539 "EHLO
	transportmtw01.mindtree.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab2FMEoz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 00:44:55 -0400
From: Santosh Hosamani <Santosh_Hosamani@mindtree.com>
To: Arne Jansen <sensille@gmx.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Bug in btrfs-debug-tree for two  or more devices.
Date: Wed, 13 Jun 2012 04:39:22 +0000
Message-ID: <24763ECA27C26742BD79B0D67389CD0E071B33E2@MTW02MBX05.mindtree.com>
References: <24763ECA27C26742BD79B0D67389CD0E071B3067@MTW02MBX05.mindtree.com>
 <4FD77336.6050800@gmx.net>
In-Reply-To: <4FD77336.6050800@gmx.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-----Original Message-----
From: Arne Jansen [mailto:sensille@gmx.net]
Sent: Tuesday, June 12, 2012 10:20 PM
To: Santosh Hosamani
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Bug in btrfs-debug-tree for two or more devices.

On 06/12/2012 08:53 AM, Santosh Hosamani wrote:
>
> Hi btrfs folks,
>                 I am working on btrfs filesystem on how it manages the free space. And found out btrfs maintain a ctree which manages the physical location of the chunks and stripes of the filesystem.
> Btrfs-debug-tree also gives the information on the chunk tree
>
> I created btrfs on single device and two device.I have attached the output of both on running btrfs-debug-tree.
> For single device sum of all the length in the chunks will add upto the total used bytes which is expected behavior.
>
> But for two devices sum of all lengths in the chunks does not add to the total bytes .Am I missing something .
> Also I notice that for the second device the superblock location 0x10000 is not considered as used .
>
> I would be really grateful if you folks can answer my query.

It's definitely not a bug in debug-tree, but just a problem in interpreting the result. Could you please paste the output of btrfs-debug-tree -d? This way it is easier to see what's bothering you :)


Btrfs fi show

Label: none  uuid: 23f86d1e-038a-4f5b-b87c-2ba78018135c
        Total devices 2 FS bytes used 28.00KB
        devid    2 size 3.00GB used 622.38MB path /dev/sdb2
        devid    1 size 3.00GB used 642.38MB path /dev/sdb1

Btrfs v0.19+


Btrfs-debug-tree -d /dev/sdb2
root tree
leaf 29364224 items 9 free space 2349 generation 4 owner 1
fs uuid 23f86d1e-038a-4f5b-b87c-2ba78018135c
chunk uuid db672366-6801-4f83-99ef-2087a60bb394
        item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 3756 itemsize 239
                root data bytenr 29368320 level 0 dirid 0 refs 1 gen 4
        item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 3517 itemsize 239
                root data bytenr 29372416 level 0 dirid 0 refs 1 gen 4
        item 2 key (FS_TREE INODE_REF 6) itemoff 3500 itemsize 17
                inode ref index 0 namelen 7 name: default
        item 3 key (FS_TREE ROOT_ITEM 0) itemoff 3261 itemsize 239
                root data bytenr 29360128 level 0 dirid 256 refs 1 gen 4
        item 4 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 3101 itemsize 160
                inode generation 3 size 0 block group 0 mode 40555 links 1
        item 5 key (ROOT_TREE_DIR INODE_REF 6) itemoff 3089 itemsize 12
                inode ref index 0 namelen 2 name: ..
        item 6 key (ROOT_TREE_DIR DIR_ITEM 2378154706) itemoff 3052 itemsize 37
                location key (FS_TREE ROOT_ITEM 18446744073709551615) type 2
                namelen 7 datalen 0 name: default
        item 7 key (CSUM_TREE ROOT_ITEM 0) itemoff 2813 itemsize 239
                root data bytenr 29376512 level 0 dirid 0 refs 1 gen 4
        item 8 key (DATA_RELOC_TREE ROOT_ITEM 0) itemoff 2574 itemsize 239
                root data bytenr 29380608 level 0 dirid 256 refs 1 gen 4
chunk tree
leaf 20971520 items 8 free space 3023 generation 4 owner 3
fs uuid 23f86d1e-038a-4f5b-b87c-2ba78018135c
chunk uuid db672366-6801-4f83-99ef-2087a60bb394
        item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 3897 itemsize 98
                dev item devid 1 total_bytes 3221225472 bytes used 673579008
        item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 3799 itemsize 98
                dev item devid 2 total_bytes 3221225472 bytes used 652607488
        item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 0) itemoff 3719 itemsize 80
                chunk length 4194304 owner 2 type 2 num_stripes 1
                        stripe 0 devid 1 offset 0
        item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 4194304) itemoff 3639 itemsize 80
                chunk length 8388608 owner 2 type 4 num_stripes 1
                        stripe 0 devid 1 offset 4194304
        item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 12582912) itemoff 3559 itemsize 80
                chunk length 8388608 owner 2 type 1 num_stripes 1
                        stripe 0 devid 1 offset 12582912
        item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 3447 itemsize 112
                chunk length 8388608 owner 2 type 18 num_stripes 2
                        stripe 0 devid 2 offset 1048576
                        stripe 1 devid 1 offset 20971520
        item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 29360128) itemoff 3335 itemsize 112
                chunk length 322109440 owner 2 type 20 num_stripes 2
                        stripe 0 devid 2 offset 9437184
                        stripe 1 devid 1 offset 29360128
        item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 351469568) itemoff 3223 itemsize 112
                chunk length 644218880 owner 2 type 9 num_stripes 2
                        stripe 0 devid 2 offset 331546624
                        stripe 1 devid 1 offset 351469568
device tree key (DEV_TREE ROOT_ITEM 0)
leaf 29372416 items 9 free space 3338 generation 4 owner 4
fs uuid 23f86d1e-038a-4f5b-b87c-2ba78018135c
chunk uuid db672366-6801-4f83-99ef-2087a60bb394
        item 0 key (1 DEV_EXTENT 0) itemoff 3947 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 0 length 4194304
        item 1 key (1 DEV_EXTENT 4194304) itemoff 3899 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 4194304 length 8388608
        item 2 key (1 DEV_EXTENT 12582912) itemoff 3851 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 12582912 length 8388608
        item 3 key (1 DEV_EXTENT 20971520) itemoff 3803 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 20971520 length 8388608
        item 4 key (1 DEV_EXTENT 29360128) itemoff 3755 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 29360128 length 322109440
        item 5 key (1 DEV_EXTENT 351469568) itemoff 3707 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 351469568 length 322109440
        item 6 key (2 DEV_EXTENT 1048576) itemoff 3659 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 20971520 length 8388608
        item 7 key (2 DEV_EXTENT 9437184) itemoff 3611 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 29360128 length 322109440
        item 8 key (2 DEV_EXTENT 331546624) itemoff 3563 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 351469568 length 322109440

>when you add all the lengths in the chunk tree
>devid 1  407502840
>devid 2  394919928
>may be the way I am counting the length is wrong.
>how to find which all blocks are used (data or metadata)  and which all  blocks are free in the multiple devices.
>Traversing the chunk tree is correct or is there any other alternative ?

>Also I had one more doubt Is chunk tree present only in the first device or will there  be a copy in all the devices?





________________________________

http://www.mindtree.com/email/disclaimer.html
