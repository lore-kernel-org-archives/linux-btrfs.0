Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F114E38839C;
	Mon, 18 May 2026 05:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779081222; cv=none; b=SIiL7t2+Houvx3ks8kmBHe3zh3u2I57mS9Pyh/2CGVspQpj/ElgIzL1DeBuKygz9B5K/OWEfcM8aTLxqkq4+9mHzg+KaHNlKsK/ShmcXYFI/gQnv4fxTZjbuYsfTEjdSGCyH9WnXGZHVyl+wnZ6z09ituW2+Yj5jVbrjEmqAb1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779081222; c=relaxed/simple;
	bh=xiXbpGc3cH880F0KQgf8lTe4sSkfOWhUgy6kqg4t9ts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i2RRKHmcOyFQlCFgRiuy8PPWo8uYV4BtqiKakqjyVWBztljeYEXUHB7ob4nafHimfzeLZo266KgJKG3S+5fpEBSERLHXUcSnv5hiSINb9lspLraELtiNvOWkaDJivpreBZi9C3dsDMkCiQ69pHfVCHIe+/0/WdJ63afIsc5AiJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TtvMKkCV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TtvMKkCV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=dwab+Vrf0RkpX4kATklkT0WVGxtwKqB/2sp1x4ycw+I=; b=TtvMKkCVKX8F1XjnNoVlVmjlsh
	TOkOte9uM/oWcQYTXmmP+Qdkqy7SnToekolWUTFbQyBZqLCJAN6dydWWZY/ptCmK9mCdw9EqA8fio
	1yvno4D5TbD9QSoMLofwFQ64vTO9OpN11SU//ZiIKEInvnDJbEm9dE7/hQnXDJLsT3d1vhajUcrmB
	tEfyWvqz93hE4uSUnR5XT+sy9eVnSUSgsNjfuE+tG0d3mc3gxMbTUsOe0k2HKxW1KxIlEEVfcshJ2
	T5SjhKhlQoVBJapQf59Z2PxRtdwD8p4/EL6qrAPEtFDG/wVrdihKXThORl1qStxgEKOiUrQ9CLPAn
	GYyfyzbw==;
Received: from [213.208.157.211] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOqHi-0000000EERm-1Mpl;
	Mon, 18 May 2026 05:12:58 +0000
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
Subject: cleanup the RAID6 P/Q library v3
Date: Mon, 18 May 2026 07:12:19 +0200
Message-ID: <20260518051245.451860-1-hch@lst.de>
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

Changes since v2:
 - merge two patches that should have been one
 - split out enforcing the 4-device minimum into a well-documented patch
   explaining the rationale
 - drop the btrfs patch to restrict the number of devices again
 - fix them module description for the kunit test
 - add -I $(src) to fix out of srctree builds for architectures with
   headers in the architecture-specific directories
 - always add the least optimized/unrolled algorithms first to keep the
   existing no-benchmark behavior
 - drop the delayed benchmarking for now to avoid corner cases
 - improve a few commit messages

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
 b/include/linux/raid/pq.h                         |  216 ------------
 b/include/linux/raid/pq_tables.h                  |   19 +
 b/lib/Kconfig                                     |   11 
 b/lib/Makefile                                    |    1 
 b/lib/raid/Kconfig                                |   33 +
 b/lib/raid/Makefile                               |    2 
 b/lib/raid/raid6/Makefile                         |  128 +++++++
 b/lib/raid/raid6/algos.c                          |  377 ++++++++++++++++++++++
 b/lib/raid/raid6/algos.h                          |   41 ++
 b/lib/raid/raid6/arm/neon.c                       |   23 -
 b/lib/raid/raid6/arm/neon.uc                      |    2 
 b/lib/raid/raid6/arm/pq_arch.h                    |   21 +
 b/lib/raid/raid6/arm/recov_neon.c                 |   27 -
 b/lib/raid/raid6/arm/recov_neon_inner.c           |    2 
 b/lib/raid/raid6/arm64/pq_arch.h                  |    1 
 b/lib/raid/raid6/int.uc                           |   10 
 b/lib/raid/raid6/loongarch/loongarch_simd.c       |   31 -
 b/lib/raid/raid6/loongarch/pq_arch.h              |   23 +
 b/lib/raid/raid6/loongarch/recov_loongarch_simd.c |   39 --
 b/lib/raid/raid6/mktables.c                       |   28 -
 b/lib/raid/raid6/powerpc/altivec.uc               |   32 -
 b/lib/raid/raid6/powerpc/pq_arch.h                |   32 +
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
 b/lib/raid/raid6/x86/pq_arch.h                    |   96 +++++
 b/lib/raid/raid6/x86/recov_avx2.c                 |   22 -
 b/lib/raid/raid6/x86/recov_avx512.c               |   26 -
 b/lib/raid/raid6/x86/recov_ssse3.c                |   23 -
 b/lib/raid/raid6/x86/sse1.c                       |   49 --
 b/lib/raid/raid6/x86/sse2.c                       |   47 --
 lib/raid6/Makefile                                |   83 ----
 lib/raid6/algos.c                                 |  291 ----------------
 lib/raid6/loongarch.h                             |   38 --
 lib/raid6/test/.gitignore                         |    3 
 lib/raid6/test/Makefile                           |  156 ---------
 lib/raid6/test/test.c                             |  152 --------
 lib/raid6/x86.h                                   |   75 ----
 55 files changed, 1349 insertions(+), 1511 deletions(-)
