Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:42520 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbeHIUcT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:32:19 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 13/17] btrfs: avoid sync IO prioritization on checksum in HMZONED mode
Date: Fri, 10 Aug 2018 03:04:46 +0900
Message-Id: <20180809180450.5091-14-naota@elisp.net>
In-Reply-To: <20180809180450.5091-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By prioritizing sync I/Os, btrfs calls btrfs_map_block() for blocks
allocated later before calling the function allocated earlier. By the
disorder of calling btrfs_map_block(), syncing on I/Os on larger LBAs
sometime wait for I/Os on smaller LBAs.

Since active checksum worker is limited to some specified number, it is
possible to wait for non-starting checksum on smaller LBAs. In such
situation, transactions are stucked waiting for I/Os on smaller LBAs to
finish, which is never finished.

This situation can be reproduced by e.g. fstests btrfs/073.

To avoid such disordering, disable sync IO prioritization for now. In the
future, it will be reworked to finish checksumming of I/Os on smaller I/Os
on committing a transaction.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 00fa6aca9bb5..f79abd5e6b3a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -807,7 +807,7 @@ blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 
 	async->status = 0;
 
-	if (op_is_sync(bio->bi_opf))
+	if (op_is_sync(bio->bi_opf) && !btrfs_fs_incompat(fs_info, HMZONED))
 		btrfs_set_work_high_priority(&async->work);
 
 	btrfs_queue_work(fs_info->workers, &async->work);
-- 
2.18.0

