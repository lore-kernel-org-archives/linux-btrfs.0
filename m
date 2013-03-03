Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0.parallels.com ([199.115.104.20]:49496 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3CCMcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 07:32:31 -0500
From: James Bottomley <jbottomley@parallels.com>
To: Chris Mason <chris.mason@fusionio.com>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: fix compile failure on parisc
Date: Sun, 3 Mar 2013 12:22:53 +0000
Message-ID: <1362313371.3057.28.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

x86 seems to include vmalloc.h by default along some of its arch paths,
but most other architectures don't, leading to this compile failure:

fs/btrfs/raid56.c: In function 'btrfs_alloc_stripe_hash_table':
fs/btrfs/raid56.c:206: error: implicit declaration of function 'vzalloc'
fs/btrfs/raid56.c:206: warning: assignment makes pointer from integer
without a cast
fs/btrfs/raid56.c:226: error: implicit declaration of function 'vfree'
make[2]: *** [fs/btrfs/raid56.o] Error 1

Fix this by adding vmalloc.h explicitly to the includes list

Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0722205..1f0f57e 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -30,6 +30,7 @@
 #include <linux/raid/pq.h>
 #include <linux/hash.h>
 #include <linux/list_sort.h>
+#include <linux/vmalloc.h>
 #include <linux/raid/xor.h>
 #include <asm/div64.h>
 #include "compat.h"

