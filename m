Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3517 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbbCQPE0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 11:04:26 -0400
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t2HEpLuU006383
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 08:04:26 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1t6m70gcv1-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 08:04:26 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix outstanding_extents accounting in DIO
Date: Tue, 17 Mar 2015 11:04:23 -0400
Message-ID: <1426604663-7663-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are keeping track of how many extents we need to reserve properly based on
the amount we want to write, but we were still incrementing outstanding_extents
if we wrote less than what we requested.  We need to fix this logic to only do
this if we request less than MAX_EXTENT_SIZE or if we write less than
MAX_EXTENT_SIZE when we request an amount larger than MAX_EXTENT_SIZE.  This
fixes the problem Filipe reported with generic/300.  Thanks,

Reported-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 156d0f5..f6d2c56 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7387,7 +7387,24 @@ unlock:
 		if (start + len > i_size_read(inode))
 			i_size_write(inode, start + len);
 
-		if (len < orig_len) {
+		/*
+		 * direct_io can send down chunks > BTRFS_MAX_EXTENT_SIZE, so we
+		 * don't want to jack up outstanding_extents if we're just
+		 * allocating the largest extent we can for a range that we've
+		 * already reserved the approriate number of outstanding_extents
+		 * for.
+		 *
+		 * So if orig_len <= BTRFS_MAX_EXTENT_SIZE and our allocated len
+		 * is less than orig_len then we know we're going to end up with
+		 * more extents than we reserved.
+		 *
+		 * If orig_len > BTRFS_MAX_EXTENT_SIZE but we weren't able to
+		 * allocate a BTRFS_MAX_EXTENT_SIZE extent then we know we have
+		 * to add another outstanding extent.
+		 */
+		if (len < orig_len &&
+		    (orig_len <= BTRFS_MAX_EXTENT_SIZE ||
+		     len < BTRFS_MAX_EXTENT_SIZE)) {
 			spin_lock(&BTRFS_I(inode)->lock);
 			BTRFS_I(inode)->outstanding_extents++;
 			spin_unlock(&BTRFS_I(inode)->lock);
-- 
1.8.3.1

