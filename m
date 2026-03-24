Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB79F3AF662;
	Tue, 24 Mar 2026 06:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774333683; cv=none; b=PwjFcr/E9i+D4UE342vF1LcN8mKbxD8iM1R/+CJ+wsO32zzrBBNa2thNnCNZyXvzp7lHmCS7BPmNM2fNXcT/dJ7gRJlnX2soOmmlZnuNNiBP06JOwpGjpueic7SfqXRgJ1B2iksA+x8lFiZZpY3USi0TtK2UpeoN6bynZ1yxQdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774333683; c=relaxed/simple;
	bh=6r6eqPrE9ADAmPLJe84uZpvKFsGJKznA3wDvSQCSexE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ub8nCU9wWKeegW0Qn+bqlSInAff6WgH+y55uU/nOiWbFy8duR0F/Zb2JR3Xb7DFyUy4vbYvYsGpVTgZYwIIyB93ueksxheOd7Jhm+WhFX5QUmxbOkavB50aZ5dE3BDFTF5+jhI74UQtiBP52y3KXm2VEZusjDih6SWa8Nd2F4oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J3qoXPQB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J3qoXPQB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=x7leLyJg+eSoQFmpHbIkemSZEZJtNueFWjt+KK0UcFM=; b=J3qoXPQBh0LNwK3BZ8W2MzW7Wn
	OuNH1NJn/S+9aRmvFmEzTTtLTLsDHbJ7tAIkw3nR94rLYtdyUK7OzjiZGzgJAt+hA4EqdrrSuOTKW
	fvL0oThRu4JoI2WRxFfSQL1HFA4pF75jSkzleBFqJskiSF8Q9CRF6kp5u/Sy/acOB2nVKphEZtyFx
	MZEBjsrK+M6hsCg4GTiMqxWj4kzvcC9ptnKh0HmWfPbwn5Kvno42tkXIio0kKtmhUqBuvo3CYglv2
	pK5hEpf385IG5zE7Rs3P7J0DbHVhsgonwjHpqPSTFfZKN62U5glZWFSgUBjsjfkd9iXvRiderMMZW
	0pNjXBdQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4vEw-00000000jze-2l0O;
	Tue, 24 Mar 2026 06:27:47 +0000
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
Subject: [PATCH 26/26] xor: add a kunit test case
Date: Tue, 24 Mar 2026 07:22:02 +0100
Message-ID: <20260324062211.3216301-27-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324062211.3216301-1-hch@lst.de>
References: <20260324062211.3216301-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a test case for the XOR routines loosely based on the CRC kunit
test.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/.kunitconfig          |   3 +
 lib/raid/Kconfig               |  11 ++
 lib/raid/xor/Makefile          |   2 +-
 lib/raid/xor/tests/Makefile    |   3 +
 lib/raid/xor/tests/xor_kunit.c | 187 +++++++++++++++++++++++++++++++++
 5 files changed, 205 insertions(+), 1 deletion(-)
 create mode 100644 lib/raid/.kunitconfig
 create mode 100644 lib/raid/xor/tests/Makefile
 create mode 100644 lib/raid/xor/tests/xor_kunit.c

diff --git a/lib/raid/.kunitconfig b/lib/raid/.kunitconfig
new file mode 100644
index 000000000000..351d22ed1954
--- /dev/null
+++ b/lib/raid/.kunitconfig
@@ -0,0 +1,3 @@
+CONFIG_KUNIT=y
+CONFIG_BTRFS_FS=y
+CONFIG_XOR_KUNIT_TEST=y
diff --git a/lib/raid/Kconfig b/lib/raid/Kconfig
index 2ccf0c60de01..1fc4b00e0d71 100644
--- a/lib/raid/Kconfig
+++ b/lib/raid/Kconfig
@@ -17,3 +17,14 @@ config XOR_BLOCKS_ARCH
 	default y if X86_32
 	default y if X86_64
 	bool
+
+config XOR_KUNIT_TEST
+	tristate "KUnit tests for xor_gen" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	depends on XOR_BLOCKS
+	default KUNIT_ALL_TESTS
+	help
+	  Unit tests for the XOR library functions.
+
+	  This is intended to help people writing architecture-specific
+	  optimized versions.  If unsure, say N.
diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index df55823c4d82..4d633dfd5b90 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -29,7 +29,7 @@ xor-$(CONFIG_SPARC64)		+= sparc/xor-sparc64.o sparc/xor-sparc64-glue.o
 xor-$(CONFIG_S390)		+= s390/xor.o
 xor-$(CONFIG_X86_32)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-mmx.o
 xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o
-
+obj-y				+= tests/
 
 CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
 CFLAGS_REMOVE_arm/xor-neon.o	+= $(CC_FLAGS_NO_FPU)
diff --git a/lib/raid/xor/tests/Makefile b/lib/raid/xor/tests/Makefile
new file mode 100644
index 000000000000..661e8f6ffd1f
--- /dev/null
+++ b/lib/raid/xor/tests/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_XOR_KUNIT_TEST) += xor_kunit.o
diff --git a/lib/raid/xor/tests/xor_kunit.c b/lib/raid/xor/tests/xor_kunit.c
new file mode 100644
index 000000000000..01cbdf44f6b0
--- /dev/null
+++ b/lib/raid/xor/tests/xor_kunit.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Unit test the XOR library functions.
+ *
+ * Copyright 2024 Google LLC
+ * Copyright 2026 Christoph Hellwig
+ *
+ * Based on the CRC tests by Eric Biggers <ebiggers@google.com>.
+ */
+#include <kunit/test.h>
+#include <linux/prandom.h>
+#include <linux/string_choices.h>
+#include <linux/vmalloc.h>
+#include <linux/raid/xor.h>
+
+#define XOR_KUNIT_SEED			42
+#define XOR_KUNIT_MAX_BYTES		16384
+#define XOR_KUNIT_MAX_BUFFERS		64
+#define XOR_KUNIT_NUM_TEST_ITERS	1000
+
+static struct rnd_state rng;
+static void *test_buffers[XOR_KUNIT_MAX_BUFFERS];
+static void *test_dest;
+static void *test_ref;
+static size_t test_buflen;
+
+static u32 rand32(void)
+{
+	return prandom_u32_state(&rng);
+}
+
+/* Reference implementation using dumb byte-wise XOR */
+static void xor_ref(void *dest, void **srcs, unsigned int src_cnt,
+		unsigned int bytes)
+{
+	unsigned int off, idx;
+	u8 *d = dest;
+
+	for (off = 0; off < bytes; off++) {
+		for (idx = 0; idx < src_cnt; idx++) {
+			u8 *src = srcs[idx];
+
+			d[off] ^= src[off];
+		}
+	}
+}
+
+/* Generate a random length that is a multiple of 512. */
+static unsigned int random_length(unsigned int max_length)
+{
+	return (rand32() % (max_length + 1)) & ~511;
+}
+
+/* Generate a random alignment that is a multiple of 64. */
+static unsigned int random_alignment(unsigned int max_alignment)
+{
+	return (rand32() % (max_alignment + 1)) & ~63;
+}
+
+static void xor_generate_random_data(void)
+{
+	int i;
+
+	prandom_bytes_state(&rng, test_dest, test_buflen);
+	memcpy(test_ref, test_dest, test_buflen);
+	for (i = 0; i < XOR_KUNIT_MAX_BUFFERS; i++)
+		prandom_bytes_state(&rng, test_buffers[i], test_buflen);
+}
+
+/* Test that xor_gen gives the same result as a reference implementation. */
+static void xor_test(struct kunit *test)
+{
+	void *aligned_buffers[XOR_KUNIT_MAX_BUFFERS];
+	size_t i;
+
+	for (i = 0; i < XOR_KUNIT_NUM_TEST_ITERS; i++) {
+		unsigned int nr_buffers =
+			(rand32() % XOR_KUNIT_MAX_BUFFERS) + 1;
+		unsigned int len = random_length(XOR_KUNIT_MAX_BYTES);
+		unsigned int max_alignment, align = 0;
+		void *buffers;
+
+		if (rand32() % 8 == 0)
+			/* Refresh the data occasionally. */
+			xor_generate_random_data();
+
+		/*
+		 * If we're not using the entire buffer size, inject randomize
+		 * alignment into the buffer.
+		 */
+		max_alignment = XOR_KUNIT_MAX_BYTES - len;
+		if (max_alignment == 0) {
+			buffers = test_buffers;
+		} else if (rand32() % 2 == 0) {
+			/* Use random alignments mod 64 */
+			int j;
+
+			for (j = 0; j < nr_buffers; j++)
+				aligned_buffers[j] = test_buffers[j] +
+					random_alignment(max_alignment);
+			buffers = aligned_buffers;
+			align = random_alignment(max_alignment);
+		} else {
+			/* Go up to the guard page, to catch buffer overreads */
+			int j;
+
+			align = test_buflen - len;
+			for (j = 0; j < nr_buffers; j++)
+				aligned_buffers[j] = test_buffers[j] + align;
+			buffers = aligned_buffers;
+		}
+
+		/*
+		 * Compute the XOR, and verify that it equals the XOR computed
+		 * by a simple byte-at-a-time reference implementation.
+		 */
+		xor_ref(test_ref + align, buffers, nr_buffers, len);
+		xor_gen(test_dest + align, buffers, nr_buffers, len);
+		KUNIT_EXPECT_MEMEQ_MSG(test, test_ref + align,
+				test_dest + align, len,
+				"Wrong result with buffers=%u, len=%u, unaligned=%s, at_end=%s",
+				nr_buffers, len,
+				str_yes_no(max_alignment),
+				str_yes_no(align + len == test_buflen));
+	}
+}
+
+static struct kunit_case xor_test_cases[] = {
+	KUNIT_CASE(xor_test),
+	{},
+};
+
+static int xor_suite_init(struct kunit_suite *suite)
+{
+	int i;
+
+	/*
+	 * Allocate the test buffer using vmalloc() with a page-aligned length
+	 * so that it is immediately followed by a guard page.  This allows
+	 * buffer overreads to be detected, even in assembly code.
+	 */
+	test_buflen = round_up(XOR_KUNIT_MAX_BYTES, PAGE_SIZE);
+	test_ref = vmalloc(test_buflen);
+	if (!test_ref)
+		return -ENOMEM;
+	test_dest = vmalloc(test_buflen);
+	if (!test_dest)
+		goto out_free_ref;
+	for (i = 0; i < XOR_KUNIT_MAX_BUFFERS; i++) {
+		test_buffers[i] = vmalloc(test_buflen);
+		if (!test_buffers[i])
+			goto out_free_buffers;
+	}
+
+	prandom_seed_state(&rng, XOR_KUNIT_SEED);
+	xor_generate_random_data();
+	return 0;
+
+out_free_buffers:
+	while (--i >= 0)
+		vfree(test_buffers[i]);
+	vfree(test_dest);
+out_free_ref:
+	vfree(test_ref);
+	return -ENOMEM;
+}
+
+static void xor_suite_exit(struct kunit_suite *suite)
+{
+	int i;
+
+	vfree(test_ref);
+	vfree(test_dest);
+	for (i = 0; i < XOR_KUNIT_MAX_BUFFERS; i++)
+		vfree(test_buffers[i]);
+}
+
+static struct kunit_suite xor_test_suite = {
+	.name		= "xor",
+	.test_cases	= xor_test_cases,
+	.suite_init	= xor_suite_init,
+	.suite_exit	= xor_suite_exit,
+};
+kunit_test_suite(xor_test_suite);
+
+MODULE_DESCRIPTION("Unit test for the XOR library functions");
+MODULE_LICENSE("GPL");
-- 
2.47.3

