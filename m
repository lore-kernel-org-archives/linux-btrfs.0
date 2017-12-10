Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45805 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbdLJJUf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 04:20:35 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 5/5] btrfs: cleanup device states define BTRFS_DEV_STATE_FLUSH_SENT
Date: Sun, 10 Dec 2017 17:15:22 +0800
Message-Id: <20171210091522.6061-6-anand.jain@oracle.com>
In-Reply-To: <20171210091522.6061-1-anand.jain@oracle.com>
References: <20171210091522.6061-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently device state is being managed by each individual int
variable such as struct btrfs_device::is_tgtdev_for_dev_replace.
Instead of that declare btrfs_device::dev_state
BTRFS_DEV_STATE_FLUSH_SENT and use the bit operations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3: Define BTRFS_DEV_STATE_FLUSH_SENT as bit nr

 fs/btrfs/disk-io.c | 6 +++---
 fs/btrfs/volumes.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 890e3a6a2f3e..9b20c1f3563b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3359,7 +3359,7 @@ static void write_dev_flush(struct btrfs_device *device)
 	bio->bi_private = &device->flush_wait;
 
 	btrfsic_submit_bio(bio);
-	device->flush_bio_sent = 1;
+	set_bit(BTRFS_DEV_STATE_FLUSH_SENT, &device->dev_state);
 }
 
 /*
@@ -3369,10 +3369,10 @@ static blk_status_t wait_dev_flush(struct btrfs_device *device)
 {
 	struct bio *bio = device->flush_bio;
 
-	if (!device->flush_bio_sent)
+	if (!test_bit(BTRFS_DEV_STATE_FLUSH_SENT, &device->dev_state))
 		return BLK_STS_OK;
 
-	device->flush_bio_sent = 0;
+	clear_bit(BTRFS_DEV_STATE_FLUSH_SENT, &device->dev_state);
 	wait_for_completion_io(&device->flush_wait);
 
 	return bio->bi_status;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index a15f8b103072..826fce3d6825 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -51,6 +51,7 @@ struct btrfs_pending_bios {
 #define BTRFS_DEV_STATE_IN_FS_METADATA	1
 #define BTRFS_DEV_STATE_MISSING		2
 #define BTRFS_DEV_STATE_REPLACE_TGT	3
+#define BTRFS_DEV_STATE_FLUSH_SENT	4
 
 struct btrfs_device {
 	struct list_head dev_list;
-- 
2.7.0

