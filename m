Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A07E36605D;
	Sat, 28 Feb 2026 07:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772262925; cv=none; b=E85MJKzW5wbD6FPtp5GJQxXaUXuwSqacnrky3jdWGW4C1+pCujIiHPpqGwKbsq2hmIDPDMXY2Ll4yeGey53CgPMmb2DEvj5Tk13JBtRt3UKtsR6y7TCqe8JpENDX1k6LQ94EHqQUQ50zvVsInXFmt92/mKGILP05zcvNu/h4Suk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772262925; c=relaxed/simple;
	bh=zWqt8Joca1KvplCXgcwLYttswt0fM6g1E9UxDDRiVTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ccZvmoEquZdZgekkulxpLeb2f/jW93Q0bGwHiZKDPp7cHDrReQIRGyBIGDQ7eGbeNaojwuYjhqIBHi/A4+RZsKVd7DOwP+I+GpQrWu+N8+W/GmHiSyx6p5R05RpcJyQhUnOWYobpmfgJt+M8QIU6KLBR/zI3y7gYbmP8xXbXBro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vz3k8kyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vz3k8kyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39044C116D0;
	Sat, 28 Feb 2026 07:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772262925;
	bh=zWqt8Joca1KvplCXgcwLYttswt0fM6g1E9UxDDRiVTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vz3k8kyTWZXHMK5zn7xXibfO3tQ+c+PplCLKYAb/nEXG6XVyxylOPTDzXmct2v/wF
	 WmaMWfVwV7ygt8481V3ntzFPARMBXxozM0S4vYM+fu8NTjVMCeXuO/SMU92oOtftWp
	 YviS01hMbTL4Nkd5vseytV1ImcKk3TWqfzHY4gUzr3YvSM+tsz1IZkLgKG1gW+KaxO
	 rZfmvPr+C7N697Fz2WWHkMDqBLHLN/FfRu//s+ea1lU/Ju8ebw+5Si06It93glm1Ff
	 QePblciurUn+VamkBgtZHIFv4AD004DBjvXkKZVZLJlMvZ9IVJkH2jsgcBMJr2hP7p
	 3dV2gvb5/dQtw==
Date: Fri, 27 Feb 2026 23:15:21 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH 09/25] xor: move generic implementations out of
 asm-generic/xor.h
Message-ID: <20260228071521.GK65277@quark>
References: <20260226151106.144735-1-hch@lst.de>
 <20260226151106.144735-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226151106.144735-10-hch@lst.de>

On Thu, Feb 26, 2026 at 07:10:21AM -0800, Christoph Hellwig wrote:
> Move the generic implementations from asm-generic/xor.h to
> per-implementaion .c files in lib/raid.
> 
> Note that this would cause the second xor_block_8regs instance created by
> arch/arm/lib/xor-neon.c to be generated instead of discarded as dead
> code, so add a NO_TEMPLATE symbol to disable it for this case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This makes the generic code always be included in xor.ko, even when the
architecture doesn't need it.  For example, x86_64 doesn't need it,
since it always selects either the AVX or SSE code.

Have you considered putting the generic code in xor-core.c (or in
headers included by it) before xor_arch.h is included, and putting
__maybe_unused on the xor_block_template structs?  Then they'll still be
available for arch_xor_init() to use, but any of them that aren't used
in a particular build will be optimized out as dead code by the
compiler.

lib/crc/ and lib/crypto/ take a similar approach for most algorithms.

- Eric
