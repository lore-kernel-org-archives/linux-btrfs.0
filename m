Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55861 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbcF3Jec (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 05:34:32 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 24E2C4056404
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 17:24:40 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 1/4] fstests: rename _require_btrfs to _require_btrfs_subcommand
Date: Thu, 30 Jun 2016 17:24:36 +0800
Message-Id: <20160630092439.27693-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160630092439.27693-1-quwenruo@cn.fujitsu.com>
References: <20160630092439.27693-1-quwenruo@cn.fujitsu.com>
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
index 883bd7b..137b88d 100644
--- a/common/rc
+++ b/common/rc
@@ -2723,7 +2723,7 @@ _require_deletable_scratch_dev_pool()
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
index 4a36303..912939e 100755
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
 
-- 
2.9.0



