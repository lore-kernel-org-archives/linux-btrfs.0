Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25006 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbbABLmD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jan 2015 06:42:03 -0500
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests: btrfs: fix up 001.out
Date: Thu,  1 Jan 2015 03:48:24 +0800
Message-Id: <1420055304-4633-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The subvol delete output has changed with btrfs-progs
    -Delete subvolume 'SCRATCH_MNT/snap'
    +Delete subvolume (no-commit): 'SCRATCH_MNT/snap'

make the matching changes in the xfstests btrfs 001.out

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/001.out | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/001.out b/tests/btrfs/001.out
index c782bde..8dc6eac 100644
--- a/tests/btrfs/001.out
+++ b/tests/btrfs/001.out
@@ -33,7 +33,7 @@ subvol
 Listing subvolumes
 snap
 subvol
-Delete subvolume 'SCRATCH_MNT/snap'
+Delete subvolume (no-commit): 'SCRATCH_MNT/snap'
 List root dir
 subvol
 List root dir
-- 
2.0.0.153.g79dcccc

