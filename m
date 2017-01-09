Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34129 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940086AbdAIOjM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jan 2017 09:39:12 -0500
From: Michal Hocko <mhocko@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
Subject: [PATCH 2/2] btrfs: drop gfp mask tweaking in try_release_extent_state
Date: Mon,  9 Jan 2017 15:39:03 +0100
Message-Id: <20170109143903.32280-2-mhocko@kernel.org>
In-Reply-To: <20170109143903.32280-1-mhocko@kernel.org>
References: <20170109143903.32280-1-mhocko@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Michal Hocko <mhocko@suse.com>

try_release_extent_state reduces the gfp mask to GFP_NOFS if it is
compatible. This is true for GFP_KERNEL as well. There is no real
reason to do that though. There is no new lock taken down the
the only consumer of the gfp mask which is
try_release_extent_state
  clear_extent_bit
    __clear_extent_bit
      alloc_extent_state

So this seems just unnecessary and confusing.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/btrfs/extent_io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f6ae94a4acad..8158930c8d4a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4326,8 +4326,6 @@ static int try_release_extent_state(struct extent_map_tree *map,
 			   EXTENT_IOBITS, 0, NULL))
 		ret = 0;
 	else {
-		if ((mask & GFP_NOFS) == GFP_NOFS)
-			mask = GFP_NOFS;
 		/*
 		 * at this point we can safely clear everything except the
 		 * locked bit and the nodatasum bit
-- 
2.11.0

