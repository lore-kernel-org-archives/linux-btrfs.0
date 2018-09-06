Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56540 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727126AbeIGBzn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 21:55:43 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BF8CBAE23
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2018 21:18:21 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/3] btrfs: don't attempt to trim devices that don't support it
Date: Thu,  6 Sep 2018 17:18:15 -0400
Message-Id: <20180906211816.12121-3-jeffm@suse.com>
In-Reply-To: <20180906211816.12121-1-jeffm@suse.com>
References: <20180906211816.12121-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

We check whether any device the file system is using supports discard
in the ioctl call, but then we attempt to trim free extents on every
device regardless of whether discard is supported.  Due to the way
we mask off EOPNOTSUPP, we can end up issuing the trim operations
on each free range on devices that don't support it, just wasting time.

Fixes: 499f377f49f08 (btrfs: iterate over unused chunk space in FITRIM)
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a0e82589c3e8..92e5e9fd9bdd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10887,6 +10887,10 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 
 	*trimmed = 0;
 
+	/* Discard not supported = nothing to do. */
+	if (!blk_queue_discard(bdev_get_queue(device->bdev)))
+		return 0;
+
 	/* Not writeable = nothing to do. */
 	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
 		return 0;
-- 
2.12.3
