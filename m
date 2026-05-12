Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93943033DE;
	Tue, 12 May 2026 05:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778563538; cv=none; b=Ds+WK0OAAUwB5I/KwbshY875xuEujrSSebcHqCk4JhXO17u9Oenb4JFVrmSdDOU/yJg30U+KfNukgQY/tVA2BY2iV8EAYbvzt7lv6tdF0F4ncbTtgUnDEYa+AK8EQx1mESeuR96/DmJNYthqOUFwnPHJUy3rVTMYtHj57Faa7jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778563538; c=relaxed/simple;
	bh=DDQTJP3afdIC7tTyI9bkets9IDfx+aaQ3TxktSGnCIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P960mJCblxLUFMhCROtoABY69ROU68bGT4MMCPHuaMjU81F6iMmiAiZLa5KCxpWgkOrxpkZGhAqeTdzQ49aBr92Faoa+Y2csSfrJFjH6vTf+NQVWF0BH2Mp02L/mdiLkOEPiX2+ZYKr4LBGdTmlpalQ1rlFmOdgILzD9473PWl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PZHyH5Jh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PZHyH5Jh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3Cb9Hbl27gLFqCi4pjUlrvz/YqmwwyaUp1VWgi6500I=; b=PZHyH5JhEcZLJzDY5KNP+Gio0k
	q8tIOiuVuyQnLX52dlKhSXFOeYg5oaqv/6i4fkuxjDsiTkJiOSNqRDNNyntxan4TAFxpynd3nsHrG
	ydJdwez1ItC7kEtk7Fe6W0Pjsxf4eHDN9kH1pxlDUM2jW+aLDT6z08LOcCIJXPIelheo7vuvQauC3
	w65bOvjoq8hX75L0v4qLwbJdnIwpsNy8L7QpEzeXTGc35JtA8Y7Dt/kyBQp0JGzJJEu2W2lGfCDti
	SybawJ3LuB9sDws3V0Lx9HI+JNO/JaWe1WGWJ8eQ/KX2uIPuR4ReZBfmFr2HEfabwXCU91QRZsDCI
	4mHvAjBw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfcN-0000000FcaV-3M01;
	Tue, 12 May 2026 05:25:20 +0000
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
Subject: [PATCH 14/19] raid6_kunit: use KUNIT_CASE_PARAM
Date: Tue, 12 May 2026 07:20:54 +0200
Message-ID: <20260512052230.2947683-15-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512052230.2947683-1-hch@lst.de>
References: <20260512052230.2947683-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The raid6 test combines various generation and recovery algorithms.  Use
KUNIT_CASE_PARAM and provide a generator that iterates over the possible
combinations instead of looping inside a single test instance.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/raid6/tests/raid6_kunit.c | 120 ++++++++++++++++-------------
 1 file changed, 68 insertions(+), 52 deletions(-)

diff --git a/lib/raid/raid6/tests/raid6_kunit.c b/lib/raid/raid6/tests/raid6_kunit.c
index daaa28e96ff1..f55b081b6b13 100644
--- a/lib/raid/raid6/tests/raid6_kunit.c
+++ b/lib/raid/raid6/tests/raid6_kunit.c
@@ -21,6 +21,15 @@ static char data[NDISKS][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 static char recovi[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 static char recovj[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
+struct test_args {
+	unsigned int recov_idx;
+	const struct raid6_recov_calls *recov;
+	unsigned int gen_idx;
+	const struct raid6_calls *gen;
+};
+
+static struct test_args args;
+
 static void makedata(int start, int stop)
 {
 	int i;
@@ -43,9 +52,10 @@ static char member_type(int d)
 	}
 }
 
-static void test_disks(struct kunit *test, const struct raid6_calls *calls,
-		const struct raid6_recov_calls *ra, int faila, int failb)
+static void test_recover(struct kunit *test, int faila, int failb)
 {
+	const struct test_args *ta = test->param_value;
+
 	memset(recovi, 0xf0, PAGE_SIZE);
 	memset(recovj, 0xba, PAGE_SIZE);
 
@@ -61,25 +71,23 @@ static void test_disks(struct kunit *test, const struct raid6_calls *calls,
 			goto skip;
 
 		/* P+Q failure.  Just rebuild the syndrome. */
-		calls->gen_syndrome(NDISKS, PAGE_SIZE, dataptrs);
+		ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, dataptrs);
 	} else if (failb == NDISKS - 2) {
 		/* data+P failure. */
-		ra->datap(NDISKS, PAGE_SIZE, faila, dataptrs);
+		ta->recov->datap(NDISKS, PAGE_SIZE, faila, dataptrs);
 	} else {
 		/* data+data failure. */
-		ra->data2(NDISKS, PAGE_SIZE, faila, failb, dataptrs);
+		ta->recov->data2(NDISKS, PAGE_SIZE, faila, failb, dataptrs);
 	}
 
 	KUNIT_EXPECT_MEMEQ_MSG(test, data[faila], recovi, PAGE_SIZE,
-		"algo=%-8s/%-8s faila miscompared: %3d[%c] (failb=%3d[%c])\n",
-	       calls->name, ra->name,
-	       faila, member_type(faila),
-	       failb, member_type(failb));
+			"faila miscompared: %3d[%c] (failb=%3d[%c])\n",
+			faila, member_type(faila),
+			failb, member_type(failb));
 	KUNIT_EXPECT_MEMEQ_MSG(test, data[failb], recovj, PAGE_SIZE,
-		"algo=%-8s/%-8s failb miscompared: %3d[%c] (faila=%3d[%c])\n",
-	       calls->name, ra->name,
-	       failb, member_type(failb),
-	       faila, member_type(faila));
+			"failb miscompared: %3d[%c] (faila=%3d[%c])\n",
+			failb, member_type(failb),
+			faila, member_type(faila));
 
 skip:
 	dataptrs[faila] = data[faila];
@@ -88,58 +96,66 @@ static void test_disks(struct kunit *test, const struct raid6_calls *calls,
 
 static void raid6_test(struct kunit *test)
 {
+	const struct test_args *ta = test->param_value;
 	int i, j, p1, p2;
-	unsigned int r, g;
-
-	for (r = 0; ; r++) {
-		const struct raid6_recov_calls *ra = raid6_recov_algo_find(r);
-
-		if (!ra)
-			break;
-
-		for (g = 0; ; g++) {
-			const struct raid6_calls *calls = raid6_algo_find(g);
-
-			if (!calls)
-				break;
 
-			/* Nuke syndromes */
-			memset(data[NDISKS - 2], 0xee, PAGE_SIZE);
-			memset(data[NDISKS - 1], 0xee, PAGE_SIZE);
+	/* Nuke syndromes */
+	memset(data[NDISKS - 2], 0xee, PAGE_SIZE);
+	memset(data[NDISKS - 1], 0xee, PAGE_SIZE);
 
-			/* Generate assumed good syndrome */
-			calls->gen_syndrome(NDISKS, PAGE_SIZE,
-						(void **)&dataptrs);
+	/* Generate assumed good syndrome */
+	ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, (void **)&dataptrs);
 
-			for (i = 0; i < NDISKS-1; i++)
-				for (j = i+1; j < NDISKS; j++)
-					test_disks(test, calls, ra, i, j);
+	for (i = 0; i < NDISKS - 1; i++)
+		for (j = i + 1; j < NDISKS; j++)
+			test_recover(test, i, j);
 
-			if (!calls->xor_syndrome)
-				continue;
+	if (!ta->gen->xor_syndrome)
+		return;
 
-			for (p1 = 0; p1 < NDISKS-2; p1++)
-				for (p2 = p1; p2 < NDISKS-2; p2++) {
+	for (p1 = 0; p1 < NDISKS - 2; p1++) {
+		for (p2 = p1; p2 < NDISKS - 2; p2++) {
+			/* Simulate rmw run */
+			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
+					(void **)&dataptrs);
+			makedata(p1, p2);
+			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
+					(void **)&dataptrs);
 
-					/* Simulate rmw run */
-					calls->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-								(void **)&dataptrs);
-					makedata(p1, p2);
-					calls->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-                                                                (void **)&dataptrs);
+			for (i = 0; i < NDISKS - 1; i++)
+				for (j = i + 1; j < NDISKS; j++)
+					test_recover(test, i, j);
+		}
+	}
+}
 
-					for (i = 0; i < NDISKS-1; i++)
-						for (j = i+1; j < NDISKS; j++)
-							test_disks(test, calls,
-									ra, i, j);
-				}
+static const void *raid6_gen_params(struct kunit *test, const void *prev,
+		char *desc)
+{
+	if (!prev) {
+		memset(&args, 0, sizeof(args));
+next_algo:
+		args.recov_idx = 0;
+		args.gen = raid6_algo_find(args.gen_idx);
+		if (!args.gen)
+			return NULL;
+	}
 
-		}
+	if (args.recov)
+		args.recov_idx++;
+	args.recov = raid6_recov_algo_find(args.recov_idx);
+	if (!args.recov) {
+		args.gen_idx++;
+		goto next_algo;
 	}
+
+	snprintf(desc, KUNIT_PARAM_DESC_SIZE, "gen=%s recov=%s",
+			args.gen->name, args.recov->name);
+	return &args;
 }
 
 static struct kunit_case raid6_test_cases[] = {
-	KUNIT_CASE(raid6_test),
+	KUNIT_CASE_PARAM(raid6_test, raid6_gen_params),
 	{},
 };
 
-- 
2.53.0

