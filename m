Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268397;
	b=zLZovWhfVWuEAlIyIwzypgKfEDXPfEuB8ZA9CEvIMKxFY+6vAW/YDqhwrXM2dYdZMaiS
	 GE2+v7L0bulP/z8UGTpNBbadbqt7iIOW5IJO3cPuBCjOGdSTtKP9G0RyuYWtNJclOoYy9
	 h89skvqHaVp0AV396X2aZ0b6Ne3+TLrgZ3spDCuk//yiDLmx+Y+H3hhP+Jcql8t/vHZql
	 idNXR4bVLXWudW9WjV+nwGexRVoiSWFbHFJBMyMc0rbAn3+MZqbKXL7LAYmo0+3eoIVtP
	 oqSvH9l1GM2K1zjTyFhT4qrR9jkyjYEyqYQgZ1ThfSNxycQkoIAtMTLI3EF2I3WOGaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268397;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=tZXODO9G9wXDCllXFupRyqH+6tNnTzexvRvg91C+yp8=;
	b=FtuCDu1D8ulu8A7lBE58QJG1F56eg7v/mLy1r18ZXGzNvpnCSfiSDJBf9BRCa6ox/Hbk
	 H+NSD6P0uZzqXaxIvMdR8T2hUp4fg9DJpPggVAkERudpxnB1Bg0ygOL5WMpxMNGvqWTkJ
	 tZHu7L/rmh89+z9jpdEbh5V4FkDU0YF9xYqfJf6fjuElqGmUQM2BnxBFQO88YRg+y6ala
	 jExNfZcSWyG13Mpm8HSqmSRZNH2fih8vGhnXkyDs2uqtybFsaQ82la2ROel6tjAMoZdMC
	 pCM6P2WcE1WvZ1ASnoaVEihLaT3UwaZc0XeVNaHJ8knK2b5yevXyx8XUEPb3lL6/1hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hmI69hGe;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hmI69hGe;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CAC606A31C;
	Mon,  9 Nov 2026 23:53:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56CAC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hmI69hGe;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hmI69hGe
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 100251F792;
	Mon,  9 Nov 2026 23:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794268394; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tZXODO9G9wXDCllXFupRyqH+6tNnTzexvRvg91C+yp8=;
	b=hmI69hGeGsFRJTu21VbrYtLK94eakp/axIWVhbjjXvluCrWP4fwCSHrOpjcJovHwFD8DZw
	uhB8BBPacidXUv07omBxmbEAqGNQ54JGcgiHQA/l1e+RUAaUr9aYxfC/JuZoU2q3iyT4rQ
	srCsHs6njjWAnP0hf+/9ifFf4P6FBrc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=hmI69hGe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794268394; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tZXODO9G9wXDCllXFupRyqH+6tNnTzexvRvg91C+yp8=;
	b=hmI69hGeGsFRJTu21VbrYtLK94eakp/axIWVhbjjXvluCrWP4fwCSHrOpjcJovHwFD8DZw
	uhB8BBPacidXUv07omBxmbEAqGNQ54JGcgiHQA/l1e+RUAaUr9aYxfC/JuZoU2q3iyT4rQ
	srCsHs6njjWAnP0hf+/9ifFf4P6FBrc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 881FA13319;
	Mon,  9 Nov 2026 23:53:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hrfNM+Zc8mpuKAAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 09 Nov 2026 23:53:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org,
	ardb@kernel.org
Subject: [PATCH] lib/crc: x86: rewrite crc32c_x86_3way() in C with inline asm
Date: Tue, 10 Nov 2026 10:22:48 +1030
Message-ID: <090c5f6603b1102c877c8649f7a6569f362bfe61.1794268279.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
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
X-Rspamd-Queue-Id: 100251F792
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
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:url,suse.com:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

Unlike user space, we can not use intrinsics, so some instructions must
still use inlined ASM, but that is only limited to crc32_u*() helpers
and the PCLMULQDQ based lanes combination.

Those wrappers are in the new crc32c-inst.h header, and are also
utilized by crc32c_arch() and the new C based crc32c_x86_3way().

The hot loop is the same sequence of crc32 instructions as in the asm
version, with the same lane addressing.
The differences in the generated code (x86_64, clang, function tracing
enabled) are as follows.

The old 4x unrolled loop is 12 memory-operand crc32q plus 3 bookkeeping
instructions per iteration:

    crc32q  (bufp), crc0_q
    crc32q  (bufp,chunk_bytes_q), crc1
    crc32q  (bufp,chunk_bytes_q,2), crc2
    ... same for offsets 8, 16 and 24 ...
    add     $32, bufp
    sub     $4, %eax
    jge     .Lcrc_3lanes_4x_loop

The new one has the same 12 crc32 and the same addressing, but clang
can't fold the load into the instruction because ASM_INPUT_RM is "r" for
clang, so every crc32 has a preceding mov:

    mov     (%rsi),%r14
    crc32   %r14,%r9
    mov     (%rsi,%rdx,8),%r14
    crc32   %r14,%r11
    mov     (%rsi,%r10,1),%r14
    crc32   %r14,%rax
    ... same for offsets 8, 16 and 24 ...
    add     $-4,%rbx
    add     $0x20,%rsi
    cmp     $3,%rbx
    ja      <loop>

Thus 12 extra loads per iteration.  They don't matter in practice, as the
loop is bound by the latency of the three crc32 dependency chains, not by
uop throughput.
Forcing the memory form with "m" made no difference either in a userspace
benchmark.  gcc accepts "rm" and folds the loads into crc32q (checked on
a userspace build of the same code).

The combination step is the same instructions, with the old code being

    pmovzxdq (K_table-8)(%rax,chunk_bytes_q), %xmm0
    movq    crc0_q, %xmm1
    pclmulqdq $0x00, %xmm0, %xmm1
    movq    crc1, %xmm2
    pclmulqdq $0x10, %xmm0, %xmm2
    pxor    %xmm2, %xmm1
    movq    %xmm1, %rax
    xor     (bufp,chunk_bytes_q,2), %rax
    mov     crc2, crc0_q
    crc32   %rax, crc0_q

and the new one

    mov     %r9d,%r9d
    mov     %r11d,%r11d
    pmovzxdq 0x0(%rdi,%rdx,8),%xmm0
    movq    %r9,%xmm1
    pclmulqdq $0x00,%xmm0,%xmm1
    movq    %r11,%xmm2
    pclmulqdq $0x10,%xmm0,%xmm2
    pxor    %xmm2,%xmm1
    movq    %xmm1,%rdx
    xor     (%rsi,%r10,1),%rdx
    crc32   %rdx,%rax

The two movs at the top are the (u64) zero extensions of the lane CRCs,
which are redundant as crc32q already zeroes the upper half.  The
register copy of crc2 disappears as crc2 is just the accumulator for the
final crc32.

The rest (prologue/epilogue, alignment head and sub-qword tail) is not
performance critical.  The only visible difference is the usual kernel
function prologue with a few callee-saved register pushes.

Measured throughput matches the old implementation within noise, both in
a userspace comparison (gcc and clang, 200 bytes to 1 MiB) and in the
in-kernel CRC32C KUnit benchmark, using a Zen5 (HX 370) based system.

Assisted-by: LLM (coding and testing)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Reason for RFC:

The idea is inspired when I was cleaning up btrfs-progs, to prepare for
new arm64 CRC32C implementation, as a preparation I want to remove all
ASM file and inline ASM usages in userspace btrfs-progs.
That works pretty well, so here I'm trying to cross-port this change to
the kernel 3way acceleration path.

Although I would prefer a code base with less minimal ASM files, I'm not
sure if everyone prefers this solution other than hand-written ASM code.

Furthermore all my tests are on a Zen5 based system (HX 370), with
cpuid masking to test the 3way optimization code.

So no test on older platforms.

If this one is fine, I can continue converting the AVX512 version too.
And hopefully can cross-port the C version of AVX512 back to
btrfs-progs.
---
 lib/crc/x86/crc32.h       |  18 +-
 lib/crc/x86/crc32c-3way.S | 360 --------------------------------------
 lib/crc/x86/crc32c-3way.c | 309 ++++++++++++++++++++++++++++++++
 lib/crc/x86/crc32c-3way.h |   9 +
 lib/crc/x86/crc32c-inst.h |  42 +++++
 5 files changed, 366 insertions(+), 372 deletions(-)
 delete mode 100644 lib/crc/x86/crc32c-3way.S
 create mode 100644 lib/crc/x86/crc32c-3way.c
 create mode 100644 lib/crc/x86/crc32c-3way.h
 create mode 100644 lib/crc/x86/crc32c-inst.h

diff --git a/lib/crc/x86/crc32.h b/lib/crc/x86/crc32.h
index 19a5e3c6c73b..b0763cc82696 100644
--- a/lib/crc/x86/crc32.h
+++ b/lib/crc/x86/crc32.h
@@ -8,6 +8,8 @@
  */
 
 #include "crc-pclmul-template.h"
+#include "crc32c-3way.h"
+#include "crc32c-inst.h"
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_crc32);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pclmulqdq);
@@ -22,20 +24,12 @@ static inline u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 	return crc32_le_base(crc, p, len);
 }
 
-#ifdef CONFIG_X86_64
-#define CRC32_INST "crc32q %1, %q0"
-#else
-#define CRC32_INST "crc32l %1, %0"
-#endif
-
 /*
  * Use carryless multiply version of crc32c when buffer size is >= 512 to
  * account for FPU state save/restore overhead.
  */
 #define CRC32C_PCLMUL_BREAKEVEN	512
 
-asmlinkage u32 crc32c_x86_3way(u32 crc, const u8 *buffer, size_t len);
-
 static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 {
 	size_t num_longs;
@@ -87,18 +81,18 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 
 	for (num_longs = len / sizeof(unsigned long);
 	     num_longs != 0; num_longs--, p += sizeof(unsigned long))
-		asm(CRC32_INST : "+r" (crc) : ASM_INPUT_RM (*(unsigned long *)p));
+		crc = crc32c_ulong(crc, *(unsigned long *)p);
 
 	if (sizeof(unsigned long) > 4 && (len & 4)) {
-		asm("crc32l %1, %0" : "+r" (crc) : ASM_INPUT_RM (*(u32 *)p));
+		crc = crc32c_u32(crc, *(u32 *)p);
 		p += 4;
 	}
 	if (len & 2) {
-		asm("crc32w %1, %0" : "+r" (crc) : ASM_INPUT_RM (*(u16 *)p));
+		crc = crc32c_u16(crc, *(u16 *)p);
 		p += 2;
 	}
 	if (len & 1)
-		asm("crc32b %1, %0" : "+r" (crc) : ASM_INPUT_RM (*p));
+		crc = crc32c_u8(crc, *p);
 
 	return crc;
 }
diff --git a/lib/crc/x86/crc32c-3way.S b/lib/crc/x86/crc32c-3way.S
deleted file mode 100644
index 9b8770503bbc..000000000000
--- a/lib/crc/x86/crc32c-3way.S
+++ /dev/null
@@ -1,360 +0,0 @@
-/*
- * Implement fast CRC32C with PCLMULQDQ instructions. (x86_64)
- *
- * The white papers on CRC32C calculations with PCLMULQDQ instruction can be
- * downloaded from:
- * http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/crc-iscsi-polynomial-crc32-instruction-paper.pdf
- * http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/fast-crc-computation-paper.pdf
- *
- * Copyright (C) 2012 Intel Corporation.
- * Copyright 2024 Google LLC
- *
- * Authors:
- *	Wajdi Feghali <wajdi.k.feghali@intel.com>
- *	James Guilford <james.guilford@intel.com>
- *	David Cote <david.m.cote@intel.com>
- *	Tim Chen <tim.c.chen@linux.intel.com>
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#include <linux/linkage.h>
-
-## ISCSI CRC 32 Implementation with crc32 and pclmulqdq Instruction
-
-# Define threshold below which buffers are considered "small" and routed to
-# regular CRC code that does not interleave the CRC instructions.
-#define SMALL_SIZE 200
-
-# u32 crc32c_x86_3way(u32 crc, const u8 *buffer, size_t len);
-
-.text
-SYM_FUNC_START(crc32c_x86_3way)
-#define    crc0		  %edi
-#define    crc0_q	  %rdi
-#define    bufp		  %rsi
-#define    bufp_d	  %esi
-#define    len		  %rdx
-#define    len_dw	  %edx
-#define    n_misaligned	  %ecx /* overlaps chunk_bytes! */
-#define    n_misaligned_q %rcx
-#define    chunk_bytes	  %ecx /* overlaps n_misaligned! */
-#define    chunk_bytes_q  %rcx
-#define    crc1		  %r8
-#define    crc2		  %r9
-
-	cmp	$SMALL_SIZE, len
-	jb	.Lsmall
-
-	################################################################
-	## 1) ALIGN:
-	################################################################
-	mov	bufp_d, n_misaligned
-	neg	n_misaligned
-	and	$7, n_misaligned	# calculate the misalignment amount of
-					# the address
-	je	.Laligned		# Skip if aligned
-
-	# Process 1 <= n_misaligned <= 7 bytes individually in order to align
-	# the remaining data to an 8-byte boundary.
-.Ldo_align:
-	movq	(bufp), %rax
-	add	n_misaligned_q, bufp
-	sub	n_misaligned_q, len
-.Lalign_loop:
-	crc32b	%al, crc0		# compute crc32 of 1-byte
-	shr	$8, %rax		# get next byte
-	dec	n_misaligned
-	jne     .Lalign_loop
-.Laligned:
-
-	################################################################
-	## 2) PROCESS BLOCK:
-	################################################################
-
-	cmp	$128*24, len
-	jae     .Lfull_block
-
-.Lpartial_block:
-	# Compute floor(len / 24) to get num qwords to process from each lane.
-	imul	$2731, len_dw, %eax	# 2731 = ceil(2^16 / 24)
-	shr	$16, %eax
-	jmp	.Lcrc_3lanes
-
-.Lfull_block:
-	# Processing 128 qwords from each lane.
-	mov	$128, %eax
-
-	################################################################
-	## 3) CRC each of three lanes:
-	################################################################
-
-.Lcrc_3lanes:
-	xor	crc1,crc1
-	xor     crc2,crc2
-	mov	%eax, chunk_bytes
-	shl	$3, chunk_bytes		# num bytes to process from each lane
-	sub	$5, %eax		# 4 for 4x_loop, 1 for special last iter
-	jl	.Lcrc_3lanes_4x_done
-
-	# Unroll the loop by a factor of 4 to reduce the overhead of the loop
-	# bookkeeping instructions, which can compete with crc32q for the ALUs.
-.Lcrc_3lanes_4x_loop:
-	crc32q	(bufp), crc0_q
-	crc32q	(bufp,chunk_bytes_q), crc1
-	crc32q	(bufp,chunk_bytes_q,2), crc2
-	crc32q	8(bufp), crc0_q
-	crc32q	8(bufp,chunk_bytes_q), crc1
-	crc32q	8(bufp,chunk_bytes_q,2), crc2
-	crc32q	16(bufp), crc0_q
-	crc32q	16(bufp,chunk_bytes_q), crc1
-	crc32q	16(bufp,chunk_bytes_q,2), crc2
-	crc32q	24(bufp), crc0_q
-	crc32q	24(bufp,chunk_bytes_q), crc1
-	crc32q	24(bufp,chunk_bytes_q,2), crc2
-	add	$32, bufp
-	sub	$4, %eax
-	jge	.Lcrc_3lanes_4x_loop
-
-.Lcrc_3lanes_4x_done:
-	add	$4, %eax
-	jz	.Lcrc_3lanes_last_qword
-
-.Lcrc_3lanes_1x_loop:
-	crc32q	(bufp), crc0_q
-	crc32q	(bufp,chunk_bytes_q), crc1
-	crc32q	(bufp,chunk_bytes_q,2), crc2
-	add	$8, bufp
-	dec	%eax
-	jnz	.Lcrc_3lanes_1x_loop
-
-.Lcrc_3lanes_last_qword:
-	crc32q	(bufp), crc0_q
-	crc32q	(bufp,chunk_bytes_q), crc1
-# SKIP  crc32q	(bufp,chunk_bytes_q,2), crc2	; Don't do this one yet
-
-	################################################################
-	## 4) Combine three results:
-	################################################################
-
-	lea	(K_table-8)(%rip), %rax		# first entry is for idx 1
-	pmovzxdq (%rax,chunk_bytes_q), %xmm0	# 2 consts: K1:K2
-	lea	(chunk_bytes,chunk_bytes,2), %eax # chunk_bytes * 3
-	sub	%rax, len			# len -= chunk_bytes * 3
-
-	movq	crc0_q, %xmm1			# CRC for block 1
-	pclmulqdq $0x00, %xmm0, %xmm1		# Multiply by K2
-
-	movq    crc1, %xmm2			# CRC for block 2
-	pclmulqdq $0x10, %xmm0, %xmm2		# Multiply by K1
-
-	pxor    %xmm2,%xmm1
-	movq    %xmm1, %rax
-	xor	(bufp,chunk_bytes_q,2), %rax
-	mov	crc2, crc0_q
-	crc32	%rax, crc0_q
-	lea	8(bufp,chunk_bytes_q,2), bufp
-
-	################################################################
-	## 5) If more blocks remain, goto (2):
-	################################################################
-
-	cmp	$128*24, len
-	jae	.Lfull_block
-	cmp	$SMALL_SIZE, len
-	jae	.Lpartial_block
-
-	#######################################################################
-	## 6) Process any remainder without interleaving:
-	#######################################################################
-.Lsmall:
-	test	len_dw, len_dw
-	jz	.Ldone
-	mov	len_dw, %eax
-	shr	$3, %eax
-	jz	.Ldo_dword
-.Ldo_qwords:
-	crc32q	(bufp), crc0_q
-	add	$8, bufp
-	dec	%eax
-	jnz	.Ldo_qwords
-.Ldo_dword:
-	test	$4, len_dw
-	jz	.Ldo_word
-	crc32l	(bufp), crc0
-	add	$4, bufp
-.Ldo_word:
-	test	$2, len_dw
-	jz	.Ldo_byte
-	crc32w	(bufp), crc0
-	add	$2, bufp
-.Ldo_byte:
-	test	$1, len_dw
-	jz	.Ldone
-	crc32b	(bufp), crc0
-.Ldone:
-	mov	crc0, %eax
-        RET
-SYM_FUNC_END(crc32c_x86_3way)
-
-.section	.rodata, "a", @progbits
-	################################################################
-	## PCLMULQDQ tables
-	## Table is 128 entries x 2 words (8 bytes) each
-	################################################################
-.align 8
-K_table:
-	.long 0x493c7d27, 0x00000001
-	.long 0xba4fc28e, 0x493c7d27
-	.long 0xddc0152b, 0xf20c0dfe
-	.long 0x9e4addf8, 0xba4fc28e
-	.long 0x39d3b296, 0x3da6d0cb
-	.long 0x0715ce53, 0xddc0152b
-	.long 0x47db8317, 0x1c291d04
-	.long 0x0d3b6092, 0x9e4addf8
-	.long 0xc96cfdc0, 0x740eef02
-	.long 0x878a92a7, 0x39d3b296
-	.long 0xdaece73e, 0x083a6eec
-	.long 0xab7aff2a, 0x0715ce53
-	.long 0x2162d385, 0xc49f4f67
-	.long 0x83348832, 0x47db8317
-	.long 0x299847d5, 0x2ad91c30
-	.long 0xb9e02b86, 0x0d3b6092
-	.long 0x18b33a4e, 0x6992cea2
-	.long 0xb6dd949b, 0xc96cfdc0
-	.long 0x78d9ccb7, 0x7e908048
-	.long 0xbac2fd7b, 0x878a92a7
-	.long 0xa60ce07b, 0x1b3d8f29
-	.long 0xce7f39f4, 0xdaece73e
-	.long 0x61d82e56, 0xf1d0f55e
-	.long 0xd270f1a2, 0xab7aff2a
-	.long 0xc619809d, 0xa87ab8a8
-	.long 0x2b3cac5d, 0x2162d385
-	.long 0x65863b64, 0x8462d800
-	.long 0x1b03397f, 0x83348832
-	.long 0xebb883bd, 0x71d111a8
-	.long 0xb3e32c28, 0x299847d5
-	.long 0x064f7f26, 0xffd852c6
-	.long 0xdd7e3b0c, 0xb9e02b86
-	.long 0xf285651c, 0xdcb17aa4
-	.long 0x10746f3c, 0x18b33a4e
-	.long 0xc7a68855, 0xf37c5aee
-	.long 0x271d9844, 0xb6dd949b
-	.long 0x8e766a0c, 0x6051d5a2
-	.long 0x93a5f730, 0x78d9ccb7
-	.long 0x6cb08e5c, 0x18b0d4ff
-	.long 0x6b749fb2, 0xbac2fd7b
-	.long 0x1393e203, 0x21f3d99c
-	.long 0xcec3662e, 0xa60ce07b
-	.long 0x96c515bb, 0x8f158014
-	.long 0xe6fc4e6a, 0xce7f39f4
-	.long 0x8227bb8a, 0xa00457f7
-	.long 0xb0cd4768, 0x61d82e56
-	.long 0x39c7ff35, 0x8d6d2c43
-	.long 0xd7a4825c, 0xd270f1a2
-	.long 0x0ab3844b, 0x00ac29cf
-	.long 0x0167d312, 0xc619809d
-	.long 0xf6076544, 0xe9adf796
-	.long 0x26f6a60a, 0x2b3cac5d
-	.long 0xa741c1bf, 0x96638b34
-	.long 0x98d8d9cb, 0x65863b64
-	.long 0x49c3cc9c, 0xe0e9f351
-	.long 0x68bce87a, 0x1b03397f
-	.long 0x57a3d037, 0x9af01f2d
-	.long 0x6956fc3b, 0xebb883bd
-	.long 0x42d98888, 0x2cff42cf
-	.long 0x3771e98f, 0xb3e32c28
-	.long 0xb42ae3d9, 0x88f25a3a
-	.long 0x2178513a, 0x064f7f26
-	.long 0xe0ac139e, 0x4e36f0b0
-	.long 0x170076fa, 0xdd7e3b0c
-	.long 0x444dd413, 0xbd6f81f8
-	.long 0x6f345e45, 0xf285651c
-	.long 0x41d17b64, 0x91c9bd4b
-	.long 0xff0dba97, 0x10746f3c
-	.long 0xa2b73df1, 0x885f087b
-	.long 0xf872e54c, 0xc7a68855
-	.long 0x1e41e9fc, 0x4c144932
-	.long 0x86d8e4d2, 0x271d9844
-	.long 0x651bd98b, 0x52148f02
-	.long 0x5bb8f1bc, 0x8e766a0c
-	.long 0xa90fd27a, 0xa3c6f37a
-	.long 0xb3af077a, 0x93a5f730
-	.long 0x4984d782, 0xd7c0557f
-	.long 0xca6ef3ac, 0x6cb08e5c
-	.long 0x234e0b26, 0x63ded06a
-	.long 0xdd66cbbb, 0x6b749fb2
-	.long 0x4597456a, 0x4d56973c
-	.long 0xe9e28eb4, 0x1393e203
-	.long 0x7b3ff57a, 0x9669c9df
-	.long 0xc9c8b782, 0xcec3662e
-	.long 0x3f70cc6f, 0xe417f38a
-	.long 0x93e106a4, 0x96c515bb
-	.long 0x62ec6c6d, 0x4b9e0f71
-	.long 0xd813b325, 0xe6fc4e6a
-	.long 0x0df04680, 0xd104b8fc
-	.long 0x2342001e, 0x8227bb8a
-	.long 0x0a2a8d7e, 0x5b397730
-	.long 0x6d9a4957, 0xb0cd4768
-	.long 0xe8b6368b, 0xe78eb416
-	.long 0xd2c3ed1a, 0x39c7ff35
-	.long 0x995a5724, 0x61ff0e01
-	.long 0x9ef68d35, 0xd7a4825c
-	.long 0x0c139b31, 0x8d96551c
-	.long 0xf2271e60, 0x0ab3844b
-	.long 0x0b0bf8ca, 0x0bf80dd2
-	.long 0x2664fd8b, 0x0167d312
-	.long 0xed64812d, 0x8821abed
-	.long 0x02ee03b2, 0xf6076544
-	.long 0x8604ae0f, 0x6a45d2b2
-	.long 0x363bd6b3, 0x26f6a60a
-	.long 0x135c83fd, 0xd8d26619
-	.long 0x5fabe670, 0xa741c1bf
-	.long 0x35ec3279, 0xde87806c
-	.long 0x00bcf5f6, 0x98d8d9cb
-	.long 0x8ae00689, 0x14338754
-	.long 0x17f27698, 0x49c3cc9c
-	.long 0x58ca5f00, 0x5bd2011f
-	.long 0xaa7c7ad5, 0x68bce87a
-	.long 0xb5cfca28, 0xdd07448e
-	.long 0xded288f8, 0x57a3d037
-	.long 0x59f229bc, 0xdde8f5b9
-	.long 0x6d390dec, 0x6956fc3b
-	.long 0x37170390, 0xa3e3e02c
-	.long 0x6353c1cc, 0x42d98888
-	.long 0xc4584f5c, 0xd73c7bea
-	.long 0xf48642e9, 0x3771e98f
-	.long 0x531377e2, 0x80ff0093
-	.long 0xdd35bc8d, 0xb42ae3d9
-	.long 0xb25b29f2, 0x8fe4c34d
-	.long 0x9a5ede41, 0x2178513a
-	.long 0xa563905d, 0xdf99fc11
-	.long 0x45cddf4e, 0xe0ac139e
-	.long 0xacfa3103, 0x6c23e841
-	.long 0xa51b6135, 0x170076fa
diff --git a/lib/crc/x86/crc32c-3way.c b/lib/crc/x86/crc32c-3way.c
new file mode 100644
index 000000000000..63d3ffdac103
--- /dev/null
+++ b/lib/crc/x86/crc32c-3way.c
@@ -0,0 +1,309 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Implement fast CRC32C with PCLMULQDQ instructions. (x86_64)
+ *
+ * The white papers on CRC32C calculations with PCLMULQDQ instruction can be
+ * downloaded from:
+ * http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/crc-iscsi-polynomial-crc32-instruction-paper.pdf
+ * http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/fast-crc-computation-paper.pdf
+ *
+ * Copyright (C) 2012 Intel Corporation.
+ * Copyright 2024 Google LLC
+ *
+ * Authors:
+ *	Wajdi Feghali <wajdi.k.feghali@intel.com>
+ *	James Guilford <james.guilford@intel.com>
+ *	David Cote <david.m.cote@intel.com>
+ *	Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+
+#include "crc32c-3way.h"
+#include "crc32c-inst.h"
+
+/*
+ * Buffers shorter than this are considered "small" and are routed to regular
+ * CRC code that does not interleave the CRC instructions.
+ */
+#define SMALL_SIZE	200
+
+/* Maximum number of qwords processed from each of the three lanes at a time */
+#define MAX_LANE_QWORDS	128
+
+/* CRC one qword from each of the three lanes, which are @chunk_bytes apart. */
+static __always_inline void crc32c_3lanes_u64(u32 *crc0, u32 *crc1, u32 *crc2,
+					      const u8 *p, size_t chunk_bytes)
+{
+	*crc0 = crc32c_u64(*crc0, *(const u64 *)p);
+	*crc1 = crc32c_u64(*crc1, *(const u64 *)(p + chunk_bytes));
+	*crc2 = crc32c_u64(*crc2, *(const u64 *)(p + 2 * chunk_bytes));
+}
+
+/*
+ * PCLMULQDQ tables.
+ *
+ * Entry (n - 1) holds the two folding constants for the case where each of the
+ * three lanes consists of n qwords, with n in [1, MAX_LANE_QWORDS].
+ */
+static const u32 k_table[MAX_LANE_QWORDS][2] = {
+	{ 0x493c7d27, 0x00000001 },
+	{ 0xba4fc28e, 0x493c7d27 },
+	{ 0xddc0152b, 0xf20c0dfe },
+	{ 0x9e4addf8, 0xba4fc28e },
+	{ 0x39d3b296, 0x3da6d0cb },
+	{ 0x0715ce53, 0xddc0152b },
+	{ 0x47db8317, 0x1c291d04 },
+	{ 0x0d3b6092, 0x9e4addf8 },
+	{ 0xc96cfdc0, 0x740eef02 },
+	{ 0x878a92a7, 0x39d3b296 },
+	{ 0xdaece73e, 0x083a6eec },
+	{ 0xab7aff2a, 0x0715ce53 },
+	{ 0x2162d385, 0xc49f4f67 },
+	{ 0x83348832, 0x47db8317 },
+	{ 0x299847d5, 0x2ad91c30 },
+	{ 0xb9e02b86, 0x0d3b6092 },
+	{ 0x18b33a4e, 0x6992cea2 },
+	{ 0xb6dd949b, 0xc96cfdc0 },
+	{ 0x78d9ccb7, 0x7e908048 },
+	{ 0xbac2fd7b, 0x878a92a7 },
+	{ 0xa60ce07b, 0x1b3d8f29 },
+	{ 0xce7f39f4, 0xdaece73e },
+	{ 0x61d82e56, 0xf1d0f55e },
+	{ 0xd270f1a2, 0xab7aff2a },
+	{ 0xc619809d, 0xa87ab8a8 },
+	{ 0x2b3cac5d, 0x2162d385 },
+	{ 0x65863b64, 0x8462d800 },
+	{ 0x1b03397f, 0x83348832 },
+	{ 0xebb883bd, 0x71d111a8 },
+	{ 0xb3e32c28, 0x299847d5 },
+	{ 0x064f7f26, 0xffd852c6 },
+	{ 0xdd7e3b0c, 0xb9e02b86 },
+	{ 0xf285651c, 0xdcb17aa4 },
+	{ 0x10746f3c, 0x18b33a4e },
+	{ 0xc7a68855, 0xf37c5aee },
+	{ 0x271d9844, 0xb6dd949b },
+	{ 0x8e766a0c, 0x6051d5a2 },
+	{ 0x93a5f730, 0x78d9ccb7 },
+	{ 0x6cb08e5c, 0x18b0d4ff },
+	{ 0x6b749fb2, 0xbac2fd7b },
+	{ 0x1393e203, 0x21f3d99c },
+	{ 0xcec3662e, 0xa60ce07b },
+	{ 0x96c515bb, 0x8f158014 },
+	{ 0xe6fc4e6a, 0xce7f39f4 },
+	{ 0x8227bb8a, 0xa00457f7 },
+	{ 0xb0cd4768, 0x61d82e56 },
+	{ 0x39c7ff35, 0x8d6d2c43 },
+	{ 0xd7a4825c, 0xd270f1a2 },
+	{ 0x0ab3844b, 0x00ac29cf },
+	{ 0x0167d312, 0xc619809d },
+	{ 0xf6076544, 0xe9adf796 },
+	{ 0x26f6a60a, 0x2b3cac5d },
+	{ 0xa741c1bf, 0x96638b34 },
+	{ 0x98d8d9cb, 0x65863b64 },
+	{ 0x49c3cc9c, 0xe0e9f351 },
+	{ 0x68bce87a, 0x1b03397f },
+	{ 0x57a3d037, 0x9af01f2d },
+	{ 0x6956fc3b, 0xebb883bd },
+	{ 0x42d98888, 0x2cff42cf },
+	{ 0x3771e98f, 0xb3e32c28 },
+	{ 0xb42ae3d9, 0x88f25a3a },
+	{ 0x2178513a, 0x064f7f26 },
+	{ 0xe0ac139e, 0x4e36f0b0 },
+	{ 0x170076fa, 0xdd7e3b0c },
+	{ 0x444dd413, 0xbd6f81f8 },
+	{ 0x6f345e45, 0xf285651c },
+	{ 0x41d17b64, 0x91c9bd4b },
+	{ 0xff0dba97, 0x10746f3c },
+	{ 0xa2b73df1, 0x885f087b },
+	{ 0xf872e54c, 0xc7a68855 },
+	{ 0x1e41e9fc, 0x4c144932 },
+	{ 0x86d8e4d2, 0x271d9844 },
+	{ 0x651bd98b, 0x52148f02 },
+	{ 0x5bb8f1bc, 0x8e766a0c },
+	{ 0xa90fd27a, 0xa3c6f37a },
+	{ 0xb3af077a, 0x93a5f730 },
+	{ 0x4984d782, 0xd7c0557f },
+	{ 0xca6ef3ac, 0x6cb08e5c },
+	{ 0x234e0b26, 0x63ded06a },
+	{ 0xdd66cbbb, 0x6b749fb2 },
+	{ 0x4597456a, 0x4d56973c },
+	{ 0xe9e28eb4, 0x1393e203 },
+	{ 0x7b3ff57a, 0x9669c9df },
+	{ 0xc9c8b782, 0xcec3662e },
+	{ 0x3f70cc6f, 0xe417f38a },
+	{ 0x93e106a4, 0x96c515bb },
+	{ 0x62ec6c6d, 0x4b9e0f71 },
+	{ 0xd813b325, 0xe6fc4e6a },
+	{ 0x0df04680, 0xd104b8fc },
+	{ 0x2342001e, 0x8227bb8a },
+	{ 0x0a2a8d7e, 0x5b397730 },
+	{ 0x6d9a4957, 0xb0cd4768 },
+	{ 0xe8b6368b, 0xe78eb416 },
+	{ 0xd2c3ed1a, 0x39c7ff35 },
+	{ 0x995a5724, 0x61ff0e01 },
+	{ 0x9ef68d35, 0xd7a4825c },
+	{ 0x0c139b31, 0x8d96551c },
+	{ 0xf2271e60, 0x0ab3844b },
+	{ 0x0b0bf8ca, 0x0bf80dd2 },
+	{ 0x2664fd8b, 0x0167d312 },
+	{ 0xed64812d, 0x8821abed },
+	{ 0x02ee03b2, 0xf6076544 },
+	{ 0x8604ae0f, 0x6a45d2b2 },
+	{ 0x363bd6b3, 0x26f6a60a },
+	{ 0x135c83fd, 0xd8d26619 },
+	{ 0x5fabe670, 0xa741c1bf },
+	{ 0x35ec3279, 0xde87806c },
+	{ 0x00bcf5f6, 0x98d8d9cb },
+	{ 0x8ae00689, 0x14338754 },
+	{ 0x17f27698, 0x49c3cc9c },
+	{ 0x58ca5f00, 0x5bd2011f },
+	{ 0xaa7c7ad5, 0x68bce87a },
+	{ 0xb5cfca28, 0xdd07448e },
+	{ 0xded288f8, 0x57a3d037 },
+	{ 0x59f229bc, 0xdde8f5b9 },
+	{ 0x6d390dec, 0x6956fc3b },
+	{ 0x37170390, 0xa3e3e02c },
+	{ 0x6353c1cc, 0x42d98888 },
+	{ 0xc4584f5c, 0xd73c7bea },
+	{ 0xf48642e9, 0x3771e98f },
+	{ 0x531377e2, 0x80ff0093 },
+	{ 0xdd35bc8d, 0xb42ae3d9 },
+	{ 0xb25b29f2, 0x8fe4c34d },
+	{ 0x9a5ede41, 0x2178513a },
+	{ 0xa563905d, 0xdf99fc11 },
+	{ 0x45cddf4e, 0xe0ac139e },
+	{ 0xacfa3103, 0x6c23e841 },
+	{ 0xa51b6135, 0x170076fa },
+};
+
+/*
+ * Fold the CRCs of lane 0 and lane 1 into a single 64-bit value, which is to be
+ * XOR'ed into the last qword of lane 2 before being CRC'ed.
+ */
+static __always_inline u64 crc32c_fold_lanes(u32 crc0, u32 crc1, const u32 *k)
+{
+	u64 res;
+
+	asm("pmovzxdq	%[k], %%xmm0\n\t"	/* 2 consts: K2:K1 */
+	    "movq	%[crc0], %%xmm1\n\t"	/* CRC for lane 0 */
+	    "pclmulqdq	$0x00, %%xmm0, %%xmm1\n\t" /* Multiply by K2 */
+	    "movq	%[crc1], %%xmm2\n\t"	/* CRC for lane 1 */
+	    "pclmulqdq	$0x10, %%xmm0, %%xmm2\n\t" /* Multiply by K1 */
+	    "pxor	%%xmm2, %%xmm1\n\t"
+	    "movq	%%xmm1, %[res]"
+	    : [res] "=r" (res)
+	    : [crc0] "r" ((u64)crc0), [crc1] "r" ((u64)crc1),
+	      [k] "m" (*(const u64 *)k)
+	    : "xmm0", "xmm1", "xmm2");
+	return res;
+}
+
+/* Compute the CRC32C of @p using three interleaved streams. */
+u32 crc32c_x86_3way(u32 crc0, const u8 *p, size_t len)
+{
+	size_t n_misaligned;
+
+	if (len < SMALL_SIZE)
+		goto small;
+
+	/*
+	 * 1) ALIGN:
+	 * Process 0 <= n_misaligned <= 7 bytes individually in order to align
+	 * the remaining data to an 8-byte boundary.
+	 */
+	n_misaligned = -(unsigned long)p & 7;
+	len -= n_misaligned;
+	for (; n_misaligned; n_misaligned--)
+		crc0 = crc32c_u8(crc0, *p++);
+
+	do {
+		/*
+		 * 2) PROCESS BLOCK:
+		 * Number of qwords to process from each lane.  For a partial
+		 * block this is floor(len / 24).
+		 */
+		size_t n = len >= MAX_LANE_QWORDS * 24 ?
+			   MAX_LANE_QWORDS : len / 24;
+		size_t chunk_bytes = n * 8;
+		size_t rem = n - 1;
+		u32 crc1 = 0, crc2 = 0;
+		u64 folded;
+
+		/*
+		 * 3) CRC each of three lanes:
+		 * Unroll the loop by a factor of 4 to reduce the overhead of the
+		 * loop bookkeeping instructions, which can compete with crc32q
+		 * for the ALUs.
+		 */
+		for (; rem >= 4; rem -= 4, p += 32) {
+			crc32c_3lanes_u64(&crc0, &crc1, &crc2, p, chunk_bytes);
+			crc32c_3lanes_u64(&crc0, &crc1, &crc2, p + 8, chunk_bytes);
+			crc32c_3lanes_u64(&crc0, &crc1, &crc2, p + 16, chunk_bytes);
+			crc32c_3lanes_u64(&crc0, &crc1, &crc2, p + 24, chunk_bytes);
+		}
+		for (; rem; rem--, p += 8)
+			crc32c_3lanes_u64(&crc0, &crc1, &crc2, p, chunk_bytes);
+
+		/*
+		 * The last qword of lanes 0 and 1.  The last qword of lane 2 is
+		 * handled below, merged with the fold result.
+		 */
+		crc0 = crc32c_u64(crc0, *(const u64 *)p);
+		crc1 = crc32c_u64(crc1, *(const u64 *)(p + chunk_bytes));
+
+		/* 4) Combine three results: */
+		folded = crc32c_fold_lanes(crc0, crc1, k_table[n - 1]);
+		crc0 = crc32c_u64(crc2, folded ^
+				  *(const u64 *)(p + 2 * chunk_bytes));
+		p += 8 + 2 * chunk_bytes;
+		len -= 3 * chunk_bytes;
+
+		/* 5) If more blocks remain, goto (2): */
+	} while (len >= SMALL_SIZE);
+
+small:
+	/* 6) Process any remainder without interleaving: */
+	for (; len >= 8; len -= 8, p += 8)
+		crc0 = crc32c_u64(crc0, *(const u64 *)p);
+	if (len & 4) {
+		crc0 = crc32c_u32(crc0, *(const u32 *)p);
+		p += 4;
+	}
+	if (len & 2) {
+		crc0 = crc32c_u16(crc0, *(const u16 *)p);
+		p += 2;
+	}
+	if (len & 1)
+		crc0 = crc32c_u8(crc0, *p);
+	return crc0;
+}
diff --git a/lib/crc/x86/crc32c-3way.h b/lib/crc/x86/crc32c-3way.h
new file mode 100644
index 000000000000..717729cd28a9
--- /dev/null
+++ b/lib/crc/x86/crc32c-3way.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _CRC32C_3WAY_H
+#define _CRC32C_3WAY_H
+
+#include <linux/types.h>
+
+u32 crc32c_x86_3way(u32 crc, const u8 *p, size_t len);
+
+#endif /* _CRC32C_3WAY_H */
diff --git a/lib/crc/x86/crc32c-inst.h b/lib/crc/x86/crc32c-inst.h
new file mode 100644
index 000000000000..17c637846746
--- /dev/null
+++ b/lib/crc/x86/crc32c-inst.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Inline wrappers around the x86 CRC32C instructions (SSE4.2)
+ */
+#ifndef _CRC32C_INST_H
+#define _CRC32C_INST_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+
+static __always_inline u32 crc32c_u8(u32 crc, u8 v)
+{
+	asm("crc32b %1, %0" : "+r" (crc) : ASM_INPUT_RM (v));
+	return crc;
+}
+
+static __always_inline u32 crc32c_u16(u32 crc, u16 v)
+{
+	asm("crc32w %1, %0" : "+r" (crc) : ASM_INPUT_RM (v));
+	return crc;
+}
+
+static __always_inline u32 crc32c_u32(u32 crc, u32 v)
+{
+	asm("crc32l %1, %0" : "+r" (crc) : ASM_INPUT_RM (v));
+	return crc;
+}
+
+#ifdef CONFIG_X86_64
+/* The upper 32 bits of the destination are zeroed by crc32q. */
+static __always_inline u32 crc32c_u64(u32 crc, u64 v)
+{
+	asm("crc32q %1, %q0" : "+r" (crc) : ASM_INPUT_RM (v));
+	return crc;
+}
+
+#define crc32c_ulong	crc32c_u64
+#else
+#define crc32c_ulong	crc32c_u32
+#endif
+
+#endif /* _CRC32C_INST_H */
-- 
2.56.0

