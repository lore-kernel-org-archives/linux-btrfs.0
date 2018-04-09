Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35771 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752196AbeDIMBY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 08:01:24 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0BAB7AD39
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 12:01:23 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/7] btrfs: tracepoints, fix whitespace in strings
Date: Mon,  9 Apr 2018 13:58:52 +0200
Message-Id: <18304c6e2b6b130ed75156fc36967846d1692555.1523275048.git.dsterba@suse.com>
In-Reply-To: <cover.1523275048.git.dsterba@suse.com>
References: <cover.1523275048.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The preferred style is to avoid spaces between key and value and no
commas between key=values.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 include/trace/events/btrfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 06e8b8bdfb42..1773355e9365 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -121,7 +121,7 @@ TRACE_EVENT(btrfs_transaction_commit,
 		__entry->root_objectid	= root->root_key.objectid;
 	),
 
-	TP_printk_btrfs("root = %llu(%s), gen = %llu",
+	TP_printk_btrfs("root=%llu(%s) gen=%llu",
 		  show_root_type(__entry->root_objectid),
 		  __entry->generation)
 );
@@ -656,7 +656,7 @@ TRACE_EVENT(btrfs_sync_fs,
 		__entry->wait	= wait;
 	),
 
-	TP_printk_btrfs("wait = %d", __entry->wait)
+	TP_printk_btrfs("wait=%d", __entry->wait)
 );
 
 TRACE_EVENT(btrfs_add_block_group,
-- 
2.16.2

