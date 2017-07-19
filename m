Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57712 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753762AbdGSR5t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2017 13:57:49 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 53634AC6B
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jul 2017 17:57:48 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: account that we're waiting for DIO read
Date: Wed, 19 Jul 2017 19:56:32 +0200
Message-Id: <20170719175632.1757-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Correctly account for IO when waiting for a submitted DIO read, the case
when we're retrying.  This only for the accounting purposes and should
not change other behaviour.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eb495e956d53..2fde93548298 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8105,7 +8105,7 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
 			goto next;
 		}
 
-		wait_for_completion(&done.done);
+		wait_for_completion_io(&done.done);
 
 		if (!done.uptodate) {
 			/* We might have another mirror, so try again */
@@ -8219,7 +8219,7 @@ static int __btrfs_subio_endio_read(struct inode *inode,
 			goto next;
 		}
 
-		wait_for_completion(&done.done);
+		wait_for_completion_io(&done.done);
 
 		if (!done.uptodate) {
 			/* We might have another mirror, so try again */
-- 
2.13.0

