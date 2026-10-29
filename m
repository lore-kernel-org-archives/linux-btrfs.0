Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268314;
	b=v4qIwp95w0JZq8TV+9h/kgIMH7SDyPLzA0Htg3lmywdkTAAI17mwFwNyzogOz+MZfwux
	 jM8z+L8EXzHL8h+CziF3BdIjZRYnNO/kw6EMnU6RQprDwk9x0ZyvgrR0Ljzejm1UW9Jnf
	 p7eCAXJ3Yc91ynhzgnilNXJUhDp8b5Gry/EliOlUSuQSARg6Pvwa39yQXfmWwD2J1BHrG
	 MfxJg9+NKbOS0eglJE36zF3fWRtA5Z1M887Cr7ZJxqDRW0VPI9tMvvVcFee3+zWNxvEju
	 MWau1f2x6vagk4kEEfJ4Lszu0eNtm1AtqPToQRAcZQSKMxjTKAq3Djd9/hKkMWybcOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268314;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=le9F/ocGS0LnQw35m83/fYtBGQ1AgfmOTZ+alX2hZ18=;
	b=KN6Pzo9n+S0kyRbG5HXDUV3+z6H2HGKTuPAP2fj599Wn5Iw+4nS9hD4HjaQIv4knxlsl
	 w9OuQTavLN4mrBQKkGGx8swTQX/UbDIfLb/QTe3sMU1YdQ/Xkg6sRM6mLv8LsG18ktZ0H
	 LQzRHx14yBxUE/dFB/c7U9XnXB/0msoIPqqAf6i9DS4y7kyxvPdUQ+SG9YeqBSDrnXtZ9
	 kdoMFiXWDkU89BuUYNv/UjdaRqNiCXXH9ywlwGCTbfrG3gRfn+d3boT8ArQezguGwYHxH
	 NsenXQA0ON9KEIJJZVeufqLUZIVSXew5ids6k62JxSVWcz6RnXzCoZ7S0Iw7q+Jpp9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="VT20jv/5";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="VT20jv/5";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34123606A325
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34123606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=VT20jv/5;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=VT20jv/5
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 893881FBA1
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793268312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=le9F/ocGS0LnQw35m83/fYtBGQ1AgfmOTZ+alX2hZ18=;
	b=VT20jv/5dA17EfZ9e43bkVjB4I7xFFjikrAgMYjp55j2ycR9SVxECd24XGzj7sWPCeT1BO
	/EOmJZ7S73OkBAcVz8cZ080DIBaq6nsPoxgpaCug58cwls6eTCuwvFZ+7R7cod9TY6ndfE
	NvuhxjL1TwtvUVGp0FH2dWcah4EFq4I=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="VT20jv/5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793268312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=le9F/ocGS0LnQw35m83/fYtBGQ1AgfmOTZ+alX2hZ18=;
	b=VT20jv/5dA17EfZ9e43bkVjB4I7xFFjikrAgMYjp55j2ycR9SVxECd24XGzj7sWPCeT1BO
	/EOmJZ7S73OkBAcVz8cZ080DIBaq6nsPoxgpaCug58cwls6eTCuwvFZ+7R7cod9TY6ndfE
	NvuhxjL1TwtvUVGp0FH2dWcah4EFq4I=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 772BD1342D
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 380rJ1Ma42qwKgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/5] btrfs-progs: utilize __cleanup__ attribute for btrfs_path
Date: Thu, 29 Oct 2026 20:34:38 +1030
Message-ID: <4c321081adc7a7b962a126406b0ae51138e1414e.1793268211.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793268211.git.wqu@suse.com>
References: <cover.1793268211.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gnu.org:url,llvm.org:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 893881FBA1

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
 configure.ac                  | 15 +++++++++++++++
 include/compiler_attributes.h |  6 ++++++
 kernel-shared/cleanup.h       | 31 +++++++++++++++++++++++++++++++
 kernel-shared/ctree.h         | 10 ++++++++++
 4 files changed, 62 insertions(+)
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
index 000000000000..44c495b8e4ec
--- /dev/null
+++ b/kernel-shared/cleanup.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Cross-ported from kernel's include/linux/cleanup.h.
+ *
+ * With unused macros like return_ptr() and no_free_ptr() removed, along with
+ * comments mentioning them.
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
+ *	function.
+ *
+ * __free(name):
+ *	variable attribute to add a scoped based cleanup to the variable.
+ */
+
+#define DEFINE_FREE(_name, _type, _free) \
+	static __always_inline void __free_##_name(void *p) { _type _T = *(_type *)p; _free; }
+
+#define __free(_name)	__cleanup(__free_##_name)
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

