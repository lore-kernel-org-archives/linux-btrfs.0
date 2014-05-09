Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3781 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756913AbaEIUke (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 16:40:34 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>, <sandeen@redhat.com>
Subject: [PATCH] xfstests: fix selinux context handling
Date: Fri, 9 May 2014 16:40:27 -0400
Message-ID: <1399668027-12912-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the new config stuff we lost the selinux options being set for systems with
selinux turned on.  We want the selinux context set all the time, wether we
provide a MOUNT_OPTIONS value or not, so take this logic out of _mount_opts()
and just put it in the body of common/config

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 common/config | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/common/config b/common/config
index e8bcf48..a2f55cf 100644
--- a/common/config
+++ b/common/config
@@ -217,16 +217,16 @@ case "$HOSTOS" in
         ;;
 esac
 
+# SELinux adds extra xattrs which can mess up our expected output.
+# So, mount with a context, and they won't be created
+# # nfs_t is a "liberal" context so we can use it.
+if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
+	SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
+	export SELINUX_MOUNT_OPTIONS
+fi
+
 _mount_opts()
 {
-	# SELinux adds extra xattrs which can mess up our expected output.
-	# So, mount with a context, and they won't be created
-	# # nfs_t is a "liberal" context so we can use it.
-	if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
-		SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
-		export SELINUX_MOUNT_OPTIONS
-	fi
-
 	case $FSTYP in
 	xfs)
 		export MOUNT_OPTIONS=$XFS_MOUNT_OPTIONS
-- 
1.8.3.1

