Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50677 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752284AbdIGQlL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Sep 2017 12:41:11 -0400
Date: Thu, 7 Sep 2017 18:39:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fnstml-btrfs@cn.fujitsu.com,
        zhangyu-fnst@cn.fujitsu.com
Subject: Re: [PATCH v2] btrfs-progs: print: Check on num_stripes in
 print_chunk
Message-ID: <20170907163942.GB31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170907022825.19334-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170907022825.19334-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 07, 2017 at 10:28:25AM +0800, Su Yue wrote:
> From: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>
> 
> In fuzz-tests/004-simple-dump-tree:
> Since there is one wrong item(DATA_RELOC_TREE CHUNK_ITEM 0) in root
> tree.
> It fails as follow:
> 
> ctree.h:317: btrfs_chunk_item_size: BUG_ON `num_stripes == 0` triggered, value 1
> btrfs-progs/btrfs(+0x2496f)[0x564a031e996f]
> btrfs-progs/btrfs(print_chunk+0x20f)[0x564a031ea091]
> btrfs-progs/btrfs(btrfs_print_leaf+0xfcb)[0x564a031ebaea]
> btrfs-progs/btrfs(btrfs_print_tree+0x3d)[0x564a031ec311]
> btrfs-progs/btrfs(cmd_inspect_dump_tree+0x4e6)[0x564a0323a6e1]
> btrfs-progs/btrfs(handle_command_group+0x44)[0x564a031d6414]
> btrfs-progs/btrfs(cmd_inspect+0x15)[0x564a03211b98]
> btrfs-progs/btrfs(main+0x88)[0x564a031d65d0]
> /usr/lib/libc.so.6(__libc_start_main+0xea)[0x7f2c7fa584ca]
> btrfs-progs/btrfs(_start+0x2a)[0x564a031d616a]
>         item 8 key (DATA_RELOC_TREE CHUNK_ITEM 0) itemoff 1574 itemsize 439
> failed (ignored, ret=134): btrfs-progs/btrfs inspect-internal dump-tree btrfs-progs/tes\
> ts/fuzz-tests/images/bko-155201-wrong-chunk-item-in-root-tree.raw.restored
> mayfail: returned code 134 (SIGABRT), not ignored
> test failed for case 004-simple-dump-tree
> 
> Solve it by checking on num_stripes in print_chunk().
> 
> Signed-off-by: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>

Applied, thanks.
