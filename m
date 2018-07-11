Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37560 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbeGKEl4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 00:41:56 -0400
Date: Tue, 10 Jul 2018 21:39:28 -0700
From: Marc MERLIN <marc@merlins.org>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        Su Yue <Damenly_Su@gmx.com>
Message-ID: <20180711043928.itffs2kt52rbatsx@merlins.org>
References: <20180710180915.onnxuak7vb7uywyn@merlins.org>
 <9afce26c-0a3f-3389-ba0f-597b26a8cd7e@cn.fujitsu.com>
 <20180711005852.prhnmohkzjplw54j@merlins.org>
 <9b612c36-f59c-b4c7-bb84-4a30c4a7d453@cn.fujitsu.com>
 <20180711014401.hic5vcp5h2tzgyxh@merlins.org>
 <9b0990aa-05aa-3e0e-463f-b4eb9894dc81@cn.fujitsu.com>
 <20180711033614.glhs2yt53napbrpr@merlins.org>
 <e8e4b853-a20d-cd55-550e-2f2263d1984e@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e8e4b853-a20d-cd55-550e-2f2263d1984e@cn.fujitsu.com>
Subject: Re: btrfs check lowmem, take 2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 11, 2018 at 12:07:05PM +0800, Su Yue wrote:
> > So, I went back to https://github.com/Damenly/btrfs-progs.git/tmp1 and
> > I'm running it without the extra options you added with hardcoded stuff:
> > gargamel:/var/local/src/btrfs-progs.sy-test# ./btrfsck --mode=lowmem --repair /dev/mapper/dshelf2
> > 
> This is okay. Let's wait to see the result.

Sadly, it crashes quickly:

Starting program: /var/local/src/btrfs-progs.sy-test/btrfs check --mode=lowmem --repair /dev/mapper/dshelf2
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
enabling repair mode
WARNING: low-memory mode repair support is only partial
 Checking filesystem on /dev/mapper/dshelf2
UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
checking extents

Program received signal SIGSEGV, Segmentation fault.
check_tree_block_backref (fs_info=fs_info@entry=0x555555825e10, 
    root_id=root_id@entry=18446744073709551607, bytenr=bytenr@entry=655589376, level=level@entry=1)
    at check/mode-lowmem.c:3744
3744		if (btrfs_header_bytenr(node) != bytenr) {
(gdb)  bt
#0  check_tree_block_backref (fs_info=fs_info@entry=0x555555825e10, 
    root_id=root_id@entry=18446744073709551607, bytenr=bytenr@entry=655589376, level=level@entry=1)
    at check/mode-lowmem.c:3744
#1  0x00005555555cb1f9 in check_extent_item (fs_info=fs_info@entry=0x555555825e10, 
    path=path@entry=0x7fffffffdc60) at check/mode-lowmem.c:4194
#2  0x00005555555d06e9 in check_leaf_items (account_bytes=1, nrefs=0x7fffffffdb80, 
    path=0x7fffffffdc60, root=0x5555558262f0) at check/mode-lowmem.c:4654
#3  walk_down_tree (check_all=1, nrefs=0x7fffffffdb80, level=<synthetic pointer>, 
    path=0x7fffffffdc60, root=0x5555558262f0) at check/mode-lowmem.c:4790
#4  check_btrfs_root (root=root@entry=0x5555558262f0, check_all=check_all@entry=1)
    at check/mode-lowmem.c:5114
#5  0x00005555555d144f in check_chunks_and_extents_lowmem (fs_info=fs_info@entry=0x555555825e10)
    at check/mode-lowmem.c:5475
#6  0x00005555555b44b1 in do_check_chunks_and_extents (fs_info=0x555555825e10) at check/main.c:8369
#7  cmd_check (argc=<optimized out>, argv=<optimized out>) at check/main.c:9899
#8  0x0000555555567510 in main (argc=4, argv=0x7fffffffe390) at btrfs.c:302


Would you like anything off gdb? (feel free to Email me directly or
point me to an online chat platform you have access to)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
