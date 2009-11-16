From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] btrfs-progs: Check mount status of multidevice
	filesystems
Date: Mon, 16 Nov 2009 10:11:15 +0800
Message-ID: <3d0408630911151811u55fdb6rf82a97a1ee620e43@mail.gmail.com>
References: <200911141944.51824.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Andi Drebes <lists-receive@programmierforen.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911141944.51824.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 15, 2009 at 2:44 AM, Andi Drebes
<lists-receive@programmierforen.de> wrote:
> Some programs like btrfsck should not be run on a mounted filesystem.
> This patch adds a check in btrfs_open_devices() for the mount status
> of every device belonging to the filesystem. The function check_mount=
()
> gets improved support for loopback devices. It now detects if the
> program is run on the file that is being used by the loopback device.
>
Hi Andi,

Thank you for sending the patch.

Would you please add mounted check for multiple devices FS to
check_mounted instead of btrfs_open_devices.  It's easy to get the
list of devices, see code at very beginning of open_ctree_fd().

Yan, Zheng

> ---besides
> diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
> index a109c6a..1e0ef9f 100644
> --- a/btrfs-map-logical.c
> +++ b/btrfs-map-logical.c
> @@ -169,7 +169,7 @@ int main(int ac, char **av)
> =A0 =A0 =A0 =A0radix_tree_init();
> =A0 =A0 =A0 =A0cache_tree_init(&root_cache);
>
> - =A0 =A0 =A0 root =3D open_ctree(dev, 0, 0);
> + =A0 =A0 =A0 root =3D open_ctree(dev, 0, 0, 0);
> =A0 =A0 =A0 =A0if (!root) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "Open ctree failed\n")=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> diff --git a/btrfsck.c b/btrfsck.c
> index 73f1836..1434791 100644
> --- a/btrfsck.c
> +++ b/btrfsck.c
> @@ -2821,7 +2821,7 @@ int main(int ac, char **av)
>
> =A0 =A0 =A0 =A0radix_tree_init();
> =A0 =A0 =A0 =A0cache_tree_init(&root_cache);
> - =A0 =A0 =A0 root =3D open_ctree(av[1], 0, 0);
> + =A0 =A0 =A0 root =3D open_ctree(av[1], 0, 0, 1);
>
> =A0 =A0 =A0 =A0if (root =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> diff --git a/debug-tree.c b/debug-tree.c
> index 1d47519..a8e85f4 100644
> --- a/debug-tree.c
> +++ b/debug-tree.c
> @@ -137,7 +137,7 @@ int main(int ac, char **av)
> =A0 =A0 =A0 =A0if (ac !=3D 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0print_usage();
>
> - =A0 =A0 =A0 root =3D open_ctree(av[optind], 0, 0);
> + =A0 =A0 =A0 root =3D open_ctree(av[optind], 0, 0, 0);
> =A0 =A0 =A0 =A0if (!root) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "unable to open %s\n",=
 av[optind]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> diff --git a/disk-io.c b/disk-io.c
> index addebe1..f8e623b 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -570,7 +570,7 @@ struct btrfs_root *btrfs_read_fs_root(struct btrf=
s_fs_info *fs_info,
> =A0 =A0 =A0 =A0return root;
> =A0}
>
> -struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, i=
nt writes)
> +struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, i=
nt writes, int check_mount)
> =A0{
> =A0 =A0 =A0 =A0int fp;
> =A0 =A0 =A0 =A0struct btrfs_root *root;
> @@ -584,14 +584,14 @@ struct btrfs_root *open_ctree(const char *filen=
ame, u64 sb_bytenr, int writes)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf (stderr, "Could not open %s\n"=
, filename);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NULL;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 root =3D open_ctree_fd(fp, filename, sb_bytenr, writes)=
;
> + =A0 =A0 =A0 root =3D open_ctree_fd(fp, filename, sb_bytenr, writes,=
 check_mount);
> =A0 =A0 =A0 =A0close(fp);
>
> =A0 =A0 =A0 =A0return root;
> =A0}
>
> =A0struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_=
bytenr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int =
writes)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int =
writes, int check_mount)
> =A0{
> =A0 =A0 =A0 =A0u32 sectorsize;
> =A0 =A0 =A0 =A0u32 nodesize;
> @@ -657,9 +657,9 @@ struct btrfs_root *open_ctree_fd(int fp, const ch=
ar *path, u64 sb_bytenr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs_info, BTRFS_ROOT_TREE_OBJE=
CTID);
>
> =A0 =A0 =A0 =A0if (writes)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_open_devices(fs_devices, =
O_RDWR);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_open_devices(fs_devices, =
O_RDWR, check_mount);
> =A0 =A0 =A0 =A0else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_open_devices(fs_devices, =
O_RDONLY);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_open_devices(fs_devices, =
O_RDONLY, check_mount);
> =A0 =A0 =A0 =A0BUG_ON(ret);
>
> =A0 =A0 =A0 =A0fs_info->super_bytenr =3D sb_bytenr;
> @@ -725,7 +725,7 @@ struct btrfs_root *open_ctree_fd(int fp, const ch=
ar *path, u64 sb_bytenr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BTRFS_UUID_SIZE);
>
> =A0 =A0 =A0 =A0if (!(btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG=
_METADUMP)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_read_chunk_tree(chunk_roo=
t);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_read_chunk_tree(chunk_roo=
t, check_mount);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(ret);
> =A0 =A0 =A0 =A0}
>
> diff --git a/disk-io.h b/disk-io.h
> index 49e5692..1d6519e 100644
> --- a/disk-io.h
> +++ b/disk-io.h
> @@ -43,9 +43,9 @@ struct extent_buffer *btrfs_find_create_tree_block(=
struct btrfs_root *root,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 bytenr, u32 blocksize);
> =A0int clean_tree_block(struct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_root *root, stru=
ct extent_buffer *buf);
> -struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, i=
nt writes);
> +struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, i=
nt writes, int check_mount);
> =A0struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_=
bytenr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int =
writes);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int =
writes, int check_mount);
> =A0int close_ctree(struct btrfs_root *root);
> =A0int write_ctree_super(struct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_root *root);
> diff --git a/kerncompat.h b/kerncompat.h
> index e4c8ce0..46236cd 100644
> --- a/kerncompat.h
> +++ b/kerncompat.h
> @@ -42,7 +42,11 @@
> =A0#define GFP_NOFS 0
> =A0#define __read_mostly
> =A0#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> +
> +#ifndef ULONG_MAX
> =A0#define ULONG_MAX =A0 =A0 =A0 (~0UL)
> +#endif
> +
> =A0#define BUG() abort()
> =A0#ifdef __CHECKER__
> =A0#define __force =A0 =A0__attribute__((force))
> diff --git a/mkfs.c b/mkfs.c
> index 2e99b95..f226661 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -456,7 +456,7 @@ int main(int ac, char **av)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "error during mkfs %d\=
n", ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 root =3D open_ctree(file, 0, O_RDWR);
> + =A0 =A0 =A0 root =3D open_ctree(file, 0, O_RDWR, 1);
> =A0 =A0 =A0 =A0root->fs_info->alloc_start =3D alloc_start;
>
> =A0 =A0 =A0 =A0ret =3D make_root_dir(root);
> diff --git a/utils.c b/utils.c
> index 2f4c6e1..60c3f24 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -31,6 +31,8 @@
> =A0#include <fcntl.h>
> =A0#include <unistd.h>
> =A0#include <mntent.h>
> +#include <linux/loop.h>
> +#include <limits.h>
> =A0#include "kerncompat.h"
> =A0#include "radix-tree.h"
> =A0#include "ctree.h"
> @@ -586,46 +588,105 @@ error:
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
> +int is_loop_device (const char *device) {
> + =A0 =A0 =A0 struct stat statbuf;
> +
> + =A0 =A0 =A0 if(stat(device, &statbuf) < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -errno;
> +
> + =A0 =A0 =A0 return (S_ISBLK(statbuf.st_mode) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 major(statbuf.st_rdev) =3D=3D LOOP_MAJO=
R);
> +}
> +
> +int is_same_blk_file(const char* a, const char* b)
> +{
> + =A0 =A0 =A0 struct stat st_buf_a, st_buf_b;
> + =A0 =A0 =A0 char real_a[PATH_MAX];
> + =A0 =A0 =A0 char real_b[PATH_MAX];
> +
> + =A0 =A0 =A0 if(!realpath(a, real_a) ||
> + =A0 =A0 =A0 =A0 =A0!realpath(b, real_b))
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -errno;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Identical path? */
> + =A0 =A0 =A0 if(strcmp(real_a, real_b) =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> +
> + =A0 =A0 =A0 if(stat(a, &st_buf_a) < 0 ||
> + =A0 =A0 =A0 =A0 =A0stat(b, &st_buf_b) < 0)
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -errno;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Same blockdevice? */
> + =A0 =A0 =A0 if(S_ISBLK(st_buf_a.st_mode) &&
> + =A0 =A0 =A0 =A0 =A0S_ISBLK(st_buf_b.st_mode) &&
> + =A0 =A0 =A0 =A0 =A0st_buf_a.st_rdev =3D=3D st_buf_b.st_rdev)
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Hardlink? */
> + =A0 =A0 =A0 if (st_buf_a.st_dev =3D=3D st_buf_b.st_dev &&
> + =A0 =A0 =A0 =A0 =A0 st_buf_a.st_ino =3D=3D st_buf_b.st_ino)
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> =A0/*
> =A0* returns 1 if the device was mounted, < 0 on error or 0 if everyt=
hing
> - * is safe to continue. =A0TODO, this should also scan multi-device =
filesystems
> + * is safe to continue.
> =A0*/
> =A0int check_mounted(char *file)
> =A0{
> =A0 =A0 =A0 =A0struct mntent *mnt;
> - =A0 =A0 =A0 struct stat st_buf;
> - =A0 =A0 =A0 dev_t file_dev =3D 0;
> - =A0 =A0 =A0 dev_t file_rdev =3D 0;
> - =A0 =A0 =A0 ino_t file_ino =3D 0;
> =A0 =A0 =A0 =A0FILE *f;
> =A0 =A0 =A0 =A0int ret =3D 0;
>
> - =A0 =A0 =A0 if ((f =3D setmntent ("/proc/mounts", "r")) =3D=3D NULL=
)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -errno;
> + =A0 =A0 =A0 int loop_fd;
> + =A0 =A0 =A0 struct loop_info loopinfo;
>
> - =A0 =A0 =A0 if (stat(file, &st_buf) < 0) {
> + =A0 =A0 =A0 if ((f =3D setmntent ("/proc/mounts", "r")) =3D=3D NULL=
)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -errno;
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (S_ISBLK(st_buf.st_mode)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 file_rdev =3D st_buf.st=
_rdev;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 file_dev =3D st_buf.st_=
dev;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 file_ino =3D st_buf.st_=
ino;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0while ((mnt =3D getmntent (f)) !=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strcmp(file, mnt->mnt_fsname) =3D=3D=
 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Only check btrfs filesystems */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(strcmp(mnt->mnt_type, "btrfs") !=3D =
0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (stat(mnt->mnt_fsname, &st_buf) =3D=3D=
 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (S_ISBLK(st_buf.st_m=
ode)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fil=
e_rdev && (file_rdev =3D=3D st_buf.st_rdev))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (file_dev && =
((file_dev =3D=3D st_buf.st_dev) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 (file_ino =3D=3D st_buf.st_ino))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D is_loop_device(mnt->mnt_fsname)=
;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(ret < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Current entry is a l=
oop device */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((loop_fd =3D open(m=
nt->mnt_fsname, O_RDONLY)) < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 -errno;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t_err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Get loop device info=
 and check */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ioctl(loop_fd, LOOP=
_GET_STATUS, &loopinfo) =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 is_same_blk_file(file, loopinfo.lo_name);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(ret =
< 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto out_err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if=
(ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 -errno;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t_err;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* normal block device =
*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(is_same_blk_file(fil=
e, mnt->mnt_fsname) > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> @@ -634,6 +695,7 @@ int check_mounted(char *file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D 1;
> =A0 =A0 =A0 =A0}
>
> +out_err:
> =A0 =A0 =A0 =A0endmntent (f);
> =A0 =A0 =A0 =A0return ret;
> =A0}
> diff --git a/utils.h b/utils.h
> index 7ff542b..695686b 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -19,6 +19,12 @@
> =A0#ifndef __UTILS__
> =A0#define __UTILS__
>
> +#define LOOP_MAJOR 7
> +
> +#ifndef major
> +#define major(dev) =A0 =A0 ((dev) >> 8)
> +#endif
> +
> =A0#define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
>
> =A0int make_btrfs(int fd, const char *device, const char *label,
> diff --git a/volumes.c b/volumes.c
> index 7671855..467f552 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -29,6 +29,7 @@
> =A0#include "transaction.h"
> =A0#include "print-tree.h"
> =A0#include "volumes.h"
> +#include "utils.h"
>
> =A0struct stripe {
> =A0 =A0 =A0 =A0struct btrfs_device *dev;
> @@ -164,7 +165,7 @@ again:
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> -int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flag=
s)
> +int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flag=
s, int check_mount)
> =A0{
> =A0 =A0 =A0 =A0int fd;
> =A0 =A0 =A0 =A0struct list_head *head =3D &fs_devices->devices;
> @@ -175,6 +176,19 @@ int btrfs_open_devices(struct btrfs_fs_devices *=
fs_devices, int flags)
> =A0 =A0 =A0 =A0list_for_each(cur, head) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0device =3D list_entry(cur, struct btrf=
s_device, dev_list);
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(check_mount) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D check_mounted(d=
evice->name);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf=
(stderr, "error checking %s mount status\n", device->name);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fa=
il;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D 1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf=
(stderr, "Error: %s is currently mounted.\n", device->name);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 -EBUSY;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fa=
il;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fd =3D open(device->name, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (fd < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -errno;
> @@ -1240,7 +1254,7 @@ static int fill_device_from_item(struct extent_=
buffer *leaf,
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> -static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
> +static int open_seed_devices(struct btrfs_root *root, u8 *fsid, int =
check_mount)
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_fs_devices *fs_devices;
> =A0 =A0 =A0 =A0int ret;
> @@ -1260,7 +1274,7 @@ static int open_seed_devices(struct btrfs_root =
*root, u8 *fsid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 ret =3D btrfs_open_devices(fs_devices, O_RDONLY);
> + =A0 =A0 =A0 ret =3D btrfs_open_devices(fs_devices, O_RDONLY, check_=
mount);
> =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> @@ -1272,7 +1286,8 @@ out:
>
> =A0static int read_one_dev(struct btrfs_root *root,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct extent_buffer *=
leaf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_dev_item *=
dev_item)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_dev_item *=
dev_item,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int check_mount)
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_device *device;
> =A0 =A0 =A0 =A0u64 devid;
> @@ -1289,7 +1304,7 @@ static int read_one_dev(struct btrfs_root *root=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BTRFS_UUID_SIZE);
>
> =A0 =A0 =A0 =A0if (memcmp(fs_uuid, root->fs_info->fsid, BTRFS_UUID_SI=
ZE)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D open_seed_devices(root, fs_uuid=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D open_seed_devices(root, fs_uuid=
, check_mount);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;
> =A0 =A0 =A0 =A0}
> @@ -1311,13 +1326,13 @@ static int read_one_dev(struct btrfs_root *ro=
ot,
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
> -int btrfs_read_super_device(struct btrfs_root *root, struct extent_b=
uffer *buf)
> +int btrfs_read_super_device(struct btrfs_root *root, struct extent_b=
uffer *buf, int check_mount)
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_dev_item *dev_item;
>
> =A0 =A0 =A0 =A0dev_item =3D (struct btrfs_dev_item *)offsetof(struct =
btrfs_super_block,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_item);
> - =A0 =A0 =A0 return read_one_dev(root, buf, dev_item);
> + =A0 =A0 =A0 return read_one_dev(root, buf, dev_item, check_mount);
> =A0}
>
> =A0int btrfs_read_sys_array(struct btrfs_root *root)
> @@ -1378,7 +1393,7 @@ int btrfs_read_sys_array(struct btrfs_root *roo=
t)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> -int btrfs_read_chunk_tree(struct btrfs_root *root)
> +int btrfs_read_chunk_tree(struct btrfs_root *root, int check_mount)
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_path *path;
> =A0 =A0 =A0 =A0struct extent_buffer *leaf;
> @@ -1421,7 +1436,7 @@ again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 btrfs_dev_item *dev_item;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_it=
em =3D btrfs_item_ptr(leaf, slot,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_dev_item);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 read_one_dev(root, leaf, dev_item);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 read_one_dev(root, leaf, dev_item, check_mount);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON=
(ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (found_key.type =3D=3D BTRFS=
_CHUNK_ITEM_KEY) {
> diff --git a/volumes.h b/volumes.h
> index bb78751..baf12ff 100644
> --- a/volumes.h
> +++ b/volumes.h
> @@ -103,16 +103,16 @@ int btrfs_rmap_block(struct btrfs_mapping_tree =
*map_tree,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 chunk_start, u64 physical=
, u64 devid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 **logical, int *naddrs, i=
nt *stripe_len);
> =A0int btrfs_read_sys_array(struct btrfs_root *root);
> -int btrfs_read_chunk_tree(struct btrfs_root *root);
> +int btrfs_read_chunk_tree(struct btrfs_root *root, int check_mount);
> =A0int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_root *extent_=
root, u64 *start,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u64 *num_bytes, u64 type);
> -int btrfs_read_super_device(struct btrfs_root *root, struct extent_b=
uffer *buf);
> +int btrfs_read_super_device(struct btrfs_root *root, struct extent_b=
uffer *buf, int check_mount);
> =A0int btrfs_add_device(struct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_root *root,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_device *device);
> =A0int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int flags, int check_mou=
nt);
> =A0int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
> =A0int btrfs_add_device(struct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_root *root,
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
