From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: use do_div to avoid compile errors on 32bit box
Date: Sat, 20 Aug 2011 09:46:02 +0800
Message-ID: <4E4F11DA.5050209@cn.fujitsu.com>
References: <1313804076-30228-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com, dave@jikos.cz
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313804076-30228-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/20/2011 09:34 AM, Liu Bo wrote:
> When doing div operation of u64 type, we need to be careful and use do_div
> to avoid compile ERROR on 32bit box:
> 
> "ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 

Sorry, guys, I just sent a wrong version.

Plz ignore this one.  I'm sorry.

thanks,
liubo

> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 80d6148..9b495ce 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6796,14 +6796,14 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>  	index = get_block_group_index(block_group);
>  	if (index == 0) {
>  		dev_min = 4;
> -		min_free /= 2;
> +		do_div(min_free, 2);
>  	} else if (index == 1) {
>  		dev_min = 2;
>  	} else if (index == 2) {
>  		min_free *= 2;
>  	} else if (index == 3) {
>  		dev_min = fs_devices->rw_devices;
> -		min_free /= dev_min;
> +		do_div(min_free, dev_min);
>  	}
>  
>  	mutex_lock(&root->fs_info->chunk_mutex);

