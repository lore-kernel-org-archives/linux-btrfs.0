From: liubo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH] Trace: use unsigned long long in trace print frames
Date: Fri, 01 Apr 2011 14:42:35 +0800
Message-ID: <4D9573DB.4010009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Rostedt <rostedt@goodmis.org>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


While adding tracepoint for btrfs, I got a problem:

btrfs uses some macros with "ULL" type, but tracepoint's macros,
__print_[flags,symbols](), only have "unsigned long", so on 32bit box
there will be 64->32 truncate WARNINGs when compiling.

Here I'm inclined to make the replacement to clear those WARNINGs.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 include/linux/ftrace_event.h |    7 ++++---
 kernel/trace/trace_output.c  |   10 +++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 22b32af..b52f2c5 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -12,15 +12,16 @@ struct tracer;
 struct dentry;
 
 struct trace_print_flags {
-	unsigned long		mask;
+	unsigned long long	mask;
 	const char		*name;
 };
 
 const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
-				   unsigned long flags,
+				   unsigned long long flags,
 				   const struct trace_print_flags *flag_array);
 
-const char *ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
+const char *ftrace_print_symbols_seq(struct trace_seq *p,
+				     unsigned long long val,
 				     const struct trace_print_flags *symbol_array);
 
 const char *ftrace_print_hex_seq(struct trace_seq *p,
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 456be90..97ba902 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -294,10 +294,10 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
 
 const char *
 ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
-		       unsigned long flags,
+		       unsigned long long flags,
 		       const struct trace_print_flags *flag_array)
 {
-	unsigned long mask;
+	unsigned long long mask;
 	const char *str;
 	const char *ret = p->buffer + p->len;
 	int i;
@@ -319,7 +319,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 	if (flags) {
 		if (p->len && delim)
 			trace_seq_puts(p, delim);
-		trace_seq_printf(p, "0x%lx", flags);
+		trace_seq_printf(p, "0x%llx", flags);
 	}
 
 	trace_seq_putc(p, 0);
@@ -329,7 +329,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 EXPORT_SYMBOL(ftrace_print_flags_seq);
 
 const char *
-ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
+ftrace_print_symbols_seq(struct trace_seq *p, unsigned long long val,
 			 const struct trace_print_flags *symbol_array)
 {
 	int i;
@@ -345,7 +345,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 	}
 
 	if (!p->len)
-		trace_seq_printf(p, "0x%lx", val);
+		trace_seq_printf(p, "0x%llx", val);
 		
 	trace_seq_putc(p, 0);
 
-- 
1.6.5.2
