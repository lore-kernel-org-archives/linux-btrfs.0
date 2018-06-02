Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:40163 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbeFBVcV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jun 2018 17:32:21 -0400
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id DDCBB20103
        for <linux-btrfs@vger.kernel.org>; Sat,  2 Jun 2018 23:26:41 +0200 (CEST)
From: Hans van Kranenburg <hans@knorrie.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fi-usage: fix RAID10 raw disk usage
Date: Sat,  2 Jun 2018 23:26:41 +0200
Message-Id: <20180602212641.928-1-hans@knorrie.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case of RAID10, fi usage is reporting half the amount of allocated
space and twice the amount of unallocated disk space. Let's fix this.

For example, a RAID10 chunk of 3GiB with num_stripes 6, half of the
stripes (dev extents) are a mirror of the other half, so the 3GiB of
actual data has to be divided by 3, and not 6 to get the size of each of
those device extents.

Signed-off-by: Hans van Kranenburg <hans@knorrie.org>
---
 cmds-fi-usage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index b9a2b1c8..3bd2ccdf 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -660,7 +660,7 @@ static u64 calc_chunk_size(struct chunk_info *ci)
 	else if (ci->type & BTRFS_BLOCK_GROUP_RAID6)
 		return ci->size / (ci->num_stripes -2);
 	else if (ci->type & BTRFS_BLOCK_GROUP_RAID10)
-		return ci->size / ci->num_stripes;
+		return ci->size / (ci->num_stripes / 2);
 	return ci->size;
 }
 
-- 
2.17.1

