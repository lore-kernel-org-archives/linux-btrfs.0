Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49677 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbdFMCp3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 22:45:29 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs: use ino_t for inode in tracer
Date: Tue, 13 Jun 2017 10:51:37 +0800
Message-Id: <1497322297-603-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1497262228-729-1-git-send-email-anand.jain@oracle.com>
References: <1497262228-729-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: fix another location where ino_t was required.

 include/trace/events/btrfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index e37973526153..692207e3f5d5 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1418,7 +1418,7 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_data_map,
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,		rootid		)
-		__field(	unsigned long,	ino		)
+		__field(	ino_t,		ino		)
 		__field(	u64,		free_reserved	)
 	),
 
@@ -1459,7 +1459,7 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_rsv_data,
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,		rootid		)
-		__field(	unsigned long,	ino		)
+		__field(	ino_t,		ino		)
 		__field(	u64,		start		)
 		__field(	u64,		len		)
 		__field(	u64,		reserved	)
-- 
2.7.0

