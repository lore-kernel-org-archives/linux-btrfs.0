Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:51063 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751153AbdJSFmA (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 19 Oct 2017 01:42:00 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, nborisov@suse.com
Subject: [PATCH v2 2/6] btrfs-progs: mkfs: Avoid positive return value from cleanup_temp_chunks
Date: Thu, 19 Oct 2017 13:41:34 +0800
Message-Id: <20171019054138.13965-3-wqu@suse.com>
In-Reply-To: <20171019054138.13965-1-wqu@suse.com>
References: <20171019054138.13965-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we're calling btrfs_search_slot() the return value can be
positive.
However we just pass that return value out, causing undefined return
value.

This can cause mkfs return 1, which indicates something wrong.

Fix it.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index 80e6089c37a1..9d53c6632b45 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1350,6 +1350,9 @@ static int cleanup_temp_chunks(struct btrfs_fs_info *fs_info,
 		ret = btrfs_search_slot(trans, root, &key, &path, 0, 0);
 		if (ret < 0)
 			goto out;
+		/* Don't pollute ret for >0 case */
+		if (ret > 0)
+			ret = 0;
 
 		btrfs_item_key_to_cpu(path.nodes[0], &found_key,
 				      path.slots[0]);
-- 
2.14.2

