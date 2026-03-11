Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5D1385528;
	Wed, 11 Mar 2026 07:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773213007; cv=none; b=ZzHmX8Lf6LKOew5FV3WoY+YLRH+vpSl2QYVvZppjvCf3q+pNb9V0maMMz6fyZGxGZLwlYWGplO2hSLPmSxmbIISVIR7C7RyR6C4A6ECGD13YSj/0YyRyOCAX/F0+YhsNPZgrfzr3xfNq6irLL7xdNuhKPk/xMfb3tlb36u77mEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773213007; c=relaxed/simple;
	bh=bFIC6Rt1zofGAV+4oWJMxgoyBXil8dFhaIdHOVSkwJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ph9sWCYW4MdHvcc+pqCrJTLZYEY4t9Q3Xw/CB/xx0+FAAkMDQxtwVmroQGA8p6kLvoNvGZf6i31QBDAusDGX7BvKaJhx9xEJ36dqIFye0x/CmBO5J6IDFigVvGnCzKfECiMV1i9V2BrSoBkzy0p22Zn0igoPJKw+m3wEY9Yqmzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VtpwBikM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VtpwBikM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H2vQZ0n6ApADqlHQBkKJl8JvR6Rc+huPC8RGmru6TyA=; b=VtpwBikMqQGisKoDGXKD2IrKce
	1Zte+VyQ8+sPZptq911j4DEv1+3ch1eb/V6P5SB7gcJ3xQCVtfJaNSLe8O7XTcQf/NDfPvGVO8sR/
	JwWr5lXsm2fVVVpQ9AgjcOkLguzI3nIKP/GpHa6bq4pvP7puPvBNQ2JMSWHp8mZOVoZIjTsFbbNyD
	Ofwet/qSDwFBD1RCeb7l/AzO0G9d067lMRRXwfK8lrvgCcQF8dryCqtXmqQUz9+QbCaXPPuRPgJ8M
	QtHf4nOvqsXu8AR7qyeIMxA+ihh+/z5/7fzeCIve/fOAA8pOMLYi2160cyMAM6Ujx3kdltX6SR7VP
	6l3vi/dg==;
Received: from [212.243.42.10] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0DhW-0000000B1Ad-0csB;
	Wed, 11 Mar 2026 07:09:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
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
Subject: [PATCH 23/27] btrfs: use xor_gen
Date: Wed, 11 Mar 2026 08:03:55 +0100
Message-ID: <20260311070416.972667-24-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311070416.972667-1-hch@lst.de>
References: <20260311070416.972667-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the new xor_gen helper instead of open coding the loop around
xor_blocks.  This helper is very similar to the existing run_xor helper
in btrfs, except that the destination buffer is passed explicitly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/raid56.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index b4511f560e92..dab07442f634 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -617,26 +617,6 @@ static void cache_rbio(struct btrfs_raid_bio *rbio)
 	spin_unlock(&table->cache_lock);
 }
 
-/*
- * helper function to run the xor_blocks api.  It is only
- * able to do MAX_XOR_BLOCKS at a time, so we need to
- * loop through.
- */
-static void run_xor(void **pages, int src_cnt, ssize_t len)
-{
-	int src_off = 0;
-	int xor_src_cnt = 0;
-	void *dest = pages[src_cnt];
-
-	while(src_cnt > 0) {
-		xor_src_cnt = min(src_cnt, MAX_XOR_BLOCKS);
-		xor_blocks(xor_src_cnt, len, dest, pages + src_off);
-
-		src_cnt -= xor_src_cnt;
-		src_off += xor_src_cnt;
-	}
-}
-
 /*
  * Returns true if the bio list inside this rbio covers an entire stripe (no
  * rmw required).
@@ -1434,7 +1414,8 @@ static void generate_pq_vertical_step(struct btrfs_raid_bio *rbio, unsigned int
 	} else {
 		/* raid5 */
 		memcpy(pointers[rbio->nr_data], pointers[0], step);
-		run_xor(pointers + 1, rbio->nr_data - 1, step);
+		xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
+				step);
 	}
 	for (stripe = stripe - 1; stripe >= 0; stripe--)
 		kunmap_local(pointers[stripe]);
@@ -2034,7 +2015,7 @@ static void recover_vertical_step(struct btrfs_raid_bio *rbio,
 		pointers[rbio->nr_data - 1] = p;
 
 		/* Xor in the rest */
-		run_xor(pointers, rbio->nr_data - 1, step);
+		xor_gen(p, pointers, rbio->nr_data - 1, step);
 	}
 
 cleanup:
@@ -2664,7 +2645,7 @@ static bool verify_one_parity_step(struct btrfs_raid_bio *rbio,
 	} else {
 		/* RAID5. */
 		memcpy(pointers[nr_data], pointers[0], step);
-		run_xor(pointers + 1, nr_data - 1, step);
+		xor_gen(pointers[nr_data], pointers + 1, nr_data - 1, step);
 	}
 
 	/* Check scrubbing parity and repair it. */
-- 
2.47.3

