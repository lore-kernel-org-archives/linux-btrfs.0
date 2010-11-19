From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] mkfs should initialize unused fields properly
Date: Fri, 19 Nov 2010 16:05:27 +0100
Message-ID: <1290179127-28139-1-git-send-email-list.btrfs@jan-o-sch.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

we discovered speed setting is (probably unintentionally) initialized to 1 in make_btrfs(), while being initialized to 0 in btrfs_add_to_fsid(). initialization in make_btrfs() is due to reuse of buf after pwrite() without clearing it. consequently, code like

 	btrfs_set_extent_generation(buf, extent_item, 1);

writes to the same location in buf where speed will be placed, later. It may be a good idea to clear buf after each pwrite(), though leaving the struct btrfs_header intact.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 utils.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/utils.c b/utils.c
index fd894f3..815b967 100644
--- a/utils.c
+++ b/utils.c
@@ -197,6 +197,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	BUG_ON(ret != leafsize);
 
 	/* create the items for the extent tree */
+	memset(buf->data+sizeof(struct btrfs_header), 0,
+		leafsize-sizeof(struct btrfs_header));
 	nritems = 0;
 	itemoff = __BTRFS_LEAF_DATA_SIZE(leafsize);
 	for (i = 1; i < 7; i++) {
@@ -242,6 +244,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	BUG_ON(ret != leafsize);
 
 	/* create the chunk tree */
+	memset(buf->data+sizeof(struct btrfs_header), 0,
+		leafsize-sizeof(struct btrfs_header));
 	nritems = 0;
 	item_size = sizeof(*dev_item);
 	itemoff = __BTRFS_LEAF_DATA_SIZE(leafsize) - item_size;
@@ -323,6 +327,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	ret = pwrite(fd, buf->data, leafsize, blocks[3]);
 
 	/* create the device tree */
+	memset(buf->data+sizeof(struct btrfs_header), 0,
+		leafsize-sizeof(struct btrfs_header));
 	nritems = 0;
 	itemoff = __BTRFS_LEAF_DATA_SIZE(leafsize) -
 		sizeof(struct btrfs_dev_extent);
@@ -356,6 +362,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	ret = pwrite(fd, buf->data, leafsize, blocks[4]);
 
 	/* create the FS root */
+	memset(buf->data+sizeof(struct btrfs_header), 0,
+		leafsize-sizeof(struct btrfs_header));
 	btrfs_set_header_bytenr(buf, blocks[5]);
 	btrfs_set_header_owner(buf, BTRFS_FS_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
@@ -364,6 +372,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	BUG_ON(ret != leafsize);
 
 	/* finally create the csum root */
+	memset(buf->data+sizeof(struct btrfs_header), 0,
+		leafsize-sizeof(struct btrfs_header));
 	btrfs_set_header_bytenr(buf, blocks[6]);
 	btrfs_set_header_owner(buf, BTRFS_CSUM_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
-- 
1.7.2.2

