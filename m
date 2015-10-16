Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbbJPQTE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 12:19:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 8AF19AABE
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2015 16:19:02 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/8] btrfs-progs: do not modify the string in parse_range
Date: Fri, 16 Oct 2015 18:17:52 +0200
Message-Id: <064ee1e727d13b169b530ec6bc7331b516d11139.1445011409.git.dsterba@suse.com>
In-Reply-To: <cover.1445011409.git.dsterba@suse.com>
References: <cover.1445011409.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's passed as const but we modify it through 'dots'. This would break
parsing the string multiple times.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-balance.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 798b533aa7d6..0a1bf0cd0699 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -101,6 +101,7 @@ static int parse_u64(const char *str, u64 *result)
 static int parse_range(const char *range, u64 *start, u64 *end)
 {
 	char *dots;
+	char *endptr;
 	const char *rest;
 	int skipped = 0;
 
@@ -109,20 +110,21 @@ static int parse_range(const char *range, u64 *start, u64 *end)
 		return 1;
 
 	rest = dots + 2;
-	*dots = 0;
 
 	if (!*rest) {
 		*end = (u64)-1;
 		skipped++;
 	} else {
-		if (parse_u64(rest, end))
+		*end = strtoull(rest, &endptr, 10);
+		if (*endptr)
 			return 1;
 	}
 	if (dots == range) {
 		*start = 0;
 		skipped++;
 	} else {
-		if (parse_u64(range, start))
+		*end = strtoull(range, &endptr, 10);
+		if (*endptr != 0 && *endptr != '.')
 			return 1;
 	}
 
-- 
2.6.1

