Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8459E1D5170;
	Sun, 29 Mar 2026 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774819885; cv=none; b=oenbhVjMfUjDs9Qyaj4/n5FMrt+clwZYq1hUP97YTDeT+WLlFQSTnlOQoXzW0tSzOyZ1Nd7CBkBCx0SZFyZ6h6upr2H2uni1u6eMdZid7ybJfDO1NWLA/ZjEf6F6Giyog3QEo8+iw+kgGegGPYFiZs/ndLB4b6BZMQ48HTsMvX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774819885; c=relaxed/simple;
	bh=PZ1wpSjnIe92PCeQuI7dS0b860us4G2UnkohZEsZsEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CP5t2LKYrtn3ig9fIkY/Wm0lsvEmcBuWfiS0guX3WStantniwAhchIWzRGeYydHohqTB1/HlKEZt6kAIT5eWoqBoGVpxsEbPt5KZ7BOjZ8CWdEpKDnHaEbfzx/iermB1KxuLCOnrSLLNJxR0gRmqoYgmlWZvtSByotSEt0Pu30E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULb4+Wxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULb4+Wxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2530AC116C6;
	Sun, 29 Mar 2026 21:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774819885;
	bh=PZ1wpSjnIe92PCeQuI7dS0b860us4G2UnkohZEsZsEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ULb4+WxdcWS0LYY9+V+ZhbQ2W3+gIjbkOcw58cK44Qjr9h22rlhdWgqrzvN7R6PFm
	 JREZi4dijq69Gaojf+s0flL7jtbEMPdMc1H9xiVEXRPZGXJ+mlST60uJB7ykogcxSg
	 kmfGm8RBCtS/7B0rt59NZvGOlgpFTgi1GJtUu13b3N8GxcTN5UmObfYBhRebgAbOcw
	 s6hlqjkrksTerC1XE20F/dvAdRtaJ9guJhs99OCpaYdx7JLVTyioUmYJlr1WpZMw7X
	 u3sIge99HyZ1zxhIvJaxFTUekKZ6rH63KCJunK++uOHXMhMrLVzR5ifEDLGHmrI7Dj
	 yDWAS2zzXgozA==
Date: Sun, 29 Mar 2026 14:31:19 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: cleanup the RAID5 XOR library v4
Message-ID: <20260329213119.GA2106@quark>
References: <20260327061704.3707577-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327061704.3707577-1-hch@lst.de>

On Fri, Mar 27, 2026 at 07:16:32AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> the XOR library used for the RAID5 parity is a bit of a mess right now.
> The main file sits in crypto/ despite not being cryptography and not
> using the crypto API, with the generic implementations sitting in
> include/asm-generic and the arch implementations sitting in an asm/
> header in theory.  The latter doesn't work for many cases, so
> architectures often build the code directly into the core kernel, or
> create another module for the architecture code.
> 
> Changes this to a single module in lib/ that also contains the
> architecture optimizations, similar to the library work Eric Biggers
> has done for the CRC and crypto libraries later.  After that it changes
> to better calling conventions that allow for smarter architecture
> implementations (although none is contained here yet), and uses
> static_call to avoid indirection function call overhead.
> 
> A git tree is also available here:
> 
>     git://git.infradead.org/users/hch/misc.git xor-improvements
> 
> Gitweb:
> 
>     https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/xor-improvements
> 
> Changes since v3:
>  - switch away from lockdep_assert_preemption_enabled() again
>  - fix a @ reference in a kerneldoc comment.
>  - build the arm4regs implementation also without kernel-mode neon
>    support
>  - fix a pre-existing issue about mismatched attributes on arm64's
>    xor_block_inner_neon
>  - reject 0-sized xor request and adjust the kunit test case to not
>    generate them

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

But yes, as Andrew mentioned there are two "xor: add a better public
API" patches.  They should be folded together.

- Eric
