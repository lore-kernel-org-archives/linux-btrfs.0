Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751147AbdJKHvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 03:51:05 -0400
Date: Wed, 11 Oct 2017 09:50:58 +0200
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] blkcg: export blkcg_root_css
Message-ID: <20171011075058.GH3667@quack2.suse.cz>
References: <20171010155441.753966-1-tj@kernel.org>
 <20171010155441.753966-2-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171010155441.753966-2-tj@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 10-10-17 08:54:37, Tejun Heo wrote:
> Export blkcg_root_css so that filesystem modules can use it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/blk-cgroup.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index d3f56ba..597a457 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -45,6 +45,7 @@ struct blkcg blkcg_root;
>  EXPORT_SYMBOL_GPL(blkcg_root);
>  
>  struct cgroup_subsys_state * const blkcg_root_css = &blkcg_root.css;
> +EXPORT_SYMBOL_GPL(blkcg_root_css);
>  
>  static struct blkcg_policy *blkcg_policy[BLKCG_MAX_POLS];
>  
> -- 
> 2.9.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
