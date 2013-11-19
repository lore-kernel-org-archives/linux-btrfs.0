Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3KSMgY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 07:36:24 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 90CFFA7A37
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Nov 2013 13:36:23 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: replace BUG in can_modify_feature
Date: Tue, 19 Nov 2013 13:36:21 +0100
Message-Id: <1384864581-26321-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to crash hard here, it's just reading a sysfs file. The
values considered in switch are from a fixed set, the default case
should not happen at all.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 669fdf777b6c..20a9bafeca78 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -75,7 +75,9 @@ static int can_modify_feature(struct btrfs_feature_attr *fa)
 		clear = BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
 		break;
 	default:
-		BUG();
+		printk(KERN_WARNING "btrfs: sysfs: unknown feature set %d\n",
+				fa->feature_set);
+		return 0;
 	}
 
 	if (set & fa->feature_bit)
-- 
1.8.4.2

