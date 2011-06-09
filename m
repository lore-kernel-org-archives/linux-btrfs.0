From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH] Btrfs: fix extent state leak on failed nodatasum reads
Date: Thu, 09 Jun 2011 18:16:06 +0200
Message-ID: <4DF0F1C6.7040800@jan-o-sch.net>
References: <1304518730-13909-1-git-send-email-list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304518730-13909-1-git-send-email-list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On 04.05.2011 16:18, Jan Schmidt wrote:
> When encountering an EIO while reading from a nodatasum extent, we
> insert an error record into the inode's failure tree.
> btrfs_readpage_end_io_hook returns early for nodatasum inodes. We'd
> better clear the failure tree in that case, otherwise the kernel
> complains about
> 
> 	BUG extent_state: Objects remaining on kmem_cache_close()
> 
> on rmmod.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 870869a..9444551 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1970,7 +1970,7 @@ static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
>  	}
>  
>  	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
> -		return 0;
> +		goto good;
>  
>  	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
>  	    test_range_bit(io_tree, start, end, EXTENT_NODATASUM, 1, NULL)) {

was there a specific reason for not pulling this one in? I find it neat,
straight forward and quite to the point ;-)

Just ran into that bug again and had to trace it down once more after I
rebased my upcoming patches to the for-linus branch... (Hey, it's been a
month!)

-Jan
