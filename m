Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795137578;
	b=UAxBHHQgZHGcrUkCEvlbY+N4/rUSeXeP2xV1+dUA1tuzqXYRwWlrWPd4Giy0UcAb+r1k
	 skvHjmiyFC8gzAb28JVm/jW1sD/G73e6h8zgmwfqV79m2C0r3aDfk6xb9izlWee28hvgp
	 Fwa6+HpX3228RNsC/XENutVmdCK05iMv/HqkPIrfKG1nhnJ5E+NQA4pBT2REImHhkpEdF
	 vpncaUAomtvN0N4jvGbPCElUdN0K4vzJKkTRYG6gH6Ze3icyx0es/37qkHJ+g+Hp0e3tM
	 1tNxp+XP6/orQuwO4U5OTj5JhP8moa4IEca0JjDio3fStOeR6e/M8yA/danPiA8nMGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795137578;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=uQHd/F+z0NK3C/yVLtkiT17zNWNI7RAZ8+TbMOnaqOs=;
	b=C9BDItTG1oHev4m+2NE977DKedvTSfT1i4KfR8JPDOnyGXQ/ap+6VgiQka46nkX+yLRh
	 EwLtrRXp6bbnP/HGYLpXxO0AQnQXc/rrayvsV7363UIoq5O0hLmfhsTi1Cg73Z20uxTDz
	 IZMBYp6K6gZJ/Of6uxuwbXkGceDkZjcbc4ZvDZwqEvFzXrZ0elBLAx+0v+/xSd2/vJZn/
	 +vNpbR+GvUZTzKzzJFa5NwMcTb0TofZhjMnIBUegFXOylPuLl1n5YbAoOJMD4PVrpdfTS
	 lwtKSNYh7igG4gRkWAi2JVLss3zR5dJ9681GfRn+2s3U3i2LHsFImAXTPBWTYrrEP3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kOMhNdfp;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kOMhNdfp;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52877606A325;
	Fri, 20 Nov 2026 01:19:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52877606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kOMhNdfp;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kOMhNdfp
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 77D311F7BB;
	Fri, 20 Nov 2026 01:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uQHd/F+z0NK3C/yVLtkiT17zNWNI7RAZ8+TbMOnaqOs=;
	b=kOMhNdfp/4ipaY3euiht+AOWx+pptsdp8cclpcCFZB0lFNojvPetm6tS1cjVMqKXY4VwEY
	XBLmE5swhbOss6RS7VsHx5MRaxdlOzFhaZyNh0+fkOjqctGzHCSeV2gMuid/JWabZNkZUM
	XJv4SmbZsOahAOEf9Wq1ERZ+ZZ8tCkc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uQHd/F+z0NK3C/yVLtkiT17zNWNI7RAZ8+TbMOnaqOs=;
	b=kOMhNdfp/4ipaY3euiht+AOWx+pptsdp8cclpcCFZB0lFNojvPetm6tS1cjVMqKXY4VwEY
	XBLmE5swhbOss6RS7VsHx5MRaxdlOzFhaZyNh0+fkOjqctGzHCSeV2gMuid/JWabZNkZUM
	XJv4SmbZsOahAOEf9Wq1ERZ+ZZ8tCkc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 423E41342D;
	Fri, 20 Nov 2026 01:19:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f6GRNh6g/2r1FAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>); Fri, 20 Nov 2026 01:19:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org,
	ardb@kernel.org
Subject: [PATCH RFC v2 2/6] lib/crc: x86: Convert crc32c_x86_3way() from assembly to C intrinsics
Date: Fri, 20 Nov 2026 11:49:00 +1030
Message-ID: <b6ae1abf9aeccd5fc1fdfd0c3bd2be25a8ac34a0.1795137348.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,intel.com:email,intel.com:url];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Rewrite crc32c-3way.S in C using the new asm/x86-intrinsics.h.  The
algorithm and the constant table are unchanged: three lanes of up to 128
qwords are CRCed with crc32q, then combined with PCLMULQDQ.

Build changes:
- Enable SSE4.2 and PCLMULQDQ for the function only, with the target
  attribute, instead of per-object ISA flags.
- Add -isystem for the compiler's include directory, like arm64 does.
  It is in x86-intrin-cflags, for the later conversions to share.
- Use the path-qualified CFLAGS_x86/crc32c-3way.o, as it is in a subdir.
- Drop asmlinkage from the prototype in crc32.h, as it is C now.
- Use #pragma to keep the 4x unrolled loop of 3 crc32_u64() chains

Behavior changes:
- Always handle the unaligned leading part first
  Previously it's only for len >= SMALL_SIZE, which means if len <
  SMALL_SIZE, we can skip the unaligned handling.
  This is not a big deal before, as later instructions can handle
  unaligned address, but still doesn't looks good to me.

  Short unaligned input will pay up to 7 crc32_u8(), but should be rare.

The license header and authors are kept from the assembly file, and the
SPDX tag now matches its dual license.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 lib/crc/Makefile          |   5 +
 lib/crc/x86/crc32.h       |   2 +-
 lib/crc/x86/crc32c-3way.S | 360 --------------------------------------
 lib/crc/x86/crc32c-3way.c | 264 ++++++++++++++++++++++++++++
 4 files changed, 270 insertions(+), 361 deletions(-)
 delete mode 100644 lib/crc/x86/crc32c-3way.S
 create mode 100644 lib/crc/x86/crc32c-3way.c

diff --git a/lib/crc/Makefile b/lib/crc/Makefile
index 386e9c175263..cd7ff35193ad 100644
--- a/lib/crc/Makefile
+++ b/lib/crc/Makefile
@@ -9,6 +9,10 @@ obj-$(CONFIG_CRC16) += crc16.o
 obj-$(CONFIG_CRC_CCITT) += crc-ccitt.o
 obj-$(CONFIG_CRC_ITU_T) += crc-itu-t.o
 
+ifdef CONFIG_X86
+x86-intrin-cflags := -isystem $(shell $(CC) -print-file-name=include)
+endif
+
 obj-$(CONFIG_CRC_T10DIF) += crc-t10dif.o
 crc-t10dif-y := crc-t10dif-main.o
 ifeq ($(CONFIG_CRC_T10DIF_ARCH),y)
@@ -32,6 +36,7 @@ crc32-$(CONFIG_S390) += s390/crc32le-vx.o s390/crc32be-vx.o
 crc32-$(CONFIG_SPARC) += sparc/crc32c_asm.o
 crc32-$(CONFIG_X86) += x86/crc32-pclmul.o
 crc32-$(CONFIG_X86_64) += x86/crc32c-3way.o
+CFLAGS_x86/crc32c-3way.o += $(x86-intrin-cflags)
 endif
 
 obj-$(CONFIG_CRC64) += crc64.o
diff --git a/lib/crc/x86/crc32.h b/lib/crc/x86/crc32.h
index 19a5e3c6c73b..2b5dd0018576 100644
--- a/lib/crc/x86/crc32.h
+++ b/lib/crc/x86/crc32.h
@@ -34,7 +34,7 @@ static inline u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
  */
 #define CRC32C_PCLMUL_BREAKEVEN	512
 
-asmlinkage u32 crc32c_x86_3way(u32 crc, const u8 *buffer, size_t len);
+u32 crc32c_x86_3way(u32 crc, const u8 *buffer, size_t len);
 
 static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 {
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
index 000000000000..9ed53b97b395
--- /dev/null
+++ b/lib/crc/x86/crc32c-3way.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0-only OR Linux-OpenIB
+/*
+ * CRC32C using the x86 CRC32 and PCLMULQDQ instructions, via C intrinsics.
+ *
+ * This is a C version of the former crc32c-3way.S.  The data is split into
+ * three lanes, which are CRCed independently with crc32q to keep the CPU's
+ * CRC32 unit busy.  The three results are then combined using PCLMULQDQ.
+ *
+ * The algorithm is described in:
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
+#include <linux/align.h>
+#include <linux/minmax.h>
+#include <linux/types.h>
+#include <asm/x86-intrinsics.h>
+
+__attribute__((target("sse4.2,pclmul")))
+u32 crc32c_x86_3way(u32 crc, const u8 *p, size_t len);
+
+/*
+ * Buffers shorter than this are considered "small" and are processed with a
+ * single stream, as combining the lanes would not pay off.
+ */
+#define SMALL_SIZE		200
+/* The block loop below needs at least 2 qwords per lane. */
+static_assert(SMALL_SIZE / 24 >= 2);
+
+/* The maximum number of qwords processed from each lane per block. */
+#define MAX_LANE_QWORDS		128
+
+/*
+ * Pairs of constants used to combine the lanes, indexed by (lane qwords - 1).
+ * The first constant is multiplied into the first lane's CRC, the second one
+ * into the second lane's CRC.  Same values as the former crc32c-3way.S.
+ */
+static const u32 K_table[MAX_LANE_QWORDS][2] = {
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
+__attribute__((target("sse4.2,pclmul")))
+u32 crc32c_x86_3way(u32 crc, const u8 *p, size_t len)
+{
+	u64 crc0 = crc;
+	/* Align the pointer to 8 bytes, so all the following loads are aligned. */
+	size_t n_misaligned = min((size_t)(PTR_ALIGN(p, 8) - p), len);
+
+	len -= n_misaligned;
+	for (; n_misaligned; n_misaligned--)
+		crc0 = _mm_crc32_u8(crc0, *p++);
+
+	while (len >= SMALL_SIZE) {
+		/* Number of qwords processed from each lane. */
+		const size_t n = min(len / 24, MAX_LANE_QWORDS);
+		const size_t chunk_bytes = n * 8;
+		const u64 *p0 = (const u64 *)p;
+		const u64 *p1 = (const u64 *)(p + chunk_bytes);
+		const u64 *p2 = (const u64 *)(p + chunk_bytes * 2);
+		u64 crc1 = 0, crc2 = 0;
+		__m128i k, x0, x1;
+		size_t i;
+
+#pragma GCC unroll 4
+		for (i = 0; i < n - 1; i++) {
+			crc0 = _mm_crc32_u64(crc0, p0[i]);
+			crc1 = _mm_crc32_u64(crc1, p1[i]);
+			crc2 = _mm_crc32_u64(crc2, p2[i]);
+		}
+		/* The last qword of the third lane is folded in below. */
+		crc0 = _mm_crc32_u64(crc0, p0[i]);
+		crc1 = _mm_crc32_u64(crc1, p1[i]);
+
+		/* Combine the three results. */
+		k = _mm_cvtepu32_epi64(_mm_loadl_epi64((const __m128i *)K_table[n - 1]));
+		x0 = _mm_clmulepi64_si128(_mm_cvtsi64_si128(crc0), k, 0x00);
+		x1 = _mm_clmulepi64_si128(_mm_cvtsi64_si128(crc1), k, 0x10);
+		crc0 = _mm_crc32_u64(crc2,
+				     _mm_cvtsi128_si64(_mm_xor_si128(x0, x1)) ^ p2[i]);
+
+		p += chunk_bytes * 3;
+		len -= chunk_bytes * 3;
+	}
+
+	/* Process the remainder without interleaving. */
+	for (; len >= 8; len -= 8, p += 8)
+		crc0 = _mm_crc32_u64(crc0, *(const u64 *)p);
+	if (len & 4) {
+		crc0 = _mm_crc32_u32(crc0, *(const u32 *)p);
+		p += 4;
+	}
+	if (len & 2) {
+		crc0 = _mm_crc32_u16(crc0, *(const u16 *)p);
+		p += 2;
+	}
+	if (len & 1)
+		crc0 = _mm_crc32_u8(crc0, *p);
+
+	return crc0;
+}
-- 
2.56.0

