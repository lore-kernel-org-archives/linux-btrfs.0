Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38863 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbcCXKL3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 06:11:29 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] fstest: btrfs: update 048.out inline with ui changes
Date: Thu, 24 Mar 2016 18:11:12 +0800
Message-Id: <1458814272-5783-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To be inline with progs changes
  28831d54895443e5fc795392f23ce3a8b122cb71
  btrfs-progs: cmd property: switch to common error message wrapper
update 048.out

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/048.out | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
index 0b20d0b5976c..1d3ccef8e870 100644
--- a/tests/btrfs/048.out
+++ b/tests/btrfs/048.out
@@ -9,7 +9,7 @@ label=foobar
 ***
 label=
 ***
-ERROR: object is not compatible with property
+ERROR: object is not compatible with property: label
 ***
 
 Testing subvolume ro property
-- 
2.7.0

