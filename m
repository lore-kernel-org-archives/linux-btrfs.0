Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41151 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbdFGUYH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 16:24:07 -0400
Date: Wed, 7 Jun 2017 13:22:04 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        kernel-team@fb.com
Subject: Re: [PATCH 7/7] Btrfs: warn if total_bytes_pinned is non-zero on
 unmount
Message-ID: <20170607202204.GD16793@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1496792333.git.osandov@fb.com>
 <0a015ca3c5d799b501b9c23475ed9e96d16de671.1496792333.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0a015ca3c5d799b501b9c23475ed9e96d16de671.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 04:45:32PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Catch any future/remaining leaks or underflows of total_bytes_pinned.
>

This might be a little bit late, what about checking it after
btrfs_finish_extetn_commit()?

-liubo

> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 75ad24f8d253..5fb2fb27eda6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9860,6 +9860,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
>  			    space_info->bytes_reserved > 0 ||
>  			    space_info->bytes_may_use > 0))
>  			dump_space_info(info, space_info, 0, 0);
> +		WARN_ON(percpu_counter_sum(&space_info->total_bytes_pinned) != 0);
>  		list_del(&space_info->list);
>  		for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
>  			struct kobject *kobj;
> -- 
> 2.13.0
> 
