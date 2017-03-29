Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31550 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752762AbdC2Rzj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 13:55:39 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] Btrfs: fix wrong failed mirror_num of read-repair on raid56
Date: Wed, 29 Mar 2017 10:54:26 -0700
Message-Id: <1490810066-18764-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1490382822-25344-1-git-send-email-bo.li.liu@oracle.com>
References: <1490382822-25344-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In raid56 scenario, after trying parity recovery, we didn't set
mirror_num for btrfs_bio with failed mirror_num, hence
end_bio_extent_readpage() will report a random mirror_num in dmesg
log.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Set mirror_num inside raid56_parity_recover so that all callers
can get a correct mirror_num if they need.

 fs/btrfs/raid56.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 1571bf2..a333acc 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2118,6 +2118,11 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
 	struct btrfs_raid_bio *rbio;
 	int ret;
 
+	if (generic_io) {
+		ASSERT(bbio->mirror_num == mirror_num);
+		btrfs_io_bio(bio)->mirror_num = mirror_num;
+	}
+
 	rbio = alloc_rbio(fs_info, bbio, stripe_len);
 	if (IS_ERR(rbio)) {
 		if (generic_io)
-- 
2.5.5

