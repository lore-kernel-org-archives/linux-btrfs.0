Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50673 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab2G1WUX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jul 2012 18:20:23 -0400
Received: by gglu4 with SMTP id u4so4067956ggl.19
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jul 2012 15:20:23 -0700 (PDT)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH 1/1] Btrfs: Explicitly include vmalloc.h in send.c
Date: Sat, 28 Jul 2012 17:20:03 -0500
Message-Id: <1343514003-10942-2-git-send-email-mitch.harder@sabayonlinux.org>
In-Reply-To: <1343514003-10942-1-git-send-email-mitch.harder@sabayonlinux.org>
References: <1343514003-10942-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Certain architectures or platforms or combinations of CONFIG options
require an explicit #include <linux/vmalloc.h>.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 fs/btrfs/send.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index bf232c8..118e76d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -25,6 +25,7 @@
 #include <linux/posix_acl_xattr.h>
 #include <linux/radix-tree.h>
 #include <linux/crc32c.h>
+#include <linux/vmalloc.h>
 
 #include "send.h"
 #include "backref.h"
-- 
1.7.8.6

