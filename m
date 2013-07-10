Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab3GJRkO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 13:40:14 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: hugo@carfax.org.uk, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: use IEC units for sizes
Date: Wed, 10 Jul 2013 19:40:12 +0200
Message-Id: <1373478012-7247-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <20130710161623.GJ5445@carfax.org.uk>
References: <20130710161623.GJ5445@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As implemented now, we use 1024 based units but reporting 1000 based,
let's finally fix that and add optional unit bases later.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 utils.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index bce06f1..2e24cb0 100644
--- a/utils.c
+++ b/utils.c
@@ -1173,8 +1173,7 @@ out:
 	return ret;
 }
 
-static char *size_strs[] = { "", "KB", "MB", "GB", "TB",
-			    "PB", "EB"};
+static char *size_strs[] = { "", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
 void pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
 {
 	int num_divs = 0;
-- 
1.8.2

