Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58865 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753551AbdHUPnw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 11:43:52 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2] btrfs: submit superblock io with REQ_META and REQ_PRIO
Date: Mon, 21 Aug 2017 17:42:27 +0200
Message-Id: <20170821154227.13644-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The superblock is also metadata of the filesystem so the relevant IO
should be tagged as such. We also tag it as high priority, as it's the
last block committed for metadata from a given transaction. Any delays
would effectively block the whole transaction, also blocking any other
operation holding the device_list_mutex.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 90b967ae46d0..27d458640536 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3433,9 +3433,10 @@ static int write_dev_supers(struct btrfs_device *device,
 		 */
 		if (i == 0) {
 			ret = btrfsic_submit_bh(REQ_OP_WRITE,
-						REQ_SYNC | REQ_FUA, bh);
+				REQ_SYNC | REQ_FUA | REQ_META | REQ_PRIO, bh);
 		} else {
-			ret = btrfsic_submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
+			ret = btrfsic_submit_bh(REQ_OP_WRITE,
+				REQ_SYNC | REQ_META | REQ_PRIO, bh);
 		}
 		if (ret)
 			errors++;
-- 
2.14.0

