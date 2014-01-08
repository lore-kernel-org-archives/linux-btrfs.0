Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48695 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbaAHVvA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 16:51:00 -0500
From: "Timothy Pepper" <timothy.c.pepper@linux.intel.com>
Date: Wed, 8 Jan 2014 13:50:58 -0800
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] Btrfs-progs: Add optional 'uuid' parameter to mkfs.btrfs
Message-ID: <20140108215058.GA31124@tcpepper-desk.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch below is a simple quick attempt at allowing the filesystem
UUID to be specified by the user at mkfs time.  Googling around I've
seen a lot of people wishing they could "change their btrfs uuid".
I understand why that's not going to happen.  But this little patch
seems like it could give them a control somewhat equivalent to what
they're seeking.  It works for me anyway, so I thought I'd share it in
case it is upstream acceptable and useful to others.

--
Tim Pepper <timothy.c.pepper@linux.intel.com>
Intel Open Source Technology Center

==============================================================================

From: Tim Pepper <timothy.c.pepper@linux.intel.com>
Date: Wed, 8 Jan 2014 11:20:26 -0800
Subject: [PATCH] Add optional 'uuid' parameter to mkfs.btrfs

Currently the code supports specifying a label, but not UUID.  Since the
UUID of a btrfs filesystem can't be modified after the filesystem is made,
it is useful to support specifying the UUID when the filesystem is made.

Signed-off-by: Tim Pepper <timothy.c.pepper@linux.intel.com>
---
 btrfs-convert.c |  2 +-
 mkfs.c          | 23 +++++++++++++++++++++--
 utils.c         |  7 +++++--
 utils.h         |  2 +-
 4 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index ae10eed..7ec1ac5 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2242,7 +2242,7 @@ static int do_convert(const char *devname, int datacsum, int packing,
 		fprintf(stderr, "unable to open %s\n", devname);
 		goto fail;
 	}
-	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
+	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name, NULL,
 			 blocks, total_bytes, blocksize, blocksize,
 			 blocksize, blocksize, 0);
 	if (ret) {
diff --git a/mkfs.c b/mkfs.c
index 33369f9..d5e65d9 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -280,6 +280,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -f --force force overwrite of existing filesystem\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
 	fprintf(stderr, "\t -L --label set a label\n");
+	fprintf(stderr, "\t -U --uuid set a UUID\n");
 	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
 	fprintf(stderr, "\t -M --mixed mix metadata and data together\n");
 	fprintf(stderr, "\t -n --nodesize size of btree nodes\n");
@@ -335,12 +336,25 @@ static char *parse_label(char *input)
 	return strdup(input);
 }
 
+static char *parse_uuid(char *input)
+{
+	int len = strlen(input);
+#define	BTRFS_UUID_STRING_SIZE	(2*BTRFS_UUID_SIZE + 5)
+	if (len >= BTRFS_UUID_STRING_SIZE) {
+		fprintf(stderr, "UUID %s is too long (max %d)\n", input,
+			BTRFS_UUID_STRING_SIZE - 1);
+		exit(1);
+	}
+	return strdup(input);
+}
+
 static struct option long_options[] = {
 	{ "alloc-start", 1, NULL, 'A'},
 	{ "byte-count", 1, NULL, 'b' },
 	{ "force", 0, NULL, 'f' },
 	{ "leafsize", 1, NULL, 'l' },
 	{ "label", 1, NULL, 'L'},
+	{ "uuid", 1, NULL, 'U'},
 	{ "metadata", 1, NULL, 'm' },
 	{ "mixed", 0, NULL, 'M' },
 	{ "nodesize", 1, NULL, 'n' },
@@ -1228,6 +1242,7 @@ int main(int ac, char **av)
 	struct btrfs_root *root;
 	struct btrfs_trans_handle *trans;
 	char *label = NULL;
+	char *uuid = NULL;
 	char *first_file;
 	u64 block_count = 0;
 	u64 dev_block_count = 0;
@@ -1264,7 +1279,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:VMK",
+		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:U:O:r:VMK",
 				long_options, &option_index);
 		if (c < 0)
 			break;
@@ -1288,6 +1303,9 @@ int main(int ac, char **av)
 			case 'L':
 				label = parse_label(optarg);
 				break;
+			case 'U':
+				uuid = parse_uuid(optarg);
+				break;
 			case 'm':
 				metadata_profile = parse_profile(optarg);
 				metadata_profile_opt = 1;
@@ -1497,7 +1515,7 @@ int main(int ac, char **av)
 
 	process_fs_features(features);
 
-	ret = make_btrfs(fd, file, label, blocks, dev_block_count,
+	ret = make_btrfs(fd, file, label, uuid, blocks, dev_block_count,
 			 nodesize, leafsize,
 			 sectorsize, stripesize, features);
 	if (ret) {
@@ -1595,5 +1613,6 @@ raid_groups:
 	ret = close_ctree(root);
 	BUG_ON(ret);
 	free(label);
+	free(uuid);
 	return 0;
 }
diff --git a/utils.c b/utils.c
index f499023..4b85eeb 100644
--- a/utils.c
+++ b/utils.c
@@ -71,7 +71,7 @@ static u64 reference_root_table[] = {
 	[6] =	BTRFS_CSUM_TREE_OBJECTID,
 };
 
-int make_btrfs(int fd, const char *device, const char *label,
+int make_btrfs(int fd, const char *device, const char *label, const char *uuid,
 	       u64 blocks[7], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features)
 {
@@ -103,7 +103,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	memset(&super, 0, sizeof(super));
 
 	num_bytes = (num_bytes / sectorsize) * sectorsize;
-	uuid_generate(super.fsid);
+	if (uuid)
+		uuid_parse(uuid, super.fsid);
+	else
+		uuid_generate(super.fsid);
 	uuid_generate(super.dev_item.uuid);
 	uuid_generate(chunk_tree_uuid);
 
diff --git a/utils.h b/utils.h
index 6f4b10c..3b89ece 100644
--- a/utils.h
+++ b/utils.h
@@ -37,7 +37,7 @@
 #define BTRFS_ARG_UUID		2
 #define BTRFS_ARG_BLKDEV	3
 
-int make_btrfs(int fd, const char *device, const char *label,
+int make_btrfs(int fd, const char *device, const char *label, const char *uuid,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
-- 
1.8.3.1

