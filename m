From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Subject: Re: [RFC PATCH 2/5 v3] Btrfs: avoid transaction stuff when btrfs is readonly
Date: Wed, 15 Dec 2010 16:45:59 +0800
Message-ID: <AANLkTikgAj1sFPr==ruot50Bq3oJ_v0ZG8Wy_QLdL+aG@mail.gmail.com>
References: <4CF8A74F.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	"Yan, Zheng" <zheng.yan@oracle.com>,
	Wenyi Liu <qingshenlwy@gmail.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF8A74F.2010306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 3, 2010 at 4:16 PM, liubo <liubo2009@cn.fujitsu.com> wrote:
> When the filesystem is readonly, avoid transaction stuff by checking =
MS_RDONLY
> at start transaction time.
>
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
> =A0fs/btrfs/transaction.c | =A0 =A03 +++
> =A01 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 1fffbc0..14a597d 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -181,6 +181,9 @@ static struct btrfs_trans_handle *start_transacti=
on(struct btrfs_root *root,
> =A0 =A0 =A0 =A0struct btrfs_trans_handle *h;
> =A0 =A0 =A0 =A0struct btrfs_transaction *cur_trans;
> =A0 =A0 =A0 =A0int ret;
> +
> + =A0 =A0 =A0 if (root->fs_info->sb->s_flags & MS_RDONLY)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EROFS);
> =A0again:
> =A0 =A0 =A0 =A0h =3D kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_=
NOFS);
> =A0 =A0 =A0 =A0if (!h)

There are cases that we need to start transaction when MS_RDONLY flag i=
s set.
=46or example, remount FS into read-only mode and log replay.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
