Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54801 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755808AbeE2BGV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 21:06:21 -0400
Date: Tue, 29 May 2018 09:06:14 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Nikolay Borisov <nborisov@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/11] Summer argument cleanup
Message-ID: <20180529010613.GA27632@fnst.localdomain>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 28, 2018 at 09:36:39AM +0300, Nikolay Borisov wrote:
>Hello, 
>
>Here is yet another series removing a bunch of extraneous argument. The series 
>constitutes no functional changes. Some of the function actually have a kernel 
>counterpart (btrfs_lookup_extent_info/clean_tree_block). However the former's 
>userspace signature differs and the patch in this series makes it identical to 
>the kernel one. 

This series looks good to me.

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

-- 
Thanks,
Lu

>
>Nikolay Borisov (11):
>  btrfs-progs: check: Remove root argument from delete_extent_records
>  btrfs-progs: check: Remove root parameter from
>    btrfs_fix_block_accounting
>  btrfs-progs: check: Remove root parameter from del_pending_extents
>  btrfs-progs: check: Remove root argument from finish_current_insert
>  btrfs-progs: check: Make update_pinned_extents take btrfs_fs_info
>  btrfs-progs: Remove unused argument from clean_tree_block
>  btrfs-progs: check: Remove unused root argument from
>    btrfs_extent_post_op
>  btrfs-progs: Change btrfs_root to btrfs_fs_info argument in
>    btrfs_lookup_extent_info
>  btrfs-progs: Remove root argument from btrfs_set_block_flags
>  btrfs-progs: Remove root argument from write_one_cache_group
>  btrfs-progs: Remove fs_info argument from write_ctree_super
>
> check/main.c        |  31 +++++++-------
> check/mode-lowmem.c |   6 +--
> ctree.c             |  17 ++++----
> ctree.h             |  13 +++---
> disk-io.c           |   9 ++--
> disk-io.h           |   6 +--
> extent-tree.c       | 121 ++++++++++++++++++++++++----------------------------
> free-space-tree.c   |   2 +-
> transaction.c       |   2 +-
> 9 files changed, 96 insertions(+), 111 deletions(-)
>
>-- 
>2.7.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


