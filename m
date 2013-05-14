Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49577 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3ENMJ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 08:09:28 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jbacik@fusionio.com, g2p.code@gmail.com
Subject: [RFC PATCH V4 1/2] Btrfs: skip merge part for delayed data refs
Date: Tue, 14 May 2013 20:08:53 +0800
Message-Id: <1368533335-19381-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1368533335-19381-1-git-send-email-bo.li.liu@oracle.com>
References: <1368533335-19381-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we have data deduplication on, we'll hang on the merge part
because it needs to verify every queued delayed data refs related to
this disk offset.

And in the case of delayed data refs, we don't usually have too much
data refs to merge.

So it's safe to shut it down for data refs.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/delayed-ref.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index c219463..be8d5cb 100644
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
1.7.7

