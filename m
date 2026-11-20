Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795137572;
	b=ApNHQbiSDtsnqUJRSivu5BmXHb4gR/gjjNMLA2CuqBk4Hc4WNYABlwE4yzyL7yGcqOjB
	 ZyS/bg5EBygnAC7LQVK6+e+iI6lNW82n6iiGA05hjxEgiYFvoRIkpWhvoTMLTgWZsEc7k
	 HorrRGPGGu9yUaLIaJGi03UqKaEzm0uWz2Jxc7kkCB0h8Ix9DInCrrWhfalzSAaq8NkUw
	 uyE61DlVJSQ40gySrp/dNuYFDxtV3HLFEM3SjiiAKP/ckMiqOaqGq3hLWl9thchdkltui
	 YouJv0QpQhafp8HlpXoZDMoo8Un+qsTqkspMUIbM1o7ZtGq80kFLZUb5kToZuAPPTOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795137572;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=1H1IoTTI+g93jvB7VArGxNY5Ipwrk9GouKodu6Wu/Bs=;
	b=hqhzuZV0Owep+z0jMjv4nTcudCQoGWBIzYZIVzYux1uVwVX7orYCNLmH95bjXepuabe8
	 +ep8a9wX+flvAdZavpB46GaelN/0zdOoho5Oax3TkP2xBt393GrlqnKuv/9LFGHl++olE
	 k7mU7aWJqJ6UYc4H/7JzCMdV/oUYA/+ZMeW9qN8ey2g7F4bbWjqjdb93/O4ncnqW0enBz
	 +xcwGJ4/2RJ9recTJRGLEd7P6YlhCPo9L1H6tSyTQPkafrKdBuzzJbl3xYVho/EUUv0ZP
	 t0MV6M7ixtC3WI96n2/iUeLaEnXsdasIebamrWNqO2Nq+yECVdQ52DNHEib0/NNKCMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=CgTqY2Vy;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=CgTqY2Vy;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F23606A320;
	Fri, 20 Nov 2026 01:19:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10F23606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=CgTqY2Vy;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=CgTqY2Vy
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0C227221FF;
	Fri, 20 Nov 2026 01:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1H1IoTTI+g93jvB7VArGxNY5Ipwrk9GouKodu6Wu/Bs=;
	b=CgTqY2VyF6Y7Y7nWvmd6Laj12+2Nr/0Xhy+lqicwiN8qSQWuCXWN5q+BjZ9zMdSc1/2PlZ
	/GI6T3ul/rd9rCOwSxvyrxmxks1mYsGzwGtcWPeJ/Vindbh2XEuVgwPwV8gnGJEaVo1T02
	ovH2NqUUfIyP6umpHIAdoGapv1n3hDw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1H1IoTTI+g93jvB7VArGxNY5Ipwrk9GouKodu6Wu/Bs=;
	b=CgTqY2VyF6Y7Y7nWvmd6Laj12+2Nr/0Xhy+lqicwiN8qSQWuCXWN5q+BjZ9zMdSc1/2PlZ
	/GI6T3ul/rd9rCOwSxvyrxmxks1mYsGzwGtcWPeJ/Vindbh2XEuVgwPwV8gnGJEaVo1T02
	ovH2NqUUfIyP6umpHIAdoGapv1n3hDw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D8211342D;
	Fri, 20 Nov 2026 01:19:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f6GRNh6g/2r1FAAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 20 Nov 2026 01:19:27 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org,
	ardb@kernel.org
Subject: [PATCH RFC v2 0/6] lib/crc: x86: convert the CRC assembly to C intrinsics
Date: Fri, 20 Nov 2026 11:48:58 +1030
Message-ID: <cover.1795137348.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

[CHANGELOG]
v2:
- Use compiler's intrinsics header directly
- Convert all x86 asm files to C

Currently the x86 CRC code is all assembly: the generic [V]PCLMULQDQ
template (12 functions: crc16, crc32 and crc64, three vector lengths each)
and crc32c-3way.S.  arm and arm64 already use C intrinsics.

This series converts all of it to C with the compiler's intrinsics, and
removes the assembly.  No algorithm, constant or calling convention
changes, so the glue is untouched.

The goal is maintainability and portability, not speed: C is easier to
read, review and extend than the macro-heavy assembly.
And it is also easier to port to userspace tools like btrfs-progs and
xfsprogs which will require optimized CRC for offline operations.

Tests on a Zen5 VM show no obvious change in performance, except for clang
with the MSB-first SSE and AVX2 functions, see below.

Patches:

1:   asm/x86-intrinsics.h, a wrapper around <immintrin.h>.
2:   crc32c_x86_3way().
3-6: crc32_lsb, crc64_msb, crc64_lsb and crc16_msb, each with the SSE4.1,
     AVX2 and AVX512BW/VL variants.  The template crc-pclmul-impl.h grows
     with them, and the assembly is removed in the last one.

Design decisions and trade-offs
===============================

-  ISA selection: target attribute instead of per-file flags

   Each function and helper has __attribute__((target(...))), the code is
   not built with -msse4.1, -mavx2 or -mavx512*.  Per-file flags would
   need one object per ISA level, or the SSE function could use AVX-512.

   Pros: all vector lengths of a CRC are in one file, and the compiler can
   only use an extension in the functions that run after the CPU feature
   checks (checked in the objdump).

   Cons: no precedent in the kernel for selecting x86 ISA levels this way,
   and this is completely compiler dependent. See the GCC 8.1/8.2 issue
   below.

-  One template, included once per function

   The 12 functions differ only in vector length, CRC width and bit order,
   so crc-pclmul-impl.h generates one per inclusion, after the includer
   defined VL, CRC_BITS, CRC_MSB and CRC_FUNC.

   I tried two different solutions:

   * Nine standalone functions
     About 1400 lines against about 490 with the template.
     And any fututre fixes needs to be duplicated 9 times.

   * A DEFINE_CRC_PCLMUL_FUNCS() style macro
     It can work, but the body cannot have #if, so the wide-vector stages
     become constant if()s and GCC warns about the dead code (-Wpsabi).

     That macro also makes checkpatch warn about flow control in a macro,
     and compiler errors, gdb and perf point at the invocation line.

   The include-as-template is not a common practice, but would be the
   least-worst solution I can come up with.

-  Generated code and performance

   Against the assembly (kbuild objects, GCC 16.2, clang 23): clang has
   the same total size for the 12 pclmul functions (7453 against 7482
   bytes) and the same instruction count in each main loop.

   GCC is 18% bigger (SSE +12%, AVX2 +22%, AVX-512 +19%): stack
   realignment in every function and, for AVX-512, loads not folded into
   vpternlogq (19 instead of 16 instructions in the LSB-first main loop).

   crc32c_x86_3way() grows from 400 bytes to 603 (GCC) and 783 (clang),
   mostly prologue and unrolling of the tail.  The main loop is 15, 17 and
   16 instructions (asm, GCC, clang).

   Every C function also gets endbr64 and the ftrace call, which the
   assembly never had.  The call is patched to a nop at boot.

   Throughput comes from a userspace harness using the same sources, built
   with the kernel's -mno-sse flags, on a Zen5 VM (Ryzen AI 9 HX 370): one
   pinned CPU, median of 7 runs.  No in-kernel benchmark yet.

   Peak is about 7.7, 15.4 and 30.7 GB/s for SSE, AVX2 and AVX-512.  GCC
   is within 2% of the assembly from 1 KiB, up to 4-6% slower at 64-200
   bytes and 8% for AVX2 at 512 bytes.

   clang is the same, except crc64_msb and crc16_msb: SSE is 5-8% slower
   from 512 bytes, AVX2 5-7% from 1 KiB, but 14% faster at 512 bytes.
   AVX-512 is equal.

   The clang SSE loop is 175 bytes against 153 for the assembly, as it
   keeps data in xmm8-xmm11 (REX prefixes).  That is likely the cause,
   changing the XOR order did not help.

   crc32c_x86_3way() is within 3% of the assembly: 8.6 to 9.0 GB/s at 200
   bytes, 14.8 to 14.9 GB/s at 64 KiB.

Known issue: GCC 8.1 and 8.2

   GCC 8.1 and 8.2 cannot build the AVX2 functions.  Their
   <vpclmulqdqintrin.h> declares _mm256_clmulepi64_epi128() with avx512vl
   in its target, which fold256() lacks, so it cannot be inlined.

   GCC 8.3 and later only need avx.  I reproduced it on Compiler Explorer,
   where 8.3 to 9.5 build the code cleanly.

   Calling __builtin_ia32_vpclmulqdq_v4di() directly for GCC older than 9
   fixes it, but it is not included.  8.1 is still the documented minimum,
   so: add that workaround, raise the minimum, or ignore 8.1 and 8.2?


Qu Wenruo (6):
  x86: Add a wrapper header for the compiler's SIMD intrinsics
  lib/crc: x86: Convert crc32c_x86_3way() from assembly to C intrinsics
  lib/crc: x86: Convert crc32_lsb_*() from assembly to C
  lib/crc: x86: Convert crc64_msb_*() from assembly to C
  lib/crc: x86: Convert crc64_lsb_*() from assembly to C
  lib/crc: x86: Convert crc16_msb_*() from assembly to C

 arch/x86/include/asm/x86-intrinsics.h |  49 +++
 lib/crc/Makefile                      |  11 +-
 lib/crc/x86/crc-pclmul-helpers.h      |  90 ++++
 lib/crc/x86/crc-pclmul-impl.h         | 304 ++++++++++++++
 lib/crc/x86/crc-pclmul-template.S     | 575 --------------------------
 lib/crc/x86/crc-pclmul-template.h     |   2 +-
 lib/crc/x86/crc16-msb-pclmul.S        |   6 -
 lib/crc/x86/crc16-msb-pclmul.c        |  23 ++
 lib/crc/x86/crc32-pclmul.S            |   6 -
 lib/crc/x86/crc32-pclmul.c            |  23 ++
 lib/crc/x86/crc32.h                   |   2 +-
 lib/crc/x86/crc32c-3way.S             | 360 ----------------
 lib/crc/x86/crc32c-3way.c             | 264 ++++++++++++
 lib/crc/x86/crc64-lsb-pclmul.c        |  23 ++
 lib/crc/x86/crc64-msb-pclmul.c        |  23 ++
 lib/crc/x86/crc64-pclmul.S            |   7 -
 16 files changed, 811 insertions(+), 957 deletions(-)
 create mode 100644 arch/x86/include/asm/x86-intrinsics.h
 create mode 100644 lib/crc/x86/crc-pclmul-helpers.h
 create mode 100644 lib/crc/x86/crc-pclmul-impl.h
 delete mode 100644 lib/crc/x86/crc-pclmul-template.S
 delete mode 100644 lib/crc/x86/crc16-msb-pclmul.S
 create mode 100644 lib/crc/x86/crc16-msb-pclmul.c
 delete mode 100644 lib/crc/x86/crc32-pclmul.S
 create mode 100644 lib/crc/x86/crc32-pclmul.c
 delete mode 100644 lib/crc/x86/crc32c-3way.S
 create mode 100644 lib/crc/x86/crc32c-3way.c
 create mode 100644 lib/crc/x86/crc64-lsb-pclmul.c
 create mode 100644 lib/crc/x86/crc64-msb-pclmul.c
 delete mode 100644 lib/crc/x86/crc64-pclmul.S

-- 
2.56.0

