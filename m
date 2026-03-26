Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E609E26159E;
	Thu, 26 Mar 2026 05:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774502326; cv=none; b=JZPT25COfHYPxt5ZBeQMsC51RQLdl5g6r2hVhc8AiDAl2sv3SrpIEhVcK3TEYL/tZj4pO1mwWS24hOYvME4IuVGGxc5aFPE+tIVX30ew5MLbqpvHc/OF3WBHBcR/YruPvluh6nEwskB1Jk/cVmBsqh4R2SBAvPqQyup8R55o36E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774502326; c=relaxed/simple;
	bh=LQ2AOVAyiIuqBIVY7X3bbSu1jE1YtSBoBtGFX3IePZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Il7kQUO/SmmAuaU3o7Kg+qlV+zh/8Dbt+VJu4O0/OmPhjTsWOuIbKZQiObpkhto7HGfDXkB2/5F1hzJkYVdFU3eJ8nn0iI6/IqaGL3ZQD5bcnB9SC6dClL9QR8MTWWlOApCOKS3fYf8Vtzj5gzOAFwIz7qaWFKr6Cx//bBz8H4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7351F68B05; Thu, 26 Mar 2026 06:18:37 +0100 (CET)
Date: Thu, 26 Mar 2026 06:18:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
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
	Li Nan <linan122@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>, linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: cleanup the RAID5 XOR library v3
Message-ID: <20260326051837.GA22847@lst.de>
References: <20260324062211.3216301-1-hch@lst.de> <20260325193954.GC2305@quark>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325193954.GC2305@quark>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 25, 2026 at 12:39:54PM -0700, Eric Biggers wrote:
> This generally looks good, but yes, please check the comments from
> https://sashiko.dev/#/patchset/20260324062211.3216301-1-hch@lst.de, as
> Andrew mentioned.

Yes, I've looked into them and fixed the, the current version in the
git branch already has the changes.

> looks real as well, though I haven't tested it.  If preemption is indeed
> not the right thing to check, then I guess (following up from
> https://lore.kernel.org/linux-crypto/20260303195517.GC2846@sol/) it
> would need to be something like:
> 
>     WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count() != 0);
> 
> Ugly, but we're running out of options.

So far I've just reverted back to the in_interrupted() check we had
before.  I can switch to the above, though.

> (This sort of thing is why the functions in lib/crypto/ and lib/crc/ are
> just supported in all contexts instead.  If FPU/vector/SIMD registers
> cannot be used in the current context, then a scalar fallback is used.)

We could do this fairly easily, but I'm not sure it is a good idea.
The callers of these routines are extremely limited, so we'd have to
add code for this which will then only be used by the new extensive
test code we'd have to add for it.

