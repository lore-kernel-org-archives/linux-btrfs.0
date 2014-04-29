Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaD2QCN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 12:02:13 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B6ACBAC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 16:02:12 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 06/14] btrfs-progs: print B for bytes
Date: Tue, 29 Apr 2014 18:02:11 +0200
Message-Id: <5e18c42732d18e0c504e76b4622246c642cbe9cc.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This arguably helps parsers.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index ca150404ea6f..159abf8bd0e4 100644
--- a/utils.c
+++ b/utils.c
@@ -1252,7 +1252,7 @@ out:
 	return ret;
 }
 
-static char *size_strs[] = { "", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
+static char *size_strs[] = { "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
 int pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
 {
 	int num_divs = 0;
-- 
1.9.0

