Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40756 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750891AbdE2SIV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 14:08:21 -0400
Date: Mon, 29 May 2017 20:07:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 00/32] btrfs_fs_info refactoring
Message-ID: <20170529180720.GU14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 18, 2017 at 11:38:25AM +0800, Qu Wenruo wrote:
> The patchset can be fetched from my github:
> https://github.com/adam900710/btrfs-progs/tree/fs_info_refactor
> 
> Which is based on v4.11-rc1.
> 
> This quite scary patchset does a large refactoring (while still less than
> 500 LoC) to move sector/node/stripe size members from btrfs_root to
> btrfs_fs_info.
> (Patch 2~29)
> 
> Also, refactor some functions which only uses btrfs_root parameter for
> block sizes. (Path 30~32)
> Refactored functions are:
> 1) read_tree_block() in disk-io.c
> 2) corrupt_keys() in btrfs-corrupt-block.c
> 3) corrupt_metadata_block() in btrfs-corrupt-block.c
> 4) read_node_slot() in ctree.c
> 
> Such refactoring has already been done in kernel for some time.
> 
> I'm pretty sure there are still quite some remaining, but I'd like to
> put them after this large patchset get merged.
> 
> I have run test-fsck, test-convert (despite the quotation error) and
> test-misc. They all finished without problem.
> 
> Despite the refactoring, I also synchronized the definition of
> btrfs_super_block, to make leafsize deprecated.
> (Patch 1)
> 
> And less than 3 open-coded round_up are also refactored to round_up()
> macro.
> 
> Qu Wenruo (32):
>   btrfs-progs: Remove deprecated leafsize usage
>   btrfs-progs: Introduce sectorsize nodesize and stripesize members for
>     btrfs_fs_info
>   btrfs-progs: Refactor block sizes users in disk-io.c
>   btrfs-progs: Refactor block sizes users in btrfs-corrupt-block.c
>   btrfs-progs: Refactor block sizes users in ctree.c and ctree.h
>   btrfs-progs: Refactor block sizes users in btrfs-map-logical.c
>   btrfs-progs: Refactor block sizes users in chunk-recover.c
>   btrfs-progs: Refactor block sizes users in backref.c
>   btrfs-progs: Refactor block sizes users in cmds-restore.c
>   btrfs-progs: Refactor nodesize user in extent_io.c
>   btrfs-progs: Refactor nodesize users in image/main.c
>   btrfs-progs: Refactor block sizes users in cmds-check.c
>   btrfs-progs: Refactor nodesize user in btrfstune.c
>   btrfs-progs: Refactor nodesize users in utils.c
>   btrfs-progs: Refactor block sizes users in extent-tree.c
>   btrfs-progs: Refactor nodesize user in print-tree.c
>   btrfs-progs: Refactor nodesize users in qgroup-verify.c
>   btrfs-progs: Refactor nodesize users in cmds-inspect-tree-stats.c
>   btrfs-progs: Refactor sectorsize users in mkfs/main.c
>   btrfs-progs: Refactor sectorsizes users in file-item.c
>   btrfs-progs: Refactor sectorsize users in free-space-cache.c
>   btrfs-progs: Refactor sectorsize users in file.c
>   btrfs-progs: Refactor sectorsize users in volumes.c
>   btrfs-progs: Refactor sectorsize users in free-space-tree.c
>   btrfs-progs: Refactor sectorsize in convert/source-fs.c
>   btrfs-progs: Refactor sectorsize users in convert/main.c
>   btrfs-progs: Refactor sectorsize users in convert/source-ext2.c
>   btrfs-progs: Refactor sectorsize users in cmds-inspect-dump-tree.c
>   btrfs-progs: Remove block size members in btrfs_root
>   btrfs-progs: Refactor btrfs_root paramters in btrfs-corrupt-block.c
>   btrfs-progs: Refactor read_tree_block to get rid of btrfs_root
>   btrfs-progs: Refactor read_node_slot function to get rid of btrfs_root
>     parameter

Applied, thanks.
