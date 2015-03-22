Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52303 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbbCWFAT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 01:00:19 -0400
From: Mark Brown <broonie@kernel.org>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Date: Sun, 22 Mar 2015 16:46:15 +0000
Message-Id: <1427042775-8258-1-git-send-email-broonie@kernel.org>
Subject: [PATCH] btrfs: Fix implicit inclusion of linux/uio.h
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs inode.c relies on implicit inclusion of linux/uio.h for
definitions of struct iov_iter and iov_iter_alignment() which breaks the
current ARM allmodconfig build where that implicit inclusion does not
happen.  Add an explicit include to fix that.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 37dc84c..9e4a634 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -29,6 +29,7 @@
 #include <linux/backing-dev.h>
 #include <linux/mpage.h>
 #include <linux/swap.h>
+#include <linux/uio.h>
 #include <linux/writeback.h>
 #include <linux/statfs.h>
 #include <linux/compat.h>
-- 
2.1.4

