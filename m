Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41114 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752082AbeENLNl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:13:41 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1F695AEBB
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 11:13:40 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/9] btrfs-progs: btrfs-corrupt-block: Factor out key parsing function
Date: Mon, 14 May 2018 14:13:28 +0300
Message-Id: <1526296414-27638-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1526296414-27638-1-git-send-email-nborisov@suse.com>
References: <1526296414-27638-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently passing a key with -K handling is open coded. I intend on
changing the interface a bit to make the program more usable. To aid
in this factor out common code which parses a triplet of the
"u64,u8,u64" format, corresponding to a btrfs key. No functional
changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfs-corrupt-block.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 0018b6c9662d..39a611d89d55 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -1081,6 +1081,16 @@ static int find_chunk_offset(struct btrfs_root *root,
 
 }
 
+static void parse_key(u64 *objectid, u8 *type, u64 *offset)
+{
+
+	int ret = sscanf(optarg, "%llu,%hhu,%llu", objectid, type, offset);
+	if (ret != 3) {
+	        fprintf(stderr, "Error parsing key %d\n", errno);
+	        print_usage(1);
+	}
+}
+
 static struct btrfs_root *open_root(struct btrfs_fs_info *fs_info,
 				    u64 root_objectid)
 {
-- 
2.7.4

