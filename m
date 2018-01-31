Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35522 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751452AbeAaGQm (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 31 Jan 2018 01:16:42 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs: volumes: Cleanup stripe size calculation
Date: Wed, 31 Jan 2018 14:16:34 +0800
Message-Id: <20180131061634.17383-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup the following things:
1) open coded SZ_16M round up
2) use min() to replace open-coded size comparison
3) code style

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cb0a8d27661b..90ad716d2b50 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4761,18 +4761,17 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	 * and compare that answer with the max chunk size
 	 */
 	if (stripe_size * data_stripes > max_chunk_size) {
-		u64 mask = (1ULL << 24) - 1;
-
 		stripe_size = div_u64(max_chunk_size, data_stripes);
 
 		/* bump the answer up to a 16MB boundary */
-		stripe_size = (stripe_size + mask) & ~mask;
+		stripe_size = round_up(stripe_size, SZ_16M);
 
-		/* but don't go higher than the limits we found
+		/*
+		 * but don't go higher than the limits we found
 		 * while searching for free extents
 		 */
-		if (stripe_size > devices_info[ndevs-1].max_avail)
-			stripe_size = devices_info[ndevs-1].max_avail;
+		stripe_size = min(devices_info[ndevs - 1].max_avail,
+				  stripe_size);
 	}
 
 	stripe_size = div_u64(stripe_size, dev_stripes);
-- 
2.16.1

