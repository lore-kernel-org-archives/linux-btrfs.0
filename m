Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8238C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A215F21741
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbeL0HNk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 02:13:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:34984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727225AbeL0HNk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 02:13:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5D4E5AD52
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2018 07:13:38 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: uuid: Port kernel btrfs_uuid_tree_lookup()
Date:   Thu, 27 Dec 2018 15:13:31 +0800
Message-Id: <20181227071333.10964-2-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20181227071333.10964-1-wqu@suse.com>
References: <20181227071333.10964-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Although we have btrfs_uuid_tree_lookup_any(), it's an online function
utilizing tree search ioctl, not an offline search function.

This patch will port kernel btrfs_uuid_tree_lookup() into btrfs-progs
for later proper uuid tree initialization.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 uuid-tree.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

diff --git a/uuid-tree.c b/uuid-tree.c
index 320eb67e1404..b9190103c355 100644
--- a/uuid-tree.c
+++ b/uuid-tree.c
@@ -23,6 +23,7 @@
 #include "transaction.h"
 #include "disk-io.h"
 #include "print-tree.h"
+#include "utils.h"
 
 
 static void btrfs_uuid_to_key(const u8 *uuid, u64 *key_objectid,
@@ -32,8 +33,11 @@ static void btrfs_uuid_to_key(const u8 *uuid, u64 *key_objectid,
 	*key_offset = get_unaligned_le64(uuid + sizeof(u64));
 }
 
-
-/* return -ENOENT for !found, < 0 for errors, or 0 if an item was found */
+/*
+ * Search uuid tree of a *MOUNTED* btrfs (online)
+ *
+ * return -ENOENT for !found, < 0 for errors, or 0 if an item was found
+ */
 static int btrfs_uuid_tree_lookup_any(int fd, const u8 *uuid, u8 type,
 				      u64 *subid)
 {
@@ -103,3 +107,66 @@ int btrfs_lookup_uuid_received_subvol_item(int fd, const u8 *uuid,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 					  subvol_id);
 }
+
+/*
+ * Search uuid tree of an *UNMOUNTED* btrfs (offline)
+ */
+static int btrfs_uuid_tree_lookup(struct btrfs_root *uuid_root, u8 *uuid,
+				  u8 type, u64 subid)
+{
+	int ret;
+	struct btrfs_path *path = NULL;
+	struct extent_buffer *eb;
+	int slot;
+	u32 item_size;
+	unsigned long offset;
+	struct btrfs_key key;
+
+	if (!uuid_root) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	btrfs_uuid_to_key(uuid, &key.objectid, &key.offset);
+	key.type = type;
+	ret = btrfs_search_slot(NULL, uuid_root, &key, path, 0, 0);
+	if (ret < 0) {
+		goto out;
+	} else if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	eb = path->nodes[0];
+	slot = path->slots[0];
+	item_size = btrfs_item_size_nr(eb, slot);
+	offset = btrfs_item_ptr_offset(eb, slot);
+	ret = -ENOENT;
+
+	if (!IS_ALIGNED(item_size, sizeof(u64))) {
+		warning("uuid item with illegal size %lu!",
+			(unsigned long)item_size);
+		goto out;
+	}
+	while (item_size) {
+		__le64 data;
+
+		read_extent_buffer(eb, &data, offset, sizeof(data));
+		if (le64_to_cpu(data) == subid) {
+			ret = 0;
+			break;
+		}
+		offset += sizeof(data);
+		item_size -= sizeof(data);
+	}
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
-- 
2.20.1

