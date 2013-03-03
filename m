Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:59124 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3CCLor (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 06:44:47 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] btrfs/raid56: Add missing #include <linux/vmalloc.h>
Date: Sun,  3 Mar 2013 12:44:41 +0100
Message-Id: <1362311081-10145-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tilegx_defconfig:

fs/btrfs/raid56.c: In function 'btrfs_alloc_stripe_hash_table':
fs/btrfs/raid56.c:206:3: error: implicit declaration of function 'vzalloc' [-Werror=implicit-function-declaration]
fs/btrfs/raid56.c:206:9: warning: assignment makes pointer from integer without a cast [enabled by default]
fs/btrfs/raid56.c:226:4: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/8311887/

 fs/btrfs/raid56.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0722205..9a79fb7 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -31,6 +31,7 @@
 #include <linux/hash.h>
 #include <linux/list_sort.h>
 #include <linux/raid/xor.h>
+#include <linux/vmalloc.h>
 #include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"
-- 
1.7.0.4

