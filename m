Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DDC257431;
	Fri, 27 Feb 2026 23:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772236532; cv=none; b=kOWBoK93+Y947mOnMCSBjas7ifdLVOX7ccAvFyk1vDqJ1Tn8DJ1peowk6Xw0mqsWfg33k6XsP1/Uq5KBg+DVOIPMmW4ynFvf8AbV05nW4jhDye78FifO1logcVGpBpSYYHB1iIbYbit1e1KiHQRAkvoxdDTAH6WamVwiuJDsUaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772236532; c=relaxed/simple;
	bh=9epsKT1Tqv7365SBQ+LgdgBkS+QLvJq0YDfqzGCQppg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DfDzI4rmuuG670rfVBaQpSv5MwnCFSyuWIXWv+G5wo7Hz8s1wlrVCEX9j7Z9Itta4SrX7zxz+eWTQg1c/iQlAXCVUdKfYTvtsez5OBA3dHui+MvaK6bvQz4vb08+3ZXmg1F8e9Fpl9FgpJJJJjpIJJZK7YpNn9qjbZiVyHStBXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XVTF8TDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVTF8TDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97119C116C6;
	Fri, 27 Feb 2026 23:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772236532;
	bh=9epsKT1Tqv7365SBQ+LgdgBkS+QLvJq0YDfqzGCQppg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XVTF8TDa48poxgWx9OMrHOWcWeX+DIvF8W0Cz9PzVZzIIYVyeCBp8CVqVCQqnKv6k
	 5zzYRJst/PHEWqq92j85maQBi7plq+GNVhfHcc+9Pog+YMNqi1zTL7+4Ehtq9UJ7o9
	 QJHa0cD62wS9Zi36AMnb9/VkZXXyv/qc0FNC/OF8hsDCWgrlGfX7gqqn/VNAfN6Fee
	 CkNTC4E/BHSyzLgTwiN6IqzHfjJo9okaT9JcgxYGTsEHUQc31er3WUHfK/2Gx865yY
	 ogRz41c7RbSVwCM0hpH/O2zyx2nKKDpUW5eh/FdyMQPRe2Q68ih/qS1f7bbUEX5IYc
	 3kMoxNtkaet5g==
Date: Fri, 27 Feb 2026 15:55:29 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20260227235529.GA31321@quark>
References: <20260226151106.144735-1-hch@lst.de>
 <20260226151106.144735-19-hch@lst.de>
 <20260227143016.GH1282955@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227143016.GH1282955@noisy.programming.kicks-ass.net>

On Fri, Feb 27, 2026 at 03:30:16PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 26, 2026 at 07:10:30AM -0800, Christoph Hellwig wrote:
> > Move the optimized XOR code out of line into lib/raid.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  arch/x86/include/asm/xor.h                    | 518 ++----------------
> >  arch/x86/include/asm/xor_64.h                 |  32 --
> >  lib/raid/xor/Makefile                         |   8 +
> >  .../xor_avx.h => lib/raid/xor/x86/xor-avx.c   |  14 +-
> >  .../xor_32.h => lib/raid/xor/x86/xor-mmx.c    |  60 +-
> >  lib/raid/xor/x86/xor-sse.c                    | 476 ++++++++++++++++
> 
> I gotta ask, why lib/raid/xor/$arch/ instead of something like
> arch/$arch/lib/xor ?

Similar to lib/crypto/ and lib/crc/, it allows the translation units
(either .c or .S files) containing architecture-optimized XOR code to be
included directly in the xor.ko module, where they should be.

Previously, these were always built into the core kernel even if
XOR_BLOCKS was 'n' or 'm', or they were built into a separate module
xor-neon.ko which xor.ko depended on.  So either the code was included
unnecessarily, or there was an extra module.

Technically we could instead have the lib makefile compile stuff in
arch/, but that would be unusual.  It's much cleaner to have the
directory structure match the build system.

If we made this code always built-in, like memcpy(), then we could put
it anywhere.  But (like many of the crypto and CRC algorithms) many
kernels don't need this code, and even if they do it may be needed only
by 'm' code.  So it makes sense to support tristate.

- Eric
