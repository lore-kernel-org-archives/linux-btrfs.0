Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59531 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965151AbbDXSV4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 14:21:56 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sat, 25 Apr 2015 04:21:53 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id F1EEB2BB0040
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 04:21:48 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t3OILefj13435266
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 04:21:48 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t3OILFoC006476
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 04:21:15 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, chandan@mykolab.com
Subject: [PATCH] Btrfs: Add OPER_SUB_SUBTREE to the list of operation types to be displayed in a trace.
Date: Fri, 24 Apr 2015 23:50:38 +0530
Message-Id: <1429899638-12430-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS_QGROUP_OPER_SUB_SUBTREE is missing from the list of operation types that
will be displayed in a trace. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 include/trace/events/btrfs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 1faecea..7a51ec3 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1122,7 +1122,8 @@ DEFINE_EVENT(btrfs__workqueue_done, btrfs_workqueue_destroy,
 		{ BTRFS_QGROUP_OPER_ADD_EXCL, 	"OPER_ADD_EXCL" },	\
 		{ BTRFS_QGROUP_OPER_ADD_SHARED, "OPER_ADD_SHARED" },	\
 		{ BTRFS_QGROUP_OPER_SUB_EXCL, 	"OPER_SUB_EXCL" },	\
-		{ BTRFS_QGROUP_OPER_SUB_SHARED,	"OPER_SUB_SHARED" })
+		{ BTRFS_QGROUP_OPER_SUB_SHARED,	"OPER_SUB_SHARED" },	\
+		{ BTRFS_QGROUP_OPER_SUB_SUBTREE,"OPER_SUB_SUBTREE" })
 
 DECLARE_EVENT_CLASS(btrfs_qgroup_oper,
 
-- 
2.1.0

