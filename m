Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36727 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbcADBCM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 20:02:12 -0500
Received: by mail-pa0-f43.google.com with SMTP id yy13so95967221pab.3
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 17:02:12 -0800 (PST)
Received: from arch-gct.localdomain ([175.114.213.172])
        by smtp.gmail.com with ESMTPSA id 184sm45125786pfa.15.2016.01.03.17.02.10
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 03 Jan 2016 17:02:11 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/6] btrfs-progs: fix endian bug in update_super()
Date: Mon,  4 Jan 2016 10:01:33 +0900
Message-Id: <1451869294-4291-6-git-send-email-bhlee.kernel@gmail.com>
In-Reply-To: <1451869294-4291-1-git-send-email-bhlee.kernel@gmail.com>
References: <1451869294-4291-1-git-send-email-bhlee.kernel@gmail.com>
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

