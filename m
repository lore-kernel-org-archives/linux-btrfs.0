Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46125 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753997AbbIBMYP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 08:24:15 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t82CNxYL030316
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Sep 2015 20:23:59 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 0/4] btrfs-progs: stat info for btrfs rescue chunk-recover
Date: Wed, 2 Sep 2015 20:22:28 +0800
Message-ID: <cover.1441196519.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

chunk-recover need to use many many time in scan_devices(),
and no output in screen:
 # btrfs rescue chunk-recover /dev/sda6
 (no output here, but need long time)

To notice user that "the command is not hang", this patch add
dynamic updated stat information in above period:
 # btrfs rescue chunk-recover /dev/sda6
 Scanning: DONE in dev[0], 19998441472 in dev[1], DONE in dev[2]
 (until)
 Scanning: DONE in dev0, DONE in dev1, DONE in dev2
 Check chunks successfully with no orphans
 Recover the chunk tree successfully.


Changelog v2->v3:
 Add [PATCH 2/4] to fix a potential invalid memory access of pthread.

Changelog v1->v2:
 [PATCH 3/3] in v1 lost a little cleanup, added in v2.

Zhao Lei (4):
  btrfs-progs: use for loop for scan_devices
  btrfs-progs: Use long type to get thread's return value
  btrfs-progs: stat info for btrfs rescue chunk-recover
  btrfs-progs: Fix some spelling typo in chunk-recover.c

 chunk-recover.c | 89 +++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 61 insertions(+), 28 deletions(-)

-- 
1.8.5.1

