Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35625 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753107AbdKFQDr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 11:03:47 -0500
Date: Mon, 6 Nov 2017 17:01:55 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: fix reported number of inode blocks after
 buffered append writes
Message-ID: <20171106160155.GN28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171031185612.30800-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171031185612.30800-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 06:56:12PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The patch from commit 7e3b975a0f92 ("Btrfs: fix reported number of inode

The commit id should be a7e3b975a0f9, looks like a typo, missing 'a' at
the beginning.

> blocks") introduced a regression where if we do a buffered write starting
> at position equal to or greater than the file's size and then stat(2) the
> file before writeback is triggered, the number of used blocks does not
> change (unless there's a prealloc/unwritten extent). Example:
> 
>   $ xfs_io -f -c "pwrite -S 0xab 0 64K" foobar
>   $ du -h foobar
>   0	foobar
>   $ sync
>   $ du -h foobar
>   64K	foobar
> 
> The first version of that patch didn't had this regression and the second
> version, which was the one committed, was made only to address some
> performance regression detected by the intel test robots using fs_mark.
> 
> This fixes the regression by setting the new delaloc bit in the range, and
> doing it at btrfs_dirty_pages() while setting the regular dealloc bit as
> well, so that this way we set both bits at once avoiding navigation of the
> inode's io tree twice. Doing it at btrfs_dirty_pages() is also the most
> meaninful place, as we should set the new dellaloc bit when if we set the
> delalloc bit, which happens only if we copied bytes into the pages at
> __btrfs_buffered_write().
> 
> This was making some of LTP's du tests fail, which can be quickly run
> using a command line like the following:
> 
>   $ ./runltp -q -p -l /ltp.log -f commands -s du -d /mnt
> 
> Fixes: 7e3b975a0f92 ("Btrfs: fix reported number of inode blocks")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/ctree.h                 |   1 +
>  fs/btrfs/extent_io.h             |   5 +-
>  fs/btrfs/file.c                  | 123 +++++++++++++++++++++------------------
>  fs/btrfs/inode.c                 |   9 +--
>  fs/btrfs/relocation.c            |   3 +-
>  fs/btrfs/tests/extent-io-tests.c |   6 +-
>  fs/btrfs/tests/inode-tests.c     |  12 ++--
>  7 files changed, 86 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 8fc690384c58..51f1f3e31608 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3174,6 +3174,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
>  int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
>  			       int nr);
>  int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
> +			      unsigned int extra_bits,
>  			      struct extent_state **cached_state, int dedupe);
>  int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
>  			     struct btrfs_root *new_root,
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index faffa28ba707..580a6c1c296c 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -365,10 +365,11 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  		       struct extent_state **cached_state);
>  
>  static inline int set_extent_delalloc(struct extent_io_tree *tree, u64 start,
> -		u64 end, struct extent_state **cached_state)
> +				      u64 end, unsigned int extra_bits,
> +				      struct extent_state **cached_state)
>  {
>  	return set_extent_bit(tree, start, end,
> -			      EXTENT_DELALLOC | EXTENT_UPTODATE,
> +			      EXTENT_DELALLOC | EXTENT_UPTODATE | extra_bits,
>  			      NULL, cached_state, GFP_NOFS);
>  }
>  
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index aaab1838cece..bcac827d65f0 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -477,6 +477,47 @@ static void btrfs_drop_pages(struct page **pages, size_t num_pages)
>  	}
>  }
>  
> +static int btrfs_find_new_delalloc_bytes(struct btrfs_inode *inode,
> +					 const u64 start,
> +					 const u64 len,
> +					 struct extent_state **cached_state)
> +{
...
> +}

Can you please separate moving of btrfs_find_new_delalloc_bytes to
another patch?
