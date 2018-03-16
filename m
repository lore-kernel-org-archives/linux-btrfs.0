Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:45375 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbeCPADu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 20:03:50 -0400
Message-ID: <1521158625.4352.16.camel@scientia.net>
Subject: Re: spurious full btrfs corruption
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Fri, 16 Mar 2018 01:03:45 +0100
In-Reply-To: <1111e6a3-20fd-d3b5-8eaa-672a4a859380@gmx.com>
References: <26306A4D-2D8E-4661-B89E-9F050FD184D5@scientia.net>
         <BF03A3DF-684D-47FE-A9AD-320256F64763@scientia.net>
         <b6b4ed0e-9569-158d-19ad-82c885bab4ec@gmx.com>
         <BB977A40-847C-4611-A468-9BF1137CE711@scientia.net>
         <d2a14d69-dfa9-8794-6375-03d1b209632f@gmx.com>
         <68697875-6E77-49C4-B54E-0FADB94700DA@scientia.net>
         <99ee9b31-a38a-d479-5b1d-30e9c942d577@gmx.com>
         <A19E863A-F83C-4630-9675-4309CECB318E@scientia.net>
         <1b24e69e-2c1e-71af-fb1d-9d32f72cc78c@gmx.com>
         <8DB99A3B-6238-497D-A70F-8834CC014DCF@gmail.com>
         <c88d6721-ad20-c45d-0ac1-a49f2bab66cb@gmx.com>
         <1519833022.3714.122.camel@scientia.net>
         <8f83436a-9abb-1fd1-599f-d8034a5b3cb5@gmx.com>
         <1520297878.4428.39.camel@scientia.net>
         <0a25d1fc-38cb-8fb6-4538-6300093c0bbd@gmx.com>
         <1520519895.15491.21.camel@scientia.net>
         <1111e6a3-20fd-d3b5-8eaa-672a4a859380@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey.

Found some time to move on with this:


Frist, I think from my side (i.e. restoring as much as possible) I'm
basically done now, so everything left over here is looking for
possible bugs/etc.

I have from my side no indication that my corruptions were actually a
bug in btrfs... the new notebook used to be unstable for some time and
it might be just that.
Also that second occurrence of csum errors (when I made a image from
the broken fs to external HDD) kinda hints that it may be a memory
issue (though I haven't found time to run memtest86+ yet).

So let's just suppose that btrfs code is as rocksolid as its raid56 is
;-P and assume the issues were cause by some unlucky memory corruption
just happening at the wrong (important) meta-data. 




The issue that newer btrfs-progs/kernel don't restore anything at all
from my corrupted fs:

On Fri, 2018-03-09 at 07:48 +0800, Qu Wenruo wrote:
> > So something changed after 4.14, which makes the tools no longer
> > being
> > able to restore at least that what they could restore at 4.14.
> 
> This seems to be a regression.
> But I'm not sure if it's the kernel to blame or the btrfs-progs.
> 
> > 
> > 
> > => Some bug recently introduced in btrfs-progs?
> 
> Is the "block mapping error" message from kernel or btrfs-progs?

All progs messages unless otherwise noticed.
/dev/mapper/restore being the image from the broken SSD fs.
Everything below was on the OLD laptop (which has probably no memory or
whichever issues) under kernel 4.15.4 and progs 4.15.1.

# btrfs-find-root /dev/mapper/restore 
Couldn't map the block 4503658729209856
No mapping for 4503658729209856-4503658729226240
Couldn't map the block 4503658729209856
Superblock thinks the generation is 2083143
Superblock thinks the level is 1
Found tree root at 58572800 gen 2083143 level 1
Well block 27820032(gen: 2083133 level: 1) seems good, but generation/level doesn't match, want gen: 2083143 level: 1
Well block 25526272(gen: 2083132 level: 1) seems good, but generation/level doesn't match, want gen: 2083143 level: 1
Well block 21807104(gen: 2083131 level: 1) seems good, but generation/level doesn't match, want gen: 2083143 level: 1
Well block 11829248(gen: 2083130 level: 1) seems good, but generation/level doesn't match, want gen: 2083143 level: 1
Well block 8716288(gen: 2083129 level: 1) seems good, but generation/level doesn't match, want gen: 2083143 level: 1
Well block 6209536(gen: 2083128 level: 1) seems good, but generation/level doesn't match, want gen: 2083143 level: 1




# btrfs-debug-tree -b 27820032 /dev/mapper/restore 
btrfs-progs v4.15.1
Couldn't map the block 4503658729209856
No mapping for 4503658729209856-4503658729226240
Couldn't map the block 4503658729209856
bytenr mismatch, want=4503658729209856, have=0
node 27820032 level 1 items 2 free 491 generation 2083133 owner 1
fs uuid b6050e38-716a-40c3-a8df-fcf1dd7e655d
chunk uuid ae6b0cc6-bbc5-4131-b3f3-41b748f5a775
	key (EXTENT_TREE ROOT_ITEM 0) block 27836416 (1699) gen 2083133
	key (1853 INODE_ITEM 0) block 28000256 (1709) gen 2083133

=> I *think* (but not 100% sure - would need to double check if it's
important for you to know), that the older progs/kernel showed me much
more here




# btrfs-debug-tree /dev/mapper/restore 
btrfs-progs v4.15.1
Couldn't map the block 4503658729209856
No mapping for 4503658729209856-4503658729226240
Couldn't map the block 4503658729209856
bytenr mismatch, want=4503658729209856, have=0
ERROR: unable to open /dev/mapper/restore

=> same here: I *think* (but not 100% sure - would need to double check
if it's important for you to know), that the older progs/kernel showed
me much more here




# btrfs-debug-tree -b 27836416 /dev/mapper/restore 
btrfs-progs v4.15.1
Couldn't map the block 4503658729209856
No mapping for 4503658729209856-4503658729226240
Couldn't map the block 4503658729209856
bytenr mismatch, want=4503658729209856, have=0
leaf 27836416 items 63 free space 6131 generation 2083133 owner 1
leaf 27836416 flags 0x1(WRITTEN) backref revision 1
fs uuid b6050e38-716a-40c3-a8df-fcf1dd7e655d
chunk uuid ae6b0cc6-bbc5-4131-b3f3-41b748f5a775
	item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 15844 itemsize 439
		generation 2083133 root_dirid 0 bytenr 27328512 level 2 refs 1
		lastsnap 0 byte_limit 0 bytes_used 182190080 flags 0x0(none)
		uuid 00000000-0000-0000-0000-000000000000
		drop key (0 UNKNOWN.0 0) level 0
	item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 15405 itemsize 439
		generation 2083129 root_dirid 0 bytenr 9502720 level 1 refs 1
		lastsnap 0 byte_limit 0 bytes_used 114688 flags 0x0(none)
		uuid 00000000-0000-0000-0000-000000000000
		drop key (0 UNKNOWN.0 0) level 0
	item 2 key (FS_TREE INODE_REF 6) itemoff 15388 itemsize 17
		index 0 namelen 7 name: default
	item 3 key (FS_TREE ROOT_ITEM 0) itemoff 14949 itemsize 439
		generation 2081091 root_dirid 256 bytenr 474185728 level 0 refs 1
		lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
		uuid 00000000-0000-0000-0000-000000000000
		ctransid 2081091 otransid 0 stransid 0 rtransid 0
		ctime 1519222863.366476716 (2018-02-21 15:21:03)
		drop key (0 UNKNOWN.0 0) level 0
	item 4 key (FS_TREE ROOT_REF 257) itemoff 14927 itemsize 22
		root ref key dirid 256 sequence 2 name root
	item 5 key (FS_TREE ROOT_REF 1830) itemoff 14866 itemsize 61
		root ref key dirid 256 sequence 5 name heisenberg.scientia.net_system_2018-02-21_1
	item 6 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 14706 itemsize 160
		generation 3 transid 0 size 0 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
		sequence 0 flags 0x0(none)
		atime 1446913329.0 (2015-11-07 17:22:09)
		ctime 1446913329.0 (2015-11-07 17:22:09)
		mtime 1446913329.0 (2015-11-07 17:22:09)
		otime 0.0 (1970-01-01 01:00:00)
	item 7 key (ROOT_TREE_DIR INODE_REF 6) itemoff 14694 itemsize 12
		index 0 namelen 2 name: ..
	item 8 key (ROOT_TREE_DIR DIR_ITEM 2378154706) itemoff 14657 itemsize 37
		location key (FS_TREE ROOT_ITEM -1) type DIR
		transid 0 data_len 0 name_len 7
		name: default
	item 9 key (CSUM_TREE ROOT_ITEM 0) itemoff 14218 itemsize 439
		generation 2083133 root_dirid 0 bytenr 27197440 level 2 refs 1
		lastsnap 0 byte_limit 0 bytes_used 866926592 flags 0x0(none)
		uuid 00000000-0000-0000-0000-000000000000
		drop key (0 UNKNOWN.0 0) level 0
	item 10 key (UUID_TREE ROOT_ITEM 0) itemoff 13779 itemsize 439
		generation 2080566 root_dirid 0 bytenr 505818398720 level 0 refs 1
		lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
		uuid 85e68ea6-09cd-3b45-b01a-e57bcc5684ba
		drop key (0 UNKNOWN.0 0) level 0
	item 11 key (257 ROOT_ITEM 0) itemoff 13340 itemsize 439
		generation 2083133 root_dirid 256 bytenr 27000832 level 2 refs 1
		lastsnap 2080523 byte_limit 0 bytes_used 1288060928 flags 0x0(none)
		uuid c37238d5-ac17-ee45-a790-b4d1538f46fc
		ctransid 2083133 otransid 8 stransid 0 rtransid 0
		ctime 1519231525.124530719 (2018-02-21 17:45:25)
		otime 1446913423.498012409 (2015-11-07 17:23:43)
		drop key (0 UNKNOWN.0 0) level 0
	item 12 key (257 ROOT_BACKREF 5) itemoff 13318 itemsize 22
		root backref key dirid 256 sequence 2 name root
	item 13 key (979 INODE_ITEM 0) itemoff 13158 itemsize 160
		generation 2081024 transid 2081024 size 262144 nbytes 3230924800
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 12325 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519191053.828440563 (2018-02-21 06:30:53)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 14 key (979 EXTENT_DATA 0) itemoff 13105 itemsize 53
		generation 2081024 type 1 (regular)
		extent data disk byte 73967251456 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 15 key (980 INODE_ITEM 0) itemoff 12945 itemsize 160
		generation 2081024 transid 2081024 size 262144 nbytes 3137601536
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 11969 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519191053.828440563 (2018-02-21 06:30:53)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 16 key (980 EXTENT_DATA 0) itemoff 12892 itemsize 53
		generation 2081024 type 1 (regular)
		extent data disk byte 73977970688 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 17 key (1830 ROOT_ITEM 2080565) itemoff 12453 itemsize 439
		generation 2080565 root_dirid 256 bytenr 505812746240 level 2 refs 1
		lastsnap 2080565 byte_limit 0 bytes_used 1021968384 flags 0x1(RDONLY)
		uuid 5247e0c0-7a79-434e-880b-d2c7941e6767
		parent_uuid 04b7ff5b-31c9-4a41-ba14-7c91076f6da6
		ctransid 2080561 otransid 2080565 stransid 0 rtransid 0
		ctime 1519174487.202858099 (2018-02-21 01:54:47)
		otime 1519174628.538451830 (2018-02-21 01:57:08)
		drop key (0 UNKNOWN.0 0) level 0
	item 18 key (1830 ROOT_BACKREF 5) itemoff 12392 itemsize 61
		root backref key dirid 256 sequence 5 name heisenberg.scientia.net_system_2018-02-21_1
	item 19 key (1831 INODE_ITEM 0) itemoff 12232 itemsize 160
		generation 2083133 transid 2083133 size 262144 nbytes 15990784
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 61 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231527.115322244 (2018-02-21 17:45:27)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 20 key (1831 EXTENT_DATA 0) itemoff 12179 itemsize 53
		generation 2083133 type 1 (regular)
		extent data disk byte 33299181568 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 21 key (1832 INODE_ITEM 0) itemoff 12019 itemsize 160
		generation 2083127 transid 2083127 size 262144 nbytes 8650752
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 33 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231352.51151791 (2018-02-21 17:42:32)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 22 key (1832 EXTENT_DATA 0) itemoff 11966 itemsize 53
		generation 2083127 type 1 (regular)
		extent data disk byte 48053231616 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 23 key (1833 INODE_ITEM 0) itemoff 11806 itemsize 160
		generation 2083117 transid 2083117 size 262144 nbytes 4456448
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 17 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231019.230780046 (2018-02-21 17:36:59)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 24 key (1833 EXTENT_DATA 0) itemoff 11753 itemsize 53
		generation 2083117 type 1 (regular)
		extent data disk byte 46261501952 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 25 key (1834 INODE_ITEM 0) itemoff 11593 itemsize 160
		generation 2083120 transid 2083120 size 262144 nbytes 2621440
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 10 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231097.45708714 (2018-02-21 17:38:17)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 26 key (1834 EXTENT_DATA 0) itemoff 11540 itemsize 53
		generation 2083120 type 1 (regular)
		extent data disk byte 33299738624 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 27 key (1835 INODE_ITEM 0) itemoff 11380 itemsize 160
		generation 2083121 transid 2083121 size 262144 nbytes 3407872
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 13 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231133.956124450 (2018-02-21 17:38:53)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 28 key (1835 EXTENT_DATA 0) itemoff 11327 itemsize 53
		generation 2083121 type 1 (regular)
		extent data disk byte 48017752064 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 29 key (1836 INODE_ITEM 0) itemoff 11167 itemsize 160
		generation 2083128 transid 2083128 size 262144 nbytes 6553600
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 25 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231382.739882872 (2018-02-21 17:43:02)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 30 key (1836 EXTENT_DATA 0) itemoff 11114 itemsize 53
		generation 2083128 type 1 (regular)
		extent data disk byte 43620921344 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 31 key (1837 INODE_ITEM 0) itemoff 10954 itemsize 160
		generation 2083129 transid 2083129 size 262144 nbytes 9437184
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 36 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231390.216060972 (2018-02-21 17:43:10)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 32 key (1837 EXTENT_DATA 0) itemoff 10901 itemsize 53
		generation 2083129 type 1 (regular)
		extent data disk byte 43256619008 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 33 key (1838 INODE_ITEM 0) itemoff 10741 itemsize 160
		generation 2083133 transid 2083133 size 262144 nbytes 8126464
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 31 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231527.115322244 (2018-02-21 17:45:27)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 34 key (1838 EXTENT_DATA 0) itemoff 10688 itemsize 53
		generation 2083133 type 1 (regular)
		extent data disk byte 44043571200 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 35 key (1839 INODE_ITEM 0) itemoff 10528 itemsize 160
		generation 2083132 transid 2083132 size 262144 nbytes 5242880
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 20 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231491.286468713 (2018-02-21 17:44:51)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 36 key (1839 EXTENT_DATA 0) itemoff 10475 itemsize 53
		generation 2083132 type 1 (regular)
		extent data disk byte 44647149568 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 37 key (1840 INODE_ITEM 0) itemoff 10315 itemsize 160
		generation 2083133 transid 2083133 size 262144 nbytes 7602176
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 29 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231527.115322244 (2018-02-21 17:45:27)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 38 key (1840 EXTENT_DATA 0) itemoff 10262 itemsize 53
		generation 2083133 type 1 (regular)
		extent data disk byte 44176515072 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 39 key (1841 INODE_ITEM 0) itemoff 10102 itemsize 160
		generation 2083132 transid 2083132 size 262144 nbytes 4456448
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 17 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231491.290468809 (2018-02-21 17:44:51)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 40 key (1841 EXTENT_DATA 0) itemoff 10049 itemsize 53
		generation 2083132 type 1 (regular)
		extent data disk byte 47911272448 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 41 key (1842 INODE_ITEM 0) itemoff 9889 itemsize 160
		generation 2083130 transid 2083130 size 262144 nbytes 2883584
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 11 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231423.700858661 (2018-02-21 17:43:43)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 42 key (1842 EXTENT_DATA 0) itemoff 9836 itemsize 53
		generation 2083130 type 1 (regular)
		extent data disk byte 46249439232 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 43 key (1843 INODE_ITEM 0) itemoff 9676 itemsize 160
		generation 2083127 transid 2083127 size 262144 nbytes 1310720
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 5 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231352.35151410 (2018-02-21 17:42:32)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 44 key (1843 EXTENT_DATA 0) itemoff 9623 itemsize 53
		generation 2083127 type 1 (regular)
		extent data disk byte 47916822528 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 45 key (1844 INODE_ITEM 0) itemoff 9463 itemsize 160
		generation 2083130 transid 2083130 size 262144 nbytes 2883584
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 11 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231423.700858661 (2018-02-21 17:43:43)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 46 key (1844 EXTENT_DATA 0) itemoff 9410 itemsize 53
		generation 2083130 type 1 (regular)
		extent data disk byte 47890669568 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 47 key (1845 INODE_ITEM 0) itemoff 9250 itemsize 160
		generation 2083133 transid 2083133 size 262144 nbytes 15990784
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 61 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231527.119322339 (2018-02-21 17:45:27)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 48 key (1845 EXTENT_DATA 0) itemoff 9197 itemsize 53
		generation 2083133 type 1 (regular)
		extent data disk byte 44771708928 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 49 key (1846 INODE_ITEM 0) itemoff 9037 itemsize 160
		generation 2083133 transid 2083133 size 262144 nbytes 15990784
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 61 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231527.119322339 (2018-02-21 17:45:27)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 50 key (1846 EXTENT_DATA 0) itemoff 8984 itemsize 53
		generation 2083133 type 1 (regular)
		extent data disk byte 46255108096 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 51 key (1847 INODE_ITEM 0) itemoff 8824 itemsize 160
		generation 2083132 transid 2083132 size 262144 nbytes 5242880
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 20 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231491.290468809 (2018-02-21 17:44:51)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 52 key (1847 EXTENT_DATA 0) itemoff 8771 itemsize 53
		generation 2083132 type 1 (regular)
		extent data disk byte 48023654400 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 53 key (1848 INODE_ITEM 0) itemoff 8611 itemsize 160
		generation 2083127 transid 2083127 size 262144 nbytes 3145728
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 12 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231352.51151791 (2018-02-21 17:42:32)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 54 key (1848 EXTENT_DATA 0) itemoff 8558 itemsize 53
		generation 2083127 type 1 (regular)
		extent data disk byte 48054853632 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 55 key (1849 INODE_ITEM 0) itemoff 8398 itemsize 160
		generation 2083132 transid 2083132 size 262144 nbytes 5505024
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 21 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231491.286468713 (2018-02-21 17:44:51)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 56 key (1849 EXTENT_DATA 0) itemoff 8345 itemsize 53
		generation 2083132 type 1 (regular)
		extent data disk byte 44981190656 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 57 key (1850 INODE_ITEM 0) itemoff 8185 itemsize 160
		generation 2083129 transid 2083129 size 262144 nbytes 4718592
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 18 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231390.216060972 (2018-02-21 17:43:10)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 58 key (1850 EXTENT_DATA 0) itemoff 8132 itemsize 53
		generation 2083129 type 1 (regular)
		extent data disk byte 43665002496 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 59 key (1851 INODE_ITEM 0) itemoff 7972 itemsize 160
		generation 2083128 transid 2083128 size 262144 nbytes 12058624
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 46 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231382.743882966 (2018-02-21 17:43:02)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 60 key (1851 EXTENT_DATA 0) itemoff 7919 itemsize 53
		generation 2083128 type 1 (regular)
		extent data disk byte 48013914112 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)
	item 61 key (1852 INODE_ITEM 0) itemoff 7759 itemsize 160
		generation 2083130 transid 2083130 size 262144 nbytes 4456448
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 17 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 01:00:00)
		ctime 1519231423.704858756 (2018-02-21 17:43:43)
		mtime 0.0 (1970-01-01 01:00:00)
		otime 0.0 (1970-01-01 01:00:00)
	item 62 key (1852 EXTENT_DATA 0) itemoff 7706 itemsize 53
		generation 2083130 type 1 (regular)
		extent data disk byte 48013127680 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0 (none)

=> I think at least the "magic" bytenr of 474185728 is the same as what
I got by the older progs/kernel



# btrfs restore -f 474185728 /dev/mapper/restore tmp/
Couldn't map the block 4503658729209856
No mapping for 4503658729209856-4503658729226240
Couldn't map the block 4503658729209856
bytenr mismatch, want=4503658729209856, have=0
Could not open root, trying backup super
Couldn't map the block 4503658729209856
No mapping for 4503658729209856-4503658729226240
Couldn't map the block 4503658729209856
bytenr mismatch, want=4503658729209856, have=0
Could not open root, trying backup super
Couldn't map the block 4503658729209856
No mapping for 4503658729209856-4503658729226240
Couldn't map the block 4503658729209856
bytenr mismatch, want=4503658729209856, have=0
Could not open root, trying backup super

=> tmp/ remains empty... so here is the major difference between 4.15
and the older ones


No kernel messages at all during the whole procedure.




> And strangely this time it works...
> 
> > 
> > dm-1 here is the external HDD (and the 130 corrupt are likely from
> > the
> > first btrfs-restore that I made while still on the NEW notebook
> > with
> > the possible bad RAM).
> > 
> > 
> > After that I did a fsck of the 8TB HDD / dm-1 ... and as you've
> > anyway
> > asked me above, a scrub of it.
> > Neither of both showed any errors.... (so still strange why it got
> > that
> > open_ctree error)
> 
> I'm surprise the corruption just disappeared...

Anything more on this from your side (I mean this spurious "open_ctree
failed" and it's even more unexplained vanishing)?
I haven't seen it again since then and wouldn't know anything further I
could do here... so I'd just forget about it.



> Fortunately (or unfortunately), no obvious problem with v1 space
> cache
> found yet.

I assume still nothing new here? Can one thus basically use the v1
space cache again or would you still rather keep it disabled until
further investigations have been made?



Cheers&thx,
Chris.
