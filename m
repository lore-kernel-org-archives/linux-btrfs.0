Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267203;
	b=eDla2tW/nijAxelKtlcJyAClI9VXobenXrL3S+JbCkU6Fhaa90Qryd8fp944xgPvRsSl
	 PXWGnTv+8xnxAq5Ml7BeUSghaR4fH3G9mcyGAxZFRNj9EoFEA5Fq/VlLHLhITEp9tao0m
	 1xopTSJ+JBrPLhEYqn1uIJqm/OsCE/8L5uHYiv1Qr/D9qd0vStgpCGHcVPpPRWGP1BSsA
	 z74TvXP68swvg0jLUktA2f+11envr/h+AIswEdADQz6xNgQg55kUro9HPecXNd+itoOJI
	 P7JeyQJ6esKTVnSHX6CLCSEAm2xoodaTr+FX2cvhgla8ZcIlgqSHW1Wff9h7Qdd30ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267203;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=/xre4QXcv90hjCjSMhWAXhBY3Wjpc1Z+qv/LcmhpXbg=;
	b=Dei2KgeX1FWAt1qJn6DvSb9Suq3n2IXoYb+SwH1Zxa5k8+0c8w8DOlgEmRUXl1HwfG7U
	 HlWOv4TPBwGJkfyLml/OrZ7HJZgJuK+EJneLlLlhdFGGEGSao+EaXeW+Z9gjIcVssVN74
	 Z5juSR57/fK8etlHgwIozBKwCmO9VNkkYVwr0ul6JuWZPCZFCZ9WgYTZfqpiCnLkw3WXd
	 7G4keuMQ91jIDEUKBBxy9y64ChABflhl8gwrX0Z0HDX6IUwZnIZ+jbgd3DrreKqP8hF9K
	 DWCl9twys0qmp0eOO+cYYD4kf9pm6wGCcEEPMO1SNzrJElwhwQG/A/aXuxvGEnDPcJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HEEKa2dd;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HEEKa2dd;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9172B606A321
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9172B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HEEKa2dd;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HEEKa2dd
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B3C4E1FB82
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793267200; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/xre4QXcv90hjCjSMhWAXhBY3Wjpc1Z+qv/LcmhpXbg=;
	b=HEEKa2ddAlbcNOntxWaCe2Z+5fuhI631wYprMeJMdrogI33Fd8KymrQ8i7wuE1S+uYdUMi
	Gjpl4NwJF4ux4E5hV5VbrlHqOyEKtGM1CDauSsfGm0ySPbiQioSYqjEm2etG9BSvfx7ItX
	ezJEbKf0vhxyz1dNgCxuFe2YvMIgeYE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=HEEKa2dd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793267200; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/xre4QXcv90hjCjSMhWAXhBY3Wjpc1Z+qv/LcmhpXbg=;
	b=HEEKa2ddAlbcNOntxWaCe2Z+5fuhI631wYprMeJMdrogI33Fd8KymrQ8i7wuE1S+uYdUMi
	Gjpl4NwJF4ux4E5hV5VbrlHqOyEKtGM1CDauSsfGm0ySPbiQioSYqjEm2etG9BSvfx7ItX
	ezJEbKf0vhxyz1dNgCxuFe2YvMIgeYE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97EB213419
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fpy8FP0V42o+FwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] btrfs-progs: introduce compiler_attributes.h
Date: Thu, 29 Oct 2026 20:16:11 +1030
Message-ID: <5b483c92d995d1a07918aac47259cf63a9df5603.1793266694.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: B3C4E1FB82
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,llvm.org:url,gnu.org:url,suse.com:dkim,suse.com:email]
X-Spam-Score: -12.01

Cross-port a minimal include/compiler_attributes.h from the kernel's
include/linux/compiler_attributes.h, and move the existing attribute
definitions there:

- __must_check
  Previously defined in kernel-lib/overflow.h, which is not a proper
  place for a generic attribute. Anyone wanting __must_check would have
  to include overflow.h just for it.

- __printf
- __maybe_unused
  Previously defined in include/kerncompat.h.

The new header has no other includes so it can be pulled in by any
header that only needs a compiler attribute. kerncompat.h includes it,
so existing users are not affected.

Assisted-By: LLM (Split the compiler_attributes.h from the next commit)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 include/compiler_attributes.h | 33 +++++++++++++++++++++++++++++++++
 include/kerncompat.h          |  7 +------
 kernel-lib/overflow.h         |  8 +-------
 3 files changed, 35 insertions(+), 13 deletions(-)
 create mode 100644 include/compiler_attributes.h

diff --git a/include/compiler_attributes.h b/include/compiler_attributes.h
new file mode 100644
index 000000000000..e9ac1ac64cd8
--- /dev/null
+++ b/include/compiler_attributes.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _COMPILER_ATTRIBUTES_H
+#define _COMPILER_ATTRIBUTES_H
+
+/*
+ * Copied from linux.git/include/linux/compiler_attributes.h, only contains the
+ * attributes btrfs-progs needs.
+ *
+ * This header must stay free of any other includes, so it can be pulled in by
+ * any header which only needs a compiler attribute.
+ */
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-format-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#format
+ */
+#define __printf(a, b)			__attribute__((__format__(printf, a, b)))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-warn_005funused_005fresult-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#nodiscard-warn-unused-result
+ */
+#define __must_check			__attribute__((__warn_unused_result__))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-unused-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#maybe-unused-unused
+ */
+#ifndef __maybe_unused
+#define __maybe_unused			__attribute__((__unused__))
+#endif
+
+#endif
diff --git a/include/kerncompat.h b/include/kerncompat.h
index 0239b0ac807a..b8e9a6c9c04b 100644
--- a/include/kerncompat.h
+++ b/include/kerncompat.h
@@ -38,6 +38,7 @@
 #include <stdbool.h>
 #include <stdarg.h>
 #include <features.h>
+#include "compiler_attributes.h"
 
 #ifndef static_assert
 #define static_assert(expr, str) _Static_assert(expr, str)
@@ -58,10 +59,6 @@
 
 #endif
 
-#ifndef __maybe_unused
-#define __maybe_unused __attribute__((__unused__))
-#endif
-
 #ifndef BTRFS_DISABLE_BACKTRACE
 #include <execinfo.h>
 #endif
@@ -776,8 +773,6 @@ struct lock_class_key {
 #define __user
 #define __pure
 
-#define __printf(a, b)                  __attribute__((__format__(printf, a, b)))
-
 static inline bool sb_rdonly(struct super_block *sb)
 {
 	return false;
diff --git a/kernel-lib/overflow.h b/kernel-lib/overflow.h
index b2a376ee13c4..d942b11924cc 100644
--- a/kernel-lib/overflow.h
+++ b/kernel-lib/overflow.h
@@ -5,6 +5,7 @@
 #include <stdbool.h>
 #include <stddef.h>
 #include <stdint.h>
+#include "compiler_attributes.h"
 
 /*
  * We need to compute the minimum and maximum values representable in a given
@@ -42,13 +43,6 @@
 #define is_non_negative(a) ((a) > 0 || (a) == 0)
 #define is_negative(a) (!(is_non_negative(a)))
 
-/* Copied from linux.git/include/compiler_attributes.h */
-/*
- *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-warn_005funused_005fresult-function-attribute
- * clang: https://clang.llvm.org/docs/AttributeReference.html#nodiscard-warn-unused-result
- */
-#define __must_check                    __attribute__((__warn_unused_result__))
-
 /*
  * Allows for effectively applying __must_check to a macro so we can have
  * both the type-agnostic benefits of the macros while also being able to
-- 
2.56.0

