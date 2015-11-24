Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8209 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752744AbbKXKOW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 05:14:22 -0500
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] fstests: speedup generic/027 for new version of btrfs
Date: Tue, 24 Nov 2015 18:11:54 +0800
Message-ID: <604c80a86a7e58c9408abad851481be10b254f0c.1448359685.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

New version of btrfs create non-mixed blockgroups in all case.

For generic/027, the filesystem in test is convert from
mixed-blockgroup to non-mixed blockgroup.
And test time is changed from 400s -> 2700s in my node.

To test btrfs with all mountoptions, this testitem need about
7.5H. (actually, some mountoption as compress needs more time)

This patch reduce test loop count, to make testtime about equal
with old version.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/generic/027 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/027 b/tests/generic/027
index d2e59d6..42f0685 100755
--- a/tests/generic/027
+++ b/tests/generic/027
@@ -78,7 +78,7 @@ rm -f $SCRATCH_MNT/testfile
 loop=100
 # btrfs takes much longer time, reduce the loop count
 if [ "$FSTYP" == "btrfs" ]; then
-	loop=10
+	loop=2
 fi
 
 dir=$SCRATCH_MNT/testdir
-- 
1.8.5.1


-- 
This message has been scanned for viruses and
dangerous content by Fujitsu, and is believed to be clean.

