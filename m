Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbdBMJeG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:06 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4C603AC53
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:05 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 05/29] btrfs: remove unused parameter from write_dev_supers
Date: Mon, 13 Feb 2017 10:33:36 +0100
Message-Id: <6a514256c5f13576cc002182224e39be8a2bc05e.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The barriers are handled by the caller.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 48846d215e97..43e71457c193 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3410,7 +3410,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
  */
 static int write_dev_supers(struct btrfs_device *device,
 			    struct btrfs_super_block *sb,
-			    int do_barriers, int wait, int max_mirrors)
+			    int wait, int max_mirrors)
 {
 	struct buffer_head *bh;
 	int i;
@@ -3752,7 +3752,7 @@ static int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
 
-		ret = write_dev_supers(dev, sb, do_barriers, 0, max_mirrors);
+		ret = write_dev_supers(dev, sb, 0, max_mirrors);
 		if (ret)
 			total_errors++;
 	}
@@ -3775,7 +3775,7 @@ static int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		ret = write_dev_supers(dev, sb, do_barriers, 1, max_mirrors);
+		ret = write_dev_supers(dev, sb, 1, max_mirrors);
 		if (ret)
 			total_errors++;
 	}
-- 
2.10.1

