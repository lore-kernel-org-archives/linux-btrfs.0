Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9086C3E63BE;
	Tue, 24 Mar 2026 06:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774334557; cv=none; b=XawTNP+vIlboUlDL9R36QjJ+nhAoc/TkWApY6woTfgPwIBvlT9GzjKjZT8LAMCkzypLh01dw00Gk2cG43TP5xAjgd9CJauyZzjNP6Scq4UfAge/tOGuSsQvJQV76Kpe52cA1WwLiMFCnL6E3xrHxRYFbovs3Jmw7/cpJ5pmPQsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774334557; c=relaxed/simple;
	bh=ke6GgiWjtw4bdl/Bw0biCJc4/c8uke1GvMh5y/LVQxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1o12tzl7saLrEhoeBttNC4LdBFdRDFJqXpSDdei9bYXhAB/e8S2+os3pVhaO3rQimnJ7G3Ih144e3TEe3ZJatKalowiLndlIrCjXephlfcghptTf2JVQ6QeS3e9a3+IqZcmewQe9t1FwvJANbsjWDasGjt3Z5Os2KctZX5mOLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KzbrTBd4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KzbrTBd4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BgRvLJC5xERY6XssOQotPnJq5Jwvijj2Vg9vEpnJo9M=; b=KzbrTBd45XjmU8GadN4Z9MlRls
	tMwjvaVj8sApJYQWkL7clog04fA0OxZIm8p3UePwR2fjUPMU4VLgO2aeJweyI0/8rUvvCCJ0upw5p
	XrcA8hFmfuQM+YsJTy0kXr5HLxxCAU8V/5n2+yzNqKW9SVeYGrNrhyYDKzlFgcmad6aZJW8JqJ3BK
	zY1JLq0lC7PawovnLbveaiGOZ5Qna2no2MFmmN3hbEfkW8o1wEyuScq3X5wnoXdml56EN9U9XNrPb
	gybaZORUREM7c8nWGJbMrcvIAj6tdgpcka1T67mTzRvWND96U40obZaWgjxKlFRkKjP/E0kQSuRCA
	43p6v9cQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4vT0-00000000mK9-2ob6;
	Tue, 24 Mar 2026 06:42:19 +0000
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
Subject: [PATCH 04/17] raid6: remove unused defines in pq.h
Date: Tue, 24 Mar 2026 07:40:39 +0100
Message-ID: <20260324064115.3217136-5-hch@lst.de>
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

These are not used anywhere in the kernel.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
2.47.3

