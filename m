Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbcGONb4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 09:31:56 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 255F2ACBB
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 13:31:55 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: remove obsolete part of comment in statfs
Date: Fri, 15 Jul 2016 15:31:56 +0200
Message-Id: <1468589516-2249-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The mixed blockgroup reporting has been fixed by commit
ae02d1bd070767e109f4a6f1bb1f466e9698a355
"btrfs: fix mixed block count of available space"

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 60e7179ed4b7..135fe88de568 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2030,9 +2030,6 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
  * chunk).
  *
  * If metadata is exhausted, f_bavail will be 0.
- *
- * FIXME: not accurate for mixed block groups, total and free/used are ok,
- * available appears slightly larger.
  */
 static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-- 
2.7.1

