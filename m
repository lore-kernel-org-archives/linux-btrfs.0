Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41961 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbeH3VqU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:20 -0400
Received: by mail-qk1-f196.google.com with SMTP id h138-v6so22939qke.8
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:43:05 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 20/35] btrfs: reset max_extent_size on clear in a bitmap
Date: Thu, 30 Aug 2018 13:42:10 -0400
Message-Id: <20180830174225.2200-21-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

We need to clear the max_extent_size when we clear bits from a bitmap
since it could have been from the range that contains the
max_extent_size.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/free-space-cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 53521027dd78..7faca05e61ea 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1683,6 +1683,8 @@ static inline void __bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
 	bitmap_clear(info->bitmap, start, count);
 
 	info->bytes -= bytes;
+	if (info->max_extent_size > ctl->unit)
+		info->max_extent_size = 0;
 }
 
 static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
-- 
2.14.3
