Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A83342CB6;
	Fri, 15 May 2026 04:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778819832; cv=none; b=pBj2lr3AzeMokUTXfs7dBx6x05zQE4J3cwFDMudlPxEke8ZSCvCadZsUiaI/f1hNGKWUFeVygVbDTdXDMDu2/UHK+Xke39yx+ES3mwPftc/YQNFTgXp9TKt2aTwP+bq8swDlJBddd2xlIEaE4V/CCxj8VeKa+/ZyRxbqL7cJykY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778819832; c=relaxed/simple;
	bh=75CeoD1WQf9By9GVdjaBm7kKQlw2et/QDjrTd7m9s38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmmqUWywd7yemazT2oFxSD0CArs68k4x7Ze979lgYWOTOYOXCJS82UDdMYcZRY9zLBXcjtB49YxxH9uCP30vOufkizyh8+7LPXzWUCLsWVLRPm5vHA/VBMjRrhe7xlrEGQvYPyPxJp1OVBGoLI7APNJ32hd9pT8xEA4lthsGPG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1B35A6732A; Fri, 15 May 2026 06:37:06 +0200 (CEST)
Date: Fri, 15 May 2026 06:37:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: kreijack@inwind.it
Cc: Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.cz>,
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
Message-ID: <20260515043705.GA3855@lst.de>
References: <20260512052230.2947683-1-hch@lst.de> <20260512052230.2947683-2-hch@lst.de> <20260512114231.GG2558453@suse.cz> <20260513054742.GA1018@lst.de> <0a8d1ff4-f5a2-49e9-aa45-d25dbe4ded40@libero.it>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a8d1ff4-f5a2-49e9-aa45-d25dbe4ded40@libero.it>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 14, 2026 at 09:51:59PM +0200, Goffredo Baroncelli wrote:
> I think that the David concern is : "what happens for an already
> existing btrfs raid6 3 disks filesystem when the user upgrade the kernel ?"
> (I am thinking when a new BG needs to be allocated)...

Then it will cleanly fail to mount instead of constantly corrupting data
and memory with every write, yes.  Which clearly suggest that such
file systems don't exist in the wild.

But if btrfs wants to keep supporting this I'll just add a _unsafe
version without the check in the core library.
