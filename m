From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Spelling fix in btrfs code comment
Date: Mon, 11 May 2009 17:46:43 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0905111746100.22712@wotan.suse.de>
References: <1241867943.26731.5.camel@blr-psankar.blr.novell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	trivial@kernel.org
To: Sankar P <sankar.curiosity@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1241867943.26731.5.camel@blr-psankar.blr.novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 9 May 2009, Sankar P wrote:

> Fix a trivial spelling error in a comment
> 
> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
> 
> ---
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e496644..3e2c7c7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -312,7 +312,7 @@ btrfs_lookup_first_block_group(struct btrfs_fs_info *info, u64 bytenr)
>  }
>  
>  /*
> - * return the block group that contains teh given bytenr
> + * return the block group that contains the given bytenr
>   */
>  struct btrfs_block_group_cache *btrfs_lookup_block_group(
>  						 struct btrfs_fs_info *info,

Appplied to trivial tree. If it has been already applied to btrfs pileup, 
please let me know so that I could drop it.

Thanks,

-- 
Jiri Kosina
SUSE Labs
