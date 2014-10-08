Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46665 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaJHCgM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 22:36:12 -0400
From: Wang Shilong <wangshilong1991@gmail.com>
To: fstests@vger.kernel.org
Cc: david@fromorbit.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] xfstests,btrfs/004: use FILEFRAG_PROG macro
Date: Wed,  8 Oct 2014 06:35:22 -0400
Message-Id: <1412764522-15754-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1412764522-15754-1-git-send-email-wangshilong1991@gmail.com>
References: <1412764522-15754-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
i didn't find a way to remove filefrag here, but let us
use macro firstly...
---
 tests/btrfs/004 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/btrfs/004 b/tests/btrfs/004
index 1d5b816..1f59963 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -53,7 +53,6 @@ _supported_os Linux
 _require_scratch
 _require_no_large_scratch_dev
 _require_btrfs inspect-internal
-_require_command "/usr/sbin/filefrag"
 
 rm -f $seqres.full
 
@@ -82,7 +81,7 @@ _filter_extents()
 
 _check_file_extents()
 {
-	cmd="filefrag -v $1"
+	cmd="$FILEFRAG_PROG -v $1"
 	echo "# $cmd" >> $seqres.full
 	out=`$cmd | _filter_extents`
 	if [ -z "$out" ]; then
-- 
1.8.3.1

