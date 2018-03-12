Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751543AbeCLKBP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 06:01:15 -0400
From: Masami Hiramatsu <mhiramat@kernel.org>
To: Alexei Starovoitov <ast@fb.com>, Josef Bacik <jbacik@fb.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        kernel-team@fb.com, daniel@iogearbox.net, linux-btrfs@vger.kernel.org,
        darrick.wong@oracle.com, mhiramat@kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: [BUGFIX PATCH bpf-next] error-injection: Fix to prohibit jump optimization
Date: Mon, 12 Mar 2018 19:00:49 +0900
Message-Id: <152084884886.1536.4464134247603910765.stgit@devbox>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since the kprobe which was optimized by jump can not change
the execution path, the kprobe for error-injection must not
be optimized. To prohibit it, set a dummy post-handler as
officially stated in Documentation/kprobes.txt.

Fixes: 4b1a29a7f542 ("error-injection: Support fault injection framework")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 kernel/fail_function.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/fail_function.c b/kernel/fail_function.c
index 21b0122cb39c..1d5632d8bbcc 100644
--- a/kernel/fail_function.c
+++ b/kernel/fail_function.c
@@ -14,6 +14,15 @@
 
 static int fei_kprobe_handler(struct kprobe *kp, struct pt_regs *regs);
 
+static void fei_post_handler(struct kprobe *kp, struct pt_regs *regs,
+			     unsigned long flags)
+{
+	/*
+	 * A dummy post handler is required to prohibit optimizing, because
+	 * jump optimization does not support execution path overriding.
+	 */
+}
+
 struct fei_attr {
 	struct list_head list;
 	struct kprobe kp;
@@ -56,6 +65,7 @@ static struct fei_attr *fei_attr_new(const char *sym, unsigned long addr)
 			return NULL;
 		}
 		attr->kp.pre_handler = fei_kprobe_handler;
+		attr->kp.post_handler = fei_post_handler;
 		attr->retval = adjust_error_retval(addr, 0);
 		INIT_LIST_HEAD(&attr->list);
 	}

