Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5452EBBA9;
	Thu, 26 Feb 2026 22:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772143251; cv=none; b=NVnfvqo4VqSlJEpliBiyCyswY1QshlCNn3UKc97cWJ4d+NAa+9PxgDRcbDGU8NDPz7Z4yTGozN8gJfrGZNxpMQXY6JTs/GTjLX6SKAbe6FkgncVBq2A24gNbO9Q+/SLKFsLZuBG3YS7ehsyR8v4aSUwZHDHSAOT9E8deTXIlP5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772143251; c=relaxed/simple;
	bh=bHoctQII+LashGyqjlg7r/KCKOXEmPVxQqcyFL0nddc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AMHehlyxHwd7SFyUimgJQ6FndAMt32xIsSEx7LjfMZL5MtYXIoB+FgeF6okyI9R4vsZTSg4sfGm19vq82kZ5qH3Ews0NFGUvMxXBMdaUDisj+tzny2yyxG8pFbZT2KA5zplkGSMTCbC6q8haM4/v/6aHvoqme58xAm3FqM0c62s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3731168C4E; Thu, 26 Feb 2026 23:00:39 +0100 (CET)
Date: Thu, 26 Feb 2026 23:00:38 +0100
From: hch <hch@lst.de>
To: Richard Weinberger <richard@nod.at>
Cc: hch <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>, will <will@kernel.org>,
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
	Sven Schnelle <svens@linux.ibm.com>, davem <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	anton ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Gleixner <tglx@kernel.org>, mingo <mingo@redhat.com>,
	bp <bp@alien8.de>, dave hansen <dave.hansen@linux.intel.com>,
	x86 <x86@kernel.org>, hpa <hpa@zytor.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	dan j williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	linux-alpha <linux-alpha@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	loongarch <loongarch@lists.linux.dev>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	linux-riscv <linux-riscv@lists.infradead.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	sparclinux <sparclinux@vger.kernel.org>,
	linux-um <linux-um@lists.infradead.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 03/25] um/xor: don't override XOR_SELECT_TEMPLATE
Message-ID: <20260226220038.GA15172@lst.de>
References: <20260226151106.144735-1-hch@lst.de> <20260226151106.144735-4-hch@lst.de> <445921547.2198.1772142326749.JavaMail.zimbra@nod.at>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <445921547.2198.1772142326749.JavaMail.zimbra@nod.at>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 26, 2026 at 10:45:26PM +0100, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
> > Von: "hch" <hch@lst.de>
> > XOR_SELECT_TEMPLATE is only ever called with a NULL argument, so all the
> > ifdef'ery doesn't do anything.  With our without this, the time travel
> > mode should work fine on CPUs that support AVX2, as the AVX2
> > implementation is forced in this case, and won't work otherwise.
> 
> IIRC Johannes added XOR_SELECT_TEMPLATE() here to skip
> the template selection logic because it didn't work with time travel mode.
> 
> Johannes, can you please test whether this change does not break
> time travel mode?

I'm pretty sure that was the intent, but as I wrote above it worked
and still works on AVX-supporting CPUs by chance, and already doesn't
on older CPUs, and unless my git blaming went wrong someewhere already
didn't when this was originally added.

