Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:37249 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaBKNA0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 08:00:26 -0500
Received: by mail-yh0-f42.google.com with SMTP id a41so6727208yho.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 05:00:24 -0800 (PST)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH] btrfs-progs: Remove superfluous BUG_ON check.
Date: Tue, 11 Feb 2014 07:00:12 -0600
Message-Id: <1392123612-11065-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function call that set the ret parameter evaluated in this
BUG_ON was removed in a previous commit:
11be10f71e1af5256f221feb9e91300b3e28bbef
Btrfs-progs: make fsck fix certain file extent inconsistencies

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 cmds-check.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index eef7c6c..ffc5d3e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4037,7 +4037,6 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 				parent, owner, key.objectid, key.offset -
 				btrfs_file_extent_offset(buf, fi), 1, 1,
 				btrfs_file_extent_disk_num_bytes(buf, fi));
-			BUG_ON(ret);
 		}
 	} else {
 		int level;
-- 
1.8.3.2

