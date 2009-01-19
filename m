From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: [Patch] btrfsck.c: bit-fields should be unsigned
Date: Mon, 19 Jan 2009 22:28:29 +0800
Message-ID: <20090119142829.GB8507@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


bit-fields should be unsigned.

Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/btrfsck.c b/btrfsck.c
index 4a41e6d..1bf4064 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -60,10 +60,10 @@ struct extent_record {
 
 struct inode_backref {
 	struct list_head list;
-	int found_dir_item:1;
-	int found_dir_index:1;
-	int found_inode_ref:1;
-	int filetype:8;
+	unsigned int found_dir_item:1;
+	unsigned int found_dir_index:1;
+	unsigned int found_inode_ref:1;
+	unsigned int filetype:8;
 	int errors;
 	u64 dir;
 	u64 index;
@@ -83,13 +83,13 @@ struct inode_backref {
 
 struct inode_record {
 	struct list_head backrefs;
-	int checked:1;
-	int found_inode_item:1;
-	int found_dir_item:1;
-	int found_file_extent:1;
-	int found_csum_item:1;
-	int some_csum_missing:1;
-	int nodatasum:1;
+	unsigned int checked:1;
+	unsigned int found_inode_item:1;
+	unsigned int found_dir_item:1;
+	unsigned int found_file_extent:1;
+	unsigned int found_csum_item:1;
+	unsigned int some_csum_missing:1;
+	unsigned int nodatasum:1;
 	int errors;
 
 	u64 ino;
