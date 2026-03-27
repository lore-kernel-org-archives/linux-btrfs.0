Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F60426E709;
	Fri, 27 Mar 2026 06:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592280; cv=none; b=tNXdZm9mc6apdeYUGKPCnadgQDS1F1eO/wIVsiNHzkGB3Kw7ARjI7Qe5txrbWDJOkFfnZod87qCyQswLmuoz2VjJRtB2k75HPlQTqQpNI+m6JEonOv0QjNl91jv2JgWfBHyHSDIOpt3eCujWO1Oe8SBRQdrHq34Jb6nvJfcUKBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592280; c=relaxed/simple;
	bh=NDxDJkmpPXKYQvlYiEIrOSMmvm63PsMUdxFS4ORsYXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpfDXhITD9aW2kaYui6Ld1Hr7YdUqF6jWAheZ1ny6coBIxeVzBRUXjuy5oA/UAYtN70KHHMilOEEXc3tSlNqvAdeLmw2EAnEeU6rVNkt70qPxq9nL474FUfUx8VwMFoEpUa9Thg9MQhSj9uibUTlZZtd0iDbQMNEuCRXu+bD4S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Dm8ySlYB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dm8ySlYB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/2j39ho5HZfwE3eOGk3paFEvb/lh5G+wpe3o3TJUYA0=; b=Dm8ySlYB19geB6N1wp4cse2BnE
	JN2T8m+Zw90dMyCB90leObMyg3f4eKCLoYf44HQSKs1iFsfQyNNlAyXTmC2YyC9cg+WVNAhvviD6y
	cyy4GwLB3/FH0loAebaI/l5+33lUAr833HyJEsycRuACwnjRw7sr6ZGJORwCbYpE9ukblH6jNRFYr
	PIcgis0ScZqfjsoRawazIw0xyrtdJF0UqnFjUlJCPOpkKy++zmpNABgi1etUgdX0e6yBRfyYJIMiN
	k0orD2TF6mVpcpXxUpVqKytJV7w1K10rawQKtxOmAa/9DVRbS95hfYSWAMKA4zwJHjX3yP5ZviO/F
	hWwaa7Hw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Vd-00000006kai-3ezG;
	Fri, 27 Mar 2026 06:17:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: [PATCH 01/28] xor: assert that xor_blocks is not call from interrupt context
Date: Fri, 27 Mar 2026 07:16:33 +0100
Message-ID: <20260327061704.3707577-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327061704.3707577-1-hch@lst.de>
References: <20260327061704.3707577-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Most of the optimized xor_blocks versions require FPU/vector registers,
which generally are not supported in interrupt context.

Both callers already are in user context, so enforce this at the highest
level.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 crypto/xor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/xor.c b/crypto/xor.c
index f39621a57bb3..df530ddc9f06 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -28,6 +28,8 @@ xor_blocks(unsigned int src_count, unsigned int bytes, void *dest, void **srcs)
 {
 	unsigned long *p1, *p2, *p3, *p4;
 
+	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
+
 	p1 = (unsigned long *) srcs[0];
 	if (src_count == 1) {
 		active_template->do_2(bytes, dest, p1);
-- 
2.47.3

