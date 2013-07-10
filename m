Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:42289 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3GJLyh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 07:54:37 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk13so2817629bkc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jul 2013 04:54:35 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs: num_tolerated_disk_barrier_failures is incorrect for RAID6
Date: Wed, 10 Jul 2013 14:54:30 +0300
Message-Id: <1373457270-18909-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently num_tolerated_disk_barrier_failures gets the value of
fs_devices->num_devices in the RAID6 case.  But, RAID6 can tolerate only
two simultaneous failures, so set it to 2.

CC: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/disk-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b8b60b6..aecf788 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3258,7 +3258,7 @@ int btrfs_calc_num_tolerated_disk_barrier_failures(
 					    BTRFS_BLOCK_GROUP_RAID10)) {
 						num_tolerated_disk_barrier_failures = 1;
 					} else if (flags &
-						   BTRFS_BLOCK_GROUP_RAID5) {
+						   BTRFS_BLOCK_GROUP_RAID6) {
 						num_tolerated_disk_barrier_failures = 2;
 					}
 				}
-- 
1.7.10.4

