From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/4] debug-btrfs: Add print_inode command
Date: Sun, 31 Jan 2010 19:51:38 +0530
Message-ID: <1264947698-32371-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1264947698-32371-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1264947698-32371-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 debugbtrfs/cmds.c              |  100 ++++++++++++++++++++++++++++++++++++++++
 debugbtrfs/debug_btrfs_cmds.ct |    3 +
 2 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/debugbtrfs/cmds.c b/debugbtrfs/cmds.c
index cd2901b..be7da31 100644
--- a/debugbtrfs/cmds.c
+++ b/debugbtrfs/cmds.c
@@ -23,6 +23,8 @@
 
 #include "ctree.h"
 #include "disk-io.h"
+#include "extent_io.h"
+#include "transaction.h"
 #include "debug_btrfs.h"
 
 void do_show_debugfs_params(int argc, char *argv[])
@@ -48,3 +50,101 @@ void do_open_filesys(int argc, char *argv[])
 		return;
 	}
 }
+
+void dump_inode_details(u64 ino, struct extent_buffer *leaf,
+			struct btrfs_inode_item *inode_item)
+{
+	char *format_space = "     ";
+	printf("Inode: %10llu", (unsigned long long)ino);
+	printf("%sMode:  %5o",  format_space,
+		btrfs_inode_mode(leaf, inode_item) & 0777);
+	printf("%sUser: %d\n", format_space, btrfs_inode_uid(leaf, inode_item));
+	printf("Size: %llu\n", (unsigned long long)
+		btrfs_inode_size(leaf, inode_item));
+	return;
+}
+
+void dump_file_extent(u64 offset, struct extent_buffer *leaf,
+		struct btrfs_file_extent_item *file_extent_item)
+{
+	printf("[%15llu - %15llu (%15llu)]\t->\t", (unsigned long long) offset,
+		(unsigned long long)
+		offset + btrfs_file_extent_num_bytes(leaf, file_extent_item),
+		btrfs_file_extent_num_bytes(leaf, file_extent_item));
+
+	printf("%15llu (%15llu)\n", (unsigned long long)
+		btrfs_file_extent_disk_bytenr(leaf, file_extent_item),
+		btrfs_file_extent_disk_num_bytes(leaf, file_extent_item));
+	return ;
+}
+
+void dump_file_hole_extent(u64 offset, u64 end_offset)
+{
+	printf("[%15llu - %15llu (%15llu)]\t->\t", (unsigned long long) offset,
+		(unsigned long long) end_offset, end_offset - offset);
+	printf("Hole\n");
+}
+
+void do_print_inode(int argc, char *argv[])
+{
+	int ret;
+	u64 offset, inode_i_size;
+	struct btrfs_path *path;
+	struct btrfs_key inode_key;
+	struct extent_buffer *leaf;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_inode_item *inode_item;
+	struct btrfs_file_extent_item *file_extent_item;
+
+
+	if (argc != 2) {
+		fprintf(stderr, "Usage inode inode_num\n");
+		return;
+	}
+	inode_key.objectid = atoll(argv[1]);
+	inode_key.type     = BTRFS_INODE_ITEM_KEY;
+	inode_key.offset   = 0;
+
+	path = btrfs_alloc_path();
+	btrfs_init_path(path);
+	trans = btrfs_start_transaction(current_fs_root, 1);
+
+	ret = btrfs_search_slot(trans, current_fs_root, &inode_key, path, 0, 0);
+	if (ret != 0) {
+		fprintf(stderr, "Failed get the inode details for %llu\n",
+			(unsigned long long)inode_key.objectid);
+		return;
+	}
+	leaf = path->nodes[0];
+	inode_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_inode_item);
+	dump_inode_details(inode_key.objectid, leaf, inode_item);
+	inode_i_size = btrfs_inode_size(leaf, inode_item);
+	btrfs_release_path(current_fs_root, path);
+
+	/* get the file extent details */
+	offset = 0;
+	/* Dump header */
+	printf("Extent details:\n");
+	printf("[%15s - %15s (%15s)]\t->\t%15s (%15s)\n",
+		"Logical offset",
+		"End offset",
+		"Extent Size",
+		"Disk bytenr",
+		"Actual disk size");
+	while (offset < inode_i_size) {
+		btrfs_init_path(path);
+		ret = btrfs_lookup_file_extent(trans, current_fs_root, path,
+					inode_key.objectid, offset, 0);
+		if (ret != 0) {
+			fprintf(stderr, "Not able to retrive extent information\n");
+			break;
+		}
+		leaf = path->nodes[0];
+		file_extent_item = btrfs_item_ptr(leaf, path->slots[0],
+						struct btrfs_file_extent_item);
+		dump_file_extent(offset, leaf, file_extent_item);
+		offset += btrfs_file_extent_num_bytes(leaf, file_extent_item);
+		btrfs_release_path(current_fs_root, path);
+	}
+	btrfs_commit_transaction(trans, current_fs_root);
+}
diff --git a/debugbtrfs/debug_btrfs_cmds.ct b/debugbtrfs/debug_btrfs_cmds.ct
index a46dbde..98a7282 100644
--- a/debugbtrfs/debug_btrfs_cmds.ct
+++ b/debugbtrfs/debug_btrfs_cmds.ct
@@ -32,5 +32,8 @@ request do_dump_root_tree, "Show root tree",
 request do_dump_chunk_tree, "Show btrfs chunk tree",
 	dump_chunk_tree;
 
+request do_print_inode, "Print inode details",
+	print_inode;
+
 end;
 
-- 
1.7.0.rc0.48.gdace5

