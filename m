Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270178;
	b=FNI1P8iXeBnJ43osauDLG4MvC5h/cL3sir6n9YhdCabxtnoMqHnSZBIpW4RmId6mGS7e
	 QAoeRJIRJqjLwcarDafElQ293lChUPnDDNCun+fqlHuFvgZd5IHJKcPFgcodFkMiaGbDW
	 d3hkWnaB+wJWRhebO+yOoR3iuyk6c80FrV0OQxH1HOH1BLVD1EkXVa5uo1PHnN8RRozlY
	 DwxzYkh28oVv0vRV2gIVRdTf3QHtonx17dJN0KLEhBYhP2VQ9zHklkJsF00Yhc80BKk39
	 dVHXeaItWZTI7xOtg7TQ9rDQYV697DkQiZPfvtrLEFmRhlWUTnaNEeovHWTAd602Ryw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270178;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=NALYbTqpQWKn266kqz03n6anoRhQmXzYtdFJ2lho0vY=;
	b=ApnO37R8scZVvi6/utYKJBp1vAI5TqhubXAnCU67tinn6gNs9LhDI+yrtPOtFmSZ5x2a
	 qVCuruwwhyIFSQ5b4vclwFeVc318IlX+XyK7shkhXz64vYyDSkVB3JOpCP5zcCb6bgIde
	 bUpiI6IliMv4P1kokZ5FA0xAjchT5IuDG5MupLXYAB6hs6Y96Pmdbnb2nMi81L6bFn6KH
	 IFS4aMfbUc93NabPG3atBpQhGQJvaL5ZDw2QwYatgcVN/2D5lTN28Hsl/qad2pIsSHa01
	 T8D7LLL6QXwRw6QTCHZ29LWtCzOPQ/M+i2mqJ4rT4ES+XWZc0zq1t98Q3DzrR5jzV2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UQlfEHs8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA512606A32A;
	Tue, 10 Nov 2026 00:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UQlfEHs8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A7C1F008A1;
	Tue, 10 Nov 2026 00:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270177;
	bh=NALYbTqpQWKn266kqz03n6anoRhQmXzYtdFJ2lho0vY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UQlfEHs8AAxyHNVuPQA7/aRHC383S+CL5aWQeYX79CchXnK2IDgmKGkEY72pDN0+k
	 U0F2gQVM2c7xbo5q+VwhKNSIIbaOVU/fKAfvtSI36+K5iIsd1XefjgUxC6N0XHaH6V
	 kb1MOQH0GdlUjcZgU4knQdkcrTmQOdztg58ANSjHEqKB9BelaFrA1Apelcr4cmLwJX
	 VwamiFt0jLEYrzl0z9Z8xVrwa0fEMxXBXkhrwbFju3qHZXsVAIQbNWYZm+s+5NmtS1
	 /7qeT1o8eWK0rdi423cy7AS+CsWJLPHPRfVgAQz4h+1C7HlE5PhjSmCrJu/pebJt8l
	 Q4beZ+gN18nvg==
Date: Mon, 9 Nov 2026 16:22:55 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
	ardb@kernel.org
Subject: Re: [PATCH] lib/crc: x86: rewrite crc32c_x86_3way() in C with inline
 asm
Message-ID: <20261110002255.GA1958@quark>
References: <090c5f6603b1102c877c8649f7a6569f362bfe61.1794268279.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <090c5f6603b1102c877c8649f7a6569f362bfe61.1794268279.git.wqu@suse.com>

On Tue, Nov 10, 2026 at 10:22:48AM +1030, Qu Wenruo wrote:
> Unlike user space, we can not use intrinsics, so some instructions must
> still use inlined ASM, but that is only limited to crc32_u*() helpers
> and the PCLMULQDQ based lanes combination.
> 
> Those wrappers are in the new crc32c-inst.h header, and are also
> utilized by crc32c_arch() and the new C based crc32c_x86_3way().
> 
> The hot loop is the same sequence of crc32 instructions as in the asm
> version, with the same lane addressing.
> The differences in the generated code (x86_64, clang, function tracing
> enabled) are as follows.
> 
> The old 4x unrolled loop is 12 memory-operand crc32q plus 3 bookkeeping
> instructions per iteration:
> 
>     crc32q  (bufp), crc0_q
>     crc32q  (bufp,chunk_bytes_q), crc1
>     crc32q  (bufp,chunk_bytes_q,2), crc2
>     ... same for offsets 8, 16 and 24 ...
>     add     $32, bufp
>     sub     $4, %eax
>     jge     .Lcrc_3lanes_4x_loop
> 
> The new one has the same 12 crc32 and the same addressing, but clang
> can't fold the load into the instruction because ASM_INPUT_RM is "r" for
> clang, so every crc32 has a preceding mov:
> 
>     mov     (%rsi),%r14
>     crc32   %r14,%r9
>     mov     (%rsi,%rdx,8),%r14
>     crc32   %r14,%r11
>     mov     (%rsi,%r10,1),%r14
>     crc32   %r14,%rax
>     ... same for offsets 8, 16 and 24 ...
>     add     $-4,%rbx
>     add     $0x20,%rsi
>     cmp     $3,%rbx
>     ja      <loop>
> 
> Thus 12 extra loads per iteration.  They don't matter in practice, as the
> loop is bound by the latency of the three crc32 dependency chains, not by
> uop throughput.
> Forcing the memory form with "m" made no difference either in a userspace
> benchmark.  gcc accepts "rm" and folds the loads into crc32q (checked on
> a userspace build of the same code).
> 
> The combination step is the same instructions, with the old code being
> 
>     pmovzxdq (K_table-8)(%rax,chunk_bytes_q), %xmm0
>     movq    crc0_q, %xmm1
>     pclmulqdq $0x00, %xmm0, %xmm1
>     movq    crc1, %xmm2
>     pclmulqdq $0x10, %xmm0, %xmm2
>     pxor    %xmm2, %xmm1
>     movq    %xmm1, %rax
>     xor     (bufp,chunk_bytes_q,2), %rax
>     mov     crc2, crc0_q
>     crc32   %rax, crc0_q
> 
> and the new one
> 
>     mov     %r9d,%r9d
>     mov     %r11d,%r11d
>     pmovzxdq 0x0(%rdi,%rdx,8),%xmm0
>     movq    %r9,%xmm1
>     pclmulqdq $0x00,%xmm0,%xmm1
>     movq    %r11,%xmm2
>     pclmulqdq $0x10,%xmm0,%xmm2
>     pxor    %xmm2,%xmm1
>     movq    %xmm1,%rdx
>     xor     (%rsi,%r10,1),%rdx
>     crc32   %rdx,%rax
> 
> The two movs at the top are the (u64) zero extensions of the lane CRCs,
> which are redundant as crc32q already zeroes the upper half.  The
> register copy of crc2 disappears as crc2 is just the accumulator for the
> final crc32.
> 
> The rest (prologue/epilogue, alignment head and sub-qword tail) is not
> performance critical.  The only visible difference is the usual kernel
> function prologue with a few callee-saved register pushes.
> 
> Measured throughput matches the old implementation within noise, both in
> a userspace comparison (gcc and clang, 200 bytes to 1 MiB) and in the
> in-kernel CRC32C KUnit benchmark, using a Zen5 (HX 370) based system.
> 
> Assisted-by: LLM (coding and testing)
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Reason for RFC:
> 
> The idea is inspired when I was cleaning up btrfs-progs, to prepare for
> new arm64 CRC32C implementation, as a preparation I want to remove all
> ASM file and inline ASM usages in userspace btrfs-progs.
> That works pretty well, so here I'm trying to cross-port this change to
> the kernel 3way acceleration path.
> 
> Although I would prefer a code base with less minimal ASM files, I'm not
> sure if everyone prefers this solution other than hand-written ASM code.
> 
> Furthermore all my tests are on a Zen5 based system (HX 370), with
> cpuid masking to test the 3way optimization code.
> 
> So no test on older platforms.
> 
> If this one is fine, I can continue converting the AVX512 version too.
> And hopefully can cross-port the C version of AVX512 back to
> btrfs-progs.

As much as I'd like to reduce the use of asm, I'm not sure this is super
convincing.  We get worse code generation and have to fall back to
inline asm anyway, as the x86 intrinsics are still unusable in the
kernel (which is different from userspace).

This patch also introduces a compiler error with gcc. It seems only
clang was tested.  (Showing again that this kind of code often has
compiler-specific issues, and we have to be extra careful to test it
with every supported compiler version.)

There's also a subtle bug where the inline asm blocks are missing the
volatile qualifier, so technically they could be reordered after the
kernel_fpu_end() and corrupt a userspace process's XMM registers.
Without inline asm, this issue would not have been possible.

I'd be interested in seeing what you can come up with for
crc-pclmul-template.S, though I think that one is going to be harder to
replace.

- Eric
