Return-Path: <SRS0=CkC6=AA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,UPPERCASE_50_75,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D453CC433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Jun 2020 12:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1320206C3
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Jun 2020 12:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbgFSM1r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 08:27:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:46050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733005AbgFSMZS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jun 2020 08:25:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C42B4B1C8;
        Fri, 19 Jun 2020 12:24:54 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/6] btrfs: tracepoints: Convert flush states to using EM macros
Date:   Fri, 19 Jun 2020 15:24:51 +0300
Message-Id: <20200619122451.31162-7-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619122451.31162-1-nborisov@suse.com>
References: <20200619122451.31162-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Only 6 out of all flush states were being printed correctly since
only they were exported via the TRACE_DEFINE_ENUM macro. This patch
converts all flush states to use the newly introduced EM macro so that
they can all be printed correctly.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 include/trace/events/btrfs.h | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 8a758892bdbe..b0e98823c0a3 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -31,13 +31,6 @@ struct extent_io_tree;
 struct prelim_ref;
 struct btrfs_space_info;
 
-TRACE_DEFINE_ENUM(FLUSH_DELAYED_ITEMS_NR);
-TRACE_DEFINE_ENUM(FLUSH_DELAYED_ITEMS);
-TRACE_DEFINE_ENUM(FLUSH_DELALLOC);
-TRACE_DEFINE_ENUM(FLUSH_DELALLOC_WAIT);
-TRACE_DEFINE_ENUM(ALLOC_CHUNK);
-TRACE_DEFINE_ENUM(COMMIT_TRANS);
-
 #define show_ref_type(type)						\
 	__print_symbolic(type,						\
 		{ BTRFS_TREE_BLOCK_REF_KEY, 	"TREE_BLOCK_REF" },	\
@@ -95,6 +88,18 @@ TRACE_DEFINE_ENUM(COMMIT_TRANS);
 	EM( IO_TREE_LOG_CSUM_RANGE,	  "LOG_CSUM_RANGE")         \
 	EMe( IO_TREE_SELFTEST,		  "SELFTEST")
 
+#define FLUSH_STATES							\
+	EM( FLUSH_DELAYED_ITEMS_NR,	"FLUSH_DELAYED_ITEMS_NR")	\
+	EM( FLUSH_DELAYED_ITEMS,	"FLUSH_DELAYED_ITEMS")		\
+	EM( FLUSH_DELALLOC,		"FLUSH_DELALLOC")		\
+	EM( FLUSH_DELALLOC_WAIT,	"FLUSH_DELALLOC_WAIT")		\
+	EM( FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR")	\
+	EM( FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS")		\
+	EM( ALLOC_CHUNK,		"ALLOC_CHUNK")			\
+	EM( ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE")		\
+	EM( RUN_DELAYED_IPUTS,		"RUN_DELAYED_IPUTS")		\
+	EMe( COMMIT_TRANS,		"COMMIT_TRANS")
+
 #undef EM
 #undef EMe
 #define EM(a, b) TRACE_DEFINE_ENUM(a);
@@ -104,6 +109,7 @@ FLUSH_ACTIONS
 FI_TYPES
 QGROUP_RSV_TYPES
 IO_TREE_OWNER
+FLUSH_STATES
 
 #undef EM
 #undef EMe
@@ -1092,18 +1098,6 @@ TRACE_EVENT(btrfs_trigger_flush,
 		  __entry->bytes)
 );
 
-#define show_flush_state(state)							\
-	__print_symbolic(state,							\
-		{ FLUSH_DELAYED_ITEMS_NR,	"FLUSH_DELAYED_ITEMS_NR"},	\
-		{ FLUSH_DELAYED_ITEMS,		"FLUSH_DELAYED_ITEMS"},		\
-		{ FLUSH_DELALLOC,		"FLUSH_DELALLOC"},		\
-		{ FLUSH_DELALLOC_WAIT,		"FLUSH_DELALLOC_WAIT"},		\
-		{ FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR"},	\
-		{ FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS"},		\
-		{ ALLOC_CHUNK,			"ALLOC_CHUNK"},			\
-		{ ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE"},		\
-		{ RUN_DELAYED_IPUTS,		"RUN_DELAYED_IPUTS"},		\
-		{ COMMIT_TRANS,			"COMMIT_TRANS"})
 
 TRACE_EVENT(btrfs_flush_space,
 
@@ -1128,7 +1122,7 @@ TRACE_EVENT(btrfs_flush_space,
 
 	TP_printk_btrfs("state=%d(%s) flags=%llu(%s) num_bytes=%llu ret=%d",
 		  __entry->state,
-		  show_flush_state(__entry->state),
+		  __print_symbolic(__entry->state, FLUSH_STATES),
 		  __entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
 				BTRFS_GROUP_FLAGS),
-- 
2.17.1

