Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbcF0UOR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 16:14:17 -0400
From: jeffm@suse.com
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2 1/4] btrfs/048: extend _filter_btrfs_prop_error to handle additional errors
Date: Mon, 27 Jun 2016 16:14:11 -0400
Message-Id: <1467058454-25907-2-git-send-email-jeffm@suse.com>
In-Reply-To: <1467058454-25907-1-git-send-email-jeffm@suse.com>
References: <1467058454-25907-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

btrfsprogs v4.5.3 changed the formatting of some error messages.  This
patch extends the filter for btrfs prop to handle those.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 common/filter.btrfs | 10 +++++++---
 tests/btrfs/048     |  6 ++++--
 tests/btrfs/048.out |  4 ++--
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/common/filter.btrfs b/common/filter.btrfs
index 9970f4d..0cf7f0d 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -72,15 +72,19 @@ _filter_btrfs_compress_property()
 	sed -e "s/compression=\(lzo\|zlib\)/COMPRESSION=XXX/g"
 }
 
-# filter name of the property from the output, optionally verify against $1
+# filter error messages from btrfs prop, optionally verify against $1
 # recognized message(s):
 #  "object is not compatible with property: label"
+#  "invalid value for property:{, value}"
+#  "failed to {get,set} compression for $PATH[.:]: Invalid argument"
 _filter_btrfs_prop_error()
 {
 	if ! [ -z "$1" ]; then
-		sed -e "s/\(compatible with property\): $1/\1/"
+		sed -e "s#\(compatible with property\): $1#\1#" \
+		    -e "s#^\(.*failed to [sg]et compression for $1\)[:.] \(.*\)#\1: \2#"
 	else
-		sed -e "s/^\(.*compatible with property\).*/\1/"
+		sed -e "s#^\(.*compatible with property\).*#\1#" \
+		    -e "s#^\(.*invalid value for property\)[:.].*#\1#"
 	fi
 }
 
diff --git a/tests/btrfs/048 b/tests/btrfs/048
index 4a36303..0b907b0 100755
--- a/tests/btrfs/048
+++ b/tests/btrfs/048
@@ -79,7 +79,8 @@ echo -e "\nTesting subvolume ro property"
 _run_btrfs_util_prog subvolume create $SCRATCH_MNT/sv1
 $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 ro
 echo "***"
-$BTRFS_UTIL_PROG property set $SCRATCH_MNT/sv1 ro foo
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/sv1 ro foo 2>&1 |
+	_filter_btrfs_prop_error
 echo "***"
 $BTRFS_UTIL_PROG property set $SCRATCH_MNT/sv1 ro true
 echo "***"
@@ -99,7 +100,8 @@ $BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
 $BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1 compression
 echo "***"
 $BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/file1 compression \
-	foo 2>&1 | _filter_scratch
+	foo 2>&1 | _filter_scratch |
+	_filter_btrfs_prop_error SCRATCH_MNT/testdir/file1
 echo "***"
 $BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/file1 compression lzo
 $BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
index 0b20d0b..3e4e3d2 100644
--- a/tests/btrfs/048.out
+++ b/tests/btrfs/048.out
@@ -15,7 +15,7 @@ ERROR: object is not compatible with property
 Testing subvolume ro property
 ro=false
 ***
-ERROR: invalid value for property.
+ERROR: invalid value for property
 ***
 ***
 ro=true
@@ -27,7 +27,7 @@ ro=false
 
 Testing compression property
 ***
-ERROR: failed to set compression for SCRATCH_MNT/testdir/file1. Invalid argument
+ERROR: failed to set compression for SCRATCH_MNT/testdir/file1: Invalid argument
 ***
 compression=lzo
 compression=lzo
-- 
1.8.5.6

