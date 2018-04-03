Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35625 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753094AbeDCSg7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 14:36:59 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6DC39AC76
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Apr 2018 18:36:58 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 13/16] btrfs: remove redundant read-only check from btrfs_cancel_balance
Date: Tue,  3 Apr 2018 20:34:31 +0200
Message-Id: <afdb0e99249c050b26a200ccbbc772a1ef90c1a4.1522780026.git.dsterba@suse.com>
In-Reply-To: <cover.1522780026.git.dsterba@suse.com>
References: <cover.1522780026.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Balance cannot be started on a read-only filesystem and will have to
finish/exit before eg. going to read-only via remount. Cancelling does
not need to check for that.

In case the filesystem is forcibly set to read-only after an error,
balance will finish anyway and if the cancel call is too fast it will
just wait for that to happen. Again does not have to check.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a0420af1fad9..2956e7b4cb9f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4053,9 +4053,6 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
 
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 {
-	if (sb_rdonly(fs_info->sb))
-		return -EROFS;
-
 	mutex_lock(&fs_info->balance_mutex);
 	if (!fs_info->balance_ctl) {
 		mutex_unlock(&fs_info->balance_mutex);
-- 
2.16.2

