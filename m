Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:34920 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754215AbdGNPMp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 11:12:45 -0400
Received: by mail-it0-f51.google.com with SMTP id v202so23234413itb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 08:12:45 -0700 (PDT)
Date: Fri, 14 Jul 2017 15:12:41 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: [PATCH v3 1/2] btrfs: Fail on removing qgroup if del_qgroup_item
 fails
Message-ID: <d025c09108e653f88202d9f1480748cd42008852.1499941625.git.sargun@sargun.me>
References: <cover.1499941625.git.sargun@sargun.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1499941625.git.sargun@sargun.me>
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
 fs/btrfs/qgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4ce351e..3abc517 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1309,6 +1309,9 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 	}
 	ret = del_qgroup_item(trans, quota_root, qgroupid);
 
+	if (ret && ret != -ENOENT)
+		goto out;
+
 	while (!list_empty(&qgroup->groups)) {
 		list = list_first_entry(&qgroup->groups,
 					struct btrfs_qgroup_list, next_group);
-- 
2.9.3

