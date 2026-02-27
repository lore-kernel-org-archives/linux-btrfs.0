Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5194218B0;
	Fri, 27 Feb 2026 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772201598; cv=none; b=HD875XPhnQy8Kp+rv8kdqPAsY4fsI37vxH5IfXlB40n0oMvDlo6kkEWbe/nbpRoZl2dNiZzVJmzT7M74O9X/fF8BCy7NEnLG11X+b0mqa7xmdjshsoUkamAIK0Zjm9b7Jqr2SMyIgxlYFtk8MBJLx3o7wtaDThflE0I3ecTrJxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772201598; c=relaxed/simple;
	bh=JuTht8SH6bc8ucM5gaQqR6Ab0QML/v1HzgC/i0mHYxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FfrpjbE3hdQ7PiIUWRN6O0pS+h58walt/SmE4lkrZGtRvSBqQmeObJhynQPCl+haVmT+fMvuhNQAFg2EGKjO8Al38LlI0JLtVQTVrJyyUmM3Z6eFb+sNI5lYfiF8ahX2/hroLXTMd53a6SRxHw9q358xhZWSvHm1BlG2YoVTmKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5A9ED68B05; Fri, 27 Feb 2026 15:13:11 +0100 (CET)
Date: Fri, 27 Feb 2026 15:13:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Heiko Carstens <hca@linux.ibm.com>
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
Subject: Re: [PATCH 17/25] s390: move the XOR code to lib/raid/
Message-ID: <20260227141311.GA22216@lst.de>
References: <20260226151106.144735-1-hch@lst.de> <20260226151106.144735-18-hch@lst.de> <20260227090959.10882Af7-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227090959.10882Af7-hca@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 27, 2026 at 10:09:59AM +0100, Heiko Carstens wrote:
> However, I just had a look at the s390 implementation and just saw that the
> inline assembly constraints for xor_xc_2() are incorrect. "bytes", "p1",
> and "p2" are input operands, while all three of them are modified within
> the inline assembly. Given that the function consists only of this inline
> assembly I doubt that this causes any harm, however I still want to fix
> this now; but your patch should apply fine with or without this fixed.

Two comments on that: I thin kin the long run simply moving the
implementation to a pure assembly file might be easier to maintain.

Also with this series you can now optimize for more than 5 stripes,
which should be the mormal case.  I'll try to make sure we'll get
units tests to help with that.
