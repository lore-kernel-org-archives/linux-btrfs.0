Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113AbaDPPC4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 11:02:56 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D8D19AC15
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 15:02:55 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: replace error code from btrfs_drop_extents
Date: Wed, 16 Apr 2014 17:02:54 +0200
Message-Id: <1397660574-9064-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1397580617-13815-1-git-send-email-dsterba@suse.cz>
References: <1397580617-13815-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's a case which clone does not handle and used to BUG_ON instead,
(testcase xfstests/btrfs/035), now returns EINVAL. This error code is
confusing to the ioctl caller, as it normally signifies errorneous
arguments.

Change it to EOPNOTSUPP which allows a fall back to copy instead of
clone. This does not affect the common reflink operation.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
v2: fix error code typo in changelog, pointed out by Mitch

 fs/btrfs/file.c  |    6 +++---
 fs/btrfs/ioctl.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index eb742c07e7a4..bdd0b17150dd 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -800,7 +800,7 @@ next_slot:
 		if (start > key.offset && end < extent_end) {
 			BUG_ON(del_nr > 0);
 			if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-				ret = -EINVAL;
+				ret = -EOPNOTSUPP;
 				break;
 			}
 
@@ -846,7 +846,7 @@ next_slot:
 		 */
 		if (start <= key.offset && end < extent_end) {
 			if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-				ret = -EINVAL;
+				ret = -EOPNOTSUPP;
 				break;
 			}
 
@@ -872,7 +872,7 @@ next_slot:
 		if (start > key.offset && end >= extent_end) {
 			BUG_ON(del_nr > 0);
 			if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-				ret = -EINVAL;
+				ret = -EOPNOTSUPP;
 				break;
 			}
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e79ff6b90cb7..2ad7de94efef 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3066,7 +3066,7 @@ process_slot:
 							 new_key.offset + datal,
 							 1);
 				if (ret) {
-					if (ret != -EINVAL)
+					if (ret != -EOPNOTSUPP)
 						btrfs_abort_transaction(trans,
 								root, ret);
 					btrfs_end_transaction(trans, root);
@@ -3141,7 +3141,7 @@ process_slot:
 							 new_key.offset + datal,
 							 1);
 				if (ret) {
-					if (ret != -EINVAL)
+					if (ret != -EOPNOTSUPP)
 						btrfs_abort_transaction(trans,
 							root, ret);
 					btrfs_end_transaction(trans, root);
-- 
1.7.9

