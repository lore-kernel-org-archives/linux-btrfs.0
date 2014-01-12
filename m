Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58257 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaALNiq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 08:38:46 -0500
Received: by mail-pd0-f178.google.com with SMTP id y10so6395845pdj.37
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 05:38:46 -0800 (PST)
Received: from linux-b0ol.localdomain ([223.65.51.231])
        by mx.google.com with ESMTPSA id jn12sm30944540pbd.37.2014.01.12.05.38.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Jan 2014 05:38:45 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: fix missing inline refs when walking backrefs
Date: Sun, 12 Jan 2014 21:38:34 +0800
Message-Id: <1389533914-2272-4-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1389533914-2272-1-git-send-email-wangshilong1991@gmail.com>
References: <1389533914-2272-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

If @slot=0, we may have an expected item in the previous leaf,
So we should handle that case, otherwise, we will miss inline refs
,fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 964679c..4ccd726 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -893,14 +893,13 @@ again:
 		spin_unlock(&delayed_refs->lock);
 	}
 
-	if (path->slots[0]) {
-		struct extent_buffer *leaf;
-		int slot;
+	ret = btrfs_previous_extent_item(fs_info->extent_root, path,
+					 key.objectid);
+	if (ret < 0)
+		goto out;
 
-		path->slots[0]--;
-		leaf = path->nodes[0];
-		slot = path->slots[0];
-		btrfs_item_key_to_cpu(leaf, &key, slot);
+	if (ret == 0) {
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 		if (key.objectid == bytenr &&
 		    (key.type == BTRFS_EXTENT_ITEM_KEY ||
 		     key.type == BTRFS_METADATA_ITEM_KEY)) {
-- 
1.8.4

