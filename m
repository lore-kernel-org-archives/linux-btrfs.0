Return-Path: <SRS0=6Gfh=7H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B71C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 May 2020 06:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCB492078B
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 May 2020 06:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388947AbgEYGeO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 May 2020 02:34:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:33466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388487AbgEYGeN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 May 2020 02:34:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8CC01AD1E;
        Mon, 25 May 2020 06:34:14 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, u-boot@lists.denx.de
Cc:     marek.behun@nic.cz
Subject: [PATCH U-BOOT v2 21/30] fs: btrfs: Use btrfs_lookup_path() to implement btrfs_exists() and btrfs_size()
Date:   Mon, 25 May 2020 14:32:48 +0800
Message-Id: <20200525063257.46757-22-wqu@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525063257.46757-1-wqu@suse.com>
References: <20200525063257.46757-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The remaining function that still utilize __btrfs_lookup_path() is
btrfs_read().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/btrfs.c | 65 +++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/inode.c |  1 -
 2 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
index 2278b52e4d0e..aec91a57eceb 100644
--- a/fs/btrfs/btrfs.c
+++ b/fs/btrfs/btrfs.c
@@ -188,37 +188,66 @@ int btrfs_ls(const char *path)
 
 int btrfs_exists(const char *file)
 {
-	struct __btrfs_root root = btrfs_info.fs_root;
-	u64 inr;
+	struct btrfs_fs_info *fs_info = current_fs_info;
+	struct btrfs_root *root;
+	u64 ino;
 	u8 type;
+	int ret;
+
+	ASSERT(fs_info);
 
-	inr = __btrfs_lookup_path(&root, root.root_dirid, file, &type, NULL, 40);
+	ret = btrfs_lookup_path(fs_info->fs_root, BTRFS_FIRST_FREE_OBJECTID,
+				file, &root, &ino, &type, 40);
+	if (ret < 0)
+		return 0;
 
-	return (inr != -1ULL && type == BTRFS_FT_REG_FILE);
+	if (type == BTRFS_FT_REG_FILE)
+		return 1;
+	return 0;
 }
 
 int btrfs_size(const char *file, loff_t *size)
 {
-	struct __btrfs_root root = btrfs_info.fs_root;
-	struct btrfs_inode_item inode;
-	u64 inr;
+	struct btrfs_fs_info *fs_info = current_fs_info;
+	struct btrfs_inode_item *ii;
+	struct btrfs_root *root;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	u64 ino;
 	u8 type;
+	int ret;
 
-	inr = __btrfs_lookup_path(&root, root.root_dirid, file, &type, &inode,
-				40);
-
-	if (inr == -1ULL) {
+	ret = btrfs_lookup_path(fs_info->fs_root, BTRFS_FIRST_FREE_OBJECTID,
+				file, &root, &ino, &type, 40);
+	if (ret < 0) {
 		printf("Cannot lookup file %s\n", file);
-		return -1;
+		return ret;
 	}
-
 	if (type != BTRFS_FT_REG_FILE) {
 		printf("Not a regular file: %s\n", file);
-		return -1;
+		return -ENOENT;
 	}
+	btrfs_init_path(&path);
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
 
-	*size = inode.size;
-	return 0;
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0) {
+		printf("Cannot lookup ino %llu\n", ino);
+		return ret;
+	}
+	if (ret > 0) {
+		printf("Ino %llu does not exist\n", ino);
+		ret = -ENOENT;
+		goto out;
+	}
+	ii = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_inode_item);
+	*size = btrfs_inode_size(path.nodes[0], ii);
+out:
+	btrfs_release_path(&path);
+	return ret;
 }
 
 int btrfs_read(const char *file, void *buf, loff_t offset, loff_t len,
@@ -270,7 +299,9 @@ void btrfs_close(void)
 int btrfs_uuid(char *uuid_str)
 {
 #ifdef CONFIG_LIB_UUID
-	uuid_bin_to_str(btrfs_info.sb.fsid, uuid_str, UUID_STR_FORMAT_STD);
+	if (current_fs_info)
+		uuid_bin_to_str(current_fs_info->super_copy->fsid, uuid_str,
+				UUID_STR_FORMAT_STD);
 	return 0;
 #endif
 	return -ENOSYS;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 34511d11353e..ba4121bb7adb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -409,7 +409,6 @@ int btrfs_lookup_path(struct btrfs_root *root, u64 ino, const char *filename,
 	}
 
 	while (*cur != '\0') {
-
 		cur = skip_current_directories(cur);
 		len = next_length(cur);
 		if (len > BTRFS_NAME_LEN) {
-- 
2.26.2

