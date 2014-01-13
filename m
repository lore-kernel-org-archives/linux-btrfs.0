Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29787 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaAMNHS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 08:07:18 -0500
From: Anand Jain <anand.jain@oracle.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] xfstests: make btrfs/001.out in line with subvol delete output
Date: Mon, 13 Jan 2014 21:16:29 +0800
Message-Id: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

btrfs/001 is failing as below btrfs-progs patch changed the
output during subvol delete.
Patch :
btrfs-progs: add options to set commit mode after subvol delete

so add it to the btrfs/001.out

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 tests/btrfs/001.out | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/001.out b/tests/btrfs/001.out
index c782bde..a255614 100644
--- a/tests/btrfs/001.out
+++ b/tests/btrfs/001.out
@@ -33,6 +33,7 @@ subvol
 Listing subvolumes
 snap
 subvol
+Transaction commit: none (default)
 Delete subvolume 'SCRATCH_MNT/snap'
 List root dir
 subvol
-- 
1.8.4.2

