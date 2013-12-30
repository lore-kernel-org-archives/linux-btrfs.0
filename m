Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17551 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3L3INN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 03:13:13 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: [PATCH v8 01/14] Btrfs: skip merge part for delayed data refs
Date: Mon, 30 Dec 2013 16:12:41 +0800
Message-Id: <1388391175-29539-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we have data deduplication on, we'll hang on the merge part
because it needs to verify every queued delayed data refs related to
this disk offset but we may have millions refs.

And in the case of delayed data refs, we don't usually have too much
data refs to merge.

So it's safe to shut it down for data refs.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/delayed-ref.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index e4d467b..b0d5d79 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -320,6 +320,13 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
 	struct rb_node *node;
 	u64 seq = 0;
 
+	/*
+	 * We don't have too much refs to merge in the case of delayed data
+	 * refs.
+	 */
+	if (head->is_data)
+		return;
+
 	spin_lock(&fs_info->tree_mod_seq_lock);
 	if (!list_empty(&fs_info->tree_mod_seq_list)) {
 		struct seq_list *elem;
-- 
1.8.2.1

