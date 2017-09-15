Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50965 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751169AbdIOPhN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 11:37:13 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org, Nick Terrell <terrelln@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Fri, 15 Sep 2017 17:36:58 +0200
Message-Id: <20170915153659.24603-2-kilobyte@angband.pl>
In-Reply-To: <20170915153659.24603-1-kilobyte@angband.pl>
References: <20170915153457.dt5zjcbrryn3qj3t@angband.pl>
 <20170915153659.24603-1-kilobyte@angband.pl>
Subject: [RFC PATCH 2/3] btrfs: allow setting zlib compression level via :9
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is bikeshedding, but it seems people are drastically more likely to
understand "zlib:9" as compression level rather than an algorithm version
compared to "zlib9".

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/btrfs/compression.c | 2 ++
 fs/btrfs/super.c       | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 70a50194fcf5..71782ec976c7 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1096,6 +1096,8 @@ unsigned int btrfs_compress_str2level(const char *str)
 
 	if ('1' <= str[4] && str[4] <= '9' )
 		return str[4] - '0';
+	if (str[4] == ':' && '1' <= str[5] && str[5] <= '9')
+		return str[5] - '0';
 
 	return 0;
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5467187701ef..537e04120457 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1248,7 +1248,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		else
 			seq_printf(seq, ",compress=%s", compress_type);
 		if (info->compress_level)
-			seq_printf(seq, "%d", info->compress_level);
+			seq_printf(seq, ":%d", info->compress_level);
 	}
 	if (btrfs_test_opt(info, NOSSD))
 		seq_puts(seq, ",nossd");
-- 
2.14.1

