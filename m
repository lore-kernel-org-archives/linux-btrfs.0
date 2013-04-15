Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64582 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036Ab3DOMtb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 08:49:31 -0400
Received: by mail-pb0-f42.google.com with SMTP id up7so2484294pbc.29
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 05:49:31 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl-fnst@fujitsu.com>,
        Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Subject: [PATCH V2] Btrfs: fix confusing edquot happening case
Date: Mon, 15 Apr 2013 20:48:36 +0800
Message-Id: <1366030116-9019-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@fujitsu.com>

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

>From the perspective of users, qgroup's referenced or exclusive
is negative,but user can not continue to write data! a workaround
way is to cast u64 to s64 when doing qgroup reservation.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Arne Jansen <sensille@gmx.net>
---
Changelog v1->v2:
-use s64 instead of signed long long
---
 fs/btrfs/qgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b44124d..ab364a2 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1523,14 +1523,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
-		    qg->reserved + qg->rfer + num_bytes >
+		    qg->reserved + (s64)qg->rfer + num_bytes >
 		    qg->max_rfer) {
 			ret = -EDQUOT;
 			goto out;
 		}
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
-		    qg->reserved + qg->excl + num_bytes >
+		    qg->reserved + (s64)qg->excl + num_bytes >
 		    qg->max_excl) {
 			ret = -EDQUOT;
 			goto out;
-- 
1.7.11.7

