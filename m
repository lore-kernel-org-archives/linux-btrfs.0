From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 1/1] btrfs: add missing spin_unlock to a rare exit path
Date: Thu, 21 Apr 2011 09:02:32 +0800
Message-ID: <4DAF8228.2080402@cn.fujitsu.com>
References: <1303302855-23093-1-git-send-email-dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303302855-23093-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Good catch!

thanks,
liubo

On 04/20/2011 08:34 PM, David Sterba wrote:
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/disk-io.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5e5d07c..25e4b8f 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2825,6 +2825,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  
>  	spin_lock(&delayed_refs->lock);
>  	if (delayed_refs->num_entries == 0) {
> +		spin_unlock(&delayed_refs->lock);
>  		printk(KERN_INFO "delayed_refs has NO entry\n");
>  		return ret;
>  	}

