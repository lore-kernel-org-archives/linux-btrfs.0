Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1599 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756400AbaEITog (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 15:44:36 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: [PATCH] xfstests: filter out selinux xattrs for generic/062
Date: Fri, 9 May 2014 15:44:28 -0400
Message-ID: <1399664668-719-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you have selinux enabled getfattr will show the selinux xattrs, which screws
with the golden output of generic/062.  To make matters worse you can't just
greap it out because we'll still get the preamble and newline from getfattr when
the selinux attr is the only attr.  So this is the voodoo I came up with after
way more time than I'm comfortable admitting to make this test pass if you have
selinux enabled.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 common/filter     | 6 ++++++
 tests/generic/062 | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/common/filter b/common/filter
index 05dbae6..16a01ed 100644
--- a/common/filter
+++ b/common/filter
@@ -323,5 +323,11 @@ _filter_ro_mount() {
 	    -e "s/mount: cannot mount block device/mount: cannot mount/g"
 }
 
+# Filter out selinux xattrs from getfattr, and if selinux is the only xattr in
+# the file simply pretend like there were no xattrs
+_filter_selinux_xattr() {
+	grep -v selinux | sed -e "N; s/^\# file: .*\n$//; /^$/d"
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/062 b/tests/generic/062
index 047c930..32f0bca 100755
--- a/tests/generic/062
+++ b/tests/generic/062
@@ -47,7 +47,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 getfattr()
 {
-    $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch
+    $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch | \
+	_filter_selinux_xattr
 }
 
 setfattr()
-- 
1.8.3.1

