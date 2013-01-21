Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:49791 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3AUTTi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 14:19:38 -0500
Received: by mail-bk0-f51.google.com with SMTP id y8so869340bkt.24
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 11:19:36 -0800 (PST)
From: Andreas Fischer <fisch0r@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andreas Fischer <info@andreasfischer.net>
Subject: [PATCH 1/1] Btrfs-progs: Fix typo in balance start usage; filetrs -> filters.
Date: Mon, 21 Jan 2013 19:19:03 +0000
Message-Id: <1358795943-5622-1-git-send-email-fisch0r@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Andreas Fischer <info@andreasfischer.net>

Fix typo in "btrfs balance start" usage documentation: 'filetrs' should have
been 'filters'.

Signed-off-by: Andreas Fischer <info@andreasfischer.net>
---
 cmds-balance.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 38a7426..dfa0dfe 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -349,7 +349,7 @@ static const char * const cmd_balance_start_usage[] = {
 	"",
 	"-d[filters]    act on data chunks",
 	"-m[filters]    act on metadata chunks",
-	"-s[filetrs]    act on system chunks (only under -f)",
+	"-s[filters]    act on system chunks (only under -f)",
 	"-v             be verbose",
 	"-f             force reducing of metadata integrity",
 	NULL
-- 
1.7.10.4

