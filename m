Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34277 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731977AbeGSPeH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:34:07 -0400
Received: by mail-qk0-f194.google.com with SMTP id b66-v6so4411407qkj.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:36 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 21/22] btrfs: reset max_extent_size on clear in a bitmap
Date: Thu, 19 Jul 2018 10:50:05 -0400
Message-Id: <20180719145006.17532-21-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
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
index 92e1c30356b9..0feb735a78a8 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1691,6 +1691,8 @@ static inline void __bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
 	bitmap_clear(info->bitmap, start, count);
 
 	info->bytes -= bytes;
+	if (info->max_extent_size > ctl->unit)
+		info->max_extent_size = 0;
 }
 
 static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
-- 
2.14.3

