From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [RFC] big fat transaction ioctl
Date: Tue, 10 Nov 2009 23:44:39 +0300
Message-ID: <2a31deca0911101244l2a84ece6p6c5dbcce5e101e9b@mail.gmail.com>
References: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 10, 2009 at 11:12 PM, Sage Weil <sage@newdream.net> wrote:
> Hi all,
>
> This is an alternative approach to atomic user transactions for btrfs=
=2E
> The old start/end ioctls suffer from some basic limitations, namely
>
> =A0- We can't properly reserve space ahead of time to avoid ENOSPC pa=
rt
> way through the transaction, and
> =A0- The process may die (seg fault, SIGKILL) part way through the
> transaction. =A0Currently when that happens the partial transaction w=
ill
> commit.
>
> This patch implements an ioctl that lets the application completely
> specify the entire transaction in a single syscall. =A0If the process=
 gets
> killed or seg faults part way through, the entire transaction will st=
ill
> complete.
>
> The goal is to atomically commit updates to multiple files, xattrs,
> directories. =A0But this is still a file system: we don't get rollbac=
k if
> things go wrong. =A0Instead, do what we can up front to make sure thi=
ngs
> will work out. =A0And if things do go wrong, optionally prevent a par=
tial
> result from reaching the disk.

Why not snapshot respective root (doesn't work if transaction spans
multiple file-systems, but this doesn't look like a real-world
limitation), run txn against that snapshot and rollback on failure
instead? Snapshots are writable, cheap, and this looks like a real
transaction abort mechanism.

Regards,
Andrey

>
> A few things:
>
> =A0- The implementation just exports the sys_* calls it needs (a popu=
lar
> move, no doubt :). =A0I've looked at using the corresponding vfs_*
> instructions instead, and keeping a table of struct file *'s instead =
of
> fd's to avoid these exports, but this requires a large amount of
> duplication of semi-boilerplate path lookup, security_path_* hooks, a=
nd
> similar code from fs/namei.c and elsewhere. =A0If we want to go that
> route, there are some advantages, the main one being that we can veri=
fy
> that every dentry/inode we operate on belongs to the same fs. =A0But =
the
> code will be more complex... I'm not sure if I should pursue that jus=
t
> yet.
>
> =A0- The application gets to define what defines a failure for each
> individual op based on its return value.
>
> =A0- If the transaction fails, the process can instruct the fs to wed=
ge
> itself so that a partial result does not commit. =A0This isn't a part=
icuarly
> elegant approach, but a wedged fs may be preferable to a partial
> transaction commit. =A0(Alternatively, a failure could branch/jump to
> another point in the transaction op vector to do some cleanup and/or =
an
> explicit WEDGE op to accomplish the same thing?)
>
> - This still uses the existing ioctl start transaction call. =A0Depen=
ding on
> how Josef's ENOSPC journal_info stuff works out, I should be able to =
avoid
> the current global open_ioctl_trans counter for a cleaner interaction=
 with
> the btrfs transaction code.
>
> - The data space reservation is still missing. =A0I need a way to
> find which space_info will be used, and pin it for the duration
> of the entire transaction.
>
> - The metadata reservation is a worst case bound. =A0It could be less
> conservative, but currently each op is pulled out of the user address
> space individually so we'd either need two passes, a big kmalloc, or
> further trust the app to get the value right. =A0(Same goes for the d=
ata
> size, actually, although that's easier to get correct.)
>
> Thoughts on this?
>
> Thanks-
> sage
>
>
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
> =A0fs/btrfs/ioctl.c | =A0187 ++++++++++++++++++++++++++++++++++++++++=
++++++++++++++
> =A0fs/btrfs/ioctl.h | =A0 49 ++++++++++++++
> =A0fs/namei.c =A0 =A0 =A0 | =A0 =A03 +
> =A0fs/open.c =A0 =A0 =A0 =A0| =A0 =A02 +
> =A0fs/read_write.c =A0| =A0 =A02 +
> =A0fs/xattr.c =A0 =A0 =A0 | =A0 =A02 +
> =A06 files changed, 245 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 136c5ed..4269616 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -37,6 +37,7 @@
> =A0#include <linux/compat.h>
> =A0#include <linux/bit_spinlock.h>
> =A0#include <linux/security.h>
> +#include <linux/syscalls.h>
> =A0#include <linux/xattr.h>
> =A0#include <linux/vmalloc.h>
> =A0#include "compat.h"
> @@ -1303,6 +1304,190 @@ long btrfs_ioctl_trans_end(struct file *file)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +/*
> + * return number of successfully complete ops via @ops_completed
> + * (where success/failure is defined by the _FAIL_* flags).
> + */
> +static long do_usertrans(struct btrfs_root *root,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_ioctl_u=
sertrans *ut,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u64 *ops_completed)
> +{
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 int *fds;
> + =A0 =A0 =A0 int err;
> + =A0 =A0 =A0 struct file *file;
> + =A0 =A0 =A0 struct btrfs_ioctl_usertrans_op *ops =3D (void *)ut->op=
s_ptr;
> + =A0 =A0 =A0 int fd1, fd2;
> +
> + =A0 =A0 =A0 fds =3D kcalloc(sizeof(int), ut->num_fds, GFP_KERNEL);
> + =A0 =A0 =A0 if (!fds)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < ut->num_ops; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_ioctl_usertrans_op op;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EFAULT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (copy_from_user(&op, &ops[i], sizeof=
(op)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* lookup fd args? */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (op.op) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_CLONERANGE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (op.args[1] < 0 || o=
p.args[1] >=3D ut->num_fds)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fd2 =3D fds[1];
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_CLOSE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_PWRITE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (op.args[0] < 0 || o=
p.args[0] >=3D ut->num_fds)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fd1 =3D fds[0];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* do op */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (op.op) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_OPEN:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (op.args[3] < 0 || o=
p.args[3] >=3D ut->num_fds)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_open((const=
 char __user *)op.args[0],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0op.args[1], op.args[2]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fds[op.args[3]] =3D ret=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_CLOSE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_close(fd1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_PWRITE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_pwrite64(fd=
1, (const char __user *)op.args[1],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0op.args[2], op.args[3]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_UNLINK:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_unlink((con=
st char __user *)op.args[0]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_MKDIR:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_mkdir((cons=
t char __user *)op.args[0],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 op.args=
[1]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_RMDIR:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_rmdir((cons=
t char __user *)op.args[0]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_TRUNCATE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_truncate((c=
onst char __user *)op.args[0],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0op.args[1]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_SETXATTR:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_setxattr((c=
har __user *)op.args[0],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0(char __user *)op.args[1],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0(void __user *)op.args[2],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0op.args[3], op.args[4]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_REMOVEXATTR:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_removexattr=
((char __user *)op.args[0],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 (char __user *)op.args[1]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case BTRFS_IOC_UT_OP_CLONERANGE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EBADF;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 file =3D fget(fd1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (file) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 btrfs_ioctl_clone(file, fd2,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 op.args[2], op.args[3],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 op.args[4]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fput(fi=
le);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_debug(" ut %d/%d op %d args %llx %ll=
x %llx %llx %llx =3D %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i, (int)ut->num_ops,=
 (int)op.op, op.args[0],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0op.args[1], op.args[=
2], op.args[3], op.args[4], ret);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_user(ret, &ops[i].rval);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FA=
IL_ON_NE) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret !=3D op.rval)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FA=
IL_ON_EQ) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=3D op.rval)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FA=
IL_ON_LT) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret < op.rval)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FA=
IL_ON_GT) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret > op.rval)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FA=
IL_ON_LTE) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret <=3D op.rval)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((op.flags & BTRFS_IOC_UT_OP_FLAG_FA=
IL_ON_GTE) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret >=3D op.rval)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 err =3D 0;
> +out:
> + =A0 =A0 =A0 *ops_completed =3D i;
> + =A0 =A0 =A0 kfree(fds);
> + =A0 =A0 =A0 return err;
> +}
> +
> +long btrfs_ioctl_usertrans(struct file *file, void __user *arg)
> +{
> + =A0 =A0 =A0 struct btrfs_root *root =3D BTRFS_I(fdentry(file)->d_in=
ode)->root;
> + =A0 =A0 =A0 struct btrfs_trans_handle *trans;
> + =A0 =A0 =A0 struct btrfs_ioctl_usertrans ut, *orig_ut =3D arg;
> + =A0 =A0 =A0 u64 ops_completed =3D 0;
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 ret =3D -EPERM;
> + =A0 =A0 =A0 if (!capable(CAP_SYS_ADMIN))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 ret =3D -EFAULT;
> + =A0 =A0 =A0 if (copy_from_user(&ut, orig_ut, sizeof(ut)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 ret =3D mnt_want_write(file->f_path.mnt);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 ret =3D btrfs_reserve_metadata_space(root, 5*ut.num_ops=
);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_drop_write;
> +
> + =A0 =A0 =A0 mutex_lock(&root->fs_info->trans_mutex);
> + =A0 =A0 =A0 root->fs_info->open_ioctl_trans++;
> + =A0 =A0 =A0 mutex_unlock(&root->fs_info->trans_mutex);
> +
> + =A0 =A0 =A0 ret =3D -ENOMEM;
> + =A0 =A0 =A0 trans =3D btrfs_start_ioctl_transaction(root, 0);
> + =A0 =A0 =A0 if (!trans)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_drop;
> +
> + =A0 =A0 =A0 ret =3D do_usertrans(root, &ut, &ops_completed);
> + =A0 =A0 =A0 put_user(ops_completed, &orig_ut->ops_completed);
> +
> + =A0 =A0 =A0 if (ret < 0 && (ut.flags & BTRFS_IOC_UT_FLAG_WEDGEONFAI=
L))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err("btrfs: usertrans failed, wedgin=
g to avoid partial "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" commit\n");
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_end_transaction(trans, root);
> +
> +out_drop:
> + =A0 =A0 =A0 mutex_lock(&root->fs_info->trans_mutex);
> + =A0 =A0 =A0 root->fs_info->open_ioctl_trans--;
> + =A0 =A0 =A0 mutex_unlock(&root->fs_info->trans_mutex);
> +
> + =A0 =A0 =A0 btrfs_unreserve_metadata_space(root, 5*ut.num_ops);
> +out_drop_write:
> + =A0 =A0 =A0 mnt_drop_write(file->f_path.mnt);
> +out:
> + =A0 =A0 =A0 return ret;
> +}
> +
> =A0long btrfs_ioctl(struct file *file, unsigned int
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cmd, unsigned long arg)
> =A0{
> @@ -1343,6 +1528,8 @@ long btrfs_ioctl(struct file *file, unsigned in=
t
> =A0 =A0 =A0 =A0case BTRFS_IOC_SYNC:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_sync_fs(file->f_dentry->d_sb, 1)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> + =A0 =A0 =A0 case BTRFS_IOC_USERTRANS:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return btrfs_ioctl_usertrans(file, argp=
);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0return -ENOTTY;
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index bc49914..f94e293 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -67,4 +67,53 @@ struct btrfs_ioctl_clone_range_args {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
truct btrfs_ioctl_vol_args)
> =A0#define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 btrfs_ioctl_vol_args)
> +
> +/* usertrans ops */
> +/* the 'fd' values are _indices_ into a temporary fd table, see num_=
fds below */
> +#define BTRFS_IOC_UT_OP_OPEN =A0 =A0 =A0 =A0 1 =A0/* path, flags, mo=
de, fd */
> +#define BTRFS_IOC_UT_OP_CLOSE =A0 =A0 =A0 =A02 =A0/* fd */
> +#define BTRFS_IOC_UT_OP_PWRITE =A0 =A0 =A0 3 =A0/* fd, data, length,=
 offset */
> +#define BTRFS_IOC_UT_OP_UNLINK =A0 =A0 =A0 4 =A0/* path */
> +#define BTRFS_IOC_UT_OP_LINK =A0 =A0 =A0 =A0 5 =A0/* oldpath, newpat=
h */
> +#define BTRFS_IOC_UT_OP_MKDIR =A0 =A0 =A0 =A06 =A0/* path, mode */
> +#define BTRFS_IOC_UT_OP_RMDIR =A0 =A0 =A0 =A07 =A0/* path */
> +#define BTRFS_IOC_UT_OP_TRUNCATE =A0 =A0 8 =A0/* path, size */
> +#define BTRFS_IOC_UT_OP_SETXATTR =A0 =A0 9 =A0/* path, name, data, l=
en */
> +#define BTRFS_IOC_UT_OP_REMOVEXATTR 10 =A0/* path, name */
> +#define BTRFS_IOC_UT_OP_CLONERANGE =A011 =A0/* dst fd, src fd, off, =
len, dst off */
> +
> +/* define what 'failure' entails for each op based on return value *=
/
> +#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_NE =A0 =A0(1<< 1)
> +#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_EQ =A0 =A0(1<< 2)
> +#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_LT =A0 =A0(1<< 3)
> +#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_GT =A0 =A0(1<< 4)
> +#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_LTE =A0 (1<< 5)
> +#define BTRFS_IOC_UT_OP_FLAG_FAIL_ON_GTE =A0 (1<< 6)
> +
> +struct btrfs_ioctl_usertrans_op {
> + =A0 =A0 =A0 __u64 op;
> + =A0 =A0 =A0 __s64 args[5];
> + =A0 =A0 =A0 __s64 rval;
> + =A0 =A0 =A0 __u64 flags;
> +};
> +
> +/*
> + * If an op fails and we cannot complete the transaction, we may wan=
t
> + * to lock up the file system (requiring a reboot) to prevent a
> + * partial result from committing.
> + */
> +#define BTRFS_IOC_UT_FLAG_WEDGEONFAIL (1<<13)
> +
> +struct btrfs_ioctl_usertrans {
> + =A0 =A0 =A0 __u64 num_ops; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* in=
: # ops */
> + =A0 =A0 =A0 __u64 ops_ptr; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* in=
: usertrans_op array */
> + =A0 =A0 =A0 __u64 num_fds; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* in=
: size of fd table (max fd + 1) */
> + =A0 =A0 =A0 __u64 data_bytes, metadata_ops; /* in: for space reserv=
ation */
> + =A0 =A0 =A0 __u64 flags; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* =
in: flags */
> + =A0 =A0 =A0 __u64 ops_completed; =A0 =A0 =A0 =A0 =A0 =A0/* out: # o=
ps completed */
> +};
> +
> +#define BTRFS_IOC_USERTRANS =A0_IOW(BTRFS_IOCTL_MAGIC, 16, =A0 =A0 =A0=
 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct btrfs_ioctl_usertrans)
> +
> =A0#endif
> diff --git a/fs/namei.c b/fs/namei.c
> index d11f404..4d53225 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2148,6 +2148,7 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pat=
hname, int, mode)
> =A0{
> =A0 =A0 =A0 =A0return sys_mkdirat(AT_FDCWD, pathname, mode);
> =A0}
> +EXPORT_SYMBOL(sys_mkdir);
>
> =A0/*
> =A0* We try to drop the dentry early: we should have
> @@ -2262,6 +2263,7 @@ SYSCALL_DEFINE1(rmdir, const char __user *, pat=
hname)
> =A0{
> =A0 =A0 =A0 =A0return do_rmdir(AT_FDCWD, pathname);
> =A0}
> +EXPORT_SYMBOL(sys_rmdir);
>
> =A0int vfs_unlink(struct inode *dir, struct dentry *dentry)
> =A0{
> @@ -2369,6 +2371,7 @@ SYSCALL_DEFINE1(unlink, const char __user *, pa=
thname)
> =A0{
> =A0 =A0 =A0 =A0return do_unlinkat(AT_FDCWD, pathname);
> =A0}
> +EXPORT_SYMBOL(sys_unlink);
>
> =A0int vfs_symlink(struct inode *dir, struct dentry *dentry, const ch=
ar *oldname)
> =A0{
> diff --git a/fs/open.c b/fs/open.c
> index 4f01e06..15eddfc 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -294,6 +294,7 @@ SYSCALL_DEFINE2(truncate, const char __user *, pa=
th, long, length)
> =A0{
> =A0 =A0 =A0 =A0return do_sys_truncate(path, length);
> =A0}
> +EXPORT_SYMBOL(sys_truncate);
>
> =A0static long do_sys_ftruncate(unsigned int fd, loff_t length, int s=
mall)
> =A0{
> @@ -1062,6 +1063,7 @@ SYSCALL_DEFINE3(open, const char __user *, file=
name, int, flags, int, mode)
> =A0 =A0 =A0 =A0asmlinkage_protect(3, ret, filename, flags, mode);
> =A0 =A0 =A0 =A0return ret;
> =A0}
> +EXPORT_SYMBOL(sys_open);
>
> =A0SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, i=
nt, flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int, mode)
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 3ac2898..75e9f60 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -453,6 +453,8 @@ SYSCALL_DEFINE(pwrite64)(unsigned int fd, const c=
har __user *buf,
>
> =A0 =A0 =A0 =A0return ret;
> =A0}
> +EXPORT_SYMBOL(sys_pwrite64);
> +
> =A0#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
> =A0asmlinkage long SyS_pwrite64(long fd, long buf, long count, loff_t=
 pos)
> =A0{
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 6d4f6d3..488c889 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -294,6 +294,7 @@ SYSCALL_DEFINE5(setxattr, const char __user *, pa=
thname,
> =A0 =A0 =A0 =A0path_put(&path);
> =A0 =A0 =A0 =A0return error;
> =A0}
> +EXPORT_SYMBOL(sys_setxattr);
>
> =A0SYSCALL_DEFINE5(lsetxattr, const char __user *, pathname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char __user *, name, const void =
__user *, value,
> @@ -523,6 +524,7 @@ SYSCALL_DEFINE2(removexattr, const char __user *,=
 pathname,
> =A0 =A0 =A0 =A0path_put(&path);
> =A0 =A0 =A0 =A0return error;
> =A0}
> +EXPORT_SYMBOL(sys_removexattr);
>
> =A0SYSCALL_DEFINE2(lremovexattr, const char __user *, pathname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char __user *, name)
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
