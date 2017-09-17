Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:54419 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbdIQJCc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 05:02:32 -0400
Received: by mail-it0-f42.google.com with SMTP id e134so6777950ite.3
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 02:02:32 -0700 (PDT)
Date: Sun, 17 Sep 2017 09:02:29 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: [PATCH] btrfs: Report error on removing qgroup if del_qgroup_item
 fails
Message-ID: <20170917090226.GA30640@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously, we were calling del_qgroup_item, and ignoring the return code
resulting in a potential to have divergent in-memory state without an
error. Perhaps, it makes sense to handle this error code, and put the
filesystem into a read only, or similar state.

This patch only adds reporting of the error if the error is fatal,
(any error other than qgroup not found).

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/qgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 770f667269f5..e172d4843eae 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1305,6 +1305,8 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 		}
 	}
 	ret = del_qgroup_item(trans, quota_root, qgroupid);
+	if (ret && ret != -ENOENT)
+		goto out;
 
 	while (!list_empty(&qgroup->groups)) {
 		list = list_first_entry(&qgroup->groups,
-- 
2.11.0

