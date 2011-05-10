Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:40757 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab1EJTzV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2011 15:55:21 -0400
From: y@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 3/3] btrfs: fix typo 'testeing' -> 'testing'
Date: Tue, 10 May 2011 22:57:29 +0300
Message-Id: <1305057449-12075-4-git-send-email-y>
In-Reply-To: <1305057449-12075-1-git-send-email-y>
References: <1305057449-12075-1-git-send-email-y>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7cd8ab0..72650ce 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1310,7 +1310,7 @@ static int btrfs_set_bit_hook(struct inode *inode,
 
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
-	 * but in this case, we are only testeing for the DELALLOC
+	 * but in this case, we are only testing for the DELALLOC
 	 * bit, which is only set or cleared with irqs on
 	 */
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
@@ -1344,7 +1344,7 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 {
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
-	 * but in this case, we are only testeing for the DELALLOC
+	 * but in this case, we are only testing for the DELALLOC
 	 * bit, which is only set or cleared with irqs on
 	 */
 	if ((state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
-- 
1.7.3.4

