Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab3KTNci (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 08:32:38 -0500
From: David Sterba <dsterba@suse.cz>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: update kconfig help text
Date: Wed, 20 Nov 2013 14:32:34 +0100
Message-Id: <1384954354-16679-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reflect the current status. Portions of the text taken from the
wiki pages.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

Please enqueue for 3.13

 fs/btrfs/Kconfig | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index f9d5094e1029..aa976eced2d2 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -9,12 +9,17 @@ config BTRFS_FS
 	select XOR_BLOCKS
 
 	help
-	  Btrfs is a new filesystem with extents, writable snapshotting,
-	  support for multiple devices and many more features.
+	  Btrfs is a general purpose copy-on-write filesystem with extents,
+	  writable snapshotting, support for multiple devices and many more
+	  features focused on fault tolerance, repair and easy administration.
 
-	  Btrfs is highly experimental, and THE DISK FORMAT IS NOT YET
-	  FINALIZED.  You should say N here unless you are interested in
-	  testing Btrfs with non-critical data.
+	  The filesystem disk format is no longer unstable, and it's not
+	  expected to change unless there are strong reasons to do so. If there
+	  is a format change, file systems with a unchanged format will
+	  continue to be mountable and usable by newer kernels.
+
+	  For more information, please see the web pages at
+	  http://btrfs.wiki.kernel.org.
 
 	  To compile this file system support as a module, choose M here. The
 	  module will be called btrfs.
-- 
1.8.4.2

