Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267204;
	b=OIs0fCH7nkKW1JPCCe8Wn0hr/pBAvJfegwUoR80fZs56Vi/Ch9hPqvGGO4VdQOCCoUpi
	 b+dFEd8f1dN99kFELE5ulhZH+kodjdcFbMMjPqwyZYUqMfrYjBVEUs8i0GZKDVmxECpwB
	 JQXmSlRkaOtY/u3AXbzGTmGDZmFzU3gDKXyaCclTIO9vsrlEy49pJOtsl1ZO9LxZ4KXbo
	 sfOJ237nHe2fYVKtPRSV7bnxf/Vt6l5vhw9VMbuvYPmTP/c3hJSGuO+emZNuU4fxkNbHA
	 0hrXjCjObMJ+kPg9qsirryDWhBPRzkinp1hUKExYGIIH7A2dxfJ2e10tVCev9CZPzIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267204;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=5xcrKKH3SlGkIKe1aafS9tv0gc8N2nQWrFXYNs0ZIn0=;
	b=uHuqf7t6qq5S+0BOd5Zd8ELedyNh9/FxRjEMTxnkW62EwRDxKBNeZRimIIa8ASQPFRUP
	 nJKS6De6l+rMPwlCaVDy3v5NBt/z/jbJoJqlqgXJL9XJmbvn++MmxB3ydnE49wFOkBtZI
	 0l7z/g7HjkHNELadiHScZExa7O+68rqyXTLmMG6VI3ntnp56ZMIVLHyNQf26Kt49J+gpF
	 wLV3x2QatWUcJ0dXgsNePd4hQKNKBc6sYlMuUfnMyFYXBM5DEo7UWeJIoWT7JZJYC7Iy+
	 bw1BFPKEmEyx29UvnWDoYP/UL8CAOmEbtOm59Hd3eP4cNBCTFk2dzWeeoKD37ij96Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Rw2YF0+1;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Rw2YF0+1;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE68B606A322
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE68B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Rw2YF0+1;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Rw2YF0+1
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5037321F6D
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793267202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xcrKKH3SlGkIKe1aafS9tv0gc8N2nQWrFXYNs0ZIn0=;
	b=Rw2YF0+1unT8AKQOgmaYagCSClsMPQlciIBWtL9luJI10V0AZjiuHIAHexT84TFG555O7J
	xXMEpFIx5MrLw3FFFNdsbexR1Bcxh/PyyzrBQ0d5dvqW9TcGCdn6lxPhOJDBIiBsmyn1VJ
	TqxYUYR3x0Y3nUY29fS+2lEcwReMB+c=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Rw2YF0+1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793267202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xcrKKH3SlGkIKe1aafS9tv0gc8N2nQWrFXYNs0ZIn0=;
	b=Rw2YF0+1unT8AKQOgmaYagCSClsMPQlciIBWtL9luJI10V0AZjiuHIAHexT84TFG555O7J
	xXMEpFIx5MrLw3FFFNdsbexR1Bcxh/PyyzrBQ0d5dvqW9TcGCdn6lxPhOJDBIiBsmyn1VJ
	TqxYUYR3x0Y3nUY29fS+2lEcwReMB+c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B33F13419
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fpy8FP0V42o+FwAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] btrfs-progs: utilize __cleanup__ attribute for btrfs_path
Date: Thu, 29 Oct 2026 20:16:12 +1030
Message-ID: <e550663684dc50df06cc4dfd7cb4b8ff31db9c86.1793266694.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793266694.git.wqu@suse.com>
References: <cover.1793266694.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5037321F6D
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gnu.org:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,llvm.org:url,suse.com:dkim,suse.com:email]
X-Spam-Score: -12.01

The new header at kernel-shared/cleanup.h is cross-ported from the
kernel's linux/cleanup.h.

Since we rely on the newer __cleanup__ attribute, also update the
configure tool to detect the compiler support.
If no support, error out.

As we will rely on the __cleanup__ attribute to do auto cleanup. Ignoring
such attribute will easily screw up future resource management.

With the new __free() macros, define BTRFS_PATH_AUTO_FREE() and
BTRFS_PATH_AUTO_RELEASE(), so we can sync the code between progs and
kernel.

Assisted-by: LLM (updating configure.ac to error out if no such support)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 configure.ac                  | 15 ++++++
 include/compiler_attributes.h |  6 +++
 kernel-shared/cleanup.h       | 89 +++++++++++++++++++++++++++++++++++
 kernel-shared/ctree.h         | 10 ++++
 4 files changed, 120 insertions(+)
 create mode 100644 kernel-shared/cleanup.h

diff --git a/configure.ac b/configure.ac
index b12ca46814bf..07cd92df5947 100644
--- a/configure.ac
+++ b/configure.ac
@@ -67,6 +67,21 @@ AS_IF([test "x$target_cpu" = 'xx86_64'], [
 AX_CHECK_COMPILE_FLAG([-std=gnu11], [],
 	[AC_MSG_ERROR([std=gnu11 compiler required])])
 
+dnl The __cleanup__ variable attribute is required by kernel-shared/cleanup.h
+AC_MSG_CHECKING([whether the compiler supports __attribute__((__cleanup__))])
+save_ac_c_werror_flag=$ac_c_werror_flag
+ac_c_werror_flag=yes
+AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
+static void free_int(int *p) { *p = 0; }
+]], [[
+	int x __attribute__((__cleanup__(free_int))) = 1;
+	(void)x;
+]])],
+	[AC_MSG_RESULT([yes])],
+	[AC_MSG_RESULT([no])
+	 AC_MSG_ERROR([compiler with __attribute__((__cleanup__)) support required])])
+ac_c_werror_flag=$save_ac_c_werror_flag
+
 AC_SYS_LARGEFILE
 
 AC_PROG_INSTALL
diff --git a/include/compiler_attributes.h b/include/compiler_attributes.h
index e9ac1ac64cd8..41edbab9c55a 100644
--- a/include/compiler_attributes.h
+++ b/include/compiler_attributes.h
@@ -10,6 +10,12 @@
  * any header which only needs a compiler attribute.
  */
 
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-cleanup-variable-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#cleanup
+ */
+#define __cleanup(func)			__attribute__((__cleanup__(func)))
+
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-format-function-attribute
  * clang: https://clang.llvm.org/docs/AttributeReference.html#format
diff --git a/kernel-shared/cleanup.h b/kernel-shared/cleanup.h
new file mode 100644
index 000000000000..c8f12e2e343a
--- /dev/null
+++ b/kernel-shared/cleanup.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Cross-ported from kernel's include/linux/cleanup.h, along with needed
+ * compiler attributes from include/linux/compiler_attributes.h
+ */
+#ifndef _LINUX_CLEANUP_H
+#define _LINUX_CLEANUP_H
+
+#include "kerncompat.h"
+#include "compiler_attributes.h"
+
+/*
+ * DEFINE_FREE(name, type, free):
+ *	simple helper macro that defines the required wrapper for a __free()
+ *	based cleanup function. @free is an expression using '_T' to access the
+ *	variable. @free should typically include a NULL test before calling a
+ *	function, see the example below.
+ *
+ * __free(name):
+ *	variable attribute to add a scoped based cleanup to the variable.
+ *
+ * no_free_ptr(var):
+ *	like a non-atomic xchg(var, NULL), such that the cleanup function will
+ *	be inhibited -- provided it sanely deals with a NULL value.
+ *
+ *	NOTE: this has __must_check semantics so that it is harder to accidentally
+ *	leak the resource.
+ *
+ * return_ptr(p):
+ *	returns p while inhibiting the __free().
+ *
+ * Ex.
+ *
+ * DEFINE_FREE(kfree, void *, if (_T) kfree(_T))
+ *
+ * void *alloc_obj(...)
+ * {
+ *	struct obj *p __free(kfree) = kmalloc(...);
+ *	if (!p)
+ *		return NULL;
+ *
+ *	if (!init_obj(p))
+ *		return NULL;
+ *
+ *	return_ptr(p);
+ * }
+ *
+ * NOTE: the DEFINE_FREE()'s @free expression includes a NULL test even though
+ * kfree() is fine to be called with a NULL value. This is on purpose. This way
+ * the compiler sees the end of our alloc_obj() function as:
+ *
+ *	tmp = p;
+ *	p = NULL;
+ *	if (p)
+ *		kfree(p);
+ *	return tmp;
+ *
+ * And through the magic of value-propagation and dead-code-elimination, it
+ * eliminates the actual cleanup call and compiles into:
+ *
+ *	return p;
+ *
+ * Without the NULL test it turns into a mess and the compiler can't help us.
+ */
+
+#define DEFINE_FREE(_name, _type, _free) \
+	static __always_inline void __free_##_name(void *p) { _type _T = *(_type *)p; _free; }
+
+#define __free(_name)	__cleanup(__free_##_name)
+
+#define __get_and_null(p, nullvalue)	    \
+	({                                  \
+		auto __ptr = &(p);	    \
+		auto __val = *__ptr;	    \
+		*__ptr = nullvalue;         \
+		__val;                      \
+	})
+
+static __always_inline __must_check
+const volatile void * __must_check_fn(const volatile void *val)
+{ return val; }
+
+#define no_free_ptr(p) \
+	((typeof(p)) __must_check_fn((__force const volatile void *)__get_and_null(p, NULL)))
+
+#define return_ptr(p)	return no_free_ptr(p)
+
+#endif
diff --git a/kernel-shared/ctree.h b/kernel-shared/ctree.h
index 93fd7f18049e..3a5f456df315 100644
--- a/kernel-shared/ctree.h
+++ b/kernel-shared/ctree.h
@@ -30,6 +30,7 @@
 #include "kernel-shared/accessors.h"
 #include "kernel-shared/extent-io-tree.h"
 #include "kernel-shared/locking.h"
+#include "kernel-shared/cleanup.h"
 #include "crypto/crc32c.h"
 #include "common/extent-cache.h"
 
@@ -1024,6 +1025,15 @@ void btrfs_release_path(struct btrfs_path *p);
 void add_root_to_dirty_list(struct btrfs_root *root);
 struct btrfs_path *btrfs_alloc_path(void);
 void btrfs_free_path(struct btrfs_path *p);
+DEFINE_FREE(btrfs_free_path, struct btrfs_path *, btrfs_free_path(_T))
+DEFINE_FREE(btrfs_release_path, struct btrfs_path, btrfs_release_path(&_T))
+
+#define BTRFS_PATH_AUTO_FREE(path_name)					\
+	struct btrfs_path *path_name __free(btrfs_free_path) = NULL
+
+#define BTRFS_PATH_AUTO_RELEASE(path_name)				\
+	struct btrfs_path path_name __free(btrfs_release_path) = { 0 }
+
 int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_path *path, int slot, int nr);
 
-- 
2.56.0

