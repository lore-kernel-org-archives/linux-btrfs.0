From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH] Btrfs: use i_version instead of our own sequence
Date: Thu, 12 Apr 2012 16:22:26 +0300
Message-ID: <CALLzPKY0ViBnaH8PVOmxad+oPpbWiYOz24+Lc8CWNuzKbyHHng@mail.gmail.com>
References: <1333986794-6525-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333986794-6525-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 9, 2012 at 6:53 PM, Josef Bacik <josef@redhat.com> wrote:
> We've been keeping around the inode sequence number in hopes that som=
ebody
> would use it, but nobody uses it and people actually use i_version wh=
ich
> serves the same purpose, so use i_version where we used the incore in=
ode's
> sequence number and that way the sequence is updated properly across =
the
> board, and not just in file write. =C2=A0Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> =C2=A0fs/btrfs/btrfs_inode.h =C2=A0 | =C2=A0 =C2=A03 ---
> =C2=A0fs/btrfs/delayed-inode.c | =C2=A0 =C2=A04 ++--
> =C2=A0fs/btrfs/file.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A0=
1 -
> =C2=A0fs/btrfs/inode.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A05 +=
+---
> =C2=A0fs/btrfs/super.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A02 +=
-
> =C2=A05 files changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 9b9b15f..3771b85 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -83,9 +83,6 @@ struct btrfs_inode {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 generation;
>
> - =C2=A0 =C2=A0 =C2=A0 /* sequence number for NFS changes */
> - =C2=A0 =C2=A0 =C2=A0 u64 sequence;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * transid of the trans_handle that last m=
odified this inode
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 03e3748..bcd40c7 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1706,7 +1706,7 @@ static void fill_stack_inode_item(struct btrfs_=
trans_handle *trans,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_set_stack_inode_nbytes(inode_item, i=
node_get_bytes(inode));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_set_stack_inode_generation(inode_ite=
m,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
BTRFS_I(inode)->generation);
> - =C2=A0 =C2=A0 =C2=A0 btrfs_set_stack_inode_sequence(inode_item, BTR=
=46S_I(inode)->sequence);
> + =C2=A0 =C2=A0 =C2=A0 btrfs_set_stack_inode_sequence(inode_item, ino=
de->i_version);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_set_stack_inode_transid(inode_item, =
trans->transid);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_set_stack_inode_rdev(inode_item, ino=
de->i_rdev);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_set_stack_inode_flags(inode_item, BT=
RFS_I(inode)->flags);
> @@ -1754,7 +1754,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *=
rdev)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0set_nlink(inode, btrfs_stack_inode_nlink(i=
node_item));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_set_bytes(inode, btrfs_stack_inode_n=
bytes(inode_item));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BTRFS_I(inode)->generation =3D btrfs_stack=
_inode_generation(inode_item);
> - =C2=A0 =C2=A0 =C2=A0 BTRFS_I(inode)->sequence =3D btrfs_stack_inode=
_sequence(inode_item);
> + =C2=A0 =C2=A0 =C2=A0 inode->i_version =3D btrfs_stack_inode_sequenc=
e(inode_item);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0inode->i_rdev =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0*rdev =3D btrfs_stack_inode_rdev(inode_ite=
m);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BTRFS_I(inode)->flags =3D btrfs_stack_inod=
e_flags(inode_item);
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 431b565..f0da02b 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1404,7 +1404,6 @@ static ssize_t btrfs_file_aio_write(struct kioc=
b *iocb,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&=
inode->i_mutex);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> - =C2=A0 =C2=A0 =C2=A0 BTRFS_I(inode)->sequence++;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0start_pos =3D round_down(pos, root->sector=
size);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (start_pos > i_size_read(inode)) {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 7a084fb..7d3dd2f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2510,7 +2510,7 @@ static void btrfs_read_locked_inode(struct inod=
e *inode)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_set_bytes(inode, btrfs_inode_nbytes(=
leaf, inode_item));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BTRFS_I(inode)->generation =3D btrfs_inode=
_generation(leaf, inode_item);
> - =C2=A0 =C2=A0 =C2=A0 BTRFS_I(inode)->sequence =3D btrfs_inode_seque=
nce(leaf, inode_item);
> + =C2=A0 =C2=A0 =C2=A0 inode->i_version =3D btrfs_inode_sequence(leaf=
, inode_item);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0inode->i_generation =3D BTRFS_I(inode)->ge=
neration;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0inode->i_rdev =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0rdev =3D btrfs_inode_rdev(leaf, inode_item=
);
> @@ -2594,7 +2594,7 @@ static void fill_inode_item(struct btrfs_trans_=
handle *trans,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_set_inode_nbytes(leaf, item, inode_g=
et_bytes(inode));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_set_inode_generation(leaf, item, BTR=
=46S_I(inode)->generation);
> - =C2=A0 =C2=A0 =C2=A0 btrfs_set_inode_sequence(leaf, item, BTRFS_I(i=
node)->sequence);
> + =C2=A0 =C2=A0 =C2=A0 btrfs_set_inode_sequence(leaf, item, inode->i_=
version);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_set_inode_transid(leaf, item, trans-=
>transid);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_set_inode_rdev(leaf, item, inode->i_=
rdev);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_set_inode_flags(leaf, item, BTRFS_I(=
inode)->flags);
> @@ -6884,7 +6884,6 @@ struct inode *btrfs_alloc_inode(struct super_bl=
ock *sb)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ei->root =3D NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ei->space_info =3D NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ei->generation =3D 0;
> - =C2=A0 =C2=A0 =C2=A0 ei->sequence =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ei->last_trans =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ei->last_sub_trans =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ei->logged_trans =3D 0;
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 54e7ee9..ee1bb31 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -770,7 +770,7 @@ static int btrfs_fill_super(struct super_block *s=
b,
> =C2=A0#ifdef CONFIG_BTRFS_FS_POSIX_ACL
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_flags |=3D MS_POSIXACL;
> =C2=A0#endif
> -
> + =C2=A0 =C2=A0 =C2=A0 sb->s_flags |=3D MS_I_VERSION;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D open_ctree(sb, fs_devices, (char *=
)data);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk("btrfs:=
 open_ctree failed\n");
> --
> 1.7.5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

BTW.
1. where is BTRFS devel git tree?
2. when this is coming to mainline?

- Dmitry
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
