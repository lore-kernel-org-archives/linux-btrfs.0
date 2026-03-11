Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBAA3783BD;
	Wed, 11 Mar 2026 07:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773212709; cv=none; b=Jb7IaRYv+vrHw2E1MCNZ2f0UhvU3WKGEJJtb0hQpJsDrPnosxRumk1wRoDXR2YTCjkeGxJRLE81NjdJtnNDuL8tyKELsDBJtJZ3aNx1p3dlFXIpO5k3pAOMdAE5eFm6nkikWiOkufrCtO3tpE1MPCqSwlDGXG22GFuG9csbybE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773212709; c=relaxed/simple;
	bh=Xr2NS+Z+MofXCcGVHIYSe4z+OYqNscadbrVLgzonAs4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UDCvHsCH17HXO/5jJ8wB0MJy3fC0g90VcwoyrjnJmtmXCoWKYvbZn2eyNR68ABpu7Tsg8r0Ky/NCPbdSOdhPm+oUZtHmzPRj7KL16oSA8xqUILfjkfvBTL4KLORTWksEEW5YoqgMgDI94LedzuDT26YjeAZCoi0t68vSVdPUTTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U7eno6iJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U7eno6iJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Hc8oVC0rraqJ+8Vr8bqmJfI6i82OBNZtjhcVJAFoc/s=; b=U7eno6iJONJITPXT1in741nyMw
	Fiv9M6CVRvVdPRJZ1dpGzKZ4zdRP6Zb8Oo81v23bKwHx9LEmAnWRHQ/HABrjjKh4isc4Ry+PWTKDe
	ReyVrnw5h1uKGlaun6hQuoczvsL2rxXwQYW474p7/KdXBoXlDZ8j4SUmBJSSl1lSkKQ4NiPl7SKbk
	zTA7N9wbM4m/vCuv7KFhRuagCarxtdrlgbYEFmPqC1tS653hV4OsNY0kp5L2xkZ3NN+ceb0v7k3kU
	NdxdUcyNZD/EZbId8gz30iKzAceTnG8/WtSDJxQInMbqtyX5BUUQkjN8uO8sG/EUGlpSHtZXsQv3o
	0QXDgsfQ==;
Received: from [212.243.42.10] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0DcK-0000000Ay6i-41SA;
	Wed, 11 Mar 2026 07:04:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Williams <dan.j.williams@intel.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: cleanup the RAID5 XOR library v2
Date: Wed, 11 Mar 2026 08:03:32 +0100
Message-ID: <20260311070416.972667-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

the XOR library used for the RAID5 parity is a bit of a mess right now.
The main file sits in crypto/ despite not being cryptography and not
using the crypto API, with the generic implementations sitting in
include/asm-generic and the arch implementations sitting in an asm/
header in theory.  The latter doesn't work for many cases, so
architectures often build the code directly into the core kernel, or
create another module for the architecture code.

Changes this to a single module in lib/ that also contains the
architecture optimizations, similar to the library work Eric Biggers
has done for the CRC and crypto libraries later.  After that it changes
to better calling conventions that allow for smarter architecture
implementations (although none is contained here yet), and uses
static_call to avoid indirection function call overhead.

A git tree is also available here:

    git://git.infradead.org/users/hch/misc.git xor-improvements

Gitweb:

    https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/xor-improvements

Changes since v1:
 - use lockdep_assert_preemption_enabled()
 - improve the commit message for the initial um xor.h cleanup
 - further clean up the um arch specific header
 - add SPDX identifier to the new build system files
 - use bool for xor_forced
 - fix an incorrect printk level conversion from warn to info
 - include xor_impl.h in xor-neon.c
 - remove unused exports for riscv
 - simply move the sparc code instead of splititng it
 - simplify the makefile for the x86-specific implementations
 - remove stray references to xor_blocks in crypto/async_tx
 - rework __DO_XOR_BLOCKS to avoid (theoretical) out of bounds references
 - improve the kerneldoc API documentration for xor_gen()
 - spell the name of the srcs argument to xor_gen correctly in xor.h
 - add a kunit test, and a new random helper for it.

Diffstat:
 arch/arm64/include/asm/xor.h              |   73 --
 arch/loongarch/include/asm/xor.h          |   68 --
 arch/loongarch/include/asm/xor_simd.h     |   34 -
 arch/loongarch/lib/xor_simd_glue.c        |   72 --
 arch/powerpc/include/asm/xor.h            |   47 -
 arch/powerpc/include/asm/xor_altivec.h    |   22 
 arch/powerpc/lib/xor_vmx.h                |   22 
 arch/powerpc/lib/xor_vmx_glue.c           |   63 --
 arch/riscv/include/asm/xor.h              |   68 --
 arch/s390/include/asm/xor.h               |   21 
 arch/sparc/include/asm/xor.h              |    9 
 arch/um/include/asm/xor.h                 |   24 
 arch/x86/include/asm/xor_64.h             |   28 -
 b/arch/alpha/Kconfig                      |    1 
 b/arch/arm/Kconfig                        |    1 
 b/arch/arm/lib/Makefile                   |    5 
 b/arch/arm64/Kconfig                      |    1 
 b/arch/arm64/lib/Makefile                 |    6 
 b/arch/loongarch/Kconfig                  |    1 
 b/arch/loongarch/lib/Makefile             |    2 
 b/arch/powerpc/Kconfig                    |    1 
 b/arch/powerpc/lib/Makefile               |    5 
 b/arch/riscv/Kconfig                      |    1 
 b/arch/riscv/lib/Makefile                 |    1 
 b/arch/s390/Kconfig                       |    1 
 b/arch/s390/lib/Makefile                  |    2 
 b/arch/sparc/Kconfig                      |    1 
 b/arch/sparc/include/asm/asm-prototypes.h |    1 
 b/arch/sparc/lib/Makefile                 |    2 
 b/arch/um/Kconfig                         |    1 
 b/arch/x86/Kconfig                        |    1 
 b/crypto/Kconfig                          |    2 
 b/crypto/Makefile                         |    1 
 b/crypto/async_tx/async_xor.c             |   34 -
 b/drivers/char/random.c                   |   26 -
 b/fs/btrfs/raid56.c                       |   27 -
 b/include/asm-generic/Kbuild              |    1 
 b/include/linux/raid/xor.h                |   27 -
 b/include/linux/random.h                  |    1 
 b/lib/Kconfig                             |    1 
 b/lib/Makefile                            |    2 
 b/lib/raid/Kconfig                        |   19 
 b/lib/raid/Makefile                       |    3 
 b/lib/raid/xor/Makefile                   |   43 +
 b/lib/raid/xor/alpha/xor.c                |   46 -
 b/lib/raid/xor/alpha/xor_arch.h           |   22 
 b/lib/raid/xor/arm/xor-neon-glue.c        |   19 
 b/lib/raid/xor/arm/xor-neon.c             |   22 
 b/lib/raid/xor/arm/xor.c                  |  105 ----
 b/lib/raid/xor/arm/xor_arch.h             |   22 
 b/lib/raid/xor/arm64/xor-neon-glue.c      |   26 +
 b/lib/raid/xor/arm64/xor-neon.c           |   94 +--
 b/lib/raid/xor/arm64/xor-neon.h           |    6 
 b/lib/raid/xor/arm64/xor_arch.h           |   21 
 b/lib/raid/xor/loongarch/xor_arch.h       |   33 +
 b/lib/raid/xor/loongarch/xor_simd_glue.c  |   37 +
 b/lib/raid/xor/powerpc/xor_arch.h         |   22 
 b/lib/raid/xor/powerpc/xor_vmx.c          |   40 -
 b/lib/raid/xor/powerpc/xor_vmx.h          |   10 
 b/lib/raid/xor/powerpc/xor_vmx_glue.c     |   28 +
 b/lib/raid/xor/riscv/xor-glue.c           |   25 +
 b/lib/raid/xor/riscv/xor.S                |    4 
 b/lib/raid/xor/riscv/xor_arch.h           |   17 
 b/lib/raid/xor/s390/xor.c                 |   15 
 b/lib/raid/xor/s390/xor_arch.h            |   13 
 b/lib/raid/xor/sparc/xor-sparc32.c        |   32 -
 b/lib/raid/xor/sparc/xor-sparc64-glue.c   |   48 -
 b/lib/raid/xor/sparc/xor-sparc64.S        |   10 
 b/lib/raid/xor/sparc/xor_arch.h           |   35 +
 b/lib/raid/xor/tests/Makefile             |    3 
 b/lib/raid/xor/tests/xor_kunit.c          |  180 +++++++
 b/lib/raid/xor/um/xor_arch.h              |    2 
 b/lib/raid/xor/x86/xor-avx.c              |   52 --
 b/lib/raid/xor/x86/xor-mmx.c              |  120 +---
 b/lib/raid/xor/x86/xor-sse.c              |  105 +---
 b/lib/raid/xor/x86/xor_arch.h             |   36 +
 b/lib/raid/xor/xor-32regs-prefetch.c      |  267 ++++++++++
 b/lib/raid/xor/xor-32regs.c               |  217 ++++++++
 b/lib/raid/xor/xor-8regs-prefetch.c       |  146 +++++
 b/lib/raid/xor/xor-8regs.c                |  103 ++++
 b/lib/raid/xor/xor-core.c                 |  191 +++++++
 b/lib/raid/xor/xor_impl.h                 |   60 ++
 crypto/xor.c                              |  174 -------
 include/asm-generic/xor.h                 |  738 ------------------------------
 84 files changed, 1840 insertions(+), 2078 deletions(-)
