Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708A6C43612
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ACDF2073D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfACHch (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:32:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:46066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729977AbfACHcg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 02:32:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18EF3B00E
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 07:32:35 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/5] btrfs-progs: Create uuid tree with proper contents
Date:   Thu,  3 Jan 2019 15:32:21 +0800
Message-Id: <20190103073221.10525-6-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190103073221.10525-1-wqu@suse.com>
References: <20190103073221.10525-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
creates uuid tree at mkfs time.

However it doesn't populate uuid tree correctly nor just create an empty
root.
It uses create_tree(), which just copies the content of fs root,
containing meaningless INODE_ITEM:

v4.15 mkfs (no uuid tree creation) + kernel mount:
  uuid tree key (UUID_TREE ROOT_ITEM 0)
  leaf 30572544 items 1 free space 16250 generation 7 owner UUID_TREE
  leaf 30572544 flags 0x1(WRITTEN) backref revision 1
  fs uuid 33ecddef-fc86-481a-93ce-846b01c11376
  chunk uuid 9e58f646-b0da-43ca-9c7d-8bbe3e120246
	item 0 key (0x92457c59d31491be UUID_KEY_SUBVOL 0xef908b5e79aa76a1) itemoff 16275 itemsize 8
		subvol_id 5

v4.19.1 mkfs (incorrect one), no kernel mount:
  uuid tree key (UUID_TREE ROOT_ITEM 0)
  leaf 30507008 items 2 free space 16061 generation 4 owner UUID_TREE
  leaf 30507008 flags 0x1(WRITTEN) backref revision 1
  fs uuid 162f5333-9b5d-4217-877c-ddaeaa79398e
  chunk uuid 7bc2c5c6-a6d2-4eec-a513-142b549c6541
	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		generation 3 transid 0 size 0 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
		sequence 0 flags 0x0(none)
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		index 0 namelen 2 name: ..

This patchset will fix it by populuating uuid tree properly:
(NOTE: due to tree-checker, kernel doesn't accept empty uuid tree, so we
 can only fix it by populating uuid tree correctly)

w/ this patchset, no kernel mount:
  uuid tree key (UUID_TREE ROOT_ITEM 0)
  leaf 30507008 items 1 free space 16250 generation 4 owner UUID_TREE
  leaf 30507008 flags 0x1(WRITTEN) backref revision 1
  fs uuid ae53079e-dbbc-409b-a565-5326c7b27731
  chunk uuid b5fb1bea-f20d-4af1-80f8-6ca3f0038d67
	item 0 key (0x334ba6b032d89c07 UUID_KEY_SUBVOL 0x86cde09cb78bcca0) itemoff 16275 itemsize 8
		subvol_id 5

For kernel, except tree-checker needs an non-empty uuid tree, both all
above behavior won't cause problem, but it's always better to keep a
good standardized behavior.

Fixes: 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 61 ++++++++++++++++++++++++-----------------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 0a13e8d83e4d..16b3432eb4c6 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -310,38 +310,6 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int create_tree(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, u64 objectid)
-{
-	struct btrfs_key location;
-	struct btrfs_root_item root_item;
-	struct extent_buffer *tmp;
-	u8 uuid[BTRFS_UUID_SIZE] = {0};
-	int ret;
-
-	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
-	if (ret)
-		return ret;
-
-	memcpy(&root_item, &root->root_item, sizeof(root_item));
-	btrfs_set_root_bytenr(&root_item, tmp->start);
-	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
-	btrfs_set_root_generation(&root_item, trans->transid);
-	/* clear uuid and o/ctime of source tree */
-	memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
-	btrfs_set_stack_timespec_sec(&root_item.otime, 0);
-	btrfs_set_stack_timespec_sec(&root_item.ctime, 0);
-	free_extent_buffer(tmp);
-
-	location.objectid = objectid;
-	location.type = BTRFS_ROOT_ITEM_KEY;
-	location.offset = 0;
-	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
-				&location, &root_item);
-
-	return ret;
-}
-
 static void print_usage(int ret)
 {
 	printf("Usage: mkfs.btrfs [options] dev [ dev ... ]\n");
@@ -777,6 +745,33 @@ out:
 	return ret;
 }
 
+static int create_uuid_tree(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *root;
+	int ret;
+
+	ASSERT(fs_info->uuid_root == NULL);
+	root = btrfs_create_tree(trans, fs_info, BTRFS_UUID_TREE_OBJECTID);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		goto out;
+	}
+
+	add_root_to_dirty_list(root);
+	fs_info->uuid_root = root;
+	ret = btrfs_uuid_tree_add(trans, fs_info->fs_root->root_item.uuid,
+				  BTRFS_UUID_KEY_SUBVOL,
+				  fs_info->fs_root->root_key.objectid);
+	if (ret < 0)
+		goto out;
+	return 0;
+
+out:
+	btrfs_abort_transaction(trans, ret);
+	return ret;
+}
+
 int main(int argc, char **argv)
 {
 	char *file;
@@ -1277,7 +1272,7 @@ raid_groups:
 		goto out;
 	}
 
-	ret = create_tree(trans, root, BTRFS_UUID_TREE_OBJECTID);
+	ret = create_uuid_tree(trans);
 	if (ret)
 		warning(
 	"unable to create uuid tree, will be created after mount: %d", ret);
-- 
2.20.1

