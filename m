Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38584 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727233AbeHaMBg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 08:01:36 -0400
Subject: Re: [PATCH 15/35] btrfs: run delayed iputs before committing
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-16-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <31a5f6cf-f69f-e624-04d5-124e90fe02a4@suse.com>
Date: Fri, 31 Aug 2018 10:55:22 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-16-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> We want to have a complete picture of any delayed inode updates before
> we make the decision to commit or not, so make sure we run delayed iputs
> before making the decision to commit or not.

Again, there was request for more detail which is not addressed:

https://www.spinics.net/lists/linux-btrfs/msg81237.html

> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 7c0e99e1f56c..064db7ebaf67 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4831,6 +4831,10 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  		goto commit;
>  	}
>  
> +	mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
> +	btrfs_run_delayed_iputs(fs_info);
> +	mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
> +
>  	spin_lock(&delayed_rsv->lock);
>  	reclaim_bytes += delayed_rsv->reserved;
>  	spin_unlock(&delayed_rsv->lock);
> 
