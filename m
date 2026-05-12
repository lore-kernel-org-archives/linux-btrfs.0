Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE5435F185;
	Tue, 12 May 2026 05:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778563576; cv=none; b=m58iGRhLfq7xvm0euXYNd1Go9xteH3O9GY+HQzNS1UUJIYEKzO+y39l9SbrIlmgcLxhQT5HqZU6xKhch77txXVa0aIA3q80zJXILqJMBdIrZqkCAGMkx4srfClr2xgVxzp8i6w7QqBkMVBKil4pb1101jg6dckhsVJe44m4+RTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778563576; c=relaxed/simple;
	bh=/blUPkagnGNO6vpnJJWZn4XGOVe2ApCnr0RmAK41T7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pj3MlzPYlEfjnVJQi1DdMCUVr1YHCMaIO+/Uu1Ja51xa/mW4CEKjUWa6H5+SL742pCL9i2nNXOvenVIA+Hj/4Sk/y2QYp9SyvOFJ3QXXxIRG4XpCEOHyVKj5o4/xzknL78153zHYey/ZCiXi3+jCVtVd/wgXJLueZ1/dmUOAcKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KxRdAHBu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KxRdAHBu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eieqJh591jkivWgUpSd0uAjJTAcruVOirF8ZRJ69/fk=; b=KxRdAHBuwBWUa5VuUvv4S8bpkO
	q+PO3gq3K+krpIfb/evZRbcYyKQqTgJobbpkHxU3qYYQnwc6eMEzGqZcv9MIbQW9tkAmNuifIJ/uJ
	tao4426qjA/2FAMk6pjqB7/ZoVvcOl7LG61PX3QB2Wl45oPjmMveu6HHYGeCFJpqPEHeQLMIVx4qN
	xKVcH5O1USlSW2iuwX1KvsK9hJBzC8Udx2kZR7xocK7ce/un02XfktJ6gdWtpJq69+KEhNxq/XZF1
	mjHwSWHRTzPVctMBKxM1mHZ0WceMb16p0UZrNyyjkA3UKM2c2k09prKBid0iSGC4Q2bauboixhEK5
	z0ITnD/Q==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfd7-0000000FdFG-1HIB;
	Tue, 12 May 2026 05:26:05 +0000
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
Subject: [PATCH 18/19] raid6_kunit: randomize parameters and increase limits
Date: Tue, 12 May 2026 07:20:58 +0200
Message-ID: <20260512052230.2947683-19-hch@lst.de>
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

The current test has double-quadratic behavior in the selection for
the updated ("XORed") disks, and in the selection of updated pointers,
which makes scaling it to more tests difficult.  At the same time it
only ever tests with the maximum number of disks, which leaves a
coverage hole for smaller ones.

Fix this by randomizing the total number, failed disks and regions
to update, and increasing the upper number of tests disks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/raid6/tests/raid6_kunit.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/raid/raid6/tests/raid6_kunit.c b/lib/raid/raid6/tests/raid6_kunit.c
index 775a0051f9a4..d6ac777dcaee 100644
--- a/lib/raid/raid6/tests/raid6_kunit.c
+++ b/lib/raid/raid6/tests/raid6_kunit.c
@@ -8,6 +8,7 @@
 #include <kunit/test.h>
 #include <linux/prandom.h>
 #include <linux/vmalloc.h>
+#include <linux/raid/pq.h>
 #include "../algos.h"
 
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
@@ -43,6 +44,12 @@ static unsigned int random_length(unsigned int max_length)
 	return round_up((rand32() % max_length) + 1, 512);
 }
 
+static unsigned int random_nr_buffers(void)
+{
+	return (rand32() % (RAID6_KUNIT_MAX_BUFFERS - (RAID6_MIN_DISKS - 1))) +
+			RAID6_MIN_DISKS;
+}
+
 static void makedata(int start, int stop)
 {
 	int i;
@@ -169,9 +176,7 @@ static void test_rmw(struct kunit *test, unsigned int nr_buffers,
 static void raid6_test_one(struct kunit *test)
 {
 	const struct test_args *ta = test->param_value;
-	/* including P/Q we need at least three buffers */
-	unsigned int nr_buffers =
-		(rand32() % (RAID6_KUNIT_MAX_BUFFERS - 2)) + 3;
+	unsigned int nr_buffers = random_nr_buffers();
 	unsigned int len = random_length(RAID6_KUNIT_MAX_BYTES);
 
 	/* Nuke syndromes */
-- 
2.53.0

