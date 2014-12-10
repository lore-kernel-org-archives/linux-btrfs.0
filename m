Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:36436 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933302AbaLJVFl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:41 -0500
Received: from mail-in-02-z2.arcor-online.net (mail-in-02-z2.arcor-online.net [151.189.8.14])
	by mx.arcor.de (Postfix) with ESMTP id 7AF36878C
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:40 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 05/18] btrfs-progs: ctree.h: fix btrfs_inode_[amc]time
Date: Wed, 10 Dec 2014 21:51:35 +0100
Message-Id: <1418244708-7087-6-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

make btrfs_inode_[amc]time work like the other btrfs_inode_xxx
functions. The current definition appears broken to me; it never
returns valid pointer unless an extent buffer address is added.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 ctree.h |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/ctree.h b/ctree.h
index 89036de..1d5a5fc 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1414,27 +1414,30 @@ BTRFS_SETGET_STACK_FUNCS(stack_inode_flags,
 			 struct btrfs_inode_item, flags, 64);
 
 static inline struct btrfs_timespec *
-btrfs_inode_atime(struct btrfs_inode_item *inode_item)
+btrfs_inode_atime(struct extent_buffer *eb,
+		  struct btrfs_inode_item *inode_item)
 {
 	unsigned long ptr = (unsigned long)inode_item;
 	ptr += offsetof(struct btrfs_inode_item, atime);
-	return (struct btrfs_timespec *)ptr;
+	return (struct btrfs_timespec *)(ptr + eb->data);
 }
 
 static inline struct btrfs_timespec *
-btrfs_inode_mtime(struct btrfs_inode_item *inode_item)
+btrfs_inode_mtime(struct extent_buffer *eb,
+		  struct btrfs_inode_item *inode_item)
 {
 	unsigned long ptr = (unsigned long)inode_item;
 	ptr += offsetof(struct btrfs_inode_item, mtime);
-	return (struct btrfs_timespec *)ptr;
+	return (struct btrfs_timespec *)(ptr + eb->data);
 }
 
 static inline struct btrfs_timespec *
-btrfs_inode_ctime(struct btrfs_inode_item *inode_item)
+btrfs_inode_ctime(struct extent_buffer *eb,
+		  struct btrfs_inode_item *inode_item)
 {
 	unsigned long ptr = (unsigned long)inode_item;
 	ptr += offsetof(struct btrfs_inode_item, ctime);
-	return (struct btrfs_timespec *)ptr;
+	return (struct btrfs_timespec *)(ptr + eb->data);
 }
 
 static inline struct btrfs_timespec *
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
