Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17821 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489AbbBIHGM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:06:12 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 3/4] Btrfs-progs: test-btrfs-devmgt.sh support if btrfs is root fs
Date: Mon,  9 Feb 2015 15:05:05 +0800
Message-Id: <1423465506-30934-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423465506-30934-1-git-send-email-anand.jain@oracle.com>
References: <1423465506-30934-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/test-btrfs-devmgt.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tests/test-btrfs-devmgt.sh b/tests/test-btrfs-devmgt.sh
index 5facbdb..55bc877 100755
--- a/tests/test-btrfs-devmgt.sh
+++ b/tests/test-btrfs-devmgt.sh
@@ -96,6 +96,10 @@ TEST_FSID=1c52f894-0ead-43d6-847a-d42359f78370
 #TMP_FILE=''
 TMP_FILE=`mktemp`
 
+#If the btrfs is root fs as well then set this
+CANT_CLEAN='yes'
+#CANT_CLEAN=''
+
 ent_cont()
 {
 	echo -n "Enter to continue: "
@@ -110,7 +114,7 @@ erase()
 
 clean()
 {
-	modprobe -r btrfs && modprobe btrfs
+	[[ -z $CANT_CLEAN ]] && modprobe -r btrfs && modprobe btrfs
 }
 
 collect_sysfs()
-- 
1.9.1

