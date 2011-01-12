From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH V3 1/6] btrfs: fix wrong data space statistics
Date: Wed, 12 Jan 2011 08:49:20 -0500
Message-ID: <20110112134919.GB2645@localhost.localdomain>
References: <4D2442D3.6050906@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2442D3.6050906@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 05, 2011 at 06:07:15PM +0800, Miao Xie wrote:
> Josef has implemented mixed data/metadata chunks, we must add those chunks'
> space just like data chunks.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef

> ---
>  fs/btrfs/super.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 61bd79a..1d21208 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -768,11 +768,10 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(found, head, list) {
> -		if (found->flags & (BTRFS_BLOCK_GROUP_METADATA |
> -				    BTRFS_BLOCK_GROUP_SYSTEM))
> -			total_used_data += found->disk_total;
> -		else
> +		if (found->flags & BTRFS_BLOCK_GROUP_DATA)
>  			total_used_data += found->disk_used;
> +		else
> +			total_used_data += found->disk_total;
>  		total_used += found->disk_used;
>  	}
>  	rcu_read_unlock();
> -- 
> 1.7.2.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
