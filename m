Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE66E36D9F1;
	Fri, 27 Mar 2026 06:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592344; cv=none; b=U1H8+5lsK4J2yICvI6GFnwJ6uMeLhKMcayfPT0E+KuhNv4Q9BxwJypVZDvny/QjfE/x8P8mm7BULGNCJpOBPF/T/ZIIXG/Q7CvFnVeHepVfSOWEIKMgWR7BSWMfFQpIiXpGN7RNtTivBF5R0HSumbcQGivZcWugw31gpqQKBkqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592344; c=relaxed/simple;
	bh=BifARZXSftWdO9hfP3qfSEVzFLHG2PG2J8BDVrSmCzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsUrHTwAxRJVod3b+PhuVne0tBTl80DfDD5c9fxPK4oW2r+j1x83m3XgyzPeWKQglbe9bSZ6LIV+m405bGobYMrwjrfO3V8R1XfSrXwliVp/LqeG124CTGO5saVX018KFK6AZLI0iwVwmkl1NqDiLPVikGxa9ZPBYJHecc80krw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EGJnD6cl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EGJnD6cl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=O6va2IgTMiqnAT/Kurlve9FMTRmwTjwBvna18czcjgs=; b=EGJnD6clY8iGs/MP3dixt2T3c2
	AVEDWxeHpVCZYASsR/vwHR7//4Xz3kGLlqybD3wuN+4HnS7GWSlGjoXb+Ml/G5a0qAMG5dMTMFCyP
	gpOdikNCR6kFERiRtNs99a5yDaf9e36QYo7HNVk4qcOwjG56QV1ajNmtlbRlrusTlSVy9Tqvd03VL
	1jWxj8BS8J2vQXJ4W7RaB2fintRi5n5x/GuiyRZ7+bjg56VUJMXCq73p3ZgHq5Fjloxm8XmqHsX/b
	zyv2AAm2R7Q/w39FRPw7UZNErIKWnRvUYUSgLz+R/yQALtOMuo/LDGYg3NDQUfaNKslS991bFfWOo
	QCQKnAHg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Ws-00000006kwY-0CTs;
	Fri, 27 Mar 2026 06:18:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: [PATCH 05/28] xor: move to lib/raid/
Date: Fri, 27 Mar 2026 07:16:37 +0100
Message-ID: <20260327061704.3707577-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327061704.3707577-1-hch@lst.de>
References: <20260327061704.3707577-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the RAID XOR code to lib/raid/ as it has nothing to do with the
crypto API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 crypto/Kconfig                          | 2 --
 crypto/Makefile                         | 1 -
 lib/Kconfig                             | 1 +
 lib/Makefile                            | 2 +-
 lib/raid/Kconfig                        | 4 ++++
 lib/raid/Makefile                       | 3 +++
 lib/raid/xor/Makefile                   | 5 +++++
 crypto/xor.c => lib/raid/xor/xor-core.c | 0
 8 files changed, 14 insertions(+), 4 deletions(-)
 create mode 100644 lib/raid/Kconfig
 create mode 100644 lib/raid/Makefile
 create mode 100644 lib/raid/xor/Makefile
 rename crypto/xor.c => lib/raid/xor/xor-core.c (100%)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b4bb85e8e226..97d73136a0b4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -2,8 +2,6 @@
 #
 # Generic algorithms support
 #
-config XOR_BLOCKS
-	tristate
 
 #
 # async_tx api: hardware offloaded memory transfer/transform support
diff --git a/crypto/Makefile b/crypto/Makefile
index 04e269117589..795c2eea51fe 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -196,7 +196,6 @@ obj-$(CONFIG_CRYPTO_ECRDSA) += ecrdsa_generic.o
 #
 # generic algorithms and the async_tx api
 #
-obj-$(CONFIG_XOR_BLOCKS) += xor.o
 obj-$(CONFIG_ASYNC_CORE) += async_tx/
 obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys/
 crypto_simd-y := simd.o
diff --git a/lib/Kconfig b/lib/Kconfig
index 0f2fb9610647..5be57adcd454 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -138,6 +138,7 @@ config TRACE_MMIO_ACCESS
 
 source "lib/crc/Kconfig"
 source "lib/crypto/Kconfig"
+source "lib/raid/Kconfig"
 
 config XXHASH
 	tristate
diff --git a/lib/Makefile b/lib/Makefile
index 1b9ee167517f..84da412a044f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -120,7 +120,7 @@ endif
 obj-$(CONFIG_DEBUG_INFO_REDUCED) += debug_info.o
 CFLAGS_debug_info.o += $(call cc-option, -femit-struct-debug-detailed=any)
 
-obj-y += math/ crc/ crypto/ tests/ vdso/
+obj-y += math/ crc/ crypto/ tests/ vdso/ raid/
 
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
diff --git a/lib/raid/Kconfig b/lib/raid/Kconfig
new file mode 100644
index 000000000000..01b73a1c303f
--- /dev/null
+++ b/lib/raid/Kconfig
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+
+config XOR_BLOCKS
+	tristate
diff --git a/lib/raid/Makefile b/lib/raid/Makefile
new file mode 100644
index 000000000000..3540fe846dc4
--- /dev/null
+++ b/lib/raid/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-y				+= xor/
diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
new file mode 100644
index 000000000000..7bca0ce8e90a
--- /dev/null
+++ b/lib/raid/xor/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_XOR_BLOCKS)	+= xor.o
+
+xor-y				+= xor-core.o
diff --git a/crypto/xor.c b/lib/raid/xor/xor-core.c
similarity index 100%
rename from crypto/xor.c
rename to lib/raid/xor/xor-core.c
-- 
2.47.3

