Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45617 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbeISFeR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 01:34:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id i26-v6so1757881pfo.12
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 16:59:14 -0700 (PDT)
Date: Tue, 18 Sep 2018 16:59:13 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 16/36] btrfs: run delayed iputs before committing
Message-ID: <20180918235913.GD479@vader>
References: <20180911175807.26181-1-josef@toxicpanda.com>
 <20180911175807.26181-17-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911175807.26181-17-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 01:57:47PM -0400, Josef Bacik wrote:
> Delayed iputs means we can have final iputs of deleted inodes in the
> queue, which could potentially generate a lot of pinned space that could
> be free'd.  So before we decide to commit the transaction for ENOPSC
> reasons, run the delayed iputs so that any potential space is free'd up.
> If there is and we freed enough we can then commit the transaction and
> potentially be able to make our reservation.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 76941fc5af79..57567d013447 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4823,6 +4823,15 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  	if (!bytes)
>  		return 0;
>  
> +	/*
> +	 * If we have pending delayed iputs then we could free up a bunch of
> +	 * pinned space, so make sure we run the iputs before we do our pinned
> +	 * bytes check below.
> +	 */
> +	mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
> +	btrfs_run_delayed_iputs(fs_info);
> +	mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
> +
>  	trans = btrfs_join_transaction(fs_info->extent_root);
>  	if (IS_ERR(trans))
>  		return -ENOSPC;
> -- 
> 2.14.3
> 
