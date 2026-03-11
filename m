Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162173BC67A;
	Wed, 11 Mar 2026 08:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.167.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773218750; cv=none; b=Cal30klhOZ7Mpb9KegQbVi8XzNBujzNIhrqhEeoOraLzpfc3qm87Q6fPvIkpoEVDdwXxdeQY4/kqEfyeBfYzTlK4/D+kmK00mhZM3rQPYs18HPEIL0N5sXfW78jFULOZuD08mooy62ioJE/QoRdTE4SxtWofTgRgstt20liCjAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773218750; c=relaxed/simple;
	bh=Tmt46hJ14n5mJT8WpkY0LC2/s3w1NMyJdvLKZ2I0GjA=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=r+t/jZGdatnd6kVnL3evvunDjFdWGrs1dyuMH7UuN1xFNe3wrq0mlJRNcdk2h7OrZIz6azG1x2lrn+LrxUbt9Rx84GTzT11ixfe17Q/XX6Z3a2YrHQndV+qEkLmGXV0KIxN3QsTRRE7l7ZnPYSFYMXSpyZjXiQsbDmQfWQ+PEzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; arc=none smtp.client-ip=116.203.167.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id BC6442B03D8;
	Wed, 11 Mar 2026 09:45:35 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id U1QpR9pLQfYI; Wed, 11 Mar 2026 09:45:35 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id E817E2ABFDC;
	Wed, 11 Mar 2026 09:45:34 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id sQ20C_OvpL54; Wed, 11 Mar 2026 09:45:34 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id 297CD2A87F7;
	Wed, 11 Mar 2026 09:45:34 +0100 (CET)
Date: Wed, 11 Mar 2026 09:45:33 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: hch <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, 
	Magnus Lindholm <linmag7@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, will <will@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy, CS GROUP" <chleroy@kernel.org>, 
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
	Li Nan <linan122@huawei.com>, tytso <tytso@mit.edu>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, 
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
Message-ID: <942530005.19163.1773218733711.JavaMail.zimbra@nod.at>
In-Reply-To: <20260311070416.972667-4-hch@lst.de>
References: <20260311070416.972667-1-hch@lst.de> <20260311070416.972667-4-hch@lst.de>
Subject: Re: [PATCH 03/27] um/xor: cleanup xor.h
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF147 (Linux)/8.8.12_GA_3809)
Thread-Topic: um/xor: cleanup xor.h
Thread-Index: ROrz3iTmErkYXUli/cm3A2WDQMn1kg==

----- Urspr=C3=BCngliche Mail -----
> Since commit c055e3eae0f1 ("crypto: xor - use ktime for template
> benchmarking") the benchmarking works just fine even for TT_MODE_INFCPU,
> so drop the workarounds.  Note that for CPUs supporting AVX2, which
> includes almost everything built in the last 10 years, the AVX2
> implementation is forced anyway.
>=20
> CONFIG_X86_32 is always correctly set for UM in arch/x86/um/Kconfig,
> so don't override it either.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> arch/um/include/asm/xor.h | 16 ----------------
> 1 file changed, 16 deletions(-)

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
