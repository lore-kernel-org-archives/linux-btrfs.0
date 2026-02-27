Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C4F2459D4;
	Fri, 27 Feb 2026 14:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772202647; cv=none; b=FPeH4onn39tV/enGOM4ZC8uACqmn4gHzTeyLtfQoVgF5mVtrkj/eaUXMIz2aFWJ1bkzGtdURVtFI8We+aSfMEkk5yBzFzr+Ov/G1RKRqv6b8zQ7LKTq1lKDYaEtcM3ama+cJG9KMRVOuIWfTAxsUSqDJhj1L+hKl58V3q8HiAr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772202647; c=relaxed/simple;
	bh=JZEUNXJ+CbYdk4xqxq+Vr7Zsu0RlKX3XpeN9ldDablA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3kK4iGl2oBIWkFHnyvAoUkqICg9SNGDbhI45C1ixYfPfThLy/az+fBON/DR6cuFrY+8b7U12MGA3o7qlVWvSCvAZk4pqUGKzE04/aWs635jmMnHWboa6zQYwqhLRsvowYcnyX92O4ZpaFOV8O2zXEZxfIUxb+pzcY0w/TBdWX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z9TK/udX; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z9TK/udX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lOp11MEHkYYwHRuUi0PZxSk1JN5+nTDJOLnSpDaUbDc=; b=Z9TK/udXiurPXiytUakXbFeev1
	ri7v9BFFO7R7ZiJvpbTW1JFNZRneKl3isIJyG3zHlkz9s2XQmusrQ/zacC5tOadz4Z7qmOWC49end
	3fVssHWiU1uZPXJxiiQFriaeu9YgtBdmdglQ2CtYVshTHvu5aWjnfh1f3CqeCm2LMKGKqofhFMRq5
	2FTQrOlmRLWH57X+/mT4zC19PNT7lNgxKvCQLn4m60NIZInXyfVhYVB3n68h6H+ZGw2r9VS0iGiNq
	QnT1zFqHAqIdiC0LM2DhVATtSnPcGUsNzzjMV7n5w3njjHXBfMs/S6eMK73CqMCrr/PUyh+1FLh1J
	kCLUtTiQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvyrB-00000004hgm-0psV;
	Fri, 27 Feb 2026 14:30:17 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B3685300CDE; Fri, 27 Feb 2026 15:30:16 +0100 (CET)
Date: Fri, 27 Feb 2026 15:30:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
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
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>, linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 18/25] x86: move the XOR code to lib/raid/
Message-ID: <20260227143016.GH1282955@noisy.programming.kicks-ass.net>
References: <20260226151106.144735-1-hch@lst.de>
 <20260226151106.144735-19-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226151106.144735-19-hch@lst.de>

On Thu, Feb 26, 2026 at 07:10:30AM -0800, Christoph Hellwig wrote:
> Move the optimized XOR code out of line into lib/raid.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/x86/include/asm/xor.h                    | 518 ++----------------
>  arch/x86/include/asm/xor_64.h                 |  32 --
>  lib/raid/xor/Makefile                         |   8 +
>  .../xor_avx.h => lib/raid/xor/x86/xor-avx.c   |  14 +-
>  .../xor_32.h => lib/raid/xor/x86/xor-mmx.c    |  60 +-
>  lib/raid/xor/x86/xor-sse.c                    | 476 ++++++++++++++++

I gotta ask, why lib/raid/xor/$arch/ instead of something like
arch/$arch/lib/xor ?

