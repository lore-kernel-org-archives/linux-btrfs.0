Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BF33A16AC;
	Mon, 18 May 2026 05:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779081760; cv=none; b=R2Do5T537aOthGSePQaMaAw58HjYQ3B5kpRGHd+QFw8MlR08TKSkGfKg1nfKV3y6HW7VIQXq0j9+yRg1N7n2u8JEMZqgIPokbHkbc7C+DHMafVTce64utTZLLzYjlimRfBwx0/ZH6lgtMR11pWhx0Of0RtoWwZHQacd8859nGyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779081760; c=relaxed/simple;
	bh=LENWD1n6qjVtkkHbsfcS6f3u+0XgeyRTS9tV1dzW9GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3atrde+qjAP3oSUEe5EZefPHB9Al7eYP7xO9jGkOAbhszk1KYzpvMDlBXVDtEeoOqQLa1IG0W1eaNruizgyGtmlCz+K0yEYtlS8y1F0pZa96WmuzNDREiKgKdz/V7usC5FtLLg2J9avqPBm2XrQFD5Jw5Xp0GFMxlCNicPGEXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jing+W1v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jing+W1v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uaKQjfFAYtBVCxqvynOc2mKXzrdsWopfj35JuMOV+rY=; b=Jing+W1vqKafzy33W0HLcJFYgc
	RKUGazs84SeejS8GgQu72B4qMAleWYZX8ji94eMmBAxUwg6lB/Udy2wC2M8Q76kOvOPVBPH1p0WdI
	MHfY5E9RI4blWIv0zxUslTrMHHvulRctkB+TX88SubO7bFbf0OrN9Vk2wETpwJqyzjfwn+HQ1DYLV
	aqdOL8urartp7j2usvg+LQVtbczGTh74oqg3q9aDYDb8shiHqlaOburv3o9h8uMZYtC92EOfVRI/3
	1sAWWMsx5mUZ7niJlPrjVBkuksc33JlNNpyxsXsDzqwyMBRI4X262XuIGoUi10V1SXSa9iJVgIvdm
	Nfp7GkbQ==;
Received: from [2001:4bb8:2d1:6fdb:d67d:128c:34ba:85b8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOqQk-0000000EID1-3vrf;
	Mon, 18 May 2026 05:22:19 +0000
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
Subject: [PATCH 16/18] raid6_kunit: cleanup dataptr handling
Date: Mon, 18 May 2026 07:17:59 +0200
Message-ID: <20260518051804.462141-17-hch@lst.de>
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

Move the global dataptr array into test_recover() as all sites that fill
data or parity can use test_buffers directly, and this localized the
override for the failed slots to the recovery testing routine.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
---
 lib/raid/raid6/tests/raid6_kunit.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/lib/raid/raid6/tests/raid6_kunit.c b/lib/raid/raid6/tests/raid6_kunit.c
index 72c78834df7f..152d5d1c3a88 100644
--- a/lib/raid/raid6/tests/raid6_kunit.c
+++ b/lib/raid/raid6/tests/raid6_kunit.c
@@ -18,7 +18,6 @@ MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 #define NDISKS		16	/* Including P and Q */
 
 static struct rnd_state rng;
-static void *dataptrs[NDISKS];
 static void *test_buffers[NDISKS];
 static void *test_recov_buffers[RAID6_KUNIT_MAX_FAILURES];
 
@@ -35,10 +34,8 @@ static void makedata(int start, int stop)
 {
 	int i;
 
-	for (i = start; i <= stop; i++) {
+	for (i = start; i <= stop; i++)
 		prandom_bytes_state(&rng, test_buffers[i], PAGE_SIZE);
-		dataptrs[i] = test_buffers[i];
-	}
 }
 
 static char member_type(int d)
@@ -56,11 +53,13 @@ static char member_type(int d)
 static void test_recover(struct kunit *test, int faila, int failb)
 {
 	const struct test_args *ta = test->param_value;
+	void *dataptrs[NDISKS];
 	int i;
 
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
 		memset(test_recov_buffers[i], 0xf0, PAGE_SIZE);
 
+	memcpy(dataptrs, test_buffers, sizeof(dataptrs));
 	dataptrs[faila] = test_recov_buffers[0];
 	dataptrs[failb] = test_recov_buffers[1];
 
@@ -70,7 +69,7 @@ static void test_recover(struct kunit *test, int faila, int failb)
 		 * is equivalent to a RAID-5 failure (XOR, then recompute Q).
 		 */
 		if (faila != NDISKS - 2)
-			goto skip;
+			return;
 
 		/* P+Q failure.  Just rebuild the syndrome. */
 		ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, dataptrs);
@@ -92,10 +91,6 @@ static void test_recover(struct kunit *test, int faila, int failb)
 			"failb miscompared: %3d[%c] (faila=%3d[%c])\n",
 			failb, member_type(failb),
 			faila, member_type(faila));
-
-skip:
-	dataptrs[faila] = test_buffers[faila];
-	dataptrs[failb] = test_buffers[failb];
 }
 
 static void raid6_test(struct kunit *test)
@@ -108,7 +103,7 @@ static void raid6_test(struct kunit *test)
 	memset(test_buffers[NDISKS - 1], 0xee, PAGE_SIZE);
 
 	/* Generate assumed good syndrome */
-	ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, (void **)&dataptrs);
+	ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, test_buffers);
 
 	for (i = 0; i < NDISKS - 1; i++)
 		for (j = i + 1; j < NDISKS; j++)
@@ -121,10 +116,10 @@ static void raid6_test(struct kunit *test)
 		for (p2 = p1; p2 < NDISKS - 2; p2++) {
 			/* Simulate rmw run */
 			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-					(void **)&dataptrs);
+					test_buffers);
 			makedata(p1, p2);
 			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-					(void **)&dataptrs);
+					test_buffers);
 
 			for (i = 0; i < NDISKS - 1; i++)
 				for (j = i + 1; j < NDISKS; j++)
-- 
2.53.0

