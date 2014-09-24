Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:36654 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751932AbaIXSAD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 14:00:03 -0400
Received: from [IPv6:2601:e:1200:11d0:b2c5:54ff:feff:f401] ([IPv6:2601:e:1200:11d0:b2c5:54ff:feff:f401])
	(authenticated bits=0)
	by mail.nuclearwinter.com (8.14.4/8.14.4) with ESMTP id s8OI010w001647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Sep 2014 13:00:02 -0500
Message-ID: <542306A1.7050108@nuclearwinter.com>
Date: Wed, 24 Sep 2014 13:00:01 -0500
From: Larkin Lowrey <llowrey@nuclearwinter.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfsck check infinite loop
References: <5422D4E0.8090605@nuclearwinter.com> <5422E342.8060000@nuclearwinter.com>
In-Reply-To: <5422E342.8060000@nuclearwinter.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got past the loop issue with the larger cache_hard_max then hit:

repaired damaged extent references
Unable to find block group for 0
btrfs: extent-tree.c:288: find_search_start: Assertion `!(1)' failed.

Not sure what to try next. Ideas?

--Larkin

On 9/24/2014 10:29 AM, Larkin Lowrey wrote:
> I noticed the following:
>
> (gdb) print nrscan
> $19 = 1680726970
> (gdb) print tree->cache_size
> $20 = 1073741824
> (gdb) print cache_hard_max
> $21 = 1073741824
>
> It appears that cache_size can not shrink below cache_hard_max so we
> never end up breaking out of the loop. The FS in question is 30TB with
> ~26TB in use. Perhaps cache_hard_max (1GB) is too small for this size
> FS? I just bumped it to 2GB and am re-running to see if that helps.
>
> --Larkin
>
> On 9/24/2014 9:27 AM, Larkin Lowrey wrote:
>> I ran 'btrfs check --repair --init-extent-tree' and appear to be in an
>> infinite loop. It performed heavy IO for about 1.5 hours then the IO
>> stopped and the CPU stayed at 100%. It's been like that for more than 12
>> hours now.
>>
>> I made a hardware change last week that resulted in unstable RAM so I
>> suspect some corrupt data was written to disk. I tried mounting with
>> -orecovery,clear_cache,nospace_cache but I would get a panic shortly
>> thereafter. I tried 'btrfs check --repair' but also got a panic. I
>> finally tried 'btrfs check --repair --init-extent-tree' and hit an
>> assertion failed error with btrfs-progs 3.16.
>>
>> After noticing some promising commits, I built from the integration repo
>> (kdave), re-ran (v3.16.1) and got further (2hrs) but then got stuck in
>> this infinite loop.
>>
>> Here's the backtrace of where it is now and has been for hours:
>>
>> #0  0x0000000000438f01 in free_some_buffers (tree=0xda3078) at
>> extent_io.c:553
>> #1  __alloc_extent_buffer (blocksize=4096, bytenr=<optimized out>,
>> tree=0xda3078) at extent_io.c:592
>> #2  alloc_extent_buffer (tree=0xda3078, bytenr=<optimized out>,
>> blocksize=4096) at extent_io.c:671
>> #3  0x000000000042be29 in btrfs_find_create_tree_block
>> (root=root@entry=0xda34a0, bytenr=<optimized out>, blocksize=<optimized
>> out>) at disk-io.c:133
>> #4  0x000000000042d683 in read_tree_block (root=0xda34a0,
>> bytenr=<optimized out>, blocksize=<optimized out>,
>> parent_transid=161580) at disk-io.c:260
>> #5  0x0000000000427c58 in read_node_slot (root=root@entry=0xda34a0,
>> parent=parent@entry=0x165ab88c0, slot=slot@entry=43) at ctree.c:634
>> #6  0x0000000000428558 in push_leaf_right (trans=trans@entry=0xe709b0,
>> root=root@entry=0xda34a0, path=path@entry=0xde317a0,
>> data_size=data_size@entry=67, empty=empty@entry=0)
>>     at ctree.c:1608
>> #7  0x0000000000428e4c in split_leaf (trans=trans@entry=0xe709b0,
>> root=root@entry=0xda34a0, ins_key=ins_key@entry=0x7fff24da24b0,
>> path=path@entry=0xde317a0,
>>     data_size=data_size@entry=67, extend=extend@entry=0) at ctree.c:1977
>> #8  0x000000000042aa54 in btrfs_search_slot (trans=0xe709b0,
>> root=root@entry=0xda34a0, key=key@entry=0x7fff24da24b0,
>> p=p@entry=0xde317a0, ins_len=ins_len@entry=67,
>>     cow=cow@entry=1) at ctree.c:1120
>> #9  0x000000000042af51 in btrfs_insert_empty_items
>> (trans=trans@entry=0xe709b0, root=root@entry=0xda34a0,
>> path=path@entry=0xde317a0, cpu_key=cpu_key@entry=0x7fff24da24b0,
>>     data_size=data_size@entry=0x7fff24da24a0, nr=nr@entry=1) at ctree.c:2412
>> #10 0x00000000004175f6 in btrfs_insert_empty_item (data_size=42,
>> key=0x7fff24da24b0, path=0xde317a0, root=0xda34a0, trans=0xe709b0) at
>> ctree.h:2312
>> #11 record_extent (flags=0, allocated=<optimized out>, back=0x95cb3d90,
>> rec=0x95cb3cc0, path=0xde317a0, info=0xda3010, trans=0xe709b0) at
>> cmds-check.c:4438
>> #12 fixup_extent_refs (trans=trans@entry=0xe709b0, info=<optimized out>,
>> extent_cache=extent_cache@entry=0x7fff24da2970,
>> rec=rec@entry=0x95cb3cc0) at cmds-check.c:5287
>> #13 0x000000000041ac01 in check_extent_refs
>> (extent_cache=0x7fff24da2970, root=<optimized out>, trans=<optimized
>> out>) at cmds-check.c:5511
>> #14 check_chunks_and_extents (root=root@entry=0xfa7c70) at cmds-check.c:5978
>> #15 0x000000000041bdd9 in cmd_check (argc=<optimized out>,
>> argv=<optimized out>) at cmds-check.c:6723
>> #16 0x0000000000404481 in main (argc=4, argv=0x7fff24da2fe0) at btrfs.c:247
>>
>> I checked node, node->next, node->next->next, node->next->prev, etc. and
>> saw no obvious loop, at least not in the immediate vicinity of node. The
>> value of node is different each time I check it.
>>
>> I'll periodically see the following backtrace:
>>
>> #0  __list_del (next=0x1326fe820, prev=0xda3088) at list.h:113
>> #1  list_move_tail (head=0xda3088, list=0x1514b40f0) at list.h:183
>> #2  free_some_buffers (tree=0xda3078) at extent_io.c:560
>> #3  __alloc_extent_buffer (blocksize=4096, bytenr=<optimized out>,
>> tree=0xda3078) at extent_io.c:592
>> #4  alloc_extent_buffer (tree=0xda3078, bytenr=<optimized out>,
>> blocksize=4096) at extent_io.c:671
>> #5  0x000000000042be29 in btrfs_find_create_tree_block
>> (root=root@entry=0xda34a0, bytenr=<optimized out>, blocksize=<optimized
>> out>) at disk-io.c:133
>> #6  0x000000000042d683 in read_tree_block (root=0xda34a0,
>> bytenr=<optimized out>, blocksize=<optimized out>,
>> parent_transid=161580) at disk-io.c:260
>> #7  0x0000000000427c58 in read_node_slot (root=root@entry=0xda34a0,
>> parent=parent@entry=0x165ab88c0, slot=slot@entry=43) at ctree.c:634
>> #8  0x0000000000428558 in push_leaf_right (trans=trans@entry=0xe709b0,
>> root=root@entry=0xda34a0, path=path@entry=0xde317a0,
>> data_size=data_size@entry=67, empty=empty@entry=0)
>>     at ctree.c:1608
>> #9  0x0000000000428e4c in split_leaf (trans=trans@entry=0xe709b0,
>> root=root@entry=0xda34a0, ins_key=ins_key@entry=0x7fff24da24b0,
>> path=path@entry=0xde317a0,
>>     data_size=data_size@entry=67, extend=extend@entry=0) at ctree.c:1977
>> #10 0x000000000042aa54 in btrfs_search_slot (trans=0xe709b0,
>> root=root@entry=0xda34a0, key=key@entry=0x7fff24da24b0,
>> p=p@entry=0xde317a0, ins_len=ins_len@entry=67,
>>     cow=cow@entry=1) at ctree.c:1120
>> #11 0x000000000042af51 in btrfs_insert_empty_items
>> (trans=trans@entry=0xe709b0, root=root@entry=0xda34a0,
>> path=path@entry=0xde317a0, cpu_key=cpu_key@entry=0x7fff24da24b0,
>>     data_size=data_size@entry=0x7fff24da24a0, nr=nr@entry=1) at ctree.c:2412
>> #12 0x00000000004175f6 in btrfs_insert_empty_item (data_size=42,
>> key=0x7fff24da24b0, path=0xde317a0, root=0xda34a0, trans=0xe709b0) at
>> ctree.h:2312
>> #13 record_extent (flags=0, allocated=<optimized out>, back=0x95cb3d90,
>> rec=0x95cb3cc0, path=0xde317a0, info=0xda3010, trans=0xe709b0) at
>> cmds-check.c:4438
>> #14 fixup_extent_refs (trans=trans@entry=0xe709b0, info=<optimized out>,
>> extent_cache=extent_cache@entry=0x7fff24da2970,
>> rec=rec@entry=0x95cb3cc0) at cmds-check.c:5287
>> #15 0x000000000041ac01 in check_extent_refs
>> (extent_cache=0x7fff24da2970, root=<optimized out>, trans=<optimized
>> out>) at cmds-check.c:5511
>> #16 check_chunks_and_extents (root=root@entry=0xfa7c70) at cmds-check.c:5978
>> #17 0x000000000041bdd9 in cmd_check (argc=<optimized out>,
>> argv=<optimized out>) at cmds-check.c:6723
>> #18 0x0000000000404481 in main (argc=4, argv=0x7fff24da2fe0) at btrfs.c:247
>>
>> If there's interest in debugging I can leave this machine in this
>> condition for a few days. It's just a backup server so losing the fs
>> won't be the end of the world.
>>
>> --Larkin
>>

