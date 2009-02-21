From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/3] Extensible printk (and friends)
Date: Fri, 20 Feb 2009 20:57:23 -0500
Message-ID: <499F5F83.9060602@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch adds the ability to add arbitrary types to vsprintf rather
 than adding every type to pointer().

 Future users include reiserfs and btrfs, where it's much more
 convenient to print messages with common data structures with a simple
 printk rather than a series of them. It makes the code much cleaner and
 easier to read.

 This functionality is accessed via the e-prefixed versions of the usual
 string formatting and printing routines by using "%pe<letter>" as a
 format string. Callers establish a set of operations and pass it as the
 first argument. I expect this will typically be hidden behind a helper
 function, much like reiserfs_warning, etc does now.

 Example, eprintk(btrfs_printf_ops, "Invalid key %pek\n", key);

 or more likely: btrfs_warning(sb, "Invalid key %pek\n", key);

 instead of printk("Invalid key [%llu %d %llu]\n",
		   le64_to_cpu(key->objectid), key->type,
		   le64_to_cpu(key->offset));

 It's even more useful when larger and/or multiple objects need to be
 printed.

 Another advantage is smaller code size due to smaller strings and less
 calculation surrounding each print site. I haven't converted btrfs yet
 and reiserfs already uses a similar mechanism, so I don't have hard
 numbers for this.

 The only exception to the e-prefix rule is kasprintf, etc, which will
 retain the k prefix. It's sort of arbitrary, since I would have assumed
 those functions would retain a ka-prefix, but that isn't the case.

 Later patches re-implement most of pointer() as an epointer() client,
 as well as convert reiserfs's prepare_error_buf to this interface.

 No additional code changes are required - this is for extensions only.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 include/linux/kernel.h       |   36 +++++++++++++
 include/linux/sprintf_type.h |   11 ++++
 kernel/printk.c              |   26 ++++++++-
 lib/kasprintf.c              |   27 ++++++++--
 lib/vsprintf.c               |  115 ++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 197 insertions(+), 18 deletions(-)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -17,6 +17,7 @@
 #include <linux/typecheck.h>
 #include <linux/ratelimit.h>
 #include <linux/dynamic_printk.h>
+#include <linux/sprintf_type.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -177,19 +178,42 @@ extern int strict_strtoull(const char *,
 extern int strict_strtoll(const char *, unsigned int, long long *);
 extern int sprintf(char * buf, const char * fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
+extern int esprintf(const struct sprintf_type *types, char *buf,
+		    const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
 extern int vsprintf(char *buf, const char *, va_list)
 	__attribute__ ((format (printf, 2, 0)));
+extern int evsprintf(const struct sprintf_type *types, char *buf,
+		     const char *, va_list)
+	__attribute__ ((format (printf, 3, 0)));
 extern int snprintf(char * buf, size_t size, const char * fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
+extern int esnprintf(const struct sprintf_type *types, char *buf,
+		     size_t size, const char *fmt, ...)
+	__attribute__ ((format (printf, 4, 5)));
 extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 3, 0)));
+extern int evsnprintf(const struct sprintf_type *types, char *buf,
+		      size_t size, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 4, 0)));
 extern int scnprintf(char * buf, size_t size, const char * fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
+extern int escnprintf(const struct sprintf_type *types, char *buf,
+		      size_t size, const char *fmt, ...)
+	__attribute__ ((format (printf, 4, 5)));
 extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 3, 0)));
+extern int evscnprintf(const struct sprintf_type *types, char *buf,
+		       size_t size, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 4, 0)));
 extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
+extern char *keasprintf(const struct sprintf_type *types, gfp_t gfp,
+			const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
 extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
+extern char *kevasprintf(const struct sprintf_type *types, gfp_t gfp,
+			 const char *fmt, va_list args);
 
 extern int sscanf(const char *, const char *, ...)
 	__attribute__ ((format (scanf, 2, 3)));
@@ -233,6 +257,12 @@ extern struct pid *session_of_pgrp(struc
 #define FW_INFO		"[Firmware Info]: "
 
 #ifdef CONFIG_PRINTK
+asmlinkage int evprintk(const struct sprintf_type *types,
+			const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+asmlinkage int eprintk(const struct sprintf_type *types,
+		       const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3))) __cold;
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
@@ -250,6 +280,12 @@ static inline int printk(const char *s,
 	__attribute__ ((format (printf, 1, 2)));
 static inline int __cold printk(const char *s, ...) { return 0; }
 static inline int printk_ratelimit(void) { return 0; }
+static inline int evprintk(const struct sprintf_type *types,
+			   const char *s, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+static inline int __cold eprintk(const struct sprintf_type *types,
+				 const char *s, ...)
+	__attribute__ ((format (printf, 2, 3)));
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
--- /dev/null
+++ b/include/linux/sprintf_type.h
@@ -0,0 +1,11 @@
+#ifndef _SPRINTF_TYPE_H_
+#define _SPRINTF_TYPE_H_
+
+struct sprintf_type {
+	char format_char;
+	char * (*formatter)(const char *fmt, char *buf, char *end,
+			    const void *ptr, int field_width, int precision,
+			    int flags);
+};
+
+#endif
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -567,6 +567,19 @@ asmlinkage int printk(const char *fmt, .
 	return r;
 }
 
+asmlinkage int eprintk(const struct sprintf_type *types, const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = evprintk(types, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(eprintk);
+
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;
 
@@ -622,7 +635,8 @@ static int recursion_bug;
 static int new_text_line = 1;
 static char printk_buf[1024];
 
-asmlinkage int vprintk(const char *fmt, va_list args)
+asmlinkage int evprintk(const struct sprintf_type *types, const char *fmt,
+			va_list args)
 {
 	int printed_len = 0;
 	int current_log_level = default_message_loglevel;
@@ -665,8 +679,8 @@ asmlinkage int vprintk(const char *fmt,
 		printed_len = strlen(recursion_bug_msg);
 	}
 	/* Emit the output into the temporary buffer */
-	printed_len += vscnprintf(printk_buf + printed_len,
-				  sizeof(printk_buf) - printed_len, fmt, args);
+	printed_len += evscnprintf(types, printk_buf + printed_len,
+				   sizeof(printk_buf) - printed_len, fmt, args);
 
 
 	/*
@@ -737,6 +751,12 @@ out_restore_irqs:
 	preempt_enable();
 	return printed_len;
 }
+EXPORT_SYMBOL(evprintk);
+
+asmlinkage int vprintk(const char *fmt, va_list args)
+{
+	return evprintk(NULL, fmt, args);
+}
 EXPORT_SYMBOL(printk);
 EXPORT_SYMBOL(vprintk);
 
--- a/lib/kasprintf.c
+++ b/lib/kasprintf.c
@@ -10,24 +10,31 @@
 #include <linux/string.h>
 
 /* Simplified asprintf. */
-char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
+char *kevasprintf(const struct sprintf_type *types, gfp_t gfp,
+		  const char *fmt, va_list ap)
 {
 	unsigned int len;
 	char *p;
 	va_list aq;
 
 	va_copy(aq, ap);
-	len = vsnprintf(NULL, 0, fmt, aq);
+	len = evsnprintf(types, NULL, 0, fmt, aq);
 	va_end(aq);
 
 	p = kmalloc(len+1, gfp);
 	if (!p)
 		return NULL;
 
-	vsnprintf(p, len+1, fmt, ap);
+	evsnprintf(types, p, len+1, fmt, ap);
 
 	return p;
 }
+EXPORT_SYMBOL(kevasprintf);
+
+char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
+{
+	return kevasprintf(NULL, gfp, fmt, ap);
+}
 EXPORT_SYMBOL(kvasprintf);
 
 char *kasprintf(gfp_t gfp, const char *fmt, ...)
@@ -42,3 +49,17 @@ char *kasprintf(gfp_t gfp, const char *f
 	return p;
 }
 EXPORT_SYMBOL(kasprintf);
+
+char *keasprintf(const struct sprintf_type *types, gfp_t gfp,
+		 const char *fmt, ...)
+{
+	va_list ap;
+	char *p;
+
+	va_start(ap, fmt);
+	p = kevasprintf(types, gfp, fmt, ap);
+	va_end(ap);
+
+	return p;
+}
+EXPORT_SYMBOL(keasprintf);
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -641,10 +641,27 @@ static char *ip4_addr_string(char *buf,
 	return string(buf, end, ip4_addr, field_width, precision, flags & ~SPECIAL);
 }
 
+static char *epointer(const char *fmt, char *buf, char *end, const void *ptr,
+		      int field_width, int precision, int flags,
+		      const struct sprintf_type *types)
+{
+	const struct sprintf_type *type;
+	if (!*fmt)
+		return NULL;
+
+	for (type = types; type && type->formatter; type++) {
+		if (*fmt == type->format_char)
+			return type->formatter(fmt + 1, buf, end, ptr,
+					       field_width, precision, flags);
+	}
+	return NULL;
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
- * specifiers.
+ * specifiers. Any unhandled alphanumeric characters following the '%p'
+ * will be skipped.
  *
  * Right now we handle:
  *
@@ -658,13 +675,22 @@ static char *ip4_addr_string(char *buf,
  *       decimal for v4 and colon separated network-order 16 bit hex for v6)
  * - 'i' [46] for 'raw' IPv4/IPv6 addresses, IPv6 omits the colons, IPv4 is
  *       currently the same
+ * - 'e' <char> for custom type handling via the e-prefixed versions of the
+ *       usual sprintf family of functions.  The caller is required to pass a
+ *       NULL terminated array of struct sprintf_type to provide the
+ *       formatting rules.  The formatter is permitted to handle any
+ *	 additional alphanumeric characters following its own format character.
+ *       If <char> is unhandled, generic '%p' formatting will be used.
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
  */
-static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field_width, int precision, int flags)
+static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
+		     int field_width, int precision, int flags,
+		     const struct sprintf_type *types)
 {
+	char *p;
 	if (!ptr)
 		return string(buf, end, "(null)", field_width, precision, flags);
 
@@ -691,6 +717,11 @@ static char *pointer(const char *fmt, ch
 			return ip4_addr_string(buf, end, ptr, field_width, precision, flags);
 		flags &= ~SPECIAL;
 		break;
+	case 'e':
+		p = epointer(fmt + 1, buf, end, ptr, field_width, precision,
+			     flags, types);
+		if (p)
+			return p;
 	}
 	flags |= SMALL;
 	if (field_width == -1) {
@@ -704,6 +735,7 @@ static char *pointer(const char *fmt, ch
  * vsnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
  * @size: The size of the buffer, including the trailing null space
+ * @ops: An optional array of operations for special %p handling
  * @fmt: The format string to use
  * @args: Arguments for the format string
  *
@@ -723,7 +755,8 @@ static char *pointer(const char *fmt, ch
  * Call this function if you are already dealing with a va_list.
  * You probably want snprintf() instead.
  */
-int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+int evsnprintf(const struct sprintf_type *types, char *buf, size_t size,
+	       const char *fmt, va_list args)
 {
 	unsigned long long num;
 	int base;
@@ -849,7 +882,8 @@ int vsnprintf(char *buf, size_t size, co
 			case 'p':
 				str = pointer(fmt+1, str, end,
 						va_arg(args, void *),
-						field_width, precision, flags);
+						field_width, precision, flags,
+						types);
 				/* Skip all alphanumeric pointer suffixes */
 				while (isalnum(fmt[1]))
 					fmt++;
@@ -937,6 +971,12 @@ int vsnprintf(char *buf, size_t size, co
 	/* the trailing null byte doesn't count towards the total */
 	return str-buf;
 }
+EXPORT_SYMBOL(evsnprintf);
+
+int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+{
+	return evsnprintf(NULL, buf, size, fmt, args);
+}
 EXPORT_SYMBOL(vsnprintf);
 
 /**
@@ -955,13 +995,19 @@ EXPORT_SYMBOL(vsnprintf);
  *
  * See the vsnprintf() documentation for format string extensions over C99.
  */
-int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
+int evscnprintf(const struct sprintf_type *types, char *buf, size_t size,
+		const char *fmt, va_list args)
 {
-	int i;
-
-	i=vsnprintf(buf,size,fmt,args);
+	int i = evsnprintf(types, buf, size, fmt, args);
 	return (i >= size) ? (size - 1) : i;
 }
+EXPORT_SYMBOL(evscnprintf);
+
+int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
+{
+	return evscnprintf(NULL, buf, size, fmt, args);
+}
+
 EXPORT_SYMBOL(vscnprintf);
 
 /**
@@ -978,18 +1024,31 @@ EXPORT_SYMBOL(vscnprintf);
  *
  * See the vsnprintf() documentation for format string extensions over C99.
  */
-int snprintf(char * buf, size_t size, const char *fmt, ...)
+int snprintf(char *buf, size_t size, const char *fmt, ...)
 {
 	va_list args;
 	int i;
 
 	va_start(args, fmt);
-	i=vsnprintf(buf,size,fmt,args);
+	i = vsnprintf(buf, size, fmt, args);
 	va_end(args);
 	return i;
 }
 EXPORT_SYMBOL(snprintf);
 
+int esnprintf(const struct sprintf_type *types, char *buf, size_t size,
+	      const char *fmt, ...)
+{
+	va_list args;
+	int i;
+
+	va_start(args, fmt);
+	i = evsnprintf(types, buf, size, fmt, args);
+	va_end(args);
+	return i;
+}
+EXPORT_SYMBOL(esnprintf);
+
 /**
  * scnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
@@ -1001,7 +1060,7 @@ EXPORT_SYMBOL(snprintf);
  * the trailing '\0'. If @size is <= 0 the function returns 0.
  */
 
-int scnprintf(char * buf, size_t size, const char *fmt, ...)
+int scnprintf(char *buf, size_t size, const char *fmt, ...)
 {
 	va_list args;
 	int i;
@@ -1013,6 +1072,19 @@ int scnprintf(char * buf, size_t size, c
 }
 EXPORT_SYMBOL(scnprintf);
 
+int escnprintf(const struct sprintf_type *types, char *buf, size_t size,
+	       const char *fmt, ...)
+{
+	va_list args;
+	int i;
+
+	va_start(args, fmt);
+	i = evsnprintf(types, buf, size, fmt, args);
+	va_end(args);
+	return (i >= size) ? (size - 1) : i;
+}
+EXPORT_SYMBOL(escnprintf);
+
 /**
  * vsprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
@@ -1034,6 +1106,13 @@ int vsprintf(char *buf, const char *fmt,
 }
 EXPORT_SYMBOL(vsprintf);
 
+int evsprintf(const struct sprintf_type *types, char *buf, const char *fmt,
+	      va_list args)
+{
+	return evsnprintf(types, buf, INT_MAX, fmt, args);
+}
+EXPORT_SYMBOL(evsprintf);
+
 /**
  * sprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
@@ -1052,12 +1131,24 @@ int sprintf(char * buf, const char *fmt,
 	int i;
 
 	va_start(args, fmt);
-	i=vsnprintf(buf, INT_MAX, fmt, args);
+	i = vsnprintf(buf, INT_MAX, fmt, args);
 	va_end(args);
 	return i;
 }
 EXPORT_SYMBOL(sprintf);
 
+int esprintf(const struct sprintf_type *types, char *buf, const char *fmt, ...)
+{
+	va_list args;
+	int i;
+
+	va_start(args, fmt);
+	i = evsnprintf(types, buf, INT_MAX, fmt, args);
+	va_end(args);
+	return i;
+}
+EXPORT_SYMBOL(esprintf);
+
 /**
  * vsscanf - Unformat a buffer into a list of arguments
  * @buf:	input buffer
-- 
Jeff Mahoney
SUSE Labs
