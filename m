Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55472 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989Ab3CYUC0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 16:02:26 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CAF119A068E
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2013 14:02:25 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id OmwFDlfznvT04JBo (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2013 14:02:25 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix space leak when we fail to reserve metadata space
Date: Mon, 25 Mar 2013 16:09:48 -0400
Message-ID: <1364242188-17568-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave reported a warning when running xfstest 275.  We have been leaking delalloc
metadata space when our reservations fail.  This is because we were improperly
calculating how much space to free for our checksum reservations.  The problem
is we would sometimes free up space that had already been freed in another
thread and we would end up with negative usage for the delalloc space.  This
patch fixes the problem by calculating how much space the other threads would
have already freed, and then calculate how much space we need to free had we not
done the reservation at all, and then freeing any excess space.  This makes
xfstests 275 no longer have leaked space.  Thanks

Cc: stable@vger.kernel.org
Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 26fc9fc..c08c7c8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4909,14 +4909,49 @@ out_fail:
 	 * If the inodes csum_bytes is the same as the original
 	 * csum_bytes then we know we haven't raced with any free()ers
 	 * so we can just reduce our inodes csum bytes and carry on.
-	 * Otherwise we have to do the normal free thing to account for
-	 * the case that the free side didn't free up its reserve
-	 * because of this outstanding reservation.
 	 */
-	if (BTRFS_I(inode)->csum_bytes == csum_bytes)
+	if (BTRFS_I(inode)->csum_bytes == csum_bytes) {
 		calc_csum_metadata_size(inode, num_bytes, 0);
-	else
-		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
+	} else {
+		u64 orig_csum_bytes = BTRFS_I(inode)->csum_bytes;
+		u64 bytes;
+
+		/*
+		 * This is tricky, but first we need to figure out how much we
+		 * free'd from any free-ers that occured during this
+		 * reservation, so we reset ->csum_bytes to the csum_bytes
+		 * before we dropped our lock, and then call the free for the
+		 * number of bytes that were freed while we were trying our
+		 * reservation.
+		 */
+		bytes = csum_bytes - BTRFS_I(inode)->csum_bytes;
+		BTRFS_I(inode)->csum_bytes = csum_bytes;
+		to_free = calc_csum_metadata_size(inode, bytes, 0);
+
+
+		/*
+		 * Now we need to see how much we would have freed had we not
+		 * been making this reservation and our ->csum_bytes were not
+		 * artificially inflated.
+		 */
+		BTRFS_I(inode)->csum_bytes = csum_bytes - num_bytes;
+		bytes = csum_bytes - orig_csum_bytes;
+		bytes = calc_csum_metadata_size(inode, bytes, 0);
+
+		/*
+		 * Now reset ->csum_bytes to what it should be.  If bytes is
+		 * more than to_free then we would have free'd more space had we
+		 * not had an artificially high ->csum_bytes, so we need to free
+		 * the remainder.  If bytes is the same or less then we don't
+		 * need to do anything, the other free-ers did the correct
+		 * thing.
+		 */
+		BTRFS_I(inode)->csum_bytes = orig_csum_bytes - num_bytes;
+		if (bytes > to_free)
+			to_free = bytes - to_free;
+		else
+			to_free = 0;
+	}
 	spin_unlock(&BTRFS_I(inode)->lock);
 	if (dropped)
 		to_free += btrfs_calc_trans_metadata_size(root, dropped);
-- 
1.7.7.6

