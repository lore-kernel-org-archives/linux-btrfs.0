Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E327F3A3E84;
	Mon, 18 May 2026 05:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779081795; cv=none; b=ibJwRLH0CXl9aEnJdH02eHH6AJOjYUZgWWpZv/CcyjKI09AXkD0oqBsaPdIEz7q14bqCLG/xMcQs5gl8c5Ed5A3LdAQMQKwH9aV47e2wP0G9Zjj7PsDUIqZIbjGsblqQmYKxTRnkkf+oF71U64YURlEJSwhxjV9lo2brY/PedlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779081795; c=relaxed/simple;
	bh=LXimcR5gIrhc7Ja9lMnRXbnWWKmMZAfemq2OZySt2vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPJfSG0UOCX6UVpBen/jVveM/+mjExbnWhOfwZ0X/8cSKoSDwaDMcwz4TA/nfsrhu8ujEtQG7tJKpUelhgXyq33XW7uXGIfQqKnrhqqZrhxwH79KJys+ezu9p2vVZvhYGynlujx5WKRSajnKLQU+78JKVWO5IQCXDQyLJkaG0Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cN+bAsg8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cN+bAsg8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TUDBo9mJANsgA73DQyJ8kF+exXqX/GsyGWAfqYV6YAM=; b=cN+bAsg8yfx0NrYdBtuwk+NdJw
	5dyD4ypIeZQ5a1P94iQ7KZrQJB7LYNNJT8rzKpM9SazFc+gkcEGcV9gE+t3Jj1RNwchZpXw5nqE8a
	cJlBsDsZadvIOIWgThLZtGMb6DDChULMTDc2c54FVfgUyCL48ZHUB4NbQAxAlcYevr1GOM9HzUN2G
	njymcwbqFde7bppHF0vfeccleKLEh0O9qCBbTG+Y6+jRwWykMxDjWz6oAf8wabBERWknTDlLCT0xA
	MmDVY9Ng/W9laPrY/fXpjScQ8u/6hzQbtpL6dHM0sYfnKzWjLQ5X9GCTh1eLkEQfXr1acT+WgFKE5
	H4ew+Qlg==;
Received: from [2001:4bb8:2d1:6fdb:d67d:128c:34ba:85b8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOqRD-0000000EIZD-1P94;
	Mon, 18 May 2026 05:22:47 +0000
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
Subject: [PATCH 18/18] raid6_kunit: randomize buffer alignment
Date: Mon, 18 May 2026 07:18:01 +0200
Message-ID: <20260518051804.462141-19-hch@lst.de>
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

Add code to add random alignment to the buffers to test the case where
they are not page aligned, and to move the buffers to the end of the
allocation so that they are next to the vmalloc guard page.

This does not include the recovery buffers as the recovery requires
page alignment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
---
 lib/raid/raid6/tests/raid6_kunit.c | 41 +++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/lib/raid/raid6/tests/raid6_kunit.c b/lib/raid/raid6/tests/raid6_kunit.c
index 71adf8932e93..9f3e671a1224 100644
--- a/lib/raid/raid6/tests/raid6_kunit.c
+++ b/lib/raid/raid6/tests/raid6_kunit.c
@@ -21,6 +21,7 @@ MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 
 static struct rnd_state rng;
 static void *test_buffers[RAID6_KUNIT_MAX_BUFFERS];
+static void *aligned_buffers[RAID6_KUNIT_MAX_BUFFERS];
 static void *test_recov_buffers[RAID6_KUNIT_MAX_FAILURES];
 static size_t test_buflen;
 
@@ -50,6 +51,14 @@ static unsigned int random_nr_buffers(void)
 			RAID6_MIN_DISKS;
 }
 
+/* Generate a random alignment that is a multiple of 64. */
+static unsigned int random_alignment(unsigned int max_alignment)
+{
+	if (max_alignment == 0)
+		return 0;
+	return (rand32() % (max_alignment + 1)) & ~63;
+}
+
 static void makedata(int start, int stop)
 {
 	int i;
@@ -80,7 +89,7 @@ static void test_recover_one(struct kunit *test, unsigned int nr_buffers,
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
 		memset(test_recov_buffers[i], 0xf0, test_buflen);
 
-	memcpy(dataptrs, test_buffers, sizeof(dataptrs));
+	memcpy(dataptrs, aligned_buffers, sizeof(dataptrs));
 	dataptrs[faila] = test_recov_buffers[0];
 	dataptrs[failb] = test_recov_buffers[1];
 
@@ -102,13 +111,13 @@ static void test_recover_one(struct kunit *test, unsigned int nr_buffers,
 		ta->recov->data2(nr_buffers, len, faila, failb, dataptrs);
 	}
 
-	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[faila], test_recov_buffers[0],
+	KUNIT_EXPECT_MEMEQ_MSG(test, aligned_buffers[faila], dataptrs[faila],
 			len,
 			"faila miscompared: %3d[%c] buffers %u len %u (failb=%3d[%c])\n",
 			faila, member_type(nr_buffers, faila),
 			nr_buffers, len,
 			failb, member_type(nr_buffers, failb));
-	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[failb], test_recov_buffers[1],
+	KUNIT_EXPECT_MEMEQ_MSG(test, aligned_buffers[failb], dataptrs[failb],
 			len,
 			"failb miscompared: %3d[%c] buffers %u len %u (faila=%3d[%c])\n",
 			failb, member_type(nr_buffers, failb),
@@ -152,9 +161,9 @@ static void test_rmw_one(struct kunit *test, unsigned int nr_buffers,
 {
 	const struct test_args *ta = test->param_value;
 
-	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, test_buffers);
+	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, aligned_buffers);
 	makedata(p1, p2);
-	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, test_buffers);
+	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, aligned_buffers);
 	test_recover(test, nr_buffers, len);
 }
 
@@ -178,13 +187,33 @@ static void raid6_test_one(struct kunit *test)
 	const struct test_args *ta = test->param_value;
 	unsigned int nr_buffers = random_nr_buffers();
 	unsigned int len = random_length(RAID6_KUNIT_MAX_BYTES);
+	unsigned int max_alignment;
+	int i;
 
 	/* Nuke syndromes */
 	memset(test_buffers[nr_buffers - 2], 0xee, test_buflen);
 	memset(test_buffers[nr_buffers - 1], 0xee, test_buflen);
 
+	/*
+	 * If we're not using the entire buffer size, inject randomize alignment
+	 * into the buffer.
+	 */
+	max_alignment = RAID6_KUNIT_MAX_BYTES - len;
+	if (rand32() % 2 == 0) {
+		/* Use random alignments mod 64 */
+		for (i = 0; i < nr_buffers; i++)
+			aligned_buffers[i] = test_buffers[i] +
+				random_alignment(max_alignment);
+	} else {
+		/* Go up to the guard page, to catch buffer overreads */
+		unsigned int align = test_buflen - len;
+
+		for (i = 0; i < nr_buffers; i++)
+			aligned_buffers[i] = test_buffers[i] + align;
+	}
+
 	/* Generate assumed good syndrome */
-	ta->gen->gen_syndrome(nr_buffers, len, test_buffers);
+	ta->gen->gen_syndrome(nr_buffers, len, aligned_buffers);
 
 	test_recover(test, nr_buffers, len);
 
-- 
2.53.0

