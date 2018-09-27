Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEADC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 239922156D
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 239922156D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbeI0M7X (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 08:59:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:38018 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbeI0M7X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 08:59:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 727CCB124
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 06:42:42 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 1/7] btrfs: qgroup: Introduce trace event to analyse the number of dirty extents accounted
Date:   Thu, 27 Sep 2018 14:42:29 +0800
Message-Id: <20180927064235.7432-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927064235.7432-1-wqu@suse.com>
References: <20180927064235.7432-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Number of qgroup dirty extents is directly linked to the performance
overhead, so add a new trace event, trace_qgroup_num_dirty_extents(), to
record how many dirty extents is processed in
btrfs_qgroup_account_extents().

This will be pretty handy to analyse later balance performance
improvement.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c            |  4 ++++
 include/trace/events/btrfs.h | 21 +++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4353bb69bb86..5977eedc00d8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2133,6 +2133,7 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct ulist *new_roots = NULL;
 	struct rb_node *node;
+	u64 num_dirty_extents = 0;
 	u64 qgroup_to_skip;
 	int ret = 0;
 
@@ -2142,6 +2143,7 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 		record = rb_entry(node, struct btrfs_qgroup_extent_record,
 				  node);
 
+		num_dirty_extents++;
 		trace_btrfs_qgroup_account_extents(fs_info, record);
 
 		if (!ret) {
@@ -2187,6 +2189,8 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 		kfree(record);
 
 	}
+	trace_qgroup_num_dirty_extents(fs_info, trans->transid,
+				       num_dirty_extents);
 	return ret;
 }
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index b401c4e36394..79253666d1d0 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1575,6 +1575,27 @@ DEFINE_EVENT(btrfs_qgroup_extent, btrfs_qgroup_trace_extent,
 	TP_ARGS(fs_info, rec)
 );
 
+TRACE_EVENT(qgroup_num_dirty_extents,
+
+	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 transid,
+		 u64 num_dirty_extents),
+
+	TP_ARGS(fs_info, transid, num_dirty_extents),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64, transid			)
+		__field(	u64, num_dirty_extents		)
+	),
+
+	TP_fast_assign_btrfs(fs_info,
+		__entry->transid	   = transid;
+		__entry->num_dirty_extents = num_dirty_extents;
+	),
+
+	TP_printk_btrfs("transid=%llu num_dirty_extents=%llu",
+		__entry->transid, __entry->num_dirty_extents)
+);
+
 TRACE_EVENT(btrfs_qgroup_account_extent,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 transid, u64 bytenr,
-- 
2.19.0

