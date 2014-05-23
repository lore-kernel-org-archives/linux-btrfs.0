Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:38275 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaEWDFp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 23:05:45 -0400
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/2] xfstests: add helper require function _require_btrfs_cloner
Date: Fri, 23 May 2014 05:05:30 +0100
Message-Id: <1400817931-32326-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So that the same check (btrfs cloner program presence) can be reused
by other tests.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 common/rc       | 7 +++++++
 tests/btrfs/035 | 4 +---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index d1788d1..f27ee53 100644
--- a/common/rc
+++ b/common/rc
@@ -2085,6 +2085,13 @@ _require_fssum()
 	[ -x $FSSUM_PROG ] || _notrun "fssum not built"
 }
 
+_require_btrfs_cloner()
+{
+	CLONER_PROG=$here/src/cloner
+	[ -x $CLONER_PROG ] || \
+		_notrun "cloner binary not present at $CLONER_PROG"
+}
+
 # Given 2 files, verify that they have the same mapping but different
 # inodes - i.e. an undisturbed reflink
 # Silent if so, make noise if not
diff --git a/tests/btrfs/035 b/tests/btrfs/035
index 6808179..dd303af 100755
--- a/tests/btrfs/035
+++ b/tests/btrfs/035
@@ -45,13 +45,11 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
+_require_btrfs_cloner
 
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
 
-CLONER_PROG=$here/src/cloner
-[ -x $CLONER_PROG ] || _notrun "cloner binary not present at $CLONER_PROG"
-
 src_str="aaaaaaaaaa"
 
 echo -n "$src_str" > $SCRATCH_MNT/src
-- 
1.9.1

