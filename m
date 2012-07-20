Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:46718 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab2GTUDH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 16:03:07 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 9osbpmSlAo9MbXau (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2012 14:03:05 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't return true in releasepage unless we actually freed the eb
Date: Fri, 20 Jul 2012 16:08:02 -0400
Message-ID: <1342814882-9311-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed while looking at an extent_buffer race that we will
unconditionally return 1 if we get down to release_extent_buffer after
clearing the tree ref.  However we can easily race in here and get a ref on
the eb and not actually free the eb.  So make release_extent_buffer return 1
if it free'd the eb and 0 if not so we can be a little kinder to the vm.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7926e1e..b778fc2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4319,7 +4319,7 @@ static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
 }
 
 /* Expects to have eb->eb_lock already held */
-static void release_extent_buffer(struct extent_buffer *eb, gfp_t mask)
+static int release_extent_buffer(struct extent_buffer *eb, gfp_t mask)
 {
 	WARN_ON(atomic_read(&eb->refs) == 0);
 	if (atomic_dec_and_test(&eb->refs)) {
@@ -4340,9 +4340,11 @@ static void release_extent_buffer(struct extent_buffer *eb, gfp_t mask)
 		btrfs_release_extent_buffer_page(eb, 0);
 
 		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
-		return;
+		return 1;
 	}
 	spin_unlock(&eb->refs_lock);
+
+	return 0;
 }
 
 void free_extent_buffer(struct extent_buffer *eb)
@@ -4981,7 +4983,6 @@ int try_release_extent_buffer(struct page *page, gfp_t mask)
 		spin_unlock(&eb->refs_lock);
 		return 0;
 	}
-	release_extent_buffer(eb, mask);
 
-	return 1;
+	return release_extent_buffer(eb, mask);
 }
-- 
1.7.7.6

