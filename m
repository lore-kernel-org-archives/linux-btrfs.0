Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2620 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750847AbdHRIiU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 04:38:20 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH] btrfs: use btrfsic_submit_bio instead of submit_bio in write_dev_flush
Date: Fri, 18 Aug 2017 16:38:07 +0800
Message-ID: <20170818083807.12572-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although this bio has no data attached, it will reach this condition
(bio->bi_opf & REQ_PREFLUSH) and then update the flush_gen of dev_state
in __btrfsic_submit_bio. So we should still submit it through integrity
checker. Otherwise, the integrity checker will throw the following warning
when I mount a newly created btrfs filesystem.

[10264.755497] btrfs: attempt to write superblock which references block M @29523968 (sdb1/1111654400/0) which is not flushed out of disk's write cache (block flush_gen=1, dev->flush_gen=0)!
[10264.755498] btrfs: attempt to write superblock which references block M @29523968 (sdb1/37912576/0) which is not flushed out of disk's write cache (block flush_gen=1, dev->flush_gen=0)!

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9e187df3c106..0dac37439bb9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3515,7 +3515,7 @@ static void write_dev_flush(struct btrfs_device *device)
 	init_completion(&device->flush_wait);
 	bio->bi_private = &device->flush_wait;
 
-	submit_bio(bio);
+	btrfsic_submit_bio(bio);
 	device->flush_bio_sent = 1;
 }
 
-- 
2.14.1



