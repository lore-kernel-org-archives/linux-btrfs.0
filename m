From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH 2/3 (take 2)] printk: Convert existing pointer() extensions
 to operations
Date: Fri, 20 Feb 2009 21:02:24 -0500
Message-ID: <499F60B0.1030502@suse.com>
References: <499F5F8D.6070200@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <499F5F8D.6070200@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch converts the existing pointer extensions from a switch statement
 to an array of printf_operations.

 The result is a very small pointer(), which only tests for null, tries
 to expand typed pointers, and eventually falls back to numeric printing.

 The previous version still had a printf_operations struct, which I renamed
 in favor of sprintf_type. Yay quilt refresh.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 lib/vsprintf.c |  116 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 79 insertions(+), 37 deletions(-)

--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -541,7 +541,9 @@ static char *string(char *buf, char *end
 	return buf;
 }
 
-static char *symbol_string(char *buf, char *end, void *ptr, int field_width, int precision, int flags)
+static char *sprintf_symbol(const char *fmt, char *buf, char *end,
+			    const void *ptr, int field_width, int precision,
+			    int flags)
 {
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
@@ -555,7 +557,9 @@ static char *symbol_string(char *buf, ch
 #endif
 }
 
-static char *resource_string(char *buf, char *end, struct resource *res, int field_width, int precision, int flags)
+static char *sprintf_resource(const char *fmt, char *buf, char *end,
+			      const void *ptr, int field_width, int precision,
+			      int flags)
 {
 #ifndef IO_RSRC_PRINTK_SIZE
 #define IO_RSRC_PRINTK_SIZE	4
@@ -568,6 +572,7 @@ static char *resource_string(char *buf,
 	/* room for the actual numbers, the two "0x", -, [, ] and the final zero */
 	char sym[4*sizeof(resource_size_t) + 8];
 	char *p = sym, *pend = sym + sizeof(sym);
+	const struct resource *res = ptr;
 	int size = -1;
 
 	if (res->flags & IORESOURCE_IO)
@@ -585,9 +590,11 @@ static char *resource_string(char *buf,
 	return string(buf, end, sym, field_width, precision, flags);
 }
 
-static char *mac_address_string(char *buf, char *end, u8 *addr, int field_width,
-				int precision, int flags)
+static char *sprintf_mac_address(const char *fmt, char *buf, char *end,
+				 const void *ptr, int field_width,
+				 int precision, int flags)
 {
+	const u8 *addr = ptr;
 	char mac_addr[6 * 3]; /* (6 * 2 hex digits), 5 colons and trailing zero */
 	char *p = mac_addr;
 	int i;
@@ -602,9 +609,19 @@ static char *mac_address_string(char *bu
 	return string(buf, end, mac_addr, field_width, precision, flags & ~SPECIAL);
 }
 
-static char *ip6_addr_string(char *buf, char *end, u8 *addr, int field_width,
-			 int precision, int flags)
+static char *sprintf_mac_address_colons(const char *fmt, char *buf, char *end,
+					const void *ptr, int field_width,
+					int precision, int flags)
 {
+	return sprintf_mac_address(fmt, buf, end, ptr, field_width, precision,
+				   flags | SPECIAL);
+}
+
+static char *sprintf_ip6_addr(const char *fmt, char *buf, char *end,
+			      const void *ptr, int field_width, int precision,
+			      int flags)
+{
+	const u8 *addr = ptr;
 	char ip6_addr[8 * 5]; /* (8 * 4 hex digits), 7 colons and trailing zero */
 	char *p = ip6_addr;
 	int i;
@@ -620,9 +637,11 @@ static char *ip6_addr_string(char *buf,
 	return string(buf, end, ip6_addr, field_width, precision, flags & ~SPECIAL);
 }
 
-static char *ip4_addr_string(char *buf, char *end, u8 *addr, int field_width,
-			 int precision, int flags)
+static char *sprintf_ip4_addr(const char *fmt, char *buf, char *end,
+			      const void *ptr, int field_width, int precision,
+			      int flags)
 {
+	const u8 *addr = ptr;
 	char ip4_addr[4 * 4]; /* (4 * 3 decimal digits), 3 dots and trailing zero */
 	char temp[3];	/* hold each IP quad in reverse order */
 	char *p = ip4_addr;
@@ -641,6 +660,47 @@ static char *ip4_addr_string(char *buf,
 	return string(buf, end, ip4_addr, field_width, precision, flags & ~SPECIAL);
 }
 
+static char *sprintf_ip_addr(const char *fmt, char *buf, char *end,
+			     const void *ptr, int field_width, int precision,
+			     int flags)
+{
+	if (*fmt == '6')
+		return sprintf_ip6_addr(fmt + 1, buf, end, ptr, field_width,
+					precision, flags);
+	else if (*fmt == '4')
+		return sprintf_ip4_addr(fmt + 1, buf, end, ptr, field_width,
+					precision, flags);
+	return NULL;
+}
+
+static char *sprintf_ip_addr_colons(const char *fmt, char *buf, char *end,
+				    const void *ptr, int field_width,
+				    int precision, int flags)
+{
+	return sprintf_ip_addr(fmt, buf, end, ptr, field_width, precision,
+			       flags | SPECIAL);
+}
+
+static char *sprintf_function_descriptor(const char *fmt, char *buf, char *end,
+					 const void *ptr, int field_width,
+					 int precision, int flags)
+{
+	return sprintf_symbol(fmt, buf, end,
+			      dereference_function_descriptor(ptr),
+			      field_width, precision, flags);
+}
+
+static const struct sprintf_type std_kernel_sprintf_types[] = {
+	{ .format_char = 'F', .formatter = sprintf_function_descriptor, },
+	{ .format_char = 'S', .formatter = sprintf_symbol, },
+	{ .format_char = 'R', .formatter = sprintf_resource, },
+	{ .format_char = 'm', .formatter = sprintf_mac_address_colons, },
+	{ .format_char = 'M', .formatter = sprintf_mac_address, },
+	{ .format_char = 'i', .formatter = sprintf_ip_addr_colons, },
+	{ .format_char = 'I', .formatter = sprintf_ip_addr, },
+	{},
+};
+
 static char *epointer(const char *fmt, char *buf, char *end, const void *ptr,
 		      int field_width, int precision, int flags,
 		      const struct sprintf_type *types)
@@ -692,43 +752,25 @@ static char *pointer(const char *fmt, ch
 {
 	char *p;
 	if (!ptr)
-		return string(buf, end, "(null)", field_width, precision, flags);
+		return string(buf, end, "(null)", field_width, precision,
+			      flags);
 
-	switch (*fmt) {
-	case 'F':
-		ptr = dereference_function_descriptor(ptr);
-		/* Fallthrough */
-	case 'S':
-		return symbol_string(buf, end, ptr, field_width, precision, flags);
-	case 'R':
-		return resource_string(buf, end, ptr, field_width, precision, flags);
-	case 'm':
-		flags |= SPECIAL;
-		/* Fallthrough */
-	case 'M':
-		return mac_address_string(buf, end, ptr, field_width, precision, flags);
-	case 'i':
-		flags |= SPECIAL;
-		/* Fallthrough */
-	case 'I':
-		if (fmt[1] == '6')
-			return ip6_addr_string(buf, end, ptr, field_width, precision, flags);
-		if (fmt[1] == '4')
-			return ip4_addr_string(buf, end, ptr, field_width, precision, flags);
-		flags &= ~SPECIAL;
-		break;
-	case 'e':
+	if (*fmt == 'e')
 		p = epointer(fmt + 1, buf, end, ptr, field_width, precision,
 			     flags, types);
-		if (p)
-			return p;
-	}
+	else
+		p = epointer(fmt, buf, end, ptr, field_width, precision,
+			     flags, std_kernel_sprintf_types);
+	if (p)
+		return p;
+
 	flags |= SMALL;
 	if (field_width == -1) {
 		field_width = 2*sizeof(void *);
 		flags |= ZEROPAD;
 	}
-	return number(buf, end, (unsigned long) ptr, 16, field_width, precision, flags);
+	return number(buf, end, (unsigned long) ptr, 16, field_width,
+		      precision, flags);
 }
 
 /**

-- 
Jeff Mahoney
SUSE Labs
