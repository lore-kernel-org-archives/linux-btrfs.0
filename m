Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:43771 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752691AbdLFQMa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Dec 2017 11:12:30 -0500
Received: by mail-qt0-f196.google.com with SMTP id w10so10089974qtb.10
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Dec 2017 08:12:30 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, daniel@iogearbox.net, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH v8 5/5] btrfs: allow us to inject errors at io_ctl_init
Date: Wed,  6 Dec 2017 11:12:17 -0500
Message-Id: <1512576737-9417-6-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1512576737-9417-1-git-send-email-josef@toxicpanda.com>
References: <1512576737-9417-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

This was instrumental in reproducing a space cache bug.

Signed-off-by: Josef Bacik <jbacik@fb.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 fs/btrfs/free-space-cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index cdc9f4015ec3..daa98dc1f844 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/math64.h>
 #include <linux/ratelimit.h>
+#include <linux/bpf.h>
 #include "ctree.h"
 #include "free-space-cache.h"
 #include "transaction.h"
@@ -332,6 +333,7 @@ static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
 
 	return 0;
 }
+BPF_ALLOW_ERROR_INJECTION(io_ctl_init);
 
 static void io_ctl_free(struct btrfs_io_ctl *io_ctl)
 {
-- 
2.7.5

