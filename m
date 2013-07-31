Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19140 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab3GaPiE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 11:38:04 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6VFc30n005753
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:04 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFc2pT027243
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:03 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFc2oh027216
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:02 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v5 1/5] Btrfs: skip merge part for delayed data refs
Date: Wed, 31 Jul 2013 23:37:41 +0800
Message-Id: <1375285066-14173-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
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
 fs/btrfs/delayed-ref.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index f7be9f7..fc4ce8b 100644
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

