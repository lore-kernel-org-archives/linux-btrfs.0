Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56656 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3DOKdI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 06:33:08 -0400
Message-ID: <516BD85B.3050508@cn.fujitsu.com>
Date: Mon, 15 Apr 2013 18:37:15 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>, Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH RFC] Btrfs: fix confusing edquot happening case
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Step to reproduce:
	mkfs.btrfs <disk>
	mount <disk> <mnt>
	dd if=/dev/zero of=/<mnt>/data bs=1M count=10
	sync
	btrfs quota enable <mnt>
	btrfs qgroup create 0/5 <mnt>
	btrfs qgroup limit 5M 0/5 <mnt>
	rm -f /<mnt>/data
	sync
	btrfs qgroup show <mnt>
	dd if=/dev/zero of=data bs=1M count=1

>From the perspective of users, qgroup's referenced or referenced

is negative,But user can not continue to write data! a workaround
way is to cast u64 to int64 when doing qgroup reservation.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
This confusing edquot may also happen after Jan's qgroup
rescan has been implemented.
---
 fs/btrfs/qgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b44124d..0178223 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1523,14 +1523,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
-		    qg->reserved + qg->rfer + num_bytes >
+		    qg->reserved + (signed long long)qg->rfer + num_bytes >
 		    qg->max_rfer) {
 			ret = -EDQUOT;
 			goto out;
 		}
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
-		    qg->reserved + qg->excl + num_bytes >
+		    qg->reserved + (signed long long)qg->excl + num_bytes >
 		    qg->max_excl) {
 			ret = -EDQUOT;
 			goto out;
-- 
1.7.7.6





