From: Chris Mason <chris.mason@oracle.com>
Subject: Re: resize ate my root node
Date: Tue, 08 Mar 2011 16:40:20 -0500
Message-ID: <1299620014-sup-698@think>
References: <20110307174820.5100.qmail@stuge.se>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Peter Stuge <peter@stuge.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110307174820.5100.qmail@stuge.se>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Peter Stuge's message of 2011-03-07 12:48:20 -0500:
> Hi,
> 
> I ran btrfsctl resize -r -3gb /dev/sda2 using wireless-testing.git
> based on 2.6.38-rc6 and all seemed good. df reported reduced size so
> I repartitioned and rebooted. Filesystem can no longer be mounted:
> 
> [10560.129038] device fsid b2408c2e83f55cc2-5f7a14e35f176484 devid 1 transid 341132 /dev/sdb2
> [10560.133407] btrfs bad tree block start 0 34520006656
> [10560.134031] btrfs bad tree block start 0 34520006656
> [10560.134904] btrfs bad tree block start 0 34520006656
> [10560.134912] btrfs: failed to read tree root on sdb2
> [10560.137206] btrfs: open_ctree failed
> 
> btrfs-debug-tree and friends are similarly upset:

Ouch, sorry about this.  Do you have details on how big the FS was and
how big the partition was before the resize?

Have you tried using fdisk to bring the partition back to the original
size?

-chris

> 
> $ ./btrfs-debug-tree /dev/sdb2
> btrfs-debug-tree: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
> 
> $ gdb --args ./btrfs-debug-tree /dev/sdb2
> GNU gdb 6.8
> ..
> (gdb) b disk-io.c:44
> Breakpoint 1 at 0x8050db7: file disk-io.c, line 44.
> ..
> Breakpoint 1, check_tree_block (root=0x946e2e8, buf=0x9471538) at disk-io.c:44
> 44              if (buf->start != btrfs_header_bytenr(buf))
> (gdb) p buf->start
> $1 = 20971520
> ..
> Breakpoint 1, check_tree_block (root=0x946e2e8, buf=0x9472588) at disk-io.c:44
> 44              if (buf->start != btrfs_header_bytenr(buf))
> (gdb) p buf->start
> $2 = 20987904
> ..
> Breakpoint 1, check_tree_block (root=0x946e2e8, buf=0x94735d8) at disk-io.c:44
> 44              if (buf->start != btrfs_header_bytenr(buf))
> (gdb) p buf->start
> $3 = 20983808
> 
> The above checks succeed but next time check_tree_block() is called
> the check does not succeed.
> 
> Breakpoint 1, check_tree_block (root=0x946e008, buf=0x9474628) at disk-io.c:44
> 44              if (buf->start != btrfs_header_bytenr(buf))
> (gdb) p buf->start
> $4 = 34520006656
> (gdb) p btrfs_header_bytenr(buf)
> $5 = 0
> ..
> (gdb) bt
> #0  check_tree_block (root=0x946e008, buf=0x9474628) at disk-io.c:45
> #1  0x080514fc in read_tree_block (root=0x946e008, bytenr=34520006656, 
>     blocksize=4096, parent_transid=341132) at disk-io.c:207
> #2  0x080531a7 in open_ctree_fd (fp=7, path=0xbfef322a "/dev/sdb2", 
>     sb_bytenr=65536, writes=0) at disk-io.c:736
> #3  0x08052a58 in open_ctree (filename=0xbfef322a "/dev/sdb2", sb_bytenr=0, 
>     writes=0) at disk-io.c:587
> #4  0x080735cf in main (ac=1, av=0xbfef2374) at debug-tree.c:148
> 
> This is disk-io.c:
> 
> 732     blocksize = btrfs_level_size(tree_root,
>                                      btrfs_super_root_level(disk_super));  
>         generation = btrfs_super_generation(disk_super);  
> 
>         tree_root->node = read_tree_block(tree_root,
>                                           btrfs_super_root(disk_super),
>                                           blocksize, generation);
> ..
> 188     eb = btrfs_find_create_tree_block(root, bytenr, blocksize);
> ..
> 198             ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
>                                       eb->start, &length, &multi, mirror_num);
> ..
> 206             ret = read_extent_from_disk(eb);
>                 if (ret == 0 && check_tree_block(root, eb) == 0 &&
> 
> This is the call that fails.
> 
> 
> Where do I look next?
> 
> 
> //Peter
