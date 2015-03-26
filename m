Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbbCZR2o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 13:28:44 -0400
Message-ID: <551441CA.9050109@redhat.com>
Date: Thu, 26 Mar 2015 12:28:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: fstests@vger.kernel.org
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] fstests: fix _filter_mkfs regression on btrfs
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit:

5e8b9e6 btrfs: add regression test for remount with thread_pool resized

did weird things to _filter_mkfs; aside from broken indentation,
it also short-circuited the default non-xfs behavior, which was to
emit a default block & inode size.  And that was all because btrfs/082
was using _filter_mkfs & not redirecting output away as per normal.

Granted, it's not super clear that _filter_mkfs serves this rather
unique purpose, but anyway...

And, while having this default seems to be of questionable value,
not emitting *anything* led to this on btrfs:

    +./tests/generic/204: line 76: space / (isize + dbsize): division by 0 (error token is ")")

because those variables don't get set for btrfs, thanks to the
above commit.

So take out the use of _filter_mkfs in btrfs/082, and take out the
munging of _filter_mkfs which broke generic/204, and get things back
to something semi-sane.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/common/filter b/common/filter
index 71ef2e2..05dbae6 100644
--- a/common/filter
+++ b/common/filter
@@ -137,10 +137,6 @@ _filter_mkfs()
     case $FSTYP in
     xfs)
 	;;
-	btrfs)
-	sed -e "/Performing full device TRIM/d" \
-		-e "/Turning ON incompat feature/d"
-	return ;;
     *)
 	cat - >/dev/null
 	perl -e 'print STDERR "dbsize=4096\nisize=256\n"'

diff --git a/tests/btrfs/082 b/tests/btrfs/082
index dd3c87e..1324d27 100755
--- a/tests/btrfs/082
+++ b/tests/btrfs/082
@@ -55,7 +55,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch
 
-_scratch_mkfs |& _filter_mkfs
+_scratch_mkfs >>$seqres.full 2>&1
 
 _scratch_mount "-o thread_pool=6"
 _scratch_mount "-o remount,thread_pool=10"

diff --git a/tests/generic/204 b/tests/generic/204
index d6bb094..13069d8 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -60,6 +60,7 @@ _scratch_mkfs_sized $SIZE $dbsize 2> /dev/null \
 		| _filter_mkfs 2> $tmp.mkfs > /dev/null
 _scratch_mount
 
+# Source $tmp.mkfs to get geometry
 . $tmp.mkfs
 
 # fix the reserve block pool to a known size so that the enospc calculations


