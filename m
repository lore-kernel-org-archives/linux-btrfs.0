Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47827 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144AbbGWUwG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 16:52:06 -0400
From: Omar Sandoval <osandov@fb.com>
To: <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>,
        Omar Sandoval <osandov@fb.com>
Subject: [PATCH 1/3] btrfs/011: test replace on RAID 5/6 now that it's supported
Date: Thu, 23 Jul 2015 13:51:49 -0700
Message-ID: <769c314845bd9341f93062204cbe435586674b1f.1437683940.git.osandov@fb.com>
In-Reply-To: <cover.1437683940.git.osandov@fb.com>
References: <cover.1437683940.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs replace has been supported on RAID 5/6 since Linux 3.19.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/btrfs/011 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/btrfs/011 b/tests/btrfs/011
index f4f2fbed68d8..c7d35fa46062 100755
--- a/tests/btrfs/011
+++ b/tests/btrfs/011
@@ -282,8 +282,8 @@ workout "-m dup -d single" 1 cancel quick
 workout "-m dup -d dup -M" 1 no quick
 workout "-m raid0 -d raid0" 2 no quick
 workout "-m raid1 -d raid1" 2 no thorough
-#workout "-m raid5 -d raid5" 2 no quick # not yet supported for btrfs replace
-#workout "-m raid6 -d raid6" 3 no quick # not yet supported for btrfs replace
+workout "-m raid5 -d raid5" 2 no quick
+workout "-m raid6 -d raid6" 3 no quick
 workout "-m raid10 -d raid10" 4 no quick
 
 echo "*** done"
-- 
2.4.6

