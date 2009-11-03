From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH]] Btrfs: fix destroy snapshot to get the right parent
	dentry
Date: Wed, 4 Nov 2009 07:20:02 +0800
Message-ID: <3d0408630911031520k78af1c39g16988123739a16e2@mail.gmail.com>
References: <20091103161054.GA13781@gentoo-vm.octal.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Rui Miguel Silva <rmfrfs@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091103161054.GA13781@gentoo-vm.octal.tv>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 4, 2009 at 12:10 AM, Rui Miguel Silva <rmfrfs@gmail.com> wr=
ote:
> In snapshot destroy the dentry used for parent was the snapshot dentr=
y
> itself. Remove d_invalidate since always return EBUSY, making possibl=
e
> to remove a snapshot using the btrfsctl -D option.
>

This is not correct. The snapshot destroy ioctl receives two parameters=
=2E
The first one provides directory that the snapshot is in, the second on=
e
provides the name of snapshot..

The usage of 'btrfsctl -D' is:
btrfsctl -D [name of snapshot] [directory that holds the snapshot]

Yan, Zheng


> Signed-off-by: Rui Miguel Silva <rmfrfs@gmail.com>
> ---
> =A0fs/btrfs/ioctl.c | =A0 =A07 ++-----
> =A01 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index cdbb054..fe6ac9a 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -741,7 +741,7 @@ out:
> =A0static noinline int btrfs_ioctl_snap_destroy(struct file *file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 void __user *arg)
> =A0{
> - =A0 =A0 =A0 struct dentry *parent =3D fdentry(file);
> + =A0 =A0 =A0 struct dentry *parent =3D file->f_path.dentry->d_parent=
;
> =A0 =A0 =A0 =A0struct dentry *dentry;
> =A0 =A0 =A0 =A0struct inode *dir =3D parent->d_inode;
> =A0 =A0 =A0 =A0struct inode *inode;
> @@ -793,9 +793,6 @@ static noinline int btrfs_ioctl_snap_destroy(stru=
ct file *file,
> =A0 =A0 =A0 =A0dest =3D BTRFS_I(inode)->root;
>
> =A0 =A0 =A0 =A0mutex_lock(&inode->i_mutex);
> - =A0 =A0 =A0 err =3D d_invalidate(dentry);
> - =A0 =A0 =A0 if (err)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_unlock;
>
> =A0 =A0 =A0 =A0down_write(&root->fs_info->subvol_sem);
>
> @@ -827,7 +824,7 @@ static noinline int btrfs_ioctl_snap_destroy(stru=
ct file *file,
> =A0 =A0 =A0 =A0inode->i_flags |=3D S_DEAD;
> =A0out_up_write:
> =A0 =A0 =A0 =A0up_write(&root->fs_info->subvol_sem);
> -out_unlock:
> +
> =A0 =A0 =A0 =A0mutex_unlock(&inode->i_mutex);
> =A0 =A0 =A0 =A0if (!err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0shrink_dcache_sb(root->fs_info->sb);
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
