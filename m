Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751706AbdHRQXS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 12:23:18 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 84CB5ABDF
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 16:23:17 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: submit superblock io with REQ_META
Date: Fri, 18 Aug 2017 18:21:53 +0200
Message-Id: <20170818162153.22389-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The superblock is also metadata of the filesystem so the relevant IO
should be tagged as such.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 90b967ae46d0..21b55e8caf33 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3433,9 +3433,11 @@ static int write_dev_supers(struct btrfs_device *device,
 		 */
 		if (i == 0) {
 			ret = btrfsic_submit_bh(REQ_OP_WRITE,
-						REQ_SYNC | REQ_FUA, bh);
+						REQ_SYNC | REQ_FUA | REQ_META,
+						bh);
 		} else {
-			ret = btrfsic_submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
+			ret = btrfsic_submit_bh(REQ_OP_WRITE,
+						REQ_SYNC | REQ_META, bh);
 		}
 		if (ret)
 			errors++;
-- 
2.14.0

