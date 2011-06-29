From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v4 1/7] btrfs: add an extra wait mode to read_extent_buffer_pages
Date: Wed, 29 Jun 2011 16:50:25 -0400
Message-ID: <4E0B9011.4050902@redhat.com>
References: <cover.1309375866.git.sensille@gmx.net> <85d9e7d63ee2492ae15c2693654d3837e6037ad2.1309375866.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <85d9e7d63ee2492ae15c2693654d3837e6037ad2.1309375866.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/2011 04:10 PM, Arne Jansen wrote:
> read_extent_buffer_pages currently has two modes, either trigger a read
> without waiting for anything, or wait for the I/O to finish. The former
> also bails when it's unable to lock the page. This patch now adds an
> additional parameter to allow it to block on page lock, but don't wait
> for completion.
> 
> Signed-off-by: Arne Jansen <sensille@gmx.net>
> ---
>  fs/btrfs/disk-io.c   |    4 ++--
>  fs/btrfs/extent_io.c |    6 +++---
>  fs/btrfs/extent_io.h |    3 ++-
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 1ac8db5d..cff882c 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -325,7 +325,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>  	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
>  	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
>  	while (1) {
> -		ret = read_extent_buffer_pages(io_tree, eb, start, 1,
> +		ret = read_extent_buffer_pages(io_tree, eb, start, 1, 1,
>  					       btree_get_extent, mirror_num);
>  		if (!ret &&
>  		    !verify_parent_transid(io_tree, eb, parent_transid))
> @@ -940,7 +940,7 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
>  	if (!buf)
>  		return 0;
>  	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
> -				 buf, 0, 0, btree_get_extent, 0);
> +				 buf, 0, 0, 0, btree_get_extent, 0);
>  	free_extent_buffer(buf);
>  	return ret;
>  }
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b181a94..b7f0b9b 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3358,7 +3358,7 @@ int extent_buffer_uptodate(struct extent_io_tree *tree,
>  
>  int read_extent_buffer_pages(struct extent_io_tree *tree,
>  			     struct extent_buffer *eb,
> -			     u64 start, int wait,
> +			     u64 start, int wait_lock, int wait_complete,
>  			     get_extent_t *get_extent, int mirror_num)

Don't do this, it makes it confusing to figure out which one is which.
Add a flags parameter at the end so we can specify stuff like

WAIT_COMPLETE
WAIT_PAGE_LOCK

which is easier to read.  Thanks,

Josef
