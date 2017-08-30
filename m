Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35681 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdH3O3u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Aug 2017 10:29:50 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: declare TRACE_DEFINE_ENUM for each of show_flush_state enum
Date: Wed, 30 Aug 2017 22:36:48 +0800
Message-Id: <20170830143648.3960-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So that perf can show the state symbol.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/trace/events/btrfs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index d412c49f5a6a..64002f898717 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -27,6 +27,13 @@ struct __btrfs_workqueue;
 struct btrfs_qgroup_extent_record;
 struct btrfs_qgroup;
 
+TRACE_DEFINE_ENUM(FLUSH_DELAYED_ITEMS_NR);
+TRACE_DEFINE_ENUM(FLUSH_DELAYED_ITEMS);
+TRACE_DEFINE_ENUM(FLUSH_DELALLOC);
+TRACE_DEFINE_ENUM(FLUSH_DELALLOC_WAIT);
+TRACE_DEFINE_ENUM(ALLOC_CHUNK);
+TRACE_DEFINE_ENUM(COMMIT_TRANS);
+
 #define show_ref_type(type)						\
 	__print_symbolic(type,						\
 		{ BTRFS_TREE_BLOCK_REF_KEY, 	"TREE_BLOCK_REF" },	\
-- 
2.13.1

