Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:20034 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105Ab3HWNHO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 09:07:14 -0400
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstest: fix btrfs/006 for 10+ devices in SCRATCH_DEV_POOL
Date: Fri, 23 Aug 2013 15:07:13 +0200
Message-Id: <1377263233-8903-4-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One problem was the output of "uniq -c" which added spaces depending
on the size of the count value (e.g. one space less for 10+ devices).

The second problem was that "btrfs fi show" was doing the same:
"devid %4llu size %s used %s path %s".

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 common/filter.btrfs |  4 ++--
 tests/btrfs/006.out | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/common/filter.btrfs b/common/filter.btrfs
index e9a2bc2..29512cd 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -10,7 +10,7 @@ _filter_btrfs_version()
 
 _filter_devid()
 {
-	sed -e "s/\(devid\s\+\)[0-9]\+/\1 <DEVID>/g"
+	sed -e "s/\(devid\)\s\+[0-9]\+/\1 <DEVID>/g"
 }
 
 # If passed a number as first arg, filter that number of devices
@@ -53,7 +53,7 @@ _filter_btrfs_device_stats()
 
 	_filter_scratch | _filter_scratch_pool | \
 	sed -e "s/[0-9]\+$/<NUM>/g" | sort | uniq $UNIQ_OPT | \
-	sed -e "s/$NUMDEVS /<NUMDEVS> /g"
+	sed -e "s/ *$NUMDEVS /<NUMDEVS> /g"
 }
 
 # make sure this script returns success
diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
index ab33b7e..22bcb77 100644
--- a/tests/btrfs/006.out
+++ b/tests/btrfs/006.out
@@ -6,21 +6,21 @@ TestLabel.006
 == Show filesystem by label
 Label: 'TestLabel.006'  uuid: <UUID>
 	Total devices <EXACTNUM> FS bytes used <SIZE>
-	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
 
 == Show filesystem by UUID
 Label: 'TestLabel.006'  uuid: <EXACTUUID>
 	Total devices <EXACTNUM> FS bytes used <SIZE>
-	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
 
 == Sync filesystem
 FSSync 'SCRATCH_MNT'
 == Show device stats by mountpoint
-      <NUMDEVS> [SCRATCH_DEV].corruption_errs <NUM>
-      <NUMDEVS> [SCRATCH_DEV].flush_io_errs   <NUM>
-      <NUMDEVS> [SCRATCH_DEV].generation_errs <NUM>
-      <NUMDEVS> [SCRATCH_DEV].read_io_errs    <NUM>
-      <NUMDEVS> [SCRATCH_DEV].write_io_errs   <NUM>
+<NUMDEVS> [SCRATCH_DEV].corruption_errs <NUM>
+<NUMDEVS> [SCRATCH_DEV].flush_io_errs   <NUM>
+<NUMDEVS> [SCRATCH_DEV].generation_errs <NUM>
+<NUMDEVS> [SCRATCH_DEV].read_io_errs    <NUM>
+<NUMDEVS> [SCRATCH_DEV].write_io_errs   <NUM>
 == Show device stats by first/scratch dev
 [SCRATCH_DEV].corruption_errs <NUM>
 [SCRATCH_DEV].flush_io_errs   <NUM>
-- 
1.8.3.4

