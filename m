Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33457 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbAAXs4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jan 2015 18:48:56 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so27049691wiw.1
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Jan 2015 15:48:55 -0800 (PST)
From: Khaled Ahmed <khaled.gnu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Khaled Ahmed <khaled.gnu@gmail.com>
Subject: [PATCH] Fixing quota error when removing files from a limit exceeded subvols
Date: Fri,  2 Jan 2015 01:48:34 +0200
Message-Id: <1420156114-10849-1-git-send-email-khaled.gnu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Khaled Ahmed <khaled.gnu@gmail.com>
---
 fs/btrfs/qgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 48b60db..b85200d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2408,14 +2408,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
 		    qg->reserved + (s64)qg->rfer + num_bytes >
-		    qg->max_rfer) {
+		    qg->max_rfer - 1 ) {
 			ret = -EDQUOT;
 			goto out;
 		}
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
 		    qg->reserved + (s64)qg->excl + num_bytes >
-		    qg->max_excl) {
+		    qg->max_excl - 1) {
 			ret = -EDQUOT;
 			goto out;
 		}
-- 
2.1.0

