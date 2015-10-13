Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545AbbJMPnk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 11:43:40 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7B664ABCC
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 15:43:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/7] btrfs-progs: add helpers to print ranges
Date: Tue, 13 Oct 2015 17:42:30 +0200
Message-Id: <92b7e8c34b35527a86ada1ac0f321cd05ab63d82.1444750808.git.dsterba@suse.com>
In-Reply-To: <cover.1444750808.git.dsterba@suse.com>
References: <cover.1444750808.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-balance.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/cmds-balance.c b/cmds-balance.c
index 72714b23b45c..dba6613b1540 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -190,6 +190,25 @@ static int parse_range_u32(const char *range, u32 *start, u32 *end)
 	return 0;
 }
 
+__attribute__ ((unused))
+static void print_range(u64 start, u64 end)
+{
+	if (start)
+		printf("%llu", (unsigned long long)start);
+	printf("..");
+	if (end != (u64)-1)
+		printf("%llu", (unsigned long long)end);
+}
+
+static void print_range_u32(u32 start, u32 end)
+{
+	if (start)
+		printf("%u", start);
+	printf("..");
+	if (end != (u32)-1)
+		printf("%u", end);
+}
+
 static int parse_filters(char *filters, struct btrfs_balance_args *args)
 {
 	char *this_char;
-- 
2.6.1

