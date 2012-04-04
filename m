From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [RFC] [PATCH 2/2] Btrfs: move over to use ->update_time
Date: Wed, 4 Apr 2012 20:24:19 +0300
Message-ID: <CALLzPKbs7ALeP9sM2OorMiMFCXGs26oPM9=EjBny0NiQi0orSQ@mail.gmail.com>
References: <1332771031-3337-1-git-send-email-josef@redhat.com>
	<1332771031-3337-2-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-btrfs@vger.kernel.org, hch@infradead.org,
	Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1332771031-3337-2-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Mimi and I working on IMA/EVM (security/integrity) and it uses
i_version for checking if file content has been changed.
extX file systems support i_version updates with mounting file system
with "iversion" option or via kernel command line parameter
"i_version"

It seems iversion option is not recognized when mounting btrfs.
I see this patchset deals with i_version update as well..
Can you please give an advice how to use i_version with btrfs?

Thanks,
Dmitry

On Mon, Mar 26, 2012 at 5:10 PM, Josef Bacik <josef@redhat.com> wrote:
> Btrfs had been doing it's own file_update_time so we could catch ENOS=
PC
> properly, so just update our btrfs_update_time to work with the new s=
tuff and
> then we'll be fancy later. =C2=A0Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> =C2=A0fs/btrfs/ctree.h | =C2=A0 =C2=A01 -
> =C2=A0fs/btrfs/file.c =C2=A0| =C2=A0 =C2=A02 +-
> =C2=A0fs/btrfs/inode.c | =C2=A0 53 ++++++++++++++--------------------=
-------------------
> =C2=A03 files changed, 15 insertions(+), 41 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 9d6f59c..9e4a06e 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2887,7 +2887,6 @@ int btrfs_readpage(struct file *file, struct pa=
ge *page);
> =C2=A0void btrfs_evict_inode(struct inode *inode);
> =C2=A0int btrfs_write_inode(struct inode *inode, struct writeback_con=
trol *wbc);
> =C2=A0int btrfs_dirty_inode(struct inode *inode);
> -int btrfs_update_time(struct file *file);
> =C2=A0struct inode *btrfs_alloc_inode(struct super_block *sb);
> =C2=A0void btrfs_destroy_inode(struct inode *inode);
> =C2=A0int btrfs_drop_inode(struct inode *inode);
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 859ba2d..50b8cea 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1389,7 +1389,7 @@ static ssize_t btrfs_file_aio_write(struct kioc=
b *iocb,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> - =C2=A0 =C2=A0 =C2=A0 err =3D btrfs_update_time(file);
> + =C2=A0 =C2=A0 =C2=A0 err =3D file_update_time(file);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&=
inode->i_mutex);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index c2c44d6..2c7359b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4287,46 +4287,18 @@ int btrfs_dirty_inode(struct inode *inode)
> =C2=A0* This is a copy of file_update_time. =C2=A0We need this so we =
can return error on
> =C2=A0* ENOSPC for updating the inode in the case of file write and m=
map writes.
> =C2=A0*/
> -int btrfs_update_time(struct file *file)
> +static int btrfs_update_time(struct inode *inode, struct timespec *n=
ow,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0int flags)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct inode *inode =3D file->f_path.dentry->d=
_inode;
> - =C2=A0 =C2=A0 =C2=A0 struct timespec now;
> - =C2=A0 =C2=A0 =C2=A0 int ret;
> - =C2=A0 =C2=A0 =C2=A0 enum { S_MTIME =3D 1, S_CTIME =3D 2, S_VERSION=
 =3D 4 } sync_it =3D 0;
> -
> - =C2=A0 =C2=A0 =C2=A0 /* First try to exhaust all avenues to not syn=
c */
> - =C2=A0 =C2=A0 =C2=A0 if (IS_NOCMTIME(inode))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> -
> - =C2=A0 =C2=A0 =C2=A0 now =3D current_fs_time(inode->i_sb);
> - =C2=A0 =C2=A0 =C2=A0 if (!timespec_equal(&inode->i_mtime, &now))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sync_it =3D S_MTIM=
E;
> -
> - =C2=A0 =C2=A0 =C2=A0 if (!timespec_equal(&inode->i_ctime, &now))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sync_it |=3D S_CTI=
ME;
> -
> - =C2=A0 =C2=A0 =C2=A0 if (IS_I_VERSION(inode))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sync_it |=3D S_VER=
SION;
> -
> - =C2=A0 =C2=A0 =C2=A0 if (!sync_it)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> -
> - =C2=A0 =C2=A0 =C2=A0 /* Finally allowed to write? Takes lock. */
> - =C2=A0 =C2=A0 =C2=A0 if (mnt_want_write_file(file))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> -
> - =C2=A0 =C2=A0 =C2=A0 /* Only change inode inside the lock region */
> - =C2=A0 =C2=A0 =C2=A0 if (sync_it & S_VERSION)
> + =C2=A0 =C2=A0 =C2=A0 if (flags & S_VERSION)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_inc_iver=
sion(inode);
> - =C2=A0 =C2=A0 =C2=A0 if (sync_it & S_CTIME)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode->i_ctime =3D=
 now;
> - =C2=A0 =C2=A0 =C2=A0 if (sync_it & S_MTIME)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode->i_mtime =3D=
 now;
> - =C2=A0 =C2=A0 =C2=A0 ret =3D btrfs_dirty_inode(inode);
> - =C2=A0 =C2=A0 =C2=A0 if (!ret)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mark_inode_dirty_s=
ync(inode);
> - =C2=A0 =C2=A0 =C2=A0 mnt_drop_write(file->f_path.mnt);
> - =C2=A0 =C2=A0 =C2=A0 return ret;
> + =C2=A0 =C2=A0 =C2=A0 if (flags & S_CTIME)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode->i_ctime =3D=
 *now;
> + =C2=A0 =C2=A0 =C2=A0 if (flags & S_MTIME)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode->i_mtime =3D=
 *now;
> + =C2=A0 =C2=A0 =C2=A0 if (flags & S_ATIME)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode->i_atime =3D=
 *now;
> + =C2=A0 =C2=A0 =C2=A0 return btrfs_dirty_inode(inode);
> =C2=A0}
>
> =C2=A0/*
> @@ -6405,7 +6377,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *v=
ma, struct vm_fault *vmf)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =C2=A0=3D btrfs_delalloc_reserve_space=
(inode, PAGE_CACHE_SIZE);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ret)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D btrfs_upda=
te_time(vma->vm_file);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D file_updat=
e_time(vma->vm_file);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret =3D=3D=
 -ENOMEM)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ret =3D VM_FAULT_OOM;
> @@ -7451,6 +7423,7 @@ static const struct inode_operations btrfs_file=
_inode_operations =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.permission =C2=A0 =C2=A0 =3D btrfs_permis=
sion,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.fiemap =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D bt=
rfs_fiemap,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.get_acl =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D bt=
rfs_get_acl,
> + =C2=A0 =C2=A0 =C2=A0 .update_time =C2=A0 =C2=A0=3D btrfs_update_tim=
e,
> =C2=A0};
> =C2=A0static const struct inode_operations btrfs_special_inode_operat=
ions =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.getattr =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D bt=
rfs_getattr,
> @@ -7461,6 +7434,7 @@ static const struct inode_operations btrfs_spec=
ial_inode_operations =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.listxattr =C2=A0 =C2=A0 =C2=A0=3D btrfs_l=
istxattr,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.removexattr =C2=A0 =C2=A0=3D btrfs_remove=
xattr,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.get_acl =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D bt=
rfs_get_acl,
> + =C2=A0 =C2=A0 =C2=A0 .update_time =C2=A0 =C2=A0=3D btrfs_update_tim=
e,
> =C2=A0};
> =C2=A0static const struct inode_operations btrfs_symlink_inode_operat=
ions =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.readlink =C2=A0 =C2=A0 =C2=A0 =3D generic=
_readlink,
> @@ -7474,6 +7448,7 @@ static const struct inode_operations btrfs_syml=
ink_inode_operations =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.listxattr =C2=A0 =C2=A0 =C2=A0=3D btrfs_l=
istxattr,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.removexattr =C2=A0 =C2=A0=3D btrfs_remove=
xattr,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.get_acl =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D bt=
rfs_get_acl,
> + =C2=A0 =C2=A0 =C2=A0 .update_time =C2=A0 =C2=A0=3D btrfs_update_tim=
e,
> =C2=A0};
>
> =C2=A0const struct dentry_operations btrfs_dentry_operations =3D {
> --
> 1.7.5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
