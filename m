From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH] btrfs: fix dip leak
Date: Thu, 10 Mar 2011 00:46:42 +0800
Message-ID: <AANLkTikDN-v4C4rt-uTFQ35uoaoJ_9LRHSmAQUN4+uVD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ito <t-itoh@jp.fujitsu.com>
To: miaox@cn.fujitsu.com, Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2010/11/22 Miao Xie <miaox@cn.fujitsu.com>:
> bio_endio() will free dip and dip->csums, so dip and dip->csums twice=
 will
> be freed twice. Fix it.
>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> =A0fs/btrfs/inode.c | =A0 =A09 +++------
> =A01 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 558cac2..5a5edc7 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5731,7 +5731,7 @@ static void btrfs_submit_direct(int rw, struct =
bio *bio, struct inode *inode,
>
> =A0 =A0 =A0 =A0ret =3D btrfs_bio_wq_end_io(root->fs_info, bio, 0);
> =A0 =A0 =A0 =A0if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto free_ordered;
>
> =A0 =A0 =A0 =A0if (write && !skip_sum) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_wq_submit_bio(BTRFS_I(in=
ode)->root->fs_info,
> @@ -5740,7 +5740,7 @@ static void btrfs_submit_direct(int rw, struct =
bio *bio, struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 _=
_btrfs_submit_bio_start_direct_io,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 _=
_btrfs_submit_bio_done);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto free_ordered;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0} else if (!skip_sum)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_lookup_bio_sums_dio(root, inode,=
 bio,
> @@ -5748,11 +5748,8 @@ static void btrfs_submit_direct(int rw, struct=
 bio *bio, struct inode *inode,
>
> =A0 =A0 =A0 =A0ret =3D btrfs_map_bio(root, rw, bio, 0, 1);
> =A0 =A0 =A0 =A0if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto free_ordered;
> =A0 =A0 =A0 =A0return;
> -out_err:
> - =A0 =A0 =A0 kfree(dip->csums);
> - =A0 =A0 =A0 kfree(dip);
> =A0free_ordered:
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * If this is a write, we need to clean up the reserve=
d space and kill

The previous patch is broken and leaks dip when dip->csums allocation
fails; bio->bi_end_io isn't set at the point where the free_ordered
branch is consequently taken, thus bio_endio doesn't call the function
which would free it in the normal case. Fix.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0efdb65..53f4c8e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6056,6 +6056,7 @@ static void btrfs_submit_direct(int rw, struct
bio *bio, struct inode *inode,
 	if (!skip_sum) {
 		dip->csums =3D kmalloc(sizeof(u32) * bio->bi_vcnt, GFP_NOFS);
 		if (!dip->csums) {
+			kfree(dip);
 			ret =3D -ENOMEM;
 			goto free_ordered;
 		}
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
