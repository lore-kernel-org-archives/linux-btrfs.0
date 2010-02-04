From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 5/6] debug-btrfs: Add pager support
Date: Thu,  4 Feb 2010 23:14:06 +0530
Message-ID: <1265305447-30780-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265305447-30780-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1265305447-30780-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 debugbtrfs/Makefile      |    2 +-
 debugbtrfs/debug_btrfs.h |    3 +
 debugbtrfs/debug_tree.c  |  107 ++++++++++++--------
 debugbtrfs/pager.c       |   49 +++++++++
 lib/ctree.c              |   22 ++--
 lib/extent-tree.c        |   10 +-
 lib/print-tree.c         |  256 +++++++++++++++++++++++-----------------------
 lib/print-tree.h         |    8 +-
 lib/root-tree.c          |   11 +-
 misc/debug-tree.c        |    8 +-
 10 files changed, 277 insertions(+), 199 deletions(-)
 create mode 100644 debugbtrfs/pager.c

diff --git a/debugbtrfs/Makefile b/debugbtrfs/Makefile
index 970990e..217a8f7 100644
--- a/debugbtrfs/Makefile
+++ b/debugbtrfs/Makefile
@@ -33,7 +33,7 @@ all: $(progs)
 debug_btrfs_cmds.c: debug_btrfs_cmds.ct
 	$(MK_CMDS) debug_btrfs_cmds.ct
 
-debug-btrfs: $(TOPDIR)/lib/libbtrfs.a  debug_btrfs.o cmds.o debug_btrfs_cmds.o debug_tree.o
+debug-btrfs: $(TOPDIR)/lib/libbtrfs.a  debug_btrfs.o cmds.o debug_btrfs_cmds.o debug_tree.o pager.o
 	$(CC) $(CFLAGS) -o debug-btrfs $^ $(TOPDIR)/lib/libbtrfs.a $(LDFLAGS) $(LIBS)
 
 clean:
diff --git a/debugbtrfs/debug_btrfs.h b/debugbtrfs/debug_btrfs.h
index 1ea4fb2..7f3b4b9 100644
--- a/debugbtrfs/debug_btrfs.h
+++ b/debugbtrfs/debug_btrfs.h
@@ -19,6 +19,7 @@
 
 #ifndef DEBUG_BTRFS_H
 #define DEBUG_BTRFS_H
+#include <stdio.h>
 #include <getopt.h>
 
 extern const char *current_device;
@@ -27,4 +28,6 @@ static inline void reset_getopt(void)
 {
 	optind = 0;
 }
+extern FILE *open_pager(void);
+extern void close_pager(FILE *);
 #endif
diff --git a/debugbtrfs/debug_tree.c b/debugbtrfs/debug_tree.c
index e92d6d0..5e159d9 100644
--- a/debugbtrfs/debug_tree.c
+++ b/debugbtrfs/debug_tree.c
@@ -30,87 +30,110 @@
 
 void do_dump_extent_tree(int argc, char *argv[])
 {
+	FILE *fp;
 	if (!current_fs_root) {
 		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
-	printf("Extent tree\n");
-	btrfs_print_tree(current_fs_root->fs_info->extent_root,
+	fp = open_pager();
+	fprintf(fp, "Extent tree\n");
+	btrfs_print_tree(fp, current_fs_root->fs_info->extent_root,
 				 current_fs_root->fs_info->extent_root->node);
+	close_pager(fp);
 }
 
 void do_dump_root_tree(int argc, char *argv[])
 {
+	FILE *fp;
 	if (!current_fs_root) {
 		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
-	printf("root tree\n");
-	btrfs_print_tree(current_fs_root->fs_info->tree_root,
+	fp = open_pager();
+	fprintf(fp, "root tree\n");
+	btrfs_print_tree(fp, current_fs_root->fs_info->tree_root,
 			 current_fs_root->fs_info->tree_root->node);
+	close_pager(fp);
 }
 
 void do_dump_chunk_tree(int argc, char *argv[])
 {
+	FILE *fp;
 	if (!current_fs_root) {
 		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
-	printf("chunk tree\n");
-	btrfs_print_tree(current_fs_root->fs_info->chunk_root,
+	fp = open_pager();
+	fprintf(fp, "chunk tree\n");
+	btrfs_print_tree(fp, current_fs_root->fs_info->chunk_root,
 				 current_fs_root->fs_info->chunk_root->node);
+	close_pager(fp);
 }
 
 void do_dump_dev_tree(int argc, char *argv[])
 {
+	FILE *fp;
 	if (!current_fs_root) {
 		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
-	printf("Device tree\n");
-	btrfs_print_tree(current_fs_root->fs_info->dev_root,
+	fp = open_pager();
+	fprintf(fp, "Device tree\n");
+	btrfs_print_tree(fp, current_fs_root->fs_info->dev_root,
 				 current_fs_root->fs_info->dev_root->node);
+	close_pager(fp);
 }
 
 void do_dump_fs_tree(int argc, char *argv[])
 {
+	FILE *fp;
 	if (!current_fs_root) {
 		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
-	printf("FS tree\n");
-	btrfs_print_tree(current_fs_root->fs_info->fs_root,
+	fp = open_pager();
+	fprintf(fp, "FS tree\n");
+	btrfs_print_tree(fp, current_fs_root->fs_info->fs_root,
 				 current_fs_root->fs_info->fs_root->node);
+	close_pager(fp);
 }
 
 void do_dump_csum_tree(int argc, char *argv[])
 {
+	FILE *fp;
 	if (!current_fs_root) {
 		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
-	printf("Checksum tree\n");
-	btrfs_print_tree(current_fs_root->fs_info->csum_root,
+	fp = open_pager();
+	fprintf(fp, "Checksum tree\n");
+	btrfs_print_tree(fp, current_fs_root->fs_info->csum_root,
 				 current_fs_root->fs_info->csum_root->node);
+	close_pager(fp);
 }
 
 void do_dump_log_tree(int argc, char *argv[])
 {
+	FILE *fp;
 	if (!current_fs_root) {
 		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
-	printf("Log tree\n");
+	fp = open_pager();
+	fprintf(fp, "Log tree\n");
 	if (!current_fs_root->fs_info->log_root_tree) {
-		printf("Nothing to replay \n");
+		fprintf(fp, "Nothing to replay \n");
+		close_pager(fp);
 		return;
 	}
-	btrfs_print_tree(current_fs_root->fs_info->log_root_tree,
+	btrfs_print_tree(fp, current_fs_root->fs_info->log_root_tree,
 				 current_fs_root->fs_info->log_root_tree->node);
+	close_pager(fp);
 }
 
 void do_dump_tree(int argc, char *argv[])
 {
+	FILE *fp;
 	struct btrfs_path path;
 	struct btrfs_key key;
 	struct btrfs_root_item ri;
@@ -126,12 +149,13 @@ void do_dump_tree(int argc, char *argv[])
 		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
-	printf("root tree\n");
-	btrfs_print_tree(current_fs_root->fs_info->tree_root,
+	fp = open_pager();
+	fprintf(fp, "root tree\n");
+	btrfs_print_tree(fp, current_fs_root->fs_info->tree_root,
 				 current_fs_root->fs_info->tree_root->node);
 
-	printf("chunk tree\n");
-	btrfs_print_tree(current_fs_root->fs_info->chunk_root,
+	fprintf(fp, "chunk tree\n");
+	btrfs_print_tree(fp, current_fs_root->fs_info->chunk_root,
 				 current_fs_root->fs_info->chunk_root->node);
 
 	tree_root_scan = current_fs_root->fs_info->tree_root;
@@ -166,55 +190,55 @@ again:
 					      tree_root_scan->leafsize, 0);
 			switch(found_key.objectid) {
 			case BTRFS_ROOT_TREE_OBJECTID:
-				printf("root");
+				fprintf(fp, "root");
 				break;
 			case BTRFS_EXTENT_TREE_OBJECTID:
-				printf("extent");
+				fprintf(fp, "extent");
 				break;
 			case BTRFS_CHUNK_TREE_OBJECTID:
-				printf("chunk");
+				fprintf(fp, "chunk");
 				break;
 			case BTRFS_DEV_TREE_OBJECTID:
-				printf("device");
+				fprintf(fp, "device");
 				break;
 			case BTRFS_FS_TREE_OBJECTID:
-				printf("fs");
+				fprintf(fp, "fs");
 				break;
 			case BTRFS_ROOT_TREE_DIR_OBJECTID:
-				printf("directory");
+				fprintf(fp, "directory");
 				break;
 			case BTRFS_CSUM_TREE_OBJECTID:
-				printf("checksum");
+				fprintf(fp, "checksum");
 				break;
 			case BTRFS_ORPHAN_OBJECTID:
-				printf("orphan");
+				fprintf(fp, "orphan");
 				break;
 			case BTRFS_TREE_LOG_OBJECTID:
-				printf("log");
+				fprintf(fp, "log");
 				break;
 			case BTRFS_TREE_LOG_FIXUP_OBJECTID:
-				printf("log fixup");
+				fprintf(fp, "log fixup");
 				break;
 			case BTRFS_TREE_RELOC_OBJECTID:
-				printf("reloc");
+				fprintf(fp, "reloc");
 				break;
 			case BTRFS_DATA_RELOC_TREE_OBJECTID:
-				printf("data reloc");
+				fprintf(fp, "data reloc");
 				break;
 			case BTRFS_EXTENT_CSUM_OBJECTID:
-				printf("extent checksum");
+				fprintf(fp, "extent checksum");
 				break;
 			case BTRFS_MULTIPLE_OBJECTIDS:
-				printf("multiple");
+				fprintf(fp, "multiple");
 				break;
 			default:
-				printf("file");
+				fprintf(fp, "file");
 			}
 
-			printf(" tree ");
-			btrfs_print_key(&disk_key);
-			printf(" \n");
-			btrfs_print_tree(tree_root_scan, buf);
+			fprintf(fp, " tree ");
+			btrfs_print_key(fp, &disk_key);
+			fprintf(fp, " \n");
+			btrfs_print_tree(fp, tree_root_scan, buf);
 
 		}
 		path.slots[0]++;
@@ -227,12 +251,13 @@ again:
 		goto again;
 	}
 
-	printf("total bytes %llu\n",
+	fprintf(fp, "total bytes %llu\n",
 	       (unsigned long long)btrfs_super_total_bytes(&current_fs_root->fs_info->super_copy));
-	printf("bytes used %llu\n",
+	fprintf(fp, "bytes used %llu\n",
 	       (unsigned long long)btrfs_super_bytes_used(&current_fs_root->fs_info->super_copy));
 	uuidbuf[36] = '\0';
 	uuid_unparse(current_fs_root->fs_info->super_copy.fsid, uuidbuf);
-	printf("uuid %s\n", uuidbuf);
+	fprintf(fp, "uuid %s\n", uuidbuf);
+	close_pager(fp);
 	return;
 }
diff --git a/debugbtrfs/pager.c b/debugbtrfs/pager.c
new file mode 100644
index 0000000..b2d3a96
--- /dev/null
+++ b/debugbtrfs/pager.c
@@ -0,0 +1,49 @@
+/* derived from e2fsprogs debugfs/util.c */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <signal.h>
+#include <unistd.h>
+#include <string.h>
+
+static const char *pager_search_list[] = { "pager", "more", "less", 0 };
+static const char *pager_dir_list[] = { "/usr/bin", "/bin", 0 };
+
+static const char *find_pager(char *buf)
+{
+	const char **i, **j;
+
+	for (i = pager_search_list; *i; i++) {
+		for (j = pager_dir_list; *j; j++) {
+			sprintf(buf, "%s/%s", *j, *i);
+			if (access(buf, X_OK) == 0)
+				return(buf);
+		}
+	}
+	return 0;
+}
+
+FILE *open_pager(void)
+{
+	FILE *outfile = 0;
+	const char *pager = getenv("DEBUGFS_PAGER");
+	char buf[80];
+
+	signal(SIGPIPE, SIG_IGN);
+	if (!isatty(1))
+		return stdout;
+	if (!pager)
+		pager = getenv("PAGER");
+	if (!pager)
+		pager = find_pager(buf);
+	if (!pager ||
+	    (strcmp(pager, "__none__") == 0) ||
+	    ((outfile = popen(pager, "w")) == 0))
+		return stdout;
+	return outfile;
+}
+
+void close_pager(FILE *stream)
+{
+	if (stream && stream != stdout) pclose(stream);
+}
diff --git a/lib/ctree.c b/lib/ctree.c
index f70e10c..45e98ae 100644
--- a/lib/ctree.c
+++ b/lib/ctree.c
@@ -657,13 +657,13 @@ static int check_leaf(struct btrfs_root *root, struct btrfs_path *path,
 		btrfs_item_key(leaf, &leaf_key, slot);
 		btrfs_item_key_to_cpu(leaf, &cpukey, slot - 1);
 		if (btrfs_comp_keys(&leaf_key, &cpukey) <= 0) {
-			btrfs_print_leaf(root, leaf);
+			btrfs_print_leaf(stdout, root, leaf);
 			printk("slot %d offset bad key\n", slot);
 			BUG_ON(1);
 		}
 		if (btrfs_item_offset_nr(leaf, slot - 1) !=
 		       btrfs_item_end_nr(leaf, slot)) {
-			btrfs_print_leaf(root, leaf);
+			btrfs_print_leaf(stdout, root, leaf);
 			printk("slot %d offset bad\n", slot);
 			BUG_ON(1);
 		}
@@ -674,7 +674,7 @@ static int check_leaf(struct btrfs_root *root, struct btrfs_path *path,
 		BUG_ON(btrfs_comp_keys(&leaf_key, &cpukey) >= 0);
 		if (btrfs_item_offset_nr(leaf, slot) !=
 			btrfs_item_end_nr(leaf, slot + 1)) {
-			btrfs_print_leaf(root, leaf);
+			btrfs_print_leaf(stdout, root, leaf);
 			printk("slot %d offset bad\n", slot);
 			BUG_ON(1);
 		}
@@ -2356,7 +2356,7 @@ split:
 
 	ret = 0;
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(stdout, root, leaf);
 		BUG();
 	}
 	kfree(buf);
@@ -2456,7 +2456,7 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 
 	ret = 0;
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(stdout, root, leaf);
 		BUG();
 	}
 	return ret;
@@ -2484,7 +2484,7 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 	data_end = leaf_data_end(root, leaf);
 
 	if (btrfs_leaf_free_space(root, leaf) < data_size) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(stdout, root, leaf);
 		BUG();
 	}
 	slot = path->slots[0];
@@ -2492,7 +2492,7 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 
 	BUG_ON(slot < 0);
 	if (slot >= nritems) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(stdout, root, leaf);
 		printk("slot %d too large, nritems %d\n", slot, nritems);
 		BUG_ON(1);
 	}
@@ -2521,7 +2521,7 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 
 	ret = 0;
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(stdout, root, leaf);
 		BUG();
 	}
 	return ret;
@@ -2572,7 +2572,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	data_end = leaf_data_end(root, leaf);
 
 	if (btrfs_leaf_free_space(root, leaf) < total_size) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(stdout, root, leaf);
 		printk("not enough freespace need %u have %d\n",
 		       total_size, btrfs_leaf_free_space(root, leaf));
 		BUG();
@@ -2586,7 +2586,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 		unsigned int old_data = btrfs_item_end_nr(leaf, slot);
 
 		if (old_data < data_end) {
-			btrfs_print_leaf(root, leaf);
+			btrfs_print_leaf(stdout, root, leaf);
 			printk("slot %d old_data %d data_end %d\n",
 			       slot, old_data, data_end);
 			BUG_ON(1);
@@ -2634,7 +2634,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	}
 
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
-		btrfs_print_leaf(root, leaf);
+		btrfs_print_leaf(stdout, root, leaf);
 		BUG();
 	}
 
diff --git a/lib/extent-tree.c b/lib/extent-tree.c
index b2f9bb2..210da17 100644
--- a/lib/extent-tree.c
+++ b/lib/extent-tree.c
@@ -1447,7 +1447,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		goto out;
 	if (ret != 0) {
-		btrfs_print_leaf(root, path->nodes[0]);
+		btrfs_print_leaf(stdout, root, path->nodes[0]);
 		printk("failed to find block number %Lu\n", bytenr);
 		BUG();
 	}
@@ -1505,7 +1505,7 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		goto out;
 	if (ret != 0) {
-		btrfs_print_leaf(root, path->nodes[0]);
+		btrfs_print_leaf(stdout, root, path->nodes[0]);
 		printk("failed to find block number %Lu\n",
 			(unsigned long long)bytenr);
 		BUG();
@@ -2126,13 +2126,13 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 				printk(KERN_ERR "umm, got %d back from search"
 				       ", was looking for %llu\n", ret,
 				       (unsigned long long)bytenr);
-				btrfs_print_leaf(extent_root, path->nodes[0]);
+				btrfs_print_leaf(stdout, extent_root, path->nodes[0]);
 			}
 			BUG_ON(ret);
 			extent_slot = path->slots[0];
 		}
 	} else {
-		btrfs_print_leaf(extent_root, path->nodes[0]);
+		btrfs_print_leaf(stdout, extent_root, path->nodes[0]);
 		WARN_ON(1);
 		printk(KERN_ERR "btrfs unable to find ref byte nr %llu "
 		       "parent %llu root %llu  owner %llu offset %llu\n",
@@ -2165,7 +2165,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			printk(KERN_ERR "umm, got %d back from search"
 			       ", was looking for %llu\n", ret,
 			       (unsigned long long)bytenr);
-			btrfs_print_leaf(extent_root, path->nodes[0]);
+			btrfs_print_leaf(stdout, extent_root, path->nodes[0]);
 		}
 		BUG_ON(ret);
 		extent_slot = path->slots[0];
diff --git a/lib/print-tree.c b/lib/print-tree.c
index 59f4358..af09b8c 100644
--- a/lib/print-tree.c
+++ b/lib/print-tree.c
@@ -25,7 +25,7 @@
 #include "disk-io.h"
 #include "print-tree.h"
 
-static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
+static int print_dir_item(FILE *out, struct extent_buffer *eb, struct btrfs_item *item,
 			  struct btrfs_dir_item *di)
 {
 	u32 total;
@@ -39,14 +39,14 @@ static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
 	total = btrfs_item_size(eb, item);
 	while(cur < total) {
 		btrfs_dir_item_key(eb, di, &location);
-		printf("\t\tlocation ");
-		btrfs_print_key(&location);
-		printf(" type %u\n", btrfs_dir_type(eb, di));
+		fprintf(out, "\t\tlocation ");
+		btrfs_print_key(out, &location);
+		fprintf(out, " type %u\n", btrfs_dir_type(eb, di));
 		name_len = btrfs_dir_name_len(eb, di);
 		data_len = btrfs_dir_data_len(eb, di);
 		len = (name_len <= sizeof(namebuf))? name_len: sizeof(namebuf);
 		read_extent_buffer(eb, namebuf, (unsigned long)(di + 1), len);
-		printf("\t\tnamelen %u datalen %u name: %.*s\n",
+		fprintf(out, "\t\tnamelen %u datalen %u name: %.*s\n",
 		       name_len, data_len, len, namebuf);
 		len = sizeof(*di) + name_len + data_len;
 		di = (struct btrfs_dir_item *)((char *)di + len);
@@ -55,7 +55,7 @@ static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
 	return 0;
 }
 
-static int print_inode_ref_item(struct extent_buffer *eb, struct btrfs_item *item,
+static int print_inode_ref_item(FILE *out, struct extent_buffer *eb, struct btrfs_item *item,
 				struct btrfs_inode_ref *ref)
 {
 	u32 total;
@@ -70,7 +70,7 @@ static int print_inode_ref_item(struct extent_buffer *eb, struct btrfs_item *ite
 		index = btrfs_inode_ref_index(eb, ref);
 		len = (name_len <= sizeof(namebuf))? name_len: sizeof(namebuf);
 		read_extent_buffer(eb, namebuf, (unsigned long)(ref + 1), len);
-		printf("\t\tinode ref index %llu namelen %u name: %.*s\n",
+		fprintf(out, "\t\tinode ref index %llu namelen %u name: %.*s\n",
 		       (unsigned long long)index, name_len, len, namebuf);
 		len = sizeof(*ref) + name_len;
 		ref = (struct btrfs_inode_ref *)((char *)ref + len);
@@ -79,32 +79,32 @@ static int print_inode_ref_item(struct extent_buffer *eb, struct btrfs_item *ite
 	return 0;
 }
 
-static void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
+static void print_chunk(FILE *out, struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
 	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
 	int i;
-	printf("\t\tchunk length %llu owner %llu type %llu num_stripes %d\n",
+	fprintf(out, "\t\tchunk length %llu owner %llu type %llu num_stripes %d\n",
 	       (unsigned long long)btrfs_chunk_length(eb, chunk),
 	       (unsigned long long)btrfs_chunk_owner(eb, chunk),
 	       (unsigned long long)btrfs_chunk_type(eb, chunk),
 	       num_stripes);
 	for (i = 0 ; i < num_stripes ; i++) {
-		printf("\t\t\tstripe %d devid %llu offset %llu\n", i,
+		fprintf(out, "\t\t\tstripe %d devid %llu offset %llu\n", i,
 		      (unsigned long long)btrfs_stripe_devid_nr(eb, chunk, i),
 		      (unsigned long long)btrfs_stripe_offset_nr(eb, chunk, i));
 	}
 }
-static void print_dev_item(struct extent_buffer *eb,
+static void print_dev_item(FILE *out, struct extent_buffer *eb,
 			   struct btrfs_dev_item *dev_item)
 {
-	printf("\t\tdev item devid %llu "
+	fprintf(out, "\t\tdev item devid %llu "
 	       "total_bytes %llu bytes used %Lu\n",
 	       (unsigned long long)btrfs_device_id(eb, dev_item),
 	       (unsigned long long)btrfs_device_total_bytes(eb, dev_item),
 	       (unsigned long long)btrfs_device_bytes_used(eb, dev_item));
 }
 
-static void print_uuids(struct extent_buffer *eb)
+static void print_uuids(FILE *out, struct extent_buffer *eb)
 {
 	char fs_uuid[37];
 	char chunk_uuid[37];
@@ -122,17 +122,17 @@ static void print_uuids(struct extent_buffer *eb)
 
 	chunk_uuid[36] = '\0';
 	uuid_unparse(disk_uuid, chunk_uuid);
-	printf("fs uuid %s\nchunk uuid %s\n", fs_uuid, chunk_uuid);
+	fprintf(out, "fs uuid %s\nchunk uuid %s\n", fs_uuid, chunk_uuid);
 }
 
-static void print_file_extent_item(struct extent_buffer *eb,
+static void print_file_extent_item(FILE *out, struct extent_buffer *eb,
 				   struct btrfs_item *item,
 				   struct btrfs_file_extent_item *fi)
 {
 	int extent_type = btrfs_file_extent_type(eb, fi);
 
 	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-		printf("\t\tinline extent data size %u "
+		fprintf(out, "\t\tinline extent data size %u "
 		       "ram %u compress %d\n",
 		  btrfs_file_extent_inline_item_len(eb, item),
 		  btrfs_file_extent_inline_len(eb, fi),
@@ -140,26 +140,26 @@ static void print_file_extent_item(struct extent_buffer *eb,
 		return;
 	}
 	if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
-		printf("\t\tprealloc data disk byte %llu nr %llu\n",
+		fprintf(out, "\t\tprealloc data disk byte %llu nr %llu\n",
 		  (unsigned long long)btrfs_file_extent_disk_bytenr(eb, fi),
 		  (unsigned long long)btrfs_file_extent_disk_num_bytes(eb, fi));
-		printf("\t\tprealloc data offset %llu nr %llu\n",
+		fprintf(out, "\t\tprealloc data offset %llu nr %llu\n",
 		  (unsigned long long)btrfs_file_extent_offset(eb, fi),
 		  (unsigned long long)btrfs_file_extent_num_bytes(eb, fi));
 		return;
 	}
-	printf("\t\textent data disk byte %llu nr %llu\n",
+	fprintf(out, "\t\textent data disk byte %llu nr %llu\n",
 		(unsigned long long)btrfs_file_extent_disk_bytenr(eb, fi),
 		(unsigned long long)btrfs_file_extent_disk_num_bytes(eb, fi));
-	printf("\t\textent data offset %llu nr %llu ram %llu\n",
+	fprintf(out, "\t\textent data offset %llu nr %llu ram %llu\n",
 		(unsigned long long)btrfs_file_extent_offset(eb, fi),
 		(unsigned long long)btrfs_file_extent_num_bytes(eb, fi),
 		(unsigned long long)btrfs_file_extent_ram_bytes(eb, fi));
-	printf("\t\textent compression %d\n",
+	fprintf(out, "\t\textent compression %d\n",
 	       btrfs_file_extent_compression(eb, fi));
 }
 
-static void print_extent_item(struct extent_buffer *eb, int slot)
+static void print_extent_item(FILE *out, struct extent_buffer *eb, int slot)
 {
 	struct btrfs_extent_item *ei;
 	struct btrfs_extent_inline_ref *iref;
@@ -178,7 +178,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 		struct btrfs_extent_item_v0 *ei0;
 		BUG_ON(item_size != sizeof(*ei0));
 		ei0 = btrfs_item_ptr(eb, slot, struct btrfs_extent_item_v0);
-		printf("\t\textent refs %u\n",
+		fprintf(out, "\t\textent refs %u\n",
 		       btrfs_extent_refs_v0(eb, ei0));
 		return;
 #else
@@ -189,7 +189,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
 	flags = btrfs_extent_flags(eb, ei);
 
-	printf("\t\textent refs %llu gen %llu flags %llu\n",
+	fprintf(out, "\t\textent refs %llu gen %llu flags %llu\n",
 	       (unsigned long long)btrfs_extent_refs(eb, ei),
 	       (unsigned long long)btrfs_extent_generation(eb, ei),
 	       (unsigned long long)flags);
@@ -198,7 +198,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 		struct btrfs_tree_block_info *info;
 		info = (struct btrfs_tree_block_info *)(ei + 1);
 		btrfs_tree_block_key(eb, info, &key);
-		printf("\t\ttree block key (%llu %x %llu) level %d\n",
+		fprintf(out, "\t\ttree block key (%llu %x %llu) level %d\n",
 		       (unsigned long long)btrfs_disk_key_objectid(&key),
 		       key.type,
 		       (unsigned long long)btrfs_disk_key_offset(&key),
@@ -216,16 +216,16 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 		offset = btrfs_extent_inline_ref_offset(eb, iref);
 		switch (type) {
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			printf("\t\ttree block backref root %llu\n",
+			fprintf(out, "\t\ttree block backref root %llu\n",
 			       (unsigned long long)offset);
 			break;
 		case BTRFS_SHARED_BLOCK_REF_KEY:
-			printf("\t\tshared block backref parent %llu\n",
+			fprintf(out, "\t\tshared block backref parent %llu\n",
 			       (unsigned long long)offset);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY:
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
-			printf("\t\textent data backref root %llu "
+			fprintf(out, "\t\textent data backref root %llu "
 			       "objectid %llu offset %llu count %u\n",
 			       (unsigned long long)btrfs_extent_data_ref_root(eb, dref),
 			       (unsigned long long)btrfs_extent_data_ref_objectid(eb, dref),
@@ -234,7 +234,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY:
 			sref = (struct btrfs_shared_data_ref *)(iref + 1);
-			printf("\t\tshared data backref parent %llu count %u\n",
+			fprintf(out, "\t\tshared data backref parent %llu count %u\n",
 			       (unsigned long long)offset,
 			       btrfs_shared_data_ref_count(eb, sref));
 			break;
@@ -247,12 +247,12 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 }
 
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
-static void print_extent_ref_v0(struct extent_buffer *eb, int slot)
+static void print_extent_ref_v0(FILE *out, struct extent_buffer *eb, int slot)
 {
 	struct btrfs_extent_ref_v0 *ref0;
 
 	ref0 = btrfs_item_ptr(eb, slot, struct btrfs_extent_ref_v0);
-	printf("\t\textent back ref root %llu gen %llu "
+	fprintf(out, "\t\textent back ref root %llu gen %llu "
 		"owner %llu num_refs %lu\n",
 		(unsigned long long)btrfs_ref_root_v0(eb, ref0),
 		(unsigned long long)btrfs_ref_generation_v0(eb, ref0),
@@ -261,7 +261,7 @@ static void print_extent_ref_v0(struct extent_buffer *eb, int slot)
 }
 #endif
 
-static void print_root_ref(struct extent_buffer *leaf, int slot, char *tag)
+static void print_root_ref(FILE *out, struct extent_buffer *leaf, int slot, char *tag)
 {
 	struct btrfs_root_ref *ref;
 	char namebuf[BTRFS_NAME_LEN];
@@ -270,169 +270,169 @@ static void print_root_ref(struct extent_buffer *leaf, int slot, char *tag)
 	ref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
 	namelen = btrfs_root_ref_name_len(leaf, ref);
 	read_extent_buffer(leaf, namebuf, (unsigned long)(ref + 1), namelen);
-	printf("\t\troot %s key dirid %llu sequence %llu name %.*s\n", tag,
+	fprintf(out, "\t\troot %s key dirid %llu sequence %llu name %.*s\n", tag,
 	       (unsigned long long)btrfs_root_ref_dirid(leaf, ref),
 	       (unsigned long long)btrfs_root_ref_sequence(leaf, ref),
 	       namelen, namebuf);
 }
 
-static void print_key_type(u8 type)
+static void print_key_type(FILE *out, u8 type)
 {
 	switch (type) {
 	case BTRFS_INODE_ITEM_KEY:
-		printf("INODE_ITEM");
+		fprintf(out, "INODE_ITEM");
 		break;
 	case BTRFS_INODE_REF_KEY:
-		printf("INODE_REF");
+		fprintf(out, "INODE_REF");
 		break;
 	case BTRFS_DIR_ITEM_KEY:
-		printf("DIR_ITEM");
+		fprintf(out, "DIR_ITEM");
 		break;
 	case BTRFS_DIR_INDEX_KEY:
-		printf("DIR_INDEX");
+		fprintf(out, "DIR_INDEX");
 		break;
 	case BTRFS_DIR_LOG_ITEM_KEY:
-		printf("DIR_LOG_ITEM");
+		fprintf(out, "DIR_LOG_ITEM");
 		break;
 	case BTRFS_DIR_LOG_INDEX_KEY:
-		printf("DIR_LOG_INDEX");
+		fprintf(out, "DIR_LOG_INDEX");
 		break;
 	case BTRFS_XATTR_ITEM_KEY:
-		printf("XATTR_ITEM");
+		fprintf(out, "XATTR_ITEM");
 		break;
 	case BTRFS_ORPHAN_ITEM_KEY:
-		printf("ORPHAN_ITEM");
+		fprintf(out, "ORPHAN_ITEM");
 		break;
 	case BTRFS_ROOT_ITEM_KEY:
-		printf("ROOT_ITEM");
+		fprintf(out, "ROOT_ITEM");
 		break;
 	case BTRFS_ROOT_REF_KEY:
-		printf("ROOT_REF");
+		fprintf(out, "ROOT_REF");
 		break;
 	case BTRFS_ROOT_BACKREF_KEY:
-		printf("ROOT_BACKREF");
+		fprintf(out, "ROOT_BACKREF");
 		break;
 	case BTRFS_EXTENT_ITEM_KEY:
-		printf("EXTENT_ITEM");
+		fprintf(out, "EXTENT_ITEM");
 		break;
 	case BTRFS_TREE_BLOCK_REF_KEY:
-		printf("TREE_BLOCK_REF");
+		fprintf(out, "TREE_BLOCK_REF");
 		break;
 	case BTRFS_SHARED_BLOCK_REF_KEY:
-		printf("SHARED_BLOCK_REF");
+		fprintf(out, "SHARED_BLOCK_REF");
 		break;
 	case BTRFS_EXTENT_DATA_REF_KEY:
-		printf("EXTENT_DATA_REF");
+		fprintf(out, "EXTENT_DATA_REF");
 		break;
 	case BTRFS_SHARED_DATA_REF_KEY:
-		printf("SHARED_DATA_REF");
+		fprintf(out, "SHARED_DATA_REF");
 		break;
 	case BTRFS_EXTENT_REF_V0_KEY:
-		printf("EXTENT_REF_V0");
+		fprintf(out, "EXTENT_REF_V0");
 		break;
 	case BTRFS_CSUM_ITEM_KEY:
-		printf("CSUM_ITEM");
+		fprintf(out, "CSUM_ITEM");
 		break;
 	case BTRFS_EXTENT_CSUM_KEY:
-		printf("EXTENT_CSUM");
+		fprintf(out, "EXTENT_CSUM");
 		break;
 	case BTRFS_EXTENT_DATA_KEY:
-		printf("EXTENT_DATA");
+		fprintf(out, "EXTENT_DATA");
 		break;
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
-		printf("BLOCK_GROUP_ITEM");
+		fprintf(out, "BLOCK_GROUP_ITEM");
 		break;
 	case BTRFS_CHUNK_ITEM_KEY:
-		printf("CHUNK_ITEM");
+		fprintf(out, "CHUNK_ITEM");
 		break;
 	case BTRFS_DEV_ITEM_KEY:
-		printf("DEV_ITEM");
+		fprintf(out, "DEV_ITEM");
 		break;
 	case BTRFS_DEV_EXTENT_KEY:
-		printf("DEV_EXTENT");
+		fprintf(out, "DEV_EXTENT");
 		break;
 	case BTRFS_STRING_ITEM_KEY:
-		printf("STRING_ITEM");
+		fprintf(out, "STRING_ITEM");
 		break;
 	default:
-		printf("UNKNOWN");
+		fprintf(out, "UNKNOWN");
 	};
 }
 
-static void print_objectid(unsigned long long objectid, u8 type)
+static void print_objectid(FILE *out, unsigned long long objectid, u8 type)
 {
 	if (type == BTRFS_DEV_EXTENT_KEY) {
-		printf("%llu", objectid); /* device id */
+		fprintf(out, "%llu", objectid); /* device id */
 		return;
 	}
 
 	switch (objectid) {
 	case BTRFS_ROOT_TREE_OBJECTID:
 		if (type == BTRFS_DEV_ITEM_KEY)
-			printf("DEV_ITEMS");
+			fprintf(out, "DEV_ITEMS");
 		else
-			printf("ROOT_TREE");
+			fprintf(out, "ROOT_TREE");
 		break;
 	case BTRFS_EXTENT_TREE_OBJECTID:
-		printf("EXTENT_TREE");
+		fprintf(out, "EXTENT_TREE");
 		break;
 	case BTRFS_CHUNK_TREE_OBJECTID:
-		printf("CHUNK_TREE");
+		fprintf(out, "CHUNK_TREE");
 		break;
 	case BTRFS_DEV_TREE_OBJECTID:
-		printf("DEV_TREE");
+		fprintf(out, "DEV_TREE");
 		break;
 	case BTRFS_FS_TREE_OBJECTID:
-		printf("FS_TREE");
+		fprintf(out, "FS_TREE");
 		break;
 	case BTRFS_ROOT_TREE_DIR_OBJECTID:
-		printf("ROOT_TREE_DIR");
+		fprintf(out, "ROOT_TREE_DIR");
 		break;
 	case BTRFS_CSUM_TREE_OBJECTID:
-		printf("CSUM_TREE");
+		fprintf(out, "CSUM_TREE");
 		break;
 	case BTRFS_ORPHAN_OBJECTID:
-		printf("ORPHAN");
+		fprintf(out, "ORPHAN");
 		break;
 	case BTRFS_TREE_LOG_OBJECTID:
-		printf("TREE_LOG");
+		fprintf(out, "TREE_LOG");
 		break;
 	case BTRFS_TREE_LOG_FIXUP_OBJECTID:
-		printf("LOG_FIXUP");
+		fprintf(out, "LOG_FIXUP");
 		break;
 	case BTRFS_TREE_RELOC_OBJECTID:
-		printf("TREE_RELOC");
+		fprintf(out, "TREE_RELOC");
 		break;
 	case BTRFS_DATA_RELOC_TREE_OBJECTID:
-		printf("DATA_RELOC_TREE");
+		fprintf(out, "DATA_RELOC_TREE");
 		break;
 	case BTRFS_EXTENT_CSUM_OBJECTID:
-		printf("EXTENT_CSUM");
+		fprintf(out, "EXTENT_CSUM");
 		break;
 	case BTRFS_MULTIPLE_OBJECTIDS:
-		printf("MULTIPLE");
+		fprintf(out, "MULTIPLE");
 		break;
 	case BTRFS_FIRST_CHUNK_TREE_OBJECTID:
-		printf("FIRST_CHUNK_TREE");
+		fprintf(out, "FIRST_CHUNK_TREE");
 		break;
 	default:
-		printf("%llu", objectid);
+		fprintf(out, "%llu", objectid);
 	}
 }
 
-void btrfs_print_key(struct btrfs_disk_key *disk_key)
+void btrfs_print_key(FILE *out, struct btrfs_disk_key *disk_key)
 {
 	u8 type;
-	printf("key (");
+	fprintf(out, "key (");
 	type = btrfs_disk_key_type(disk_key);
-	print_objectid((unsigned long long)btrfs_disk_key_objectid(disk_key),
+	print_objectid(out, (unsigned long long)btrfs_disk_key_objectid(disk_key),
 		type);
-	printf(" ");
-	print_key_type(type);
-	printf(" %llu)", (unsigned long long)btrfs_disk_key_offset(disk_key));
+	fprintf(out, " ");
+	print_key_type(out, type);
+	fprintf(out, " %llu)", (unsigned long long)btrfs_disk_key_offset(disk_key));
 }
 
-void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
+void btrfs_print_leaf(FILE *out, struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
 	char *str;
@@ -454,26 +454,26 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	u32 nr = btrfs_header_nritems(l);
 	u32 type;
 
-	printf("leaf %llu items %d free space %d generation %llu owner %llu\n",
+	fprintf(out, "leaf %llu items %d free space %d generation %llu owner %llu\n",
 		(unsigned long long)btrfs_header_bytenr(l), nr,
 		btrfs_leaf_free_space(root, l),
 		(unsigned long long)btrfs_header_generation(l),
 		(unsigned long long)btrfs_header_owner(l));
-	print_uuids(l);
-	fflush(stdout);
+	print_uuids(out, l);
+	fflush(out);
 	for (i = 0 ; i < nr ; i++) {
 		item = btrfs_item_nr(l, i);
 		btrfs_item_key(l, &disk_key, i);
 		type = btrfs_disk_key_type(&disk_key);
-		printf("\titem %d ", i);
-		btrfs_print_key(&disk_key);
-		printf(" itemoff %d itemsize %d\n",
+		fprintf(out, "\titem %d ", i);
+		btrfs_print_key(out, &disk_key);
+		fprintf(out, " itemoff %d itemsize %d\n",
 			btrfs_item_offset(l, item),
 			btrfs_item_size(l, item));
 		switch (type) {
 		case BTRFS_INODE_ITEM_KEY:
 			ii = btrfs_item_ptr(l, i, struct btrfs_inode_item);
-			printf("\t\tinode generation %llu size %llu block group %llu mode %o links %u\n",
+			fprintf(out, "\t\tinode generation %llu size %llu block group %llu mode %o links %u\n",
 			       (unsigned long long)btrfs_inode_generation(l, ii),
 			       (unsigned long long)btrfs_inode_size(l, ii),
 			       (unsigned long long)btrfs_inode_block_group(l,ii),
@@ -482,27 +482,27 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			break;
 		case BTRFS_INODE_REF_KEY:
 			iref = btrfs_item_ptr(l, i, struct btrfs_inode_ref);
-			print_inode_ref_item(l, item, iref);
+			print_inode_ref_item(out, l, item, iref);
 			break;
 		case BTRFS_DIR_ITEM_KEY:
 		case BTRFS_DIR_INDEX_KEY:
 		case BTRFS_XATTR_ITEM_KEY:
 			di = btrfs_item_ptr(l, i, struct btrfs_dir_item);
-			print_dir_item(l, item, di);
+			print_dir_item(out, l, item, di);
 			break;
 		case BTRFS_DIR_LOG_INDEX_KEY:
 		case BTRFS_DIR_LOG_ITEM_KEY:
 			dlog = btrfs_item_ptr(l, i, struct btrfs_dir_log_item);
-			printf("\t\tdir log end %Lu\n",
+			fprintf(out, "\t\tdir log end %Lu\n",
 			       btrfs_dir_log_end(l, dlog));
 		       break;
 		case BTRFS_ORPHAN_ITEM_KEY:
-			printf("\t\torphan item\n");
+			fprintf(out, "\t\torphan item\n");
 			break;
 		case BTRFS_ROOT_ITEM_KEY:
 			ri = btrfs_item_ptr(l, i, struct btrfs_root_item);
 			read_extent_buffer(l, &root_item, (unsigned long)ri, sizeof(root_item));
-			printf("\t\troot data bytenr %llu level %d dirid %llu refs %u\n",
+			fprintf(out, "\t\troot data bytenr %llu level %d dirid %llu refs %u\n",
 				(unsigned long long)btrfs_root_bytenr(&root_item),
 				btrfs_root_level(&root_item),
 				(unsigned long long)btrfs_root_dirid(&root_item),
@@ -511,29 +511,29 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 				struct btrfs_key drop_key;
 				btrfs_disk_key_to_cpu(&drop_key,
 						      &root_item.drop_progress);
-				printf("\t\tdrop ");
-				btrfs_print_key(&root_item.drop_progress);
-				printf(" level %d\n", root_item.drop_level);
+				fprintf(out, "\t\tdrop ");
+				btrfs_print_key(out, &root_item.drop_progress);
+				fprintf(out, " level %d\n", root_item.drop_level);
 			}
 			break;
 		case BTRFS_ROOT_REF_KEY:
-			print_root_ref(l, i, "ref");
+			print_root_ref(out, l, i, "ref");
 			break;
 		case BTRFS_ROOT_BACKREF_KEY:
-			print_root_ref(l, i, "backref");
+			print_root_ref(out, l, i, "backref");
 			break;
 		case BTRFS_EXTENT_ITEM_KEY:
-			print_extent_item(l, i);
+			print_extent_item(out, l, i);
 			break;
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			printf("\t\ttree block backref\n");
+			fprintf(out, "\t\ttree block backref\n");
 			break;
 		case BTRFS_SHARED_BLOCK_REF_KEY:
-			printf("\t\tshared block backref\n");
+			fprintf(out, "\t\tshared block backref\n");
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY:
 			dref = btrfs_item_ptr(l, i, struct btrfs_extent_data_ref);
-			printf("\t\textent data backref root %llu "
+			fprintf(out, "\t\textent data backref root %llu "
 			       "objectid %llu offset %llu count %u\n",
 			       (unsigned long long)btrfs_extent_data_ref_root(l, dref),
 			       (unsigned long long)btrfs_extent_data_ref_objectid(l, dref),
@@ -542,50 +542,50 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY:
 			sref = btrfs_item_ptr(l, i, struct btrfs_shared_data_ref);
-			printf("\t\tshared data backref count %u\n",
+			fprintf(out, "\t\tshared data backref count %u\n",
 			       btrfs_shared_data_ref_count(l, sref));
 			break;
 		case BTRFS_EXTENT_REF_V0_KEY:
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
-			print_extent_ref_v0(l, i);
+			print_extent_ref_v0(out, l, i);
 #else
 			BUG();
 #endif
 			break;
 		case BTRFS_CSUM_ITEM_KEY:
 			ci = btrfs_item_ptr(l, i, struct btrfs_csum_item);
-			printf("\t\tcsum item\n");
+			fprintf(out, "\t\tcsum item\n");
 			break;
 		case BTRFS_EXTENT_CSUM_KEY:
 			ci = btrfs_item_ptr(l, i, struct btrfs_csum_item);
-			printf("\t\textent csum item\n");
+			fprintf(out, "\t\textent csum item\n");
 			break;
 		case BTRFS_EXTENT_DATA_KEY:
 			fi = btrfs_item_ptr(l, i,
 					    struct btrfs_file_extent_item);
-			print_file_extent_item(l, item, fi);
+			print_file_extent_item(out, l, item, fi);
 			break;
 		case BTRFS_BLOCK_GROUP_ITEM_KEY:
 			bi = btrfs_item_ptr(l, i,
 					    struct btrfs_block_group_item);
 			read_extent_buffer(l, &bg_item, (unsigned long)bi,
 					   sizeof(bg_item));
-			printf("\t\tblock group used %llu chunk_objectid %llu flags %llu\n",
+			fprintf(out, "\t\tblock group used %llu chunk_objectid %llu flags %llu\n",
 			       (unsigned long long)btrfs_block_group_used(&bg_item),
 			       (unsigned long long)btrfs_block_group_chunk_objectid(&bg_item),
 			       (unsigned long long)btrfs_block_group_flags(&bg_item));
 			break;
 		case BTRFS_CHUNK_ITEM_KEY:
-			print_chunk(l, btrfs_item_ptr(l, i, struct btrfs_chunk));
+			print_chunk(out, l, btrfs_item_ptr(l, i, struct btrfs_chunk));
 			break;
 		case BTRFS_DEV_ITEM_KEY:
-			print_dev_item(l, btrfs_item_ptr(l, i,
+			print_dev_item(out, l, btrfs_item_ptr(l, i,
 					struct btrfs_dev_item));
 			break;
 		case BTRFS_DEV_EXTENT_KEY:
 			dev_extent = btrfs_item_ptr(l, i,
 						    struct btrfs_dev_extent);
-			printf("\t\tdev extent chunk_tree %llu\n"
+			fprintf(out, "\t\tdev extent chunk_tree %llu\n"
 			       "\t\tchunk objectid %llu chunk offset %llu "
 			       "length %llu\n",
 			       (unsigned long long)
@@ -600,14 +600,14 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_STRING_ITEM_KEY:
 			/* dirty, but it's simple */
 			str = l->data + btrfs_item_ptr_offset(l, i);
-			printf("\t\titem data %.*s\n", btrfs_item_size(l, item), str);
+			fprintf(out, "\t\titem data %.*s\n", btrfs_item_size(l, item), str);
 			break;
 		};
-		fflush(stdout);
+		fflush(out);
 	}
 }
 
-void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb)
+void btrfs_print_tree(FILE *out, struct btrfs_root *root, struct extent_buffer *eb)
 {
 	int i;
 	u32 nr;
@@ -619,29 +619,29 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb)
 		return;
 	nr = btrfs_header_nritems(eb);
 	if (btrfs_is_leaf(eb)) {
-		btrfs_print_leaf(root, eb);
+		btrfs_print_leaf(out, root, eb);
 		return;
 	}
-	printf("node %llu level %d items %d free %u generation %llu owner %llu\n",
+	fprintf(out, "node %llu level %d items %d free %u generation %llu owner %llu\n",
 	       (unsigned long long)eb->start,
 	        btrfs_header_level(eb), nr,
 		(u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr,
 		(unsigned long long)btrfs_header_generation(eb),
 		(unsigned long long)btrfs_header_owner(eb));
-	print_uuids(eb);
-	fflush(stdout);
+	print_uuids(out, eb);
+	fflush(out);
 	size = btrfs_level_size(root, btrfs_header_level(eb) - 1);
 	for (i = 0; i < nr; i++) {
 		u64 blocknr = btrfs_node_blockptr(eb, i);
 		btrfs_node_key(eb, &disk_key, i);
 		btrfs_disk_key_to_cpu(&key, &disk_key);
-		printf("\t");
-		btrfs_print_key(&disk_key);
-		printf(" block %llu (%llu) gen %llu\n",
+		fprintf(out, "\t");
+		btrfs_print_key(out, &disk_key);
+		fprintf(out, " block %llu (%llu) gen %llu\n",
 		       (unsigned long long)blocknr,
 		       (unsigned long long)blocknr / size,
 		       (unsigned long long)btrfs_node_ptr_generation(eb, i));
-		fflush(stdout);
+		fflush(out);
 	}
 	for (i = 0; i < nr; i++) {
 		struct extent_buffer *next = read_tree_block(root,
@@ -660,7 +660,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb)
 		if (btrfs_header_level(next) !=
 			btrfs_header_level(eb) - 1)
 			BUG();
-		btrfs_print_tree(root, next);
+		btrfs_print_tree(out, root, next);
 		free_extent_buffer(next);
 	}
 }
diff --git a/lib/print-tree.h b/lib/print-tree.h
index 4d1a01a..a7e9826 100644
--- a/lib/print-tree.h
+++ b/lib/print-tree.h
@@ -18,7 +18,9 @@
 
 #ifndef __PRINT_TREE_
 #define __PRINT_TREE_
-void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l);
-void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *t);
-void btrfs_print_key(struct btrfs_disk_key *disk_key);
+#include <stdio.h>
+
+void btrfs_print_leaf(FILE *out, struct btrfs_root *root, struct extent_buffer *l);
+void btrfs_print_tree(FILE *out, struct btrfs_root *root, struct extent_buffer *t);
+void btrfs_print_key(FILE *out, struct btrfs_disk_key *disk_key);
 #endif
diff --git a/lib/root-tree.c b/lib/root-tree.c
index 782472c..e1df044 100644
--- a/lib/root-tree.c
+++ b/lib/root-tree.c
@@ -182,12 +182,11 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	if (ret < 0)
 		goto out;
 	if (ret) {
-btrfs_print_leaf(root, path->nodes[0]);
-printk("failed to del %llu %u %llu\n",
-	(unsigned long long)key->objectid,
-	key->type,
-	(unsigned long long)key->offset);
-
+		btrfs_print_leaf(stdout, root, path->nodes[0]);
+		printk("failed to del %llu %u %llu\n",
+			(unsigned long long)key->objectid,
+			key->type,
+			(unsigned long long)key->offset);
 	}
 	BUG_ON(ret != 0);
 	leaf = path->nodes[0];
diff --git a/misc/debug-tree.c b/misc/debug-tree.c
index 1d47519..64f6f83 100644
--- a/misc/debug-tree.c
+++ b/misc/debug-tree.c
@@ -144,11 +144,11 @@ int main(int ac, char **av)
 	}
 	if (!extent_only) {
 		printf("root tree\n");
-		btrfs_print_tree(root->fs_info->tree_root,
+		btrfs_print_tree(stdout, root->fs_info->tree_root,
 				 root->fs_info->tree_root->node);
 
 		printf("chunk tree\n");
-		btrfs_print_tree(root->fs_info->chunk_root,
+		btrfs_print_tree(stdout, root->fs_info->chunk_root,
 				 root->fs_info->chunk_root->node);
 	}
 	tree_root_scan = root->fs_info->tree_root;
@@ -258,9 +258,9 @@ again:
 			}
 			if (!skip && !extent_only) {
 				printf(" tree ");
-				btrfs_print_key(&disk_key);
+				btrfs_print_key(stdout, &disk_key);
 				printf(" \n");
-				btrfs_print_tree(tree_root_scan, buf);
+				btrfs_print_tree(stdout, tree_root_scan, buf);
 			} else if (extent_only && !skip) {
 				print_extents(tree_root_scan, buf);
 			}
-- 
1.7.0.rc0.48.gdace5

