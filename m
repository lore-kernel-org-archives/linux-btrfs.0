Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbbJPQTO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 12:19:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 8CE22AAC8
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2015 16:19:12 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/8] btrfs-progs: add helpers to print ranges
Date: Fri, 16 Oct 2015 18:18:02 +0200
Message-Id: <62198ec2e23b520e08b0e81417c867cad510b75f.1445011409.git.dsterba@suse.com>
In-Reply-To: <cover.1445011409.git.dsterba@suse.com>
References: <cover.1445011409.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-balance.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/cmds-balance.c b/cmds-balance.c
index 457d693eec42..3166d7a73ba2 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -192,6 +192,25 @@ static int parse_range_u32(const char *range, u32 *start, u32 *end)
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

