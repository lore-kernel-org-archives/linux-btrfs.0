Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33591 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbH2IqJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Aug 2015 04:46:09 -0400
Date: Sat, 29 Aug 2015 11:45:53 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangsl-fnst@cn.fujitsu.com
Subject: [PATCH] btrfs: Remove unneeded cast to s64 for qgroup rfer state
Message-ID: <20150829114553.GA7522@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch reverts commit: b4fcd6be6bbd702ae1a6545c9b413681850a9814
Wang Shilong added those casts as a workaround for a bug reproduced
using the following steps:

Steps to reproduce:
>    	mkfs.btrfs <disk>
>    	mount <disk> <mnt>
>    	dd if=/dev/zero of=/<mnt>/data bs=1M count=10
>    	sync
>    	btrfs quota enable <mnt>
>    	btrfs qgroup create 0/5 <mnt>
>    	btrfs qgroup limit 5M 0/5 <mnt>
>    	rm -f /<mnt>/data
>    	sync
>    	btrfs qgroup show <mnt>
>    	dd if=/dev/zero of=data bs=1M count=1
>
>    >From the perspective of users, qgroup's referenced or exclusive
>    is negative,but user can not continue to write data! a workaround
>    way is to cast u64 to s64 when doing qgroup reservation

I am unable to reproduce this problem without his modification.
I could be wrong in reverting this, so I'm gonna CC Wang as well so
he is aware of this patch.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
 fs/btrfs/qgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8a82029..9c75e86 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2077,14 +2077,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		qg = u64_to_ptr(unode->aux);
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
-		    qg->reserved + (s64)qg->rfer + num_bytes >
+		    qg->reserved + qg->rfer + num_bytes >
 		    qg->max_rfer) {
 			ret = -EDQUOT;
 			goto out;
 		}
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
-		    qg->reserved + (s64)qg->excl + num_bytes >
+		    qg->reserved + qg->excl + num_bytes >
 		    qg->max_excl) {
 			ret = -EDQUOT;
 			goto out;
-- 
2.5.0

