Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45471 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751769AbdGYU5i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 16:57:38 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D4633AD16
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 20:57:36 +0000 (UTC)
Subject: Re: [PATCH 3/3] btrfs-progs: convert: add support for converting
 reiserfs
To: linux-btrfs@vger.kernel.org
References: <20170725205443.29874-1-jeffm@suse.com>
 <20170725205443.29874-3-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <85ada2ad-d177-bed8-338f-4ed82dd997c1@suse.com>
Date: Tue, 25 Jul 2017 16:57:35 -0400
MIME-Version: 1.0
In-Reply-To: <20170725205443.29874-3-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="G1CLran2P1RLJFwcLIOHndcfjFP57cvOj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G1CLran2P1RLJFwcLIOHndcfjFP57cvOj
Content-Type: multipart/mixed; boundary="iKPFfa0M2WnSw3Jr0PvxPF74kXwoDC0N4";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <85ada2ad-d177-bed8-338f-4ed82dd997c1@suse.com>
Subject: Re: [PATCH 3/3] btrfs-progs: convert: add support for converting
 reiserfs
References: <20170725205443.29874-1-jeffm@suse.com>
 <20170725205443.29874-3-jeffm@suse.com>
In-Reply-To: <20170725205443.29874-3-jeffm@suse.com>

--iKPFfa0M2WnSw3Jr0PvxPF74kXwoDC0N4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/25/17 4:54 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> This patch adds support to convert reiserfs file systems in-place to bt=
rfs.
>=20
> It will convert extended attribute files to btrfs extended attributes,
> translate ACLs, coalesce tails that consist of multiple items into one =
item,
> and convert tails that are too big into indirect files.
>=20
> This requires that libreiserfscore 3.6.27 be available.
>=20
> Many of the test cases for convert apply regardless of what the source
> file system is and using ext4 is sufficient.  I've included several
> test cases that are reiserfs-specific.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  Makefile                                           |    3 +-
>  Makefile.inc.in                                    |    3 +-
>  configure.ac                                       |   10 +-
>  convert/main.c                                     |   13 +-
>  convert/source-reiserfs.c                          | 1011 ++++++++++++=
++++++++
>  convert/source-reiserfs.h                          |  105 ++
>  tests/common.convert                               |   14 +-
>  tests/convert-tests/010-reiserfs-basic/test.sh     |   16 +
>  .../011-reiserfs-delete-all-rollback/test.sh       |   67 ++
>  .../012-reiserfs-large-hole-extent/test.sh         |   23 +
>  .../013-reiserfs-common-inode-flags/test.sh        |   35 +
>  11 files changed, 1290 insertions(+), 10 deletions(-)
>  create mode 100644 convert/source-reiserfs.c
>  create mode 100644 convert/source-reiserfs.h
>  create mode 100755 tests/convert-tests/010-reiserfs-basic/test.sh
>  create mode 100755 tests/convert-tests/011-reiserfs-delete-all-rollbac=
k/test.sh
>  create mode 100755 tests/convert-tests/012-reiserfs-large-hole-extent/=
test.sh
>  create mode 100755 tests/convert-tests/013-reiserfs-common-inode-flags=
/test.sh
>=20
> diff --git a/Makefile b/Makefile
> index 81598df..f7f6dab 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -111,7 +111,7 @@ libbtrfs_headers =3D send-stream.h send-utils.h sen=
d.h kernel-lib/rbtree.h btrfs-l
>  	       kernel-lib/radix-tree.h kernel-lib/sizes.h extent-cache.h \
>  	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
>  convert_objects =3D convert/main.o convert/common.o convert/source-fs.=
o \
> -		  convert/source-ext2.o
> +		  convert/source-ext2.o convert/source-reiserfs.o
>  mkfs_objects =3D mkfs/main.o mkfs/common.o
> =20
>  TESTS =3D fsck-tests.sh convert-tests.sh
> @@ -188,6 +188,7 @@ endif
>  # external libs required by various binaries; for btrfs-foo,
>  # specify btrfs_foo_libs =3D <list of libs>; see $($(subst...)) rules =
below
>  btrfs_convert_cflags =3D -DBTRFSCONVERT_EXT2=3D$(BTRFSCONVERT_EXT2)
> +btrfs_convert_cflags +=3D -DBTRFSCONVERT_REISERFS=3D$(BTRFSCONVERT_REI=
SERFS)
>  btrfs_fragments_libs =3D -lgd -lpng -ljpeg -lfreetype
>  btrfs_debug_tree_objects =3D cmds-inspect-dump-tree.o
>  btrfs_show_super_objects =3D cmds-inspect-dump-super.o
> diff --git a/Makefile.inc.in b/Makefile.inc.in
> index 4e1b68c..3c7bc03 100644
> --- a/Makefile.inc.in
> +++ b/Makefile.inc.in
> @@ -12,6 +12,7 @@ INSTALL =3D @INSTALL@
>  DISABLE_DOCUMENTATION =3D @DISABLE_DOCUMENTATION@
>  DISABLE_BTRFSCONVERT =3D @DISABLE_BTRFSCONVERT@
>  BTRFSCONVERT_EXT2 =3D @BTRFSCONVERT_EXT2@
> +BTRFSCONVERT_REISERFS =3D @BTRFSCONVERT_REISERFS@
> =20
>  SUBST_CFLAGS =3D @CFLAGS@
>  SUBST_LDFLAGS =3D @LDFLAGS@
> @@ -31,6 +32,6 @@ udevruledir =3D ${udevdir}/rules.d
> =20
>  # external libs required by various binaries; for btrfs-foo,
>  # specify btrfs_foo_libs =3D <list of libs>; see $($(subst...)) rules =
in Makefile
> -btrfs_convert_libs =3D @EXT2FS_LIBS@ @COM_ERR_LIBS@
> +btrfs_convert_libs =3D @EXT2FS_LIBS@ @COM_ERR_LIBS@ @REISERFS_LIBS@
> =20
>  MAKEFILE_INC_INCLUDED =3D yes
> diff --git a/configure.ac b/configure.ac
> index 30055f8..3a8bd3f 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -120,6 +120,7 @@ fi
> =20
>  convertfs=3D
>  BTRFSCONVERT_EXT2=3D0
> +BTRFSCONVERT_REISERFS=3D0
>  if test "x$enable_convert" =3D xyes; then
>  	if test "x$with_convert" =3D "xauto" || echo "$with_convert" | grep -=
q "ext2"; then
>  		PKG_CHECK_MODULES(EXT2FS, [ext2fs >=3D 1.42],,
> @@ -131,11 +132,18 @@ if test "x$enable_convert" =3D xyes; then
>  		convertfs=3D"${convertfs:+$convertfs,}ext2"
>  		BTRFSCONVERT_EXT2=3D1
>  	fi
> +	if test "x$with_convert" =3D "xauto" || echo "$with_convert" | grep -=
q "reiserfs"; then
> +		PKG_CHECK_MODULES(REISERFS, [reiserfscore >=3D 3.6.27],
> +				  [BTRFSCONVERT_REISERFS=3D1],[])
> +		convertfs=3D"${convertfs:+$convertfs,}reiserfs"
> +		BTRFSCONVERT_REISERFS=3D1
> +	fi
>  fi
>  AC_SUBST([BTRFSCONVERT_EXT2])
> +AC_SUBST([BTRFSCONVERT_REISERFS])
> =20
>  # catch typos
> -tmp=3D$(echo "$with_convert" | sed -e 's/auto//' | sed -e 's/ext2//' |=
 sed -e 's/,\+/,/')
> +tmp=3D$(echo "$with_convert" | sed -e 's/auto//' | sed -e 's/ext2//' |=
 sed -e 's/reiserfs//' | sed -e 's/,\+/,/')
>  if ! test "x$tmp" =3D "x"; then
>  	AC_MSG_ERROR([unknown tokens for --with-convert: $tmp])
>  fi
> diff --git a/convert/main.c b/convert/main.c
> index 01657a6..bc459a4 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -102,12 +102,16 @@
>  #include "convert/source-fs.h"
>  #include "fsfeatures.h"
> =20
> -const struct btrfs_convert_operations ext2_convert_ops;
> +extern const struct btrfs_convert_operations ext2_convert_ops;
> +extern const struct btrfs_convert_operations reiserfs_convert_ops;
> =20
>  static const struct btrfs_convert_operations *convert_operations[] =3D=
 {
>  #if BTRFSCONVERT_EXT2
>  	&ext2_convert_ops,
>  #endif
> +#if BTRFSCONVERT_REISERFS
> +	&reiserfs_convert_ops,
> +#endif
>  };
> =20
>  static void *print_copied_inodes(void *p)
> @@ -411,7 +415,7 @@ static int migrate_one_reserved_range(struct btrfs_=
trans_handle *trans,
>  }
> =20
>  /*
> - * Relocate the used ext2 data in reserved ranges
> + * Relocate the used source fs data in reserved ranges
>   */
>  static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
>  				   struct btrfs_root *root,
> @@ -1655,11 +1659,11 @@ static int do_rollback(const char *devname)
>  	ret =3D btrfs_search_slot(NULL, fs_info->tree_root, &key, &path, 0, 0=
);
>  	btrfs_release_path(&path);
>  	if (ret > 0) {
> -		error("unable to find ext2 image subvolume, is it deleted?");
> +		error("unable to find source fs image subvolume, is it deleted?");
>  		ret =3D -ENOENT;
>  		goto close_fs;
>  	} else if (ret < 0) {
> -		error("failed to find ext2 image subvolume: %s",
> +		error("failed to find source fs image subvolume: %s",
>  			strerror(-ret));
>  		goto close_fs;
>  	}
> @@ -1777,6 +1781,7 @@ static void print_usage(void)
>  	printf("\n");
>  	printf("Supported filesystems:\n");
>  	printf("\text2/3/4: %s\n", BTRFSCONVERT_EXT2 ? "yes" : "no");
> +	printf("\treiserfs: %s\n", BTRFSCONVERT_REISERFS ? "yes" : "no");
>  }
> =20
>  int main(int argc, char *argv[])
> diff --git a/convert/source-reiserfs.c b/convert/source-reiserfs.c
> new file mode 100644
> index 0000000..2d9d4bc
> --- /dev/null
> +++ b/convert/source-reiserfs.c
> @@ -0,0 +1,1011 @@
> +/*
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#if BTRFSCONVERT_REISERFS
> +
> +#include "kerncompat.h"
> +#include <linux/limits.h>
> +#include <linux/fs.h>
> +#include <limits.h>
> +#include <sys/stat.h>
> +#include "disk-io.h"
> +#include "transaction.h"
> +#include "utils.h"
> +#include "bitops.h"
> +#include "convert/common.h"
> +#include "convert/source-reiserfs.h"
> +
> +static inline u8 mode_to_file_type(u32 mode)
> +{
> +	switch (mode & S_IFMT) {
> +	case S_IFREG:	return BTRFS_FT_REG_FILE;
> +	case S_IFDIR:	return BTRFS_FT_DIR;
> +	case S_IFCHR:	return BTRFS_FT_CHRDEV;
> +	case S_IFBLK:	return BTRFS_FT_BLKDEV;
> +	case S_IFIFO:	return BTRFS_FT_FIFO;
> +	case S_IFSOCK:	return BTRFS_FT_SOCK;
> +	case S_IFLNK:	return BTRFS_FT_SYMLINK;
> +	};
> +
> +	return BTRFS_FT_UNKNOWN;
> +}
> +
> +
> +struct reiserfs_convert_info {
> +	int privroot_found;
> +	struct reiserfs_key privroot_key;
> +	struct reiserfs_key xattr_key;
> +	int copy_attrs;
> +
> +	struct task_ctx *progress;
> +
> +	/* used to track hardlinks */
> +	unsigned used_slots;
> +	unsigned alloced_slots;
> +	u64 *objectids;
> +};
> +
> +static u32 reiserfs_count_objectids(reiserfs_filsys_t fs)
> +{
> +	struct reiserfs_super_block *sb =3D fs->fs_ondisk_sb;
> +	u32 count =3D 0;
> +	u32 *map;
> +	int i;
> +
> +	if (fs->fs_format =3D=3D REISERFS_FORMAT_3_6)
> +		map =3D (u32 *) (sb + 1);
> +	else
> +		map =3D (u32 *)((struct reiserfs_super_block_v1 *)sb + 1);
> +
> +	for (i =3D 0; i < get_sb_oid_cursize(sb); i +=3D 2)
> +		count +=3D le32_to_cpu(map[i + 1]) - (le32_to_cpu(map[i]) + 1);
> +
> +	return count;
> +}
> +
> +
> +static int reiserfs_open_fs(struct btrfs_convert_context *cxt, const c=
har *name)
> +{
> +	struct reiserfs_convert_info *info;
> +	reiserfs_filsys_t fs;
> +	long error;
> +
> +	fs =3D reiserfs_open(name, O_RDONLY, &error, NULL, 0);
> +	if (!fs)
> +		return -1;
> +
> +	error =3D reiserfs_open_ondisk_bitmap(fs);
> +	if (error) {
> +		reiserfs_close(fs);
> +		return -1;
> +	}
> +
> +	cxt->fs_data =3D fs;
> +	cxt->blocksize =3D fs->fs_blocksize;
> +	cxt->block_count =3D get_sb_block_count(fs->fs_ondisk_sb);
> +	cxt->total_bytes =3D cxt->blocksize * cxt->block_count;
> +	cxt->volume_name =3D strndup(fs->fs_ondisk_sb->s_label, 16);
> +	cxt->first_data_block =3D 0;
> +	cxt->inodes_count =3D reiserfs_count_objectids(fs);
> +	cxt->free_inodes_count =3D 0;
> +	info =3D calloc(1, sizeof(*info));
> +	if (!info) {
> +		reiserfs_close(fs);
> +		return -1;
> +	}
> +
> +	/*
> +	 * Inode attributes are somewhat of a hack on reiserfs and it was
> +	 * once possible to have garbage in the flags field.  A superblock
> +	 * field now indicates that the field has been cleared and can
> +	 * be considered valid, but only on v3.6 format file systems.
> +	 */
> +	if (fs->fs_format =3D=3D REISERFS_FORMAT_3_6 &&
> +	    get_sb_v2_flag(fs->fs_ondisk_sb, reiserfs_attrs_cleared))
> +		info->copy_attrs =3D 1;
> +
> +	fs->fs_vp =3D info;
> +	return 0;
> +}
> +
> +#if 0

Whoops.  This will be removed as part of the next submission after review=
=2E

-Jeff

> +static int reiserfs_alloc_block(struct btrfs_convert_context *cxt, u64=
 goal,
> +				u64 *block_ret)
> +{
> +	int ret;
> +	reiserfs_filsys_t fs =3D cxt->fs_data;
> +	unsigned long block =3D goal;
> +
> +	ret =3D reiserfs_bitmap_find_zero_bit(fs->fs_bitmap2, &block);
> +
> +	if (ret !=3D 0)
> +		return -1;
> +
> +	reiserfs_bitmap_set_bit(fs->fs_bitmap2, block);
> +
> +	*block_ret =3D block;
> +	return 0;
> +}
> +
> +static void bc_reiserfs_free_block(struct btrfs_convert_context *cxt, =
u64 block)
> +{
> +	reiserfs_filsys_t fs =3D cxt->fs_data;
> +	reiserfs_bitmap_clear_bit(fs->fs_bitmap2, block);
> +}
> +
> +static int reiserfs_test_block(struct btrfs_convert_context *cxt, u64 =
block64)
> +{
> +	reiserfs_filsys_t fs =3D cxt->fs_data;
> +	u32 block =3D block64;
> +
> +	BUG_ON(block !=3D block64);
> +	return reiserfs_bitmap_test_bit(fs->fs_bitmap2, block);
> +}
> +#endif
> +
> +static void reiserfs_close_fs(struct btrfs_convert_context *cxt)
> +{
> +	reiserfs_filsys_t fs =3D cxt->fs_data;
> +	struct reiserfs_convert_info *info =3D fs->fs_vp;
> +
> +	if (info) {
> +		if (info->objectids)
> +			free(info->objectids);
> +		free(info);
> +		fs->fs_vp =3D NULL;
> +	}
> +
> +	/* We don't want changes to be persistent */
> +	fs->fs_bitmap2->bm_dirty =3D 0;
> +
> +	reiserfs_close(fs);
> +}
> +
> +static int compare_objectids(const void *p1, const void *p2)
> +{
> +	u64 v1 =3D *(u64 *)p1;
> +	u64 v2 =3D *(u64 *)p2;
> +
> +	if (v1 > v2)
> +		return 1;
> +	else if (v1 < v2)
> +		return -1;
> +	return 0;
> +}
> +
> +static int lookup_cached_objectid(reiserfs_filsys_t fs, u64 objectid)
> +{
> +	struct reiserfs_convert_info *info =3D fs->fs_vp;
> +	u64 *result;
> +
> +	if (!info->objectids)
> +		return 0;
> +	result =3D bsearch(&objectid, info->objectids, info->used_slots,
> +			 sizeof(u64), compare_objectids);
> +	return result !=3D NULL;
> +}
> +
> +static int insert_cached_objectid(reiserfs_filsys_t fs, u64 objectid)
> +{
> +	struct reiserfs_convert_info *info =3D fs->fs_vp;
> +
> +	if (info->used_slots + 1 >=3D info->alloced_slots) {
> +		u64 *objectids =3D realloc(info->objectids,
> +				    (info->alloced_slots + 1000) * sizeof(u64));
> +		if (!objectids)
> +			return -ENOMEM;
> +		info->objectids =3D objectids;
> +		info->alloced_slots +=3D 1000;
> +	}
> +	info->objectids[info->used_slots++] =3D objectid;
> +
> +	qsort(info->objectids, info->used_slots, sizeof(u64),
> +	      compare_objectids);
> +	return 0;
> +}
> +
> +static int reiserfs_locate_privroot(reiserfs_filsys_t fs)
> +{
> +	int err;
> +	unsigned generation;
> +	struct reiserfs_convert_info *info =3D fs->fs_vp;
> +	struct reiserfs_key key =3D root_dir_key;
> +
> +	err =3D reiserfs_find_entry(fs, &key, ".reiserfs_priv",
> +				  &generation, &info->privroot_key);
> +	if (err =3D=3D 1) {
> +		err =3D reiserfs_find_entry(fs, &info->privroot_key, "xattrs",
> +					  &generation, &info->xattr_key);
> +		if (err !=3D 1)
> +			memset(&info->xattr_key, 0, sizeof(info->xattr_key));
> +	}
> +
> +	return 0;
> +}
> +
> +static void reiserfs_convert_inode_flags(struct btrfs_inode_item *inod=
e,
> +					 const struct stat_data *sd)
> +{
> +	u16 attrs =3D sd_v2_sd_attrs(sd);
> +	u64 new_flags =3D 0;
> +
> +	if (attrs & FS_IMMUTABLE_FL)
> +		new_flags |=3D BTRFS_INODE_IMMUTABLE;
> +
> +	if (attrs & FS_APPEND_FL)
> +		new_flags |=3D BTRFS_INODE_APPEND;
> +
> +	if (attrs & FS_SYNC_FL)
> +		new_flags |=3D BTRFS_INODE_SYNC;
> +
> +	if (attrs & FS_NOATIME_FL)
> +		new_flags |=3D BTRFS_INODE_NOATIME;
> +
> +	if (attrs & FS_NODUMP_FL)
> +		new_flags |=3D BTRFS_INODE_NODUMP;
> +
> +	if (attrs & FS_NODUMP_FL)
> +		new_flags |=3D BTRFS_INODE_NODUMP;
> +
> +	btrfs_set_stack_inode_flags(inode, new_flags);
> +
> +}
> +
> +static void reiserfs_copy_inode_item(struct btrfs_inode_item *inode,
> +				     struct item_head *ih, void *stat_data,
> +				     int copy_inode_flags)
> +{
> +	u32 mode;
> +	u32 rdev =3D 0;
> +
> +	memset(inode, 0, sizeof(*inode));
> +	btrfs_set_stack_inode_generation(inode, 1);
> +	if (get_ih_key_format(ih) =3D=3D KEY_FORMAT_1) {
> +		struct stat_data_v1 *sd =3D stat_data;
> +
> +		mode =3D sd_v1_mode(sd);
> +		btrfs_set_stack_inode_size(inode, sd_v1_size(sd));
> +		btrfs_set_stack_inode_nlink(inode, sd_v1_nlink(sd));
> +		btrfs_set_stack_inode_uid(inode, sd_v1_uid(sd));
> +		btrfs_set_stack_inode_gid(inode, sd_v1_gid(sd));
> +		btrfs_set_stack_timespec_sec(&inode->atime, sd_v1_atime(sd));
> +		btrfs_set_stack_timespec_sec(&inode->ctime, sd_v1_ctime(sd));
> +		btrfs_set_stack_timespec_sec(&inode->mtime, sd_v1_mtime(sd));
> +
> +		if (!S_ISREG(mode) && !S_ISDIR(mode) && !S_ISLNK(mode))
> +			rdev =3D new_decode_dev(sd_v1_rdev(sd));
> +	} else {
> +		struct stat_data *sd =3D stat_data;
> +
> +		mode =3D sd_v2_mode(sd);
> +		btrfs_set_stack_inode_size(inode, sd_v2_size(sd));
> +		btrfs_set_stack_inode_nlink(inode, sd_v2_nlink(sd));
> +		btrfs_set_stack_inode_uid(inode, sd_v2_uid(sd));
> +		btrfs_set_stack_inode_gid(inode, sd_v2_gid(sd));
> +		btrfs_set_stack_timespec_sec(&inode->atime, sd_v2_atime(sd));
> +		btrfs_set_stack_timespec_sec(&inode->ctime, sd_v2_ctime(sd));
> +		btrfs_set_stack_timespec_sec(&inode->mtime, sd_v2_mtime(sd));
> +
> +		if (!S_ISREG(mode) && !S_ISDIR(mode) && !S_ISLNK(mode))
> +			rdev =3D new_decode_dev(sd_v2_rdev(sd));
> +
> +		if (copy_inode_flags)
> +			reiserfs_convert_inode_flags(inode, sd);
> +
> +	}
> +	if (S_ISDIR(mode)) {
> +		btrfs_set_stack_inode_size(inode, 0);
> +		btrfs_set_stack_inode_nlink(inode, 1);
> +	}
> +	btrfs_set_stack_inode_mode(inode, mode);
> +	btrfs_set_stack_inode_rdev(inode, rdev);
> +
> +}
> +
> +struct reiserfs_blk_iterate_data {
> +	struct blk_iterate_data blk_data;
> +	int indirect;
> +	char *inline_data;
> +	u64 inline_offset;
> +	u32 inline_length;
> +};
> +
> +static void init_reiserfs_blk_iterate_data(
> +				struct reiserfs_blk_iterate_data *data,
> +				struct btrfs_trans_handle *trans,
> +				struct btrfs_root *root,
> +				struct btrfs_inode_item *inode,
> +				u64 objectid, u32 convert_flags)
> +{
> +	init_blk_iterate_data(&data->blk_data, trans, root, inode, objectid,
> +			      convert_flags & CONVERT_FLAG_DATACSUM);
> +	data->indirect =3D 0;
> +	data->inline_data =3D NULL;
> +	data->inline_offset =3D (u64)-1;
> +	data->inline_length =3D 0;
> +}
> +
> +static int reiserfs_record_indirect_extent(reiserfs_filsys_t fs, u64 p=
osition,
> +					   u64 size, int num_ptrs,
> +					   u32 *ptrs, void *data)
> +{
> +	struct reiserfs_blk_iterate_data *bdata =3D data;
> +	u32 file_block =3D position / fs->fs_blocksize;
> +	int i;
> +	int ret =3D 0;
> +
> +	bdata->indirect =3D 1;
> +
> +	for (i =3D 0; i < num_ptrs; i++, file_block++) {
> +		u32 block =3D d32_get(ptrs, i);
> +
> +		if (!block)
> +			continue;
> +
> +		ret =3D block_iterate_proc(block, file_block, &bdata->blk_data);
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int reiserfs_record_direct_extent(reiserfs_filsys_t fs, __u64 p=
osition,
> +					 __u64 size, const char *body,
> +					 size_t len, void *data)
> +{
> +	struct reiserfs_blk_iterate_data *bdata =3D data;
> +	char *inline_data;
> +
> +	if (bdata->inline_offset =3D=3D (u64)-1)
> +		bdata->inline_offset =3D position;
> +
> +	inline_data =3D realloc(bdata->inline_data, bdata->inline_length + le=
n);
> +	if (!inline_data)
> +		return -ENOMEM;
> +	bdata->inline_data =3D inline_data;
> +
> +	memcpy(bdata->inline_data + bdata->inline_length, body, len);
> +	bdata->inline_length +=3D len;
> +
> +	return 0;
> +}
> +
> +static int convert_direct(struct btrfs_trans_handle *trans,
> +			  struct btrfs_root *root, u64 objectid,
> +			  struct btrfs_inode_item *inode, const char *body,
> +			  u32 length, u64 offset, u32 convert_flags)
> +{
> +	struct btrfs_key key;
> +	u32 sectorsize =3D root->sectorsize;
> +	int ret;
> +	struct extent_buffer *eb;
> +
> +	BUG_ON(length > sectorsize);
> +	ret =3D btrfs_reserve_extent(trans, root, sectorsize,
> +				   0, 0, -1ULL, &key, 1);
> +	if (ret)
> +		return ret;
> +
> +	eb =3D alloc_extent_buffer(&root->fs_info->extent_cache, key.objectid=
,
> +				 sectorsize);
> +
> +	if (!eb)
> +		return -ENOMEM;
> +
> +	write_extent_buffer(eb, body, 0, length);
> +	ret =3D write_and_map_eb(root, eb);
> +	free_extent_buffer(eb);
> +	if (ret)
> +		return ret;
> +
> +	return btrfs_record_file_extent(trans, root, objectid, inode, offset,=

> +					key.objectid, sectorsize);
> +}
> +
> +static int reiserfs_record_file_extents(reiserfs_filsys_t fs,
> +					struct btrfs_trans_handle *trans,
> +					struct btrfs_root *root,
> +					u64 objectid,
> +					struct btrfs_inode_item *inode,
> +					struct reiserfs_key *sd_key,
> +					u32 convert_flags)
> +
> +{
> +	int ret;
> +	u32 last_block;
> +	u32 sectorsize =3D root->sectorsize;
> +        u64 inode_size =3D btrfs_stack_inode_size(inode);
> +	struct reiserfs_blk_iterate_data data;
> +
> +	init_reiserfs_blk_iterate_data(&data, trans, root, inode,
> +				       objectid, convert_flags);
> +
> +	ret =3D reiserfs_iterate_file_data(fs, sd_key,
> +					 reiserfs_record_indirect_extent,
> +					 reiserfs_record_direct_extent, &data);
> +	if (ret)
> +		return ret;
> +
> +	if (data.indirect && data.blk_data.num_blocks) {
> +		ret =3D record_file_blocks(&data.blk_data,
> +					 data.blk_data.first_block,
> +					 data.blk_data.disk_block,
> +					 data.blk_data.num_blocks);
> +		if (ret)
> +			goto fail;
> +	}
> +
> +	data.blk_data.first_block +=3D data.blk_data.num_blocks;
> +	last_block =3D (inode_size + sectorsize - 1) / sectorsize;
> +	if (last_block > data.blk_data.first_block) {
> +		ret =3D record_file_blocks(&data.blk_data,
> +					 data.blk_data.first_block, 0,
> +					 last_block - data.blk_data.first_block);
> +		if (ret)
> +			goto fail;
> +	}
> +
> +	if (data.inline_length) {
> +		if (data.inline_length < BTRFS_MAX_INLINE_DATA_SIZE(root)) {
> +			int isize;
> +			ret =3D btrfs_insert_inline_extent(trans, root,
> +							 objectid,
> +							 data.inline_offset,
> +							 data.inline_data,
> +							 data.inline_length);
> +			if (ret)
> +				goto fail;
> +
> +			isize =3D btrfs_stack_inode_nbytes(inode);
> +			btrfs_set_stack_inode_nbytes(inode,
> +					     isize + data.inline_length);
> +		} else {
> +			ret =3D convert_direct(trans, root, objectid, inode,
> +					     data.inline_data,
> +					     data.inline_length,
> +					     data.inline_offset, convert_flags);
> +			if (ret)
> +				goto fail;
> +		}
> +	}
> +
> +	ret =3D 0;
> +fail:
> +	return ret;
> +}
> +
> +#define OID_OFFSET (BTRFS_FIRST_FREE_OBJECTID - REISERFS_ROOT_OBJECTID=
)
> +static int reiserfs_copy_meta(reiserfs_filsys_t fs, struct btrfs_root =
*root,
> +			      u32 convert_flags, u32 deh_dirid,
> +			      u32 deh_objectid, u8 *type);
> +
> +struct reiserfs_dirent_data {
> +	u64 index;
> +	u32 convert_flags;
> +	struct btrfs_inode_item *inode;
> +	struct btrfs_root *root;
> +};
> +
> +static int reiserfs_copy_dirent(reiserfs_filsys_t fs,
> +				const struct reiserfs_key *dir_short_key,
> +				const char *name, size_t len,
> +				__u32 deh_dirid, __u32 deh_objectid,
> +				void *cb_data)
> +{
> +	int ret;
> +	u8 type;
> +	struct btrfs_trans_handle *trans;
> +	u64 objectid =3D deh_objectid + OID_OFFSET;
> +	struct reiserfs_convert_info *info =3D fs->fs_vp;
> +	struct reiserfs_dirent_data *dirent_data =3D cb_data;
> +	struct btrfs_root *root =3D dirent_data->root;
> +	__u32 dir_objectid =3D get_key_objectid(dir_short_key) + OID_OFFSET;
> +
> +	/*
> +	 * These are the extended attributes and shouldn't appear as files
> +	 * in the converted file systems.
> +	 */
> +	if (deh_objectid =3D=3D get_key_objectid(&info->privroot_key))
> +		return 0;
> +
> +	ret =3D reiserfs_copy_meta(fs, root, dirent_data->convert_flags,
> +				 deh_dirid, deh_objectid, &type);
> +	if (ret)
> +		return ret;
> +	trans =3D btrfs_start_transaction(root, 1);
> +	if (!trans)
> +		return -ENOMEM;
> +
> +	ret =3D convert_insert_dirent(trans, root, name, len, dir_objectid,
> +				    objectid, type, dirent_data->index++,
> +				    dirent_data->inode);
> +	return btrfs_commit_transaction(trans, root);
> +}
> +
> +static int reiserfs_copy_symlink(struct btrfs_trans_handle *trans,
> +				 struct btrfs_root *root, u64 objectid,
> +				 struct btrfs_inode_item *btrfs_inode,
> +				 reiserfs_filsys_t fs,
> +				 struct reiserfs_path *sd_path)
> +{
> +	INITIALIZE_REISERFS_PATH(path);
> +	struct item_head *ih =3D tp_item_head(sd_path);
> +	struct reiserfs_key key =3D ih->ih_key;
> +	int ret;
> +	char *symlink;
> +	int len;
> +
> +	set_key_uniqueness(&key, type2uniqueness(TYPE_DIRECT));
> +	set_key_offset_v1(&key, 1);
> +
> +	ret =3D reiserfs_search_by_key_3(fs, &key, &path);
> +	if (ret !=3D ITEM_FOUND) {
> +		ret =3D -ENOENT;
> +		goto fail;
> +	}
> +
> +	symlink =3D tp_item_body(&path);
> +	len =3D get_ih_item_len(tp_item_head(&path));
> +
> +	ret =3D btrfs_insert_inline_extent(trans, root, objectid, 0,
> +					 symlink, len + 1);
> +	btrfs_set_stack_inode_nbytes(btrfs_inode, len + 1);
> +fail:
> +	pathrelse(&path);
> +	return ret;
> +}
> +
> +static int reiserfs_copy_meta(reiserfs_filsys_t fs, struct btrfs_root =
*root,
> +			      u32 convert_flags, u32 deh_dirid,
> +			      u32 deh_objectid, u8 *type)
> +{
> +	INITIALIZE_REISERFS_PATH(path);
> +	int ret =3D 0;
> +	struct item_head *ih;
> +	struct reiserfs_key key;
> +	struct btrfs_inode_item btrfs_inode;
> +	struct btrfs_trans_handle *trans =3D NULL;
> +	struct reiserfs_convert_info *info =3D fs->fs_vp;
> +	u32 mode;
> +	u64 objectid =3D deh_objectid + OID_OFFSET;
> +	u64 parent =3D deh_dirid + OID_OFFSET;
> +	struct reiserfs_dirent_data dirent_data =3D {
> +		.index =3D 2,
> +		.convert_flags =3D convert_flags,
> +		.inode =3D &btrfs_inode,
> +		.root =3D root,
> +	};
> +
> +	/* The root directory's dirid in reiserfs points to an object
> +	 * that does't exist.  In btrfs it's self-referential.
> +	 */
> +	if (deh_dirid =3D=3D REISERFS_ROOT_PARENT_OBJECTID)
> +		parent =3D objectid;
> +
> +	set_key_dirid(&key, deh_dirid);
> +	set_key_objectid(&key, deh_objectid);
> +	set_key_offset_v2(&key, 0);
> +	set_key_type_v2(&key, TYPE_STAT_DATA);
> +
> +	ret =3D reiserfs_search_by_key_3(fs, &key, &path);
> +	if (ret !=3D ITEM_FOUND) {
> +		ret =3D -ENOENT;
> +		goto fail;
> +	}
> +
> +	ih =3D tp_item_head(&path);
> +	if (!is_stat_data_ih(ih)) {
> +		ret =3D -EINVAL;
> +		goto fail;
> +	}
> +
> +	reiserfs_copy_inode_item(&btrfs_inode, ih, tp_item_body(&path),
> +				 info->copy_attrs);
> +	mode =3D btrfs_stack_inode_mode(&btrfs_inode);
> +	*type =3D mode_to_file_type(mode);
> +
> +	if (S_ISREG(mode)) {
> +		/* Inodes with hardlinks should only be inserted once */
> +		if (btrfs_stack_inode_nlink(&btrfs_inode) > 1) {
> +			if (lookup_cached_objectid(fs, deh_objectid)) {
> +				ret =3D 0;
> +				goto fail; /* Not a failure */
> +			}
> +			ret =3D insert_cached_objectid(fs, deh_objectid);
> +			if (ret)
> +				goto fail;
> +		}
> +
> +	}
> +
> +	if (!(convert_flags & CONVERT_FLAG_DATACSUM)) {
> +		u32 flags =3D btrfs_stack_inode_flags(&btrfs_inode) |
> +			    BTRFS_INODE_NODATASUM;
> +		btrfs_set_stack_inode_flags(&btrfs_inode, flags);
> +	}
> +
> +	switch (mode & S_IFMT) {
> +	case S_IFREG:
> +		trans =3D btrfs_start_transaction(root, 1);
> +		if (!trans) {
> +			ret =3D -ENOMEM;
> +			goto fail;
> +		}
> +		ret =3D reiserfs_record_file_extents(fs, trans, root, objectid,
> +						   &btrfs_inode, &ih->ih_key,
> +						   convert_flags);
> +		if (ret)
> +			goto fail;
> +		break;
> +	case S_IFDIR:
> +		ret =3D reiserfs_iterate_dir(fs, &ih->ih_key,
> +					   reiserfs_copy_dirent, &dirent_data);
> +		if (ret)
> +			goto fail;
> +		trans =3D btrfs_start_transaction(root, 1);
> +		if (!trans) {
> +			ret =3D -ENOMEM;
> +			goto fail;
> +		}
> +
> +		ret =3D btrfs_insert_inode_ref(trans, root, "..", 2, parent,
> +					     objectid, 0);
> +		break;
> +	case S_IFLNK:
> +		trans =3D btrfs_start_transaction(root, 1);
> +		if (!trans) {
> +			ret =3D -ENOMEM;
> +			goto fail;
> +		}
> +		ret =3D reiserfs_copy_symlink(trans, root, objectid,
> +					    &btrfs_inode, fs, &path);
> +		if (ret)
> +			goto fail;
> +		break;
> +	default:
> +		trans =3D btrfs_start_transaction(root, 1);
> +		if (!trans) {
> +			ret =3D -ENOMEM;
> +			goto fail;
> +		}
> +	}
> +
> +	ret =3D btrfs_insert_inode(trans, root, objectid, &btrfs_inode);
> +	if (ret)
> +		goto fail;
> +	ret =3D btrfs_commit_transaction(trans, root);
> +	info->progress->cur_copy_inodes++;
> +
> +fail:
> +	pathrelse(&path);
> +	return ret;
> +}
> +
> +struct reiserfs_xattr_data {
> +	struct btrfs_root *root;
> +	struct btrfs_trans_handle *trans;
> +	u64 target_oid;
> +	const char *name;
> +	size_t namelen;
> +	void *body;
> +	size_t len;
> +};
> +
> +static int reiserfs_xattr_indirect_fn(reiserfs_filsys_t fs, u64 positi=
on,
> +				      u64 size, int num_blocks,
> +				      u32 *blocks, void *data)
> +{
> +	int i;
> +	struct reiserfs_xattr_data *xa_data =3D data;
> +	size_t alloc =3D min(position + num_blocks * fs->fs_blocksize, size);=

> +	char *body;
> +
> +	if (size > BTRFS_LEAF_DATA_SIZE(xa_data->root) -
> +	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
> +		fprintf(stderr, "skip large xattr on objectid %llu name %.*s\n",
> +			xa_data->target_oid, (int)xa_data->namelen,
> +			xa_data->name);
> +		return -E2BIG;
> +	}
> +
> +	body =3D realloc(xa_data->body, alloc);
> +	if (!body)
> +		return -ENOMEM;
> +
> +	xa_data->body =3D body;
> +	xa_data->len =3D alloc;
> +
> +	for (i =3D 0; i < num_blocks; i++) {
> +		int ret;
> +		u32 block =3D d32_get(blocks, i);
> +		u64 offset =3D (u64)block * fs->fs_blocksize;
> +		size_t chunk =3D min_t(u64, size - position, fs->fs_blocksize);
> +		char *buffer =3D xa_data->body + position;
> +		ret =3D read_disk_extent(xa_data->root, offset, chunk, buffer);
> +		if (ret)
> +			return ret;
> +		position +=3D chunk;
> +	}
> +
> +	return 0;
> +}
> +
> +static int reiserfs_xattr_direct_fn(reiserfs_filsys_t fs, __u64 positi=
on,
> +				    __u64 size, const char *body, size_t len,
> +				    void *data)
> +{
> +	struct reiserfs_xattr_data *xa_data =3D data;
> +	char *newbody;
> +
> +	if (size > BTRFS_LEAF_DATA_SIZE(xa_data->root) -
> +	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
> +		fprintf(stderr, "skip large xattr on objectid %llu name %.*s\n",
> +			xa_data->target_oid, (int)xa_data->namelen,
> +			xa_data->name);
> +		return -E2BIG;
> +	}
> +
> +	newbody =3D realloc(xa_data->body, position + len);
> +	if (!newbody)
> +		return -ENOMEM;
> +	xa_data->body =3D newbody;
> +	xa_data->len =3D position + len;
> +	memcpy(xa_data->body + position, body, len);
> +	return 0;
> +}
> +
> +static int reiserfs_acl_to_xattr(void *dst, const void *src,
> +				 size_t dst_size, size_t src_size)
> +{
> +	int i, count;
> +	const void *end =3D src + src_size;
> +	acl_ea_header *ext_acl =3D (acl_ea_header *)dst;
> +	acl_ea_entry *dst_entry =3D ext_acl->a_entries;
> +	struct reiserfs_acl_entry *src_entry;
> +
> +	if (src_size < sizeof(struct reiserfs_acl_header))
> +		goto fail;
> +	if (((struct reiserfs_acl_header *)src)->a_version !=3D
> +	    cpu_to_le32(REISERFS_ACL_VERSION))
> +		goto fail;
> +	src +=3D sizeof(struct reiserfs_acl_header);
> +	count =3D reiserfs_acl_count(src_size);
> +	if (count <=3D 0)
> +		goto fail;
> +
> +	BUG_ON(dst_size < acl_ea_size(count));
> +	ext_acl->a_version =3D cpu_to_le32(ACL_EA_VERSION);
> +	for (i =3D 0; i < count; i++, dst_entry++) {
> +		src_entry =3D (struct reiserfs_acl_entry *)src;
> +		if (src + sizeof(struct reiserfs_acl_entry_short) > end)
> +			goto fail;
> +		dst_entry->e_tag =3D src_entry->e_tag;
> +		dst_entry->e_perm =3D src_entry->e_perm;
> +		switch (le16_to_cpu(src_entry->e_tag)) {
> +		case ACL_USER_OBJ:
> +		case ACL_GROUP_OBJ:
> +		case ACL_MASK:
> +		case ACL_OTHER:
> +			src +=3D sizeof(struct reiserfs_acl_entry_short);
> +			dst_entry->e_id =3D cpu_to_le32(ACL_UNDEFINED_ID);
> +			break;
> +		case ACL_USER:
> +		case ACL_GROUP:
> +			src +=3D sizeof(struct reiserfs_acl_entry);
> +			if (src > end)
> +				goto fail;
> +			dst_entry->e_id =3D src_entry->e_id;
> +			break;
> +		default:
> +			goto fail;
> +		}
> +	}
> +	if (src !=3D end)
> +		goto fail;
> +	return 0;
> +fail:
> +	return -EINVAL;
> +}
> +
> +static int reiserfs_copy_one_xattr(reiserfs_filsys_t fs,
> +				   const struct reiserfs_key *dir_short_key,
> +				   const char *name, size_t namelen,
> +				   __u32 deh_dirid,
> +				   __u32 deh_objectid, void *cb_data)
> +{
> +	struct reiserfs_convert_info *info =3D fs->fs_vp;
> +	struct reiserfs_xattr_data *xa_data =3D cb_data;
> +	struct reiserfs_key key =3D {
> +		.k2_dir_id =3D deh_dirid,
> +		.k2_objectid =3D deh_objectid,
> +	};
> +	void *body =3D NULL;
> +	int len;
> +	int ret;
> +
> +	xa_data->name =3D name;
> +	xa_data->namelen =3D namelen;
> +
> +	ret =3D reiserfs_iterate_file_data(fs, &key, reiserfs_xattr_indirect_=
fn,
> +					 reiserfs_xattr_direct_fn, cb_data);
> +	if (ret)
> +		goto out;
> +
> +	if (!reiserfs_check_xattr(xa_data->body, xa_data->len)) {
> +		fprintf(stderr,
> +			"skip corrupted xattr on objectid %u name %.*s\n",
> +			deh_objectid, (int)xa_data->namelen,
> +			xa_data->name);
> +		goto out;
> +	}
> +
> +	body =3D xa_data->body + sizeof(struct reiserfs_xattr_header);
> +	len =3D xa_data->len - sizeof(struct reiserfs_xattr_header);
> +
> +	if (!strncmp("system.posix_acl_default", name, namelen) ||
> +	    !strncmp("system.posix_acl_access", name, namelen)) {
> +		size_t bufsize =3D acl_ea_size(ext2_acl_count(len));
> +		char *databuf =3D malloc(bufsize);
> +		if (!databuf)
> +			goto out;
> +		ret =3D reiserfs_acl_to_xattr(databuf, body, bufsize, len);
> +		if (ret)
> +			goto out;
> +		body =3D databuf;
> +		len =3D bufsize;
> +	}
> +
> +	ret =3D btrfs_insert_xattr_item(xa_data->trans, xa_data->root,
> +				      name, namelen, body, len,
> +				      xa_data->target_oid);
> +
> +	info->progress->cur_copy_inodes++;
> +out:
> +	if (body &&
> +	    body !=3D xa_data->body + sizeof(struct reiserfs_xattr_header))
> +		free(body);
> +	if (xa_data->body)
> +		free(xa_data->body);
> +	xa_data->body =3D NULL;
> +	xa_data->len =3D 0;
> +
> +	return ret;
> +}
> +
> +static int reiserfs_copy_xattr_dir(reiserfs_filsys_t fs,
> +				   const struct reiserfs_key *dir_short_key,
> +				   const char *name, size_t len,
> +				   __u32 deh_dirid, __u32 deh_objectid,
> +				   void *cb_data)
> +{
> +	struct reiserfs_convert_info *info =3D fs->fs_vp;
> +	struct reiserfs_xattr_data *xa_data =3D cb_data;
> +	struct reiserfs_key dir_key =3D {
> +		.k2_dir_id =3D deh_dirid,
> +		.k2_objectid =3D deh_objectid,
> +	};
> +	int ret, err;
> +
> +	errno =3D 0;
> +	xa_data->target_oid =3D strtoull(name, NULL, 16);
> +	if (xa_data->target_oid =3D=3D ULLONG_MAX && errno)
> +		return -errno;
> +
> +	xa_data->target_oid +=3D OID_OFFSET;
> +
> +	xa_data->trans =3D btrfs_start_transaction(xa_data->root, 1);
> +	if (!xa_data->trans)
> +		return -ENOMEM;
> +
> +	ret =3D reiserfs_iterate_dir(fs, &dir_key,
> +				    reiserfs_copy_one_xattr, xa_data);
> +
> +	err =3D btrfs_commit_transaction(xa_data->trans, xa_data->root);
> +	info->progress->cur_copy_inodes++;
> +	xa_data->trans =3D NULL;
> +	return ret ?: err;
> +}
> +
> +static int reiserfs_copy_xattrs(reiserfs_filsys_t fs, struct btrfs_roo=
t *root)
> +{
> +	struct reiserfs_convert_info *info =3D fs->fs_vp;
> +	struct reiserfs_xattr_data data =3D {
> +		.root =3D root,
> +	};
> +
> +	if (info->xattr_key.k2_objectid =3D=3D 0)
> +		return 0;
> +
> +	return reiserfs_iterate_dir(fs, &info->xattr_key,
> +				    reiserfs_copy_xattr_dir, &data);
> +}
> +
> +static int reiserfs_copy_inodes(struct btrfs_convert_context *cxt,
> +				struct btrfs_root *root,
> +				u32 convert_flags,
> +				struct task_ctx *p)
> +{
> +	reiserfs_filsys_t fs =3D cxt->fs_data;
> +	struct reiserfs_convert_info *info =3D fs->fs_vp;
> +	int ret;
> +	u8 type;
> +
> +	info->progress =3D p;
> +
> +	ret =3D reiserfs_locate_privroot(fs);
> +	if (ret)
> +		goto out;
> +
> +	ret =3D reiserfs_copy_meta(fs, root, convert_flags,
> +				 REISERFS_ROOT_PARENT_OBJECTID,
> +				 REISERFS_ROOT_OBJECTID, &type);
> +	if (ret)
> +		goto out;
> +
> +	if (convert_flags & CONVERT_FLAG_XATTR)
> +		ret =3D reiserfs_copy_xattrs(fs, root);
> +
> +out:
> +	info->progress =3D NULL;
> +	return ret;
> +}
> +
> +static int read_used_space(struct btrfs_convert_context *cxt)
> +{
> +	reiserfs_filsys_t fs =3D cxt->fs_data;
> +	u64 start, end =3D 0;
> +	unsigned int size =3D get_sb_block_count(fs->fs_ondisk_sb);
> +	unsigned long *bitmap =3D (unsigned long *)fs->fs_bitmap2->bm_map;
> +	int ret =3D 0;
> +
> +	/* We have the entire bitmap loaded so we can just ping pong with
> +	 * ffz and ffs
> +	 */
> +
> +	while (end < size) {
> +		u64 offset, length;
> +		start =3D find_next_bit(bitmap, size, end);
> +		if (start >=3D size)
> +			break;
> +		end =3D find_next_zero_bit(bitmap, size, start);
> +		if (end > size)
> +			end =3D size;
> +		offset =3D start * fs->fs_blocksize;
> +		length =3D (end - start) * fs->fs_blocksize;
> +		ret =3D add_merge_cache_extent(&cxt->used_space, offset, length);
> +		if (ret < 0)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int reiserfs_check_state(struct btrfs_convert_context *cxt)
> +{
> +	return 0;
> +}
> +
> +const struct btrfs_convert_operations reiserfs_convert_ops =3D {
> +	.name		=3D "reiserfs",
> +	.open_fs	=3D reiserfs_open_fs,
> +	.read_used_space	=3D read_used_space,
> +	.copy_inodes	=3D reiserfs_copy_inodes,
> +	.close_fs	=3D reiserfs_close_fs,
> +	.check_state	=3D reiserfs_check_state,
> +};
> +
> +#endif /* BTRFSCONVERT_REISERFS */
> diff --git a/convert/source-reiserfs.h b/convert/source-reiserfs.h
> new file mode 100644
> index 0000000..f6cdf78
> --- /dev/null
> +++ b/convert/source-reiserfs.h
> @@ -0,0 +1,105 @@
> +/*
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#ifndef __BTRFS_CONVERT_SOURCE_REISERFS_H__
> +#define __BTRFS_CONVERT_SOURCE_REISERFS_H__
> +
> +#if BTRFSCONVERT_REISERFS
> +
> +#include "kerncompat.h"
> +#include <reiserfs/misc.h>
> +#include <reiserfs/io.h>
> +#include <reiserfs/reiserfs_lib.h>
> +#include <reiserfs/reiserfs_fs.h>
> +#include <linux/kdev_t.h>
> +#include "convert/source-fs.h"
> +
> +#define REISERFS_ACL_VERSION	0x0001
> +
> +/* 23.2.5 acl_tag_t values */
> +
> +#define ACL_UNDEFINED_TAG       (0x00)
> +#define ACL_USER_OBJ            (0x01)
> +#define ACL_USER                (0x02)
> +#define ACL_GROUP_OBJ           (0x04)
> +#define ACL_GROUP               (0x08)
> +#define ACL_MASK                (0x10)
> +#define ACL_OTHER               (0x20)
> +
> +/* 23.2.7 ACL qualifier constants */
> +
> +#define ACL_UNDEFINED_ID        ((id_t)-1)
> +
> +typedef struct {
> +	__le16		e_tag;
> +	__le16		e_perm;
> +	__le32		e_id;
> +} ext2_acl_entry;
> +
> +typedef struct {
> +	__le16		e_tag;
> +	__le16		e_perm;
> +} ext2_acl_entry_short;
> +
> +typedef struct {
> +	__le32		a_version;
> +} ext2_acl_header;
> +
> +#define ACL_EA_VERSION		0x0002
> +
> +typedef struct {
> +	__le16		e_tag;
> +	__le16		e_perm;
> +	__le32		e_id;
> +} acl_ea_entry;
> +
> +typedef struct {
> +	__le32		a_version;
> +	acl_ea_entry	a_entries[0];
> +} acl_ea_header;
> +
> +static inline int ext2_acl_count(size_t size)
> +{
> +	ssize_t s;
> +	size -=3D sizeof(ext2_acl_header);
> +	s =3D size - 4 * sizeof(ext2_acl_entry_short);
> +	if (s < 0) {
> +		if (size % sizeof(ext2_acl_entry_short))
> +			return -1;
> +		return size / sizeof(ext2_acl_entry_short);
> +	} else {
> +		if (s % sizeof(ext2_acl_entry))
> +			return -1;
> +		return s / sizeof(ext2_acl_entry) + 4;
> +	}
> +}
> +
> +
> +static inline size_t acl_ea_size(int count)
> +{
> +	return sizeof(acl_ea_header) + count * sizeof(acl_ea_entry);
> +}
> +
> +static inline dev_t new_decode_dev(u32 dev)
> +{
> +	unsigned major =3D (dev & 0xfff00) >> 8;
> +	unsigned minor =3D (dev & 0xff) | ((dev >> 12) & 0xfff00);
> +
> +	return MKDEV(major, minor);
> +}
> +
> +#endif	/* BTRFSCONVERT_REISERFS */
> +#endif
> diff --git a/tests/common.convert b/tests/common.convert
> index 8c9242e..6c525d1 100644
> --- a/tests/common.convert
> +++ b/tests/common.convert
> @@ -17,7 +17,7 @@ convert_test_preamble() {
>  	msg=3D"$2"
>  	shift 3
>  	echo "    [TEST/conv]     $msg, btrfs" "${features:-defaults}"
> -	echo "creating ext image with: $@" >> "$RESULTS"
> +	echo "creating test image with: $@" >> "$RESULTS"
>  }
> =20
>  #  prepare TEST_DEV before conversion, create filesystem and mount it,=
 image
> @@ -29,10 +29,18 @@ convert_test_prep_fs() {
>  	run_check truncate -s 0 "$TEST_DEV"
>  	# 256MB is the smallest acceptable btrfs image.
>  	run_check truncate -s 512M "$TEST_DEV"
> -	run_check "$@" -F "$TEST_DEV"
> +	force=3D
> +	mountopts=3D
> +	case "$@" in
> +	*mke2fs*)
> +		force=3D-F ;;
> +	*mkreiserfs*)
> +		force=3D-ff; mountopts=3D"-o acl,user_xattr,attrs" ;;
> +	esac
> +	run_check "$@" $force "$TEST_DEV"
> =20
>  	# create a file to check btrfs-convert can convert regular file corre=
ct
> -	run_check_mount_test_dev
> +	run_check_mount_test_dev $mountopts
> =20
>  	# create a file inside the fs before convert, to make sure there is
>  	# data covering btrfs backup superblock range (64M)
> diff --git a/tests/convert-tests/010-reiserfs-basic/test.sh b/tests/con=
vert-tests/010-reiserfs-basic/test.sh
> new file mode 100755
> index 0000000..8f80965
> --- /dev/null
> +++ b/tests/convert-tests/010-reiserfs-basic/test.sh
> @@ -0,0 +1,16 @@
> +#!/bin/bash
> +
> +source "$TOP/tests/common"
> +source "$TOP/tests/common.convert"
> +
> +setup_root_helper
> +prepare_test_dev 512M
> +check_prereq btrfs-convert
> +
> +for feature in '' 'extref' 'skinny-metadata' 'no-holes'; do
> +	convert_test "$feature" "reiserfs 4k nodesize" 4096 mkreiserfs -b 409=
6
> +	convert_test "$feature" "reiserfs 8k nodesize" 8192 mkreiserfs -b 409=
6
> +	convert_test "$feature" "reiserfs 16k nodesize" 16384 mkreiserfs -b 4=
096
> +	convert_test "$feature" "reiserfs 32k nodesize" 32768 mkreiserfs -b 4=
096
> +	convert_test "$feature" "reiserfs 64k nodesize" 65536 mkreiserfs -b 4=
096
> +done
> diff --git a/tests/convert-tests/011-reiserfs-delete-all-rollback/test.=
sh b/tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh
> new file mode 100755
> index 0000000..d7e7ed6
> --- /dev/null
> +++ b/tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh
> @@ -0,0 +1,67 @@
> +#!/bin/bash
> +# create a base image, convert to btrfs, remove all files, rollback th=
e reiserfs image
> +
> +source "$TOP/tests/common"
> +source "$TOP/tests/common.convert"
> +
> +setup_root_helper
> +prepare_test_dev 512M
> +check_prereq btrfs-convert
> +
> +# simple wrapper for a convert test
> +# $1: btrfs features, argument to -O
> +# $2: message
> +# $3: nodesize value
> +# $4 + rest: command to create the reiserfs image
> +do_test() {
> +	local features
> +	local msg
> +	local nodesize
> +	local CHECKSUMTMP
> +	local here
> +
> +	features=3D"$1"
> +	msg=3D"$2"
> +	nodesize=3D"$3"
> +	shift 3
> +	convert_test_preamble "$features" "$msg" "$nodesize" "$@"
> +	convert_test_prep_fs "$@"
> +	populate_fs
> +	CHECKSUMTMP=3D$(mktemp --tmpdir btrfs-progs-convert.XXXXXXXXXX)
> +	convert_test_gen_checksums "$CHECKSUMTMP"
> +
> +	run_check_umount_test_dev
> +
> +	convert_test_do_convert "$features" "$nodesize"
> +
> +	run_check_mount_test_dev
> +	convert_test_post_check_checksums "$CHECKSUMTMP"
> +
> +	here=3D$(pwd)
> +	cd "$TEST_MNT" || _fail "cannot cd to TEST_MNT"
> +	# reiserfs_saved/image must not be deleted
> +	run_mayfail $SUDO_HELPER find "$TEST_MNT"/ -mindepth 1 -path '*reiser=
fs_saved' -prune -o -exec rm -vrf "{}" \;
> +	cd "$here"
> +	run_check "$TOP/btrfs" filesystem sync "$TEST_MNT"
> +	run_check_umount_test_dev
> +	convert_test_post_rollback
> +
> +	run_check_mount_test_dev
> +	convert_test_post_check_checksums "$CHECKSUMTMP"
> +	run_check_umount_test_dev
> +
> +	# mount again and verify checksums
> +	run_check_mount_test_dev
> +	convert_test_post_check_checksums "$CHECKSUMTMP"
> +	run_check_umount_test_dev
> +
> +	rm "$CHECKSUMTMP"
> +}
> +
> +for feature in '' 'extref' 'skinny-metadata' 'no-holes'; do
> +	do_test "$feature" "reiserfs 4k nodesize" 4096 mkreiserfs -b 4096
> +	do_test "$feature" "reiserfs 8k nodesize" 8192 mkreiserfs -b 4096
> +	do_test "$feature" "reiserfs 16k nodesize" 16384 mkreiserfs -b 4096
> +	do_test "$feature" "reiserfs 32k nodesize" 32768 mkreiserfs -b 4096
> +	do_test "$feature" "reiserfs 64k nodesize" 65536 mkreiserfs -b 4096
> +done
> diff --git a/tests/convert-tests/012-reiserfs-large-hole-extent/test.sh=
 b/tests/convert-tests/012-reiserfs-large-hole-extent/test.sh
> new file mode 100755
> index 0000000..90cd514
> --- /dev/null
> +++ b/tests/convert-tests/012-reiserfs-large-hole-extent/test.sh
> @@ -0,0 +1,23 @@
> +#!/bin/bash
> +# Create a base image with large hole extent, then convert to btrfs,
> +# check the converted image.
> +# Check if btrfs-convert can handle such large hole.
> +# Fast pinpoint regression test. No options combination nor checksum
> +# verification
> +
> +source "$TOP/tests/common"
> +source "$TOP/tests/common.convert"
> +
> +setup_root_helper
> +prepare_test_dev 512M
> +check_prereq btrfs-convert
> +
> +default_mkfs=3D"mkreiserfs -b 4096"
> +convert_test_preamble '' 'large hole extent test' 16k "$default_mkfs"
> +convert_test_prep_fs $default_mkfs
> +
> +run_check $SUDO_HELPER dd if=3D/dev/zero of=3D"$TEST_MNT/file" bs=3D1M=
 \
> +	count=3D1 seek=3D1024 > /dev/null 2>&1
> +
> +run_check_umount_test_dev
> +convert_test_do_convert=20
> diff --git a/tests/convert-tests/013-reiserfs-common-inode-flags/test.s=
h b/tests/convert-tests/013-reiserfs-common-inode-flags/test.sh
> new file mode 100755
> index 0000000..b3948b3
> --- /dev/null
> +++ b/tests/convert-tests/013-reiserfs-common-inode-flags/test.sh
> @@ -0,0 +1,35 @@
> +#!/bin/bash
> +# Check if btrfs-convert can copy common inode flags like SYNC/IMMUTAB=
LE
> +
> +source "$TOP/tests/common"
> +source "$TOP/tests/common.convert"
> +
> +setup_root_helper
> +prepare_test_dev 512M
> +check_prereq btrfs-convert
> +
> +fail=3D0
> +default_mkfs=3D"mkreiserfs -b 4096"
> +convert_test_preamble '' 'common inode flags test' 16k "$default_mkfs"=

> +convert_test_prep_fs $default_mkfs
> +
> +# create file with specific flags
> +run_check $SUDO_HELPER touch "$TEST_MNT/flag_test"
> +run_check $SUDO_HELPER chattr +aAdSi "$TEST_MNT/flag_test"
> +run_check lsattr "$TEST_MNT/flag_test"
> +
> +run_check_umount_test_dev
> +convert_test_do_convert
> +run_check_mount_test_dev
> +
> +# Log the status
> +run_check lsattr "$TEST_MNT/flag_test"
> +# Above flags should be copied to btrfs flags, and lsattr should get t=
hem
> +run_check_stdout lsattr "$TEST_MNT/flag_test" | cut -f1 -d\ | grep "[a=
AdiS]" -q
> +if [ $? -ne 0 ]; then
> +	rm tmp_output
> +	_fail "no common inode flags are copied after convert"
> +fi
> +
> +run_check_umount_test_dev
> +convert_test_post_rollback
>=20


--=20
Jeff Mahoney
SUSE Labs


--iKPFfa0M2WnSw3Jr0PvxPF74kXwoDC0N4--

--G1CLran2P1RLJFwcLIOHndcfjFP57cvOj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWXewvx57S2MheeWyAQjTFRAAp+RTc2cT/b1UVFo0Ng3/1u67jYKCku4h
U1N2j7F+ekOiffx5+6q+PItfMHWlDNhXpZm64Bhh/a8EKangjAUwRvQ3FzJ8TR31
fg3abMNCfXt6BjwU2UwxEnCGbUchM+rasZTUHm1WzqBTB86PR9gkgsJ3Y8is3D/D
841k5H507VIv+04QPvOHI8M8b0NH1IxatN0Y6Z488/ST7+Ez/YQ9WQj53/8A7Jya
tsSv4tIkiNRMXndazH7KnfC3Z5QE0HESnVPSZHVtKy4sRWKa+I+GeBbfyaMYHht4
Y1/eXQczq80/zoOY31PdZ2mpPNRizf+FXUceiZqJL6cDhfpMNnMSM7OkqutQiIJz
LE6RI3F9rQl+mPpBBhaHZLcKa+Z1Z2Gvn4m8r9RzPAO+VN6BXyMvMAVDOaaYV5Vx
yBRv5z97DzIw7Ltu3t865THeFeprQ4Zyc9Y8V4RaAq+DSHrb2oQt+iVK4xJzI7wl
Trt/4kAFzS+ErfUn2Hcnf3ks5ZhXIqB+vXYY6KfSPfykJyje9sctgHH1FIVF6YOu
uzZe6nINzujdu0s+CZAU8jlBkXmEHRJrh112M9QUb5DckvMYYLgf+c0Fd28vgffx
N+BpJ+jqUtnBdMAYmXGu6YQmsHZH3WR00zr3gnlrKncckzAe2QVyBAs3mVByjQxY
NnXBh1HzaG8=
=hglt
-----END PGP SIGNATURE-----

--G1CLran2P1RLJFwcLIOHndcfjFP57cvOj--
