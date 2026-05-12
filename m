Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED91C33260F;
	Tue, 12 May 2026 05:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778563408; cv=none; b=lCXhCvXcR62BPuZWN6TYtAOTgxN79hrh3chNBQSNvtHXq2gRLNf5xvZ6xzFTla5poDOXeBIKWfJ2LPWsbM3gy5MBFTEcvnK4+nZ0Giz+Ca2qlHfJf93CoXO8hA0917CxQ3RXv5Ab3xFbLY0C0vLIPh7LC3x1wlwyOnGkLBb7/vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778563408; c=relaxed/simple;
	bh=LS237DMSHu93VVdKtP/ECriEZ+ENITiSKV6/y4WTcuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRi4YopYhdbEhH9nET3fvmHmMBmC0FmlGkKImvE7myyt/uz8dneCUvYxKCa9fbUybp4uUg461pZOwrFFasFrHPbX1aBIZJwhf4e1ls6GMdfdbgpMISDASGibGTojMfIRcaem5dDNC5Bf/yom56lhhLtSFJ+ZzuvE6+j7QJXYZTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l9QL8FjZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l9QL8FjZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lk9xgGRX6KmTgHi8yeCmJiNwyDWaauERdGqaOWPOxNE=; b=l9QL8FjZ7+E5EBMHVT0/gRU+vG
	eamJddBD4ZK2GrbpvQkqMeld+GJF1U8zc0XZKnsp3cbar4kkaiZ6prkVXfW5QHNmKwOko9E0CAaCG
	K6nseoa3cjAeTPtKZ1mDOZz3Dzv+qSAlvUcrAyqlkJ2cBKvc5q8k6SA3W89evJiahuLj7tRPCblYk
	67mWrhIWdo6GJvmWsCiVx9KGhqz2Lx4zA1NFzvV0+RkG0BQpZnrKCUUHTUgRJldV6EUY+DHzEmOhX
	kjYI6hqQsKxKtPUx90JTmkimbSZePBIxTp2pD0+LosuqW4BQq12FxpZ35qupJ1ptq5qWURy7fZluC
	n3JlY+qA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfZz-0000000FaPv-0bKv;
	Tue, 12 May 2026 05:22:51 +0000
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
Subject: [PATCH 01/19] btrfs: require at least 4 devices for RAID 6
Date: Tue, 12 May 2026 07:20:41 +0200
Message-ID: <20260512052230.2947683-2-hch@lst.de>
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

While the RAID6 algorithm could in theory support 3 devices by just
copying the data disk to the two parity disks, this version is not only
useless because it is a suboptimal version of 3-way mirroring, but also
broken with various crashes and incorrect parity generation in various
architecture-optimized implementations.  Disallow it similar to mdraid
which requires at least 4 devices for RAID 6.

Fixes: 53b381b3abeb ("Btrfs: RAID5 and RAID6")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a88e68f90564..0b54b97bdad8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -159,7 +159,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.sub_stripes	= 1,
 		.dev_stripes	= 1,
 		.devs_max	= 0,
-		.devs_min	= 3,
+		.devs_min	= 4,
 		.tolerated_failures = 2,
 		.devs_increment	= 1,
 		.ncopies	= 1,
-- 
2.53.0

