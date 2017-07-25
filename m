Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751700AbdGYUyI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 16:54:08 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D06A9AD16
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 20:54:06 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/3] btrfs-progs: convert: add missing newlines for printfs
Date: Tue, 25 Jul 2017 16:54:42 -0400
Message-Id: <20170725205443.29874-2-jeffm@suse.com>
In-Reply-To: <20170725205443.29874-1-jeffm@suse.com>
References: <20170725205443.29874-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

There are two printfs with missing newlines that end up making the
output wonky.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 convert/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index c56382e..01657a6 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1285,7 +1285,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 		goto fail;
 	}
 
-	printf("creating btrfs metadata");
+	printf("creating btrfs metadata\n");
 	ctx.max_copy_inodes = (cctx.inodes_count - cctx.free_inodes_count);
 	ctx.cur_copy_inodes = 0;
 
@@ -1348,7 +1348,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 	close_ctree(root);
 	close(fd);
 
-	printf("conversion complete");
+	printf("conversion complete\n");
 	return 0;
 fail:
 	clean_convert_context(&cctx);
-- 
2.11.0

