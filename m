Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4842 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753815AbcAVMRY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 07:17:24 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 0BB5042AC841
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 20:16:56 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] [RFC] btrfs: reada: avoid undone reada extents in btrfs_reada_wait
Date: Fri, 22 Jan 2016 20:15:11 +0800
Message-ID: <1eb65b4f7a07c532a8a823326de405c0d707070f.1453464904.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some case, reada background works exit before all extents read,
for example, if a device reachs workload limit(MAX_IN_FLIGHT),
or total reads reachs max limit.

In old code, every works queue 2x new works, so many works make
above problem rarely happened.
After we limit max works by patch titled:
  btrfs: reada: limit max works count
The chance of above problem invreased.

Fix:
 We can check running background works in btrfs_reada_wait(),
 and create one work if no works exist.

Note:
 1: It is patch for debug, discussed on following thread in maillist:
      Re: [PATCH 1/2] btrfs: reada: limit max works count
    I havn't reproduce problem in above mail until now, this patch is
    created by reviewing code.
    And I also havn't reproduced the problem before patch.
    I only comfirmed no-problem after this patch applied.
 2: It is based on patch named:
    btrfs: reada: limit max works count
    The above patch and some detail in this patch needs more
    improvement before applied.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index af1e7b6..e67ce05 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -957,6 +957,8 @@ int btrfs_reada_wait(void *handle)
 	struct reada_control *rc = handle;
 
 	while (atomic_read(&rc->elems)) {
+		if (!atomic_read(&works_cnt))
+			reada_start_machine(rc->root->fs_info);
 		wait_event_timeout(rc->wait, atomic_read(&rc->elems) == 0,
 				   5 * HZ);
 		dump_devs(rc->root->fs_info,
@@ -975,6 +977,8 @@ int btrfs_reada_wait(void *handle)
 	struct reada_control *rc = handle;
 
 	while (atomic_read(&rc->elems)) {
+		if (!atomic_read(&works_cnt))
+			reada_start_machine(rc->root->fs_info);
 		wait_event(rc->wait, atomic_read(&rc->elems) == 0);
 	}
 
-- 
1.8.5.1



