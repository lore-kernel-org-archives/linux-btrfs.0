Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:60508 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbdKFCnd (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Sun, 5 Nov 2017 21:43:33 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lakshmipathi.g@gmail.com
Subject: [PATCH 2/2] btrfs: compression: Return correct default zlib compression level
Date: Mon,  6 Nov 2017 10:43:19 +0800
Message-Id: <20171106024319.32584-2-wqu@suse.com>
In-Reply-To: <20171106024319.32584-1-wqu@suse.com>
References: <20171106024319.32584-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

0 means no compression at all for zlib.
Z_DEFAULT_COMPRESSION is the correct value, which is -1 and will be
converted to 6 at runtime.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b35ce16b3df3..29a41e6c9e28 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -35,6 +35,7 @@
 #include <linux/sched/mm.h>
 #include <linux/sort.h>
 #include <linux/log2.h>
+#include <linux/zlib.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -1528,5 +1529,9 @@ unsigned int btrfs_compress_str2level(const char *str)
 	if (str[4] == ':' && '1' <= str[5] && str[5] <= '9' && str[6] == 0)
 		return str[5] - '0';
 
-	return 0;
+	/*
+	 * NOTE: Default compression level is not 0!!
+	 * 0 means no compression at all
+	 */
+	return Z_DEFAULT_COMPRESSION;
 }
-- 
2.14.3

