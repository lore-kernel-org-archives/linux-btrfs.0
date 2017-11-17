Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:38734 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754453AbdKQSAO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 13:00:14 -0500
Received: by mail-qt0-f195.google.com with SMTP id f8so7836177qta.5
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 10:00:13 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, daniel@iogearbox.net, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 2/4] btrfs: make open_ctree error injectable
Date: Fri, 17 Nov 2017 13:00:05 -0500
Message-Id: <1510941607-3997-3-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1510941607-3997-1-git-send-email-josef@toxicpanda.com>
References: <1510941607-3997-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

This allows us to do error injection with BPF for open_ctree.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/disk-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dfdab849037b..c6b4e1f07072 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -31,6 +31,7 @@
 #include <linux/uuid.h>
 #include <linux/semaphore.h>
 #include <asm/unaligned.h>
+#include <asm/kprobes.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "hash.h"
@@ -3283,6 +3284,7 @@ int open_ctree(struct super_block *sb,
 		goto fail_block_groups;
 	goto retry_root_backup;
 }
+BPF_ALLOW_ERROR_INJECTION(open_ctree);
 
 static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 {
-- 
2.7.5

