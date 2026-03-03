Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1373A6EED;
	Tue,  3 Mar 2026 16:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553796; cv=none; b=T9v6qnAc3l0R+uEjvMXZbWwqsIKd5BeoSfCqL/ym+g42fvZ/CTIx/b8QrL8n1lOcSjXWAtIJAZQ0sPkNk5XB96QA7w9HiS4yvHafx6NfzhNUQbWNjAKsyk7tlTp5kuc3uFFsHyvOM7uPfmIz4U0vT9+sy7ygfCFhwfZM3Em79h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553796; c=relaxed/simple;
	bh=ZWv+gO+FdnwlR8dPywhHmr+HYcl63OF2TGtLqHW5BxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hF+eVJrq2y/fsdK+Vzzsl2wAxcRusJkNKLbvTmvY8Q+TzCz6mlKYLIBaHMuWWws6iZNUmx8CrDZz9E00ZAEeIvp3FfxwdyhIhidbmh+XdyEJI4OcNbxCOPp3DHc5cI2eHQ6wjWuPWqAlVfa6SYn35elVTPmSNh8cEyelDHO1mBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C1C3F68C4E; Tue,  3 Mar 2026 17:03:10 +0100 (CET)
Date: Tue, 3 Mar 2026 17:03:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
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
Subject: Re: [PATCH 07/25] xor: split xor.h
Message-ID: <20260303160309.GD7021@lst.de>
References: <20260226151106.144735-1-hch@lst.de> <20260226151106.144735-8-hch@lst.de> <20260228044355.GD65277@quark>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228044355.GD65277@quark>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 27, 2026 at 08:43:55PM -0800, Eric Biggers wrote:
> On Thu, Feb 26, 2026 at 07:10:19AM -0800, Christoph Hellwig wrote:
> > Keep xor.h for the public API, and split the struct xor_block_template
> > definition that is only needed by the xor.ko core and
> > architecture-specific optimizations into a separate xor_impl.h header.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  arch/arm/lib/xor-neon.c       |  1 +
> >  arch/s390/lib/xor.c           |  2 +-
> >  include/linux/raid/xor.h      | 22 +---------------------
> >  include/linux/raid/xor_impl.h | 25 +++++++++++++++++++++++++
> >  lib/raid/xor/xor-core.c       |  1 +
> >  5 files changed, 29 insertions(+), 22 deletions(-)
> >  create mode 100644 include/linux/raid/xor_impl.h
> 
> arch/arm64/lib/xor-neon.c needs to be updated to include xor_impl.h.

As of this patch it is not using anything from that header (but
neither from the public xor.h).

