Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63936 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755002AbcKVIi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 03:38:29 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [RFC PATCH 1/3] fstests: common: rename _require_btrfs to _require_btrfs_subcommand
Date: Tue, 22 Nov 2016 16:38:09 +0800
Message-Id: <20161122083811.12636-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161122083811.12636-1-quwenruo@cn.fujitsu.com>
References: <20161122083811.12636-1-quwenruo@cn.fujitsu.com>
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
 tests/btrfs/131 | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/common/rc b/common/rc
index e3b54ec..6d333dd 100644
--- a/common/rc
+++ b/common/rc
@@ -3017,7 +3017,7 @@ _require_deletable_scratch_dev_pool()
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
index 0b907b0..ac731d1 100755
--- a/tests/btrfs/048
+++ b/tests/btrfs/048
@@ -48,7 +48,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_test
 _require_scratch
-_require_btrfs "property"
+_require_btrfs_subcommand "property"
 
 send_files_dir=$TEST_DIR/btrfs-test-$seq
 
diff --git a/tests/btrfs/059 b/tests/btrfs/059
index 8f106d2..fd67ebb 100755
--- a/tests/btrfs/059
+++ b/tests/btrfs/059
@@ -51,7 +51,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_test
 _require_scratch
-_require_btrfs "property"
+_require_btrfs_subcommand "property"
 
 rm -f $seqres.full
 
diff --git a/tests/btrfs/131 b/tests/btrfs/131
index d1a11d2..ff1dbdd 100755
--- a/tests/btrfs/131
+++ b/tests/btrfs/131
@@ -48,7 +48,7 @@ rm -f $seqres.full
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-_require_btrfs inspect-internal
+_require_btrfs_subcommand inspect-internal
 
 mkfs_v1()
 {
-- 
2.7.4



