Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F12F38BF67;
	Wed, 11 Mar 2026 07:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773213044; cv=none; b=rih3IJrPfpmOIDQBLRMPMNOQliN4YsDRayr9/DdiIU5Ly3AICglKFWvZf5S/BIhJsAZNZaHk9UdAR+LAIOZ1AzZeHT5kUqHvf/K2cJK1jO87a64FqNN1Ml3vJXumSISc8Jhl0gkAKJYeRSyG2+vrNW/xaoTAotWwin+2tPVyE64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773213044; c=relaxed/simple;
	bh=qAz9+7NWn+fxRUImkscM/PWNvzxXbkoqTVoW81OCLWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5T+a6uQ2BIIjqPsybKGziu0WVwuViwH+oXuKPA1VKI42ZVSbtDQFEBvtfXPjAYKR2O1kaZEeSDrcGYJXuNmSy2lEHNi2zycowDwNR+azVfv6j7Dz1L1VZPISRCKx/WL+8Ftcol9IZcJwGNYhGo2JIC1oaA3nfi2Qh5Q5dF8j2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BiRPm2vK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BiRPm2vK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EDWCo5cE2aEVpTui5bFdNy+9+SZiFj1BIITbfBYcjoU=; b=BiRPm2vKL9hGHKNuSaxBRpxE2D
	mXgqkxQdMGMIlSKtxUiL1DX30AL1P/IRN2NatDer1YoAKfR1SamsIwlMzXU0NUGufK6L0AAlKLvKO
	nVYjyKBGLuqv4evC5XLG4cWcwJwJ8Co6CST0FYTLyD4EB0vuMcIszwlr4HyrULBj6+ePMyFjY/x/l
	2510EhcWdl4KfDQc53Q5AKdxMuzlGPF8SpZuE2mwLh1zneewS0BbdJwg2jp/pkRl+acSv1UHcG9+f
	PKnjNpW0ifFJ4eLkkRXHDCfR/vTJU5S011cRoPjh00Ll/I7IxPZSkukKKbbsuASGypN10O3qaSBJy
	qG4MSjRA==;
Received: from [212.243.42.10] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0Di7-0000000B1bE-3GZS;
	Wed, 11 Mar 2026 07:10:28 +0000
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
Subject: [PATCH 26/27] random: factor out a __limit_random_u32_below helper
Date: Wed, 11 Mar 2026 08:03:58 +0100
Message-ID: <20260311070416.972667-27-hch@lst.de>
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

Factor out the guts of __get_random_u32_below into a new helper,
so that callers with their own prng state can reuse this code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/char/random.c  | 26 +++++++++++++++-----------
 include/linux/random.h |  1 +
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7ff4d29911fd..23b5addf02fb 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -544,18 +544,16 @@ DEFINE_BATCHED_ENTROPY(u16)
 DEFINE_BATCHED_ENTROPY(u32)
 DEFINE_BATCHED_ENTROPY(u64)
 
-u32 __get_random_u32_below(u32 ceil)
+/*
+ * This is the slow path for variable ceil. It is still fast, most of the time,
+ * by doing traditional reciprocal multiplication and opportunistically
+ * comparing the lower half to ceil itself, before falling back to computing a
+ * larger bound, and then rejecting samples whose lower half would indicate a
+ * range indivisible by ceil. The use of `-ceil % ceil` is analogous to `2^32 %
+ * ceil`, but is computable in 32-bits.
+ */
+u32 __limit_random_u32_below(u32 ceil, u32 rand)
 {
-	/*
-	 * This is the slow path for variable ceil. It is still fast, most of
-	 * the time, by doing traditional reciprocal multiplication and
-	 * opportunistically comparing the lower half to ceil itself, before
-	 * falling back to computing a larger bound, and then rejecting samples
-	 * whose lower half would indicate a range indivisible by ceil. The use
-	 * of `-ceil % ceil` is analogous to `2^32 % ceil`, but is computable
-	 * in 32-bits.
-	 */
-	u32 rand = get_random_u32();
 	u64 mult;
 
 	/*
@@ -577,6 +575,12 @@ u32 __get_random_u32_below(u32 ceil)
 	}
 	return mult >> 32;
 }
+EXPORT_SYMBOL_GPL(__limit_random_u32_below);
+
+u32 __get_random_u32_below(u32 ceil)
+{
+	return __limit_random_u32_below(ceil, get_random_u32());
+}
 EXPORT_SYMBOL(__get_random_u32_below);
 
 #ifdef CONFIG_SMP
diff --git a/include/linux/random.h b/include/linux/random.h
index 8a8064dc3970..54401dd53f68 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -50,6 +50,7 @@ static inline unsigned long get_random_long(void)
 #endif
 }
 
+u32 __limit_random_u32_below(u32 ceil, u32 rand);
 u32 __get_random_u32_below(u32 ceil);
 
 /*
-- 
2.47.3

