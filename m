Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:29635 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbaGDTKb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jul 2014 15:10:31 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs: use PTR_ERR_OR_ZERO
Date: Fri,  4 Jul 2014 21:10:27 +0200
Message-Id: <1404501027-22752-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

replace IS_ERR/PTR_ERR

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/hash.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/hash.c b/fs/btrfs/hash.c
index 85889aa..64f15bb 100644
--- a/fs/btrfs/hash.c
+++ b/fs/btrfs/hash.c
@@ -20,10 +20,8 @@ static struct crypto_shash *tfm;
 int __init btrfs_hash_init(void)
 {
 	tfm = crypto_alloc_shash("crc32c", 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(tfm);
 }
 
 void btrfs_hash_exit(void)
-- 
1.9.1

