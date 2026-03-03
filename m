Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8B6282F37;
	Tue,  3 Mar 2026 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553874; cv=none; b=TRY2+mCTmIIH/417y5S0bepYx1bvOnlUtExUf2HASoJGCxQx+qePK3Z56fR8sbVmVNKDnWroDP4nXusQ+6RedmSI3h17oQvv2prQfzm9cF7VkdSgFOxebN48fZqOc5yC2WDJ81l2b0ITYywoZMdoyWfwL+dSVk9DeffcqjsTkYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553874; c=relaxed/simple;
	bh=FyDdjLedTpsP6TzUy6AnArgDyfiqI7jC6hlyZPHtYFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mv1zcjEvz6nOJ5iBNusC5n4G0sba22+gMjmxWw8b66XemH3b5LGE8aqmWYGVASuEaiT2Geio7pfNEvKSEYWmXP273xMjElaNWDr1eEP4No+5/3ylPRdlzgqjy0OvUX59pj1ZEUhhK8jvmo857xkmvSXyjw7vOQp/7bWjqsOOoxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2F91868BEB; Tue,  3 Mar 2026 17:04:29 +0100 (CET)
Date: Tue, 3 Mar 2026 17:04:28 +0100
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
Subject: Re: [PATCH 16/25] sparc: move the XOR code to lib/raid/
Message-ID: <20260303160428.GE7021@lst.de>
References: <20260226151106.144735-1-hch@lst.de> <20260226151106.144735-17-hch@lst.de> <20260228054716.GF65277@quark>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228054716.GF65277@quark>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 27, 2026 at 09:47:16PM -0800, Eric Biggers wrote:
> On Thu, Feb 26, 2026 at 07:10:28AM -0800, Christoph Hellwig wrote:
> > diff --git a/arch/sparc/lib/xor.S b/lib/raid/xor/sparc/xor-niagara.S
> > similarity index 53%
> > rename from arch/sparc/lib/xor.S
> > rename to lib/raid/xor/sparc/xor-niagara.S
> > index 35461e3b2a9b..f8749a212eb3 100644
> > --- a/arch/sparc/lib/xor.S
> > +++ b/lib/raid/xor/sparc/xor-niagara.S
> > @@ -1,11 +1,8 @@
> >  /* SPDX-License-Identifier: GPL-2.0 */
> >  /*
> > - * arch/sparc64/lib/xor.S
> > - *
> >   * High speed xor_block operation for RAID4/5 utilizing the
> > - * UltraSparc Visual Instruction Set and Niagara store-init/twin-load.
> > + * Niagara store-init/twin-load.
> >   *
> > - * Copyright (C) 1997, 1999 Jakub Jelinek (jj@ultra.linux.cz)
> >   * Copyright (C) 2006 David S. Miller <davem@davemloft.net>
> >   */
> >  
> > @@ -16,343 +13,6 @@
> >  #include <asm/dcu.h>
> >  #include <asm/spitfire.h>
> >  
> 
> <linux/export.h> can be removed from the two assembly files, since all
> the invocations of EXPORT_SYMBOL() in them were removed.
> 
> Also, xor-niagara.S ended up without a .text directive at the beginning.
> Probably it was unnecessary anyway.  However, this seems unintentional,
> given that xor-vis.S still has it.

I'll probably undo the split and just do the mechanical move for the
next version.  This was a bit too much change even if a split would be
my preferred outcome.

