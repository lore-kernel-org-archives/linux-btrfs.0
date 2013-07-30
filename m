Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51035 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab3G3XkL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 19:40:11 -0400
Received: by mail-wi0-f171.google.com with SMTP id hr7so3271039wib.10
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 16:40:10 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: add missing error handling to read_tree_block
Date: Wed, 31 Jul 2013 00:39:56 +0100
Message-Id: <1375227596-24884-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/disk-io.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 254cdc8..b71e882 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1148,6 +1148,10 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 		return NULL;
 
 	ret = btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
+	if (ret) {
+		free_extent_buffer(buf);
+		return NULL;
+	}
 	return buf;
 
 }
-- 
1.7.9.5

