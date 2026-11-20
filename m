Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795137586;
	b=oVsQxjPgw5jCK4WAUouRFAC6KZ5K0vS3kNhvtD9HSQ5idf+sOkTMj1ViWHvqvcmqBJYj
	 dHqSGd7+LBKVhLNadn/kjsA7nvLWLGTSnu4cUELVR52EWo6EKbqBHb3Nhm25JrtvAz1ZE
	 y6/H6/uihr2dUM5mWMkJLxkIn3sLyK+PGMO0uftiBZR11IkBFsrcq636MI+6KQ0x4ISCc
	 Hu0XyUYIUFovS/wvK0LN6RsWhIldgoJ1JI8FJyAuVIA8L6tRavgrlMSEebGAHdOy9lPyl
	 sMqtpsRofUODaw3oCpj9jhjfq+naHZrxHzN0Gkm+Q4JJOHkEImPI236gV5+zE82+XZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795137586;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=bKKBr+WuQi+GVnA3KE07Fb5L3H9lRnHkancr3gb8Kqc=;
	b=znAdIPzOxwYf5yMPTYGo9Aii3DOgwvGhYfCwFSWW0Zm/1RrAjLmB/B8p/egh6BbJk8Ku
	 5YDSaU07dvTUq+kihlHyRGpRVtmdBouHFzNcBmd2I8ztWkvyyS4SLPJ71/npiNR/Uqsyt
	 ykxGNuB5aRXjVgtrTS9NlrQMYvyyIn1GhojsH2mtKe1uQlWsDChOxSavtCorEmYjjV4tU
	 tCCCDYTyTxUeSvGc8+VuhexWRdY7SNx83j1fA5VeCM5RTDQ2MmLvz+XG5cfXueDI0CErN
	 xtQg6phY6+IDLC3iZ0HmXm2Hu2CpZjaQgDw1YMdOjd45yxW/7AqlR4ch3NcKNZzOWnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uXomySCq;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uXomySCq;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C22606A320;
	Fri, 20 Nov 2026 01:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86C22606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uXomySCq;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uXomySCq
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DD8701F7BB;
	Fri, 20 Nov 2026 01:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bKKBr+WuQi+GVnA3KE07Fb5L3H9lRnHkancr3gb8Kqc=;
	b=uXomySCqW1CfsHdQtLJHuZxG7pJFUYdJj+zSeoUHVpVZLtaGnYALNBI8ioQ4NS1ybvD3GG
	SXlpRuzqHT9r4SFD596EJKO5CaGeOsVhN7swO0Aom/dcTEwE527gviRHrhpxhyCBlwmYG1
	hk53M9QZ9zje2+lqzUdxPiM8AzfaW4o=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bKKBr+WuQi+GVnA3KE07Fb5L3H9lRnHkancr3gb8Kqc=;
	b=uXomySCqW1CfsHdQtLJHuZxG7pJFUYdJj+zSeoUHVpVZLtaGnYALNBI8ioQ4NS1ybvD3GG
	SXlpRuzqHT9r4SFD596EJKO5CaGeOsVhN7swO0Aom/dcTEwE527gviRHrhpxhyCBlwmYG1
	hk53M9QZ9zje2+lqzUdxPiM8AzfaW4o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A73F61342D;
	Fri, 20 Nov 2026 01:19:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f6GRNh6g/2r1FAAAD6G6ig:T6
	(envelope-from <wqu@suse.com>); Fri, 20 Nov 2026 01:19:41 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org,
	ardb@kernel.org
Subject: [PATCH RFC v2 5/6] lib/crc: x86: Convert crc64_lsb_*() from assembly to C
Date: Fri, 20 Nov 2026 11:49:03 +1030
Message-ID: <30b4534ac43c0d28b727c9d7ac4f492e62927936.1795137348.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795137348.git.wqu@suse.com>
References: <cover.1795137348.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Rewrite the three crc64_lsb functions in C using the template, which now
supports the final reduction of LSB-first 64-bit CRCs.

Remove crc64-pclmul.S, as nothing is left in it.

Build changes:
- Add crc64-lsb-pclmul.o, built with x86-intrin-cflags, and drop
  crc64-pclmul.o.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 lib/crc/Makefile               |  3 ++-
 lib/crc/x86/crc-pclmul-impl.h  | 14 ++++++++++++++
 lib/crc/x86/crc64-lsb-pclmul.c | 23 +++++++++++++++++++++++
 lib/crc/x86/crc64-pclmul.S     |  6 ------
 4 files changed, 39 insertions(+), 7 deletions(-)
 create mode 100644 lib/crc/x86/crc64-lsb-pclmul.c
 delete mode 100644 lib/crc/x86/crc64-pclmul.S

diff --git a/lib/crc/Makefile b/lib/crc/Makefile
index 302183401543..343d252a3b33 100644
--- a/lib/crc/Makefile
+++ b/lib/crc/Makefile
@@ -53,8 +53,9 @@ crc64-$(CONFIG_ARM) += crc64-neon.o
 crc64-$(CONFIG_ARM64) += crc64-neon.o
 
 crc64-$(CONFIG_RISCV) += riscv/crc64_lsb.o riscv/crc64_msb.o
-crc64-$(CONFIG_X86) += x86/crc64-pclmul.o x86/crc64-msb-pclmul.o
+crc64-$(CONFIG_X86) += x86/crc64-msb-pclmul.o x86/crc64-lsb-pclmul.o
 CFLAGS_x86/crc64-msb-pclmul.o += $(x86-intrin-cflags)
+CFLAGS_x86/crc64-lsb-pclmul.o += $(x86-intrin-cflags)
 endif # CONFIG_CRC64_ARCH
 
 obj-y += tests/
diff --git a/lib/crc/x86/crc-pclmul-impl.h b/lib/crc/x86/crc-pclmul-impl.h
index db3d4dcef8ee..47b5d75d483b 100644
--- a/lib/crc/x86/crc-pclmul-impl.h
+++ b/lib/crc/x86/crc-pclmul-impl.h
@@ -264,6 +264,20 @@ crc_t CRC_FUNC(crc_t crc, const u8 *p, size_t len, const void *consts_ptr)
 	x1 = _mm_clmulepi64_si128(x1, k128, 0x10);
 	x0 = _mm_xor_si128(x0, x1);
 	return _mm_extract_epi32(x0, 2);
+#else
+	/*
+	 * For an LSB-first CRC-64 the low qword of x1, floor(t0 / G), must also
+	 * be XORed into the CRC.  Move it to the high qword, the one that is
+	 * extracted, so that the two XORs can be done together.
+	 */
+	x1 = _mm_clmulepi64_si128(x0, k128, 0x10);
+	x0 = _mm_xor_si128(_mm_srli_si128(x0, 8), x1);
+	k128 = consts[4];
+	x1 = _mm_clmulepi64_si128(x0, k128, 0x00);
+	x0 = _mm_xor_si128(x0, _mm_unpacklo_epi64(x1, x1));
+	x1 = _mm_clmulepi64_si128(x1, k128, 0x10);
+	x0 = _mm_xor_si128(x0, x1);
+	return _mm_extract_epi64(x0, 1);
 #endif /* CRC_MSB */
 }
 
diff --git a/lib/crc/x86/crc64-lsb-pclmul.c b/lib/crc/x86/crc64-lsb-pclmul.c
new file mode 100644
index 000000000000..a184ffb2f19a
--- /dev/null
+++ b/lib/crc/x86/crc64-lsb-pclmul.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * CRC-64 (LSB-first) using [V]PCLMULQDQ, via C intrinsics
+ *
+ * Copyright 2025 Google LLC
+ */
+
+#include <linux/types.h>
+
+#define CRC_BITS 64
+#define CRC_MSB 0
+
+#define VL 16
+#define CRC_FUNC crc64_lsb_pclmul_sse
+#include "crc-pclmul-impl.h"
+
+#define VL 32
+#define CRC_FUNC crc64_lsb_vpclmul_avx2
+#include "crc-pclmul-impl.h"
+
+#define VL 64
+#define CRC_FUNC crc64_lsb_vpclmul_avx512
+#include "crc-pclmul-impl.h"
diff --git a/lib/crc/x86/crc64-pclmul.S b/lib/crc/x86/crc64-pclmul.S
deleted file mode 100644
index 9e1230ce5c8f..000000000000
--- a/lib/crc/x86/crc64-pclmul.S
+++ /dev/null
@@ -1,6 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-// Copyright 2025 Google LLC
-
-#include "crc-pclmul-template.S"
-
-DEFINE_CRC_PCLMUL_FUNCS(crc64_lsb, /* bits= */ 64, /* lsb= */ 1)
-- 
2.56.0

