Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:57424 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757371AbcG0Rnd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 13:43:33 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/5] New btrfs command: "btrfs inspect physical-find"
Date: Wed, 27 Jul 2016 19:43:15 +0200
Message-Id: <1469641398-3879-3-git-send-email-kreijack@libero.it>
In-Reply-To: <1469641398-3879-1-git-send-email-kreijack@libero.it>
References: <1469641398-3879-1-git-send-email-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

The aim of this new command is to show the physical placement on the disk
of a file.
Currently it handles all the profiles (single, dup, raid1/10/5/6).

The syntax is simple:

where:
  <filename> is the file to inspect
  <offset> is the offset of the file to inspect (default 0)

Below some examples:

** Single

$ sudo mkfs.btrfs -f -d single -m single /dev/loop0
$ sudo mount /dev/loop0 mnt/
$ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
$ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
mnt/out.txt: 0
        devid: 1 dev_name: /dev/loop0 offset: 12582912 type: LINEAR
$ dd 2>/dev/null if=/dev/loop0 skip=12582912 bs=1 count=5; echo
adaaa

** Dup

The command shows both the copies

$ sudo mkfs.btrfs -f -d single -m single /dev/loop0
$ sudo mount /dev/loop0 mnt/
$ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
$ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
$ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
mnt/out.txt: 0
        devid: 1 dev_name: /dev/loop0 offset: 71303168 type: DUP
        devid: 1 dev_name: /dev/loop0 offset: 104857600 type: DUP
$ dd 2>/dev/null if=/dev/loop0 skip=104857600 bs=1 count=5 ; echo
adaaa

** Raid1

The command shows both the copies

$ sudo mkfs.btrfs -f -d raid1 -m raid1 /dev/loop0 /dev/loop1
$ sudo mount /dev/loop0 mnt/
$ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
$ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt mnt/out.txt: 0
        devid: 2 dev_name: /dev/loop1 offset: 61865984 type: RAID1
        devid: 1 dev_name: /dev/loop0 offset: 81788928 type: RAID1
$ dd 2>/dev/null if=/dev/loop0 skip=81788928 bs=1 count=5; echo
adaaa

** Raid10

The command show both the copies; if you set an offset to the next disk-stripe, you can see the next pair of disk-stripe

$ sudo mkfs.btrfs -f -d raid10 -m raid10 /dev/loop[0123]
$ sudo mount /dev/loop0 mnt/
$ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
$ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt mnt/out.txt: 0
        devid: 4 dev_name: /dev/loop3 offset: 61931520 type: RAID10
        devid: 3 dev_name: /dev/loop2 offset: 61931520 type: RAID10
$ dd 2>/dev/null if=/dev/loop2 skip=61931520 bs=1 count=5; echo
adaaa
$ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt 65536
mnt/out.txt: 65536
        devid: 2 dev_name: /dev/loop1 offset: 61931520 type: RAID10
        devid: 1 dev_name: /dev/loop0 offset: 81854464 type: RAID10
$ dd 2>/dev/null if=/dev/loop0 skip=81854464 bs=1 count=5; echo
bdbbb

** Raid5

Depending by the offset, you can see which disk-stripe is used.

$ sudo mkfs.btrfs -f -d raid5 -m raid5 /dev/loop[012]
$ sudo mount /dev/loop0 mnt/
$ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
$ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
mnt/out.txt: 0
        devid: 2 dev_name: /dev/loop1 offset: 61931520 type: DATA
        devid: 1 dev_name: /dev/loop0 offset: 81854464 type: OTHER
        devid: 3 dev_name: /dev/loop2 offset: 61931520 type: PARITY
$ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt 65536mnt/out.txt: 65536
        devid: 2 dev_name: /dev/loop1 offset: 61931520 type: OTHER
        devid: 1 dev_name: /dev/loop0 offset: 81854464 type: DATA
        devid: 3 dev_name: /dev/loop2 offset: 61931520 type: PARITY
$ dd 2>/dev/null if=/dev/loop1 skip=61931520 bs=1 count=5; echo
adaaa
$ dd 2>/dev/null if=/dev/loop0 skip=81854464 bs=1 count=5; echo
bdbbb
$ dd 2>/dev/null if=/dev/loop2 skip=61931520 bs=1 count=5 | xxd
00000000: 0300 0303 03                             .....

The parity is computed as: parity=disk1^disk2. So "adaa" ^ "bdbb" == "\x03\x00\x03\x03

** Raid6
$ sudo mkfs.btrfs -f -mraid6 -draid6 /dev/loop[0-4]^C
$ sudo mount /dev/loop0 mnt/
$ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
$ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
mnt/out.txt: 0
        devid: 3 dev_name: /dev/loop2 offset: 61931520 type: DATA
        devid: 2 dev_name: /dev/loop1 offset: 61931520 type: OTHER
        devid: 1 dev_name: /dev/loop0 offset: 81854464 type: PARITY
        devid: 4 dev_name: /dev/loop3 offset: 61931520 type: PARITY

$ dd 2>/dev/null if=/dev/loop2 skip=61931520 bs=1 count=5 ; echo
adaaa


Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-inspect.c | 587 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 587 insertions(+)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index dd7b9dd..fc2e7c3 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -22,6 +22,11 @@
 #include <errno.h>
 #include <getopt.h>
 #include <limits.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <linux/fs.h>
+#include <linux/fiemap.h>
 
 #include "kerncompat.h"
 #include "ioctl.h"
@@ -623,6 +628,586 @@ out:
 	return !!ret;
 }
 
+
+static const char * const cmd_inspect_physical_find_usage[] = {
+	"btrfs inspect-internal physical-find <path> [<off>|-l <logical>]",
+	"Show the physical placement of a file data.",
+	"<path>     file to show",
+	"<off>      file offset to show; 0 if not specified",
+	"<logical>  show info about a logical address instead of a file",
+	"This command requires root privileges",
+	NULL
+};
+
+#define STRIPE_INFO_LINEAR		1
+#define STRIPE_INFO_DUP			2
+#define STRIPE_INFO_RAID0		3
+#define STRIPE_INFO_RAID1		4
+#define STRIPE_INFO_RAID10		5
+#define STRIPE_INFO_RAID56_DATA		6
+#define STRIPE_INFO_RAID56_OTHER	7
+#define STRIPE_INFO_RAID56_PARITY	8
+
+static const char * const stripe_info_descr[] = {
+	[STRIPE_INFO_LINEAR] = "LINEAR",
+	[STRIPE_INFO_DUP] = "DUP",
+	[STRIPE_INFO_RAID0] = "RAID0",
+	[STRIPE_INFO_RAID1] = "RAID1",
+	[STRIPE_INFO_RAID10] = "RAID10",
+	[STRIPE_INFO_RAID56_DATA] = "DATA",
+	[STRIPE_INFO_RAID56_OTHER] = "OTHER",
+	[STRIPE_INFO_RAID56_PARITY] = "PARITY",
+};
+
+struct stripe_info {
+	u64 devid;
+	const char *dname;
+	u64 phy_start;
+	int type;
+};
+
+static void add_stripe_info(struct stripe_info **list, int *count,
+	u64 devid, const char *dname, u64 phy_start, int type) {
+
+	if (*list == NULL)
+		*count = 0;
+
+	++*count;
+	*list = realloc(*list, sizeof(struct stripe_info) * *count);
+	/*
+	 * It is rude, but it should not happen for this kind of allocation...
+	 * ... and anyway when it happens, there are more severe problems
+	 * that this handling of "not enough memory"
+	 */
+	if (*list == NULL) {
+		error("Not nough memory: abort\n");
+		exit(100);
+	}
+
+	(*list)[*count-1].devid = devid;
+	(*list)[*count-1].dname = dname;
+	(*list)[*count-1].phy_start = phy_start;
+	(*list)[*count-1].type = type;
+}
+
+static void dump_stripes(int ndisks, struct btrfs_ioctl_dev_info_args *disks,
+			 struct btrfs_chunk *chunk, u64 logical_start,
+			 struct stripe_info **stripes_ret, int *stripes_count) {
+	struct btrfs_stripe *stripes;
+
+	stripes = &chunk->stripe;
+
+	if ((chunk->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0) {
+		/* LINEAR: each chunk has (should have) only one disk */
+		int j;
+		char *dname = "<NOT FOUND>";
+
+		assert(chunk->num_stripes == 1);
+
+		u64 phy_start = stripes[0].offset +
+			+logical_start;
+		for (j = 0 ; j < ndisks ; j++) {
+			if (stripes[0].devid == disks[j].devid) {
+				dname = (char *)disks[j].path;
+				break;
+			}
+		}
+
+		add_stripe_info(stripes_ret, stripes_count,
+			stripes[0].devid, dname, phy_start,
+			STRIPE_INFO_LINEAR);
+	} else if (chunk->type & BTRFS_BLOCK_GROUP_RAID0) {
+		/*
+		 * RAID0: each chunk is composed by more disks;
+		 * each stripe_len bytes are in a different disk:
+		 *
+		 *  file: ABC...NMOP....
+		 *
+		 *      disk1   disk2    disk3  .... disksN
+		 *
+		 *        A      B         C    ....    N
+		 *        M      O         P    ....
+		 *
+		 */
+		u64 disks_number = chunk->num_stripes;
+		u64 disk_stripe_size = chunk->stripe_len;
+		u64 stripe_capacity;
+		u64 stripe_nr;
+		u64 disk_stripe_start;
+		int sidx;
+		int j;
+		char *dname = "<NOT FOUND>";
+
+		stripe_capacity = disks_number * disk_stripe_size;
+		stripe_nr = logical_start / stripe_capacity;
+		disk_stripe_start = logical_start % disk_stripe_size;
+
+		sidx = (logical_start / disk_stripe_size) % disks_number;
+
+		u64 phy_start = stripes[sidx].offset +
+			stripe_nr * disk_stripe_size +
+			disk_stripe_start;
+
+		for (j = 0 ; j < ndisks ; j++) {
+			if (stripes[sidx].devid == disks[j].devid) {
+				dname = (char *)disks[j].path;
+				break;
+			}
+		}
+
+		add_stripe_info(stripes_ret, stripes_count,
+			stripes[sidx].devid, dname, phy_start,
+			STRIPE_INFO_RAID0);
+
+	} else if (chunk->type & BTRFS_BLOCK_GROUP_RAID1) {
+		/*
+		 * RAID0: each chunk is composed by more disks;
+		 * each stripe_len bytes are in a different disk:
+		 *
+		 *  file: ABC...
+		 *
+		 *      disk1   disk2   disk3  ....
+		 *
+		 *        A       A
+		 *        B       B
+		 *        C       C
+		 *
+		 */
+		int sidx;
+
+		for (sidx = 0; sidx < chunk->num_stripes; sidx++) {
+			int j;
+			char *dname = "<NOT FOUND>";
+			u64 phy_start = stripes[sidx].offset +
+				+logical_start;
+
+			for (j = 0 ; j < ndisks ; j++) {
+				if (stripes[sidx].devid == disks[j].devid) {
+					dname = (char *)disks[j].path;
+					break;
+				}
+			}
+			add_stripe_info(stripes_ret, stripes_count,
+				stripes[sidx].devid, dname, phy_start,
+				STRIPE_INFO_RAID1);
+		}
+
+	} else if (chunk->type & BTRFS_BLOCK_GROUP_DUP) {
+		/*
+		 * DUP: each chunk has 'num_stripes' disk_stripe. Heach
+		 * disk_stripe has its own copy of data
+		 *
+		 *  file: ABCD....
+		 *
+		 *      disk1   disk2   disk3
+		 *
+		 *        A
+		 *        B
+		 *        C
+		 *      [...]
+		 *        A
+		 *        B
+		 *        C
+		 *
+		 *
+		 * NOTE: the difference between DUP and RAID1 is that
+		 * in RAID1 each disk_stripe is in a different disk, in DUP
+		 * each disk chunk is in the same disk
+		 */
+		int sidx;
+
+		for (sidx = 0; sidx < chunk->num_stripes; sidx++) {
+			int j;
+			char *dname = "<NOT FOUND>";
+			u64 phy_start = stripes[sidx].offset +
+				+logical_start;
+
+			for (j = 0 ; j < ndisks ; j++) {
+				if (stripes[sidx].devid == disks[j].devid) {
+					dname = (char *)disks[j].path;
+					break;
+				}
+			}
+
+			add_stripe_info(stripes_ret, stripes_count,
+				stripes[sidx].devid, dname, phy_start,
+				STRIPE_INFO_DUP);
+		}
+	} else if (chunk->type & BTRFS_BLOCK_GROUP_RAID10) {
+		/*
+		 * RAID10: each chunk is composed by more disks;
+		 * each stripe_len bytes are in a different disk:
+		 *
+		 *  file: ABCD....
+		 *
+		 *      disk1   disk2   disk3   disk4
+		 *
+		 *        A      A         B      B
+		 *        C      C         D      D
+		 *
+		 *
+		 */
+		int i;
+		u64 disks_number = chunk->num_stripes;
+		u64 disk_stripe_size = chunk->stripe_len;
+		u64 stripe_capacity;
+		u64 stripe_nr;
+		u64 stripe_start;
+		u64 disk_stripe_start;
+
+		stripe_capacity = disks_number * disk_stripe_size / chunk->sub_stripes;
+		stripe_nr = logical_start / stripe_capacity;
+		stripe_start = logical_start % stripe_capacity;
+		disk_stripe_start = logical_start % disk_stripe_size;
+
+		for (i = 0; i < chunk->sub_stripes; i++) {
+			int j;
+			char *dname = "<NOT FOUND>";
+			int sidx = (i +
+				stripe_start/disk_stripe_size*chunk->sub_stripes) %
+				disks_number;
+
+			u64 phy_start = stripes[sidx].offset +
+				+stripe_nr*disk_stripe_size + disk_stripe_start;
+
+			for (j = 0 ; j < ndisks ; j++) {
+				if (stripes[sidx].devid == disks[j].devid) {
+					dname = (char *)disks[j].path;
+					break;
+				}
+			}
+
+			add_stripe_info(stripes_ret, stripes_count,
+				stripes[sidx].devid, dname, phy_start,
+				STRIPE_INFO_RAID10);
+
+		}
+	} else if (chunk->type & BTRFS_BLOCK_GROUP_RAID5 ||
+			chunk->type & BTRFS_BLOCK_GROUP_RAID6) {
+		/*
+		 * RAID5: each chunk is spread on a different disk; however one
+		 * disk is used for parity
+		 *
+		 *  file: ABCDEFGHIJK....
+		 *
+		 *      disk1  disk2  disk3  disk4  disk5
+		 *
+		 *        A      B      C      D      P
+		 *        P      D      E      F      G
+		 *        H      P      I      J      K
+		 *
+		 *   Note: P == parity
+		 *
+		 * RAID6: each chunk is spread on a different disk; however two
+		 * disks are used for parity
+		 *
+		 *  file: ABCDEFGHI...
+		 *
+		 *      disk1  disk2  disk3  disk4  disk5
+		 *
+		 *        A      B      C      P      Q
+		 *        Q      D      E      F      P
+		 *        P      Q      G      H      I
+		 *
+		 *   Note: P,Q == parity
+		 *
+		 */
+		int parities_nr = 1;
+		u64 disks_number = chunk->num_stripes;
+		u64 disk_stripe_size = chunk->stripe_len;
+		u64 stripe_capacity;
+		u64 stripe_nr;
+		u64 stripe_start;
+		u64 pos = 0;
+		u64 disk_stripe_start;
+		int sidx;
+
+		if (chunk->type & BTRFS_BLOCK_GROUP_RAID6)
+			parities_nr = 2;
+
+		stripe_capacity = (disks_number - parities_nr) *
+						disk_stripe_size;
+		stripe_nr = logical_start / stripe_capacity;
+		stripe_start = logical_start % stripe_capacity;
+		disk_stripe_start = logical_start % disk_stripe_size;
+
+		for (sidx = 0; sidx < disks_number ; sidx++) {
+			int j;
+			char *dname = "<NOT FOUND>";
+			u64 stripe_index = (sidx + stripe_nr) % disks_number;
+			u64 phy_start = stripes[stripe_index].offset + /* chunk start */
+				+ stripe_nr*disk_stripe_size +  /* stripe start */
+				+ disk_stripe_start;
+
+			for (j = 0 ; j < ndisks ; j++)
+				if (stripes[stripe_index].devid == disks[j].devid) {
+				dname = (char *)disks[j].path;
+				break;
+				}
+
+			if (sidx >= (disks_number - parities_nr)) {
+				add_stripe_info(stripes_ret, stripes_count,
+					stripes[stripe_index].devid, dname, phy_start,
+					STRIPE_INFO_RAID56_PARITY);
+				continue;
+			}
+
+			if (stripe_start >= pos && stripe_start < (pos+disk_stripe_size)) {
+				add_stripe_info(stripes_ret, stripes_count,
+					stripes[stripe_index].devid, dname, phy_start,
+					STRIPE_INFO_RAID56_DATA);
+			} else {
+				add_stripe_info(stripes_ret, stripes_count,
+					stripes[stripe_index].devid, dname, phy_start,
+					STRIPE_INFO_RAID56_OTHER);
+			}
+
+			pos += disk_stripe_size;
+		}
+		assert(pos == stripe_capacity);
+	} else {
+		error("Unknown chunk type = 0x%016llx\n", chunk->type);
+		return;
+	}
+
+}
+
+static int get_chunk_offset(int fd, u64 logical_start,
+	struct btrfs_chunk *chunk_ret, u64 *off_ret) {
+
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header sh;
+	unsigned long off = 0;
+	int i;
+
+	memset(&args, 0, sizeof(args));
+	sk->tree_id = BTRFS_CHUNK_TREE_OBJECTID;
+	sk->min_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	sk->max_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	sk->min_type = BTRFS_CHUNK_ITEM_KEY;
+	sk->max_type = BTRFS_CHUNK_ITEM_KEY;
+	sk->max_offset = (u64)-1;
+	sk->min_offset = 0;
+	sk->max_transid = (u64)-1;
+
+	while (1) {
+		int ret;
+
+		sk->nr_items = 1;
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		if (ret < 0)
+			return -errno;
+
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+		for (i = 0; i < sk->nr_items; i++) {
+			struct btrfs_chunk *item;
+
+			memcpy(&sh, args.buf + off, sizeof(sh));
+			off += sizeof(sh);
+			item = (struct btrfs_chunk *)(args.buf + off);
+			off += sh.len;
+
+			if (logical_start >= sh.offset &&
+			    logical_start < sh.offset+item->length) {
+				memcpy(chunk_ret, item, sh.len);
+				*off_ret = logical_start-sh.offset;
+				return 0;
+			}
+
+			sk->min_objectid = sh.objectid;
+			sk->min_type = sh.type;
+			sk->min_offset = sh.offset;
+		}
+
+		if (sk->min_offset < (u64)-1)
+			sk->min_offset++;
+		else
+			break;
+	}
+
+	return 1; /* not found */
+}
+
+/*
+ * Inline extents are skipped because they do not take data space,
+ * delalloc and unknown are skipped because we do not know how much
+ * space they will use yet.
+ */
+#define SKIP_FLAGS	(FIEMAP_EXTENT_UNKNOWN|FIEMAP_EXTENT_DELALLOC| \
+			 FIEMAP_EXTENT_DATA_INLINE)
+
+static int get_file_offset(int fd, u64 file_offset, u64 *logical)
+{
+	char buf[16384];
+	struct fiemap *fiemap = (struct fiemap *)buf;
+	struct fiemap_extent *fm_ext;
+	const int count = (sizeof(buf) - sizeof(*fiemap)) /
+					sizeof(struct fiemap_extent);
+	int last = 0;
+
+
+	memset(fiemap, 0, sizeof(struct fiemap));
+
+	do {
+
+		int rc;
+		int j;
+
+		fiemap->fm_length = ~0ULL;
+		fiemap->fm_extent_count = count;
+		fiemap->fm_flags = FIEMAP_FLAG_SYNC;
+		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
+		if (rc < 0)
+			return -errno;
+
+		for (j = 0; j < fiemap->fm_mapped_extents; j++) {
+			u32 flags;
+
+			fm_ext = &fiemap->fm_extents[j];
+			flags = fm_ext->fe_flags;
+
+			fiemap->fm_start = (fm_ext->fe_logical +
+					fm_ext->fe_length);
+
+			if (flags & FIEMAP_EXTENT_LAST)
+				last = 1;
+
+			if (flags & SKIP_FLAGS)
+				continue;
+
+			if (file_offset > fm_ext->fe_logical +
+			fm_ext->fe_length)
+				continue;
+
+			*logical = fm_ext->fe_physical + file_offset -
+				   fm_ext->fe_logical;
+			return 0;
+		}
+	} while (last == 0);
+
+	return 1;
+}
+static int cmd_inspect_physical_find(int argc, char **argv)
+{
+	int ret = 0;
+	int fd = -1;
+	char *fname;
+	struct btrfs_ioctl_dev_info_args *disks = NULL;
+	struct btrfs_ioctl_fs_info_args fi_args = {0};
+	char btrfs_chunk_data[4096];
+	struct btrfs_chunk *chunk_item = (struct btrfs_chunk *)&btrfs_chunk_data;
+	u64 chunk_offset = 0;
+	struct stripe_info *stripes = NULL;
+	int stripes_count = 0;
+	int i;
+	int rc;
+	const char *logical_arg = NULL;
+	u64 logical = 0ull;
+
+
+	optind = 1;
+	while (1) {
+		int c = getopt(argc, argv, "l:");
+
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'l':
+			logical_arg = optarg;
+			break;
+		default:
+			usage(cmd_inspect_physical_find_usage);
+		}
+	}
+
+	if ((logical_arg != NULL && check_argc_exact(argc - optind, 1)) ||
+	    (check_argc_min(argc - optind, 1) || check_argc_max(argc - optind, 2)))
+		usage(cmd_inspect_physical_find_usage);
+
+	fname = argv[optind];
+
+	check_root_or_exit();
+	check_btrfs_or_exit(fname);
+
+	fd = open(fname, O_RDONLY);
+	if (fd < 0) {
+		error("Can't open '%s' for reading\n", fname);
+		ret = -errno;
+		goto out;
+	}
+
+	if (logical_arg == NULL) {
+		u64 file_offset = 0ull;
+
+		if (argc - optind == 2)
+			file_offset = strtoull(argv[optind+1], NULL, 0);
+		ret = get_file_offset(fd, file_offset, &logical);
+		if (ret > 0) {
+			error("Can't find the extent: the file is too short, or the file is stored in a leaf.\n");
+			ret = 10;
+			goto out;
+		} else if (ret < 0) {
+			int e = -ret;
+
+			error("Can't do ioctl() [errno=%d: %s]\n", e, strerror(e));
+			ret = 11;
+			goto out;
+		}
+
+		printf("logical: %llu offset: %llu file: %s\n", logical,
+		       file_offset, fname);
+	} else {
+		logical = strtoull(logical_arg, NULL, 0);
+		printf("logical: %llu filesystem: %s\n", logical, fname);
+	}
+
+	rc = get_fs_info(fname, &fi_args, &disks);
+	if (rc < 0) {
+		error("Cannot get info for the filesystem: may be it is not a btrfs filesystem ?\n");
+		ret = 12;
+		goto out;
+	}
+
+	rc = get_chunk_offset(fd,
+		logical,
+		chunk_item, &chunk_offset);
+	if (rc < 0) {
+		error("cannot perform the search: %s", strerror(rc));
+		ret = 13;
+		goto out;
+	}
+	if (rc != 0) {
+		error("cannot find chunk\n");
+		ret = 14;
+		goto out;
+	}
+
+	dump_stripes(fi_args.num_devices, disks,
+		     chunk_item, chunk_offset,
+		     &stripes, &stripes_count);
+
+	for (i = 0 ; i < stripes_count ; i++) {
+		printf("devid: %llu dev_name: %s offset: %llu type: %s\n",
+			stripes[i].devid, stripes[i].dname,
+			stripes[i].phy_start,
+			stripe_info_descr[stripes[i].type]);
+	}
+
+out:
+	if (fd != -1)
+		close(fd);
+	if (disks != NULL)
+		free(disks);
+	if (stripes != NULL)
+		free(stripes);
+	return ret;
+}
+
 static const char inspect_cmd_group_info[] =
 "query various internal information";
 
@@ -644,6 +1229,8 @@ const struct cmd_group inspect_cmd_group = {
 				cmd_inspect_dump_super_usage, NULL, 0 },
 		{ "tree-stats", cmd_inspect_tree_stats,
 				cmd_inspect_tree_stats_usage, NULL, 0 },
+		{ "physical-find", cmd_inspect_physical_find,
+				cmd_inspect_physical_find_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.8.1

