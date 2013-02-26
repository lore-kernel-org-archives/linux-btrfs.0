Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758711Ab3BZUmn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 15:42:43 -0500
Message-ID: <512D1E3E.9050907@redhat.com>
Date: Tue, 26 Feb 2013 14:42:38 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] xfstests: handle new mkfs.btrfs -f option cleanly
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I added an "-f" option to mkfs.btrfs to force overwrite
of an existing filesystem.  Now on an xfstests run, new
mkfs.btrfs requires it, and old mkfs.btrfs cannot accept
it.

So, add a helper which works out whether -f is needed,
and add it to the MKFS_BTRFS_PROG env. var as necessary,
so that it is an always-included option during the tests.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common.config b/common.config
index 57f505d..9f1d309 100644
--- a/common.config
+++ b/common.config
@@ -101,6 +101,17 @@ set_prog_path()
     return 1
 }
 
+# Handle mkfs.btrfs which does (or does not) require -f to overwrite
+set_btrfs_mkfs_prog_path_with_opts()
+{
+	p=`set_prog_path mkfs.btrfs`
+	if grep -q 'force overwrite' $p; then
+		echo "$p -f"
+	else
+		echo $p
+	fi
+}
+
 _fatal()
 {
     echo "$*"
@@ -185,7 +196,7 @@ case "$HOSTOS" in
     Linux)
         export MKFS_XFS_PROG="`set_prog_path mkfs.xfs`"
         export MKFS_UDF_PROG="`set_prog_path mkudffs`"
-        export MKFS_BTRFS_PROG="`set_prog_path mkfs.btrfs`"
+        export MKFS_BTRFS_PROG="`set_btrfs_mkfs_prog_path_with_opts`"
         export BTRFS_UTIL_PROG="`set_prog_path btrfs`"
         export XFS_FSR_PROG="`set_prog_path xfs_fsr`"
         export MKFS_NFS_PROG="false"

