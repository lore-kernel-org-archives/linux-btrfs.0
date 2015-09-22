Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57417 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbbIVRAj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 13:00:39 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: Fix golden output for the new btrfs device replace tests
Date: Tue, 22 Sep 2015 17:58:53 +0100
Message-Id: <1442941133-14482-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

As a workaround for a regression in the uuid filter introduced by
a092363bbdfa ("xfs: test changing UUID on V5 superblock"), the btrfs
100 and 101 tests included an extra white space before the uuid in their
golden output files. However commit 48613832ad11 ("_filter_uuid: Fix
output regression for btrfs/006"), which came later, fixed the regression
in the uuid filter therefore making btrfs/100 and btrfs/101 fail due to
the extra space in their expected golden output files. So just remove the
extra white spaces from the golden output files.

  $ ./check btrfs/100
  FSTYP         -- btrfs
  PLATFORM      -- Linux/x86_64 debian3 4.2.0-rc5-btrfs-next-13+
  MKFS_OPTIONS  -- /dev/sdc
  MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1

  btrfs/100 4s ... - output mismatch (see .../results//btrfs/100.out.bad)
    --- tests/btrfs/100.out	2015-09-22 02:56:35.031470334 +0100
    +++ /home/fdmanana/git/hub/xfstests/results//btrfs/100.out.bad...
    @@ -1,10 +1,10 @@
     QA output created by 100
    -Label: none  uuid:  <UUID>
    +Label: none  uuid: <UUID>
     	Total devices <NUM> FS bytes used <SIZE>
     	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
     	devid <DEVID> size <SIZE> used <SIZE> path /dev/mapper/error-test

    (...)
  Failures: btrfs/100
  Failed 1 of 1 tests

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/100.out | 4 ++--
 tests/btrfs/101.out | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/btrfs/100.out b/tests/btrfs/100.out
index 2eeefa4..aa49291 100644
--- a/tests/btrfs/100.out
+++ b/tests/btrfs/100.out
@@ -1,10 +1,10 @@
 QA output created by 100
-Label: none  uuid:  <UUID>
+Label: none  uuid: <UUID>
 	Total devices <NUM> FS bytes used <SIZE>
 	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
 	devid <DEVID> size <SIZE> used <SIZE> path /dev/mapper/error-test
 
-Label: none  uuid:  <UUID>
+Label: none  uuid: <UUID>
 	Total devices <NUM> FS bytes used <SIZE>
 	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
 
diff --git a/tests/btrfs/101.out b/tests/btrfs/101.out
index 4621902..e1b88c2 100644
--- a/tests/btrfs/101.out
+++ b/tests/btrfs/101.out
@@ -1,10 +1,10 @@
 QA output created by 101
-Label: none  uuid:  <UUID>
+Label: none  uuid: <UUID>
 	Total devices <NUM> FS bytes used <SIZE>
 	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
 	devid <DEVID> size <SIZE> used <SIZE> path /dev/mapper/error-test
 
-Label: none  uuid:  <UUID>
+Label: none  uuid: <UUID>
 	Total devices <NUM> FS bytes used <SIZE>
 	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
 
-- 
2.1.3

