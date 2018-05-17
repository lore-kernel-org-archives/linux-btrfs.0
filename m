Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56906 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751999AbeEQG2F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 02:28:05 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jamespharvey20@gmail.com
Subject: [PATCH 1/4] btrfs: compression: Add linux/sizes.h for compression.h
Date: Thu, 17 May 2018 14:27:50 +0800
Message-Id: <20180517062753.25973-2-wqu@suse.com>
In-Reply-To: <20180517062753.25973-1-wqu@suse.com>
References: <20180517062753.25973-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since compression.h is using SZ_* macros, and if some user only includes
compression.h without linux/sizes.h, it will cause compile error.

One example is lzo.c, if it uses BTRFS_MAX_COMPRESSED, it would cause
compile error.

Fix it by adding linux/sizes.h in compression.h

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index cc605f7b23fb..317703d9b073 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -6,6 +6,7 @@
 #ifndef BTRFS_COMPRESSION_H
 #define BTRFS_COMPRESSION_H
 
+#include <linux/sizes.h>
 /*
  * We want to make sure that amount of RAM required to uncompress an extent is
  * reasonable, so we limit the total size in ram of a compressed extent to
-- 
2.17.0

