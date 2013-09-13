Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab3IMPlZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 11:41:25 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2E142A531D
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Sep 2013 17:41:24 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: refuse to remount read-write after abort
Date: Fri, 13 Sep 2013 17:41:20 +0200
Message-Id: <1379086880-11324-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's still possible to flip the filesystem into RW mode after it's
remounted RO due to an abort. There are lots of places that check for
the superblock error bit and will not write data, but we should not let
the filesystem appear read-write.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/super.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3aab10c..3864807 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1340,6 +1340,12 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		if (ret)
 			goto restore;
 	} else {
+		if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state)) {
+			btrfs_err(fs_info,
+				"Remounting read-write after error is not allowed\n");
+			ret = -EINVAL;
+			goto restore;
+		}
 		if (fs_info->fs_devices->rw_devices == 0) {
 			ret = -EACCES;
 			goto restore;
-- 
1.7.9

