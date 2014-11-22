Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44301 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaKVNOp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 08:14:45 -0500
Received: by mail-pd0-f175.google.com with SMTP id y10so7074392pdj.6
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Nov 2014 05:14:45 -0800 (PST)
Received: from promote.cache-dns.local.cache-dns.local ([223.65.142.103])
        by mx.google.com with ESMTPSA id lr4sm7522107pab.42.2014.11.22.05.14.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Nov 2014 05:14:44 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: switch to kvfree() helper
Date: Sat, 22 Nov 2014 21:13:10 +0800
Message-Id: <1416661990-20717-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1416661990-20717-1-git-send-email-wangshilong1991@gmail.com>
References: <1416661990-20717-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A new helper kvfree() in mm/utils.c will do this.

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
 fs/btrfs/raid56.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 6a41631..12e343b 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -221,12 +221,8 @@ int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info)
 	}
 
 	x = cmpxchg(&info->stripe_hash_table, NULL, table);
-	if (x) {
-		if (is_vmalloc_addr(x))
-			vfree(x);
-		else
-			kfree(x);
-	}
+	if (x)
+		kvfree(x);
 	return 0;
 }
 
@@ -436,10 +432,7 @@ void btrfs_free_stripe_hash_table(struct btrfs_fs_info *info)
 	if (!info->stripe_hash_table)
 		return;
 	btrfs_clear_rbio_cache(info);
-	if (is_vmalloc_addr(info->stripe_hash_table))
-		vfree(info->stripe_hash_table);
-	else
-		kfree(info->stripe_hash_table);
+	kvfree(info->stripe_hash_table);
 	info->stripe_hash_table = NULL;
 }
 
-- 
1.7.12.4

