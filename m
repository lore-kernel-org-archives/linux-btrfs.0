From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH 07/10] btrfs: fix wrong ctime when adding link
Date: Thu, 20 May 2010 02:01:09 -0700
Message-ID: <AANLkTilVU-QFaBJKnjt7XF95RPpmrBv1EaZkFtfUraYa@mail.gmail.com>
References: <4BF4E336.40603@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BF4E336.40603@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 20, 2010 at 12:22 AM, Miao Xie <miaox@cn.fujitsu.com> wrote=
:
> the ctime of file has not been updated when I create a link for it.
>
> Steps to reproduce:
> =C2=A0# touch file1
> =C2=A0# stat -c %Z file1
> =C2=A01273592239
> =C2=A0# link flink1 file1
> =C2=A0# stat -c %Z file1
> =C2=A01273592239 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 <-- have n=
ot been updated
>
> This patch fix this problem.
>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> =C2=A0fs/btrfs/inode.c | =C2=A0 =C2=A08 ++++++--
> =C2=A01 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a85b90c..5271887 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4218,8 +4218,12 @@ int btrfs_add_link(struct btrfs_trans_handle *=
trans,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_i_size_w=
rite(parent_inode, parent_inode->i_size +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 name_len * 2);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 parent_inode->i_mt=
ime =3D parent_inode->i_ctime =3D CURRENT_TIME;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D btrfs_upda=
te_inode(trans, root, parent_inode);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 parent_inode->i_mt=
ime =3D parent_inode->i_ctime =3D inode->i_ctime
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D CURRENT_TI=
ME;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D btrfs_upda=
te_inode(trans, root, inode);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ret)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ret =3D btrfs_update_inode(trans, root, parent_inode);

You only update parent inode if write to current inode fails?

Also should you be updating the ctime of parent inode even with link
count of parent inode is not modified (btrfs always reports link count
of 1 on directories)?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
