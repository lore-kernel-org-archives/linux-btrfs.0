Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:61770 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab3AFOc5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 09:32:57 -0500
Received: by mail-da0-f42.google.com with SMTP id z17so8258871dal.15
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 06:32:57 -0800 (PST)
From: Liu Bo <liub.liubo@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests: fix 284 ENOENT error
Date: Sun,  6 Jan 2013 22:30:38 +0800
Message-Id: <1357482638-27129-1-git-send-email-liub.liubo@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

284 misses a 'mkdir' operation.

Signed-off-by: Liu Bo <liub.liubo@gmail.com>
---
 284 |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/284 b/284
index c00e6f1..7f4a630 100644
--- a/284
+++ b/284
@@ -44,6 +44,7 @@ _create_file()
 	if [ $1 -ne 2 ]; then
 		tmpfile="$SCRATCH_MNT/tmp_file"
 	else
+		mkdir -p $SCRATCH_MNT/tmp_dir
 		tmpfile="$SCRATCH_MNT/tmp_dir/tmp_file"
 	fi
 		
-- 
1.7.7.6

