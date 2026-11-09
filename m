Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794197429;
	b=5E392IHwX1KHE1UWWqC3bFjMRNOTUXt+F9NfRAetJT/GPb66r3YRvZvGC3M/qCVAxerj
	 KLNfZo1ji4M3jFQKowbgfiKnjssb/XxJKOR0F/sLgnmLTzEiO/7rg5L4UjCmJfcsUzmEU
	 led9bE5yt+xb5ADioUqlvPAWAnDyUh906K16RPfUNtKOlmaQiA6ekS1zXXrbFS6GGrv8o
	 RQr0mYNM6Y54AzVV5kpJBWcVX+lvLp4LfEEdj7NDsKs4NRLI4GNa9hgdHqpjyu0XzpSvw
	 hEioDryuD23wlcvJzTlXGI1lfsfEgEBw4E2ltrUIOaw8bbn/hPq38zYvP5bSbHwCjHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794197429;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=mhcm8l3RdQaXnuT+fdUifBxtu71HC5ZbczdBTXwBgck=;
	b=vqQLMRowjf45UwqgtIUid0r7d2eKcmmqfrKn2r6mMj9G5eueCx94KEjRN1Jr6PeHmgWT
	 OZX8C+55uArejYMZn5UBml0pC0rQdP4e+PoXhkx7efWFI7tNWJ71BTVZbSFQo9EUiFA2O
	 W2XW+tWZ2HFpFR6TQMCGbISWHPPrQOx6q/NIj1i+/0yDIo5/PBe6yKCEa1WfPnE8pCTcv
	 bzIhbuaPQEDYzrCe3hPOmW6j4QGOBeZ/MvYd0raxi+y+X92DbLlNuRjgvcKwnDjes1XT+
	 tGYyR5GpgTkciF01Zp2ipZJJ4OV92wG4dle3by33CUgFpC44mnZyvAgGAr7D7uB0Ttg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=oy3XvcPh;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="Qrz/KVLI";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E896606A31C
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E896606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=oy3XvcPh;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Qrz/KVLI
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 58EAC22156
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhcm8l3RdQaXnuT+fdUifBxtu71HC5ZbczdBTXwBgck=;
	b=oy3XvcPhX7AUexz/dV2o/BreOZmLn6fZUW8M4KmfJUSSoz5hHKzbVkjMbTBDtPYO7+f9ag
	Jc4v04lEvLhcbE1n78XNcDq+LGRRNLgLZJaUlkWdTc6FI5wnkoZ8o0nbX8C9z+C+rUvbXT
	WBA6GSqA2/meWDLrvifuSd4B3S8w8Bw=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="Qrz/KVLI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhcm8l3RdQaXnuT+fdUifBxtu71HC5ZbczdBTXwBgck=;
	b=Qrz/KVLIG3e4EGdz0nT5u8HROVyKIv15RrelB/C7/vfzsTCAfJc7qSCwTS4CeH9jLoLUUn
	d5/NsTnU25G8ISJb2k0LYxG+XLQ8tKz/nAXyiR7YgH0BUCX6PrVF/30hCY3Q31jdTd83eZ
	wYdDIxDUGu9B8l3eeW3syvmakvyn3+k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E055613319
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AKhEN6tH8WrIZAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 04:10:23 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/7] btrfs-progs: crypto/crc32c: port crc32c-pcl optimization to C
Date: Mon,  9 Nov 2026 14:39:56 +1030
Message-ID: <d2e7c1e242aa07869660461a1913ed7e771db49e.1794196688.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794196688.git.wqu@suse.com>
References: <cover.1794196688.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 58EAC22156
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,intel.com:email,intel.com:url];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.51

This is inspired by Google's CRC32C library which has all the hardware
acceleration, but without any ASM code.

The idea is to use compiler wrapped commands instead of the hand written
ASM code.

The performance is at the same level as the old code:

The hardware is Ryzen 9 HX 370, on a single CPU core, unit is GiB/s.

   Size    |  Old (asm)  |   New (C)
-----------+-------------+-------------
 64 B      | 4.76–4.80   | 4.80–4.82
 256 B     | 8.76–8.88   | 8.82–8.87
 1 KiB     | 12.26–12.41 | 12.47–12.51
 4 KiB     | 13.35–13.49 | 13.48
 16 KiB    | 13.69–13.78 | 13.66–13.79
 64 KiB    | 13.73–13.83 | 13.75–13.83
 1 MiB     | 13.62–13.72 | 13.61–13.63

We should have a better hash-vectest to cover larger block sizes, but
that will be added later by the newer ARMv8 CRC optimization.

Asssited-by: LLM (code porting, testing)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Makefile                         |  14 --
 crypto/crc32c-pcl-intel-asm_64.S | 370 -------------------------------
 crypto/crc32c.c                  | 262 +++++++++++++++++++++-
 3 files changed, 258 insertions(+), 388 deletions(-)
 delete mode 100644 crypto/crc32c-pcl-intel-asm_64.S

diff --git a/Makefile b/Makefile
index 78c23ad3c694..e5a5534b4fb7 100644
--- a/Makefile
+++ b/Makefile
@@ -107,8 +107,6 @@ ENABLE_WARNING_FLAGS := $(call cc-option, -Wimplicit-fallthrough) \
 			$(call cc-option, -Wmissing-prototypes) \
 			-Wshadow
 
-ASFLAGS =
-
 # Common build flags
 CFLAGS = $(SUBST_CFLAGS) \
 	 -std=gnu11 \
@@ -413,11 +411,6 @@ CRYPTO_OBJECTS = crypto/sha224-256.o crypto/blake2b-ref.o crypto/blake2b-sse2.o
 CRYPTO_CFLAGS = -DCRYPTOPROVIDER_BUILTIN=1
 endif
 
-ifeq ($(TARGET_CPU),x86_64)
-CRYPTO_OBJECTS += crypto/crc32c-pcl-intel-asm_64.o
-ASFLAGS += -fPIC
-endif
-
 CHECKER_FLAGS += $(btrfs_convert_cflags)
 
 # collect values of the variables above
@@ -478,13 +471,6 @@ else
 	check_echo = true
 endif
 
-.S.o:
-	@echo "  AS       $@"
-	$(Q)$(CC) $(CFLAGS) $(ASFLAGS) -c $< -o $@
-
-%.static.o: %.S
-	@echo "  AS       $@"
-	$(Q)$(CC) $(CFLAGS) $(ASFLAGS) -c $< -o $@
 #
 # Pick from per-file variables, btrfs_*_cflags
 #
diff --git a/crypto/crc32c-pcl-intel-asm_64.S b/crypto/crc32c-pcl-intel-asm_64.S
deleted file mode 100644
index f87e62bdf345..000000000000
--- a/crypto/crc32c-pcl-intel-asm_64.S
+++ /dev/null
@@ -1,370 +0,0 @@
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
-##include "linkage.h"
-
-#define ENDBR
-
-## ISCSI CRC 32 Implementation with crc32 and pclmulqdq Instruction
-
-# Define threshold below which buffers are considered "small" and routed to
-# regular CRC code that does not interleave the CRC instructions.
-#define SMALL_SIZE 200
-
-# unsigned int crc_pcl(const u8 *buffer, unsigned int len, unsigned int crc_init);
-
-.text
-###SYM_FUNC_START(crc_pcl)
-.globl crc_pcl
-crc_pcl:
-###SYM_FUNC_START(crc_pcl)
-#define    bufp		  %rdi
-#define    bufp_d	  %edi
-#define    len		  %esi
-#define    crc_init	  %edx
-#define    crc_init_q	  %rdx
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
-	sub	n_misaligned, len
-.Lalign_loop:
-	crc32b	%al, crc_init		# compute crc32 of 1-byte
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
-	imul	$2731, len, %eax	# 2731 = ceil(2^16 / 24)
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
-	crc32q	(bufp), crc_init_q
-	crc32q	(bufp,chunk_bytes_q), crc1
-	crc32q	(bufp,chunk_bytes_q,2), crc2
-	crc32q	8(bufp), crc_init_q
-	crc32q	8(bufp,chunk_bytes_q), crc1
-	crc32q	8(bufp,chunk_bytes_q,2), crc2
-	crc32q	16(bufp), crc_init_q
-	crc32q	16(bufp,chunk_bytes_q), crc1
-	crc32q	16(bufp,chunk_bytes_q,2), crc2
-	crc32q	24(bufp), crc_init_q
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
-	crc32q	(bufp), crc_init_q
-	crc32q	(bufp,chunk_bytes_q), crc1
-	crc32q	(bufp,chunk_bytes_q,2), crc2
-	add	$8, bufp
-	dec	%eax
-	jnz	.Lcrc_3lanes_1x_loop
-
-.Lcrc_3lanes_last_qword:
-	crc32q	(bufp), crc_init_q
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
-	sub	%eax, len			# len -= chunk_bytes * 3
-
-	movq	crc_init_q, %xmm1		# CRC for block 1
-	pclmulqdq $0x00, %xmm0, %xmm1		# Multiply by K2
-
-	movq    crc1, %xmm2			# CRC for block 2
-	pclmulqdq $0x10, %xmm0, %xmm2		# Multiply by K1
-
-	pxor    %xmm2,%xmm1
-	movq    %xmm1, %rax
-	xor	(bufp,chunk_bytes_q,2), %rax
-	mov	crc2, crc_init_q
-	crc32	%rax, crc_init_q
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
-	test	len, len
-	jz	.Ldone
-	mov	len, %eax
-	shr	$3, %eax
-	jz	.Ldo_dword
-.Ldo_qwords:
-	crc32q	(bufp), crc_init_q
-	add	$8, bufp
-	dec	%eax
-	jnz	.Ldo_qwords
-.Ldo_dword:
-	test	$4, len
-	jz	.Ldo_word
-	crc32l	(bufp), crc_init
-	add	$4, bufp
-.Ldo_word:
-	test	$2, len
-	jz	.Ldo_byte
-	crc32w	(bufp), crc_init
-	add	$2, bufp
-.Ldo_byte:
-	test	$1, len
-	jz	.Ldone
-	crc32b	(bufp), crc_init
-.Ldone:
-	mov	crc_init, %eax
-        RET
-###SYM_FUNC_END(crc_pcl)
-.size crc_pcl, .-crc_pcl
-###SYM_FUNC_END(crc_pcl)
-
-.data
-	################################################################
-	## PCLMULQDQ tables
-	## Table is 128 entries x 2 words (8 bytes) each
-	################################################################
-.section	.rodata, "a", @progbits
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
-
-## Warning
-.section .note.GNU-stack,"",@progbits
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 9a3c9fc14eab..daf232c44e4d 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -10,6 +10,7 @@
 
 #include <inttypes.h>
 #include <stdio.h>
+#include <string.h>
 #include "crypto/crc32c.h"
 #include "common/cpu-utils.h"
 
@@ -19,10 +20,262 @@ static uint32_t (*crc32c_impl)(uint32_t crc, unsigned char const *data, uint32_t
 #ifdef __x86_64__
 
 #include <nmmintrin.h>
+#include <wmmintrin.h>
 
-/* asmlinkage */ unsigned int crc_pcl(const unsigned char *buffer, unsigned int len, unsigned int crc_init);
-static unsigned int crc32c_pcl(uint32_t crc, unsigned char const *data, uint32_t len) {
-	return crc_pcl(data, len, crc);
+/*
+ * Fast CRC32C with PCLMULQDQ, three interleaved crc32 lanes combined with
+ * carry-less multiplication. Derived from the Intel implementation
+ * (crc32c-pcl-intel-asm_64.S in the kernel), available under GPLv2 or the
+ * OpenIB.org BSD license.
+ *
+ * Copyright (C) 2012 Intel Corporation.
+ * Copyright 2024 Google LLC
+ *
+ * Authors:
+ *	Wajdi Feghali <wajdi.k.feghali@intel.com>
+ *	James Guilford <james.guilford@intel.com>
+ *	David Cote <david.m.cote@intel.com>
+ *	Tim Chen <tim.c.chen@linux.intel.com>
+ */
+
+/* ISCSI CRC 32 Implementation with crc32 and pclmulqdq Instruction */
+
+/*
+ * Define threshold below which buffers are considered "small" and routed to
+ * regular CRC code that does not interleave the CRC instructions.
+ */
+#define PCL_SMALL_SIZE	200
+
+/*
+ * PCLMULQDQ tables
+ * Table is 128 entries x 2 words (8 bytes) each. The first entry is for idx 1
+ * (one qword per lane), the constants are used as K1:K2 when combining lanes.
+ */
+static const uint32_t crc32c_pcl_k_table[128][2] = {
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
+static inline uint64_t crc32c_load64(const unsigned char *p)
+{
+	uint64_t v;
+
+	memcpy(&v, p, sizeof(v));
+	return v;
+}
+
+__attribute__((target("sse4.2,pclmul")))
+static uint32_t crc32c_pcl(uint32_t crc, unsigned char const *data, uint32_t len)
+{
+	uint64_t crc0 = crc;
+
+	if (len >= PCL_SMALL_SIZE) {
+		unsigned int misaligned = -(uintptr_t)data & 7;
+
+		/*
+		 * 1) ALIGN:
+		 * Process 1 <= misaligned <= 7 bytes individually in order to
+		 * align the remaining data to an 8-byte boundary.
+		 */
+		len -= misaligned;
+		while (misaligned--)
+			crc0 = _mm_crc32_u8(crc0, *data++);
+	}
+
+	/*
+	 * 2) PROCESS BLOCK:
+	 * 5) If more blocks remain, repeat from here.
+	 */
+	while (len >= PCL_SMALL_SIZE) {
+		/*
+		 * Processing 128 qwords from each lane for a full block,
+		 * otherwise compute floor(len / 24) to get the number of qwords
+		 * to process from each lane. 2731 = ceil(2^16 / 24)
+		 */
+		unsigned int qwords = len >= 128 * 24 ? 128 : (len * 2731) >> 16;
+		unsigned int chunk = qwords * 8;
+		const uint32_t *k = crc32c_pcl_k_table[qwords - 1];
+		const unsigned char *p1 = data + chunk;
+		const unsigned char *p2 = data + 2 * chunk;
+		uint64_t crc1 = 0, crc2 = 0;
+		__m128i kvec, x1, x2;
+		unsigned int i;
+
+		/* 3) CRC each of three lanes: */
+		for (i = 0; i < qwords - 1; i++) {
+			crc0 = _mm_crc32_u64(crc0, crc32c_load64(data + i * 8));
+			crc1 = _mm_crc32_u64(crc1, crc32c_load64(p1 + i * 8));
+			crc2 = _mm_crc32_u64(crc2, crc32c_load64(p2 + i * 8));
+		}
+		crc0 = _mm_crc32_u64(crc0, crc32c_load64(data + i * 8));
+		crc1 = _mm_crc32_u64(crc1, crc32c_load64(p1 + i * 8));
+		/* SKIP the last qword of crc2, don't do this one yet */
+
+		/* 4) Combine three results: */
+		/* 2 consts: K1:K2 */
+		kvec = _mm_set_epi64x(k[1], k[0]);
+		/* CRC for block 1, multiply by K2 */
+		x1 = _mm_clmulepi64_si128(_mm_cvtsi64_si128(crc0), kvec, 0x00);
+		/* CRC for block 2, multiply by K1 */
+		x2 = _mm_clmulepi64_si128(_mm_cvtsi64_si128(crc1), kvec, 0x10);
+		x1 = _mm_xor_si128(x1, x2);
+		crc0 = _mm_crc32_u64(crc2, _mm_cvtsi128_si64(x1) ^
+				     crc32c_load64(p2 + i * 8));
+
+		data += 3 * chunk;
+		len -= 3 * chunk;
+	}
+
+	/* 6) Process any remainder without interleaving: */
+	while (len >= 8) {
+		crc0 = _mm_crc32_u64(crc0, crc32c_load64(data));
+		data += 8;
+		len -= 8;
+	}
+	if (len & 4) {
+		uint32_t v;
+
+		memcpy(&v, data, sizeof(v));
+		crc0 = _mm_crc32_u32(crc0, v);
+		data += 4;
+	}
+	if (len & 2) {
+		uint16_t v;
+
+		memcpy(&v, data, sizeof(v));
+		crc0 = _mm_crc32_u16(crc0, v);
+		data += 2;
+	}
+	if (len & 1)
+		crc0 = _mm_crc32_u8(crc0, *data);
+
+	return crc0;
 }
 
 /*
@@ -82,7 +335,8 @@ static uint32_t crc32c_sse42(uint32_t crc, unsigned char const *data, uint32_t l
 void crc32c_init_accel(void)
 {
 	if (0) {
-	} else if (cpu_has_feature(CPU_FLAG_PCLMUL)) {
+	} else if (cpu_has_feature(CPU_FLAG_PCLMUL) &&
+		   cpu_has_feature(CPU_FLAG_SSE42)) {
 		/* printf("CRC32C: pcl\n"); */
 		crc32c_impl = crc32c_pcl;
 	} else if (cpu_has_feature(CPU_FLAG_SSE42)) {
-- 
2.56.0

