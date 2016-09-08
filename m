Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46383 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753306AbcIHCwe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Sep 2016 22:52:34 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2] fstests: common: Enhance _exclude_scratch_mount_option to handle multiple options
Date: Thu,  8 Sep 2016 10:52:21 +0800
Message-Id: <20160908025221.11618-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enhance _exclude_scratch_mount_option() function to normalize mount
options.
Now it can understand and extract real mount option from string like
"-o opt1,opt2 -oopt3".

And now we do word grep to handle mount options like noinode_cache and
inode_cache.

Finally, allow it to accept multiple options at the same time.
No need for multiple _exclude_scratch_mount_option lines now

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2:
   Don't introduce new 'fstype' parameter, suggested by Dave and Eryu.
   Use easier grep -w method, suggested by Dave and Eryu.
---
 common/rc      | 22 ++++++++++++++++++----
 tests/ext4/271 |  6 ++----
 tests/xfs/134  |  3 +--
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/common/rc b/common/rc
index 04039a4..23c007a 100644
--- a/common/rc
+++ b/common/rc
@@ -3183,12 +3183,26 @@ _require_cloner()
 		_notrun "cloner binary not present at $CLONER_PROG"
 }
 
-# skip test if MKFS_OPTIONS contains the given string
+# Normalize mount options from global $MOUNT_OPTIONS
+# Convert options like "-o opt1,opt2 -oopt3" to
+# "opt1 opt2 opt3"
+_normalize_mount_options()
+{
+	echo $MOUNT_OPTIONS | sed -n 's/-o\s*\(\S*\)/\1/gp' |\
+		sed 's/,/ /g'
+}
+
+# skip test if MOUNT_OPTIONS contains the given string
 _exclude_scratch_mount_option()
 {
-	if echo $MOUNT_OPTIONS | grep -q "$1"; then
-		_notrun "mount option \"$1\" not allowed in this test"
-	fi
+	mnt_opts=$(_normalize_mount_options)
+
+	while [ $# -gt 1 ]; do
+		if echo $mnt_opts | grep -qw "$1"; then
+			_notrun "mount option \"$1\" not allowed in this test"
+		fi
+		shift
+	done
 }
 
 _require_atime()
diff --git a/tests/ext4/271 b/tests/ext4/271
index 8674090..6f61e51 100755
--- a/tests/ext4/271
+++ b/tests/ext4/271
@@ -41,10 +41,8 @@ _supported_os Linux
 _require_scratch
 # this test needs no journal to be loaded, skip on journal related mount
 # options, otherwise mount would fail with "-o noload" mount option
-_exclude_scratch_mount_option "data="
-_exclude_scratch_mount_option "commit="
-_exclude_scratch_mount_option "journal_checksum"
-_exclude_scratch_mount_option "journal_async_commit"
+_exclude_scratch_mount_option "data" "commit" "journal_checksum" \
+			      "journal_async_commit"
 
 rm -f $seqres.full
 _scratch_mkfs_sized $((128 * 1024 * 1024)) >> $seqres.full 2>&1
diff --git a/tests/xfs/134 b/tests/xfs/134
index b3a1107..21fe1ed 100755
--- a/tests/xfs/134
+++ b/tests/xfs/134
@@ -51,8 +51,7 @@ _supported_os Linux IRIX
 _require_test
 _require_xfs_quota
 # we can't run with group quotas
-_exclude_scratch_mount_option "gquota"
-_exclude_scratch_mount_option "grpquota"
+_exclude_scratch_mount_option "gquota" "grpquota"
 
 dir=$SCRATCH_MNT/project
 
-- 
2.7.4



