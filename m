Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CB8384CE0;
	Wed, 13 May 2026 05:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778651272; cv=none; b=jI8qyoHu/2GuGAfG8M7jcUPVCHop4VH80gplVQqW78DQgPiV0xn2xZgUImTTeeAKUTp4O7LTpbJ8iLHXNReJVQYqemBkoMGuIEp2pRHIY4qATK9xHlZTeNxhedQqETdBjyAKbvS8r747ufDwpnCRiynFMPy5BDVmLIBJwmp/Xpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778651272; c=relaxed/simple;
	bh=gLgo4WQ3hzDs13tL91Gp16GFz3W0lr9TsHhf12nzTgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gWWqtE3oERaGl7wV8Z2+x/NZBOSBtbiR91Gz2yyzz3T1Tn/sYgYC/eYW9WDcKlZywJt7uYcTPD6/3UEHhIP9oPxryc2+IqZhjTP5T1WuEDrK+lxUEAV5tW8CyOI1WQdn6GWg5MylbT30u1P6gbRrz5n8RKJJp+9k0RlxuOxM9M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B404568B05; Wed, 13 May 2026 07:47:42 +0200 (CEST)
Date: Wed, 13 May 2026 07:47:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Sterba <dsterba@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 01/19] btrfs: require at least 4 devices for RAID 6
Message-ID: <20260513054742.GA1018@lst.de>
References: <20260512052230.2947683-1-hch@lst.de> <20260512052230.2947683-2-hch@lst.de> <20260512114231.GG2558453@suse.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512114231.GG2558453@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, May 12, 2026 at 01:42:31PM +0200, David Sterba wrote:
> On Tue, May 12, 2026 at 07:20:41AM +0200, Christoph Hellwig wrote:
> > While the RAID6 algorithm could in theory support 3 devices by just
> > copying the data disk to the two parity disks, this version is not only
> > useless because it is a suboptimal version of 3-way mirroring, but also
> > broken with various crashes and incorrect parity generation in various
> > architecture-optimized implementations.  Disallow it similar to mdraid
> > which requires at least 4 devices for RAID 6.
> > 
> > Fixes: 53b381b3abeb ("Btrfs: RAID5 and RAID6")
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This patch should have been sent separately as it has user visible
> impact and can potentially break some setups.

It _is_ sent out separate.

> The degenerate modes of
> raid0, 5, or 6 are explicit as a possible middle step when converting
> profiles.  We can use a fallback implementation for this case if the
> accelerated implementations cannot do it.

This is not about a degenerated mode.  For a degenerated RAID 6, parity
generation uses the RAID 5 XOR routines as the second parity will be
missing.  This is about generating two parities for a single data disk,
which must be explicitly selected.
