Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45962 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbeABVjT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jan 2018 16:39:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w02Lb7sN152780
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Jan 2018 21:39:18 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2f8hua82vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jan 2018 21:39:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w02LdHJK016492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Jan 2018 21:39:17 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w02LdHbl001043
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Jan 2018 21:39:17 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2 RESEND] Btrfs: make raid6 rebuild retry more
Date: Tue,  2 Jan 2018 13:36:41 -0700
Message-Id: <20180102203642.14105-1-bo.li.liu@oracle.com>
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
index b078429..c1ed7e8 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2187,11 +2187,21 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
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
index 49810b7..558c6c0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5104,7 +5104,14 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
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

