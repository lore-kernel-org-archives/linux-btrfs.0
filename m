Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38965 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752705AbdLKQg4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 11:36:56 -0500
Received: by mail-qt0-f193.google.com with SMTP id k19so40002431qtj.6
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Dec 2017 08:36:56 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, daniel@iogearbox.net, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH v9 2/5] btrfs: make open_ctree error injectable
Date: Mon, 11 Dec 2017 11:36:47 -0500
Message-Id: <1513010210-30594-3-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1513010210-30594-1-git-send-email-josef@toxicpanda.com>
References: <1513010210-30594-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

This allows us to do error injection with BPF for open_ctree.

Signed-off-by: Josef Bacik <jbacik@fb.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 fs/btrfs/disk-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 10a2a579cc7f..02b5f5667754 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -30,6 +30,7 @@
 #include <linux/ratelimit.h>
 #include <linux/uuid.h>
 #include <linux/semaphore.h>
+#include <linux/bpf.h>
 #include <asm/unaligned.h>
 #include "ctree.h"
 #include "disk-io.h"
@@ -3123,6 +3124,7 @@ int open_ctree(struct super_block *sb,
 		goto fail_block_groups;
 	goto retry_root_backup;
 }
+BPF_ALLOW_ERROR_INJECTION(open_ctree);
 
 static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 {
-- 
2.7.5

