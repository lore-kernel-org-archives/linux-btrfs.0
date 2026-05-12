Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DA52D12ED;
	Tue, 12 May 2026 05:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778563406; cv=none; b=ksIKtZfa0ZW3YL9IYplyMZM/2eWqAN5j4VZHCzYA1w++eyLeuTlMBXBgwI813MLu9Uzzp4S7MVqVq+KvKOVzi2d/Ziwo0ZD9h3kRGPiTx0rx/viSVXsXvwqEBdcnmrxQGSYMc+PNKLG+fDq5vPanxoYyHfGsQ9Ugv/i72ZCtHdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778563406; c=relaxed/simple;
	bh=qj0HhEGSi5uUOjhdkDpAEzZ/VYBnmPrjXqneop/fn4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f3q5dVCKIpSVpJgarRM4uVKgNlfsa1DhKBFXbSjT0BADJLTeD+ZRH9ZKxa9hhpX+WcJyMy2BY0YO7Jk/zIcSEiD7uT6Z6PrYaEx6Vli2jb0B4p27pIyp9LoHqR46uqQYfTfwDEx7Gqud+/bPqfwUQb/AJA2I5plMwEOK/fCWD48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vtscn1Fk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vtscn1Fk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=hWNuCSvOTgL+hl7LSeigsUSvduHQkUgOajdKryVpMzA=; b=vtscn1Fk3uE4T8sWoxzxlGROEJ
	GCADN1TTiJPS4GrO9lcYTxNPoCYGR0Fg2YfYSZzEqBWFKq2hhv5PT4Hqz353ftsQAUkD0T8gLGlqd
	z0A72chaGEeedY1Api/DTbf4rOEzT9+pcvs4aKeu12A42LLGhu1uQsL8R2tZhrUsXMUPt3yTgpzLv
	u5trTMadFgEa6RMlzUE0dtLyIHiet5/ttZO0xqLdJdPFASjLmSebe8/gCPLk/MFMb4OvN8x2DZjzo
	uyCvvRPg5vy8g7A8aHtdehArpsSMrcXlUxHEy9FmxQeib99y7ucocuZiPQW6XpLvCGzZ68OHTJZN0
	5wEgmGCQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfZo-0000000FaGb-2eLn;
	Tue, 12 May 2026 05:22:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
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
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: cleanup the RAID6 P/Q library v2
Date: Tue, 12 May 2026 07:20:40 +0200
Message-ID: <20260512052230.2947683-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series cleans up the RAID6 P/Q library to match the recent updates
to the RAID 5 XOR library and other CRC/crypto libraries.  This includes
providing properly documented external interfaces, hiding the internals,
using static_call instead of indirect calls and turning the user space
test suite into an in-kernel kunit test which is also extended to
improve coverage.

Note that this changes registration so that non-priority algorithms are
not registered, which greatly helps with the benchmark time at boot time.
I'd like to encourage all architecture maintainers to see if they can
further optimized this by registering as few as possible algorithms when
there is a clear benefit in optimized or more unrolled implementations.

This series sits on top of the "cleanup the RAID5 XOR library v3" series.

A git tree is also available here:

    git://git.infradead.org/users/hch/misc.git lib-raid6

Gitweb:

    https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/lib-raid6

Changes since v1:
 - fix arm64 objdir != srcdir builds
 - call the kunit module raid6_kunit.ko from the beginning
 - update MAINTAINERS
 - don't require preemptible context and apply the same restrictions as
   the merged version of the XOR API
 - fix the arm64 default in Kconfig
 - pick the last registered (and presumably most optimized) algorithm when
   benchmarking is disabled
 - port over the randomization fixes from the XOR series
 - misc other kunit cleanups
 - require at least 4 devices for RAID6 to skip broken special cases

Diffstat:
 b/Documentation/crypto/async-tx-api.rst           |    4 
 b/MAINTAINERS                                     |    2 
 b/crypto/async_tx/async_pq.c                      |    9 
 b/crypto/async_tx/async_raid6_recov.c             |    9 
 b/drivers/dma/bcm-sba-raid.c                      |    1 
 b/drivers/md/raid5.c                              |    4 
 b/fs/btrfs/raid56.c                               |    8 
 b/fs/btrfs/volumes.c                              |    2 
 b/include/linux/raid/pq.h                         |  233 +------------
 b/include/linux/raid/pq_tables.h                  |   19 +
 b/lib/Kconfig                                     |   11 
 b/lib/Makefile                                    |    1 
 b/lib/raid/Kconfig                                |   33 +
 b/lib/raid/Makefile                               |    2 
 b/lib/raid/raid6/Makefile                         |  126 +++++++
 b/lib/raid/raid6/algos.c                          |  383 ++++++++++++++++++++++
 b/lib/raid/raid6/algos.h                          |   41 ++
 b/lib/raid/raid6/arm/neon.c                       |   23 -
 b/lib/raid/raid6/arm/neon.uc                      |    2 
 b/lib/raid/raid6/arm/pq_arch.h                    |   24 +
 b/lib/raid/raid6/arm/recov_neon.c                 |   27 -
 b/lib/raid/raid6/arm/recov_neon_inner.c           |    2 
 b/lib/raid/raid6/arm64/pq_arch.h                  |    1 
 b/lib/raid/raid6/int.uc                           |   10 
 b/lib/raid/raid6/loongarch/loongarch_simd.c       |   31 -
 b/lib/raid/raid6/loongarch/pq_arch.h              |   23 +
 b/lib/raid/raid6/loongarch/recov_loongarch_simd.c |   39 --
 b/lib/raid/raid6/mktables.c                       |   28 -
 b/lib/raid/raid6/powerpc/altivec.uc               |   32 -
 b/lib/raid/raid6/powerpc/pq_arch.h                |   31 +
 b/lib/raid/raid6/powerpc/vpermxor.uc              |   29 -
 b/lib/raid/raid6/recov.c                          |   62 ---
 b/lib/raid/raid6/riscv/pq_arch.h                  |   21 +
 b/lib/raid/raid6/riscv/recov_rvv.c                |   14 
 b/lib/raid/raid6/riscv/rvv.h                      |   26 -
 b/lib/raid/raid6/s390/pq_arch.h                   |   15 
 b/lib/raid/raid6/s390/recov_s390xc.c              |   14 
 b/lib/raid/raid6/s390/s390vx.uc                   |   15 
 b/lib/raid/raid6/tests/Makefile                   |    3 
 b/lib/raid/raid6/tests/raid6_kunit.c              |  321 ++++++++++++++++++
 b/lib/raid/raid6/x86/avx2.c                       |   47 --
 b/lib/raid/raid6/x86/avx512.c                     |   57 +--
 b/lib/raid/raid6/x86/mmx.c                        |   39 --
 b/lib/raid/raid6/x86/pq_arch.h                    |   97 +++++
 b/lib/raid/raid6/x86/recov_avx2.c                 |   22 -
 b/lib/raid/raid6/x86/recov_avx512.c               |   26 -
 b/lib/raid/raid6/x86/recov_ssse3.c                |   23 -
 b/lib/raid/raid6/x86/sse1.c                       |   49 --
 b/lib/raid/raid6/x86/sse2.c                       |   47 --
 lib/raid6/Makefile                                |   83 ----
 lib/raid6/algos.c                                 |  291 ----------------
 lib/raid6/loongarch.h                             |   38 --
 lib/raid6/test/.gitignore                         |    3 
 lib/raid6/test/Makefile                           |  156 --------
 lib/raid6/test/test.c                             |  152 --------
 lib/raid6/x86.h                                   |   75 ----
 56 files changed, 1369 insertions(+), 1517 deletions(-)
