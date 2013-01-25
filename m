Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab3AYP5M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 10:57:12 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0PFvCje002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2013 10:57:12 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r0PFvBnw003125
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2013 10:57:11 -0500
Message-ID: <5102AB54.3050704@redhat.com>
Date: Fri, 25 Jan 2013 09:57:08 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH, RFC] mkfs: collapse redundant logic in custom_alloc_extent()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It looks to me like the logic in these two if statements are
overlapping.

The test for flags & BTRFS_BLOCK_GROUP_SYSTEM in the 2nd case
should never get triggered, because it would have triggered
on the first case, right?

And since the actions are identical in both cases, this can be
collapsed into one.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s.

Having done that, I now look at the nearly identical
custom_alloc_extent() copy in convert.c, and wonder if it's
intentional that the convert copy does not care about 
BTRFS_BLOCK_GROUP_METADATA, but mkfs does?  I'm not quite
sure what's going on there.

Thanks,
-Eric

diff --git a/mkfs.c b/mkfs.c
index ca850d9..5d77428 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -635,14 +635,10 @@ static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
 
 		cache = btrfs_lookup_block_group(root->fs_info, start);
 		BUG_ON(!cache);
-		if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM ||
-		    last > cache->key.objectid + cache->key.offset) {
-			last = cache->key.objectid + cache->key.offset;
-			continue;
-		}
 
 		if (cache->flags & (BTRFS_BLOCK_GROUP_SYSTEM |
-			    BTRFS_BLOCK_GROUP_METADATA)) {
+			    BTRFS_BLOCK_GROUP_METADATA) ||
+		    last > cache->key.objectid + cache->key.offset) {
 			last = cache->key.objectid + cache->key.offset;
 			continue;
 		}

