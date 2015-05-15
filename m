Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934443AbbEOU2b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 16:28:31 -0400
From: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Fix bashism in fsck.btrfs for debian/ubuntu dash.
Date: Fri, 15 May 2015 21:28:29 +0100
Message-Id: <1431721709-5146-1-git-send-email-dimitri.j.ledkov@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bug-Debian: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=784911
Signed-off-by: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
---
 fsck.btrfs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fsck.btrfs b/fsck.btrfs
index f056a7f..3a92804 100755
--- a/fsck.btrfs
+++ b/fsck.btrfs
@@ -31,7 +31,7 @@ if [ ! -e $DEV ]; then
 	echo "$0: $DEV does not exist"
 	exit 8
 fi
-if [ "$AUTO" == "false" ]; then
+if [ "false" = "$AUTO" ]; then
 	echo "If you wish to check the consistency of a BTRFS filesystem or"
 	echo "repair a damaged filesystem, see btrfs(8) subcommand 'check'."
 fi
-- 
2.1.4

