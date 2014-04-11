Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48558 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754543AbaDKDLJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 23:11:09 -0400
Message-ID: <53475CE2.2040601@cn.fujitsu.com>
Date: Fri, 11 Apr 2014 11:09:22 +0800
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>, Chris Mason <clm@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: Use PTR_ERR_OR_ZERO
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


PTR_RET is deprecated. Do not recommend its usage anymore.
Use PTR_ERR_OR_ZERO instead.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 fs/btrfs/hash.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/hash.c b/fs/btrfs/hash.c
index 85889aa..8c2d3b9 100644
--- a/fs/btrfs/hash.c
+++ b/fs/btrfs/hash.c
@@ -20,10 +20,7 @@ static struct crypto_shash *tfm;
 int __init btrfs_hash_init(void)
 {
 	tfm = crypto_alloc_shash("crc32c", 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(tfm);
 }
 
 void btrfs_hash_exit(void)
-- 
1.8.3.1
