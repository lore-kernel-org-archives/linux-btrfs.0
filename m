Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out0-231.mail.aliyun.com ([140.205.0.231]:36596 "EHLO
        out0-231.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423205AbdKQXD7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 18:03:59 -0500
From: "Yang Shi" <yang.s@alibaba-inc.com>
To: linux-kernel@vger.kernel.org
Cc: <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        "Yang Shi" <yang.s@alibaba-inc.com>, "Chris Mason" <clm@fb.com>,
        "Josef Bacik" <jbacik@fb.com>, "David Sterba" <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/8] fs: btrfs: remove unused hardirq.h
Date: Sat, 18 Nov 2017 07:02:16 +0800
Message-Id: <1510959741-31109-3-git-send-email-yang.s@alibaba-inc.com>
In-Reply-To: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Preempt counter APIs have been split out, currently, hardirq.h just
includes irq_enter/exit APIs which are not used by btrfs at all.

So, remove the unused hardirq.h.

Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/extent_map.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 2e348fb..cced7f1 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -2,7 +2,6 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/hardirq.h>
 #include "ctree.h"
 #include "extent_map.h"
 #include "compression.h"
-- 
1.8.3.1

