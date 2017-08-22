Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43263 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932510AbdHVOOB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 10:14:01 -0400
Date: Tue, 22 Aug 2017 16:12:36 +0200
From: David Sterba <dsterba@suse.cz>
To: zhangyu-fnst@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Check root before printing item
Message-ID: <20170822141236.GX2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170821075713.32051-1-zhangyu-fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170821075713.32051-1-zhangyu-fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 03:57:13PM +0800, zhangyu-fnst@cn.fujitsu.com wrote:
> From: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>
> 
> [TEST/fuzz] case: 004-simple-dump-tree
> 
> Since the wrong key(DATA_RELOC_TREE CHUNK_ITEM 0) in root tree,
> error calling print_chunk(), resulting in num_stripes == 0.
> 
> ERROR:
>      [TEST/fuzz]   004-simple-dump-tree
> ctree.h:317: btrfs_chunk_item_size: BUG_ON `num_stripes == 0`
>         triggered, value 1
> 
> failed (ignored, ret=134): /myproject/btrfs-progs/btrfs
> inspect-internal dump-tree
> /myproject/btrfs-progs/tests/fuzz-tests/images/
> bko-155201-wrong-chunk-item-in-root-tree.raw.restored
> 
> test failed for case 004-simple-dump-tree
> Makefile:288: recipe for target 'test-fuzz' failed
> make: *** [test-fuzz] Error 1
> 
> So, before printing item, determine the root is valid or not.

I don't think this is the right way to fix it. The print-tree function
should print everything that's found, possibly doing sanity checks and
then only skip the bad data. For debugging or other purposes, we want to
get exact state of the trees.

The original problem you found is wrong number of stripes, so it should
be dealt with in print_chunk.
