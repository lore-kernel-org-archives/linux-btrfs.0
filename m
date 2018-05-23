Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60039 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754356AbeEWIXF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 04:23:05 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BAAC3AF06
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 08:23:04 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/4] btrfs: compression: Add linux/sizes.h for compression.h
Date: Wed, 23 May 2018 16:22:58 +0800
Message-Id: <20180523082301.29874-2-wqu@suse.com>
In-Reply-To: <20180523082301.29874-1-wqu@suse.com>
References: <20180523082301.29874-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since compression.h is using SZ_* macros, and if some user only includes
compression.h without linux/sizes.h, it will cause compile error.

One example is lzo.c, if it uses BTRFS_MAX_COMPRESSED, it would cause
compile error.

Fix it by adding linux/sizes.h in compression.h

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
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

