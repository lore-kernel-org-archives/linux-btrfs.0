Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E5C27470;
	Wed, 11 Mar 2026 07:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773212705; cv=none; b=P9FLRZLe9fPSGsbbZDWcAyzqnZ4Iiu+qjSY1PLjcvpIPQ2LLEVmIyg//8sr7g9lNJG9IgN4cgx5REDR5brT2IFYP9y9PjOzGzDXk47hiYYyiHYOjesBW9GuDzNDvmSJwKrMoWyy45H+Kd9njXTueM+4HT5Sp2/Fle1J547/O9Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773212705; c=relaxed/simple;
	bh=BonflUDoxa9Vif6kaTe/UCbVEYjZil2vrjq6waM85IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGatwiMtEs+s0irD3Et4qPtE5cUYObmt8Fqtymoxy3ziq5KfooO5a6heG0SV4qDC93kcmKo/7jve2R004rBLsZMoVuD4gGHLF8pKQ4YSEvhg7YFxw0hMEijdz+hArxU0efy7BUxzCqnUCFsZxVuCmO6pK3+LBTkYgoxKYI2ZB5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s0MZyizq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s0MZyizq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7WrAq85hb5EzAI0QdwS9kx5aUTvTK9+Z0/VmDcCQjL8=; b=s0MZyizq9xr8dSahIjPy3JQ3t4
	uZrLmV1klhNA8C9uxNhWEXjJOJeMZnlKw3znv9GV6B0XIoaFnb4W8MpAlx+ZoFrNLfENzyw4IUbYD
	Wq4mASelRboH3kdslwRtyhYn2p0i+1vJ7q/Ut0Xvjt4J0WgD12518VxGvcKZh+0w7PSx+WBJEjias
	BACqiJd2lFSoefmJICAgzdDwne2nZKhDDJ722UuahWBb2EYpYNdCdljWbpvQqFVO6hnr++92lVCfc
	Mt3wHcE17EjBuPpNbn5mCtAly02z6CRU1aLBmMxy+EnnepAktVccxpP45xGpT94yzOpEny/G7OKJy
	KzuVxk/w==;
Received: from [212.243.42.10] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0DcV-0000000Ay7p-13ZO;
	Wed, 11 Mar 2026 07:04:39 +0000
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
Subject: [PATCH 01/27] xor: assert that xor_blocks is not from preemptible user context
Date: Wed, 11 Mar 2026 08:03:33 +0100
Message-ID: <20260311070416.972667-2-hch@lst.de>
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

Most of the optimized xor_blocks versions require FPU/vector registers,
which generally are not supported in interrupt context.

Both callers already are in user context, so enforce this at the highest
level.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 crypto/xor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/xor.c b/crypto/xor.c
index f39621a57bb3..676d7401af43 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -28,6 +28,8 @@ xor_blocks(unsigned int src_count, unsigned int bytes, void *dest, void **srcs)
 {
 	unsigned long *p1, *p2, *p3, *p4;
 
+	lockdep_assert_preemption_enabled();
+
 	p1 = (unsigned long *) srcs[0];
 	if (src_count == 1) {
 		active_template->do_2(bytes, dest, p1);
-- 
2.47.3

