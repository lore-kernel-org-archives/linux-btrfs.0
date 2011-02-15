From: Yoshinori Sano <yoshinori.sano@gmail.com>
Subject: Re: [PATCH] Btrfs: fix uncheck memory allocations
Date: Tue, 15 Feb 2011 21:10:53 +0900
Message-ID: <AANLkTikb+U+CUZYvNNmfAdd=xoaBfTsQVgh9ncP1ZrYc@mail.gmail.com>
References: <1297771302-28297-1-git-send-email-yoshinori.sano@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, t-itoh@jp.fujitsu.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297771302-28297-1-git-send-email-yoshinori.sano@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is the modified version of my previous patch.
This patch is created by removing the duplicated (conflicted) code
of the following work.

Tsutomu Itoh (1) commits (+7/-3):
    Btrfs: check return value of alloc_extent_map()

http://marc.info/?l=3Dlinux-btrfs&m=3D129774185204197&w=3D2

Regards,

2011/2/15 Yoshinori Sano <yoshinori.sano@gmail.com>:
> To make Btrfs code more robust, several return value checks where mem=
ory
> allocation can fail are introduced. I use BUG_ON where I don't know h=
ow
> to handle the error properly, which increases the number of using the
> notorious BUG_ON, though.
>
> Signed-off-by: Yoshinori Sano <yoshinori.sano@gmail.com>
> ---
> =A0fs/btrfs/compression.c | =A0 =A06 ++++++
> =A0fs/btrfs/extent-tree.c | =A0 =A04 ++++
> =A0fs/btrfs/inode.c =A0 =A0 =A0 | =A0 =A02 ++
> =A03 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 4d2110e..992a4b9 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -340,6 +340,8 @@ int btrfs_submit_compressed_write(struct inode *i=
node, u64 start,
>
> =A0 =A0 =A0 =A0WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
> =A0 =A0 =A0 =A0cb =3D kmalloc(compressed_bio_size(root, compressed_le=
n), GFP_NOFS);
> + =A0 =A0 =A0 if (!cb)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> =A0 =A0 =A0 =A0atomic_set(&cb->pending_bios, 0);
> =A0 =A0 =A0 =A0cb->errors =3D 0;
> =A0 =A0 =A0 =A0cb->inode =3D inode;
> @@ -354,6 +356,10 @@ int btrfs_submit_compressed_write(struct inode *=
inode, u64 start,
> =A0 =A0 =A0 =A0bdev =3D BTRFS_I(inode)->root->fs_info->fs_devices->la=
test_bdev;
>
> =A0 =A0 =A0 =A0bio =3D compressed_bio_alloc(bdev, first_byte, GFP_NOF=
S);
> + =A0 =A0 =A0 if(!bio) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cb);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0bio->bi_private =3D cb;
> =A0 =A0 =A0 =A0bio->bi_end_io =3D end_compressed_bio_write;
> =A0 =A0 =A0 =A0atomic_inc(&cb->pending_bios);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a7aaa10..3c6d0f2 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6931,6 +6931,10 @@ static noinline int get_new_locations(struct i=
node *reloc_inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct disk_extent *ol=
d =3D exts;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0max *=3D 2;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exts =3D kzalloc(sizeo=
f(*exts) * max, GFP_NOFS);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!exts) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(exts, old, size=
of(*exts) * nr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (old !=3D *extents)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(=
old);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8d392ed..12a5a40 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -287,6 +287,7 @@ static noinline int add_async_extent(struct async=
_cow *cow,
> =A0 =A0 =A0 =A0struct async_extent *async_extent;
>
> =A0 =A0 =A0 =A0async_extent =3D kmalloc(sizeof(*async_extent), GFP_NO=
=46S);
> + =A0 =A0 =A0 BUG_ON(!async_extent);
> =A0 =A0 =A0 =A0async_extent->start =3D start;
> =A0 =A0 =A0 =A0async_extent->ram_size =3D ram_size;
> =A0 =A0 =A0 =A0async_extent->compressed_size =3D compressed_size;
> @@ -384,6 +385,7 @@ again:
> =A0 =A0 =A0 =A0 =A0 =A0 (BTRFS_I(inode)->force_compress))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(pages);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pages =3D kzalloc(sizeof(struct page *=
) * nr_pages, GFP_NOFS);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(!pages);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (BTRFS_I(inode)->force_compress)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0compress_type =3D BTRF=
S_I(inode)->force_compress;
> --
> 1.7.1
>
>

--=20
Yoshinori Sano <yoshinori.sano@gmail.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
