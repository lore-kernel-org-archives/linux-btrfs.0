Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37471 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbbCYQwV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 12:52:21 -0400
Received: by wixw10 with SMTP id w10so47279387wix.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2015 09:52:20 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] btrfs: fix build breakage
Date: Wed, 25 Mar 2015 16:52:01 +0000
Message-Id: <1427302321-3458-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds necessary include file, fixing following build errors:

fs/btrfs/inode.c:8094:13: error: undefined identifier 'iov_iter_alignment'
fs/btrfs/inode.c:8105:33: error: using member 'nr_segs' in incomplete struct iov_iter
fs/btrfs/inode.c:8106:43: error: using member 'nr_segs' in incomplete struct iov_iter
fs/btrfs/inode.c:8107:33: error: using member 'iov' in incomplete struct iov_iter
fs/btrfs/inode.c:8140:17: error: undefined identifier 'iov_iter_count'

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Noticed this issue on linux-next, with allmodconfig
 build.

 fs/btrfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index aa8ce48..a938e74 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -42,6 +42,8 @@
 #include <linux/btrfs.h>
 #include <linux/blkdev.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/uio.h>
+
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
-- 
2.1.0

