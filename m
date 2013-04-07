Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17443 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584Ab3DGNPc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 09:15:32 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r37DFUKB018747
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 7 Apr 2013 13:15:31 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r37DFU4K011318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 7 Apr 2013 13:15:30 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r37DFTA8005896
	for <linux-btrfs@vger.kernel.org>; Sun, 7 Apr 2013 08:15:29 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: skip merge part for delayed data refs
Date: Sun,  7 Apr 2013 21:12:49 +0800
Message-Id: <1365340369-23537-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1365340369-23537-1-git-send-email-bo.li.liu@oracle.com>
References: <1365340369-23537-1-git-send-email-bo.li.liu@oracle.com>
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
index b7a0641..34670c8 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -316,6 +316,13 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
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

