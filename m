Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbaL3O5s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 09:57:48 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DE738ABFC
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 14:57:47 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/5] btrfs-progs: fix overflow check in btrfs_insert_inode_ref
Date: Tue, 30 Dec 2014 15:57:47 +0100
Message-Id: <08dfef4fbdbfcd06a7a2c8743d9dcba6fa84d747.1419951036.git.dsterba@suse.cz>
In-Reply-To: <cover.1419951036.git.dsterba@suse.cz>
References: <cover.1419951036.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resolves-coverity-id: 1260247
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 inode-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/inode-item.c b/inode-item.c
index 993f3091e335..522d25a433ac 100644
--- a/inode-item.c
+++ b/inode-item.c
@@ -89,7 +89,7 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 		ptr = (unsigned long)(ref + 1);
 		ret = 0;
 	} else if (ret < 0) {
-		if (ret == EOVERFLOW)
+		if (ret == -EOVERFLOW)
 			ret = -EMLINK;
 		goto out;
 	} else {
-- 
2.1.3

