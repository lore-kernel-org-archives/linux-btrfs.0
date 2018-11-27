Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AC7C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07D3A208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:33:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07D3A208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbeK0N3n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 08:29:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:58554 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728272AbeK0N3n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 08:29:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9040AF5C
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 02:33:24 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs-progs: image: Remove all existing dev extents for later rebuild
Date:   Tue, 27 Nov 2018 10:33:13 +0800
Message-Id: <20181127023315.28176-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181127023315.28176-1-wqu@suse.com>
References: <20181127023315.28176-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch will remove all existing dev extents for later rebuild.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/main.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/image/main.c b/image/main.c
index 9060f6b1b665..707568f22e01 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2210,6 +2210,70 @@ static void fixup_block_groups(struct btrfs_trans_handle *trans,
 	}
 }
 
+static int remove_all_dev_extents(struct btrfs_trans_handle *trans,
+				  struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *root = fs_info->dev_root;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	int slot;
+	int ret;
+
+	key.objectid = 1;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	key.offset = 0;
+	btrfs_init_path(&path);
+
+	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
+	if (ret < 0) {
+		error("failed to search dev tree: %s", strerror(-ret));
+		return ret;
+	}
+
+	while (1) {
+		slot = path.slots[0];
+		leaf = path.nodes[0];
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, &path);
+			if (ret < 0) {
+				error("failed to search dev tree: %s",
+					strerror(-ret));
+				goto out;
+			}
+			if (ret > 0) {
+				ret = 0;
+				goto out;
+			}
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (key.type != BTRFS_DEV_EXTENT_KEY)
+			break;
+		ret = btrfs_del_item(trans, root, &path);
+		if (ret < 0) {
+			error("failed to delete dev extent %llu, %llu: %s",
+				key.objectid, key.offset, strerror(-ret));
+			goto out;
+		}
+	}
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
+static int fixup_dev_extents(struct btrfs_trans_handle *trans,
+			     struct btrfs_fs_info *fs_info)
+{
+	int ret;
+
+	ret = remove_all_dev_extents(trans, fs_info);
+	if (ret < 0)
+		error("failed to remove all existing dev extents: %s",
+			strerror(-ret));
+	return ret;
+}
+
 static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
 			 struct mdrestore_struct *mdres, off_t dev_size)
 {
@@ -2227,6 +2291,10 @@ static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
 	}
 
 	fixup_block_groups(trans, fs_info);
+	ret = fixup_dev_extents(trans, fs_info);
+	if (ret < 0)
+		goto error;
+
 	ret = fixup_device_size(trans, fs_info, mdres, dev_size);
 	if (ret < 0)
 		goto error;
-- 
2.19.2

