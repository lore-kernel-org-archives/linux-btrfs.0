Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbaKGQrI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 11:47:08 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3E6A6ACF9
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 16:47:07 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/4] btrfs: add checks for sys_chunk_array sizes
Date: Fri,  7 Nov 2014 17:47:06 +0100
Message-Id: <2855ec89bc99c87365ffb46bb5130bd60f146799.1415378049.git.dsterba@suse.cz>
In-Reply-To: <cover.1415378049.git.dsterba@suse.cz>
References: <cover.1415378049.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Verify that possible minimum and maximum size is set, validity of
contents is checked in btrfs_read_sys_array.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e97fa11488f1..77f205d82ae9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3887,6 +3887,25 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	}
 
 	/*
+	 * Obvious sys_chunk_array corruptions, it must hold at least one key
+	 * and one chunk
+	 */
+	if (btrfs_super_sys_array_size(sb) > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
+		printk(KERN_ERR "BTRFS: system chunk array too big %llu > %u\n",
+				btrfs_super_sys_array_size(sb),
+				BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
+		ret = -EINVAL;
+	}
+	if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
+			+ sizeof(struct btrfs_chunk)) {
+		printk(KERN_ERR "BTRFS: system chunk array too small %llu < %u\n",
+				btrfs_super_sys_array_size(sb),
+				sizeof(struct btrfs_disk_key)
+				+ sizeof(struct btrfs_chunk));
+		ret = -EINVAL;
+	}
+
+	/*
 	 * The generation is a global counter, we'll trust it more than the others
 	 * but it's still possible that it's the one that's wrong.
 	 */
-- 
1.8.4.5

