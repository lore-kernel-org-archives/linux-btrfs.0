Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD183921DD;
	Mon, 18 May 2026 05:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779081581; cv=none; b=s0N01PJ+i4+xS6CCko1G4bG550GAPDVU7dc7T5XCh/DhODRHYSoAJSrdLNB7K1JDR/Yn0WEDXDWQlAvEetqYYrPbKckgj44rRtLGOgdsB77odG9OAem6kOS2vOYH+RzsKlWxcDEZksumTCn19S33A/2P9KNa9RwgtnVihWWDXk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779081581; c=relaxed/simple;
	bh=4qrKpKRHeJdogPZgUQcVymCDfC5xHNbP0VlbmzakNhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+IWmgWjZXCUrNY30YohgXwFNhC/LOauXR5gQxcnqe43E1dK0dDloq1RFd4hnhXhhSpP5tVMflpcHizLPW4vkH0asLJdgVKStp+ikgLQXZw2QAtH3dxX21suDQ5dHbXCadYKnhFBu1rnoIGioKsiR3+8izpUAucmN5m2rWcth5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q5Mrno9G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q5Mrno9G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oPj6YyuMGUNCf0Hmw0XpTtspEAmY9x+9oDziy5puBG0=; b=q5Mrno9GvpbxW2XcuAy9csfwpU
	BX/cQ/l1gJ/VERaG55tOXAfdJNsbJJWHZMHEG81mmghQH2MbZVKUTxlbpte25jIr82r/sU/QhDSnR
	R5ygQGlxX06p+RwtkXWJdUbQtvtBdyUrOUh8hBII98iyaopudQ1XGVzU0jnD9O0jBXYPd5EYySpv7
	wVggmxbIGygyKBvYjyfhd0tD8cuu6UZuEdaXHHG8SqbcltnR4m6IOg3jEvc2zCy4VpQ/EFjNzFc6e
	pmlt7b/Q5qbWKGQYBShvRbxbGjwrZAa/iPXdjmYafFcFKVRSeN5UAKt0ME16EpcRNujjpvS2oe5z9
	88JUSAFg==;
Received: from [2001:4bb8:2d1:6fdb:d67d:128c:34ba:85b8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOqNp-0000000EFtC-0bCw;
	Mon, 18 May 2026 05:19:17 +0000
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
Subject: [PATCH 04/18] raid6: remove unused defines in pq.h
Date: Mon, 18 May 2026 07:17:47 +0200
Message-ID: <20260518051804.462141-5-hch@lst.de>
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

These are not used anywhere in the kernel.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
---
 include/linux/raid/pq.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index d26788fada58..5e7e743b83f5 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -90,12 +90,6 @@ extern const struct raid6_calls raid6_neonx8;
 extern const struct raid6_calls * const raid6_algos[];
 extern const struct raid6_recov_calls *const raid6_recov_algos[];
 
-/* Return values from chk_syndrome */
-#define RAID6_OK	0
-#define RAID6_P_BAD	1
-#define RAID6_Q_BAD	2
-#define RAID6_PQ_BAD	3
-
 /* Galois field tables */
 extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
 extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
-- 
2.53.0

