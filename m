Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36131 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753344AbbAFM5t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jan 2015 07:57:49 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: qgroup: move WARN_ON() to the correct location.
Date: Tue, 6 Jan 2015 20:54:42 +0800
Message-ID: <1420548882-12106-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In function qgroup_excl_accounting(), we need to WARN when
qg->excl is less than what we want to free, same to child
and parents. But currently, for parent qgroup, the WARN_ON()
is located after freeing qg->excl. It will WARN out even we
free it normally.

This patch move this WARN_ON() before freeing qg->excl.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 48b60db..97159a8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1431,9 +1431,8 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 		qgroup = u64_to_ptr(unode->aux);
 		qgroup->rfer += sign * oper->num_bytes;
 		qgroup->rfer_cmpr += sign * oper->num_bytes;
+		WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);
 		qgroup->excl += sign * oper->num_bytes;
-		if (sign < 0)
-			WARN_ON(qgroup->excl < oper->num_bytes);
 		qgroup->excl_cmpr += sign * oper->num_bytes;
 		qgroup_dirty(fs_info, qgroup);
 
-- 
1.8.4.2

