Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5F33F0A8E;
	Tue, 24 Mar 2026 06:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774334705; cv=none; b=imnvzQjMRlhM+GBEk+7Y347j9XNdlilO4c1QJsuVnsufnIa6LSRDFe/HZxy6B98pplwu2Y7MEh8z2SlilGmT6/hnk+V9B5uHrPa9GUMazwpIKG9t5zUxV3ffCcga4ZDcN0y/wUqPa8daHoQ424df7JeSRCV79LnzgrEqYrLo3Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774334705; c=relaxed/simple;
	bh=A17doW2CerQkmDN/LJVQrDHVc7hbAlk5qO74m35CUow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcZtf43v0SWzDrTsQRbLNx90YPi44m9kC8ZOfMnyq/sIhAvnHg6P0j46VJ2b6h8uBxGF9l4epybHl6Tsfq5wX5ETwjtcwZ6CUsYLkkSfHjJLILnk9iLCvocedTDIMQvcUbuKtqh6UDWJ8VsbtPcuRpThSSWhEhDPUBOsRonoUgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=maUwg6ss; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="maUwg6ss"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1qcNMjs/6HgqVDyYip4FGqGPvQZzqVe+4OKCwRy55VI=; b=maUwg6ssEm5qHQqeiwb51d6JZU
	3t+8AOzQk0pTOiQxQW5BqP3NORVAR35CMlckHoIbX9V2tTvJEQv46aV+TXTp8TzyWS45aaRlvsAHU
	3cDvy7TJacxXzIzyEffdxlr9cl95//IsPuhaU9XNW/B/DsMAYcaZME2U+qf6FxtPOTEfl3Qp0wfWy
	ku4j+kn5cF6kbehWxErdFnUXCUSUHGDpzPmqH7XOUMzIKrqU8CObPlJK2TPKnhn4RVZweVqGhANp6
	I9KU28IsmWEV2cTUNTP6MLMn3bMK5SIgX903dLLYX2OgreYmzLhtPmHQgjtfJ1c0nWpB78kNeWaIs
	3Sl++CuA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4vVL-00000000oHJ-1D1y;
	Tue, 24 Mar 2026 06:44:43 +0000
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
Subject: [PATCH 14/17] raid6_kunit: dynamically allocate data buffers using vmalloc
Date: Tue, 24 Mar 2026 07:40:49 +0100
Message-ID: <20260324064115.3217136-15-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324064115.3217136-1-hch@lst.de>
References: <20260324064115.3217136-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use vmalloc for the data buffers instead of using static .data allocations.
This provides for better out of bounds checking and avoids wasting kernel
memory after the test has run.  vmalloc is used instead of kmalloc to
provide for better out of bounds access checking as in other kunit tests.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/raid6/tests/raid6_kunit.c | 75 +++++++++++++++++++++++-------
 1 file changed, 59 insertions(+), 16 deletions(-)

diff --git a/lib/raid/raid6/tests/raid6_kunit.c b/lib/raid/raid6/tests/raid6_kunit.c
index 7095952ad8e3..1793b952a595 100644
--- a/lib/raid/raid6/tests/raid6_kunit.c
+++ b/lib/raid/raid6/tests/raid6_kunit.c
@@ -7,19 +7,20 @@
 
 #include <kunit/test.h>
 #include <linux/prandom.h>
+#include <linux/vmalloc.h>
 #include "../algos.h"
 
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 
 #define RAID6_KUNIT_SEED		42
+#define RAID6_KUNIT_MAX_FAILURES	2
 
 #define NDISKS		16	/* Including P and Q */
 
 static struct rnd_state rng;
 static void *dataptrs[NDISKS];
-static char data[NDISKS][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-static char recovi[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-static char recovj[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+static void *test_buffers[NDISKS];
+static void *test_recov_buffers[RAID6_KUNIT_MAX_FAILURES];
 
 struct test_args {
 	unsigned int recov_idx;
@@ -35,8 +36,8 @@ static void makedata(int start, int stop)
 	int i;
 
 	for (i = start; i <= stop; i++) {
-		prandom_bytes_state(&rng, data[i], PAGE_SIZE);
-		dataptrs[i] = data[i];
+		prandom_bytes_state(&rng, test_buffers[i], PAGE_SIZE);
+		dataptrs[i] = test_buffers[i];
 	}
 }
 
@@ -55,12 +56,13 @@ static char member_type(int d)
 static void test_recover(struct kunit *test, int faila, int failb)
 {
 	const struct test_args *ta = test->param_value;
+	int i;
 
-	memset(recovi, 0xf0, PAGE_SIZE);
-	memset(recovj, 0xba, PAGE_SIZE);
+	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
+		memset(test_recov_buffers[i], 0xf0, PAGE_SIZE);
 
-	dataptrs[faila] = recovi;
-	dataptrs[failb] = recovj;
+	dataptrs[faila] = test_recov_buffers[0];
+	dataptrs[failb] = test_recov_buffers[1];
 
 	if (faila > failb)
 		swap(faila, failb);
@@ -83,18 +85,20 @@ static void test_recover(struct kunit *test, int faila, int failb)
 		ta->recov->data2(NDISKS, PAGE_SIZE, faila, failb, dataptrs);
 	}
 
-	KUNIT_EXPECT_MEMEQ_MSG(test, data[faila], recovi, PAGE_SIZE,
+	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[faila], test_recov_buffers[0],
+			PAGE_SIZE,
 			"faila miscompared: %3d[%c] (failb=%3d[%c])\n",
 			faila, member_type(faila),
 			failb, member_type(failb));
-	KUNIT_EXPECT_MEMEQ_MSG(test, data[failb], recovj, PAGE_SIZE,
+	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[failb], test_recov_buffers[1],
+			PAGE_SIZE,
 			"failb miscompared: %3d[%c] (faila=%3d[%c])\n",
 			failb, member_type(failb),
 			faila, member_type(faila));
 
 skip:
-	dataptrs[faila] = data[faila];
-	dataptrs[failb] = data[failb];
+	dataptrs[faila] = test_buffers[faila];
+	dataptrs[failb] = test_buffers[failb];
 }
 
 static void raid6_test(struct kunit *test)
@@ -103,8 +107,8 @@ static void raid6_test(struct kunit *test)
 	int i, j, p1, p2;
 
 	/* Nuke syndromes */
-	memset(data[NDISKS - 2], 0xee, PAGE_SIZE);
-	memset(data[NDISKS - 1], 0xee, PAGE_SIZE);
+	memset(test_buffers[NDISKS - 2], 0xee, PAGE_SIZE);
+	memset(test_buffers[NDISKS - 1], 0xee, PAGE_SIZE);
 
 	/* Generate assumed good syndrome */
 	ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, (void **)&dataptrs);
@@ -163,16 +167,55 @@ static struct kunit_case raid6_test_cases[] = {
 
 static int raid6_suite_init(struct kunit_suite *suite)
 {
+	int i;
+
 	prandom_seed_state(&rng, RAID6_KUNIT_SEED);
-	makedata(0, NDISKS - 1);
 	memset(&args, 0, sizeof(args));
+
+	/*
+	 * Allocate the test buffer using vmalloc() with a page-aligned length
+	 * so that it is immediately followed by a guard page.  This allows
+	 * buffer overreads to be detected, even in assembly code.
+	 */
+	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++) {
+		test_recov_buffers[i] = vmalloc(PAGE_SIZE);
+		if (!test_recov_buffers[i])
+			goto out_free_recov_buffers;
+	}
+	for (i = 0; i < NDISKS; i++) {
+		test_buffers[i] = vmalloc(PAGE_SIZE);
+		if (!test_buffers[i])
+			goto out_free_buffers;
+	}
+
+	makedata(0, NDISKS - 1);
+
 	return 0;
+
+out_free_buffers:
+	for (i = 0; i < NDISKS; i++)
+		vfree(test_buffers[i]);
+out_free_recov_buffers:
+	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
+		vfree(test_recov_buffers[i]);
+	return -ENOMEM;
+}
+
+static void raid6_suite_exit(struct kunit_suite *suite)
+{
+	int i;
+
+	for (i = 0; i < NDISKS; i++)
+		vfree(test_buffers[i]);
+	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
+		vfree(test_recov_buffers[i]);
 }
 
 static struct kunit_suite raid6_test_suite = {
 	.name		= "raid6",
 	.test_cases	= raid6_test_cases,
 	.suite_init	= raid6_suite_init,
+	.suite_exit	= raid6_suite_exit,
 };
 kunit_test_suite(raid6_test_suite);
 
-- 
2.47.3

