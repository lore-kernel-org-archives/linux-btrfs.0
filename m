Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52702 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759580Ab2INRkY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 13:40:24 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id mlPA1DRTMGKtEjFs (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 11:40:23 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix race when getting the eb out of page->private
Date: Fri, 14 Sep 2012 13:45:49 -0400
Message-ID: <1347644749-4950-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can race when checking wether PagePrivate is set on a page and we
actually have an eb saved in the pages private pointer.  We could have
easily written out this page and released it in the time that we did the
pagevec lookup and actually got around to looking at this page.  So use
mapping->private_lock to ensure we get a consistent view of the
page->private pointer.  This is inline with the alloc and releasepage paths
which use private_lock when manipulating page->private.  Thanks,

Reported-by: David Sterba <dave@jikos.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d48599f..263c392 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3256,19 +3256,34 @@ retry:
 				break;
 			}
 
+			spin_lock(&mapping->private_lock);
+			if (!PagePrivate(page)) {
+				spin_unlock(&mapping->private_lock);
+				continue;
+			}
+
 			eb = (struct extent_buffer *)page->private;
+
+			/*
+			 * Shouldn't happen and normally this would be a BUG_ON
+			 * but no sense in crashing the users box for something
+			 * we can survive anyway.
+			 */
 			if (!eb) {
+				spin_unlock(&mapping->private_lock);
 				WARN_ON(1);
 				continue;
 			}
 
-			if (eb == prev_eb)
+			if (eb == prev_eb) {
+				spin_unlock(&mapping->private_lock);
 				continue;
+			}
 
-			if (!atomic_inc_not_zero(&eb->refs)) {
-				WARN_ON(1);
+			ret = atomic_inc_not_zero(&eb->refs);
+			spin_unlock(&mapping->private_lock);
+			if (!ret)
 				continue;
-			}
 
 			prev_eb = eb;
 			ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
-- 
1.7.7.6

