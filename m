Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34791 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbcBLQYF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 11:24:05 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: generic/158, test dedupe with destination offset past EOF
Date: Fri, 12 Feb 2016 16:23:59 +0000
Message-Id: <1455294239-9049-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

We were testing when the source file offset starts at EOF or beyond,
but not when the destination offset is beyond EOF or when the
destination offset is smaller than EOF but destination offset plus
dedup length is greater than EOF.

This is motivated by a bug in btrfs' extent_same (dedup) ioctl where
we allowed the destination offset to start at EOF and beyond (and
destination offset + length beyond EOF) for the case where the source
and destination files are the same (was not allowed for different
files used as source and destination). This also made the file's
metadata inconsistent when the dedup operation succeeded, which
happened when the source range corresponded to a file hole, prealloc
extent or a data extent filled with zeroes.

The btrfs issue is fixed by the following patch for the linux kernel:

  "Btrfs: fix extent_same allowing destination offset beyond i_size"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/158     | 10 +++++++++-
 tests/generic/158.out |  6 +++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tests/generic/158 b/tests/generic/158
index 807c247..9c2d17a 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -97,9 +97,17 @@ _dedupe_range "$testdir1/file1" 37 "$testdir1/file1" 59 23
 echo "Try overlapping dedupe"
 _dedupe_range "$testdir1/file1" 0 "$testdir1/file1" 1 $((blksz * 2))
 
-echo "Try dedupe past EOF"
+echo "Try dedupe from past EOF"
 _dedupe_range "$testdir1/file1" $(( (blks + 10) * blksz)) "$testdir1/file1" 0 $blksz
 
+echo "Try dedupe to past EOF, destination offset beyond EOF"
+_dedupe_range "$testdir1/file1" 0 "$testdir1/file1" $(( (blks + 10) * blksz)) \
+	$blksz
+
+echo "Try dedupe to past EOF, destination offset behind EOF"
+_dedupe_range "$testdir1/file1" 0 "$testdir1/file1" $(( (blks - 1) * blksz)) \
+	$(( blksz * 2))
+
 echo "Try to dedupe a dir"
 _dedupe_range "$testdir1/dir1" 0 "$testdir1/file2" 0 $blksz
 
diff --git a/tests/generic/158.out b/tests/generic/158.out
index dff3692..9aa337f 100644
--- a/tests/generic/158.out
+++ b/tests/generic/158.out
@@ -7,7 +7,11 @@ Try unaligned dedupe
 dedupe: Invalid argument
 Try overlapping dedupe
 dedupe: Invalid argument
-Try dedupe past EOF
+Try dedupe from past EOF
+dedupe: Invalid argument
+Try dedupe to past EOF, destination offset beyond EOF
+dedupe: Invalid argument
+Try dedupe to past EOF, destination offset behind EOF
 dedupe: Invalid argument
 Try to dedupe a dir
 XFS_IOC_FILE_EXTENT_SAME: Is a directory
-- 
2.7.0.rc3

