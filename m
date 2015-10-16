Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbbJPQTL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 12:19:11 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4C106AABE
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2015 16:19:09 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/8] btrfs-progs: add helpers for parsing 32bit ranges
Date: Fri, 16 Oct 2015 18:17:59 +0200
Message-Id: <d194c80991f1bd7baa1fe054b698d1d4266ad98a.1445011409.git.dsterba@suse.com>
In-Reply-To: <cover.1445011409.git.dsterba@suse.com>
References: <cover.1445011409.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-balance.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/cmds-balance.c b/cmds-balance.c
index 1fd8d2018b7a..457d693eec42 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -161,6 +161,37 @@ static int parse_range_strict(const char *range, u64 *start, u64 *end)
 	return 1;
 }
 
+/*
+ * Convert 64bit range to 32bit with boundary checkso
+ */
+static int range_to_u32(u64 start, u64 end, u32 *start32, u32 *end32)
+{
+	if (start > (u32)-1)
+		return 1;
+
+	if (end != (u64)-1 && end > (u32)-1)
+		return 1;
+
+	*start32 = (u32)start;
+	*end32 = (u32)end;
+
+	return 0;
+}
+
+static int parse_range_u32(const char *range, u32 *start, u32 *end)
+{
+	u64 tmp_start;
+	u64 tmp_end;
+
+	if (parse_range(range, &tmp_start, &tmp_end))
+		return 1;
+
+	if (range_to_u32(tmp_start, tmp_end, start, end))
+		return 1;
+
+	return 0;
+}
+
 static int parse_filters(char *filters, struct btrfs_balance_args *args)
 {
 	char *this_char;
-- 
2.6.1

