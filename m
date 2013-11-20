Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KTOF5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 09:05:57 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, David Sterba <dsterba@suse.cz>,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/2] Documentation: filesystems: add new btrfs mount options
Date: Wed, 20 Nov 2013 15:05:51 +0100
Message-Id: <1384956351-18832-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two new options were added in 3.12: commit and rescan_uuid_tree

CC: linux-doc@vger.kernel.org
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/filesystems/btrfs.txt | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 9dae59407437..3744ec373db9 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -70,6 +70,12 @@ Unless otherwise specified, all options default to off.
 
 	See comments at the top of fs/btrfs/check-integrity.c for more info.
 
+  commit=<seconds>
+	Set the interval of periodic commit, 30 seconds by default. Higher
+	values defer data being synced to permanent storage with obvious
+	consequences when the system crashes. The upper bound is not forced,
+	but a warning is printed if it's more than 300 seconds (5 minutes).
+
   compress
   compress=<type>
   compress-force
@@ -154,7 +160,11 @@ Unless otherwise specified, all options default to off.
 	Currently this scans a list of several previous tree roots and tries to 
 	use the first readable.
 
- skip_balance
+  rescan_uuid_tree
+	Force check and rebuild procedure of the UUID tree. This should not be
+	normally be needed.
+
+  skip_balance
 	Skip automatic resume of interrupted balance operation after mount.
 	May be resumed with "btrfs balance resume."
 
-- 
1.8.4.2

