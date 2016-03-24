Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39934 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbcCXKOK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 06:14:10 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] fstest: btrfs: remove _need_to_be_root fix btrfs/118
Date: Thu, 24 Mar 2016 18:13:59 +0800
Message-Id: <1458814439-6418-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit 56ff01f471c9b72de0a447b37cdb1051adcede6a
    xfstests: remove _need_to_be_root

Removed _need_to_be_root(), and so btrfs/118 needs an update

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/118 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/btrfs/118 b/tests/btrfs/118
index 3ed1cbef1068..740cb92b0669 100755
--- a/tests/btrfs/118
+++ b/tests/btrfs/118
@@ -45,7 +45,6 @@ _cleanup()
 . ./common/dmflakey
 
 # real QA test starts here
-_need_to_be_root
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-- 
2.7.0

