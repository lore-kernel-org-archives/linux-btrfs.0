Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC8E3A5435;
	Mon, 18 May 2026 05:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779081787; cv=none; b=NHxxUVZ3hMfPO7VACO0aLB3hs+zLZKlTg0s8b52lHYttjRfSmdP96QI9/XcF13ZjO4u+v/LXHR2hkVcJ+ww59Nb2Yb3T0gHGSsQfSg39EJNqlQ250RNmQ97mGsJB+uI6sis9+DuNWcsa1oUeonbVXP62tjWQYIY2tTss6GS3ctg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779081787; c=relaxed/simple;
	bh=cK2Kka/WPQ4ifSENkuZ3p3xiVvoKubgCTTpiMsVqVbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCfZ4PWuOGFTzWy2PAJWOPdBN0rtFBPW8BK9chgXdnahbmsDsNBn5kCx1D8PBBhtBrZ9jvhO8EtuJSFEyu9jj8PZ4Iedqec74PyPNur16yxaWR46O1WDU0sisQhhNK+HK5DpRRkVa9jU8ozwLdz2kyFCAt1vcnNZEtc56qy2riQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XUk6/CSp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XUk6/CSp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=llzZsOAsj1trIBaTg3PiOxle1PpEJK0HRw4b69DMNy4=; b=XUk6/CSpfN8h4rJl8JVtcP47jy
	sJ5QsXx4UjIxKPk8V1gjR9SMBT86j3FXoitQomE6S6O/Npzv4htYaH5ZbOfwjMw+hkUZZAeo4Q1A1
	ElMrxP1qRFSl0jCSXEPpqXR5htddZHZ1WZ3ZTotuBx2mvIto3HmrzvClPBJr9qS4T2HVfhnU8JCdx
	WdoqKnp2BafVpMcxINWfq0jlwTbdFX7Xo/a6umJqUpjkRRpVokQjCTo9MAKOjCTPeZ2kRc7+N0Gbf
	r49VF5hKxPT64oO8SSNIE09Gvrl87xu9q3pPhmBGFkY23+hYFOGoqdwmqFBke+vcSy0MP6bsxNWFV
	GbuARqyA==;
Received: from [2001:4bb8:2d1:6fdb:d67d:128c:34ba:85b8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOqR0-0000000EIOD-0WQ9;
	Mon, 18 May 2026 05:22:34 +0000
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
Subject: [PATCH 17/18] raid6_kunit: randomize parameters and increase limits
Date: Mon, 18 May 2026 07:18:00 +0200
Message-ID: <20260518051804.462141-18-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518051804.462141-1-hch@lst.de>
References: <20260518051804.462141-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The current test has double-quadratic behavior in the selection for
the updated ("XORed") disks, and in the selection of updated pointers,
which makes scaling it to more tests difficult.  At the same time it
only ever tests with the maximum number of disks, which leaves a
coverage hole for smaller ones.

Fix this by randomizing the total number, failed disks and regions
to update, and increasing the upper number of tests disks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
---
 lib/raid/raid6/tests/raid6_kunit.c | 189 ++++++++++++++++++++---------
 1 file changed, 131 insertions(+), 58 deletions(-)

diff --git a/lib/raid/raid6/tests/raid6_kunit.c b/lib/raid/raid6/tests/raid6_kunit.c
index 152d5d1c3a88..71adf8932e93 100644
--- a/lib/raid/raid6/tests/raid6_kunit.c
+++ b/lib/raid/raid6/tests/raid6_kunit.c
@@ -8,18 +8,21 @@
 #include <kunit/test.h>
 #include <linux/prandom.h>
 #include <linux/vmalloc.h>
+#include <linux/raid/pq.h>
 #include "../algos.h"
 
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 
 #define RAID6_KUNIT_SEED		42
+#define RAID6_KUNIT_NUM_TEST_ITERS	10
+#define RAID6_KUNIT_MAX_BUFFERS		64 /* Including P and Q */
 #define RAID6_KUNIT_MAX_FAILURES	2
-
-#define NDISKS		16	/* Including P and Q */
+#define RAID6_KUNIT_MAX_BYTES		PAGE_SIZE
 
 static struct rnd_state rng;
-static void *test_buffers[NDISKS];
+static void *test_buffers[RAID6_KUNIT_MAX_BUFFERS];
 static void *test_recov_buffers[RAID6_KUNIT_MAX_FAILURES];
+static size_t test_buflen;
 
 struct test_args {
 	unsigned int recov_idx;
@@ -30,102 +33,171 @@ struct test_args {
 
 static struct test_args args;
 
+static u32 rand32(void)
+{
+	return prandom_u32_state(&rng);
+}
+
+/* Generate a random length that is a multiple of 512. */
+static unsigned int random_length(unsigned int max_length)
+{
+	return round_up((rand32() % max_length) + 1, 512);
+}
+
+static unsigned int random_nr_buffers(void)
+{
+	return (rand32() % (RAID6_KUNIT_MAX_BUFFERS - (RAID6_MIN_DISKS - 1))) +
+			RAID6_MIN_DISKS;
+}
+
 static void makedata(int start, int stop)
 {
 	int i;
 
 	for (i = start; i <= stop; i++)
-		prandom_bytes_state(&rng, test_buffers[i], PAGE_SIZE);
+		prandom_bytes_state(&rng, test_buffers[i], test_buflen);
 }
 
-static char member_type(int d)
+static char member_type(unsigned int nr_buffers, int d)
 {
-	switch (d) {
-	case NDISKS-2:
+	if (d == nr_buffers - 2)
 		return 'P';
-	case NDISKS-1:
+	if (d == nr_buffers - 1)
 		return 'Q';
-	default:
-		return 'D';
-	}
+	return 'D';
 }
 
-static void test_recover(struct kunit *test, int faila, int failb)
+static void test_recover_one(struct kunit *test, unsigned int nr_buffers,
+		unsigned int len, int faila, int failb)
 {
 	const struct test_args *ta = test->param_value;
-	void *dataptrs[NDISKS];
+	void *dataptrs[RAID6_KUNIT_MAX_BUFFERS];
 	int i;
 
+	if (faila > failb)
+		swap(faila, failb);
+
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
-		memset(test_recov_buffers[i], 0xf0, PAGE_SIZE);
+		memset(test_recov_buffers[i], 0xf0, test_buflen);
 
 	memcpy(dataptrs, test_buffers, sizeof(dataptrs));
 	dataptrs[faila] = test_recov_buffers[0];
 	dataptrs[failb] = test_recov_buffers[1];
 
-	if (failb == NDISKS - 1) {
+	if (failb == nr_buffers - 1) {
 		/*
 		 * We don't implement the data+Q failure scenario, since it
 		 * is equivalent to a RAID-5 failure (XOR, then recompute Q).
 		 */
-		if (faila != NDISKS - 2)
+		if (WARN_ON_ONCE(faila != nr_buffers - 2))
 			return;
 
 		/* P+Q failure.  Just rebuild the syndrome. */
-		ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, dataptrs);
-	} else if (failb == NDISKS - 2) {
+		ta->gen->gen_syndrome(nr_buffers, len, dataptrs);
+	} else if (failb == nr_buffers - 2) {
 		/* data+P failure. */
-		ta->recov->datap(NDISKS, PAGE_SIZE, faila, dataptrs);
+		ta->recov->datap(nr_buffers, len, faila, dataptrs);
 	} else {
 		/* data+data failure. */
-		ta->recov->data2(NDISKS, PAGE_SIZE, faila, failb, dataptrs);
+		ta->recov->data2(nr_buffers, len, faila, failb, dataptrs);
 	}
 
 	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[faila], test_recov_buffers[0],
-			PAGE_SIZE,
-			"faila miscompared: %3d[%c] (failb=%3d[%c])\n",
-			faila, member_type(faila),
-			failb, member_type(failb));
+			len,
+			"faila miscompared: %3d[%c] buffers %u len %u (failb=%3d[%c])\n",
+			faila, member_type(nr_buffers, faila),
+			nr_buffers, len,
+			failb, member_type(nr_buffers, failb));
 	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[failb], test_recov_buffers[1],
-			PAGE_SIZE,
-			"failb miscompared: %3d[%c] (faila=%3d[%c])\n",
-			failb, member_type(failb),
-			faila, member_type(faila));
+			len,
+			"failb miscompared: %3d[%c] buffers %u len %u (faila=%3d[%c])\n",
+			failb, member_type(nr_buffers, failb),
+			nr_buffers, len,
+			faila, member_type(nr_buffers, faila));
 }
 
-static void raid6_test(struct kunit *test)
+static void test_recover(struct kunit *test, unsigned int nr_buffers,
+		unsigned int len)
+{
+	unsigned int nr_data = nr_buffers - 2;
+	int iterations, i;
+
+	/* Test P+Q recovery */
+	test_recover_one(test, nr_buffers, len, nr_data, nr_buffers - 1);
+
+	/* Test data+P recovery */
+	for (i = 0; i < nr_buffers - 2; i++)
+		test_recover_one(test, nr_buffers, len, i, nr_data);
+
+	/* Double data failure is impossible with a single data disk */
+	if (nr_data == 1)
+		return;
+
+	/* Test data+data recovery using random sampling */
+	iterations = nr_buffers * 2; /* should provide good enough coverage */
+	for (i = 0; i < iterations; i++) {
+		int faila = rand32() % nr_data, failb;
+
+		do {
+			failb = rand32() % nr_data;
+		} while (failb == faila);
+
+		test_recover_one(test, nr_buffers, len, faila, failb);
+	}
+}
+
+/* Simulate rmw run */
+static void test_rmw_one(struct kunit *test, unsigned int nr_buffers,
+		unsigned int len, int p1, int p2)
 {
 	const struct test_args *ta = test->param_value;
-	int i, j, p1, p2;
+
+	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, test_buffers);
+	makedata(p1, p2);
+	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, test_buffers);
+	test_recover(test, nr_buffers, len);
+}
+
+static void test_rmw(struct kunit *test, unsigned int nr_buffers,
+		unsigned int len)
+{
+	int iterations = nr_buffers / 2, i;
+
+	for (i = 0; i < iterations; i++) {
+		int p1 = rand32() % (nr_buffers - 2);
+		int p2 = rand32() % (nr_buffers - 2);
+
+		if (p2 < p1)
+			swap(p1, p2);
+		test_rmw_one(test, nr_buffers, len, p1, p2);
+	}
+}
+
+static void raid6_test_one(struct kunit *test)
+{
+	const struct test_args *ta = test->param_value;
+	unsigned int nr_buffers = random_nr_buffers();
+	unsigned int len = random_length(RAID6_KUNIT_MAX_BYTES);
 
 	/* Nuke syndromes */
-	memset(test_buffers[NDISKS - 2], 0xee, PAGE_SIZE);
-	memset(test_buffers[NDISKS - 1], 0xee, PAGE_SIZE);
+	memset(test_buffers[nr_buffers - 2], 0xee, test_buflen);
+	memset(test_buffers[nr_buffers - 1], 0xee, test_buflen);
 
 	/* Generate assumed good syndrome */
-	ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, test_buffers);
+	ta->gen->gen_syndrome(nr_buffers, len, test_buffers);
 
-	for (i = 0; i < NDISKS - 1; i++)
-		for (j = i + 1; j < NDISKS; j++)
-			test_recover(test, i, j);
+	test_recover(test, nr_buffers, len);
 
-	if (!ta->gen->xor_syndrome)
-		return;
+	if (ta->gen->xor_syndrome)
+		test_rmw(test, nr_buffers, len);
+}
 
-	for (p1 = 0; p1 < NDISKS - 2; p1++) {
-		for (p2 = p1; p2 < NDISKS - 2; p2++) {
-			/* Simulate rmw run */
-			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-					test_buffers);
-			makedata(p1, p2);
-			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-					test_buffers);
-
-			for (i = 0; i < NDISKS - 1; i++)
-				for (j = i + 1; j < NDISKS; j++)
-					test_recover(test, i, j);
-		}
-	}
+static void raid6_test(struct kunit *test)
+{
+	int i;
+
+	for (i = 0; i < RAID6_KUNIT_NUM_TEST_ITERS; i++)
+		raid6_test_one(test);
 }
 
 static const void *raid6_gen_params(struct kunit *test, const void *prev,
@@ -169,23 +241,24 @@ static int raid6_suite_init(struct kunit_suite *suite)
 	 * so that it is immediately followed by a guard page.  This allows
 	 * buffer overreads to be detected, even in assembly code.
 	 */
+	test_buflen = round_up(RAID6_KUNIT_MAX_BYTES, PAGE_SIZE);
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++) {
-		test_recov_buffers[i] = vmalloc(PAGE_SIZE);
+		test_recov_buffers[i] = vmalloc(test_buflen);
 		if (!test_recov_buffers[i])
 			goto out_free_recov_buffers;
 	}
-	for (i = 0; i < NDISKS; i++) {
-		test_buffers[i] = vmalloc(PAGE_SIZE);
+	for (i = 0; i < RAID6_KUNIT_MAX_BUFFERS; i++) {
+		test_buffers[i] = vmalloc(test_buflen);
 		if (!test_buffers[i])
 			goto out_free_buffers;
 	}
 
-	makedata(0, NDISKS - 1);
+	makedata(0, RAID6_KUNIT_MAX_BUFFERS - 1);
 
 	return 0;
 
 out_free_buffers:
-	for (i = 0; i < NDISKS; i++)
+	for (i = 0; i < RAID6_KUNIT_MAX_BUFFERS; i++)
 		vfree(test_buffers[i]);
 	memset(test_buffers, 0, sizeof(test_buffers));
 out_free_recov_buffers:
@@ -199,7 +272,7 @@ static void raid6_suite_exit(struct kunit_suite *suite)
 {
 	int i;
 
-	for (i = 0; i < NDISKS; i++)
+	for (i = 0; i < RAID6_KUNIT_MAX_BUFFERS; i++)
 		vfree(test_buffers[i]);
 	memset(test_buffers, 0, sizeof(test_buffers));
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
-- 
2.53.0

