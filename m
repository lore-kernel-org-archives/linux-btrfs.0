Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795137575;
	b=x8hXQCMTGsTKEen29TMqLJIm3c+S3fk8JIEIVnHXC6r7OvT7OdaJRNytyssiI9uXBzTg
	 IAjjt0dLbfHhSXfXq4f9ix4BBWZLm9BKZHLAxXkviWSdBsqKUh+iIunaZwmHKyND5MfzI
	 T0JEdlxGMDPI0sAKnPr+XU/fTki2lrO4EDDR8NVejZ1PUHcCTDCbakaYu1vXxC8KdR81B
	 IHQH/SEqqgnqxhbCIWIqyollTx1/MkL3sUodnsaSs1Dh+MsiAhrMIA5DBGt29tioL2rgt
	 1MzYffUiQaTHvqSAkgIt5O31Nth9kFaRB51BCbbbkg7Fxyrjt3JgJmxMn9/AUaEuWdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795137575;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=3oAocs64EzR0k+evA+5FOeRNUfNh/mfSOQaUzVZJpCI=;
	b=dNgvsI+CPDEUMAsepIyaejqlOKxoTW9TK3dMsJ6gdTyJCeYFAY2+0QjmmAaBMh9F3z2r
	 q9OMNxpK5HagjLwczKDgdF9csvaEqu4iHLU8Br1ZEe/EeedUgo8tAB8jv+iflHk9yY2DC
	 NR6mYo4Mt9hi88n0S6HtE4K1fylpAk54RI8aMANjqKiXB8kByjzcQ4jINbHCsp33G5+DL
	 40M5PRS0rQtpfPbvqKeKtO3DFyIrvZYdtiRNC7RpCVs7JoEvwns32reo5MH8lYvyXG4C5
	 ak3ZKuysjMYUZa06mGgioxQtmZG41AQ6spuHgw40+mZR5V0nc0EP3UdMH/ZU9oWGc3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=I6BAJuba;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=I6BAJuba;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83344606A320;
	Fri, 20 Nov 2026 01:19:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83344606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=I6BAJuba;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=I6BAJuba
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A62261F7BB;
	Fri, 20 Nov 2026 01:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3oAocs64EzR0k+evA+5FOeRNUfNh/mfSOQaUzVZJpCI=;
	b=I6BAJubaO9fZ7EQKNE0HBK0Xb0L5msCib3bE7ItQUOGmQDpVlue/BMXoVUYCHZeK4kCtgp
	s3BRhR4pzrefZnR/ROnDmm3EOqSb/9nMIWUj4gs4OJBOFa4O8GhGkNfBt+9NPy19LNpCib
	KTmbvbQThe56M58A/bbiWRrutRQuCH4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3oAocs64EzR0k+evA+5FOeRNUfNh/mfSOQaUzVZJpCI=;
	b=I6BAJubaO9fZ7EQKNE0HBK0Xb0L5msCib3bE7ItQUOGmQDpVlue/BMXoVUYCHZeK4kCtgp
	s3BRhR4pzrefZnR/ROnDmm3EOqSb/9nMIWUj4gs4OJBOFa4O8GhGkNfBt+9NPy19LNpCib
	KTmbvbQThe56M58A/bbiWRrutRQuCH4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 70B6A1342D;
	Fri, 20 Nov 2026 01:19:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f6GRNh6g/2r1FAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>); Fri, 20 Nov 2026 01:19:30 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org,
	ardb@kernel.org
Subject: [PATCH RFC v2 1/6] x86: Add a wrapper header for the compiler's SIMD intrinsics
Date: Fri, 20 Nov 2026 11:48:59 +1030
Message-ID: <6ee7e9fd0bdfdf6508f67c4c7e25a16d875ccf6d.1795137348.git.wqu@suse.com>
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

Allow kernel code to use SSE/AVX/PCLMULQDQ etc. from C through the
compiler's intrinsics, as arm and arm64 already do through
asm/neon-intrinsics.h.

There are some points to notice:

- Workaround for <mm_malloc.h> header
  <immintrin.h> pulls in <xmmintrin.h> then <mm_malloc.h> for
  _mm_malloc() and mm_free(), which will further pull in <stdlib.h>.

  No intrinsic depends on those memory allocation/free helpers.
  Workaround by pretending they are already included for both GCC and
  clang.

- Skip intrinsics for genksyms
  Intrinsics expands to 30~50K lines, but nothing is exported. No need
  to expose those for genksyms. This is the same as arm64 NEON wrapper.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 arch/x86/include/asm/x86-intrinsics.h | 49 +++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 arch/x86/include/asm/x86-intrinsics.h

diff --git a/arch/x86/include/asm/x86-intrinsics.h b/arch/x86/include/asm/x86-intrinsics.h
new file mode 100644
index 000000000000..694e11b4b3dc
--- /dev/null
+++ b/arch/x86/include/asm/x86-intrinsics.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Wrapper around the compiler's x86 intrinsics headers, so that kernel code
+ * can use e.g. _mm_crc32_u64() and _mm_clmulepi64_si128() from C.
+ *
+ * Modeled after arch/arm64/include/asm/neon-intrinsics.h.
+ *
+ * Users of this header should:
+ *
+ * - Enable the needed ISA extensions per function with
+ *   __attribute__((target("..."))), e.g. target("sse4.2,pclmul").
+ *   The kernel is built without them (-mno-sse etc.), and this way the
+ *   compiler can only use them inside the functions that are meant to
+ *   run on CPUs that have them.  The helpers calling intrinsics need the
+ *   attribute too.
+ *
+ * - Build the object with -isystem $(CC -print-file-name=include).
+ *   This is to allow including the compiler's intrinsics headers, which
+ *   are not reachable by -nostdinc.
+ */
+
+#ifndef _ASM_X86_X86_INTRINSICS_H
+#define _ASM_X86_X86_INTRINSICS_H
+
+#include <asm-generic/int-ll64.h>
+
+/*
+ * The compiler's <xmmintrin.h> pulls in <mm_malloc.h>, which needs <stdlib.h>
+ * for posix_memalign() and free().  Neither is wanted in the kernel, so pretend
+ * that <mm_malloc.h> was already included.
+ *
+ * The first is for GCC's header, the second for clang's.
+ */
+#ifndef _MM_MALLOC_H_INCLUDED
+#define _MM_MALLOC_H_INCLUDED
+#endif
+#ifndef __MM_MALLOC_H
+#define __MM_MALLOC_H
+#endif
+
+/*
+ * The intrinsics headers expand to 30~50K lines, but nothing exported.
+ * Hide them from genksyms, like the NEON wrapper does.
+ */
+#ifndef __GENKSYMS__
+#include <immintrin.h>
+#endif
+
+#endif /* _ASM_X86_X86_INTRINSICS_H */
-- 
2.56.0

