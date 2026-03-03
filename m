Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479764B8DC0;
	Tue,  3 Mar 2026 16:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772554315; cv=none; b=BdkCCFGpKvxK+oaqXxam0xVm2thnZEb2GCe+hIRVVWDCV7PeZyIGUKjtz6+rvPmqBE+QAaQWLZ0xjRzsY1bbpgr7VkyzCXvTqYMrmh3VBoW66z4GP1JpZKZf3PWHkJnc95jxHX1JBwaUeIuRxkRDtbI3+eJkqQiTrE1Urr5m1Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772554315; c=relaxed/simple;
	bh=qXfMFx1V+SjVZ1JKY59h8uVCQyv/ezN1YeeaK8ler8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L8eCwVgG3/P02nIJ0AKUf+KgRyJmk6K+Lc7ahVIFtDojUCjQuOPP2XFCZ3buLQKWQqgDmcLpG/y1++mV42FTRlsRVmEujWN3FBMWt5PIIVUB6oZ9Sy49wXvvdO8q8Z4nlQpRATKwFLV7nvOMxc8dIP/ztNh8EUL3H4uW+zDenY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E4C7E68BEB; Tue,  3 Mar 2026 17:11:45 +0100 (CET)
Date: Tue, 3 Mar 2026 17:11:45 +0100
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
Subject: Re: cleanup the RAID5 XOR library
Message-ID: <20260303161145.GK7021@lst.de>
References: <20260226151106.144735-1-hch@lst.de> <20260228073553.GL65277@quark>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228073553.GL65277@quark>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 27, 2026 at 11:35:53PM -0800, Eric Biggers wrote:
> >     https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/xor-improvements
> 
> Overall this looks great.  xor_gen() really needs a KUnit test, though.
> Without that, how was this tested?

fio data integrity testing on degraded raid.  But yes, a unit test
would be nice.

> Later we should remove some of the obsolete implementations, such as the
> alpha or x86 MMX ones.  Those platforms have no optimized code in
> lib/crc/ or lib/crypto/, and I doubt anyone cares.

I'd rather leave that to the architecture maintainers, but overall I
ahree.

> Also, I notice that no one has optimized this for the latest x86_64 CPUs
> by using the vpternlogd instruction to do 3-input XORs.  That would be
> another good future project.

Yes, as would rewriting the routines to deal with more than 4 + 1 stripes
as that is a really narrow raid these days.

