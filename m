Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35290 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731656AbeGSPds (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:33:48 -0400
Received: by mail-qt0-f194.google.com with SMTP id a5-v6so7414988qtp.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:17 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 07/22] btrfs: don't leak ret from do_chunk_alloc
Date: Thu, 19 Jul 2018 10:49:51 -0400
Message-Id: <20180719145006.17532-7-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we're trying to make a data reservation and we have to allocate a
data chunk we could leak ret == 1, as do_chunk_alloc() will return 1 if
it allocated a chunk.  Since the end of the function is the success path
just return 0.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 523bc197c40b..6de9a180abdd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4360,7 +4360,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 				      data_sinfo->flags, bytes, 1);
 	spin_unlock(&data_sinfo->lock);
 
-	return ret;
+	return 0;
 }
 
 int btrfs_check_data_free_space(struct inode *inode,
-- 
2.14.3

