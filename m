Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E042EB5AF;
	Sat, 28 Feb 2026 05:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772257055; cv=none; b=eJvN/QXQHTmgxUR25TTfEGbJrx+9CbSuHaZGKvia5v1aLVmCZ6He/RMbLQ9SkfilzsvsuVuU4+2DkqJslcXhz28+8SM0lGcEnTLG24ql2aOhoA6AxHHjp8W/wyELnEyz66E7UlHk6xQH84c4oHRKFdnk6yW2Uz66UogMTT1IDH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772257055; c=relaxed/simple;
	bh=eqLNM+it9jPNWRs+scO49PSKMIRVyGiqn9NcqSlCp7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q/4XkdK9AuhzrwTLQlud7tjATmEfhZGZbtmeYjWmkRdxDVZ9XRkYeeThj1c8hMuUnP5cpDD53sXoJp4riVbhOYMnakmI29YmuLGzs9tRq3hyMUAQ5UmFKURd6ADH1DHpCYV2IIsm6vjYjXzeklov9WQVYaSJcMMuTl1ksM9kOko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vJAxXZ8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vJAxXZ8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE76EC116D0;
	Sat, 28 Feb 2026 05:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772257055;
	bh=eqLNM+it9jPNWRs+scO49PSKMIRVyGiqn9NcqSlCp7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vJAxXZ8Kz5WRI3FAqQiiWltyd3uQ9vRfiXCgBQwT4V+lApPXGfBKpNyhyElFSuB3u
	 XB4VENMAfKNQt4jt5mepYgezGyP/JFcan/V5g78ruKQj4Ji3BOedSoLRvaGOzY6b7q
	 Mc5XWWLUQF0PcVSlTTmo7S7Zck6GQKRu3zWFaP+B5XItpiitYzcZpUfca6qi8XUfOd
	 6vh1cIQZcaLVpiV5n3ZguAWWWmPlxPcj2Nj9plSsomBCSSLqZZekWhAfjQ2YeYW7iu
	 rDzWS5l+PL0z3I+4kxGk4sYmPecb+wzM6vyPcl7Y9d2Uxa1CYls2Am5BPUZnt/qH5z
	 mB77YqO/RTn8A==
Date: Fri, 27 Feb 2026 21:37:30 -0800
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
Subject: Re: [PATCH 15/25] riscv: move the XOR code to lib/raid/
Message-ID: <20260228053730.GE65277@quark>
References: <20260226151106.144735-1-hch@lst.de>
 <20260226151106.144735-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226151106.144735-16-hch@lst.de>

On Thu, Feb 26, 2026 at 07:10:27AM -0800, Christoph Hellwig wrote:
> Move the optimized XOR into lib/raid and include it it in xor.ko
> instead of always building it into the main kernel image.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/riscv/include/asm/xor.h                 | 54 +------------------
>  arch/riscv/lib/Makefile                      |  1 -
>  lib/raid/xor/Makefile                        |  1 +
>  lib/raid/xor/riscv/xor-glue.c                | 56 ++++++++++++++++++++
>  {arch/riscv/lib => lib/raid/xor/riscv}/xor.S |  0

The EXPORT_SYMBOL() statements in xor.S can be removed, since the
functions are now located in the same module as their callers.

- Eric
