Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51915 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751015AbcJJJVJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 05:21:09 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: btrfstune: Register new UUIDs after uuid change
Date: Mon, 10 Oct 2016 17:21:01 +0800
Message-Id: <20161010092101.469-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For multi-device btrfs, after UUID change we should info kernel, or new
fs can't be mounted due to false alert on missing devices.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/btrfstune.c b/btrfstune.c
index 15dde90..23d06ce 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -369,6 +369,15 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
 	fs_info->new_fsid = NULL;
 	fs_info->new_chunk_tree_uuid = NULL;
 	printf("Fsid change finished\n");
+
+	/*
+	 * Register new devices, or multi-volume btrfs can't be mounted until
+	 * device scan happens.
+	 * Ignore any error, as such register is optional.
+	 */
+	printf("Register new UUIDs(error can be ignored)\n");
+	btrfs_register_all_devices();
+
 out:
 	return ret;
 }
-- 
2.10.0



