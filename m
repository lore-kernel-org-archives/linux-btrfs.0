Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8EE33507C;
	Tue, 12 May 2026 05:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778563508; cv=none; b=S5WWr4g49MAhuEDv4JlN+w9IgyDvcg6OEVuiOnpbbWh3H55QT9j4Nx58hHnxO9AqYgZFguJhxmAGzb8Z0qz7n7y2c57Nr9r0/Qeg6quyssH1BtvhJN5BDE1Z1Sn+03Yt2r2ILLvK7wB4aQjAwpOOmmApxkF78440lD3249yHf2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778563508; c=relaxed/simple;
	bh=khbyrJqw0K/uLNRto+FGJko9VNpN8A9SHZ1HivoFRUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJDgPNL9v+awkg7+bh+jNgM2huExnWkjVAMtXi3BZM9tEKd8VV3QxCo4/bUD+TBucxD2QwDybx4V5FhIsCgXAp+gL4REgb3satbDUHXuS8I+iqsj6two4rVA3HdqobfwiGuNn8hx+DBVsmLxxngY6xRRuNpWpNlEW6ZvXzm4OQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nj+eSR6Y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nj+eSR6Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=v4XDa+C/o91FMWjaSNhcRxXMdj1CYKY/YPjwb23rTsE=; b=nj+eSR6Yjql/J4+NOLB1SIR9wA
	yiTsn5udcxuDswc8RbV0Nz37ZuPaslxNhIKY9akbDGEQQjGYsUCE+Vxzhneju2Evin+QBZeiYTCxR
	8+/bkPa388JJH9xVoLVtf8cDY6tAsnGW0VnCVXqYjP37KlzIRcMq+WHpabYljLU9+zyOpcc9oiXgh
	60fqvpn8xmYuAPfWRPlcfGlL2VPXrJt1VVSukKXADFk6a8izV3T8mvjQw/u7+onJwJVS2250slP3l
	vh/jPtKP1HFqwZvJWzOpwjEp6s628KldCifTx4R9yIU2X5c7CllE5xxW7J265m0ZxofOuRSFTyMeJ
	sExTVitg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfbz-0000000FcGb-2ne1;
	Tue, 12 May 2026 05:24:56 +0000
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
Subject: [PATCH 12/19] raid6: use static_call for raid6_recov_2data and raid6_recov_datap
Date: Tue, 12 May 2026 07:20:52 +0200
Message-ID: <20260512052230.2947683-13-hch@lst.de>
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

Avoid expensive indirect calls for the recovery routines as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/raid6/algos.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
index 65b75236ecf8..d333318e3301 100644
--- a/lib/raid/raid6/algos.c
+++ b/lib/raid/raid6/algos.c
@@ -26,6 +26,8 @@ static const struct raid6_recov_calls *raid6_recov_algo;
 /* Selected algorithm */
 DEFINE_STATIC_CALL_NULL(raid6_gen_syndrome_impl, *raid6_intx1.gen_syndrome);
 DEFINE_STATIC_CALL_NULL(raid6_xor_syndrome_impl, *raid6_intx1.xor_syndrome);
+DEFINE_STATIC_CALL_NULL(raid6_recov_2data_impl, *raid6_recov_intx1.data2);
+DEFINE_STATIC_CALL_NULL(raid6_recov_datap_impl, *raid6_recov_intx1.datap);
 
 /**
  * raid6_gen_syndrome - generate RAID6 P/Q parity
@@ -126,7 +128,7 @@ void raid6_recov_2data(int disks, size_t bytes, int faila, int failb,
 	WARN_ON_ONCE(bytes > PAGE_SIZE);
 	WARN_ON_ONCE(failb <= faila);
 
-	raid6_recov_algo->data2(disks, bytes, faila, failb, ptrs);
+	static_call(raid6_recov_2data_impl)(disks, bytes, faila, failb, ptrs);
 }
 EXPORT_SYMBOL_GPL(raid6_recov_2data);
 
@@ -151,7 +153,7 @@ void raid6_recov_datap(int disks, size_t bytes, int faila, void **ptrs)
 	WARN_ON_ONCE(bytes & 511);
 	WARN_ON_ONCE(bytes > PAGE_SIZE);
 
-	raid6_recov_algo->datap(disks, bytes, faila, ptrs);
+	static_call(raid6_recov_datap_impl)(disks, bytes, faila, ptrs);
 }
 EXPORT_SYMBOL_GPL(raid6_recov_datap);
 
@@ -324,6 +326,8 @@ static int __init raid6_init(void)
 	 */
 	if (!raid6_recov_algo)
 		raid6_recov_algo = &raid6_recov_intx1;
+	static_call_update(raid6_recov_2data_impl, raid6_recov_algo->data2);
+	static_call_update(raid6_recov_datap_impl, raid6_recov_algo->datap);
 	pr_info("raid6: using %s recovery algorithm\n", raid6_recov_algo->name);
 
 #ifdef MODULE
-- 
2.53.0

