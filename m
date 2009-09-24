From: Edward Shishkin <edward@redhat.com>
Subject: [patch 1/2] grub-0.97: btrfs support for a singe device configuration
Date: Fri, 25 Sep 2009 00:06:32 +0200
Message-ID: <4ABBED68.6090801@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060604030607000902070801"
To: The development of BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060604030607000902070801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------060604030607000902070801
Content-Type: text/plain;
 name="grub-btrfs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="grub-btrfs.patch"

Signed-off-by: Edward Shishkin <edward@redhat.com>

---
 AUTHORS             |    2 
 INSTALL             |    3 
 configure.in        |    7 
 docs/grub.texi      |    3 
 stage2/Makefile.am  |   38 -
 stage2/btrfs.h      | 1413 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 stage2/builtins.c   |    1 
 stage2/disk_io.c    |    3 
 stage2/filesys.h    |   10 
 stage2/fsys_btrfs.c | 1402 +++++++++++++++++++++++++++++++++++++++++++++++++++
 stage2/shared.h     |   13 
 11 files changed, 2876 insertions(+), 19 deletions(-)

--- grub-0.97.orig/INSTALL
+++ grub-0.97/INSTALL
@@ -207,6 +207,9 @@ operates.
 `--disable-reiserfs'
      Omit the ReiserFS support in Stage 2.
 
+`--disable-btrfs'
+     Omit the BtrFS support in Stage 2.
+
 `--disable-vstafs'
      Omit the VSTa filesystem support in Stage 2.
 
--- grub-0.97.orig/configure.in
+++ grub-0.97/configure.in
@@ -337,6 +337,13 @@ if test x"$enable_reiserfs" != xno; then
   FSYS_CFLAGS="$FSYS_CFLAGS -DFSYS_REISERFS=1"
 fi
 
+AC_ARG_ENABLE(btrfs,
+  [  --disable-btrfs         disable BtrFS support in Stage 2])
+
+if test x"$enable_btrfs" != xno; then
+  FSYS_CFLAGS="$FSYS_CFLAGS -DFSYS_BTRFS=1"
+fi
+
 AC_ARG_ENABLE(vstafs,
   [  --disable-vstafs        disable VSTa FS support in Stage 2])
 
--- grub-0.97.orig/docs/grub.texi
+++ grub-0.97/docs/grub.texi
@@ -283,7 +283,7 @@ devices, partitions, and files in a dire
 Support multiple filesystem types transparently, plus a useful explicit
 blocklist notation. The currently supported filesystem types are
 @dfn{BSD FFS}, @dfn{DOS FAT16 and FAT32}, @dfn{Minix fs}, @dfn{Linux
-ext2fs}, @dfn{ReiserFS}, @dfn{JFS}, @dfn{XFS}, and @dfn{VSTa
+ext2fs}, @dfn{ReiserFS}, @dfn{BtrFS}, @dfn{JFS}, @dfn{XFS}, and @dfn{VSTa
 fs}. @xref{Filesystem}, for more information.
 
 @item Support automatic decompression
@@ -1776,6 +1776,7 @@ itself. Usually, this is put in a filesy
 @itemx jfs_stage1_5
 @itemx minix_stage1_5
 @itemx reiserfs_stage1_5
+@itemx btrfs_stage1_5
 @itemx vstafs_stage1_5
 @itemx xfs_stage1_5
 
--- grub-0.97.orig/stage2/Makefile.am
+++ grub-0.97/stage2/Makefile.am
@@ -21,13 +21,13 @@ noinst_LIBRARIES = libgrub.a
 endif
 libgrub_a_SOURCES = boot.c builtins.c char_io.c cmdline.c common.c \
 	disk_io.c fsys_ext2fs.c fsys_fat.c fsys_ffs.c fsys_iso9660.c \
-	fsys_jfs.c fsys_minix.c fsys_reiserfs.c fsys_ufs2.c \
+	fsys_jfs.c fsys_minix.c fsys_reiserfs.c fsys_btrfs.c fsys_ufs2.c \
 	fsys_vstafs.c fsys_xfs.c gunzip.c md5.c serial.c stage2.c \
 	terminfo.c tparm.c graphics.c
 libgrub_a_CFLAGS = $(GRUB_CFLAGS) -I$(top_srcdir)/lib \
 	-DGRUB_UTIL=1 -DFSYS_EXT2FS=1 -DFSYS_FAT=1 -DFSYS_FFS=1 \
 	-DFSYS_ISO9660=1 -DFSYS_JFS=1 -DFSYS_MINIX=1 -DFSYS_REISERFS=1 \
-	-DFSYS_UFS2=1 -DFSYS_VSTAFS=1 -DFSYS_XFS=1 \
+	-DFSYS_BTRFS=1 -DFSYS_UFS2=1 -DFSYS_VSTAFS=1 -DFSYS_XFS=1 \
 	-DUSE_MD5_PASSWORDS=1 -DSUPPORT_SERIAL=1 -DSUPPORT_HERCULES=1
 
 # Stage 2 and Stage 1.5's.
@@ -40,24 +40,26 @@ EXTRA_PROGRAMS = nbloader.exec pxeloader
 if DISKLESS_SUPPORT
 pkgdata_DATA = stage2 stage2_eltorito e2fs_stage1_5 fat_stage1_5 \
 	ffs_stage1_5 iso9660_stage1_5 jfs_stage1_5 minix_stage1_5 \
-	reiserfs_stage1_5 ufs2_stage1_5 vstafs_stage1_5 xfs_stage1_5 \
-	nbgrub pxegrub
+	reiserfs_stage1_5 btrfs_stage1_5 ufs2_stage1_5 vstafs_stage1_5 \
+	xfs_stage1_5 nbgrub pxegrub
 noinst_DATA = pre_stage2 start start_eltorito nbloader pxeloader diskless
 noinst_PROGRAMS = pre_stage2.exec start.exec start_eltorito.exec \
 	e2fs_stage1_5.exec fat_stage1_5.exec ffs_stage1_5.exec \
 	iso9660_stage1_5.exec jfs_stage1_5.exec minix_stage1_5.exec \
-	reiserfs_stage1_5.exec ufs2_stage1_5.exec vstafs_stage1_5.exec \
-	xfs_stage1_5.exec nbloader.exec pxeloader.exec diskless.exec
+	reiserfs_stage1_5.exec btrfs_stage1_5.exec ufs2_stage1_5.exec \
+	vstafs_stage1_5.exec xfs_stage1_5.exec nbloader.exec \
+	pxeloader.exec diskless.exec
 else
 pkgdata_DATA = stage2 stage2_eltorito e2fs_stage1_5 fat_stage1_5 \
 	ffs_stage1_5 iso9660_stage1_5 jfs_stage1_5 minix_stage1_5 \
-	reiserfs_stage1_5 ufs2_stage1_5 vstafs_stage1_5 xfs_stage1_5
+	reiserfs_stage1_5 btrfs_stage1_5 ufs2_stage1_5 vstafs_stage1_5 \
+        xfs_stage1_5
 noinst_DATA = pre_stage2 start start_eltorito
 noinst_PROGRAMS = pre_stage2.exec start.exec start_eltorito.exec \
 	e2fs_stage1_5.exec fat_stage1_5.exec ffs_stage1_5.exec \
 	iso9660_stage1_5.exec jfs_stage1_5.exec minix_stage1_5.exec \
-	reiserfs_stage1_5.exec ufs2_stage1_5.exec vstafs_stage1_5.exec \
-	xfs_stage1_5.exec
+	reiserfs_stage1_5.exec btrfs_stage1_5.exec ufs2_stage1_5.exec \
+        vstafs_stage1_5.exec xfs_stage1_5.exec
 endif
 MOSTLYCLEANFILES = $(noinst_PROGRAMS)
 
@@ -98,7 +100,7 @@ STAGE2_COMPILE = $(STAGE2_CFLAGS) -fno-b
 
 libstage2_a_SOURCES = boot.c builtins.c char_io.c cmdline.c common.c \
 	disk_io.c fsys_ext2fs.c fsys_fat.c fsys_ffs.c fsys_iso9660.c \
-	fsys_jfs.c fsys_minix.c fsys_reiserfs.c fsys_ufs2.c \
+	fsys_jfs.c fsys_minix.c fsys_reiserfs.c fsys_btrfs.c fsys_ufs2.c \
 	fsys_vstafs.c fsys_xfs.c gunzip.c md5.c serial.c stage2.c \
 	terminfo.c tparm.c
 libstage2_a_CFLAGS = $(STAGE2_COMPILE) $(FSYS_CFLAGS)
@@ -112,9 +114,9 @@ STAGE1_5_COMPILE = $(STAGE2_COMPILE) -DN
 pre_stage2_exec_SOURCES = asm.S bios.c boot.c builtins.c char_io.c \
 	cmdline.c common.c console.c disk_io.c fsys_ext2fs.c \
 	fsys_fat.c fsys_ffs.c fsys_iso9660.c fsys_jfs.c fsys_minix.c \
-	fsys_reiserfs.c fsys_ufs2.c fsys_vstafs.c fsys_xfs.c gunzip.c \
-	hercules.c md5.c serial.c smp-imps.c stage2.c terminfo.c tparm.c \
-	graphics.c
+	fsys_reiserfs.c fsys_btrfs.c fsys_ufs2.c fsys_vstafs.c fsys_xfs.c \
+	gunzip.c hercules.c md5.c serial.c smp-imps.c stage2.c terminfo.c \
+	tparm.c graphics.c
 pre_stage2_exec_CFLAGS = $(STAGE2_COMPILE) $(FSYS_CFLAGS)
 pre_stage2_exec_CCASFLAGS = $(STAGE2_COMPILE) $(FSYS_CFLAGS)
 pre_stage2_exec_LDFLAGS = $(PRE_STAGE2_LINK)
@@ -223,6 +225,16 @@ reiserfs_stage1_5_exec_CCASFLAGS = $(STA
 reiserfs_stage1_5_exec_LDFLAGS = $(STAGE1_5_LINK)
 reiserfs_stage1_5_exec_LDADD = @LIBGCC@
 
+# For btrfs_stage1_5 target.
+btrfs_stage1_5_exec_SOURCES = start.S asm.S common.c char_io.c \
+	disk_io.c stage1_5.c fsys_btrfs.c bios.c
+btrfs_stage1_5_exec_CFLAGS = $(STAGE1_5_COMPILE) -DFSYS_BTRFS=1 \
+	-DNO_BLOCK_FILES=1
+btrfs_stage1_5_exec_CCASFLAGS = $(STAGE1_5_COMPILE) -DFSYS_BTRFS=1 \
+	-DNO_BLOCK_FILES=1
+btrfs_stage1_5_exec_LDFLAGS = $(STAGE1_5_LINK)
+btrfs_stage1_5_exec_LDADD = @LIBGCC@
+
 # For vstafs_stage1_5 target.
 vstafs_stage1_5_exec_SOURCES = start.S asm.S common.c char_io.c \
 	disk_io.c stage1_5.c fsys_vstafs.c bios.c
--- /dev/null
+++ grub-0.97/stage2/btrfs.h
@@ -0,0 +1,1413 @@
+/* btrfs.h - an extraction from btrfs-progs-0.18/ctree.h into one file
+ *
+ * Copyright (C) 2007 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+/* include/asm-i386/types.h */
+
+typedef __signed__ char __s8;
+typedef unsigned char __u8;
+typedef __signed__ short __s16;
+typedef unsigned short __u16;
+typedef __signed__ int __s32;
+typedef unsigned int __u32;
+typedef unsigned long long __u64;
+typedef __signed__ long long __s64;
+
+typedef __s8 s8;
+typedef __u8 u8;
+typedef __u16 u16;
+typedef __u32 u32;
+typedef __u64 u64;
+typedef __s64 s64;
+
+#define __bitwise
+
+typedef u16 __bitwise __le16;
+typedef u32 __bitwise __le32;
+typedef u64 __bitwise __le64;
+
+/* linux/posix_type.h */
+typedef long linux_off_t;
+
+/* linux/little_endian.h */
+#define cpu_to_le64(x) ((__u64) (x))
+#define le64_to_cpu(x) ((__u64) (x))
+#define cpu_to_le32(x) ((__u32) (x))
+#define le32_to_cpu(x) ((__u32) (x))
+#define cpu_to_le16(x) ((__u16) (x))
+#define le16_to_cpu(x) ((__u16) (x))
+#define le8_to_cpu(x) ((__u8) (x))
+#define cpu_to_le8(x) ((__u8) (x))
+
+/* linux/stat.h */
+#define S_IFMT  00170000
+#define S_IFLNK  0120000
+#define S_IFREG  0100000
+#define S_IFDIR  0040000
+#define S_ISLNK(m)	(((m) & S_IFMT) == S_IFLNK)
+#define S_ISREG(m)      (((m) & S_IFMT) == S_IFREG)
+#define S_ISDIR(m)      (((m) & S_IFMT) == S_IFDIR)
+
+struct btrfs_root;
+#define BTRFS_MAGIC "_BHRfS_M"
+
+#define BTRFS_SUPER_INFO_OFFSET (64 * 1024)
+#define BTRFS_SUPER_INFO_SIZE 4096
+
+#define BTRFS_SUPER_MIRROR_MAX	 3
+#define BTRFS_SUPER_MIRROR_SHIFT 12
+
+#define PATH_MAX                1024	/* include/linux/limits.h */
+#define MAX_LINK_COUNT             5	/* number of symbolic links
+					   to follow */
+#define BTRFS_MAX_LEVEL 8
+#define BTRFS_ROOT_TREE_OBJECTID 1ULL
+#define BTRFS_EXTENT_TREE_OBJECTID 2ULL
+#define BTRFS_CHUNK_TREE_OBJECTID 3ULL
+#define BTRFS_DEV_TREE_OBJECTID 4ULL
+#define BTRFS_FS_TREE_OBJECTID 5ULL
+#define BTRFS_ROOT_TREE_DIR_OBJECTID 6ULL
+#define BTRFS_CSUM_TREE_OBJECTID 7ULL
+
+#define BTRFS_ORPHAN_OBJECTID -5ULL
+#define BTRFS_TREE_LOG_OBJECTID -6ULL
+#define BTRFS_TREE_LOG_FIXUP_OBJECTID -7ULL
+#define BTRFS_TREE_RELOC_OBJECTID -8ULL
+#define BTRFS_DATA_RELOC_TREE_OBJECTID -9ULL
+#define BTRFS_EXTENT_CSUM_OBJECTID -10ULL
+
+#define BTRFS_MULTIPLE_OBJECTIDS -255ULL
+#define BTRFS_FIRST_FREE_OBJECTID 256ULL
+#define BTRFS_LAST_FREE_OBJECTID -256ULL
+#define BTRFS_FIRST_CHUNK_TREE_OBJECTID 256ULL
+#define BTRFS_DEV_ITEMS_OBJECTID 1ULL
+
+
+#define BTRFS_NAME_LEN 255
+#define BTRFS_CSUM_SIZE 32
+#define BTRFS_CSUM_TYPE_CRC32	0
+
+static int btrfs_csum_sizes[] = { 4, 0 };
+
+/* four bytes for CRC32 */
+#define BTRFS_CRC32_SIZE 4
+#define BTRFS_EMPTY_DIR_SIZE 0
+
+#define BTRFS_FT_UNKNOWN	0
+#define BTRFS_FT_REG_FILE	1
+#define BTRFS_FT_DIR		2
+#define BTRFS_FT_CHRDEV		3
+#define BTRFS_FT_BLKDEV		4
+#define BTRFS_FT_FIFO		5
+#define BTRFS_FT_SOCK		6
+#define BTRFS_FT_SYMLINK	7
+#define BTRFS_FT_XATTR		8
+#define BTRFS_FT_MAX		9
+
+#define BTRFS_UUID_SIZE 16
+
+#define BTRFS_DEFAULT_NUM_DEVICES     1
+#define BTRFS_DEFAULT_NODE_SIZE       4096
+#define BTRFS_DEFAULT_LEAF_SIZE       4096
+
+#define WARN_ON(c)
+#define cassert(cond) ({ switch (-1) { case (cond): case 0: break; } })
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+#define offsetof(type, memb) \
+	((unsigned long)(&((type *)0)->memb))
+
+struct btrfs_disk_key {
+	__le64 objectid;
+	u8 type;
+	__le64 offset;
+} __attribute__ ((__packed__));
+
+/* cpu key */
+struct btrfs_key {
+	u64 objectid;
+	u8 type;
+	u64 offset;
+} __attribute__ ((__packed__));
+
+/* this represents a divice in a chunk tree */
+struct btrfs_dev_item {
+	__le64 devid; /* internal device id */
+	__le64 total_bytes; /* size of the device */
+	__le64 bytes_used;
+	__le32 io_align; /* optimal io alignment */
+	__le32 io_width; /* optimal io width */
+	__le32 sector_size; /* minimal io size */
+	__le64 type; /* type and info about this device */
+	__le64 generation; /* expected generation */
+        __le64 start_offset; /* of the partition on a device */
+
+	/* info for allocation decisions */
+	__le32 dev_group;
+
+        u8 seek_speed; /* 0-100 (100 is fastest) */
+	u8 bandwidth;  /* 0-100 (100 is fastest) */
+
+        u8 uuid[BTRFS_UUID_SIZE]; /* dev uuid generated by btrfs */
+	u8 fsid[BTRFS_UUID_SIZE]; /* uuid of the host FS */
+} __attribute__ ((__packed__));
+
+struct btrfs_stripe {
+	__le64 devid;
+	__le64 offset;
+	u8 dev_uuid[BTRFS_UUID_SIZE];
+} __attribute__ ((__packed__));
+
+struct btrfs_chunk {
+	/* size of this chunk in bytes */
+	__le64 length;
+	__le64 owner; /* objectid of the root referincing this chunk */
+	__le64 stripe_len;
+	__le64 type;
+	__le32 io_align; /* optimal io alignment for this chunk */
+	__le32 io_width; /* optimal io width for this chunk */
+	__le32 sector_size; /* minimal io size for this chunk */
+	__le16 num_stripes;
+	__le16 sub_stripes; /* sub stripes (for raid10) */
+	struct btrfs_stripe stripe;
+} __attribute__ ((__packed__));
+
+static inline unsigned long btrfs_chunk_item_size(int num_stripes)
+{
+	return sizeof(struct btrfs_chunk) +
+		sizeof(struct btrfs_stripe) * (num_stripes - 1);
+}
+
+#define BTRFS_FSID_SIZE 16
+#define BTRFS_HEADER_FLAG_WRITTEN (1 << 0)
+
+struct btrfs_header {
+	/* these first four must match the super block */
+	u8 csum[BTRFS_CSUM_SIZE];
+	u8 fsid[BTRFS_FSID_SIZE]; /* uuid of the host fs */
+	__le64 bytenr; /* which block this node is supposed to live in */
+	__le64 flags;
+
+	/* allowed to be different from the super from here on down */
+	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
+	__le64 generation;
+	__le64 owner;
+	__le32 nritems;
+	u8 level;
+} __attribute__ ((__packed__));
+
+#define BTRFS_NODEPTRS_PER_BLOCK(r) (((r)->nodesize - \
+			        sizeof(struct btrfs_header)) / \
+			        sizeof(struct btrfs_key_ptr))
+#define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
+#define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->leafsize))
+#define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r) - \
+					sizeof(struct btrfs_item) - \
+					sizeof(struct btrfs_file_extent_item))
+
+#define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
+#define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
+
+/*
+ * a portion of superblock which is used
+ * for chunk translation (up to 14 chunks
+ * with 3 stripes each.
+ */
+#define BTRFS_SYSTEM_CHUNK_ARRAY_SIZE 2048
+#define BTRFS_LABEL_SIZE 256
+
+/*
+ * the super block basically lists the main trees of the FS
+ * it currently lacks any block count etc etc
+ */
+struct btrfs_super_block {
+	u8 csum[BTRFS_CSUM_SIZE];
+	/* the first 3 fields must match struct btrfs_header */
+	u8 fsid[BTRFS_FSID_SIZE];    /* FS specific uuid */
+	__le64 bytenr; /* this block number */
+	__le64 flags;
+
+	/* allowed to be different from the btrfs_header from here own down */
+	__le64 magic;
+	__le64 generation;
+	__le64 root;        /* tree root */
+	__le64 chunk_root;
+	__le64 log_root;
+
+	/* this will help find the new super based on the log root */
+	__le64 log_root_transid;
+	__le64 total_bytes;
+	__le64 bytes_used;
+	__le64 root_dir_objectid;
+	__le64 num_devices;
+	__le32 sectorsize;
+	__le32 nodesize;
+	__le32 leafsize;
+	__le32 stripesize;
+	__le32 sys_chunk_array_size;
+	__le64 chunk_root_generation;
+	__le64 compat_flags;
+	__le64 compat_ro_flags;
+	__le64 incompat_flags;
+	__le16 csum_type;
+	u8 root_level;
+	u8 chunk_root_level;
+	u8 log_root_level;
+	struct btrfs_dev_item dev_item;
+
+	char label[BTRFS_LABEL_SIZE];
+
+	/* future expansion */
+	__le64 reserved[32];
+	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
+} __attribute__ ((__packed__));
+
+/*
+ * Compat flags that we support.  If any incompat flags are set other than the
+ * ones specified below then we will fail to mount
+ */
+#define BTRFS_FEATURE_COMPAT_SUPP	0x0
+#define BTRFS_FEATURE_COMPAT_RO_SUPP	0x0
+#define BTRFS_FEATURE_INCOMPAT_SUPP	0x0
+
+/* Item header for per-leaf lookup */
+struct btrfs_item {
+	struct btrfs_disk_key key;
+	__le32 offset;
+	__le32 size;
+} __attribute__ ((__packed__));
+
+/*
+ * Format of the leaves:
+ * [item0, item1....itemN] [free space] [dataN...data1, data0]
+ */
+struct btrfs_leaf {
+	struct btrfs_header header;
+	struct btrfs_item items[];
+} __attribute__ ((__packed__));
+
+/*
+ * keys-pointers pairs for per-node (non-leaf) lookup
+ */
+struct btrfs_key_ptr {
+	struct btrfs_disk_key key;
+	__le64 blockptr;
+	__le64 generation;
+} __attribute__ ((__packed__));
+
+struct btrfs_node {
+	struct btrfs_header header;
+	struct btrfs_key_ptr ptrs[];
+} __attribute__ ((__packed__));
+
+struct extent_buffer {
+	/* metadata */
+	u64 start;
+	u64 dev_bytenr;
+	u32 len;
+	int refs;
+	int flags;
+	char *data;
+};
+
+static inline void read_extent_buffer(struct extent_buffer *eb,
+				      void *dst, unsigned long start,
+				      unsigned long len)
+{
+	memcpy(dst, eb->data + start, len);
+}
+
+static inline void write_extent_buffer(struct extent_buffer *eb,
+				       const void *src, unsigned long start,
+				       unsigned long len)
+{
+	memcpy(eb->data + start, src, len);
+}
+
+/*
+ * NOTE:
+ * don't increase a number of levels for grub-0.97!
+ */
+typedef enum {
+	FIRST_EXTERNAL_LOOKUP_POOL,
+	SECOND_EXTERNAL_LOOKUP_POOL,
+	INTERNAL_LOOKUP_POOL,
+	LAST_LOOKUP_POOL
+} lookup_pool_id;
+
+/*             Relationship between lookup pools:
+ *  depth
+ *
+ *    ^             +----> INTERNAL <----+
+ *    |             |                    |
+ *    |             |                    |
+ *    -        FIRST_EXTERNAL     SECOND_EXTERNAL
+ */
+
+struct btrfs_path {
+	lookup_pool_id lpid;
+	struct extent_buffer nodes[BTRFS_MAX_LEVEL];
+	int slots[BTRFS_MAX_LEVEL];
+};
+
+/*
+ * items in the extent btree are used to record the objectid of the
+ * owner of the block and the number of references
+ */
+struct btrfs_extent_item {
+	__le32 refs;
+} __attribute__ ((__packed__));
+
+struct btrfs_extent_ref {
+	__le64 root;
+	__le64 generation;
+	__le64 objectid;
+	__le32 num_refs;
+} __attribute__ ((__packed__));
+
+/* dev extents record free space on individual devices.  The owner
+ * field points back to the chunk allocation mapping tree that allocated
+ * the extent.  The chunk tree uuid field is a way to double check the owner
+ */
+struct btrfs_dev_extent {
+	__le64 chunk_tree;
+	__le64 chunk_objectid;
+	__le64 chunk_offset;
+	__le64 length;
+	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
+} __attribute__ ((__packed__));
+
+struct btrfs_inode_ref {
+	__le64 index;
+	__le16 name_len;
+	/* name goes here */
+} __attribute__ ((__packed__));
+
+struct btrfs_timespec {
+	__le64 sec;
+	__le32 nsec;
+} __attribute__ ((__packed__));
+
+typedef enum {
+	BTRFS_COMPRESS_NONE = 0,
+	BTRFS_COMPRESS_ZLIB = 1,
+	BTRFS_COMPRESS_LAST = 2,
+} btrfs_compression_type;
+
+/* we don't understand any encryption methods right now */
+typedef enum {
+	BTRFS_ENCRYPTION_NONE = 0,
+	BTRFS_ENCRYPTION_LAST = 1,
+} btrfs_encryption_type;
+
+struct btrfs_inode_item {
+	/* nfs style generation number */
+	__le64 generation;
+	/* transid that last touched this inode */
+	__le64 transid;
+	__le64 size;
+	__le64 nbytes;
+	__le64 block_group;
+	__le32 nlink;
+	__le32 uid;
+	__le32 gid;
+	__le32 mode;
+	__le64 rdev;
+	__le64 flags;
+
+	/* modification sequence number for NFS */
+	__le64 sequence;
+
+	/*
+	 * a little future expansion, for more than this we can
+	 * just grow the inode item and version it
+	 */
+	__le64 reserved[4];
+	struct btrfs_timespec atime;
+	struct btrfs_timespec ctime;
+	struct btrfs_timespec mtime;
+	struct btrfs_timespec otime;
+} __attribute__ ((__packed__));
+
+struct btrfs_dir_item {
+	struct btrfs_disk_key location;
+	__le64 transid;
+	__le16 data_len;
+	__le16 name_len;
+	u8 type;
+} __attribute__ ((__packed__));
+
+struct btrfs_root_item {
+	struct btrfs_inode_item inode;
+	__le64 generation;
+	__le64 root_dirid;
+	__le64 bytenr;
+	__le64 byte_limit;
+	__le64 bytes_used;
+	__le64 last_snapshot;
+	__le64 flags;
+	__le32 refs;
+	struct btrfs_disk_key drop_progress;
+	u8 drop_level;
+	u8 level;
+} __attribute__ ((__packed__));
+
+/*
+ * this is used for both forward and backward root refs
+ */
+struct btrfs_root_ref {
+	__le64 dirid;
+	__le64 sequence;
+	__le16 name_len;
+} __attribute__ ((__packed__));
+
+#define BTRFS_FILE_EXTENT_INLINE 0
+#define BTRFS_FILE_EXTENT_REG 1
+#define BTRFS_FILE_EXTENT_PREALLOC 2
+
+struct btrfs_file_extent_item {
+	/*
+	 * transaction id that created this extent
+	 */
+	__le64 generation;
+	/*
+	 * max number of bytes to hold this extent in ram
+	 * when we split a compressed extent we can't know how big
+	 * each of the resulting pieces will be.  So, this is
+	 * an upper limit on the size of the extent in ram instead of
+	 * an exact limit.
+	 */
+	__le64 ram_bytes;
+
+	/*
+	 * 32 bits for the various ways we might encode the data,
+	 * including compression and encryption.  If any of these
+	 * are set to something a given disk format doesn't understand
+	 * it is treated like an incompat flag for reading and writing,
+	 * but not for stat.
+	 */
+	u8 compression;
+	u8 encryption;
+	__le16 other_encoding; /* spare for later use */
+
+	/* are we inline data or a real extent? */
+	u8 type;
+
+	/*
+	 * disk space consumed by the extent, checksum blocks are included
+	 * in these numbers
+	 */
+	__le64 disk_bytenr;
+	__le64 disk_num_bytes;
+	/*
+	 * the logical offset in file blocks (no csums)
+	 * this extent record is for.  This allows a file extent to point
+	 * into the middle of an existing extent on disk, sharing it
+	 * between two snapshots (useful if some bytes in the middle of the
+	 * extent have changed
+	 */
+	__le64 offset;
+	/*
+	 * the logical number of file blocks (no csums included)
+	 */
+	__le64 num_bytes;
+
+} __attribute__ ((__packed__));
+
+struct btrfs_csum_item {
+	u8 csum;
+} __attribute__ ((__packed__));
+
+/* tag for the radix tree of block groups in ram */
+#define BTRFS_BLOCK_GROUP_DATA     (1 << 0)
+#define BTRFS_BLOCK_GROUP_SYSTEM   (1 << 1)
+#define BTRFS_BLOCK_GROUP_METADATA (1 << 2)
+#define BTRFS_BLOCK_GROUP_RAID0    (1 << 3)
+#define BTRFS_BLOCK_GROUP_RAID1    (1 << 4)
+#define BTRFS_BLOCK_GROUP_DUP	   (1 << 5)
+#define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
+
+struct btrfs_block_group_item {
+	__le64 used;
+	__le64 chunk_objectid;
+	__le64 flags;
+} __attribute__ ((__packed__));
+
+/*
+ * in ram representation of the tree.  extent_root is used for all allocations
+ * and for the extent tree extent_root root.
+ */
+struct btrfs_root {
+	struct extent_buffer   node;
+	char                   data[4096];
+	struct extent_buffer   *commit_root;
+	struct btrfs_root_item root_item;
+	struct btrfs_key       root_key;
+	struct btrfs_fs_info   *fs_info;
+	u64 objectid;
+	u64 last_trans;
+
+	/* data allocations are done in sectorsize units */
+	u32 sectorsize;
+
+	/* node allocations are done in nodesize units */
+	u32 nodesize;
+
+	/* leaf allocations are done in leafsize units */
+	u32 leafsize;
+
+	/* leaf allocations are done in leafsize units */
+	u32 stripesize;
+
+	int ref_cows;
+	int track_dirty;
+
+
+	u32 type;
+	u64 highest_inode;
+	u64 last_inode_alloc;
+};
+
+struct btrfs_root;
+struct btrfs_fs_devices;
+struct btrfs_fs_info {
+	u8 fsid[BTRFS_FSID_SIZE];
+	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
+	struct btrfs_root fs_root;
+	struct btrfs_root tree_root;
+	struct btrfs_root chunk_root;
+
+	struct btrfs_key  file_info; /* currently opened file */
+	struct btrfs_path paths [LAST_LOOKUP_POOL];
+
+	u64 generation;
+	u64 last_trans_committed;
+
+	u64 system_alloc_profile;
+	u64 alloc_start;
+
+	struct btrfs_super_block super_temp;
+   	struct btrfs_super_block super_copy;
+
+	u64 super_bytenr;
+	u64 total_pinned;
+
+	int system_allocs;
+	int readonly;
+};
+
+/*
+ * inode items have the data typically returned from stat and store other
+ * info about object characteristics.  There is one for every file and dir in
+ * the FS
+ */
+#define BTRFS_INODE_ITEM_KEY		1
+#define BTRFS_INODE_REF_KEY		12
+#define BTRFS_XATTR_ITEM_KEY		24
+#define BTRFS_ORPHAN_ITEM_KEY		48
+
+#define BTRFS_DIR_LOG_ITEM_KEY  60
+#define BTRFS_DIR_LOG_INDEX_KEY 72
+/*
+ * dir items are the name -> inode pointers in a directory.  There is one
+ * for every name in a directory.
+ */
+#define BTRFS_DIR_ITEM_KEY	84
+#define BTRFS_DIR_INDEX_KEY	96
+
+/*
+ * extent data is for file data
+ */
+#define BTRFS_EXTENT_DATA_KEY	108
+
+/*
+ * csum items have the checksums for data in the extents
+ */
+#define BTRFS_CSUM_ITEM_KEY	120
+/*
+ * extent csums are stored in a separate tree and hold csums for
+ * an entire extent on disk.
+ */
+#define BTRFS_EXTENT_CSUM_KEY	128
+
+/*
+ * root items point to tree roots.  There are typically in the root
+ * tree used by the super block to find all the other trees
+ */
+#define BTRFS_ROOT_ITEM_KEY	132
+
+/*
+ * root backrefs tie subvols and snapshots to the directory entries that
+ * reference them
+ */
+#define BTRFS_ROOT_BACKREF_KEY	144
+
+/*
+ * root refs make a fast index for listing all of the snapshots and
+ * subvolumes referenced by a given root.  They point directly to the
+ * directory item in the root that references the subvol
+ */
+#define BTRFS_ROOT_REF_KEY	156
+
+/*
+ * extent items are in the extent map tree.  These record which blocks
+ * are used, and how many references there are to each block
+ */
+#define BTRFS_EXTENT_ITEM_KEY	168
+#define BTRFS_EXTENT_REF_KEY	180
+
+/*
+ * block groups give us hints into the extent allocation trees.  Which
+ * blocks are free etc etc
+ */
+#define BTRFS_BLOCK_GROUP_ITEM_KEY 192
+
+#define BTRFS_DEV_EXTENT_KEY	204
+#define BTRFS_DEV_ITEM_KEY	216
+#define BTRFS_CHUNK_ITEM_KEY	228
+
+/*
+ * string items are for debugging.  They just store a short string of
+ * data in the FS
+ */
+#define BTRFS_STRING_ITEM_KEY	253
+/*
+ * Inode flags
+ */
+#define BTRFS_INODE_NODATASUM		(1 << 0)
+#define BTRFS_INODE_NODATACOW		(1 << 1)
+#define BTRFS_INODE_READONLY		(1 << 2)
+
+#define read_eb_member(eb, ptr, type, member, result) (			\
+	read_extent_buffer(eb, (char *)(result),			\
+			   ((unsigned long)(ptr)) +			\
+			    offsetof(type, member),			\
+			   sizeof(((type *)0)->member)))
+
+#define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
+static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
+{									\
+	struct btrfs_header *h = (struct btrfs_header *)eb->data;	\
+	return le##bits##_to_cpu(h->member);				\
+}									\
+static inline void btrfs_set_##name(struct extent_buffer *eb,		\
+				    u##bits val)			\
+{									\
+	struct btrfs_header *h = (struct btrfs_header *)eb->data;	\
+	h->member = cpu_to_le##bits(val);				\
+}
+
+#define BTRFS_SETGET_FUNCS(name, type, member, bits)			\
+static inline u##bits btrfs_##name(struct extent_buffer *eb,		\
+				   type *s)				\
+{									\
+	unsigned long offset = (unsigned long)s;			\
+	type *p = (type *) (eb->data + offset);				\
+	return le##bits##_to_cpu(p->member);				\
+}									\
+static inline void btrfs_set_##name(struct extent_buffer *eb,		\
+				    type *s, u##bits val)		\
+{									\
+	unsigned long offset = (unsigned long)s;			\
+	type *p = (type *) (eb->data + offset);				\
+	p->member = cpu_to_le##bits(val);				\
+}
+
+#define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\
+static inline u##bits btrfs_##name(type *s)				\
+{									\
+	return le##bits##_to_cpu(s->member);				\
+}									\
+static inline void btrfs_set_##name(type *s, u##bits val)		\
+{									\
+	s->member = cpu_to_le##bits(val);				\
+}
+
+BTRFS_SETGET_FUNCS(device_type, struct btrfs_dev_item, type, 64);
+BTRFS_SETGET_FUNCS(device_total_bytes, struct btrfs_dev_item, total_bytes, 64);
+BTRFS_SETGET_FUNCS(device_bytes_used, struct btrfs_dev_item, bytes_used, 64);
+BTRFS_SETGET_FUNCS(device_io_align, struct btrfs_dev_item, io_align, 32);
+BTRFS_SETGET_FUNCS(device_io_width, struct btrfs_dev_item, io_width, 32);
+BTRFS_SETGET_FUNCS(device_start_offset, struct btrfs_dev_item,
+		   start_offset, 64);
+BTRFS_SETGET_FUNCS(device_sector_size, struct btrfs_dev_item, sector_size, 32);
+BTRFS_SETGET_FUNCS(device_id, struct btrfs_dev_item, devid, 64);
+BTRFS_SETGET_FUNCS(device_group, struct btrfs_dev_item, dev_group, 32);
+BTRFS_SETGET_FUNCS(device_seek_speed, struct btrfs_dev_item, seek_speed, 8);
+BTRFS_SETGET_FUNCS(device_bandwidth, struct btrfs_dev_item, bandwidth, 8);
+BTRFS_SETGET_FUNCS(device_generation, struct btrfs_dev_item, generation, 64);
+
+BTRFS_SETGET_STACK_FUNCS(stack_device_type, struct btrfs_dev_item, type, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_device_total_bytes, struct btrfs_dev_item,
+			 total_bytes, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_device_bytes_used, struct btrfs_dev_item,
+			 bytes_used, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_device_io_align, struct btrfs_dev_item,
+			 io_align, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_device_io_width, struct btrfs_dev_item,
+			 io_width, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_device_sector_size, struct btrfs_dev_item,
+			 sector_size, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_device_id, struct btrfs_dev_item, devid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_device_group, struct btrfs_dev_item,
+			 dev_group, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_device_seek_speed, struct btrfs_dev_item,
+			 seek_speed, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_device_bandwidth, struct btrfs_dev_item,
+			 bandwidth, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_device_generation, struct btrfs_dev_item,
+			 generation, 64);
+
+static inline char *btrfs_device_uuid(struct btrfs_dev_item *d)
+{
+	return (char *)d + offsetof(struct btrfs_dev_item, uuid);
+}
+
+static inline char *btrfs_device_fsid(struct btrfs_dev_item *d)
+{
+	return (char *)d + offsetof(struct btrfs_dev_item, fsid);
+}
+
+BTRFS_SETGET_FUNCS(chunk_length, struct btrfs_chunk, length, 64);
+BTRFS_SETGET_FUNCS(chunk_owner, struct btrfs_chunk, owner, 64);
+BTRFS_SETGET_FUNCS(chunk_stripe_len, struct btrfs_chunk, stripe_len, 64);
+BTRFS_SETGET_FUNCS(chunk_io_align, struct btrfs_chunk, io_align, 32);
+BTRFS_SETGET_FUNCS(chunk_io_width, struct btrfs_chunk, io_width, 32);
+BTRFS_SETGET_FUNCS(chunk_sector_size, struct btrfs_chunk, sector_size, 32);
+BTRFS_SETGET_FUNCS(chunk_type, struct btrfs_chunk, type, 64);
+BTRFS_SETGET_FUNCS(chunk_num_stripes, struct btrfs_chunk, num_stripes, 16);
+BTRFS_SETGET_FUNCS(chunk_sub_stripes, struct btrfs_chunk, sub_stripes, 16);
+BTRFS_SETGET_FUNCS(stripe_devid, struct btrfs_stripe, devid, 64);
+BTRFS_SETGET_FUNCS(stripe_offset, struct btrfs_stripe, offset, 64);
+
+static inline char *btrfs_stripe_dev_uuid(struct btrfs_stripe *s)
+{
+	return (char *)s + offsetof(struct btrfs_stripe, dev_uuid);
+}
+
+BTRFS_SETGET_STACK_FUNCS(stack_chunk_length, struct btrfs_chunk, length, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_chunk_owner, struct btrfs_chunk, owner, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_chunk_stripe_len, struct btrfs_chunk,
+			 stripe_len, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_chunk_io_align, struct btrfs_chunk,
+			 io_align, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_chunk_io_width, struct btrfs_chunk,
+			 io_width, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_chunk_sector_size, struct btrfs_chunk,
+			 sector_size, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_chunk_type, struct btrfs_chunk, type, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_chunk_num_stripes, struct btrfs_chunk,
+			 num_stripes, 16);
+BTRFS_SETGET_STACK_FUNCS(stack_chunk_sub_stripes, struct btrfs_chunk,
+			 sub_stripes, 16);
+BTRFS_SETGET_STACK_FUNCS(stack_stripe_devid, struct btrfs_stripe, devid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_stripe_offset, struct btrfs_stripe, offset, 64);
+
+static inline struct btrfs_stripe *btrfs_stripe_nr(struct btrfs_chunk *c,
+						   int nr)
+{
+	unsigned long offset = (unsigned long)c;
+	offset += offsetof(struct btrfs_chunk, stripe);
+	offset += nr * sizeof(struct btrfs_stripe);
+	return (struct btrfs_stripe *)offset;
+}
+
+static inline char *btrfs_stripe_dev_uuid_nr(struct btrfs_chunk *c, int nr)
+{
+	return btrfs_stripe_dev_uuid(btrfs_stripe_nr(c, nr));
+}
+
+static inline u64 btrfs_stripe_offset_nr(struct extent_buffer *eb,
+					 struct btrfs_chunk *c, int nr)
+{
+	return btrfs_stripe_offset(eb, btrfs_stripe_nr(c, nr));
+}
+
+static inline void btrfs_set_stripe_offset_nr(struct extent_buffer *eb,
+					     struct btrfs_chunk *c, int nr,
+					     u64 val)
+{
+	btrfs_set_stripe_offset(eb, btrfs_stripe_nr(c, nr), val);
+}
+
+static inline u64 btrfs_stripe_devid_nr(struct extent_buffer *eb,
+					 struct btrfs_chunk *c, int nr)
+{
+	return btrfs_stripe_devid(eb, btrfs_stripe_nr(c, nr));
+}
+
+static inline void btrfs_set_stripe_devid_nr(struct extent_buffer *eb,
+					     struct btrfs_chunk *c, int nr,
+					     u64 val)
+{
+	btrfs_set_stripe_devid(eb, btrfs_stripe_nr(c, nr), val);
+}
+
+/* struct btrfs_block_group_item */
+BTRFS_SETGET_STACK_FUNCS(block_group_used, struct btrfs_block_group_item,
+			 used, 64);
+BTRFS_SETGET_FUNCS(disk_block_group_used, struct btrfs_block_group_item,
+			 used, 64);
+BTRFS_SETGET_STACK_FUNCS(block_group_chunk_objectid,
+			struct btrfs_block_group_item, chunk_objectid, 64);
+
+BTRFS_SETGET_FUNCS(disk_block_group_chunk_objectid,
+		   struct btrfs_block_group_item, chunk_objectid, 64);
+BTRFS_SETGET_FUNCS(disk_block_group_flags,
+		   struct btrfs_block_group_item, flags, 64);
+BTRFS_SETGET_STACK_FUNCS(block_group_flags,
+			struct btrfs_block_group_item, flags, 64);
+
+/* struct btrfs_inode_ref */
+BTRFS_SETGET_FUNCS(inode_ref_name_len, struct btrfs_inode_ref, name_len, 16);
+BTRFS_SETGET_FUNCS(inode_ref_index, struct btrfs_inode_ref, index, 64);
+
+/* struct btrfs_inode_item */
+BTRFS_SETGET_FUNCS(inode_generation, struct btrfs_inode_item, generation, 64);
+BTRFS_SETGET_FUNCS(inode_sequence, struct btrfs_inode_item, sequence, 64);
+BTRFS_SETGET_FUNCS(inode_transid, struct btrfs_inode_item, transid, 64);
+BTRFS_SETGET_FUNCS(inode_size, struct btrfs_inode_item, size, 64);
+BTRFS_SETGET_FUNCS(inode_nbytes, struct btrfs_inode_item, nbytes, 64);
+BTRFS_SETGET_FUNCS(inode_block_group, struct btrfs_inode_item, block_group, 64);
+BTRFS_SETGET_FUNCS(inode_nlink, struct btrfs_inode_item, nlink, 32);
+BTRFS_SETGET_FUNCS(inode_uid, struct btrfs_inode_item, uid, 32);
+BTRFS_SETGET_FUNCS(inode_gid, struct btrfs_inode_item, gid, 32);
+BTRFS_SETGET_FUNCS(inode_mode, struct btrfs_inode_item, mode, 32);
+BTRFS_SETGET_FUNCS(inode_rdev, struct btrfs_inode_item, rdev, 64);
+BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
+
+BTRFS_SETGET_STACK_FUNCS(stack_inode_generation,
+			 struct btrfs_inode_item, generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence,
+			 struct btrfs_inode_item, generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_size,
+			 struct btrfs_inode_item, size, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_nbytes,
+			 struct btrfs_inode_item, nbytes, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_block_group,
+			 struct btrfs_inode_item, block_group, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_nlink,
+			 struct btrfs_inode_item, nlink, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_uid,
+			 struct btrfs_inode_item, uid, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_gid,
+			 struct btrfs_inode_item, gid, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_mode,
+			 struct btrfs_inode_item, mode, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_rdev,
+			 struct btrfs_inode_item, rdev, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_flags,
+			 struct btrfs_inode_item, flags, 64);
+
+BTRFS_SETGET_FUNCS(timespec_sec, struct btrfs_timespec, sec, 64);
+BTRFS_SETGET_FUNCS(timespec_nsec, struct btrfs_timespec, nsec, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_timespec_sec, struct btrfs_timespec,
+			 sec, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_timespec_nsec, struct btrfs_timespec,
+			 nsec, 32);
+
+/* struct btrfs_dev_extent */
+BTRFS_SETGET_FUNCS(dev_extent_chunk_tree, struct btrfs_dev_extent,
+		   chunk_tree, 64);
+BTRFS_SETGET_FUNCS(dev_extent_chunk_objectid, struct btrfs_dev_extent,
+		   chunk_objectid, 64);
+BTRFS_SETGET_FUNCS(dev_extent_chunk_offset, struct btrfs_dev_extent,
+		   chunk_offset, 64);
+BTRFS_SETGET_FUNCS(dev_extent_length, struct btrfs_dev_extent, length, 64);
+
+static inline u8 *btrfs_dev_extent_chunk_tree_uuid(struct btrfs_dev_extent *dev)
+{
+	unsigned long ptr = offsetof(struct btrfs_dev_extent, chunk_tree_uuid);
+	return (u8 *)((unsigned long)dev + ptr);
+}
+
+/* struct btrfs_extent_ref */
+BTRFS_SETGET_FUNCS(ref_root, struct btrfs_extent_ref, root, 64);
+BTRFS_SETGET_FUNCS(ref_generation, struct btrfs_extent_ref, generation, 64);
+BTRFS_SETGET_FUNCS(ref_objectid, struct btrfs_extent_ref, objectid, 64);
+BTRFS_SETGET_FUNCS(ref_num_refs, struct btrfs_extent_ref, num_refs, 32);
+
+BTRFS_SETGET_STACK_FUNCS(stack_ref_root, struct btrfs_extent_ref, root, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_ref_generation, struct btrfs_extent_ref,
+			 generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_ref_objectid, struct btrfs_extent_ref,
+			 objectid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_ref_num_refs, struct btrfs_extent_ref,
+			 num_refs, 32);
+
+/* struct btrfs_extent_item */
+BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_extent_refs, struct btrfs_extent_item,
+			 refs, 32);
+
+/* struct btrfs_node */
+BTRFS_SETGET_FUNCS(key_blockptr, struct btrfs_key_ptr, blockptr, 64);
+BTRFS_SETGET_FUNCS(key_generation, struct btrfs_key_ptr, generation, 64);
+
+static inline u64 btrfs_node_blockptr(struct extent_buffer *eb, int nr)
+{
+	unsigned long ptr;
+	ptr = offsetof(struct btrfs_node, ptrs) +
+		sizeof(struct btrfs_key_ptr) * nr;
+	return btrfs_key_blockptr(eb, (struct btrfs_key_ptr *)ptr);
+}
+
+static inline void btrfs_set_node_blockptr(struct extent_buffer *eb,
+					   int nr, u64 val)
+{
+	unsigned long ptr;
+	ptr = offsetof(struct btrfs_node, ptrs) +
+		sizeof(struct btrfs_key_ptr) * nr;
+	btrfs_set_key_blockptr(eb, (struct btrfs_key_ptr *)ptr, val);
+}
+
+static inline u64 btrfs_node_ptr_generation(struct extent_buffer *eb, int nr)
+{
+	unsigned long ptr;
+	ptr = offsetof(struct btrfs_node, ptrs) +
+		sizeof(struct btrfs_key_ptr) * nr;
+	return btrfs_key_generation(eb, (struct btrfs_key_ptr *)ptr);
+}
+
+static inline void btrfs_set_node_ptr_generation(struct extent_buffer *eb,
+						 int nr, u64 val)
+{
+	unsigned long ptr;
+	ptr = offsetof(struct btrfs_node, ptrs) +
+		sizeof(struct btrfs_key_ptr) * nr;
+	btrfs_set_key_generation(eb, (struct btrfs_key_ptr *)ptr, val);
+}
+
+static inline unsigned long btrfs_node_key_ptr_offset(int nr)
+{
+	return offsetof(struct btrfs_node, ptrs) +
+		sizeof(struct btrfs_key_ptr) * nr;
+}
+
+static inline void btrfs_node_key(struct extent_buffer *eb,
+				  struct btrfs_disk_key *disk_key, int nr)
+{
+	unsigned long ptr;
+	ptr = btrfs_node_key_ptr_offset(nr);
+	read_eb_member(eb, (struct btrfs_key_ptr *)ptr,
+		       struct btrfs_key_ptr, key, disk_key);
+}
+
+/* struct btrfs_item */
+BTRFS_SETGET_FUNCS(item_offset, struct btrfs_item, offset, 32);
+BTRFS_SETGET_FUNCS(item_size, struct btrfs_item, size, 32);
+
+static inline unsigned long btrfs_item_nr_offset(int nr)
+{
+	return offsetof(struct btrfs_leaf, items) +
+		sizeof(struct btrfs_item) * nr;
+}
+
+static inline struct btrfs_item *btrfs_item_nr(struct extent_buffer *eb,
+					       int nr)
+{
+	return (struct btrfs_item *)btrfs_item_nr_offset(nr);
+}
+
+static inline u32 btrfs_item_end(struct extent_buffer *eb,
+				 struct btrfs_item *item)
+{
+	return btrfs_item_offset(eb, item) + btrfs_item_size(eb, item);
+}
+
+static inline u32 btrfs_item_end_nr(struct extent_buffer *eb, int nr)
+{
+	return btrfs_item_end(eb, btrfs_item_nr(eb, nr));
+}
+
+static inline u32 btrfs_item_offset_nr(struct extent_buffer *eb, int nr)
+{
+	return btrfs_item_offset(eb, btrfs_item_nr(eb, nr));
+}
+
+static inline u32 btrfs_item_size_nr(struct extent_buffer *eb, int nr)
+{
+	return btrfs_item_size(eb, btrfs_item_nr(eb, nr));
+}
+
+static inline void btrfs_item_key(struct extent_buffer *eb,
+			   struct btrfs_disk_key *disk_key, int nr)
+{
+	struct btrfs_item *item = btrfs_item_nr(eb, nr);
+	read_eb_member(eb, item, struct btrfs_item, key, disk_key);
+}
+
+/*
+ * struct btrfs_root_ref
+ */
+BTRFS_SETGET_FUNCS(root_ref_dirid, struct btrfs_root_ref, dirid, 64);
+BTRFS_SETGET_FUNCS(root_ref_sequence, struct btrfs_root_ref, sequence, 64);
+BTRFS_SETGET_FUNCS(root_ref_name_len, struct btrfs_root_ref, name_len, 16);
+
+/* struct btrfs_dir_item */
+BTRFS_SETGET_FUNCS(dir_data_len, struct btrfs_dir_item, data_len, 16);
+BTRFS_SETGET_FUNCS(dir_type, struct btrfs_dir_item, type, 8);
+BTRFS_SETGET_FUNCS(dir_name_len, struct btrfs_dir_item, name_len, 16);
+BTRFS_SETGET_FUNCS(dir_transid, struct btrfs_dir_item, transid, 64);
+
+static inline void btrfs_dir_item_key(struct extent_buffer *eb,
+				      struct btrfs_dir_item *item,
+				      struct btrfs_disk_key *key)
+{
+	read_eb_member(eb, item, struct btrfs_dir_item, location, key);
+}
+
+/* struct btrfs_disk_key */
+BTRFS_SETGET_STACK_FUNCS(disk_key_objectid, struct btrfs_disk_key,
+			 objectid, 64);
+BTRFS_SETGET_STACK_FUNCS(disk_key_offset, struct btrfs_disk_key, offset, 64);
+BTRFS_SETGET_STACK_FUNCS(disk_key_type, struct btrfs_disk_key, type, 8);
+
+static inline void btrfs_disk_key_to_cpu(struct btrfs_key *cpu,
+					 struct btrfs_disk_key *disk)
+{
+	cpu->offset = le64_to_cpu(disk->offset);
+	cpu->type = disk->type;
+	cpu->objectid = le64_to_cpu(disk->objectid);
+}
+
+static inline void btrfs_cpu_key_to_disk(struct btrfs_disk_key *disk,
+					 struct btrfs_key *cpu)
+{
+	disk->offset = cpu_to_le64(cpu->offset);
+	disk->type = cpu->type;
+	disk->objectid = cpu_to_le64(cpu->objectid);
+}
+
+static inline void btrfs_node_key_to_cpu(struct extent_buffer *eb,
+				  struct btrfs_key *key, int nr)
+{
+	struct btrfs_disk_key disk_key;
+	btrfs_node_key(eb, &disk_key, nr);
+	btrfs_disk_key_to_cpu(key, &disk_key);
+}
+
+static inline void btrfs_item_key_to_cpu(struct extent_buffer *eb,
+				  struct btrfs_key *key, int nr)
+{
+	struct btrfs_disk_key disk_key;
+	btrfs_item_key(eb, &disk_key, nr);
+	btrfs_disk_key_to_cpu(key, &disk_key);
+}
+
+static inline void btrfs_dir_item_key_to_cpu(struct extent_buffer *eb,
+				      struct btrfs_dir_item *item,
+				      struct btrfs_key *key)
+{
+	struct btrfs_disk_key disk_key;
+	btrfs_dir_item_key(eb, item, &disk_key);
+	btrfs_disk_key_to_cpu(key, &disk_key);
+}
+
+static inline u8 btrfs_key_type(struct btrfs_key *key)
+{
+	return key->type;
+}
+
+static inline void btrfs_set_key_type(struct btrfs_key *key, u8 val)
+{
+	key->type = val;
+}
+
+/* struct btrfs_header */
+BTRFS_SETGET_HEADER_FUNCS(header_bytenr, struct btrfs_header, bytenr, 64);
+BTRFS_SETGET_HEADER_FUNCS(header_generation, struct btrfs_header,
+			  generation, 64);
+BTRFS_SETGET_HEADER_FUNCS(header_owner, struct btrfs_header, owner, 64);
+BTRFS_SETGET_HEADER_FUNCS(header_nritems, struct btrfs_header, nritems, 32);
+BTRFS_SETGET_HEADER_FUNCS(header_flags, struct btrfs_header, flags, 64);
+BTRFS_SETGET_HEADER_FUNCS(header_level, struct btrfs_header, level, 8);
+
+/* struct btrfs_root_item */
+BTRFS_SETGET_FUNCS(disk_root_generation, struct btrfs_root_item,
+		   generation, 64);
+BTRFS_SETGET_FUNCS(disk_root_refs, struct btrfs_root_item, refs, 32);
+BTRFS_SETGET_FUNCS(disk_root_bytenr, struct btrfs_root_item, bytenr, 64);
+BTRFS_SETGET_FUNCS(disk_root_level, struct btrfs_root_item, level, 8);
+
+BTRFS_SETGET_STACK_FUNCS(root_generation, struct btrfs_root_item,
+			 generation, 64);
+BTRFS_SETGET_STACK_FUNCS(root_bytenr, struct btrfs_root_item, bytenr, 64);
+BTRFS_SETGET_STACK_FUNCS(root_level, struct btrfs_root_item, level, 8);
+BTRFS_SETGET_STACK_FUNCS(root_dirid, struct btrfs_root_item, root_dirid, 64);
+BTRFS_SETGET_STACK_FUNCS(root_refs, struct btrfs_root_item, refs, 32);
+BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 64);
+BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
+BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
+BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
+			 last_snapshot, 64);
+
+/* struct btrfs_super_block */
+
+BTRFS_SETGET_STACK_FUNCS(super_bytenr, struct btrfs_super_block, bytenr, 64);
+BTRFS_SETGET_STACK_FUNCS(super_flags, struct btrfs_super_block, flags, 64);
+BTRFS_SETGET_STACK_FUNCS(super_generation, struct btrfs_super_block,
+			 generation, 64);
+BTRFS_SETGET_STACK_FUNCS(super_root, struct btrfs_super_block, root, 64);
+BTRFS_SETGET_STACK_FUNCS(super_sys_array_size,
+			 struct btrfs_super_block, sys_chunk_array_size, 32);
+BTRFS_SETGET_STACK_FUNCS(super_chunk_root_generation,
+			 struct btrfs_super_block, chunk_root_generation, 64);
+BTRFS_SETGET_STACK_FUNCS(super_root_level, struct btrfs_super_block,
+			 root_level, 8);
+BTRFS_SETGET_STACK_FUNCS(super_chunk_root, struct btrfs_super_block,
+			 chunk_root, 64);
+BTRFS_SETGET_STACK_FUNCS(super_chunk_root_level, struct btrfs_super_block,
+			 chunk_root_level, 8);
+BTRFS_SETGET_STACK_FUNCS(super_log_root, struct btrfs_super_block,
+			 log_root, 64);
+BTRFS_SETGET_STACK_FUNCS(super_log_root_transid, struct btrfs_super_block,
+			 log_root_transid, 64);
+BTRFS_SETGET_STACK_FUNCS(super_log_root_level, struct btrfs_super_block,
+			 log_root_level, 8);
+BTRFS_SETGET_STACK_FUNCS(super_total_bytes, struct btrfs_super_block,
+			 total_bytes, 64);
+BTRFS_SETGET_STACK_FUNCS(super_bytes_used, struct btrfs_super_block,
+			 bytes_used, 64);
+BTRFS_SETGET_STACK_FUNCS(super_sectorsize, struct btrfs_super_block,
+			 sectorsize, 32);
+BTRFS_SETGET_STACK_FUNCS(super_nodesize, struct btrfs_super_block,
+			 nodesize, 32);
+BTRFS_SETGET_STACK_FUNCS(super_leafsize, struct btrfs_super_block,
+			 leafsize, 32);
+BTRFS_SETGET_STACK_FUNCS(super_stripesize, struct btrfs_super_block,
+			 stripesize, 32);
+BTRFS_SETGET_STACK_FUNCS(super_root_dir, struct btrfs_super_block,
+			 root_dir_objectid, 64);
+BTRFS_SETGET_STACK_FUNCS(super_num_devices, struct btrfs_super_block,
+			 num_devices, 64);
+BTRFS_SETGET_STACK_FUNCS(super_compat_flags, struct btrfs_super_block,
+			 compat_flags, 64);
+BTRFS_SETGET_STACK_FUNCS(super_compat_ro_flags, struct btrfs_super_block,
+			 compat_flags, 64);
+BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,
+			 incompat_flags, 64);
+BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
+			 csum_type, 16);
+
+static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
+{
+	int t = btrfs_super_csum_type(s);
+	//BUG_ON(t >= ARRAY_SIZE(btrfs_csum_sizes));
+	return btrfs_csum_sizes[t];
+}
+
+static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
+{
+	return offsetof(struct btrfs_leaf, items);
+}
+
+/* struct btrfs_file_extent_item */
+BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
+
+static inline unsigned long btrfs_file_extent_inline_start(struct
+						   btrfs_file_extent_item *e)
+{
+	unsigned long offset = (unsigned long)e;
+	offset += offsetof(struct btrfs_file_extent_item, disk_bytenr);
+	return offset;
+}
+
+static inline u32 btrfs_file_extent_calc_inline_size(u32 datasize)
+{
+	return offsetof(struct btrfs_file_extent_item, disk_bytenr) + datasize;
+}
+
+BTRFS_SETGET_FUNCS(file_extent_disk_bytenr, struct btrfs_file_extent_item,
+		   disk_bytenr, 64);
+BTRFS_SETGET_FUNCS(file_extent_generation, struct btrfs_file_extent_item,
+		   generation, 64);
+BTRFS_SETGET_FUNCS(file_extent_disk_num_bytes, struct btrfs_file_extent_item,
+		   disk_num_bytes, 64);
+BTRFS_SETGET_FUNCS(file_extent_offset, struct btrfs_file_extent_item,
+		  offset, 64);
+BTRFS_SETGET_FUNCS(file_extent_num_bytes, struct btrfs_file_extent_item,
+		   num_bytes, 64);
+BTRFS_SETGET_FUNCS(file_extent_ram_bytes, struct btrfs_file_extent_item,
+		   ram_bytes, 64);
+BTRFS_SETGET_FUNCS(file_extent_compression, struct btrfs_file_extent_item,
+		   compression, 8);
+BTRFS_SETGET_FUNCS(file_extent_encryption, struct btrfs_file_extent_item,
+		   encryption, 8);
+BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
+		   other_encoding, 16);
+
+/* this returns the number of file bytes represented by the inline item.
+ * If an item is compressed, this is the uncompressed size
+ */
+static inline u32 btrfs_file_extent_inline_len(struct extent_buffer *eb,
+					struct btrfs_file_extent_item *e)
+{
+       return btrfs_file_extent_ram_bytes(eb, e);
+}
+
+/*
+ * this returns the number of bytes used by the item on disk, minus the
+ * size of any extent headers.  If a file is compressed on disk, this is
+ * the compressed size
+ */
+static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
+						    struct btrfs_item *e)
+{
+       unsigned long offset;
+       offset = offsetof(struct btrfs_file_extent_item, disk_bytenr);
+       return btrfs_item_size(eb, e) - offset;
+}
+
+static inline u32 btrfs_level_size(struct btrfs_root *root, int level) {
+	if (level == 0)
+		return root->leafsize;
+	return root->nodesize;
+}
+
+static inline u32 btrfs_root_level_size(struct btrfs_super_block *sb) {
+	return btrfs_super_root_level(sb) == 0 ?
+		btrfs_super_leafsize(sb) :
+		btrfs_super_nodesize(sb);
+}
+
+static inline u32 btrfs_chunk_root_level_size(struct btrfs_super_block *sb) {
+	return btrfs_super_chunk_root_level(sb) == 0 ?
+		btrfs_super_leafsize(sb) :
+		btrfs_super_nodesize(sb);
+}
+
+/* helper function to cast into the data area of the leaf. */
+#define btrfs_item_ptr(leaf, slot, type) \
+	((type *)(btrfs_leaf_data(leaf) + \
+	btrfs_item_offset_nr(leaf, slot)))
+
+#define btrfs_item_ptr_offset(leaf, slot) \
+	((unsigned long)(btrfs_leaf_data(leaf) + \
+	btrfs_item_offset_nr(leaf, slot)))
+
+/*volumes.h */
+
+struct btrfs_fs_devices {
+	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
+
+	/* the device with this id has the most recent coyp of the super */
+	u64 latest_devid;
+	u64 latest_trans;
+	u64 lowest_devid;
+	int latest_bdev;
+	int lowest_bdev;
+	int seeding;
+	struct btrfs_fs_devices *seed;
+};
+
+struct btrfs_bio_stripe {
+	u64 physical;
+};
+
+#define MAX_NRSTRIPES 8
+struct btrfs_multi_bio {
+	int error;
+	int num_stripes;
+	struct btrfs_bio_stripe stripes[MAX_NRSTRIPES];
+};
+
+#define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
+			    (sizeof(struct btrfs_bio_stripe) * (n)))
+
+static int aux_tree_lookup(struct btrfs_root *root,
+			   struct btrfs_key *key,
+			   struct btrfs_path *path);
+
+struct cache_extent {
+	u64 start;
+	u64 size;
+};
+
+struct map_lookup {
+	struct cache_extent ce;
+	u64 type;
+	int io_align;
+	int io_width;
+	int stripe_len;
+	int sector_size;
+	int num_stripes;
+	int sub_stripes;
+        struct btrfs_bio_stripe stripes[MAX_NRSTRIPES];
+};
+
+/* "VFS" things */
+
+/* file types recognized by grub */
+typedef enum {
+	BTRFS_REGULAR_FILE,
+	BTRFS_DIRECTORY_FILE,
+	BTRFS_SYMLINK_FILE,
+	BTRFS_UNKNOWN_FILE
+} btrfs_file_type;
+
+static inline int coord_is_root(struct btrfs_root *root,
+				struct btrfs_path *path)
+{
+	return btrfs_header_bytenr(&path->nodes[0]) ==
+		btrfs_header_bytenr(&root->node);
+}
+
+static inline btrfs_file_type btrfs_get_file_type (int mode)
+{
+	if (S_ISLNK(mode))
+		return BTRFS_SYMLINK_FILE;
+	if (S_ISREG(mode))
+		return BTRFS_REGULAR_FILE;
+	if (S_ISDIR(mode))
+		return BTRFS_DIRECTORY_FILE;
+	return BTRFS_UNKNOWN_FILE;
+}
+
+#define min_t(type,x,y)							\
+	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
+#define max_t(type,x,y)							\
+	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
+
+
+int sys_array_lookup(struct map_lookup *map, u64 logical);
+int tree_chunk_lookup(struct map_lookup *map,
+		      u64 logical);
+int __btrfs_map_block(u64 logical, u64 *length,
+		      struct btrfs_multi_bio *multi_ret, int mirror_num);
+int read_tree_block(struct btrfs_root *root,
+		    struct extent_buffer *eb,
+		    u64 bytenr, /* logical */
+		    u32 blocksize,
+		    u64 parent_transid,
+		    lookup_pool_id lpid);
+int check_read_chunk(struct btrfs_key *key,
+		     struct extent_buffer *leaf,
+		     struct btrfs_chunk *chunk,
+		     struct map_lookup *map,
+		     u64 logical);
+/*
+  Local variables:
+  c-indentation-style: "K&R"
+  mode-name: "LC"
+  c-basic-offset: 8
+  tab-width: 8
+  fill-column: 80
+  scroll-step: 1
+  End:
+*/
--- grub-0.97.orig/stage2/builtins.c
+++ grub-0.97/stage2/builtins.c
@@ -4170,6 +4170,7 @@ setup_func (char *arg, int flags)
     {"jfs",      "/jfs_stage1_5"},
     {"minix",    "/minix_stage1_5"},
     {"reiserfs", "/reiserfs_stage1_5"},
+    {"btrfs",    "/btrfs_stage1_5"},
     {"vstafs",   "/vstafs_stage1_5"},
     {"xfs",      "/xfs_stage1_5"}
   };
--- grub-0.97.orig/stage2/disk_io.c
+++ grub-0.97/stage2/disk_io.c
@@ -64,6 +64,9 @@ struct fsys_entry fsys_table[NUM_FSYS + 
 # ifdef FSYS_REISERFS
   {"reiserfs", reiserfs_mount, reiserfs_read, reiserfs_dir, 0, reiserfs_embed},
 # endif
+# ifdef FSYS_BTRFS
+  {"btrfs", btrfs_mount, btrfs_read, btrfs_dir, 0, 0},
+# endif
 # ifdef FSYS_VSTAFS
   {"vstafs", vstafs_mount, vstafs_read, vstafs_dir, 0, 0},
 # endif
--- grub-0.97.orig/stage2/filesys.h
+++ grub-0.97/stage2/filesys.h
@@ -77,6 +77,16 @@ int reiserfs_embed (int *start_sector, i
 #define FSYS_REISERFS_NUM 0
 #endif
 
+#ifdef FSYS_BTRFS
+#define FSYS_BTRFS_NUM 1
+int btrfs_mount (void);
+int btrfs_read (char *buf, int len);
+int btrfs_dir (char *dirname);
+int btrfs_embed (int *start_sector, int needed_sectors);
+#else
+#define FSYS_BTRFS_NUM 0
+#endif
+
 #ifdef FSYS_VSTAFS
 #define FSYS_VSTAFS_NUM 1
 int vstafs_mount (void);
--- /dev/null
+++ grub-0.97/stage2/fsys_btrfs.c
@@ -0,0 +1,1402 @@
+/* fsys_btrfs.c - an implementation for the Btrfs filesystem
+ *
+ * Copyright 2009 Red Hat, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifdef FSYS_BTRFS
+
+#include "shared.h"
+#include "filesys.h"
+#include "btrfs.h"
+
+#define BTRFS_VERBOSE 0
+
+/* Cache layouts */
+
+#define LOOKUP_CACHE_BUF_SIZE   (4096)
+#define LOOKUP_CACHE_SIZE       (LOOKUP_CACHE_BUF_SIZE * LAST_LOOKUP_POOL)
+#define BTRFS_FS_INFO							\
+	((struct btrfs_fs_info *)((unsigned long)FSYS_BUF +		\
+				  LOOKUP_CACHE_SIZE))
+#define BTRFS_CACHE_SIZE        (sizeof(struct btrfs_fs_info) +	\
+				 LOOKUP_CACHE_SIZE)
+#define BTRFS_FILE_INFO         (&BTRFS_FS_INFO->file_info)
+#define BTRFS_TREE_ROOT         (&BTRFS_FS_INFO->tree_root)
+#define BTRFS_CHUNK_ROOT        (&BTRFS_FS_INFO->chunk_root)
+#define BTRFS_FS_ROOT           (&BTRFS_FS_INFO->fs_root)
+#define BTRFS_SUPER             (&BTRFS_FS_INFO->super_copy)
+#define LOOKUP_CACHE_BUF(id)	((char *)((unsigned long)FSYS_BUF +	\
+					  id * LOOKUP_CACHE_BUF_SIZE))
+
+#define noop   do {; } while (0)
+
+#if BTRFS_VERBOSE
+#define btrfs_msg(format, ...) printf(format , ## __VA_ARGS__)
+#else
+#define btrfs_msg(format, args...) noop
+#endif
+
+/* compile-time check to make sure we don't overlap
+   filesystem buffer */
+static inline void check_btrfs_cache_size(void)
+{
+	cassert(BTRFS_CACHE_SIZE <= FSYS_BUFLEN);
+}
+
+static inline u64 btrfs_sb_offset(int mirror)
+{
+	u64 start = 16 * 1024;
+	if (mirror)
+		return start << (BTRFS_SUPER_MIRROR_SHIFT * mirror);
+	return BTRFS_SUPER_INFO_OFFSET;
+}
+
+static inline char *grab_lookup_cache(lookup_pool_id lpid)
+{
+	char *buf = LOOKUP_CACHE_BUF(lpid);
+	memset(buf, 0, LOOKUP_CACHE_BUF_SIZE);
+	return buf;
+}
+
+static inline struct btrfs_path *btrfs_grab_path(lookup_pool_id lpid)
+{
+	return &BTRFS_FS_INFO->paths[lpid];
+}
+
+static inline void btrfs_update_file_info(struct btrfs_path *path)
+{
+	btrfs_item_key_to_cpu(&path->nodes[0],
+			      BTRFS_FILE_INFO,
+			      path->slots[0]);
+}
+
+static inline void btrfs_set_root_dir_key(struct btrfs_key *key)
+{
+	key->objectid = BTRFS_FIRST_FREE_OBJECTID;
+	btrfs_set_key_type(key, BTRFS_INODE_ITEM_KEY);
+	key->offset = 0;
+}
+
+static inline void copy_extent_buffer(struct extent_buffer *dst,
+				      struct extent_buffer *src)
+{
+	char *data = dst->data;
+	memcpy(dst, src, sizeof(*dst));
+	memcpy(data, src->data, 4096);
+	dst->data = data;
+}
+
+static inline void move_extent_buffer(struct extent_buffer *dst,
+				      struct extent_buffer *src)
+{
+	memcpy(dst, src, sizeof(*dst));
+}
+
+static inline void init_btrfs_root (struct btrfs_root *root)
+{
+	root->node.data = root->data;
+}
+
+static inline void init_btrfs_path(lookup_pool_id lpid)
+{
+	struct btrfs_path *path;
+	path = btrfs_grab_path(lpid);
+	path->lpid = lpid;
+}
+
+static inline void init_btrfs_info(void)
+{
+	int i;
+	struct btrfs_fs_info *fs = BTRFS_FS_INFO;
+
+	memset(fs, 0, sizeof (*fs));
+	for(i = 0; i < LAST_LOOKUP_POOL; i++)
+		init_btrfs_path(i);
+	init_btrfs_root(&fs->tree_root);
+	init_btrfs_root(&fs->chunk_root);
+	init_btrfs_root(&fs->fs_root);
+}
+
+static void setup_root(struct btrfs_root *root,
+		       u32 nodesize,
+		       u32 leafsize,
+		       u32 sectorsize,
+		       u32 stripesize,
+		       u64 objectid)
+{
+	root->fs_info = BTRFS_FS_INFO;
+	root->nodesize = nodesize;
+	root->leafsize = leafsize;
+	root->sectorsize = sectorsize;
+	root->stripesize = stripesize;
+	root->objectid = objectid;
+}
+
+/*
+ * Pick up the latest root of a
+ * tree with specified @objectid
+ */
+static int btrfs_find_last_root(struct btrfs_root *tree_root,
+				u64 objectid,
+				struct btrfs_root_item *item,
+				struct btrfs_key *key,
+				lookup_pool_id lpid)
+{
+	int ret;
+	int slot;
+	struct btrfs_key search_key;
+	struct btrfs_key found_key;
+	struct btrfs_path *path;
+
+	search_key.objectid = objectid;
+	search_key.type = BTRFS_ROOT_ITEM_KEY;
+	search_key.offset = (u64)-1;
+	path = btrfs_grab_path(lpid);
+
+	ret = aux_tree_lookup(tree_root, &search_key, path);
+	if (ret < 0)
+		return 1;
+	slot = path->slots[0];
+	WARN_ON(slot == 0);
+	slot -= 1;
+	btrfs_item_key_to_cpu(&path->nodes[0], &found_key, slot);
+	if (found_key.objectid != objectid)
+		return 1;
+	read_extent_buffer(&path->nodes[0], item,
+			   btrfs_item_ptr_offset(&path->nodes[0], slot),
+			   sizeof(*item));
+	memcpy(key, &found_key, sizeof(found_key));
+	return 0;
+}
+
+static int find_setup_root(struct btrfs_root *tree_root,
+			   u32 nodesize,
+			   u32 leafsize,
+			   u32 sectorsize,
+			   u32 stripesize,
+			   u64 objectid,
+			   struct btrfs_root *dest_root,
+			   u64 bytenr,
+			   u32 blocksize,
+			   u64 generation,
+			   lookup_pool_id lpid)
+{
+	int ret;
+	struct extent_buffer eb;
+
+	setup_root(dest_root,
+		   nodesize,
+		   leafsize,
+		   sectorsize,
+		   stripesize,
+		   objectid);
+	if (tree_root) {
+		/*
+		 * pick up the latest version
+		 * of the root we want to set up
+		 */
+		ret = btrfs_find_last_root(tree_root, objectid,
+					   &dest_root->root_item,
+					   &dest_root->root_key,
+					   lpid);
+		if (ret)
+			return ret;
+		bytenr = btrfs_root_bytenr(&dest_root->root_item);
+		blocksize = btrfs_level_size(dest_root,
+				       btrfs_root_level(&dest_root->root_item));
+		generation = btrfs_root_generation(&tree_root->root_item);
+	}
+	ret = read_tree_block(dest_root,
+			      &eb,
+			      bytenr,
+			      blocksize,
+			      generation,
+			      lpid);
+	if (!ret)
+		return 1;
+	copy_extent_buffer(&dest_root->node, &eb);
+	return 0;
+}
+
+static inline int btrfs_strncmp(const char *cs, const char *ct, int count)
+{
+	signed char __res = 0;
+
+	while (count) {
+		if ((__res = *cs - *ct++) != 0 || !*cs++)
+			break;
+		count--;
+	}
+	return __res;
+}
+
+static int btrfs_check_super_block(struct btrfs_super_block *sb)
+{
+	if (sb->num_devices != BTRFS_DEFAULT_NUM_DEVICES) {
+		btrfs_msg("Btrfs multi-device configuration unsupported\n");
+		goto error;
+	}
+	if (sb->nodesize != BTRFS_DEFAULT_NODE_SIZE) {
+		btrfs_msg("Btrfs node size (%d) != %d unsupported\n",
+			  sb->nodesize, BTRFS_DEFAULT_NODE_SIZE);
+		goto error;
+	}
+	if (sb->leafsize != BTRFS_DEFAULT_LEAF_SIZE) {
+ 	        btrfs_msg("Btrfs leaf size (%d) != %d unsupported\n",
+			  sb->leafsize, BTRFS_DEFAULT_LEAF_SIZE);
+		goto error;
+	}
+	return 1;
+ error:
+	errnum = ERR_FSYS_MOUNT;
+	return 0;
+}
+
+int btrfs_mount(void)
+{
+	int i;
+	int ret;
+	u64 transid = 0;
+	u64 bytenr;
+
+	struct btrfs_fs_info *fs = BTRFS_FS_INFO;
+	struct btrfs_super_block *sb_tmp; /* current */
+	struct btrfs_super_block *sb;     /* latest */
+
+	struct btrfs_root *tree_root = &fs->tree_root;
+	struct btrfs_root *chunk_root = &fs->chunk_root;
+	struct btrfs_root *fs_root = &fs->fs_root;
+
+	check_btrfs_cache_size();
+	init_btrfs_info();
+
+	sb_tmp = &fs->super_temp;
+	sb = &fs->super_copy;
+
+	/* pick up the latest version of superblock */
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		bytenr = btrfs_sb_offset(i);
+		ret = devread(bytenr >> SECTOR_BITS,
+			      0,
+			      sizeof(*sb_tmp),
+			      (char *)sb_tmp);
+		if (!ret)
+		        continue;
+
+		if (btrfs_super_bytenr(sb_tmp) != bytenr ||
+		    btrfs_strncmp((char *)(&sb_tmp->magic),
+				  BTRFS_MAGIC,
+				  sizeof(sb_tmp->magic)))
+			continue;
+		if (btrfs_super_generation(sb_tmp) > transid) {
+			memcpy(sb, sb_tmp, sizeof(*sb_tmp));
+			transid = btrfs_super_generation(sb);
+		}
+	}
+	/* there might be errors when reading super mirrors */
+	if (errnum == ERR_OUTSIDE_PART)
+		errnum = ERR_NONE;
+	if (transid <= 0) {
+		btrfs_msg("No valid Btrfs superblock found\n");
+		return 0;
+	}
+	if (!btrfs_check_super_block(sb))
+		return 0;
+	/* setup chunk root */
+	ret = find_setup_root(NULL,
+			      btrfs_super_nodesize(sb),
+			      btrfs_super_leafsize(sb),
+			      btrfs_super_sectorsize(sb),
+			      btrfs_super_stripesize(sb),
+			      BTRFS_CHUNK_TREE_OBJECTID,
+			      chunk_root,
+			      btrfs_super_chunk_root(sb),
+			      btrfs_chunk_root_level_size(sb),
+			      btrfs_super_chunk_root_generation(sb),
+			      FIRST_EXTERNAL_LOOKUP_POOL);
+	if (ret)
+		return 0;
+	/* setup tree root */
+	ret = find_setup_root(NULL,
+			      btrfs_super_nodesize(sb),
+			      btrfs_super_leafsize(sb),
+			      btrfs_super_sectorsize(sb),
+			      btrfs_super_stripesize(sb),
+			      BTRFS_ROOT_TREE_OBJECTID,
+			      tree_root,
+			      btrfs_super_root(sb),
+			      btrfs_root_level_size(sb),
+			      btrfs_super_generation(sb),
+			      FIRST_EXTERNAL_LOOKUP_POOL);
+	if (ret)
+		return 0;
+	/* setup fs_root */
+	ret = find_setup_root(tree_root,
+			      btrfs_super_nodesize(sb),
+			      btrfs_super_leafsize(sb),
+			      btrfs_super_sectorsize(sb),
+			      btrfs_super_stripesize(sb),
+			      BTRFS_FS_TREE_OBJECTID,
+			      fs_root,
+			      0,
+			      0,
+			      0,
+			      FIRST_EXTERNAL_LOOKUP_POOL);
+	return !ret;
+}
+
+/*
+ * Check, whether @chunk is the map for a
+ * block with @logical block number.
+ * If yes, then fill the @map.
+ * Return 1 on affirmative result,
+ * otherwise return 0.
+ */
+int check_read_chunk(struct btrfs_key *key,
+			    struct extent_buffer *leaf,
+			    struct btrfs_chunk *chunk,
+			    struct map_lookup *map,
+			    u64 logical)
+{
+	int i;
+	u64 chunk_start;
+	u64 chunk_size;
+	int num_stripes;
+
+	chunk_start = key->offset;
+	chunk_size = btrfs_chunk_length(leaf, chunk);
+
+	if (logical + 1 > chunk_start + chunk_size ||
+	    logical < chunk_start)
+		/* not a fit */
+		return 0;
+	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	map->ce.start = chunk_start;
+	map->ce.size = chunk_size;
+	map->num_stripes = num_stripes;
+	map->io_width = btrfs_chunk_io_width(leaf, chunk);
+	map->io_align = btrfs_chunk_io_align(leaf, chunk);
+	map->sector_size = btrfs_chunk_sector_size(leaf, chunk);
+	map->stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
+	map->type = btrfs_chunk_type(leaf, chunk);
+	map->sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
+
+	for (i = 0; i < num_stripes; i++) {
+		map->stripes[i].physical =
+			btrfs_stripe_offset_nr(leaf, chunk, i);
+	}
+	return 1;
+}
+
+static void init_extent_buffer(struct extent_buffer *eb,
+			       u64 logical,
+			       u32 blocksize,
+			       u64 physical,
+			       lookup_pool_id lpid)
+{
+	eb->start = logical;
+	eb->len = blocksize;
+	eb->refs = 2;
+	eb->flags = 0;
+	eb->dev_bytenr = physical;
+	eb->data = grab_lookup_cache(lpid);
+}
+
+/*
+ * Search for a map by logical offset in sys array.
+ * Return -1 on errors;
+ * Return 1 if the map is found,
+ * Return 0 if the map is not found.
+ */
+int sys_array_lookup(struct map_lookup *map, u64 logical)
+{
+	struct extent_buffer sb;
+	struct btrfs_disk_key *disk_key;
+	struct btrfs_chunk *chunk;
+	struct btrfs_key key;
+	u32 num_stripes;
+	u32 array_size;
+	u32 len = 0;
+	u8 *ptr;
+	unsigned long sb_ptr;
+	u32 cur;
+	int ret;
+	int i = 0;
+
+	sb.data = (char *)BTRFS_SUPER;
+	array_size = btrfs_super_sys_array_size(BTRFS_SUPER);
+
+	ptr = BTRFS_SUPER->sys_chunk_array;
+	sb_ptr = offsetof(struct btrfs_super_block, sys_chunk_array);
+	cur = 0;
+
+	while (cur < array_size) {
+		disk_key = (struct btrfs_disk_key *)ptr;
+		btrfs_disk_key_to_cpu(&key, disk_key);
+
+		len = sizeof(*disk_key);
+		ptr += len;
+		sb_ptr += len;
+		cur += len;
+
+		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
+			chunk = (struct btrfs_chunk *)sb_ptr;
+			ret = check_read_chunk(&key, &sb,
+					       chunk, map, logical);
+			if (ret)
+				/* map is found */
+				return ret;
+			num_stripes = btrfs_chunk_num_stripes(&sb, chunk);
+			len = btrfs_chunk_item_size(num_stripes);
+		} else {
+			errnum = ERR_FSYS_CORRUPT;
+			return -1;
+		}
+		ptr += len;
+		sb_ptr += len;
+		cur += len;
+		i++;
+	}
+	return 0;
+}
+
+/*
+ * Search for a map by logical offset in the chunk tree.
+ * Return 1 if map is found, otherwise return 0.
+ */
+static int chunk_tree_lookup(struct map_lookup *map,
+			     u64 logical)
+{
+	int ret;
+	int slot;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_chunk *chunk;
+	struct btrfs_path *path;
+
+	path = btrfs_grab_path(INTERNAL_LOOKUP_POOL);
+
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.offset = logical;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+
+	ret = aux_tree_lookup(BTRFS_CHUNK_ROOT, &key, path);
+	if (ret < 0)
+		return 0;
+	leaf = &path->nodes[0];
+	slot = path->slots[0];
+	if (ret == 1) {
+		WARN_ON(slot == 0);
+		slot -= 1;
+	}
+	btrfs_item_key_to_cpu(leaf, &found_key, slot);
+	if (found_key.type != BTRFS_CHUNK_ITEM_KEY)
+		return 0;
+	chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
+	return check_read_chunk(&found_key, leaf,
+				chunk, map, logical);
+}
+
+/*
+ * Btrfs logical/physical block mapper.
+ * Look for an appropriate map-extent and
+ * perform a translation. Return 1 on errors.
+ */
+int __btrfs_map_block(u64 logical, u64 *length, struct btrfs_multi_bio *multi,
+		      int mirror_num)
+{
+	struct map_lookup map;
+	u64 offset;
+	u64 stripe_offset;
+	u64 stripe_nr;
+	struct cache_extent *ce;
+	int stripe_index;
+	int i;
+	int ret;
+
+	memset(&map, 0, sizeof(map));
+	ret = sys_array_lookup(&map, logical);
+	if (ret == -1) {
+		errnum = ERR_FSYS_CORRUPT;
+		return 1;
+	}
+	if (ret == 0) {
+		ret = chunk_tree_lookup(&map, logical);
+		if (!ret) {
+			/* something should be found! */
+			errnum = ERR_FSYS_CORRUPT;
+			return 1;
+		}
+	}
+	/* do translation */
+	ce = &map.ce;
+
+	offset = logical - ce->start;
+	stripe_nr = offset / map.stripe_len;
+	stripe_offset = stripe_nr * map.stripe_len;
+	WARN_ON(offset < stripe_offset);
+
+	stripe_offset = offset - stripe_offset;
+
+	if (map.type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
+			 BTRFS_BLOCK_GROUP_RAID10 |
+			 BTRFS_BLOCK_GROUP_DUP)) {
+		*length = min_t(u64, ce->size - offset,
+			      map.stripe_len - stripe_offset);
+	} else {
+		*length = ce->size - offset;
+	}
+	multi->num_stripes = 1;
+	stripe_index = 0;
+	if (map.type & BTRFS_BLOCK_GROUP_RAID1) {
+		if (mirror_num)
+			stripe_index = mirror_num - 1;
+		else
+			stripe_index = stripe_nr % map.num_stripes;
+	} else if (map.type & BTRFS_BLOCK_GROUP_RAID10) {
+		int factor = map.num_stripes / map.sub_stripes;
+
+		stripe_index = stripe_nr % factor;
+		stripe_index *= map.sub_stripes;
+
+		if (mirror_num)
+			stripe_index += mirror_num - 1;
+		else
+			stripe_index = stripe_nr % map.sub_stripes;
+
+		stripe_nr = stripe_nr / factor;
+	} else if (map.type & BTRFS_BLOCK_GROUP_DUP) {
+		if (mirror_num)
+			stripe_index = mirror_num - 1;
+	} else {
+		stripe_index = stripe_nr % map.num_stripes;
+		stripe_nr = stripe_nr / map.num_stripes;
+	}
+	WARN_ON(stripe_index >= map.num_stripes);
+
+	for (i = 0; i < multi->num_stripes; i++) {
+		multi->stripes[i].physical =
+			map.stripes[stripe_index].physical + stripe_offset +
+			stripe_nr * map.stripe_len;
+		stripe_index++;
+	}
+	return 0;
+}
+
+static u64 btrfs_map_block(u64 logical)
+{
+	int ret;
+	u64 length;
+	struct btrfs_multi_bio multi;
+
+	ret = __btrfs_map_block(logical, &length, &multi, 0);
+	if (ret) {
+		errnum = ERR_FSYS_CORRUPT;
+		return 0;
+	}
+	return multi.stripes[0].physical;
+}
+
+static int read_extent_from_disk(struct extent_buffer *eb)
+{
+	WARN_ON(eb->dev_bytenr % SECTOR_BITS);
+	return devread(eb->dev_bytenr >> SECTOR_BITS, 0, eb->len, eb->data);
+}
+
+static int verify_parent_transid(struct extent_buffer *eb, u64 parent_transid)
+{
+	return parent_transid && (btrfs_header_generation(eb) != parent_transid);
+}
+
+static int btrfs_num_copies(u64 logical, u64 len)
+{
+	return 1;
+}
+
+static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
+{
+	return 0;
+}
+
+static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
+		    int verify)
+{
+	return 0;
+}
+
+/*
+ * Read a block of logical number @bytenr
+ * from disk to buffer @eb.
+ * Return 1 on success.
+ */
+int read_tree_block(struct btrfs_root *root,
+		    struct extent_buffer *eb,
+		    u64 bytenr, /* logical */
+		    u32 blocksize,
+		    u64 parent_transid,
+		    lookup_pool_id lpid)
+{
+	int ret;
+	int dev_nr;
+	u64 length;
+	struct btrfs_multi_bio multi;
+	int mirror_num = 0;
+	int num_copies;
+
+	dev_nr = 0;
+	length = blocksize;
+	while (1) {
+		ret = __btrfs_map_block(bytenr,
+					&length, &multi, mirror_num);
+		if (ret) {
+			errnum = ERR_FSYS_CORRUPT;
+			return 0;
+		}
+		init_extent_buffer(eb,
+				   bytenr,
+				   blocksize,
+				   multi.stripes[0].physical,
+				   lpid);
+
+		ret = read_extent_from_disk(eb);
+		if (ret &&
+		    check_tree_block(root, eb) == 0 &&
+		    csum_tree_block(root, eb, 1) == 0 &&
+		    verify_parent_transid(eb, parent_transid) == 0)
+			return 1;
+
+		num_copies = btrfs_num_copies(eb->start, eb->len);
+		if (num_copies == 1)
+			break;
+		mirror_num++;
+		if (mirror_num > num_copies)
+			break;
+	}
+	return 0;
+}
+
+/*
+ * Read a child pointed by @slot node pointer
+ * of @parent. Put the result to @parent.
+ * Return 1 on success.
+ */
+static int parent2child(struct btrfs_root *root,
+			struct extent_buffer *parent,
+			int slot,
+			lookup_pool_id lpid)
+{
+	int level;
+
+	WARN_ON(slot < 0);
+	WARN_ON(slot >= btrfs_header_nritems(parent));
+
+	level = btrfs_header_level(parent);
+	WARN_ON(level <= 0);
+
+	return read_tree_block(root,
+			       parent,
+			       btrfs_node_blockptr(parent, slot),
+			       btrfs_level_size(root, level - 1),
+			       btrfs_node_ptr_generation(parent, slot),
+			       lpid);
+}
+
+static int btrfs_comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
+{
+	struct btrfs_key k1;
+
+	btrfs_disk_key_to_cpu(&k1, disk);
+
+	if (k1.objectid > k2->objectid)
+		return 1;
+	if (k1.objectid < k2->objectid)
+		return -1;
+	if (k1.type > k2->type)
+		return 1;
+	if (k1.type < k2->type)
+		return -1;
+	if (k1.offset > k2->offset)
+		return 1;
+	if (k1.offset < k2->offset)
+		return -1;
+	return 0;
+}
+
+static int bin_search(struct extent_buffer *eb, unsigned long p,
+		      int item_size, struct btrfs_key *key,
+		      int max, int *slot)
+{
+	int low = 0;
+	int high = max;
+	int mid;
+	int ret;
+	unsigned long offset;
+	struct btrfs_disk_key *tmp;
+
+	while(low < high) {
+		mid = (low + high) / 2;
+		offset = p + mid * item_size;
+
+		tmp = (struct btrfs_disk_key *)(eb->data + offset);
+		ret = btrfs_comp_keys(tmp, key);
+
+		if (ret < 0)
+			low = mid + 1;
+		else if (ret > 0)
+			high = mid;
+		else {
+			*slot = mid;
+			return 0;
+		}
+	}
+	*slot = low;
+	return 1;
+}
+
+/* look for a key in a node */
+static int node_lookup(struct extent_buffer *eb,
+		       struct btrfs_key *key,
+		       int *slot)
+{
+	if (btrfs_header_level(eb) == 0) {
+		return bin_search(eb,
+				  offsetof(struct btrfs_leaf, items),
+				  sizeof(struct btrfs_item),
+				  key, btrfs_header_nritems(eb),
+				  slot);
+	} else {
+		return bin_search(eb,
+				  offsetof(struct btrfs_node, ptrs),
+				  sizeof(struct btrfs_key_ptr),
+				  key, btrfs_header_nritems(eb),
+				  slot);
+	}
+	return -1;
+}
+
+static inline int check_node(struct extent_buffer *buf, int slot)
+{
+	return 0;
+}
+
+/*
+ * Look for an item by key in read-only tree.
+ * Return 0, if key was found. Return -1 on io errors.
+ *
+ * Preconditions: btrfs_mount already executed.
+ * Postconditions: if returned value is non-negative,
+ * then path[0] represents the found position in the
+ * tree. All components of the @path from leaf to root
+ * are valid except their data buffers (only path[0]
+ * has valid attached data buffer).
+ */
+
+int aux_tree_lookup(struct btrfs_root *root,
+		    struct btrfs_key *key,
+		    struct btrfs_path *path)
+{
+	int ret;
+	int slot = 0;
+	int level;
+	struct extent_buffer node;
+	init_extent_buffer(&node,
+			   0,
+			   0,
+			   0,
+			   path->lpid);
+	copy_extent_buffer(&node, &root->node);
+	do {
+		level = btrfs_header_level(&node);
+		ret = check_node(&node, slot);
+		if (ret)
+			return -1;
+		move_extent_buffer(&path->nodes[level],
+				   &node);
+		ret = node_lookup(&node, key, &slot);
+		if (ret < 0)
+			return ret;
+		if (level) {
+		        /*
+			 * non-leaf,
+			 * jump to the next level
+			 */
+			if (ret && slot > 0)
+			        slot -= 1;
+			ret = parent2child(root, &node, slot, path->lpid);
+			if (ret == 0)
+				return -1;
+		}
+		path->slots[level] = slot;
+	} while (level);
+	return ret;
+}
+
+static int readup_buffer(struct extent_buffer *buf, lookup_pool_id lpid)
+{
+	buf->data = grab_lookup_cache(lpid);
+	return read_extent_from_disk(buf);
+}
+
+/*
+ * Find the next leaf in accordance with tree order;
+ * walk up the tree as far as required to find it.
+ * Returns 0 if something was found, or 1 if there
+ * are no greater leaves. Returns < 0 on io errors.
+ *
+ * Preconditions: all @path components from leaf to
+ * root have valid meta-data fields. path[0] has a
+ * valid attached data buffer with initial leaf.
+ * Postcondition: the same as above, but path[0] has
+ * an attached data buffer with the next leaf.
+ */
+static int btrfs_next_leaf(struct btrfs_root *root,
+			   struct btrfs_path *path)
+{
+	int res;
+	int slot;
+	int level = 1;
+	struct extent_buffer *buf;
+
+	while(level < BTRFS_MAX_LEVEL) {
+		buf = &path->nodes[level];
+		slot = path->slots[level] + 1;
+		/*
+		 * lift data on this level
+		 */
+		res = readup_buffer(buf, path->lpid);
+		if (!res)
+			break;
+		if (slot >= btrfs_header_nritems(buf)) {
+			/* alas, go to parent (if any) */
+			level++;
+			res = 1;
+			continue;
+		}
+		break;
+	}
+	if (!res)
+		return 1;
+	/*
+	 * At this level slot points to
+	 * the subtree we are interested in.
+	 */
+	path->slots[level] = slot;
+	while(level) {
+		struct extent_buffer tmp;
+		move_extent_buffer(&tmp, &path->nodes[level]);
+		res = parent2child(root, &tmp, slot, path->lpid);
+		if (res == 0)
+			return -1;
+		level --;
+		slot = 0;
+		move_extent_buffer(&path->nodes[level], &tmp);
+		path->slots[level] = slot;
+	}
+	return 0;
+}
+
+/* Preconditions: path is valid, data buffer
+ * is attached to leaf node.
+ * Postcondition: path is updated to point to
+ * the next position with respect to the tree
+ * order.
+ *
+ * Return -1 on io errors.
+ * Return 0, if next item was found.
+ * Return 1, if next item wasn't found (no more items).
+ */
+static int btrfs_next_item(struct btrfs_root *root,
+			   struct btrfs_path *path)
+{
+	WARN_ON(path->slots[0] >= btrfs_header_nritems(&path->nodes[0]));
+
+	path->slots[0] += 1;
+
+	if (path->slots[0] < btrfs_header_nritems(&path->nodes[0]))
+		return 0;
+	if (coord_is_root(root, path))
+		/* no more items */
+		return 1;
+	return btrfs_next_leaf(root, path);
+}
+
+/*
+ * check if we can reuse results of previous
+ * search for read operation
+ */
+static int path_is_valid(struct btrfs_path *path,
+			 struct btrfs_key *key)
+{
+	btrfs_item_key_to_cpu(&path->nodes[0],
+			      key,
+			      path->slots[0]);
+	return (key->objectid == BTRFS_FILE_INFO->objectid) &&
+		(btrfs_key_type(key) == BTRFS_EXTENT_DATA_KEY);
+}
+
+/* ->read_func() */
+int btrfs_read(char *buf, int len)
+{
+	int ret;
+	struct btrfs_root *fs_root;
+	struct btrfs_path *path;
+	struct btrfs_key *info_key;
+	struct btrfs_key  path_key;
+	u64 off;
+	u64 bytes;
+	unsigned int to_read;
+	char *pos = buf;
+
+	fs_root = BTRFS_FS_ROOT;
+	info_key = BTRFS_FILE_INFO;
+	path = btrfs_grab_path(FIRST_EXTERNAL_LOOKUP_POOL);
+
+	if (!path_is_valid(path, &path_key)) {
+		btrfs_set_key_type(info_key, BTRFS_EXTENT_DATA_KEY);
+		info_key->offset = filepos;
+		ret = aux_tree_lookup(fs_root, info_key, path);
+		if (ret < 0)
+			errnum = ERR_FSYS_CORRUPT;
+	}
+	while (!errnum) {
+		struct btrfs_item *item;
+		struct btrfs_file_extent_item *fi;
+		unsigned int from;
+
+		if (!path_is_valid(path, &path_key))
+			break;
+		item = btrfs_item_nr(&path->nodes[0], path->slots[0]);
+		fi = btrfs_item_ptr(&path->nodes[0],
+				    path->slots[0],
+				    struct btrfs_file_extent_item);
+		if (btrfs_file_extent_compression(&path->nodes[0], fi)) {
+		       btrfs_msg("Btrfs transparent compression unsupported\n");
+		       errnum = ERR_BAD_FILETYPE;
+		       goto exit;
+		}
+		off = filepos - path_key.offset;
+
+		switch (btrfs_file_extent_type(&path->nodes[0], fi)) {
+		case BTRFS_FILE_EXTENT_INLINE:
+			bytes = btrfs_file_extent_inline_item_len(&path->
+								  nodes[0],
+								  item);
+			to_read = bytes - off;
+			if (to_read > len)
+				to_read = len;
+			from = off + btrfs_file_extent_inline_start(fi);
+			if (disk_read_hook != NULL) {
+				disk_read_func = disk_read_hook;
+				ret = devread(path->nodes[0].dev_bytenr >>
+					      SECTOR_BITS, from, to_read, pos);
+				disk_read_func = NULL;
+			} else {
+				memcpy(pos,
+				       path->nodes[0].data + from,
+				       to_read);
+			}
+			break;
+		case BTRFS_FILE_EXTENT_REG:
+			bytes = btrfs_file_extent_num_bytes(&path->nodes[0],
+							    fi);
+			to_read = bytes - off;
+			if (to_read > len)
+				to_read = len;
+			from = off +
+				btrfs_file_extent_disk_bytenr(&path->nodes[0],
+							      fi);
+			disk_read_func = disk_read_hook;
+			ret = devread(btrfs_map_block(from) >> SECTOR_BITS,
+				      from & ((u64)SECTOR_SIZE - 1),
+				      to_read,
+				      pos);
+			disk_read_func = NULL;
+			if (!ret)
+				goto exit;
+			break;
+		case BTRFS_FILE_EXTENT_PREALLOC:
+			btrfs_msg("Btrfs preallocated extents unsupported\n");
+			errnum = ERR_BAD_FILETYPE;
+			goto exit;
+		default:
+			errnum = ERR_FSYS_CORRUPT;
+			goto exit;
+		}
+		len -= to_read;
+		pos += to_read;
+		filepos += to_read;
+		if (len == 0)
+			break;
+		/* not everything was read */
+		ret = btrfs_next_item(fs_root, path);
+		if (ret) {
+			/* something should be found */
+			errnum = ERR_FSYS_CORRUPT;
+			break;
+		}
+	}
+ exit:
+	return errnum ? 0 : pos - buf;
+}
+
+static int btrfs_follow_link(struct btrfs_root *root,
+			     struct btrfs_path *path,
+			     char **dirname, char *linkbuf,
+			     int *link_count,
+			     struct btrfs_inode_item *sd)
+{
+	int ret;
+	int len;
+	char *name = *dirname;
+
+	if (++(*link_count) > MAX_LINK_COUNT) {
+		errnum = ERR_SYMLINK_LOOP;
+		return 0;
+	}
+	/* calculate remaining name size */
+	filemax = btrfs_inode_size(&path->nodes[0], sd);
+	for (len = 0;
+	     name[len] && isspace(name[len]);
+	     len ++);
+
+	if (filemax + len > PATH_MAX - 1) {
+		errnum = ERR_FILELENGTH;
+		return 0;
+	}
+	grub_memmove(linkbuf + filemax, name, len + 1);
+	btrfs_update_file_info(path);
+	filepos = 0;
+	/* extract symlink content */
+	while (1) {
+		u64 oid = BTRFS_FILE_INFO->objectid;
+		ret = btrfs_next_item(root, path);
+		if (ret)
+			break;
+		btrfs_update_file_info(path);
+		if (oid != BTRFS_FILE_INFO->objectid)
+			break;
+		if (btrfs_key_type(BTRFS_FILE_INFO) ==
+		    BTRFS_EXTENT_DATA_KEY)
+			goto found;
+	}
+	/* no target was found */
+	errnum = ERR_FSYS_CORRUPT;
+	return 0;
+ found:
+	/* fill the rest of linkbuf with the content */
+	ret = btrfs_read(linkbuf, filemax);
+	if (ret != filemax) {
+		errnum = ERR_FSYS_CORRUPT;
+		return 0;
+	}
+	return 1;
+}
+
+static int update_fs_root(struct btrfs_root *fs_root,
+			  struct btrfs_key *location)
+{
+	int ret;
+	struct btrfs_root *tree_root;
+
+	if (location->offset != (u64)-1)
+		return 0;
+	tree_root = &fs_root->fs_info->tree_root;
+	ret = find_setup_root(tree_root,
+			      tree_root->nodesize,
+			      tree_root->leafsize,
+			      tree_root->sectorsize,
+			      tree_root->stripesize,
+			      location->objectid,
+			      fs_root,
+			      0,
+			      0,
+			      0,
+			      SECOND_EXTERNAL_LOOKUP_POOL);
+	if (ret)
+		return ret;
+	location->objectid = btrfs_root_dirid(&fs_root->root_item);
+	btrfs_set_key_type(location, BTRFS_INODE_ITEM_KEY);
+	location->offset = 0;
+	return 0;
+}
+
+#ifndef STAGE1_5
+static inline void update_possibilities(void)
+{
+	if (print_possibilities > 0)
+		print_possibilities =
+			-print_possibilities;
+}
+#endif
+
+/*
+ * Look for a directory item by name.
+ * Print possibilities, if needed.
+ * Postconditions: on success @sd_key points
+ * to the key contained in the directory entry.
+ */
+static int btrfs_de_index_by_name(struct btrfs_root *root,
+				  struct btrfs_path *path,
+				  char **dirname,
+				  struct btrfs_key *sd_key)
+{
+	char ch;
+	int ret;
+	char *rest;
+	struct btrfs_dir_item *di;
+#ifndef STAGE1_5
+	int do_possibilities = 0;
+#endif
+	for (; **dirname == '/'; (*dirname)++);
+	for (rest = *dirname;
+	     (ch = *rest) && !isspace(ch) && ch != '/';
+	     rest++);
+	*rest = 0; /* for substrung() */
+#ifndef STAGE1_5
+	if (print_possibilities && ch != '/')
+		do_possibilities = 1;
+#endif
+	/* scan a directory */
+	while (1) {
+		u32 total;
+		u32 cur = 0;
+		u32 len;
+		struct btrfs_key di_key;
+		struct btrfs_disk_key location;
+		struct btrfs_item *item;
+
+		/* extract next dir entry */
+		ret = btrfs_next_item(root, path);
+		if (ret)
+			break;
+		item = btrfs_item_nr(&path->nodes[0],
+				     path->slots[0]);
+		btrfs_item_key_to_cpu(&path->nodes[0],
+				      &di_key,
+				      path->slots[0]);
+		if (di_key.objectid != sd_key->objectid)
+			/* no more entries */
+			break;
+		di = btrfs_item_ptr(&path->nodes[0],
+				    path->slots[0],
+				    struct btrfs_dir_item);
+		/*
+		 * working around special cases:
+		 * btrfs doesn't maintain directory entries
+		 * which contain names "." and ".."
+		 */
+		if (!substring(".", *dirname)) {
+#ifndef STAGE1_5
+			if (do_possibilities) {
+				update_possibilities();
+				return 1;
+			}
+#endif
+			goto found;
+		}
+		if (!substring("..", *dirname)) {
+			if (di_key.type != BTRFS_INODE_REF_KEY)
+				continue;
+			sd_key->objectid = di_key.offset;
+			btrfs_set_key_type(sd_key, BTRFS_INODE_ITEM_KEY);
+			sd_key->offset = 0;
+#ifndef STAGE1_5
+			if (do_possibilities) {
+				update_possibilities();
+				return 1;
+			}
+#endif
+			goto found;
+		}
+		if (di_key.type != BTRFS_DIR_ITEM_KEY)
+			continue;
+		total = btrfs_item_size(&path->nodes[0], item);
+		/* scan a directory item */
+		while (cur < total) {
+			char tmp;
+			int result;
+			char *filename;
+			char *end_of_name;
+			int name_len;
+			int data_len;
+
+			btrfs_dir_item_key(&path->nodes[0], di, &location);
+
+			name_len = btrfs_dir_name_len(&path->nodes[0], di);
+			data_len = btrfs_dir_data_len(&path->nodes[0], di);
+
+			WARN_ON(name_len > BTRFS_NAME_LEN);
+
+			filename = (char *)(path->nodes[0].data +
+					    (unsigned long)(di + 1));
+			end_of_name = filename + name_len;
+			/*
+			 * working around not null-terminated
+			 * directory names in btrfs: just
+			 * a short-term overwrite of the
+			 * cache with the following rollback
+			 * of the change.
+			 */
+			tmp = *end_of_name;
+			*end_of_name = 0;
+			result = substring(*dirname, filename);
+			*end_of_name = tmp;
+#ifndef STAGE1_5
+			if (do_possibilities) {
+				if (result <= 0) {
+					update_possibilities();
+					*end_of_name = 0;
+					print_a_completion(filename);
+					*end_of_name = tmp;
+				}
+			}
+			else
+#endif
+				if (result == 0) {
+				      btrfs_dir_item_key_to_cpu(&path->nodes[0],
+								di, sd_key);
+				      goto found;
+				}
+			len = sizeof(*di) + name_len + data_len;
+			di = (struct btrfs_dir_item *)((char *)di + len);
+			cur += len;
+		}
+	}
+#ifndef STAGE1_5
+	if (print_possibilities < 0)
+		return 1;
+#endif
+	errnum = ERR_FILE_NOT_FOUND;
+	*rest = ch;
+	return 0;
+ found:
+	*rest = ch;
+	*dirname = rest;
+	return 1;
+}
+
+/*
+ * ->dir_func().
+ * Postcondition: on a non-zero return BTRFS_FS_INFO
+ * contains the latest fs_root of file's subvolume.
+ * BTRFS_FS_INFO points to a subvolume of a file we
+ * were trying to look up.
+ * BTRFS_FILE_INFO contains info of the file we were
+ * trying to look up.
+ */
+
+int btrfs_dir(char *dirname)
+{
+	int ret;
+	int mode;
+	u64 size;
+	int linkcount = 0;
+	char linkbuf[PATH_MAX];
+
+	struct btrfs_path *path;
+	struct btrfs_root *root;
+
+	struct btrfs_key sd_key;
+	struct btrfs_inode_item *sd;
+	struct btrfs_key parent_sd_key;
+
+	root = BTRFS_FS_ROOT;
+	path = btrfs_grab_path(FIRST_EXTERNAL_LOOKUP_POOL);
+
+	btrfs_set_root_dir_key(&sd_key);
+	while (1) {
+		struct extent_buffer *leaf;
+		ret = aux_tree_lookup(root, &sd_key, path);
+		if (ret)
+			return 0;
+		leaf = &path->nodes[0];
+		sd = btrfs_item_ptr(leaf,
+				    path->slots[0],
+				    struct btrfs_inode_item);
+		mode = btrfs_inode_mode(leaf, sd);
+		size = btrfs_inode_size(leaf, sd);
+		switch (btrfs_get_file_type(mode)) {
+		case BTRFS_SYMLINK_FILE:
+			ret = btrfs_follow_link(root,
+						path,
+						&dirname,
+						linkbuf,
+						&linkcount,
+						sd);
+			if (!ret)
+				return 0;
+			dirname = linkbuf;
+			if (*dirname == '/')
+				/* absolute name */
+				btrfs_set_root_dir_key(&sd_key);
+			else
+				memcpy(&sd_key, &parent_sd_key,
+				       sizeof(sd_key));
+			continue;
+		case BTRFS_REGULAR_FILE:
+			/*
+			 * normally we want to exit here
+			 */
+			if (*dirname && !isspace (*dirname)) {
+				errnum = ERR_BAD_FILETYPE;
+				return 0;
+			}
+			filepos = 0;
+			filemax = btrfs_inode_size(leaf, sd);
+			btrfs_update_file_info(path);
+			return 1;
+		case BTRFS_DIRECTORY_FILE:
+			memcpy(&parent_sd_key, &sd_key, sizeof(sd_key));
+			ret = btrfs_de_index_by_name(root,
+						     path,
+						     &dirname,
+						     &sd_key);
+			if (!ret)
+				return 0;
+#ifndef STAGE1_5
+			if (print_possibilities < 0)
+				return 1;
+#endif
+			/*
+			 * update fs_tree:
+			 * subvolume stuff goes here
+			 */
+			ret = update_fs_root(root, &sd_key);
+			if (ret)
+				return 0;
+			continue;
+		case BTRFS_UNKNOWN_FILE:
+		default:
+			btrfs_msg("Btrfs: bad file type\n");
+			errnum = ERR_BAD_FILETYPE;
+			return 0;
+		}
+	}
+}
+
+#endif /* FSYS_BTRFS */
+
+/*
+  Local variables:
+  c-indentation-style: "K&R"
+  mode-name: "LC"
+  c-basic-offset: 8
+  tab-width: 8
+  fill-column: 80
+  scroll-step: 1
+  End:
+*/
--- grub-0.97.orig/stage2/shared.h
+++ grub-0.97/stage2/shared.h
@@ -210,11 +210,12 @@ extern void *grub_scratch_mem;
 #define STAGE2_ID_FAT_STAGE1_5		3
 #define STAGE2_ID_MINIX_STAGE1_5	4
 #define STAGE2_ID_REISERFS_STAGE1_5	5
-#define STAGE2_ID_VSTAFS_STAGE1_5	6
-#define STAGE2_ID_JFS_STAGE1_5		7
-#define STAGE2_ID_XFS_STAGE1_5		8
-#define STAGE2_ID_ISO9660_STAGE1_5	9
-#define STAGE2_ID_UFS2_STAGE1_5		10
+#define STAGE2_ID_BTRFS_STAGE1_5	6
+#define STAGE2_ID_VSTAFS_STAGE1_5	7
+#define STAGE2_ID_JFS_STAGE1_5		8
+#define STAGE2_ID_XFS_STAGE1_5		9
+#define STAGE2_ID_ISO9660_STAGE1_5	10
+#define STAGE2_ID_UFS2_STAGE1_5		11
 
 #ifndef STAGE1_5
 # define STAGE2_ID	STAGE2_ID_STAGE2
@@ -229,6 +230,8 @@ extern void *grub_scratch_mem;
 #  define STAGE2_ID	STAGE2_ID_MINIX_STAGE1_5
 # elif defined(FSYS_REISERFS)
 #  define STAGE2_ID	STAGE2_ID_REISERFS_STAGE1_5
+# elif defined(FSYS_BTRFS)
+#  define STAGE2_ID	STAGE2_ID_BTRFS_STAGE1_5
 # elif defined(FSYS_VSTAFS)
 #  define STAGE2_ID	STAGE2_ID_VSTAFS_STAGE1_5
 # elif defined(FSYS_JFS)
--- grub-0.97.orig/AUTHORS
+++ grub-0.97/AUTHORS
@@ -41,6 +41,8 @@ Kristoffer Branemyr added VSTa filesyste
 
 Serguei Tzukanov added JFS and XFS support.
 
+Edward Shishkin added Btrfs support.
+
 Jason Thomas added Linux DAC960 support and support for hiding/unhiding
 logical partitions, and did a significant bugfix for the terminal stuff.
 

--------------060604030607000902070801--
