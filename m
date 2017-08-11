Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56584 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752869AbdHKOld (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Aug 2017 10:41:33 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.21/8.16.0.21) with SMTP id v7BEd2dd006565
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Aug 2017 07:41:32 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2c9bp50pye-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Aug 2017 07:41:32 -0700
Received: from facebook.com (2401:db00:2120:20df:face:0:2d:0)   by
 mx-out.facebook.com (10.103.99.97) with ESMTP  id
 2a0f52787ea311e7a3110002c9931860-1359f150 for <linux-btrfs@vger.kernel.org>;
        Fri, 11 Aug 2017 07:41:31 -0700
From: Chris Mason <clm@fb.com>
To: <stable@vger.kernel.org>
CC: <mail@christoph.anton.mitterer.name>, <linux-btrfs@vger.kernel.org>,
        Omar Sandoval <osandov@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH stable v4.12 backport] Btrfs: fix early ENOSPC due to delalloc
Date: Fri, 11 Aug 2017 07:41:30 -0700
Message-ID: <20170811144130.1325132-1-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

If a lot of metadata is reserved for outstanding delayed allocations, we
rely on shrink_delalloc() to reclaim metadata space in order to fulfill
reservation tickets. However, shrink_delalloc() has a shortcut where if
it determines that space can be overcommitted, it will stop early. This
made sense before the ticketed enospc system, but now it means that
shrink_delalloc() will often not reclaim enough space to fulfill any
tickets, leading to an early ENOSPC. (Reservation tickets don't care
about being able to overcommit, they need every byte accounted for.)

Fix it by getting rid of the shortcut so that shrink_delalloc() reclaims
all of the metadata it is supposed to. This fixes early ENOSPCs we were
seeing when doing a btrfs receive to populate a new filesystem, as well
as early ENOSPCs Christoph saw when doing a big cp -r onto Btrfs.

Fixes: 957780eb2788 ("Btrfs: introduce ticketed enospc infrastructure")
Tested-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: stable@vger.kernel.org
Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/extent-tree.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 33d979e9..83eecd3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4776,10 +4776,6 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 		else
 			flush = BTRFS_RESERVE_NO_FLUSH;
 		spin_lock(&space_info->lock);
-		if (can_overcommit(root, space_info, orig, flush)) {
-			spin_unlock(&space_info->lock);
-			break;
-		}
 		if (list_empty(&space_info->tickets) &&
 		    list_empty(&space_info->priority_tickets)) {
 			spin_unlock(&space_info->lock);
-- 
2.9.3

