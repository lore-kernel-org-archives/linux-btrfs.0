From: Li Dongyang <lidongyang@novell.com>
Subject: Re: [PATCH] btrfs: fix crash when no drive supports DISCARD
Date: Wed, 18 May 2011 11:29:14 +0800
Message-ID: <201105181129.14201.lidongyang@novell.com>
References: <20110517152743.GU12709@twin.jikos.cz> <1305648031-26379-1-git-send-email-dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	stable@kernel.org
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305648031-26379-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, May 18, 2011 12:00:31 AM David Sterba wrote:
> xfstests/013 crashes when the test partition is mounted with -o discard:
> 
> walk_up_log_tree
>   btrfs_free_reserved_extent
>     btrfs_discard_extent
>       return -EOPNOTSUPP
>     BUG_ON ret
> 
> btrfs_discard_extent() should be fine when drive does not support the
> DISCARD operation and filter the EOPNOTSUPP retcode, but currently it
> does this only when some bytes were succesfully discarded.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> CC: stable@kernel.org
> ---
>  fs/btrfs/extent-tree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9ee6bd5..feab2ab 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -1790,7 +1790,7 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
>  		}
>  		kfree(multi);
>  	}
> -	if (discarded_bytes && ret == -EOPNOTSUPP)
> +	if (ret == -EOPNOTSUPP)
>  		ret = 0;
>  
>  	if (actual_bytes)
> 
Thanks for the fix, I thought EOPNOTSUPP could be useful by the caller that time, and maybe we could do somthing
like remove the discard mount_opt in the fs_info so we can avoid calling it again.
