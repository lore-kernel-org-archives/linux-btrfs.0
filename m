Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbcDDXHF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 19:07:05 -0400
Date: Mon, 4 Apr 2016 16:06:57 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, jbacik@fb.com, clm@fb.com
Subject: Qgroups wrong after snapshot create
Message-ID: <20160404230657.GA2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gatW/ieO32f1wygP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Making a snapshot gets us the wrong qgroup numbers. This is very easy to
reproduce. From a fresh btrfs filesystem, simply enable qgroups and create a
snapshot. In this example we have mounted a newly created fresh filesystem
and mounted it at /btrfs:

# btrfs quota enable /btrfs
# btrfs sub sna /btrfs/ /btrfs/snap1
# btrfs qg show /btrfs

qgroupid         rfer         excl 
--------         ----         ---- 
0/5          32.00KiB     32.00KiB 
0/257        16.00KiB     16.00KiB 


In the example above, the default subvolume (0/5) should read 16KiB
referenced and 16KiB exclusive.

A rescan fixes things, so we know the rescan process is doing the math
right:

# btrfs quota rescan /btrfs
# btrfs qgroup show /btrfs
qgroupid         rfer         excl 
--------         ----         ---- 
0/5          16.00KiB     16.00KiB 
0/257        16.00KiB     16.00KiB 



The last kernel to get this right was v4.1:

# uname -r
4.1.20
# btrfs quota enable /btrfs
# btrfs sub sna /btrfs/ /btrfs/snap1
Create a snapshot of '/btrfs/' in '/btrfs/snap1'
# btrfs qg show /btrfs
qgroupid         rfer         excl 
--------         ----         ---- 
0/5          16.00KiB     16.00KiB 
0/257        16.00KiB     16.00KiB 


Which leads me to believe that this was a regression introduced by Qu's
rewrite as that is the biggest change to qgroups during that development
period.


Going back to upstream, I applied my tracing patch from this list
( http://thread.gmane.org/gmane.comp.file-systems.btrfs/54685 ), with a
couple changes - I'm printing the rfer/excl bytecounts in
qgroup_update_counters AND I print them twice - once before we make any
changes and once after the changes. If I enable tracing in
btrfs_qgroup_account_extent and qgroup_update_counters just before the
snapshot creation, we get the following trace:


# btrfs quota enable /btrfs
# <wait a sec for the rescan to finish>
# echo 1 > /sys/kernel/debug/tracing/events/btrfs/btrfs_qgroup_account_extent/enable
# echo 1 > //sys/kernel/debug/tracing/events/btrfs/qgroup_update_counters/enable
# btrfs sub sna /btrfs/ /btrfs/snap2
Create a snapshot of '/btrfs/' in '/btrfs/snap2'
# btrfs qg show /btrfs
qgroupid         rfer         excl 
--------         ----         ---- 
0/5          32.00KiB     32.00KiB 
0/257        16.00KiB     16.00KiB 
# fstest1:~ # cat /sys/kernel/debug/tracing/trace

# tracer: nop
#
# entries-in-buffer/entries-written: 13/13   #P:2
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
           btrfs-10233 [001] .... 260298.823339: btrfs_qgroup_account_extent: bytenr = 29360128, num_bytes = 16384, nr_old_roots = 1, nr_new_roots = 0
           btrfs-10233 [001] .... 260298.823342: qgroup_update_counters: qgid = 5, cur_old_count = 1, cur_new_count = 0, rfer = 16384, excl = 16384
           btrfs-10233 [001] .... 260298.823342: qgroup_update_counters: qgid = 5, cur_old_count = 1, cur_new_count = 0, rfer = 0, excl = 0
           btrfs-10233 [001] .... 260298.823343: btrfs_qgroup_account_extent: bytenr = 29720576, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
           btrfs-10233 [001] .... 260298.823345: btrfs_qgroup_account_extent: bytenr = 29736960, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
           btrfs-10233 [001] .... 260298.823347: btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 1
           btrfs-10233 [001] .... 260298.823347: qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 0, excl = 0
           btrfs-10233 [001] .... 260298.823348: qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
           btrfs-10233 [001] .... 260298.823421: btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
           btrfs-10233 [001] .... 260298.823422: btrfs_qgroup_account_extent: bytenr = 29835264, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
           btrfs-10233 [001] .... 260298.823425: btrfs_qgroup_account_extent: bytenr = 29851648, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 1
           btrfs-10233 [001] .... 260298.823426: qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
           btrfs-10233 [001] .... 260298.823426: qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 32768, excl = 32768

If you read through the whole log we do some ... interesting.. things - at
the start, we *subtract* from qgroup 5, making it's count go to zero. I want
to say that this is kind of unexpected for a snapshot create but perhaps
there's something I'm missing.

Remember that I'm printing each qgroup twice in qgroup_adjust_counters (once
before, once after). Sothen we can see then that extent 29851648 (len 16k)
is the extent being counted against qgroup 5 which makes the count invalid.

>From a btrfs-debug-tree I get the following records referencing that extent:

>From the root tree:
        item 3 key (FS_TREE ROOT_ITEM 0) itemoff 14949 itemsize 439
                root data bytenr 29851648 level 0 dirid 256 refs 1 gen 10 lastsnap 10
                uuid 00000000-0000-0000-0000-000000000000
                ctransid 10 otransid 0 stransid 0 rtransid 0

>From the extent tree:
        item 9 key (29851648 METADATA_ITEM 0) itemoff 15960 itemsize 33
                extent refs 1 gen 10 flags TREE_BLOCK
                tree block skinny level 0
                tree block backref root 5

And here is the block itself:

fs tree key (FS_TREE ROOT_ITEM 0) 
leaf 29851648 items 4 free space 15941 generation 10 owner 5
fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
        item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
                inode generation 3 transid 10 size 10 nbytes 16384
                block group 0 mode 40755 links 1 uid 0 gid 0
                rdev 0 flags 0x0
        item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
                inode ref index 0 namelen 2 name: ..
        item 2 key (256 DIR_ITEM 3390559794) itemoff 16076 itemsize 35
                location key (257 ROOT_ITEM -1) type DIR
                namelen 5 datalen 0 name: snap2
        item 3 key (256 DIR_INDEX 2) itemoff 16041 itemsize 35
                location key (257 ROOT_ITEM -1) type DIR
                namelen 5 datalen 0 name: snap2


So unless I'm mistaken, it seems like we're counting the original snapshot
root against itself when creating a snapshot.

I found this looking for what I believe to be a _different_ corruption in
qgroups. In the meantime while I track that one down though I was hoping
that someone might be able to shed some light on this particular issue.

Qu, do you have any ideas how we might fix this?

Thanks,
	--Mark

PS: I have attached the output of btrfs-debug-tree for the FS used in this
example.

--
Mark Fasheh

--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="debug-tree.txt"

root tree
leaf 29884416 items 17 free space 11820 generation 11 owner 1
fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
	item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 15844 itemsize 439
		root data bytenr 29900800 level 0 dirid 0 refs 1 gen 11 lastsnap 0
		uuid 00000000-0000-0000-0000-000000000000
	item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 15405 itemsize 439
		root data bytenr 29507584 level 0 dirid 0 refs 1 gen 6 lastsnap 0
		uuid 00000000-0000-0000-0000-000000000000
	item 2 key (FS_TREE INODE_REF 6) itemoff 15388 itemsize 17
		inode ref index 0 namelen 7 name: default
	item 3 key (FS_TREE ROOT_ITEM 0) itemoff 14949 itemsize 439
		root data bytenr 29851648 level 0 dirid 256 refs 1 gen 10 lastsnap 10
		uuid 00000000-0000-0000-0000-000000000000
		ctransid 10 otransid 0 stransid 0 rtransid 0
	item 4 key (FS_TREE ROOT_REF 257) itemoff 14926 itemsize 23
		root ref key dirid 256 sequence 2 name snap2
	item 5 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 14766 itemsize 160
		inode generation 3 transid 0 size 0 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0
		rdev 0 flags 0x0
	item 6 key (ROOT_TREE_DIR INODE_REF 6) itemoff 14754 itemsize 12
		inode ref index 0 namelen 2 name: ..
	item 7 key (ROOT_TREE_DIR DIR_ITEM 2378154706) itemoff 14717 itemsize 37
		location key (FS_TREE ROOT_ITEM -1) type DIR
		namelen 7 datalen 0 name: default
	item 8 key (CSUM_TREE ROOT_ITEM 0) itemoff 14278 itemsize 439
		root data bytenr 29933568 level 0 dirid 0 refs 1 gen 11 lastsnap 0
		uuid 00000000-0000-0000-0000-000000000000
	item 9 key (QUOTA_TREE ROOT_ITEM 0) itemoff 13839 itemsize 439
		root data bytenr 29917184 level 0 dirid 0 refs 1 gen 11 lastsnap 0
		uuid d66e47c6-9943-ae4e-9adb-6d97065f6358
	item 10 key (UUID_TREE ROOT_ITEM 0) itemoff 13400 itemsize 439
		root data bytenr 29802496 level 0 dirid 0 refs 1 gen 10 lastsnap 0
		uuid 4bded89b-be0f-ba46-becf-15604fcc58fc
	item 11 key (256 INODE_ITEM 0) itemoff 13240 itemsize 160
		inode generation 11 transid 11 size 262144 nbytes 1572864
		block group 0 mode 100600 links 1 uid 0 gid 0
		rdev 0 flags 0x1b
	item 12 key (256 EXTENT_DATA 0) itemoff 13187 itemsize 53
		extent data disk byte 12845056 nr 262144
		extent data offset 0 nr 262144 ram 262144
		extent compression 0
	item 13 key (257 ROOT_ITEM 10) itemoff 12748 itemsize 439
		root data bytenr 29736960 level 0 dirid 256 refs 1 gen 10 lastsnap 10
		uuid fb326c16-07e8-4944-aba6-9154d860322c
	item 14 key (257 ROOT_BACKREF 5) itemoff 12725 itemsize 23
		root backref key dirid 256 sequence 2 name snap2
	item 15 key (FREE_SPACE UNTYPED 29360128) itemoff 12684 itemsize 41
		location key (256 INODE_ITEM 0)
		cache generation 11 entries 10 bitmaps 0
	item 16 key (DATA_RELOC_TREE ROOT_ITEM 0) itemoff 12245 itemsize 439
		root data bytenr 29442048 level 0 dirid 256 refs 1 gen 4 lastsnap 0
		uuid 00000000-0000-0000-0000-000000000000
chunk tree
leaf 20987904 items 4 free space 15781 generation 5 owner 3
fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
	item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
		dev item devid 1 total_bytes 17178820608 bytes used 2172649472
		dev uuid 24080b38-13bb-4f4c-8c9f-c6d5313c8621
	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 12582912) itemoff 16105 itemsize 80
		chunk length 8388608 owner 2 stripe_len 65536
		type DATA num_stripes 1
			stripe 0 devid 1 offset 12582912
			dev uuid: 24080b38-13bb-4f4c-8c9f-c6d5313c8621
	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 15993 itemsize 112
		chunk length 8388608 owner 2 stripe_len 65536
		type SYSTEM|DUP num_stripes 2
			stripe 0 devid 1 offset 20971520
			dev uuid: 24080b38-13bb-4f4c-8c9f-c6d5313c8621
			stripe 1 devid 1 offset 29360128
			dev uuid: 24080b38-13bb-4f4c-8c9f-c6d5313c8621
	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 29360128) itemoff 15881 itemsize 112
		chunk length 1073741824 owner 2 stripe_len 65536
		type METADATA|DUP num_stripes 2
			stripe 0 devid 1 offset 37748736
			dev uuid: 24080b38-13bb-4f4c-8c9f-c6d5313c8621
			stripe 1 devid 1 offset 1111490560
			dev uuid: 24080b38-13bb-4f4c-8c9f-c6d5313c8621
extent tree key (EXTENT_TREE ROOT_ITEM 0) 
leaf 29900800 items 14 free space 15478 generation 11 owner 2
fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
	item 0 key (12582912 BLOCK_GROUP_ITEM 8388608) itemoff 16259 itemsize 24
		block group used 262144 chunk_objectid 256 flags DATA
	item 1 key (12845056 EXTENT_ITEM 262144) itemoff 16206 itemsize 53
		extent refs 1 gen 11 flags DATA
		extent data backref root 1 objectid 256 offset 0 count 1
	item 2 key (20971520 BLOCK_GROUP_ITEM 8388608) itemoff 16182 itemsize 24
		block group used 16384 chunk_objectid 256 flags SYSTEM|DUP
	item 3 key (20987904 METADATA_ITEM 0) itemoff 16149 itemsize 33
		extent refs 1 gen 5 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root 3
	item 4 key (29360128 BLOCK_GROUP_ITEM 1073741824) itemoff 16125 itemsize 24
		block group used 147456 chunk_objectid 256 flags METADATA|DUP
	item 5 key (29442048 METADATA_ITEM 0) itemoff 16092 itemsize 33
		extent refs 1 gen 4 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root 18446744073709551607
	item 6 key (29507584 METADATA_ITEM 0) itemoff 16059 itemsize 33
		extent refs 1 gen 6 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root 4
	item 7 key (29736960 METADATA_ITEM 0) itemoff 16026 itemsize 33
		extent refs 1 gen 10 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root 257
	item 8 key (29802496 METADATA_ITEM 0) itemoff 15993 itemsize 33
		extent refs 1 gen 10 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root 9
	item 9 key (29851648 METADATA_ITEM 0) itemoff 15960 itemsize 33
		extent refs 1 gen 10 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root 5
	item 10 key (29884416 METADATA_ITEM 0) itemoff 15927 itemsize 33
		extent refs 1 gen 11 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root 1
	item 11 key (29900800 METADATA_ITEM 0) itemoff 15894 itemsize 33
		extent refs 1 gen 11 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root 2
	item 12 key (29917184 METADATA_ITEM 0) itemoff 15861 itemsize 33
		extent refs 1 gen 11 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root 8
	item 13 key (29933568 METADATA_ITEM 0) itemoff 15828 itemsize 33
		extent refs 1 gen 11 flags TREE_BLOCK
		tree block skinny level 0
		tree block backref root 7
device tree key (DEV_TREE ROOT_ITEM 0) 
leaf 29507584 items 6 free space 15853 generation 6 owner 4
fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
	item 0 key (0 DEV_STATS 1) itemoff 16243 itemsize 40
		device stats
	item 1 key (1 DEV_EXTENT 12582912) itemoff 16195 itemsize 48
		dev extent chunk_tree 3
		chunk objectid 256 chunk offset 12582912 length 8388608
	item 2 key (1 DEV_EXTENT 20971520) itemoff 16147 itemsize 48
		dev extent chunk_tree 3
		chunk objectid 256 chunk offset 20971520 length 8388608
	item 3 key (1 DEV_EXTENT 29360128) itemoff 16099 itemsize 48
		dev extent chunk_tree 3
		chunk objectid 256 chunk offset 20971520 length 8388608
	item 4 key (1 DEV_EXTENT 37748736) itemoff 16051 itemsize 48
		dev extent chunk_tree 3
		chunk objectid 256 chunk offset 29360128 length 1073741824
	item 5 key (1 DEV_EXTENT 1111490560) itemoff 16003 itemsize 48
		dev extent chunk_tree 3
		chunk objectid 256 chunk offset 29360128 length 1073741824
fs tree key (FS_TREE ROOT_ITEM 0) 
leaf 29851648 items 4 free space 15941 generation 10 owner 5
fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		inode generation 3 transid 10 size 10 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0
		rdev 0 flags 0x0
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		inode ref index 0 namelen 2 name: ..
	item 2 key (256 DIR_ITEM 3390559794) itemoff 16076 itemsize 35
		location key (257 ROOT_ITEM -1) type DIR
		namelen 5 datalen 0 name: snap2
	item 3 key (256 DIR_INDEX 2) itemoff 16041 itemsize 35
		location key (257 ROOT_ITEM -1) type DIR
		namelen 5 datalen 0 name: snap2
checksum tree key (CSUM_TREE ROOT_ITEM 0) 
leaf 29933568 items 0 free space 16283 generation 11 owner 7
fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
quota tree key (QUOTA_TREE ROOT_ITEM 0) 
leaf 29917184 items 5 free space 15966 generation 11 owner 8
fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
	item 0 key (0 QGROUP_STATUS 0) itemoff 16251 itemsize 32
		version 1 generation 11 flags ON scan -1
	item 1 key (0 QGROUP_INFO 0/5) itemoff 16211 itemsize 40
		generation 10
		referenced 32768 referenced compressed 32768
		exclusive 32768 exclusive compressed 32768
	item 2 key (0 QGROUP_INFO 0/257) itemoff 16171 itemsize 40
		generation 10
		referenced 16384 referenced compressed 16384
		exclusive 16384 exclusive compressed 16384
	item 3 key (0 QGROUP_LIMIT 0/5) itemoff 16131 itemsize 40
		flags 0
		max referenced 0 max exclusive 0
		rsv referenced 0 rsv exclusive 0
	item 4 key (0 QGROUP_LIMIT 0/257) itemoff 16091 itemsize 40
		flags 0
		max referenced 0 max exclusive 0
		rsv referenced 0 rsv exclusive 0
uuid tree key (UUID_TREE ROOT_ITEM 0) 
leaf 29802496 items 1 free space 16250 generation 10 owner 9
fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
	item 0 key (0x4449e807166c32fb UUID_KEY_SUBVOL 0x2c3260d85491a6ab) itemoff 16275 itemsize 8
		subvol_id 257
file tree key (257 ROOT_ITEM 10) 
leaf 29736960 items 2 free space 16061 generation 10 owner 257
fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		inode generation 3 transid 0 size 0 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0
		rdev 0 flags 0x0
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		inode ref index 0 namelen 2 name: ..
data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0) 
leaf 29442048 items 2 free space 16061 generation 4 owner 18446744073709551607
fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		inode generation 3 transid 0 size 0 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0
		rdev 0 flags 0x0
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		inode ref index 0 namelen 2 name: ..
total bytes 17178820608
bytes used 425984
uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
btrfs-progs v4.4+20160122

--gatW/ieO32f1wygP--
