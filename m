Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbbIPNey (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 09:34:54 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E5AADAC14
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 13:34:52 +0000 (UTC)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH[ btrfs: advertise which crc32c implementation is being used on
 mount
Message-ID: <55F96FFD.5040501@suse.com>
Date: Wed, 16 Sep 2015 15:34:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since several architectures support hardware-accelerated crc32c 
calculation, it would be nice to confirm that btrfs is actually using it.

We can see an elevated use count for the module, but it doesn't actually
show who the users are.  This patch simply prints the name of the driver
after successfully initializing the shash.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/hash.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/btrfs/hash.c
+++ b/fs/btrfs/hash.c
@@ -20,8 +20,12 @@ static struct crypto_shash *tfm;
 int __init btrfs_hash_init(void)
 {
 	tfm = crypto_alloc_shash("crc32c", 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
 
-	return PTR_ERR_OR_ZERO(tfm);
+	printk("BTRFS: using %s for crc32c\n",
+	       crypto_tfm_alg_driver_name(crypto_shash_tfm(tfm)));
+	return 0;
 }
 
 void btrfs_hash_exit(void)

-- 
Jeff Mahoney
SUSE Labs
