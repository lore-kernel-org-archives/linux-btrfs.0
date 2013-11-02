Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46063 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3KBQ7M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 12:59:12 -0400
Date: Sat, 2 Nov 2013 09:59:04 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com, linux-btrfs@vger.kernel.org,
        Zach Brown <zab@redhat.com>
Subject: Re: [OPW kernel] [PATCH v3] btrfs: Add helper function for
 free_root_pointers()
Message-ID: <20131102165904.GH15704@leaf>
References: <20131030204834.GA20844@gmail.com>
 <1383167720-24201-1-git-send-email-rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383167720-24201-1-git-send-email-rashika.kheria@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 31, 2013 at 02:45:20AM +0530, Rashika Kheria wrote:
> The function free_root_pointers() in disk-io.h contains redundant code.
> Therefore, this patch adds a helper function free_root_extent_buffers()
> to free_root_pointers() to eliminate redundancy.
> 
> Reviewed-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

(In general, the Reviewed-by goes after the Signed-off-by.)

One minor nit:

> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2012,50 +2012,28 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
>  	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
>  }
>  
> +static void free_root_extent_buffers(struct btrfs_root *root)
> +{
> +	if (root) {
> +		free_extent_buffer(root->node);
> +		free_extent_buffer(root->commit_root);
> +		root->node = NULL;
> +		root->commit_root = NULL;
> +	}
> +}

I'd tend to write this with an early return if (!root).  In this case it
doesn't matter much, but it's a good habit to get into for larger
functions with deeper indentation.

- Josh Triplett
