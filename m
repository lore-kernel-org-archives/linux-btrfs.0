Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36292 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726905AbeGUC7K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 22:59:10 -0400
Date: Sat, 21 Jul 2018 10:08:05 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Nikolay Borisov <nborisov@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/7] fs_info cleanups for volume.c
Message-ID: <20180721020805.GB575@fnst.localdomain>
References: <1532104673-28311-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1532104673-28311-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2018 at 07:37:46PM +0300, Nikolay Borisov wrote:
>Here are a bunch of patches which cleanup extraneous fs_info parameters to 
>function which already take a structure that holds a reference to the fs_info. 
>
>Except for patches 4 and 5, everything else is correct - due to those functions
>always taking a transaction. 4 and 5 in turn reference the fs_info from 
>struct btrfs_device. Inspecting the callers I managed to convince myself that 
>those function are always called with well-formed btrfs_device i.e one which 
>has its fs_info member initialised. Reviewers might want to pay extra 
>attention to that but otherwise they are trivial. 
>
>Nikolay Borisov (7):
>  btrfs: Remove fs_info argument from btrfs_add_dev_item
>  btrfs: Remove fs_info from btrfs_rm_dev_replace_remove_srcdev
>  btrfs: remove fs_info argument from update_dev_stat_item
>  btrfs: Remove fs_info from btrfs_assign_next_active_device
>  btrfs: Remove fs_info from btrfs_destroy_dev_replace_tgtdev
>  btrfs: Remove fs_info form btrfs_free_chunk
>  btrfs: Remove fs_info from btrfs_finish_chunk_alloc

The series looks good to me.

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

-- 
Thanks,
Lu

>
> fs/btrfs/dev-replace.c | 10 +++++-----
> fs/btrfs/extent-tree.c |  5 ++---
> fs/btrfs/volumes.c     | 49 +++++++++++++++++++++++--------------------------
> fs/btrfs/volumes.h     | 16 ++++++----------
> 4 files changed, 36 insertions(+), 44 deletions(-)
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


