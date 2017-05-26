Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34323 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944931AbdEZUoa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 16:44:30 -0400
Received: by mail-io0-f171.google.com with SMTP id k91so16162111ioi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 13:44:29 -0700 (PDT)
Date: Fri, 26 May 2017 20:44:27 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, mkh@rqc.ru
Subject: [PATCH v2 1/4] btrfs: Fail on removing qgroup if del_qgroup_item
 fails
Message-ID: <20170526204424.GA18188@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170526204414.GA18176@ircssh-2.c.rugged-nimbus-611.internal>

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
index deffbeb..d39ffcc 100644
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

