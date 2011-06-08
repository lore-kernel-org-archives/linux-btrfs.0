From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] Btrfs: check root_key's offset instead
Date: Wed, 8 Jun 2011 18:24:57 +0800
Message-ID: <BANLkTik83m9d1m-_R9fGuidcR2Ygx4Z_gw@mail.gmail.com>
References: <4DEF44E5.6020906@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DEF44E5.6020906@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 8, 2011 at 5:46 PM, liubo <liubo2009@cn.fujitsu.com> wrote:
> When we use reloc root to cow or copy a tree block, we do not set the=
 block's
> owner, instead we set its header's flag with BTRFS_HEADER_FLAG_RELOC.
>
> So here we should check for root_key's offset.
>
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
> =A0fs/btrfs/extent-tree.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 5b9b6b6..0bda273 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6160,7 +6160,7 @@ static noinline int walk_up_proc(struct btrfs_t=
rans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (wc->flags[level + 1] & BTRFS_BLOCK=
_FLAG_FULL_BACKREF)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parent =3D path->nodes=
[level + 1]->start;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(root->root_key.o=
bjectid !=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(root->root_key.o=
ffset !=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_hea=
der_owner(path->nodes[level + 1]));
> =A0 =A0 =A0 =A0}
>

This is wrong, all blocks with BTRFS_HEADER_FLAG_RELOC flag set should
uss full back references.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
