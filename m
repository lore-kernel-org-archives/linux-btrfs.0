Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3428 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbcEQDsb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 23:48:31 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/4] btrfs-progs: ctree: return earlier for btrfs_previous_item
Date: Tue, 17 May 2016 11:47:56 +0800
Message-Id: <1463456878-17550-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs_previous_item() has a parameter to specify minimal objectid to
return.

But surprisingly it doesn't use it at all.
Although that's OK, but it would take years long for large tree, so
return it earlier.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ctree.c b/ctree.c
index 079696e..3a9f417 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2894,6 +2894,8 @@ int btrfs_previous_item(struct btrfs_root *root,
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 		if (found_key.type == type)
 			return 0;
+		if (found_key.objectid < min_objectid)
+			break;
 	}
 	return 1;
 }
-- 
2.8.2



