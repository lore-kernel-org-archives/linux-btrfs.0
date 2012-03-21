From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH RESEND] Xfstest: make 218 support btrfs
Date: Wed, 21 Mar 2012 13:26:05 +0800
Message-ID: <1332307565-26036-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <linux-btrfs@vger.kernel.org>, <hch@infradead.org>
To: <xfs@oss.sgi.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs progs has a defragment tool, so we can test 218 on btrfs now.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 218           |    2 +-
 common.defrag |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/218 b/218
index 53d0b61..77782c6 100755
--- a/218
+++ b/218
@@ -44,7 +44,7 @@ _cleanup()
 . ./common.defrag
 
 # real QA test starts here
-_supported_fs xfs ext4
+_supported_fs xfs ext4 btrfs
 _supported_os Linux
 
 _setup_testdir
diff --git a/common.defrag b/common.defrag
index 4850803..ea6c14c 100644
--- a/common.defrag
+++ b/common.defrag
@@ -29,6 +29,9 @@ _require_defrag()
     ext4|ext4dev)
         DEFRAG_PROG=/usr/bin/e4defrag
 	;;
+    btrfs)
+	DEFRAG_PROG="$BTRFS_UTIL_PROG filesystem defragment"
+	;;
     *)
         _notrun "defragmentation not supported for fstype \"$FSTYP\""
 	;;
-- 
1.6.5.2

