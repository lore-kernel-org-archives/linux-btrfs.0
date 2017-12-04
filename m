Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49760 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbdLDXnZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 18:43:25 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vB4NhOkT029481
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB4NhND1013538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:23 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vB4NhNkN031379
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:23 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: make raid6 rebuild retry more
Date: Mon,  4 Dec 2017 15:40:37 -0700
Message-Id: <20171204224037.7556-4-bo.li.liu@oracle.com>
In-Reply-To: <20171204224037.7556-1-bo.li.liu@oracle.com>
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a scenario that can end up with rebuild process failing to
return good content, i.e.
suppose that all disks can be read without problems and if the content
that was read out doesn't match its checksum, currently for raid6
btrfs at most retries twice,

- the 1st retry is to rebuild with all other stripes, it'll eventually
  be a raid5 xor rebuild,
- if the 1st fails, the 2nd retry will deliberately fail parity p so
  that it will do raid6 style rebuild,

however, the chances are that another non-parity stripe content also
has something corrupted, so that the above retries are not able to
return correct content, and users will think of this as data loss.
More seriouly, if the loss happens on some important internal btree
roots, it could refuse to mount.

This extends btrfs to do more retries and each retry fails only one
stripe.  Since raid6 can tolerate 2 disk failures, if there is one
more failure besides the failure on which we're recovering, this can
always work.

The worst case is to retry as many times as the number of raid6 disks,
but given the fact that such a scenario is really rare in practice,
it's still acceptable.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c  | 18 ++++++++++++++----
 fs/btrfs/volumes.c |  9 ++++++++-
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 8d09535..064d5bc 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2166,11 +2166,21 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
 	}
 
 	/*
-	 * reconstruct from the q stripe if they are
-	 * asking for mirror 3
+	 * Loop retry:
+	 * for 'mirror == 2', reconstruct from all other stripes.
+	 * for 'mirror_num > 2', select a stripe to fail on every retry.
 	 */
-	if (mirror_num == 3)
-		rbio->failb = rbio->real_stripes - 2;
+	if (mirror_num > 2) {
+		/*
+		 * 'mirror == 3' is to fail the p stripe and
+		 * reconstruct from the q stripe.  'mirror > 3' is to
+		 * fail a data stripe and reconstruct from p+q stripe.
+		 */
+		rbio->failb = rbio->real_stripes - (mirror_num - 1);
+		ASSERT(rbio->failb > 0);
+		if (rbio->failb <= rbio->faila)
+			rbio->failb--;
+	}
 
 	ret = lock_stripe_add(rbio);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b397375..95371f8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5094,7 +5094,14 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID5)
 		ret = 2;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
-		ret = 3;
+		/*
+		 * There could be two corrupted data stripes, we need
+		 * to loop retry in order to rebuild the correct data.
+		 * 
+		 * Fail a stripe at a time on every retry except the
+		 * stripe under reconstruction.
+		 */
+		ret = map->num_stripes;
 	else
 		ret = 1;
 	free_extent_map(em);
-- 
2.9.4

