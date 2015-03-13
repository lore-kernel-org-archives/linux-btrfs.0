Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:59299 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbbCMI66 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 04:58:58 -0400
Received: from mailnull by bh-25.webhostbox.net with sa-checked (Exim 4.82)
	(envelope-from <linux@roeck-us.net>)
	id 1YWLQo-002pIv-0S
	for linux-btrfs@vger.kernel.org; Fri, 13 Mar 2015 08:58:58 +0000
From: Guenter Roeck <linux@roeck-us.net>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fs: btrfs: Add missing include file
Date: Fri, 13 Mar 2015 01:58:46 -0700
Message-Id: <1426237126-9700-1-git-send-email-linux@roeck-us.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Building alpha:allmodconfig fails with

fs/btrfs/inode.c: In function 'check_direct_IO':
fs/btrfs/inode.c:8050:2: error: implicit declaration of function 'iov_iter_alignment'

due to a missing include file.

Fixes: 3737c63e1fb0 ("fs: move struct kiocb to fs.h")
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 37dc84c..5b6e5bd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -42,6 +42,7 @@
 #include <linux/btrfs.h>
 #include <linux/blkdev.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/uio.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
-- 
2.1.0

