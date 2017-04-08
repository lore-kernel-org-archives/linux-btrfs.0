Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33852 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933959AbdDHA6m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 20:58:42 -0400
From: Deepa Dinamani <deepa.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: tglx@linutronix.de, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org,
        andreas.dilger@intel.com, arnd@arndb.de, bfields@fieldses.org,
        clm@fb.com, davem@davemloft.net, dsterba@suse.com, dushistov@mail.ru,
        eparis@redhat.com, jaegeuk@kernel.org, jbacik@fb.com,
        jlayton@poochiereds.net, john.stultz@linaro.org,
        jsimmons@infradead.org, mingo@redhat.com, oleg.drokin@intel.com,
        paul@paul-moore.com, rostedt@goodmis.org, yuchao0@huawei.com,
        ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-audit@redhat.com, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-security-module@vger.kernel.org, lustre-devel@lists.lustre.org,
        netdev@vger.kernel.org, samba-technical@lists.samba.org,
        y2038@lists.linaro.org
Subject: [PATCH 06/12] audit: Use timespec64 to represent audit timestamps
Date: Fri,  7 Apr 2017 17:57:04 -0700
Message-Id: <1491613030-11599-7-git-send-email-deepa.kernel@gmail.com>
In-Reply-To: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

struct timespec is not y2038 safe.
Audit timestamps are recorded in string format into
an audit buffer for a given context.
These mark the entry timestamps for the syscalls.
Use y2038 safe struct timespec64 to represent the times.
The log strings can handle this transition as strings can
hold upto 1024 characters.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Paul Moore <paul@paul-moore.com>
Acked-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |  4 ++--
 kernel/audit.c        | 10 +++++-----
 kernel/audit.h        |  2 +-
 kernel/auditsc.c      |  6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 6fdfefc..f830508 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -332,7 +332,7 @@ static inline void audit_ptrace(struct task_struct *t)
 				/* Private API (for audit.c only) */
 extern unsigned int audit_serial(void);
 extern int auditsc_get_stamp(struct audit_context *ctx,
-			      struct timespec *t, unsigned int *serial);
+			      struct timespec64 *t, unsigned int *serial);
 extern int audit_set_loginuid(kuid_t loginuid);
 
 static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
@@ -511,7 +511,7 @@ static inline void __audit_seccomp(unsigned long syscall, long signr, int code)
 static inline void audit_seccomp(unsigned long syscall, long signr, int code)
 { }
 static inline int auditsc_get_stamp(struct audit_context *ctx,
-			      struct timespec *t, unsigned int *serial)
+			      struct timespec64 *t, unsigned int *serial)
 {
 	return 0;
 }
diff --git a/kernel/audit.c b/kernel/audit.c
index 2f4964c..fcbf377 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1625,10 +1625,10 @@ unsigned int audit_serial(void)
 }
 
 static inline void audit_get_stamp(struct audit_context *ctx,
-				   struct timespec *t, unsigned int *serial)
+				   struct timespec64 *t, unsigned int *serial)
 {
 	if (!ctx || !auditsc_get_stamp(ctx, t, serial)) {
-		*t = CURRENT_TIME;
+		ktime_get_real_ts64(t);
 		*serial = audit_serial();
 	}
 }
@@ -1652,7 +1652,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 				     int type)
 {
 	struct audit_buffer *ab;
-	struct timespec t;
+	struct timespec64 t;
 	unsigned int uninitialized_var(serial);
 
 	if (audit_initialized != AUDIT_INITIALIZED)
@@ -1705,8 +1705,8 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	}
 
 	audit_get_stamp(ab->ctx, &t, &serial);
-	audit_log_format(ab, "audit(%lu.%03lu:%u): ",
-			 t.tv_sec, t.tv_nsec/1000000, serial);
+	audit_log_format(ab, "audit(%llu.%03lu:%u): ",
+			 (unsigned long long)t.tv_sec, t.tv_nsec/1000000, serial);
 
 	return ab;
 }
diff --git a/kernel/audit.h b/kernel/audit.h
index 0f1cf6d..cdf96f4 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -112,7 +112,7 @@ struct audit_context {
 	enum audit_state    state, current_state;
 	unsigned int	    serial;     /* serial number for record */
 	int		    major;      /* syscall number */
-	struct timespec	    ctime;      /* time of syscall entry */
+	struct timespec64   ctime;      /* time of syscall entry */
 	unsigned long	    argv[4];    /* syscall arguments */
 	long		    return_code;/* syscall return code */
 	u64		    prio;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index e59ffc7..a2d9217 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1532,7 +1532,7 @@ void __audit_syscall_entry(int major, unsigned long a1, unsigned long a2,
 		return;
 
 	context->serial     = 0;
-	context->ctime      = CURRENT_TIME;
+	ktime_get_real_ts64(&context->ctime);
 	context->in_syscall = 1;
 	context->current_state  = state;
 	context->ppid       = 0;
@@ -1941,13 +1941,13 @@ EXPORT_SYMBOL_GPL(__audit_inode_child);
 /**
  * auditsc_get_stamp - get local copies of audit_context values
  * @ctx: audit_context for the task
- * @t: timespec to store time recorded in the audit_context
+ * @t: timespec64 to store time recorded in the audit_context
  * @serial: serial value that is recorded in the audit_context
  *
  * Also sets the context as auditable.
  */
 int auditsc_get_stamp(struct audit_context *ctx,
-		       struct timespec *t, unsigned int *serial)
+		       struct timespec64 *t, unsigned int *serial)
 {
 	if (!ctx->in_syscall)
 		return 0;
-- 
2.7.4

