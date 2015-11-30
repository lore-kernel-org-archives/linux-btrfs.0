Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbbK3Q26 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 11:28:58 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 69C4CAAC7
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 16:28:57 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: verbose error when we find an unexpected item in sys_array
Date: Mon, 30 Nov 2015 17:27:09 +0100
Message-Id: <d53b1469fa8dab55414b0b39e338070f49d4c9f0.1448900173.git.dsterba@suse.com>
In-Reply-To: <cover.1448900173.git.dsterba@suse.com>
References: <cover.1448900173.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b5d6c53d2441..e73e4a1aef91 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6530,6 +6530,9 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 			if (ret)
 				break;
 		} else {
+			printk(KERN_ERR
+		"BTRFS: unexpected item type %u in sys_array at offset %u\n",
+				(u32)key.type, cur_offset);
 			ret = -EIO;
 			break;
 		}
-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
