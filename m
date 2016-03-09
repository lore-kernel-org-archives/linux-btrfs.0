Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47714 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbcCIIgT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 03:36:19 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v4 1/6] fstests: rename _require_btrfs to _require_btrfs_subcommand
Date: Wed,  9 Mar 2016 16:33:39 +0800
Message-Id: <1457512424-9215-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1457512424-9215-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1457512424-9215-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rename _require_btrfs() to _require_btrfs_subcommand() to avoid
confusion, as all other _require_btrfs_* has a quite clear suffix, like
_require_btrfs_mkfs_feature() or _require_btrfs_fs_feature().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 common/rc       | 2 +-
 tests/btrfs/004 | 2 +-
 tests/btrfs/048 | 2 +-
 tests/btrfs/059 | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/common/rc b/common/rc
index 16f5a43..957182f 100644
--- a/common/rc
+++ b/common/rc
@@ -2706,7 +2706,7 @@ _require_deletable_scratch_dev_pool()
 }
 
 # We check for btrfs and (optionally) features of the btrfs command
-_require_btrfs()
+_require_btrfs_subcommand()
 {
 	cmd=$1
 	_require_command "$BTRFS_UTIL_PROG" btrfs
diff --git a/tests/btrfs/004 b/tests/btrfs/004
index 905770a..2ce628e 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -51,7 +51,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch
 _require_no_large_scratch_dev
-_require_btrfs inspect-internal
+_require_btrfs_subcommand inspect-internal
 _require_command "/usr/sbin/filefrag" filefrag
 
 rm -f $seqres.full
diff --git a/tests/btrfs/048 b/tests/btrfs/048
index c2cb4a6..38089f6 100755
--- a/tests/btrfs/048
+++ b/tests/btrfs/048
@@ -47,7 +47,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_test
 _require_scratch
-_require_btrfs "property"
+_require_btrfs_subcommand "property"
 
 send_files_dir=$TEST_DIR/btrfs-test-$seq
 
diff --git a/tests/btrfs/059 b/tests/btrfs/059
index b9a6ef4..f6c2e27 100755
--- a/tests/btrfs/059
+++ b/tests/btrfs/059
@@ -50,7 +50,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_test
 _require_scratch
-_require_btrfs "property"
+_require_btrfs_subcommand "property"
 
 rm -f $seqres.full
 
-- 
2.7.2



