Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18033 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966243AbdCXTOw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Mar 2017 15:14:52 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: fix wrong failed mirror_num of read-repair on raid56
Date: Fri, 24 Mar 2017 12:13:42 -0700
Message-Id: <1490382822-25344-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In raid56 senario, after trying parity recovery, we didn't set
mirror_num for btrfs_bio with failed mirror_num, hence
end_bio_extent_readpage() will report a random mirror_num in dmesg
log.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 73d56ee..be64e4a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6197,6 +6197,7 @@ int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 		} else {
 			ret = raid56_parity_recover(fs_info, bio, bbio,
 						    map_length, mirror_num, 1);
+			btrfs_io_bio(bio)->mirror_num = mirror_num;
 		}
 
 		btrfs_bio_counter_dec(fs_info);
-- 
2.5.5

