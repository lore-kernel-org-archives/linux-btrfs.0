Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56042 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2HPH5f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 03:57:35 -0400
Received: by obbuo13 with SMTP id uo13so3331605obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 00:57:35 -0700 (PDT)
Message-ID: <502CA7E6.8020004@gmail.com>
Date: Thu, 16 Aug 2012 15:57:26 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add malloc check in transaction.h/btrfs_start_transaction
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For malloc may fail, we should check it before assign
values to the fields of struct btrfs_trans_handle *h.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 transaction.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/transaction.h b/transaction.h
index a1070e0..d4e42a1 100644
--- a/transaction.h
+++ b/transaction.h
@@ -32,7 +32,12 @@ static inline struct btrfs_trans_handle *
 btrfs_start_transaction(struct btrfs_root *root, int num_blocks)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+
 	struct btrfs_trans_handle *h = malloc(sizeof(*h));
+	if (!h) {
+		BUG();
+		return NULL;
+	}
 
 	BUG_ON(root->commit_root);
 	BUG_ON(fs_info->running_transaction);
-- 
1.7.1

