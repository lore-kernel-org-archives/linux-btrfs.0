Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39507 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751082AbdEaRuf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 13:50:35 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E5E74AAB6
        for <linux-btrfs@vger.kernel.org>; Wed, 31 May 2017 17:50:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/5] btrfs: adjust includes after vmalloc removal
Date: Wed, 31 May 2017 19:49:34 +0200
Message-Id: <136d7b862a15ae8d02fecfb605465f2316d31575.1496252765.git.dsterba@suse.com>
In-Reply-To: <cover.1496252765.git.dsterba@suse.com>
References: <cover.1496252765.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we don't use vmalloc/vzalloc/vfree directly in ctree.c, we can now
use the proper header that defines kvmalloc.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6e1b02dd72d3..3f4daa9d6e2c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -19,7 +19,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
-#include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
-- 
2.12.0

