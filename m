Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33145 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286AbbDUV4T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 17:56:19 -0400
Received: by lbbzk7 with SMTP id zk7so166237841lbb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2015 14:56:17 -0700 (PDT)
MIME-Version: 1.0
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Tue, 21 Apr 2015 23:55:56 +0200
Message-ID: <CAJF-kYmLtMq-7aVqJb_onD3Nv=AQadScZ=0pm7wRSLfebFA0+A@mail.gmail.com>
Subject: Carefully crafted BTRFS-image causes userland tools to crash
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

See also https://bugzilla.kernel.org/show_bug.cgi?id=97031

The btrfs-image attached to this bug causes the userland tools v3.19.1
to crash with a SIGFPE. The problem is that map->stripe_len in
__btrfs_map_block() is allowed to be 0 before entering a division.

The userland tool crashes.
The kernel fails to mount with
> BTRFS: failed to read the system array on loop0
> BTRFS: open_ctree_failed



(gdb) run check btrfs_fukked_sigfpe_volumes:1372.bin
....
warning, device 0 is missing
warning, device 4294967295 is missing
warning, device 0 is missing
warning, device 0 is missing
warning, device 0 is missing
warning, device 0 is missing
warning, device 4294967295 is missing

Program received signal SIGFPE, Arithmetic exception.
0x000000000044d56f in __btrfs_map_block (map_tree=map_tree@entry=0x88c170,
    rw=rw@entry=0, logical=<optimized out>, length=length@entry=0x7fffffffd8f0,
    type=type@entry=0x0, multi_ret=multi_ret@entry=0x7fffffffd8e8, mirror_num=0,
    raid_map_ret=0x0) at volumes.c:1372
1372 stripe_nr = stripe_nr / map->stripe_len;
(gdb) bt
#0  0x000000000044d56f in __btrfs_map_block (map_tree=map_tree@entry=0x88c170,
    rw=rw@entry=0, logical=<optimized out>, length=length@entry=0x7fffffffd8f0,
    type=type@entry=0x0, multi_ret=multi_ret@entry=0x7fffffffd8e8, mirror_num=0,
    raid_map_ret=0x0) at volumes.c:1372
#1  0x000000000044db45 in btrfs_map_block (map_tree=map_tree@entry=0x88c170,
    rw=rw@entry=0, logical=<optimized out>, length=length@entry=0x7fffffffd8f0,
    multi_ret=multi_ret@entry=0x7fffffffd8e8, mirror_num=mirror_num@entry=0,
    raid_map_ret=0x0) at volumes.c:1291
#2  0x000000000043b22d in read_whole_eb (info=0x88c010, eb=eb@entry=0x88f400,
    mirror=mirror@entry=0) at disk-io.c:232
#3  0x000000000043caa2 in read_tree_block (root=root@entry=0x88c710,
    bytenr=<optimized out>, blocksize=<optimized out>, parent_transid=5)
    at disk-io.c:295
#4  0x000000000043d5df in btrfs_setup_chunk_tree_and_device_map (
    fs_info=fs_info@entry=0x88c010) at disk-io.c:1106
#5  0x000000000043d7d1 in __open_ctree_fd (fp=fp@entry=3,
    path=path@entry=0x7fffffffe1fa "btrfs_fukked_sigfpe_volumes:1372.bin",
    sb_bytenr=65536, sb_bytenr@entry=0,
root_tree_bytenr=root_tree_bytenr@entry=0,
    flags=flags@entry=OPEN_CTREE_EXCLUSIVE) at disk-io.c:1190
#6  0x000000000043d965 in open_ctree_fs_info (
    filename=0x7fffffffe1fa "btrfs_fukked_sigfpe_volumes:1372.bin",
    sb_bytenr=sb_bytenr@entry=0, root_tree_bytenr=root_tree_bytenr@entry=0,
    flags=flags@entry=OPEN_CTREE_EXCLUSIVE) at disk-io.c:1231
#7  0x0000000000427bf5 in cmd_check (argc=1, argv=0x7fffffffde90) at
cmds-check.c:9326
#8  0x000000000040e5a2 in main (argc=2, argv=0x7fffffffde90) at btrfs.c:245
(gdb) p map->stripe_len
$1 = 0
