From: Li Dongyang <lidongyang@novell.com>
Subject: Re: [PATCH 2/2] Btrfs: fix space leak when trimming free extents
Date: Tue, 21 Jun 2011 17:45:03 +0800
Message-ID: <201106211745.03356.lidongyang@novell.com>
References: <4E0030DF.4080704@cn.fujitsu.com> <4E003112.9050702@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E003112.9050702@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, June 21, 2011 01:50:10 PM Li Zefan wrote:
> When the end of an extent exceeds the end of the specified range,
> the extent will be accidentally truncated.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/btrfs/free-space-cache.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 292c0d9..185cf8e 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -2509,8 +2509,15 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
>  			bytes = min(entry->bytes, end - start);
>  			if (bytes < minlen)
>  				goto next;
> +
>  			unlink_free_space(ctl, entry);
> -			kmem_cache_free(btrfs_free_space_cachep, entry);
> +			if (bytes < entry->bytes) {
> +				entry->offset = entry->offset + bytes;
> +				entry->bytes = entry->bytes - bytes;
> +				link_free_space(ctl, entry);
yes, I forgot to link the rest extent to the free space cache.
Thanks for the fix!
> +			} else {
> +				kmem_cache_free(btrfs_free_space_cachep, entry);
> +			}
>  		}
>  
>  		spin_unlock(&ctl->tree_lock);
> -- 1.7.3.1 
> 
