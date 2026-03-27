Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3750E37A4B9;
	Fri, 27 Mar 2026 06:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592367; cv=none; b=ISPv0u/Aeq9Pxnnvwq6nFtybexP7oKNxJBKq4y9MIRFOfPv7YHJY9iTwWeDFl6fzi0x3BtiPIRIJjmMQjvSkGYvzxEDnNSVDjMnMVjwEmNkcfQyfZaEKtvnHJsVth8AcWUIGmaFKZ6K/FspMfK9U6HytKJggnzt4zY/yEoG5XT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592367; c=relaxed/simple;
	bh=/h2TQ6ycCwZwsjtMF4tjfn519hXqJKk2XsF/dy0omJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcaHMOs9pPNoL4Q3qHbynwWoxD6ScMBxb+H33Z4OYVTKicmRS1pwKN+gL1+4VyHuYj/6kYLeiIdoXDko3dGazORr8NCUJzj9nmUNr7PqII7Gjd/MxcuXOOj01budEbnzhp0eHiIml0+pBsmkWNnRTrHaRIaHLtzSoqEIRvsiMaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XuLAO0Cc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XuLAO0Cc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uz4b28xnj4JQz1ok8SL7hYQ5/Vu1HsWlxMe5TkEq2UU=; b=XuLAO0Cc9zwueAqoqYAggRFnZK
	qnoJObda16l/T8Cdbd8cL9KgDX1zkmTMbW4bXiSLDYnneNvwofgzBlJsry8yVqaSYUVihZs+KdQYn
	Vz7tbnWBN3c2U3KcD5MDki/o3yo/okCgXaptA9jSt1vjdsSYU6fCAHbH90l/Fo7aoO+VSRsR5jTDf
	qG9BrbTEHrCk318Jed5VtSINd2NpkcCO/5obDdkv6FW55Xt92NJ1Z6wP+cgFEXbYjIMjrpvr8JC0p
	oEssmz3+eFGyYtlNQ4znEJC1zSBgM0P8CqzpmKf7kirJBYivvhtgEjD+rVDK+1c4uoDvxhY/4FTkD
	zJV9lXfA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60XA-00000006l66-4AHc;
	Fri, 27 Mar 2026 06:19:05 +0000
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
Subject: [PATCH 06/28] xor: small cleanups
Date: Fri, 27 Mar 2026 07:16:38 +0100
Message-ID: <20260327061704.3707577-7-hch@lst.de>
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

Update the to of file comment to be correct and non-redundant, and drop
the unused BH_TRACE define.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/xor/xor-core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index df530ddc9f06..c54f48405c40 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -1,14 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * xor.c : Multiple Devices driver for Linux
- *
  * Copyright (C) 1996, 1997, 1998, 1999, 2000,
  * Ingo Molnar, Matti Aarnio, Jakub Jelinek, Richard Henderson.
  *
- * Dispatch optimized RAID-5 checksumming functions.
+ * Dispatch optimized XOR parity functions.
  */
 
-#define BH_TRACE 0
 #include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/raid/xor.h>
-- 
2.47.3

