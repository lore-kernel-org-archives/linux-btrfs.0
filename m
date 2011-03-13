From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH v3 3/6] btrfs: add scrub code and prototypes
Date: Mon, 14 Mar 2011 01:50:31 +0200
Message-ID: <20110313235031.GA32690@kwango.lan.net>
References: <cover.1299941055.git.sensille@gmx.net> <7ccafb5250b72ca706369a8d5b45f06e8d5a4f8a.1299941055.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7ccafb5250b72ca706369a8d5b45f06e8d5a4f8a.1299941055.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 12, 2011 at 03:50:42PM +0100, Arne Jansen wrote:
> This is the main scrub code.
> 
> Updates v3:
> 
>  - fixed EIO handling, need to reallocate bio instead of reusing it
>  - Updated according to David Sterba's review
>  - don't clobber bi_flags on reuse, just set UPTODATE
>  - allocate long living bios with bio_kmalloc instead of bio_alloc
> 
> Signed-off-by: Arne Jansen <sensille@gmx.net>
> ---
>  fs/btrfs/Makefile |    2 +-
>  fs/btrfs/ctree.h  |   14 +
>  fs/btrfs/scrub.c  | 1497 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1512 insertions(+), 1 deletions(-)

(snipped)

> +static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
> +	struct map_lookup *map, int num, u64 base, u64 length)
> +{
> +	struct btrfs_path *path;
> +	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
> +	struct btrfs_root *root = fs_info->extent_root;
> +	struct btrfs_root *csum_root = fs_info->csum_root;
> +	struct btrfs_extent_item *extent;
> +	u64 flags;
> +	int ret;
> +	int slot;
> +	int i;
> +	int nstripes;

It should be u64 nstripes.  A few lines below you assign the stripe
length, it is a 64 bit quantity, also do_div() expects a 64 bit
dividend.  This fixes a serious breakage on x86-32.

Overall, this function could use a good cleanup.  I can send you a patch
later unless you want to do it yourself.

> +	int start_stripe;
> +	struct extent_buffer *l;
> +	struct btrfs_key key;
> +	u64 physical;
> +	u64 logical;
> +	u64 generation;
> +	u64 mirror_num;

And a minor thing on the whole series: u64 should be printed with %llu
and explicit casting to unsigned long long.

Thanks,

		Ilya

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
