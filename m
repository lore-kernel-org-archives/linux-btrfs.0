Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38685 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753958AbbHFDHg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 23:07:36 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7635dkB021083
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 11:05:39 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 2/2] btrfs-progs: Modify confuse error message in scrub
Date: Thu, 6 Aug 2015 11:05:55 +0800
Message-ID: <4d18a89d55f130df60c9c604881599172cde0459.1438830282.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <4779cd8de60a58c7e3d9ea2cf62595bd075638c2.1438830282.git.zhaolei@cn.fujitsu.com>
References: <4779cd8de60a58c7e3d9ea2cf62595bd075638c2.1438830282.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Scrub output following error message in my test:
  ERROR: scrubbing /var/ltf/tester/scratch_mnt failed for device id 5 (Success)

It is caused by a broken kernel and fs, but the we need to avoid
outputting both "error and success" in oneline message as above.

This patch modified above message to:
  ERROR: scrubbing /var/ltf/tester/scratch_mnt failed for device id 5, ret=1, errno=0(Success)

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index a40eecf..2529956 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1469,8 +1469,9 @@ static int scrub_start(int argc, char **argv, int resume)
 				break;
 			default:
 				if (do_print)
-					fprintf(stderr, "ERROR: scrubbing %s failed for device id %lld (%s)\n",
+					fprintf(stderr, "ERROR: scrubbing %s failed for device id %lld, ret=%d, errno=%d(%s)\n",
 						path, devid,
+						sp[i].ret, sp[i].ioctl_errno,
 						strerror(sp[i].ioctl_errno));
 				++err;
 				continue;
-- 
1.8.5.1

