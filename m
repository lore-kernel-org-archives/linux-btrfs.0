From: Cheng Renquan <crquan@gmail.com>
Subject: Re: [PATCH] btrfs: avoid duplications by moving the static int array
 from header to c file
Date: Fri, 27 Aug 2010 22:38:10 +0800
Message-ID: <AANLkTikqQBHSWrsSzEsBmp0_AoxRX7uE-Gemg6Wjam1x@mail.gmail.com>
References: <1281664548-10189-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com, Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1281664548-10189-1-git-send-email-crquan@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 13, 2010 at 9:55 AM, Cheng Renquan <crquan@gmail.com> wrote=
:
> The commit 607d432d referred a static int array defined in ctree.h,
> and a static inline function (btrfs_super_csum_size) using this array=
,
> the obvious problem is every c file using that function would have a
> local copy of that int array, multiple c files calling would result
> multiple copies of that array:
>
> $ nm fs/btrfs/btrfs.ko | grep btrfs_csum_sizes
> 0000010c r btrfs_csum_sizes
> 00000114 r btrfs_csum_sizes
> 000001c0 r btrfs_csum_sizes
> 000005a0 r btrfs_csum_sizes
>
> the original commit has 4 c files called this static inline function,
> till now there are still those 4 c files calling it, so there are 4 c=
opies
> of btrfs_csum_sizes; but future code may call it in more c files,
> resulting in more copies;
>
> =C2=A0fs/btrfs/ctree.h =C2=A0 =C2=A0 | =C2=A0 19 ++++++++++++++++-
> =C2=A0fs/btrfs/disk-io.c =C2=A0 | =C2=A0 25 +++++++++++++++++----
> =C2=A0fs/btrfs/file-item.c | =C2=A0 56 ++++++++++++++++++++++++++++--=
-------------------
> =C2=A0fs/btrfs/ioctl.c =C2=A0 =C2=A0 | =C2=A0 =C2=A09 ++++---
> =C2=A0fs/btrfs/tree-log.c =C2=A0| =C2=A0 10 +++++---
> =C2=A05 files changed, 81 insertions(+), 38 deletions(-)
>
> multiple copies are just wasting memory; move it to a c file can avoi=
d
> duplications; and since the inline function referred ARRAY_SIZE of th=
at
> array, must know the array size at compile time, so cannot be inlined
> anyway.
>
> The cost is originally inlined function calling changed to external f=
unction
> calling.
>
> Signed-off-by: Cheng Renquan <crquan@gmail.com>

Ping,

It was two weeks passed, and someone has some comments? Thanks,

> ---
> =C2=A0fs/btrfs/ctree.c | =C2=A0 =C2=A09 +++++++++
> =C2=A0fs/btrfs/ctree.h | =C2=A0 =C2=A09 +--------
> =C2=A02 files changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index c3df14c..3a89207 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -24,6 +24,15 @@
> =C2=A0#include "print-tree.h"
> =C2=A0#include "locking.h"
>
> +int btrfs_super_csum_size(struct btrfs_super_block *s)
> +{
> + =C2=A0 =C2=A0 =C2=A0 static const int btrfs_csum_sizes[] =3D { 4, 0=
 };
> +
> + =C2=A0 =C2=A0 =C2=A0 int t =3D btrfs_super_csum_type(s);
> + =C2=A0 =C2=A0 =C2=A0 BUG_ON(t >=3D ARRAY_SIZE(btrfs_csum_sizes));
> + =C2=A0 =C2=A0 =C2=A0 return btrfs_csum_sizes[t];
> +}
> +
> =C2=A0static int split_node(struct btrfs_trans_handle *trans, struct =
btrfs_root
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0*root, struct btrfs_path *path, int level);
> =C2=A0static int split_leaf(struct btrfs_trans_handle *trans, struct =
btrfs_root
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index e9bf864..99220ee 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -132,8 +132,6 @@ struct btrfs_ordered_sum;
> =C2=A0/* csum types */
> =C2=A0#define BTRFS_CSUM_TYPE_CRC32 =C2=A00
>
> -static int btrfs_csum_sizes[] =3D { 4, 0 };
> -
> =C2=A0/* four bytes for CRC32 */
> =C2=A0#define BTRFS_EMPTY_DIR_SIZE 0
>
> @@ -1877,12 +1875,7 @@ BTRFS_SETGET_STACK_FUNCS(super_incompat_flags,=
 struct btrfs_super_block,
> =C2=A0BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_bl=
ock,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 csum_type, 16);
>
> -static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
> -{
> - =C2=A0 =C2=A0 =C2=A0 int t =3D btrfs_super_csum_type(s);
> - =C2=A0 =C2=A0 =C2=A0 BUG_ON(t >=3D ARRAY_SIZE(btrfs_csum_sizes));
> - =C2=A0 =C2=A0 =C2=A0 return btrfs_csum_sizes[t];
> -}
> +int btrfs_super_csum_size(struct btrfs_super_block *s);
>
> =C2=A0static inline unsigned long btrfs_leaf_data(struct extent_buffe=
r *l)
> =C2=A0{
> --

--
Cheng Renquan (=E7=A8=8B=E4=BB=BB=E5=85=A8), from Singapore
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
