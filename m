Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDA23ED134;
	Tue, 24 Mar 2026 06:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774334660; cv=none; b=PDKj/cYSYrm2Rvl/blzAWHX5FMb0A6NKOj3+nbwD3ZCn9hCrLraAaQYQMB0nmzleTAa2AMxLbNQ5q5iAcvbAVsOZPuWMxHwvHpWUuZyms64BKKy2ryhl08VvTkn6g6HcQx8NE6q3yGRxxwWocLmjtsLLAYgYZtgV5uy6BiCwxX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774334660; c=relaxed/simple;
	bh=o+iAV0Eu04dpBHXUs4wkhCKcIsi6awpdw/QK3TQgwyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlYazYdEC3EXC+8b9dh8bZD+vaXJIM6PpwRxzu+85hs1cej0xb+L4gIi6GGOc3MAHKJV6zD8poLoVcyKVZjZWUZuppObWbLuAGvBK/8s2dgZd/IsYOAN8ftNy07c+TrTARP9sOUrL9kLPxglow+oJcUCY9tdC15U8FngEkzdfMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=44NDbNw7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="44NDbNw7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=a19LbadRLJlsYU1cNPgEz2GRhMYxLtenB33pRklMjDY=; b=44NDbNw7LJSycvhx8c8SeGOL9l
	CsWR8zJNTYB6fCMGnR6R8d83Fmg+71Ng3zjdrDWOgLJl4W7Q99ujM43viH5Bok5wnt0xXWkpp40Pe
	kkjOa3HrWawRPdc5JG8pwwaPb6wzxe/3HzYUOWa7oYno1JSfvfMOTmoDQSTHGqP9olY43tI6M/bG0
	DMjd2Cwz+ccuRwRY07jSJiXJ3CiWD672TUGbfkhDsVabg+4pmhl7NHdviUv/N9ddsYwP560HBGo+7
	53wzbzKrcMXlcQEAfsIMVJM2h48ZC5I+PyOrdTyhkj14XreNKCpIicvYhS3PITcNDddaUZHNEThIE
	3N8ilyBA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4vUe-00000000nie-1N6T;
	Tue, 24 Mar 2026 06:44:00 +0000
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
Subject: [PATCH 11/17] raid6: use static_call for raid6_recov_2data and raid6_recov_datap
Date: Tue, 24 Mar 2026 07:40:46 +0100
Message-ID: <20260324064115.3217136-12-hch@lst.de>
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

Avoid expensive indirect calls for the recovery routines as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/raid6/algos.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
index b81c7594f6c4..201443f6cac2 100644
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
@@ -124,7 +126,7 @@ void raid6_recov_2data(int disks, size_t bytes, int faila, int failb,
 	WARN_ON_ONCE(bytes > PAGE_SIZE);
 	WARN_ON_ONCE(failb <= faila);
 
-	raid6_recov_algo->data2(disks, bytes, faila, failb, ptrs);
+	static_call(raid6_recov_2data_impl)(disks, bytes, faila, failb, ptrs);
 }
 EXPORT_SYMBOL_GPL(raid6_recov_2data);
 
@@ -149,7 +151,7 @@ void raid6_recov_datap(int disks, size_t bytes, int faila, void **ptrs)
 	WARN_ON_ONCE(bytes & 511);
 	WARN_ON_ONCE(bytes > PAGE_SIZE);
 
-	raid6_recov_algo->datap(disks, bytes, faila, ptrs);
+	static_call(raid6_recov_datap_impl)(disks, bytes, faila, ptrs);
 }
 EXPORT_SYMBOL_GPL(raid6_recov_datap);
 
@@ -322,6 +324,8 @@ static int __init raid6_init(void)
 	 */
 	if (!raid6_recov_algo)
 		raid6_recov_algo = &raid6_recov_intx1;
+	static_call_update(raid6_recov_2data_impl, raid6_recov_algo->data2);
+	static_call_update(raid6_recov_datap_impl, raid6_recov_algo->datap);
 	pr_info("raid6: using %s recovery algorithm\n", raid6_recov_algo->name);
 
 #ifdef MODULE
-- 
2.47.3

