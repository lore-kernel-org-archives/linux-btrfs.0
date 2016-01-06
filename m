Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20276 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbcAFVJE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 16:09:04 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Subject: [PATCH] Btrfs-progs: fix typo in parse_range
Date: Wed,  6 Jan 2016 13:08:53 -0800
Message-Id: <1452114533-15121-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

s/*end/*start.

This makes 'btrfs balance start -dvrange=xxx..yyy' really work.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 cmds-balance.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index c5be6b9..9f647cd 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -123,7 +123,7 @@ static int parse_range(const char *range, u64 *start, u64 *end)
 		*start = 0;
 		skipped++;
 	} else {
-		*end = strtoull(range, &endptr, 10);
+		*start = strtoull(range, &endptr, 10);
 		if (*endptr != 0 && *endptr != '.')
 			return 1;
 	}
-- 
2.5.0

