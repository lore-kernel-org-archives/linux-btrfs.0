Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36112 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbbHEJv6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 05:51:58 -0400
From: mhocko@kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.com>
Subject: [RFC 8/8] btrfs: use __GFP_NOFAIL in alloc_btrfs_bio
Date: Wed,  5 Aug 2015 11:51:24 +0200
Message-Id: <1438768284-30927-9-git-send-email-mhocko@kernel.org>
In-Reply-To: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
References: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Michal Hocko <mhocko@suse.com>

alloc_btrfs_bio is relying on GFP_NOFS to allocate a bio but since "mm:
page_alloc: do not lock up GFP_NOFS allocations upon OOM" this is
allowed to fail which can lead to
[   37.928625] kernel BUG at fs/btrfs/extent_io.c:4045

This is clearly undesirable and the nofail behavior should be explicit
if the allocation failure cannot be tolerated.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 53af23f2c087..57a99d19533d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4914,7 +4914,7 @@ static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
 		 * and the stripes
 		 */
 		sizeof(u64) * (total_stripes),
-		GFP_NOFS);
+		GFP_NOFS|__GFP_NOFAIL);
 	if (!bbio)
 		return NULL;
 
-- 
2.5.0

