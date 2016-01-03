Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34618 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbcACTAU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 14:00:20 -0500
Received: by mail-pf0-f175.google.com with SMTP id e65so137600064pfe.1
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 11:00:20 -0800 (PST)
Received: from arch-gct.localdomain ([175.114.213.172])
        by smtp.gmail.com with ESMTPSA id fc6sm120726837pac.44.2016.01.03.11.00.18
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 03 Jan 2016 11:00:19 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs-progs: fix endian bug in update_super()
Date: Mon,  4 Jan 2016 03:59:57 +0900
Message-Id: <1451847598-30666-6-git-send-email-bhlee.kernel@gmail.com>
In-Reply-To: <1451847598-30666-1-git-send-email-bhlee.kernel@gmail.com>
References: <1451847598-30666-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In update_super() 'chunk->stripe.devid' and 'super->dev_item.devid' both
are little endian. So we should not use endian helper
btrfs_set_stack_stripe_devid().

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 btrfs-image.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 4a0a7c5414a7..bb1f63511647 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1464,8 +1464,7 @@ static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
 			btrfs_set_stack_chunk_sub_stripes(chunk, 0);
 			btrfs_set_stack_chunk_type(chunk,
 						   BTRFS_BLOCK_GROUP_SYSTEM);
-			btrfs_set_stack_stripe_devid(&chunk->stripe,
-						     super->dev_item.devid);
+			chunk->stripe.devid = super->dev_item.devid;
 			physical = logical_to_physical(mdres, key.offset,
 						       &size);
 			if (size != (u64)-1)
-- 
2.6.4

