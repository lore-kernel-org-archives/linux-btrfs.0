From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v4 2/7] btrfs: add READAHEAD extent buffer flag
Date: Wed, 29 Jun 2011 16:55:34 -0400
Message-ID: <4E0B9146.1000100@redhat.com>
References: <cover.1309375866.git.sensille@gmx.net> <0584fc4d0deca47bd788aaab26ed9e02b4816227.1309375866.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <0584fc4d0deca47bd788aaab26ed9e02b4816227.1309375866.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/2011 04:10 PM, Arne Jansen wrote:
> Add a READAHEAD extent buffer flag.
> Add a function to trigger a read with this flag set.
> 
> Changes v2:
>  - use extent buffer flags instead of extent state flags
> 
> Signed-off-by: Arne Jansen <sensille@gmx.net>
> ---
>  fs/btrfs/disk-io.c   |   32 ++++++++++++++++++++++++++++++++
>  fs/btrfs/disk-io.h   |    2 ++
>  fs/btrfs/extent_io.h |    1 +
>  3 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index cff882c..20edd2d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -945,6 +945,38 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
>  	return ret;
>  }
>  
> +int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
> +			 int mirror_num, struct extent_buffer **eb)
> +{
> +	struct extent_buffer *buf = NULL;
> +	struct inode *btree_inode = root->fs_info->btree_inode;
> +	struct extent_io_tree *io_tree = &BTRFS_I(btree_inode)->io_tree;
> +	int ret;
> +
> +	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
> +	if (!buf)
> +		return 0;
> +
> +	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
> +
> +	ret = read_extent_buffer_pages(io_tree, buf, 0, 0, 1, btree_get_extent,
> +				 mirror_num);
> +	if (ret) {
> +		free_extent_buffer(buf);
> +		return ret;
> +	}
> +
> +	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags)) {
> +		*eb = buf;
> +		return -EIO;

Why are you returning buf here when if you get an error from
read_extent_buffer_pages you free it?  Instead free the extent buffer
and return EIO to be consistent.  Thanks,

Josef
