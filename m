Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:65033 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaBXVQP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 16:16:15 -0500
From: Andrea Mazzoleni <amadvance@gmail.com>
To: clm@fb.com, jbacik@fb.com, neilb@suse.de
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, amadvance@gmail.com
Subject: [PATCH v5 3/3] btrfs-progs: Adds new par3456 modes to support up to six parities
Date: Mon, 24 Feb 2014 22:15:30 +0100
Message-Id: <1393276530-26423-4-git-send-email-amadvance@gmail.com>
In-Reply-To: <1393276530-26423-1-git-send-email-amadvance@gmail.com>
References: <1393276530-26423-1-git-send-email-amadvance@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Extends mkfs.btrfs to support the new par1/2/3/4/5/6 modes to create
filesystem with up to six parities.
Replaces the raid6 code with a new references function able to compute up
to six parities.
Replaces the existing BLOCK_GROUP_RAID5/6 with new PAR1/2/3/4/5/6 ones that
handle up to six parities, and updates all the code to use them.

Signed-off-by: Andrea Mazzoleni <amadvance@gmail.com>
---
 Makefile            |  14 ++-
 chunk-recover.c     |  18 +---
 cmds-balance.c      |  20 +++-
 cmds-check.c        |   7 +-
 cmds-chunk.c        |  18 +---
 cmds-filesystem.c   |  12 ++-
 ctree.h             |  42 ++++++++-
 disk-io.h           |   2 -
 extent-tree.c       |   3 +-
 ioctl.h             |  18 +++-
 man/mkfs.btrfs.8.in |   4 +-
 mkfs.c              |  28 +++++-
 mktables.c          | 256 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 raid.c              |  44 +++++++++
 raid.h              |  34 +++++++
 raid6.c             | 101 ---------------------
 utils.c             |  12 ++-
 volumes.c           | 112 ++++++++++-------------
 volumes.h           |  12 ++-
 19 files changed, 530 insertions(+), 227 deletions(-)
 create mode 100644 mktables.c
 create mode 100644 raid.c
 create mode 100644 raid.h
 delete mode 100644 raid6.c

diff --git a/Makefile b/Makefile
index 0874a41..72c5c01 100644
--- a/Makefile
+++ b/Makefile
@@ -9,7 +9,7 @@ CFLAGS = -g -O1 -fno-strict-aliasing
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid6.o free-space-cache.o list_sort.o
+	  qgroup.o raid.o tables.o free-space-cache.o list_sort.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
@@ -140,6 +140,10 @@ version.h:
 	@echo "    [SH]     $@"
 	$(Q)bash version.sh
 
+tables.c: mktables
+	@echo "    [MK]     $@"
+	$(Q)./mktables > tables.c
+
 $(libs_shared): $(libbtrfs_objects) $(lib_links) send.h
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(LDFLAGS) $(lib_LIBS) \
@@ -193,6 +197,10 @@ mkfs.btrfs: $(objects) $(libs) mkfs.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
 
+mktables: $(libs) mktables.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o mktables mktables.o $(LDFLAGS) $(LIBS)
+
 mkfs.btrfs.static: $(static_objects) mkfs.static.o $(static_libbtrfs_objects)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(STATIC_CFLAGS) -o mkfs.btrfs.static mkfs.static.o $(static_objects) \
@@ -225,8 +233,8 @@ clean: $(CLEANDIRS)
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o *.o.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfsck \
-	      btrfs.static mkfs.btrfs.static btrfs-calc-size \
-	      version.h $(check_defs) \
+	      btrfs.static mkfs.btrfs.static btrfs-calc-size mktables \
+	      version.h tables.c $(check_defs) \
 	      $(libs) $(lib_links)
 
 $(CLEANDIRS):
diff --git a/chunk-recover.c b/chunk-recover.c
index bcde39e..cec14cd 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1327,8 +1327,7 @@ static int calc_num_stripes(u64 type)
 {
 	if (type & (BTRFS_BLOCK_GROUP_RAID0 |
 		    BTRFS_BLOCK_GROUP_RAID10 |
-		    BTRFS_BLOCK_GROUP_RAID5 |
-		    BTRFS_BLOCK_GROUP_RAID6))
+		    BTRFS_BLOCK_GROUP_PARX))
 		return 0;
 	else if (type & (BTRFS_BLOCK_GROUP_RAID1 |
 			 BTRFS_BLOCK_GROUP_DUP))
@@ -1404,13 +1403,8 @@ static int btrfs_calc_stripe_index(struct chunk_record *chunk, u64 logical)
 	} else if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID10) {
 		index = stripe_nr % (chunk->num_stripes / chunk->sub_stripes);
 		index *= chunk->sub_stripes;
-	} else if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID5) {
-		nr_data_stripes = chunk->num_stripes - 1;
-		index = stripe_nr % nr_data_stripes;
-		stripe_nr /= nr_data_stripes;
-		index = (index + stripe_nr) % chunk->num_stripes;
-	} else if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID6) {
-		nr_data_stripes = chunk->num_stripes - 2;
+	} else if (chunk->type_flags & BTRFS_BLOCK_GROUP_PARX) {
+		nr_data_stripes = chunk->num_stripes - btrfs_flags_par(chunk->type_flags);
 		index = stripe_nr % nr_data_stripes;
 		stripe_nr /= nr_data_stripes;
 		index = (index + stripe_nr) % chunk->num_stripes;
@@ -1503,8 +1497,7 @@ no_extent_record:
 	if (list_empty(&devexts))
 		return 0;
 
-	if (chunk->type_flags & (BTRFS_BLOCK_GROUP_RAID5 |
-				 BTRFS_BLOCK_GROUP_RAID6)) {
+	if (chunk->type_flags & BTRFS_BLOCK_GROUP_PARX) {
 		/* Fixme: try to recover the order by the parity block. */
 		list_splice_tail(&devexts, &chunk->dextents);
 		return -EINVAL;
@@ -1540,8 +1533,7 @@ no_extent_record:
 
 #define BTRFS_ORDERED_RAID	(BTRFS_BLOCK_GROUP_RAID0 |	\
 				 BTRFS_BLOCK_GROUP_RAID10 |	\
-				 BTRFS_BLOCK_GROUP_RAID5 |	\
-				 BTRFS_BLOCK_GROUP_RAID6)
+				 BTRFS_BLOCK_GROUP_PARX)
 
 static int btrfs_rebuild_chunk_stripes(struct recover_control *rc,
 				       struct chunk_record *chunk)
diff --git a/cmds-balance.c b/cmds-balance.c
index a151475..7d116bb 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -48,10 +48,22 @@ static int parse_one_profile(const char *profile, u64 *flags)
 		*flags |= BTRFS_BLOCK_GROUP_RAID1;
 	} else if (!strcmp(profile, "raid10")) {
 		*flags |= BTRFS_BLOCK_GROUP_RAID10;
-	} else if (!strcmp(profile, "raid5")) {
-		*flags |= BTRFS_BLOCK_GROUP_RAID5;
-	} else if (!strcmp(profile, "raid6")) {
-		*flags |= BTRFS_BLOCK_GROUP_RAID6;
+	} else if (!strcmp(profile, "raid5")) { /* synonymous of "par1" */
+		*flags |= BTRFS_BLOCK_GROUP_PAR1;
+	} else if (!strcmp(profile, "raid6")) { /* synonymous of "par2" */
+		*flags |= BTRFS_BLOCK_GROUP_PAR2;
+	} else if (!strcmp(profile, "par1")) {
+		*flags |= BTRFS_BLOCK_GROUP_PAR1;
+	} else if (!strcmp(profile, "par2")) {
+		*flags |= BTRFS_BLOCK_GROUP_PAR2;
+	} else if (!strcmp(profile, "par3")) {
+		*flags |= BTRFS_BLOCK_GROUP_PAR3;
+	} else if (!strcmp(profile, "par4")) {
+		*flags |= BTRFS_BLOCK_GROUP_PAR4;
+	} else if (!strcmp(profile, "par5")) {
+		*flags |= BTRFS_BLOCK_GROUP_PAR5;
+	} else if (!strcmp(profile, "par6")) {
+		*flags |= BTRFS_BLOCK_GROUP_PAR6;
 	} else if (!strcmp(profile, "dup")) {
 		*flags |= BTRFS_BLOCK_GROUP_DUP;
 	} else if (!strcmp(profile, "single")) {
diff --git a/cmds-check.c b/cmds-check.c
index a65670e..46e1a83 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5189,12 +5189,9 @@ u64 calc_stripe_length(u64 type, u64 length, int num_stripes)
 	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
 		stripe_size = length * 2;
 		stripe_size /= num_stripes;
-	} else if (type & BTRFS_BLOCK_GROUP_RAID5) {
+	} else if (type & BTRFS_BLOCK_GROUP_PARX) {
 		stripe_size = length;
-		stripe_size /= (num_stripes - 1);
-	} else if (type & BTRFS_BLOCK_GROUP_RAID6) {
-		stripe_size = length;
-		stripe_size /= (num_stripes - 2);
+		stripe_size /= num_stripes - btrfs_flags_par(type);
 	} else {
 		stripe_size = length;
 	}
diff --git a/cmds-chunk.c b/cmds-chunk.c
index 4d7fce0..b4c067d 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -1347,8 +1347,7 @@ static int calc_num_stripes(u64 type)
 {
 	if (type & (BTRFS_BLOCK_GROUP_RAID0 |
 		    BTRFS_BLOCK_GROUP_RAID10 |
-		    BTRFS_BLOCK_GROUP_RAID5 |
-		    BTRFS_BLOCK_GROUP_RAID6))
+		    BTRFS_BLOCK_GROUP_PARX))
 		return 0;
 	else if (type & (BTRFS_BLOCK_GROUP_RAID1 |
 			 BTRFS_BLOCK_GROUP_DUP))
@@ -1424,13 +1423,8 @@ static int btrfs_calc_stripe_index(struct chunk_record *chunk, u64 logical)
 	} else if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID10) {
 		index = stripe_nr % (chunk->num_stripes / chunk->sub_stripes);
 		index *= chunk->sub_stripes;
-	} else if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID5) {
-		nr_data_stripes = chunk->num_stripes - 1;
-		index = stripe_nr % nr_data_stripes;
-		stripe_nr /= nr_data_stripes;
-		index = (index + stripe_nr) % chunk->num_stripes;
-	} else if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID6) {
-		nr_data_stripes = chunk->num_stripes - 2;
+	} else if (chunk->type_flags & BTRFS_BLOCK_GROUP_PARX) {
+		nr_data_stripes = chunk->num_stripes - btrfs_flags_par(chunk->type_flags);
 		index = stripe_nr % nr_data_stripes;
 		stripe_nr /= nr_data_stripes;
 		index = (index + stripe_nr) % chunk->num_stripes;
@@ -1523,8 +1517,7 @@ no_extent_record:
 	if (list_empty(&devexts))
 		return 0;
 
-	if (chunk->type_flags & (BTRFS_BLOCK_GROUP_RAID5 |
-				 BTRFS_BLOCK_GROUP_RAID6)) {
+	if (chunk->type_flags & BTRFS_BLOCK_GROUP_PARX) {
 		/* Fixme: try to recover the order by the parity block. */
 		list_splice_tail(&devexts, &chunk->dextents);
 		return -EINVAL;
@@ -1560,8 +1553,7 @@ no_extent_record:
 
 #define BTRFS_ORDERED_RAID	(BTRFS_BLOCK_GROUP_RAID0 |	\
 				 BTRFS_BLOCK_GROUP_RAID10 |	\
-				 BTRFS_BLOCK_GROUP_RAID5 |	\
-				 BTRFS_BLOCK_GROUP_RAID6)
+				 BTRFS_BLOCK_GROUP_PARX)
 
 static int btrfs_rebuild_chunk_stripes(struct recover_control *rc,
 				       struct chunk_record *chunk)
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1c1926b..861cbb3 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -142,10 +142,18 @@ static char *group_profile_str(u64 flag)
 		return "RAID0";
 	case BTRFS_BLOCK_GROUP_RAID1:
 		return "RAID1";
-	case BTRFS_BLOCK_GROUP_RAID5:
+	case BTRFS_BLOCK_GROUP_PAR1:
 		return "RAID5";
-	case BTRFS_BLOCK_GROUP_RAID6:
+	case BTRFS_BLOCK_GROUP_PAR2:
 		return "RAID6";
+	case BTRFS_BLOCK_GROUP_PAR3:
+		return "PAR3";
+	case BTRFS_BLOCK_GROUP_PAR4:
+		return "PAR4";
+	case BTRFS_BLOCK_GROUP_PAR5:
+		return "PAR5";
+	case BTRFS_BLOCK_GROUP_PAR6:
+		return "PAR6";
 	case BTRFS_BLOCK_GROUP_DUP:
 		return "DUP";
 	case BTRFS_BLOCK_GROUP_RAID10:
diff --git a/ctree.h b/ctree.h
index 2117374..4d2d1b6 100644
--- a/ctree.h
+++ b/ctree.h
@@ -470,6 +470,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
+#define BTRFS_FEATURE_INCOMPAT_PAR3456		(1ULL << 10)
 
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
@@ -482,7 +483,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
-	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
+	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
+	 BTRFS_FEATURE_INCOMPAT_PAR3456)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -830,8 +832,39 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID1		(1ULL << 4)
 #define BTRFS_BLOCK_GROUP_DUP		(1ULL << 5)
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
-#define BTRFS_BLOCK_GROUP_RAID5    (1ULL << 7)
-#define BTRFS_BLOCK_GROUP_RAID6    (1ULL << 8)
+#define BTRFS_BLOCK_GROUP_PAR1     (1ULL << 7)
+#define BTRFS_BLOCK_GROUP_PAR2     (1ULL << 8)
+#define BTRFS_BLOCK_GROUP_PAR3     (1ULL << 9)
+#define BTRFS_BLOCK_GROUP_PAR4     (1ULL << 10)
+#define BTRFS_BLOCK_GROUP_PAR5     (1ULL << 11)
+#define BTRFS_BLOCK_GROUP_PAR6     (1ULL << 12)
+
+/* tags for all the parity groups */
+#define BTRFS_BLOCK_GROUP_PARX (BTRFS_BLOCK_GROUP_PAR1 | \
+				BTRFS_BLOCK_GROUP_PAR2 | \
+				BTRFS_BLOCK_GROUP_PAR3 | \
+				BTRFS_BLOCK_GROUP_PAR4 | \
+				BTRFS_BLOCK_GROUP_PAR5 | \
+				BTRFS_BLOCK_GROUP_PAR6)
+
+/* gets the parity number from the parity group */
+static inline int btrfs_flags_par(unsigned group)
+{
+	switch (group & BTRFS_BLOCK_GROUP_PARX) {
+	case BTRFS_BLOCK_GROUP_PAR1: return 1;
+	case BTRFS_BLOCK_GROUP_PAR2: return 2;
+	case BTRFS_BLOCK_GROUP_PAR3: return 3;
+	case BTRFS_BLOCK_GROUP_PAR4: return 4;
+	case BTRFS_BLOCK_GROUP_PAR5: return 5;
+	case BTRFS_BLOCK_GROUP_PAR6:  return 6;
+	}
+
+	/* ensures that no multiple groups are defined */
+	BUG_ON(group & BTRFS_BLOCK_GROUP_PARX);
+
+	return 0;
+}
+
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
 
 #define BTRFS_BLOCK_GROUP_TYPE_MASK	(BTRFS_BLOCK_GROUP_DATA |    \
@@ -840,8 +873,7 @@ struct btrfs_csum_item {
 
 #define BTRFS_BLOCK_GROUP_PROFILE_MASK	(BTRFS_BLOCK_GROUP_RAID0 |   \
 					 BTRFS_BLOCK_GROUP_RAID1 |   \
-					 BTRFS_BLOCK_GROUP_RAID5 |   \
-					 BTRFS_BLOCK_GROUP_RAID6 |   \
+					 BTRFS_BLOCK_GROUP_PARX |   \
 					 BTRFS_BLOCK_GROUP_DUP |     \
 					 BTRFS_BLOCK_GROUP_RAID10)
 
diff --git a/disk-io.h b/disk-io.h
index ca6af2d..27e3dc4 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -110,5 +110,3 @@ int write_and_map_eb(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		     struct extent_buffer *eb);
 #endif
 
-/* raid6.c */
-void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
diff --git a/extent-tree.c b/extent-tree.c
index 7860d1d..98a8cb4 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1862,8 +1862,7 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 	u64 extra_flags = flags & (BTRFS_BLOCK_GROUP_RAID0 |
 				   BTRFS_BLOCK_GROUP_RAID1 |
 				   BTRFS_BLOCK_GROUP_RAID10 |
-				   BTRFS_BLOCK_GROUP_RAID5 |
-				   BTRFS_BLOCK_GROUP_RAID6 |
+				   BTRFS_BLOCK_GROUP_PARX |
 				   BTRFS_BLOCK_GROUP_DUP);
 	if (extra_flags) {
 		if (flags & BTRFS_BLOCK_GROUP_DATA)
diff --git a/ioctl.h b/ioctl.h
index a589cd7..f798d22 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -466,7 +466,11 @@ enum btrfs_err_code {
 	BTRFS_ERROR_DEV_TGT_REPLACE,
 	BTRFS_ERROR_DEV_MISSING_NOT_FOUND,
 	BTRFS_ERROR_DEV_ONLY_WRITABLE,
-	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS
+	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS,
+	BTRFS_ERROR_DEV_PAR3_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_PAR4_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_PAR5_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_PAR6_MIN_NOT_MET
 };
 
 /* An error code to error string mapping for the kernel
@@ -480,9 +484,9 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 		case BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET:
 			return "unable to go below four devices on raid10";
 		case BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET:
-			return "unable to go below three devices on raid5";
+			return "unable to go below two devices on raid5/par1";
 		case BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET:
-			return "unable to go below four devices on raid6";
+			return "unable to go below three devices on raid6/par2";
 		case BTRFS_ERROR_DEV_TGT_REPLACE:
 			return "unable to remove the dev_replace target dev";
 		case BTRFS_ERROR_DEV_MISSING_NOT_FOUND:
@@ -492,6 +496,14 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 		case BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS:
 			return "add/delete/balance/replace/resize operation "
 				"in progress";
+		case BTRFS_ERROR_DEV_PAR3_MIN_NOT_MET:
+			return "unable to go below four devices on par3";
+		case BTRFS_ERROR_DEV_PAR4_MIN_NOT_MET:
+			return "unable to go below five devices on par4";
+		case BTRFS_ERROR_DEV_PAR5_MIN_NOT_MET:
+			return "unable to go below six devices on par5";
+		case BTRFS_ERROR_DEV_PAR6_MIN_NOT_MET:
+			return "unable to go below seven devices on par5";
 		default:
 			return NULL;
 	}
diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index b54e935..e3f4ec7 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -38,7 +38,9 @@ mkfs.btrfs uses all the available storage for the filesystem.
 .TP
 \fB\-d\fR, \fB\-\-data \fItype\fR
 Specify how the data must be spanned across the devices specified. Valid
-values are raid0, raid1, raid5, raid6, raid10 or single.
+values are raid0, raid1, raid5, raid6, raid10, par1, par2, par3, par4, par5,
+par6 or single. The parX values enable RAID for up to six parity levels.
+Note that raid5 and raid6 are synonymous of par1 and par2.
 .TP
 \fB\-f\fR, \fB\-\-force\fR
 Force overwrite when an existing filesystem is detected on the device.
diff --git a/mkfs.c b/mkfs.c
index 33369f9..661e59f 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -276,7 +276,7 @@ static void print_usage(void)
 	fprintf(stderr, "options:\n");
 	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
-	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid5, raid6, raid10, dup or single\n");
+	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid5, raid6, par[1,2,3,4,5,6], raid10, dup or single\n");
 	fprintf(stderr, "\t -f --force force overwrite of existing filesystem\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
 	fprintf(stderr, "\t -L --label set a label\n");
@@ -306,9 +306,21 @@ static u64 parse_profile(char *s)
 	} else if (strcmp(s, "raid1") == 0) {
 		return BTRFS_BLOCK_GROUP_RAID1;
 	} else if (strcmp(s, "raid5") == 0) {
-		return BTRFS_BLOCK_GROUP_RAID5;
+		return BTRFS_BLOCK_GROUP_PAR1;
 	} else if (strcmp(s, "raid6") == 0) {
-		return BTRFS_BLOCK_GROUP_RAID6;
+		return BTRFS_BLOCK_GROUP_PAR2;
+	} else if (strcmp(s, "par1") == 0) {
+		return BTRFS_BLOCK_GROUP_PAR1;
+	} else if (strcmp(s, "par2") == 0) {
+		return BTRFS_BLOCK_GROUP_PAR2;
+	} else if (strcmp(s, "par3") == 0) {
+		return BTRFS_BLOCK_GROUP_PAR3;
+	} else if (strcmp(s, "par4") == 0) {
+		return BTRFS_BLOCK_GROUP_PAR4;
+	} else if (strcmp(s, "par5") == 0) {
+		return BTRFS_BLOCK_GROUP_PAR5;
+	} else if (strcmp(s, "par6") == 0) {
+		return BTRFS_BLOCK_GROUP_PAR6;
 	} else if (strcmp(s, "raid10") == 0) {
 		return BTRFS_BLOCK_GROUP_RAID10;
 	} else if (strcmp(s, "dup") == 0) {
@@ -1147,6 +1159,8 @@ static const struct btrfs_fs_feature {
 		"raid56 extended format" },
 	{ "skinny-metadata", BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA,
 		"reduced-size metadata extent refs" },
+	{ "par3456", BTRFS_FEATURE_INCOMPAT_PAR3456,
+		"raid support with up to six parities" },
 	/* Keep this one last */
 	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
 };
@@ -1491,10 +1505,16 @@ int main(int ac, char **av)
 		features |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
 
 	if ((data_profile | metadata_profile) &
-	    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
+		(BTRFS_BLOCK_GROUP_PAR1 | BTRFS_BLOCK_GROUP_PAR2)) {
 		features |= BTRFS_FEATURE_INCOMPAT_RAID56;
 	}
 
+	if ((data_profile | metadata_profile) &
+		(BTRFS_BLOCK_GROUP_PAR3 | BTRFS_BLOCK_GROUP_PAR4
+		 | BTRFS_BLOCK_GROUP_PAR5 | BTRFS_BLOCK_GROUP_PAR6)) {
+		features |= BTRFS_FEATURE_INCOMPAT_PAR3456;
+	}
+
 	process_fs_features(features);
 
 	ret = make_btrfs(fd, file, label, blocks, dev_block_count,
diff --git a/mktables.c b/mktables.c
new file mode 100644
index 0000000..21c0222
--- /dev/null
+++ b/mktables.c
@@ -0,0 +1,256 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+
+/**
+ * Multiplication a*b in GF(2^8).
+ */
+static uint8_t gfmul(uint8_t a, uint8_t b)
+{
+	uint8_t v;
+
+	v = 0;
+	while (b)  {
+		if ((b & 1) != 0)
+			v ^= a;
+
+		if ((a & 0x80) != 0) {
+			a <<= 1;
+			a ^= 0x1d;
+		} else {
+			a <<= 1;
+		}
+
+		b >>= 1;
+	}
+
+	return v;
+}
+
+/**
+ * Inversion (1/a) in GF(2^8).
+ */
+uint8_t gfinv[256];
+
+/**
+ * Number of parities.
+ * This is the number of rows of the generator matrix.
+ */
+#define PARITY 6
+
+/**
+ * Number of disks.
+ * This is the number of columns of the generator matrix.
+ */
+#define DISK (257-PARITY)
+
+/**
+ * Setup the Cauchy matrix used to generate the parity.
+ */
+static void set_cauchy(uint8_t *matrix)
+{
+	int i, j;
+	uint8_t inv_x, y;
+
+	/*
+	 * The first row of the generator matrix is formed by all 1.
+	 *
+	 * The generator matrix is an Extended Cauchy matrix built from
+	 * a Cauchy matrix adding at the top a row of all 1.
+	 *
+	 * Extending a Cauchy matrix in this way maintains the MDS property
+	 * of the matrix.
+	 *
+	 * For example, considering a generator matrix of 4x6 we have now:
+	 *
+	 *   1   1   1   1   1   1
+	 *   -   -   -   -   -   -
+	 *   -   -   -   -   -   -
+	 *   -   -   -   -   -   -
+	 */
+	for (i = 0; i < DISK; ++i)
+		matrix[0*DISK+i] = 1;
+
+	/*
+	 * Second row is formed with powers 2^i, and it's the first
+	 * row of the Cauchy matrix.
+	 *
+	 * Each element of the Cauchy matrix is in the form 1/(x_i + y_j)
+	 * where all x_i and y_j must be different for any i and j.
+	 *
+	 * For the first row with j=0, we choose x_i = 2^-i and y_0 = 0
+	 * and we obtain a first row formed as:
+	 *
+	 * 1/(x_i + y_0) = 1/(2^-i + 0) = 2^i
+	 *
+	 * with 2^-i != 0 for any i
+	 *
+	 * In the example we get:
+	 *
+	 * x_0 = 1
+	 * x_1 = 142
+	 * x_2 = 71
+	 * x_3 = 173
+	 * x_4 = 216
+	 * x_5 = 108
+	 * y_0 = 0
+	 *
+	 * with the matrix:
+	 *
+	 *   1   1   1   1   1   1
+	 *   1   2   4   8  16  32
+	 *   -   -   -   -   -   -
+	 *   -   -   -   -   -   -
+	 */
+	inv_x = 1;
+	for (i = 0; i < DISK; ++i) {
+		matrix[1*DISK+i] = inv_x;
+		inv_x = gfmul(2, inv_x);
+	}
+
+	/*
+	 * The rest of the Cauchy matrix is formed choosing for each row j
+	 * a new y_j = 2^j and reusing the x_i already assigned in the first
+	 * row obtaining :
+	 *
+	 * 1/(x_i + y_j) = 1/(2^-i + 2^j)
+	 *
+	 * with 2^-i + 2^j != 0 for any i,j with i>=0,j>=1,i+j<255
+	 *
+	 * In the example we get:
+	 *
+	 * y_1 = 2
+	 * y_2 = 4
+	 *
+	 * with the matrix:
+	 *
+	 *   1   1   1   1   1   1
+	 *   1   2   4   8  16  32
+	 * 244  83  78 183 118  47
+	 * 167  39 213  59 153  82
+	 */
+	y = 2;
+	for (j = 0; j < PARITY-2; ++j) {
+		inv_x = 1;
+		for (i = 0; i < DISK; ++i) {
+			uint8_t x = gfinv[inv_x];
+			matrix[(j+2)*DISK+i] = gfinv[y ^ x];
+			inv_x = gfmul(2, inv_x);
+		}
+
+		y = gfmul(2, y);
+	}
+
+	/*
+	 * Finally we adjust the matrix multipling each row for
+	 * the inverse of the first element in the row.
+	 *
+	 * Also this operation maintains the MDS property of the matrix.
+	 *
+	 * Resulting in:
+	 *
+	 *   1   1   1   1   1   1
+	 *   1   2   4   8  16  32
+	 *   1 245 210 196 154 113
+	 *   1 187 166 215   7 106
+	 */
+	for (j = 0; j < PARITY-2; ++j) {
+		uint8_t f = gfinv[matrix[(j+2)*DISK]];
+
+		for (i = 0; i < DISK; ++i)
+			matrix[(j+2)*DISK+i] = gfmul(matrix[(j+2)*DISK+i], f);
+	}
+}
+
+int main(void)
+{
+	uint8_t v;
+	int i, j, p;
+	uint8_t matrix[PARITY * 256];
+
+	printf("/*\n");
+	printf(" * Copyright (C) 2013 Andrea Mazzoleni\n");
+	printf(" *\n");
+	printf(" * This program is free software: you can redistribute it and/or modify\n");
+	printf(" * it under the terms of the GNU General Public License as published by\n");
+	printf(" * the Free Software Foundation, either version 2 of the License, or\n");
+	printf(" * (at your option) any later version.\n");
+	printf(" *\n");
+	printf(" * This program is distributed in the hope that it will be useful,\n");
+	printf(" * but WITHOUT ANY WARRANTY; without even the implied warranty of\n");
+	printf(" * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n");
+	printf(" * GNU General Public License for more details.\n");
+	printf(" */\n");
+	printf("\n");
+
+	printf("#include \"kerncompat.h\"\n");
+	printf("\n");
+
+	/* a*b */
+	printf("const u8 raid_gfmul[256][256] =\n");
+	printf("{\n");
+	for (i = 0; i < 256; ++i) {
+		printf("\t{\n");
+		for (j = 0; j < 256; ++j) {
+			if (j % 8 == 0)
+				printf("\t\t");
+			v = gfmul(i, j);
+			if (v == 1)
+				gfinv[i] = j;
+			printf("0x%02x,", (unsigned)v);
+			if (j % 8 == 7)
+				printf("\n");
+			else
+				printf(" ");
+		}
+		printf("\t},\n");
+	}
+	printf("};\n\n");
+
+	/* cauchy matrix */
+	set_cauchy(matrix);
+
+	printf("/**\n");
+	printf(" * Cauchy matrix used to generate parity.\n");
+	printf(" * This matrix is valid for up to %u parity with %u data disks.\n", PARITY, DISK);
+	printf(" *\n");
+	for (p = 0; p < PARITY; ++p) {
+		printf(" * ");
+		for (i = 0; i < DISK; ++i)
+			printf("%02x ", matrix[p*DISK+i]);
+		printf("\n");
+	}
+	printf(" */\n");
+	printf("const u8 raid_gfcauchy[%u][256] =\n", PARITY);
+	printf("{\n");
+	for (p = 0; p < PARITY; ++p) {
+		printf("\t{\n");
+		for (i = 0; i < DISK; ++i) {
+			if (i % 8 == 0)
+				printf("\t\t");
+			printf("0x%02x,", matrix[p*DISK+i]);
+			if (i % 8 == 7)
+				printf("\n");
+			else
+				printf(" ");
+		}
+		printf("\n\t},\n");
+	}
+	printf("};\n\n");
+
+	return 0;
+}
+
diff --git a/raid.c b/raid.c
new file mode 100644
index 0000000..2aa275e
--- /dev/null
+++ b/raid.c
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "raid.h"
+
+/* tables defined in tables.c */
+const u8 raid_gfmul[256][256];
+const u8 raid_gfcauchy[6][256];
+
+void raid_gen(int nd, int np, size_t size, void **vv)
+{
+	u8 **v = (u8 **)vv;
+	size_t i;
+
+	for (i = 0; i < size; ++i) {
+		u8 p[RAID_PARITY_MAX];
+		int j, d;
+
+		for (j = 0; j < np; ++j)
+			p[j] = 0;
+
+		for (d = 0; d < nd; ++d) {
+			u8 b = v[d][i];
+
+			for (j = 0; j < np; ++j)
+				p[j] ^= raid_gfmul[b][raid_gfcauchy[j][d]];
+		}
+
+		for (j = 0; j < np; ++j)
+			v[nd + j][i] = p[j];
+	}
+}
+
diff --git a/raid.h b/raid.h
new file mode 100644
index 0000000..83f8b25
--- /dev/null
+++ b/raid.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __RAID_H
+#define __RAID_H
+
+#include "kerncompat.h"
+
+/*
+ * Max number of parities supported.
+ */
+#define RAID_PARITY_MAX 6
+
+/*
+ * Generate the RAID Cauchy parity.
+ *
+ * Note that this is the slow reference implementation.
+ * For a faster one and documentation see lib/raid/raid.c in the Linux Kernel.
+ */
+void raid_gen(int nd, int np, size_t size, void **vv);
+
+#endif
+
diff --git a/raid6.c b/raid6.c
deleted file mode 100644
index a6ee483..0000000
--- a/raid6.c
+++ /dev/null
@@ -1,101 +0,0 @@
-/* -*- linux-c -*- ------------------------------------------------------- *
- *
- *   Copyright 2002-2004 H. Peter Anvin - All Rights Reserved
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License as published by
- *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Boston MA 02111-1307, USA; either version 2 of the License, or
- *   (at your option) any later version; incorporated herein by reference.
- *
- * ----------------------------------------------------------------------- */
-
-/*
- * raid6int1.c
- *
- * 1-way unrolled portable integer math RAID-6 instruction set
- *
- * This file was postprocessed using unroll.pl and then ported to userspace
- */
-#include <stdint.h>
-#include <unistd.h>
-#include "kerncompat.h"
-#include "ctree.h"
-#include "disk-io.h"
-
-/*
- * This is the C data type to use
- */
-
-/* Change this from BITS_PER_LONG if there is something better... */
-#if BITS_PER_LONG == 64
-# define NBYTES(x) ((x) * 0x0101010101010101UL)
-# define NSIZE  8
-# define NSHIFT 3
-typedef uint64_t unative_t;
-#else
-# define NBYTES(x) ((x) * 0x01010101U)
-# define NSIZE  4
-# define NSHIFT 2
-typedef uint32_t unative_t;
-#endif
-
-/*
- * These sub-operations are separate inlines since they can sometimes be
- * specially optimized using architecture-specific hacks.
- */
-
-/*
- * The SHLBYTE() operation shifts each byte left by 1, *not*
- * rolling over into the next byte
- */
-static inline __attribute_const__ unative_t SHLBYTE(unative_t v)
-{
-	unative_t vv;
-
-	vv = (v << 1) & NBYTES(0xfe);
-	return vv;
-}
-
-/*
- * The MASK() operation returns 0xFF in any byte for which the high
- * bit is 1, 0x00 for any byte for which the high bit is 0.
- */
-static inline __attribute_const__ unative_t MASK(unative_t v)
-{
-	unative_t vv;
-
-	vv = v & NBYTES(0x80);
-	vv = (vv << 1) - (vv >> 7); /* Overflow on the top bit is OK */
-	return vv;
-}
-
-
-void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs)
-{
-	uint8_t **dptr = (uint8_t **)ptrs;
-	uint8_t *p, *q;
-	int d, z, z0;
-
-	unative_t wd0, wq0, wp0, w10, w20;
-
-	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
-
-	for ( d = 0 ; d < bytes ; d += NSIZE*1 ) {
-		wq0 = wp0 = *(unative_t *)&dptr[z0][d+0*NSIZE];
-		for ( z = z0-1 ; z >= 0 ; z-- ) {
-			wd0 = *(unative_t *)&dptr[z][d+0*NSIZE];
-			wp0 ^= wd0;
-			w20 = MASK(wq0);
-			w10 = SHLBYTE(wq0);
-			w20 &= NBYTES(0x1d);
-			w10 ^= w20;
-			wq0 = w10 ^ wd0;
-		}
-		*(unative_t *)&p[d+NSIZE*0] = wp0;
-		*(unative_t *)&q[d+NSIZE*0] = wq0;
-	}
-}
-
diff --git a/utils.c b/utils.c
index f499023..52b090b 100644
--- a/utils.c
+++ b/utils.c
@@ -1856,13 +1856,19 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 
 	switch (dev_cnt) {
 	default:
+	case 7:
+		allowed |= BTRFS_BLOCK_GROUP_PAR6;
+	case 6:
+		allowed |= BTRFS_BLOCK_GROUP_PAR5;
+	case 5:
+		allowed |= BTRFS_BLOCK_GROUP_PAR4;
 	case 4:
-		allowed |= BTRFS_BLOCK_GROUP_RAID10;
+		allowed |= BTRFS_BLOCK_GROUP_RAID10 | BTRFS_BLOCK_GROUP_PAR3;
 	case 3:
-		allowed |= BTRFS_BLOCK_GROUP_RAID6;
+		allowed |= BTRFS_BLOCK_GROUP_PAR2;
 	case 2:
 		allowed |= BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
-			BTRFS_BLOCK_GROUP_RAID5;
+			BTRFS_BLOCK_GROUP_PAR1;
 		break;
 	case 1:
 		allowed |= BTRFS_BLOCK_GROUP_DUP;
diff --git a/volumes.c b/volumes.c
index c38da6c..b1fb7de 100644
--- a/volumes.c
+++ b/volumes.c
@@ -30,6 +30,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "math.h"
+#include "raid.h"
 
 struct stripe {
 	struct btrfs_device *dev;
@@ -38,12 +39,7 @@ struct stripe {
 
 static inline int nr_parity_stripes(struct map_lookup *map)
 {
-	if (map->type & BTRFS_BLOCK_GROUP_RAID5)
-		return 1;
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
-		return 2;
-	else
-		return 0;
+	return btrfs_flags_par(map->type);
 }
 
 static inline int nr_data_stripes(struct map_lookup *map)
@@ -51,8 +47,6 @@ static inline int nr_data_stripes(struct map_lookup *map)
 	return map->num_stripes - nr_parity_stripes(map);
 }
 
-#define is_parity_stripe(x) ( ((x) == BTRFS_RAID5_P_STRIPE) || ((x) == BTRFS_RAID6_Q_STRIPE) )
-
 static LIST_HEAD(fs_uuids);
 
 static struct btrfs_device *__find_device(struct list_head *head, u64 devid,
@@ -643,10 +637,8 @@ static u64 chunk_bytes_by_type(u64 type, u64 calc_size, int num_stripes,
 		return calc_size;
 	else if (type & BTRFS_BLOCK_GROUP_RAID10)
 		return calc_size * (num_stripes / sub_stripes);
-	else if (type & BTRFS_BLOCK_GROUP_RAID5)
-		return calc_size * (num_stripes - 1);
-	else if (type & BTRFS_BLOCK_GROUP_RAID6)
-		return calc_size * (num_stripes - 2);
+	else if (type & BTRFS_BLOCK_GROUP_PARX)
+		return calc_size * (num_stripes - btrfs_flags_par(type));
 	else
 		return calc_size * num_stripes;
 }
@@ -782,7 +774,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	}
 
 	if (type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
-		    BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
+		    BTRFS_BLOCK_GROUP_PARX |
 		    BTRFS_BLOCK_GROUP_RAID10 |
 		    BTRFS_BLOCK_GROUP_DUP)) {
 		if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
@@ -822,20 +814,13 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		sub_stripes = 2;
 		min_stripes = 4;
 	}
-	if (type & (BTRFS_BLOCK_GROUP_RAID5)) {
-		num_stripes = btrfs_super_num_devices(info->super_copy);
-		if (num_stripes < 2)
-			return -ENOSPC;
-		min_stripes = 2;
-		stripe_len = find_raid56_stripe_len(num_stripes - 1,
-				    btrfs_super_stripesize(info->super_copy));
-	}
-	if (type & (BTRFS_BLOCK_GROUP_RAID6)) {
+	if (type & BTRFS_BLOCK_GROUP_PARX) {
+		min_stripes = 1 + btrfs_flags_par(type);
 		num_stripes = btrfs_super_num_devices(info->super_copy);
-		if (num_stripes < 3)
+		if (num_stripes < min_stripes)
 			return -ENOSPC;
-		min_stripes = 3;
-		stripe_len = find_raid56_stripe_len(num_stripes - 2,
+
+		stripe_len = find_raid56_stripe_len(num_stripes - btrfs_flags_par(type),
 				    btrfs_super_stripesize(info->super_copy));
 	}
 
@@ -1107,10 +1092,8 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 		ret = map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
 		ret = map->sub_stripes;
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID5)
-		ret = 2;
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
-		ret = 3;
+	else if (map->type & BTRFS_BLOCK_GROUP_PARX)
+		ret = 1 + btrfs_flags_par(map->type);
 	else
 		ret = 1;
 	return ret;
@@ -1163,8 +1146,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		length = ce->size / (map->num_stripes / map->sub_stripes);
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID0)
 		length = ce->size / map->num_stripes;
-	else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
-			      BTRFS_BLOCK_GROUP_RAID6)) {
+	else if (map->type & BTRFS_BLOCK_GROUP_PARX) {
 		length = ce->size / nr_data_stripes(map);
 		rmap_len = map->stripe_len * nr_data_stripes(map);
 	}
@@ -1294,9 +1276,9 @@ again:
 			stripes_required = map->sub_stripes;
 		}
 	}
-	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)
+	if ((map->type & BTRFS_BLOCK_GROUP_PARX)
 	    && multi_ret && ((rw & WRITE) || mirror_num > 1) && raid_map_ret) {
-		    /* RAID[56] write or recovery. Return all stripes */
+		    /* PAR write or recovery. Return all stripes */
 		    stripes_required = map->num_stripes;
 
 		    /* Only allocate the map if we've already got a large enough multi_ret */
@@ -1330,7 +1312,7 @@ again:
 	stripe_offset = offset - stripe_offset;
 
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
-			 BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
+			 BTRFS_BLOCK_GROUP_PARX |
 			 BTRFS_BLOCK_GROUP_RAID10 |
 			 BTRFS_BLOCK_GROUP_DUP)) {
 		/* we limit the length of each bio to what fits in a stripe */
@@ -1369,14 +1351,14 @@ again:
 			multi->num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
-	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
-				BTRFS_BLOCK_GROUP_RAID6)) {
+	} else if (map->type & BTRFS_BLOCK_GROUP_PARX) {
 
 		if (raid_map) {
 			int rot;
 			u64 tmp;
 			u64 raid56_full_stripe_start;
 			u64 full_stripe_len = nr_data_stripes(map) * map->stripe_len;
+			int j;
 
 			/*
 			 * align the start of our data stripe in the logical
@@ -1399,9 +1381,8 @@ again:
 				raid_map[(i+rot) % map->num_stripes] =
 					ce->start + (tmp + i) * map->stripe_len;
 
-			raid_map[(i+rot) % map->num_stripes] = BTRFS_RAID5_P_STRIPE;
-			if (map->type & BTRFS_BLOCK_GROUP_RAID6)
-				raid_map[(i+rot+1) % map->num_stripes] = BTRFS_RAID6_Q_STRIPE;
+			for (j = 0; j < btrfs_flags_par(map->type); j++)
+				raid_map[(i+rot+j) % map->num_stripes] = BTRFS_RAID_PAR1_STRIPE + j;
 
 			*length = map->stripe_len;
 			stripe_index = 0;
@@ -1413,8 +1394,9 @@ again:
 
 			/*
 			 * Mirror #0 or #1 means the original data block.
-			 * Mirror #2 is RAID5 parity block.
-			 * Mirror #3 is RAID6 Q block.
+			 * Mirror #2 is RAID5/PAR1 P block.
+			 * Mirror #3 is RAID6/PAR2 Q block.
+			 * .. and so on up to PAR6
 			 */
 			if (mirror_num > 1)
 				stripe_index = nr_data_stripes(map) + mirror_num - 2;
@@ -1838,7 +1820,7 @@ static void split_eb_for_raid56(struct btrfs_fs_info *info,
 	int ret;
 
 	for (i = 0; i < num_stripes; i++) {
-		if (raid_map[i] >= BTRFS_RAID5_P_STRIPE)
+		if (raid_map[i] >= BTRFS_RAID_PAR1_STRIPE)
 			break;
 
 		eb = malloc(sizeof(struct extent_buffer) + stripe_len);
@@ -1871,11 +1853,13 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			     struct btrfs_multi_bio *multi,
 			     u64 stripe_len, u64 *raid_map)
 {
-	struct extent_buffer **ebs, *p_eb = NULL, *q_eb = NULL;
+	struct extent_buffer **ebs;
+	struct extent_buffer *p_eb[RAID_PARITY_MAX];
 	int i;
 	int j;
 	int ret;
 	int alloc_size = eb->len;
+	int np;
 
 	ebs = kmalloc(sizeof(*ebs) * multi->num_stripes, GFP_NOFS);
 	BUG_ON(!ebs);
@@ -1883,12 +1867,16 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 	if (stripe_len > alloc_size)
 		alloc_size = stripe_len;
 
+	np = 0;
+	for (i = 0; i < RAID_PARITY_MAX; i++)
+		p_eb[i] = NULL;
+
 	split_eb_for_raid56(info, eb, ebs, stripe_len, raid_map,
 			    multi->num_stripes);
 
 	for (i = 0; i < multi->num_stripes; i++) {
 		struct extent_buffer *new_eb;
-		if (raid_map[i] < BTRFS_RAID5_P_STRIPE) {
+		if (raid_map[i] < BTRFS_RAID_PAR1_STRIPE) {
 			ebs[i]->dev_bytenr = multi->stripes[i].physical;
 			ebs[i]->fd = multi->stripes[i].dev->fd;
 			multi->stripes[i].dev->total_ios++;
@@ -1902,35 +1890,33 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 		multi->stripes[i].dev->total_ios++;
 		new_eb->len = stripe_len;
 
-		if (raid_map[i] == BTRFS_RAID5_P_STRIPE)
-			p_eb = new_eb;
-		else if (raid_map[i] == BTRFS_RAID6_Q_STRIPE)
-			q_eb = new_eb;
+		/* parity index */
+		j = raid_map[i] - BTRFS_RAID_PAR1_STRIPE;
+
+		BUG_ON(j < 0 || j >= RAID_PARITY_MAX);
+
+		p_eb[j] = new_eb;
+
+		/* keep track of the number of parities used */
+		if (j + 1 > np)
+			np = j + 1;
 	}
-	if (q_eb) {
+
+	if (np != 0) {
 		void **pointers;
 
-		pointers = kmalloc(sizeof(*pointers) * multi->num_stripes,
-				   GFP_NOFS);
+		pointers = kmalloc(sizeof(*pointers) * multi->num_stripes, GFP_NOFS);
 		BUG_ON(!pointers);
 
-		ebs[multi->num_stripes - 2] = p_eb;
-		ebs[multi->num_stripes - 1] = q_eb;
+		for (i = 0; i < np; i++)
+			ebs[multi->num_stripes - np + i] = p_eb[i];
 
 		for (i = 0; i < multi->num_stripes; i++)
 			pointers[i] = ebs[i]->data;
 
-		raid6_gen_syndrome(multi->num_stripes, stripe_len, pointers);
+		raid_gen(multi->num_stripes - np, np, stripe_len, pointers);
+
 		kfree(pointers);
-	} else {
-		ebs[multi->num_stripes - 1] = p_eb;
-		memcpy(p_eb->data, ebs[0]->data, stripe_len);
-		for (j = 1; j < multi->num_stripes - 1; j++) {
-			for (i = 0; i < stripe_len; i += sizeof(unsigned long)) {
-				*(unsigned long *)(p_eb->data + i) ^=
-					*(unsigned long *)(ebs[j]->data + i);
-			}
-		}
 	}
 
 	for (i = 0; i < multi->num_stripes; i++) {
diff --git a/volumes.h b/volumes.h
index 2802cb0..0a73084 100644
--- a/volumes.h
+++ b/volumes.h
@@ -137,9 +137,15 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_CONVERT	(1ULL << 8)
 #define BTRFS_BALANCE_ARGS_SOFT		(1ULL << 9)
 
-#define BTRFS_RAID5_P_STRIPE ((u64)-2)
-#define BTRFS_RAID6_Q_STRIPE ((u64)-1)
-
+/*
+ * Parity stripe indexes.
+ */
+#define BTRFS_RAID_PAR1_STRIPE ((u64)-6)
+#define BTRFS_RAID_PAR2_STRIPE ((u64)-5)
+#define BTRFS_RAID_PAR3_STRIPE ((u64)-4)
+#define BTRFS_RAID_PAR4_STRIPE ((u64)-3)
+#define BTRFS_RAID_PAR5_STRIPE ((u64)-2)
+#define BTRFS_RAID_PAR6_STRIPE ((u64)-1)
 
 int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		      u64 logical, u64 *length, u64 *type,
-- 
1.7.12.1

