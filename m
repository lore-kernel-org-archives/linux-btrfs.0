Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30858 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbdFLKE3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 06:04:29 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: use ino_t for inode in tracer
Date: Mon, 12 Jun 2017 18:10:28 +0800
Message-Id: <1497262228-729-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/trace/events/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index e37973526153..6494e34b6df9 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
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

