Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795146142;
	b=YOQ84Odkp06n4VjaMEurXIgaluJU7YgsRai2WdL5KVaLsXj+Kz7uHkWU63BebTEQiLU4
	 LSBjVU4kpY3QJ4S3hixTPz4eC23jzCTuPtiJGNHmKALQnIFciL/aawLNJrPx3wjT/EnlR
	 HHOlLUOfNJwkJLh/jd8Jr42lKPgDltIhlCC6BPSV+O2HHYa7j8YO13BD7CEcQ8Ukf+UFK
	 Tknf1A/QwSwgksRrhFwF43TmVlIIQd2wEo+LqP+/EIasuiKgjQKZWsgPjbfHUe7dt+Dfy
	 LitlxnGm5XR8UoiRUn0vrxHjrfHxTOSeheyexFA2F4wi6keuJ2iU+y75U1ZL+G7xLkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795146142;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LvGgs0LmnbFgyPQ2jeX4JEBExkGaNzwkJs6z5uReUoQ=;
	b=3fWZfcLvSwRkF5GqthEjGuLVlUZeKTTO2wZiDT4VCWwwLABL3IRDaYcvyiZsgok5HErH
	 hHjxmnMHyTxuIeKSzBEjXwqA479rY8u0UAhoUXFSFm68h1sUAKQHyzQXjjV/J7X2yXXXO
	 1JlvE0Nip9FFfDMBq21smSm41LqK6Crn1Iii3+nTIHZCt9AnzmBQwNMuR4/buELkwg42Z
	 wCPNzej4C02fnEwB2O2UimN3VObK9bjzBvTXpOm1P5xbTHux/BkSB6PIXPqawyrj3Jz9v
	 FJ8stb/D+IGmk1FyTgQ1Cc/WkIyN/9Ny7PlNqdX9a1RK0oOlHl60B4Vw912URlaxorA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PoT9Wi9z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8204A606A320;
	Fri, 20 Nov 2026 03:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PoT9Wi9z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB9F1F000C6;
	Fri, 20 Nov 2026 03:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795146142;
	bh=LvGgs0LmnbFgyPQ2jeX4JEBExkGaNzwkJs6z5uReUoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PoT9Wi9z4Bme/byZ1hCnxJvBK8kbn9Qt128ekf22cg/msr0H0ZWL2rPFttYtu80SH
	 sQEM5dYPmuAF+26uN1ePnLHl8gl/reo5KmlYvsa1GIOppLd/YOPNJ+HkXGmAwvhASZ
	 /wJZMvvNcG3pW5uLIUzMQ5PA3bI/FKT3UvvJ6ZeBk3s58wbAV0EcR0g0jyXCGn+WBw
	 GQMxZuTf91M2vEFWZ6yzUOIgF6cD3ke940RHbawQ0CeotGZszgx+4vyIxOZYKmq1tq
	 wUtFQoJuNwue8+xbDwgKtcihdaOy2hA6LTCds+8bc+2pnNIepV9ath8julvO9x/tav
	 0Ubfm8JOXNdHw==
Date: Thu, 19 Nov 2026 19:42:20 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
	ardb@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/6] lib/crc: x86: convert the CRC assembly to C
 intrinsics
Message-ID: <20261120034220.GA11532@sol>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1795137348.git.wqu@suse.com>

[ +Cc x86@kernel.org ]

Hi Qu,

On Fri, Nov 20, 2026 at 11:48:58AM +1030, Qu Wenruo wrote:
> [CHANGELOG]
> v2:
> - Use compiler's intrinsics header directly
> - Convert all x86 asm files to C
> 
> Currently the x86 CRC code is all assembly: the generic [V]PCLMULQDQ
> template (12 functions: crc16, crc32 and crc64, three vector lengths each)
> and crc32c-3way.S.  arm and arm64 already use C intrinsics.
> 
> This series converts all of it to C with the compiler's intrinsics, and
> removes the assembly.  No algorithm, constant or calling convention
> changes, so the glue is untouched.
> 
> The goal is maintainability and portability, not speed: C is easier to
> read, review and extend than the macro-heavy assembly.
> And it is also easier to port to userspace tools like btrfs-progs and
> xfsprogs which will require optimized CRC for offline operations.
> 
> Tests on a Zen5 VM show no obvious change in performance, except for clang
> with the MSB-first SSE and AVX2 functions, see below.
> 
> Patches:
> 
> 1:   asm/x86-intrinsics.h, a wrapper around <immintrin.h>.
> 2:   crc32c_x86_3way().
> 3-6: crc32_lsb, crc64_msb, crc64_lsb and crc16_msb, each with the SSE4.1,
>      AVX2 and AVX512BW/VL variants.  The template crc-pclmul-impl.h grows
>      with them, and the assembly is removed in the last one.
> 
> Design decisions and trade-offs
> ===============================
> 
> -  ISA selection: target attribute instead of per-file flags
> 
>    Each function and helper has __attribute__((target(...))), the code is
>    not built with -msse4.1, -mavx2 or -mavx512*.  Per-file flags would
>    need one object per ISA level, or the SSE function could use AVX-512.
> 
>    Pros: all vector lengths of a CRC are in one file, and the compiler can
>    only use an extension in the functions that run after the CPU feature
>    checks (checked in the objdump).
> 
>    Cons: no precedent in the kernel for selecting x86 ISA levels this way,
>    and this is completely compiler dependent. See the GCC 8.1/8.2 issue
>    below.
> 
> -  One template, included once per function
> 
>    The 12 functions differ only in vector length, CRC width and bit order,
>    so crc-pclmul-impl.h generates one per inclusion, after the includer
>    defined VL, CRC_BITS, CRC_MSB and CRC_FUNC.
> 
>    I tried two different solutions:
> 
>    * Nine standalone functions
>      About 1400 lines against about 490 with the template.
>      And any fututre fixes needs to be duplicated 9 times.
> 
>    * A DEFINE_CRC_PCLMUL_FUNCS() style macro
>      It can work, but the body cannot have #if, so the wide-vector stages
>      become constant if()s and GCC warns about the dead code (-Wpsabi).
> 
>      That macro also makes checkpatch warn about flow control in a macro,
>      and compiler errors, gdb and perf point at the invocation line.
> 
>    The include-as-template is not a common practice, but would be the
>    least-worst solution I can come up with.
> 
> -  Generated code and performance
> 
>    Against the assembly (kbuild objects, GCC 16.2, clang 23): clang has
>    the same total size for the 12 pclmul functions (7453 against 7482
>    bytes) and the same instruction count in each main loop.
> 
>    GCC is 18% bigger (SSE +12%, AVX2 +22%, AVX-512 +19%): stack
>    realignment in every function and, for AVX-512, loads not folded into
>    vpternlogq (19 instead of 16 instructions in the LSB-first main loop).
> 
>    crc32c_x86_3way() grows from 400 bytes to 603 (GCC) and 783 (clang),
>    mostly prologue and unrolling of the tail.  The main loop is 15, 17 and
>    16 instructions (asm, GCC, clang).
> 
>    Every C function also gets endbr64 and the ftrace call, which the
>    assembly never had.  The call is patched to a nop at boot.
> 
>    Throughput comes from a userspace harness using the same sources, built
>    with the kernel's -mno-sse flags, on a Zen5 VM (Ryzen AI 9 HX 370): one
>    pinned CPU, median of 7 runs.  No in-kernel benchmark yet.
> 
>    Peak is about 7.7, 15.4 and 30.7 GB/s for SSE, AVX2 and AVX-512.  GCC
>    is within 2% of the assembly from 1 KiB, up to 4-6% slower at 64-200
>    bytes and 8% for AVX2 at 512 bytes.
> 
>    clang is the same, except crc64_msb and crc16_msb: SSE is 5-8% slower
>    from 512 bytes, AVX2 5-7% from 1 KiB, but 14% faster at 512 bytes.
>    AVX-512 is equal.
> 
>    The clang SSE loop is 175 bytes against 153 for the assembly, as it
>    keeps data in xmm8-xmm11 (REX prefixes).  That is likely the cause,
>    changing the XOR order did not help.
> 
>    crc32c_x86_3way() is within 3% of the assembly: 8.6 to 9.0 GB/s at 200
>    bytes, 14.8 to 14.9 GB/s at 64 KiB.
> 
> Known issue: GCC 8.1 and 8.2
> 
>    GCC 8.1 and 8.2 cannot build the AVX2 functions.  Their
>    <vpclmulqdqintrin.h> declares _mm256_clmulepi64_epi128() with avx512vl
>    in its target, which fold256() lacks, so it cannot be inlined.
> 
>    GCC 8.3 and later only need avx.  I reproduced it on Compiler Explorer,
>    where 8.3 to 9.5 build the code cleanly.
> 
>    Calling __builtin_ia32_vpclmulqdq_v4di() directly for GCC older than 9
>    fixes it, but it is not included.  8.1 is still the documented minimum,
>    so: add that workaround, raise the minimum, or ignore 8.1 and 8.2?
> 
> 
> Qu Wenruo (6):
>   x86: Add a wrapper header for the compiler's SIMD intrinsics
>   lib/crc: x86: Convert crc32c_x86_3way() from assembly to C intrinsics
>   lib/crc: x86: Convert crc32_lsb_*() from assembly to C
>   lib/crc: x86: Convert crc64_msb_*() from assembly to C
>   lib/crc: x86: Convert crc64_lsb_*() from assembly to C
>   lib/crc: x86: Convert crc16_msb_*() from assembly to C
> 
>  arch/x86/include/asm/x86-intrinsics.h |  49 +++
>  lib/crc/Makefile                      |  11 +-
>  lib/crc/x86/crc-pclmul-helpers.h      |  90 ++++
>  lib/crc/x86/crc-pclmul-impl.h         | 304 ++++++++++++++
>  lib/crc/x86/crc-pclmul-template.S     | 575 --------------------------
>  lib/crc/x86/crc-pclmul-template.h     |   2 +-
>  lib/crc/x86/crc16-msb-pclmul.S        |   6 -
>  lib/crc/x86/crc16-msb-pclmul.c        |  23 ++
>  lib/crc/x86/crc32-pclmul.S            |   6 -
>  lib/crc/x86/crc32-pclmul.c            |  23 ++
>  lib/crc/x86/crc32.h                   |   2 +-
>  lib/crc/x86/crc32c-3way.S             | 360 ----------------
>  lib/crc/x86/crc32c-3way.c             | 264 ++++++++++++
>  lib/crc/x86/crc64-lsb-pclmul.c        |  23 ++
>  lib/crc/x86/crc64-msb-pclmul.c        |  23 ++
>  lib/crc/x86/crc64-pclmul.S            |   7 -
>  16 files changed, 811 insertions(+), 957 deletions(-)
>  create mode 100644 arch/x86/include/asm/x86-intrinsics.h
>  create mode 100644 lib/crc/x86/crc-pclmul-helpers.h
>  create mode 100644 lib/crc/x86/crc-pclmul-impl.h
>  delete mode 100644 lib/crc/x86/crc-pclmul-template.S
>  delete mode 100644 lib/crc/x86/crc16-msb-pclmul.S
>  create mode 100644 lib/crc/x86/crc16-msb-pclmul.c
>  delete mode 100644 lib/crc/x86/crc32-pclmul.S
>  create mode 100644 lib/crc/x86/crc32-pclmul.c
>  delete mode 100644 lib/crc/x86/crc32c-3way.S
>  create mode 100644 lib/crc/x86/crc32c-3way.c
>  create mode 100644 lib/crc/x86/crc64-lsb-pclmul.c
>  create mode 100644 lib/crc/x86/crc64-msb-pclmul.c
>  delete mode 100644 lib/crc/x86/crc64-pclmul.S

Thanks for exploring this.

I think we should be honest: this would be a negative for
maintainability at least in the short term.  We'd be replacing existing
well-optimized and well-documented code with an experimental use of x86
C intrinsics in the kernel, with many of the original comments stripped
out or made inconsistent, and signing up to fight with compiler issues
(including inconsistent support between compilers, having to use
error-prone hacks to use the x86 intrinsics in the kernel at all, and
inefficient code generation which in some cases might not be solvable
without contributing fixes to gcc/clang).

I've used the x86 C intrinsics extensively in userspace projects.  So
sure, some of these compiler issues (minus the ones specific to trying
to use the intrinsics in the kernel) are things I'm used to already.
It's just been nice to not have to deal with them in the kernel.

Note that gcc can't even generate simple loops using vector intrinsics
without emitting unnecessary move instructions.  I reported it years ago
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107892) and it's still
unfixed.  So realistically, we either need to simply tolerate bad
codegen like that, or actually step up and actively contribute fixes to
the compilers (as merely opening a bug report does not result in a fix).

And as you mentioned in your cover letter, a lot of the code grew in
size and became slower, especially for short inputs which are important
for some in-kernel use cases.  So clearly there is some bad codegen
going on compared to what was there before.

I kind of feel this could only be a benefit in the long term if we
actually go all in and commit to switching the crypto code over to this
style of implementation as well.  But that area has a lot more code.
And that code also has another thorny issue: when operating on secrets,
it has to make sure to only use x86 instructions that are in the DOITM
(Data Operand Independent Timing Mode) subset.  Yet there's no compiler
support for restricting the used instructions to that subset, and no
announced plans from anyone (Intel, AMD, or otherwise) to implement it.

I'll also note that the hardest part to understand about this code (IMO)
is actually the polynomial math, especially the Barrett reduction.  And
yet this series deletes or greatly shortens many of the comments
explaining it, leaving unexplained operations, factually wrong comments
(especially for the Barrett reduction), and dangling references.  That's
most of the negative diff, too.

So if we're going to proceed, I'd at least like to see a version that
compares a bit more favorably to the original.  But also I think before
diving into this approach I'd like wider agreement in the Linux
community (x86 maintainers, crypto, etc.) that the x86 intrinsics are
the way to go, and for there to be a path forward for DOITM as well, and
hopefully some interest in improving the compilers too.

- Eric
