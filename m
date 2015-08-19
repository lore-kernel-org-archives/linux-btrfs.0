Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37356 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbbHSMSC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 08:18:02 -0400
From: mhocko@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
Subject: [PATCH 2/2] btrfs: use __GFP_NOFAIL in alloc_btrfs_bio
Date: Wed, 19 Aug 2015 14:17:41 +0200
Message-Id: <1439986661-15896-3-git-send-email-mhocko@kernel.org>
In-Reply-To: <1439986661-15896-1-git-send-email-mhocko@kernel.org>
References: <1439986661-15896-1-git-send-email-mhocko@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Michal Hocko <mhocko@suse.com>

alloc_btrfs_bio relies on GFP_NOFS allocation when committing the
transaction but this allocation context is rather weak wrt. reclaim
capabilities. The page allocator currently tries hard to not fail these
allocations if they are small (<=PAGE_ALLOC_COSTLY_ORDER) but it can
still fail if the _current_ process is the OOM killer victim. Moreover
there is an attempt to move away from the default no-fail behavior and
allow these allocation to fail more eagerly. This would lead to:

[   37.928625] kernel BUG at fs/btrfs/extent_io.c:4045

which is clearly undesirable and the nofail behavior should be explicit
if the allocation failure cannot be tolerated.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/btrfs/volumes.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 53af23f2c087..42b9949dd71d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4914,9 +4914,7 @@ static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
 		 * and the stripes
 		 */
 		sizeof(u64) * (total_stripes),
-		GFP_NOFS);
-	if (!bbio)
-		return NULL;
+		GFP_NOFS|__GFP_NOFAIL);
 
 	atomic_set(&bbio->error, 0);
 	atomic_set(&bbio->refs, 1);
-- 
2.5.0

