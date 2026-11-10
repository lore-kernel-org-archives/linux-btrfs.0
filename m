Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794274548;
	b=gkv2mmM+cAB2FzRoA4xVPXyelkggleET15P8i9wRX8KmMT0vpXLLprtghB4WWmKBXp3O
	 u9Osq0DUNooO4c2CF7kTW1NKB5vIMmI3vbw1YyJIH3TPs64gYlDyXV19ECo53p7ZXglsd
	 O5cl4fgPZvC9H+v04h6Fp8J3oME66KE5EMKzizEoWmhjJ58FlFF86LUshSjxFQVmrL47k
	 rcah3pwSkKu4uBCjgXpW3nyO2NyGufxbyI3saXaHKs7wLnU+GYF46Ld7gfViMnR4xVIse
	 G1gt+Y3XT1xaFvJzDCWNVsyS2md9LkYiojJxbassF53xMJ4FSWzI1mi1s8jhhcpqECw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794274548;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=HxWSiB1arzR1bjR0PmLUBKmuqzNFtIgeI+cvPlz5Vmg=;
	b=kYob3y0a+Ob5MKiRNB+/NNhEJpsD5z2oKPqwwEmBpbdGdeqaazsSV1QBusxu51k9nSh+
	 ShxLdILOuRYfT7iPNQ2LFDZ9ILODnG9anv4h6Brl5lE1l0VAK8mWL4GAyahrp9x6FKLVs
	 DU2vNjbeiefWmbaeJECE0TBTCbTTP+lzM+vMLoBXBlITkwwUjTVey0dlX7oB7ePvCdhsW
	 NEXmpLyeYeXGqQUDQPye+8VhBLN6yv6JHaB1fV8tqIn2XFVaTGBw/buesKSh2Fbi8+avX
	 nA5guGg+SXE68stHeSRa1buqUpgfk9rAXgonMHtXmNYBKfHDH9ELnL21F5Yh7F9yxQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N7QXZjzV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6DC606A31C;
	Tue, 10 Nov 2026 01:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N7QXZjzV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A751F0089F;
	Tue, 10 Nov 2026 01:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794274547;
	bh=HxWSiB1arzR1bjR0PmLUBKmuqzNFtIgeI+cvPlz5Vmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N7QXZjzV68kahKEBHFCLlEPS7uC4v3rk7fCtwtX/xnoRkUS/UBMak/MXYEU8gJ5YH
	 crHWvIvV8EZ3rCONwodtZkF/b8yZ8q5VpmGDJ11TJZ1ibDdrcWZmPD0N88cUan7uMm
	 2B02/KkvTze8wbTfWdoemXSwnoTK0WoHlyty8crAy8rRwNvb3uJEdudWNe0Qkk1OTx
	 Txs3I+gmIPh34AfRGrSjE+ypogw/3w84VzZeYJ4J+tGcTdY4AOqzwQwY0eyDmtujH2
	 ptCb01yn48MU/aJk3Iq2gWoRH+rwqV9uD7HIF+HVVgj+aWbrHmNEBolLVtESgM5g8O
	 aoBbD29I+bRtg==
Date: Mon, 9 Nov 2026 17:35:46 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
	ardb@kernel.org
Subject: Re: [PATCH] lib/crc: x86: rewrite crc32c_x86_3way() in C with inline
 asm
Message-ID: <20261110013546.GC1958@quark>
References: <090c5f6603b1102c877c8649f7a6569f362bfe61.1794268279.git.wqu@suse.com>
 <20261110002255.GA1958@quark>
 <20261110010943.GB1958@quark>
 <44965cd2-30f9-4846-86b5-537f94f18958@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44965cd2-30f9-4846-86b5-537f94f18958@suse.com>

On Tue, Nov 10, 2026 at 11:52:03AM +1030, Qu Wenruo wrote:
> 在 2026/11/10 11:39, Eric Biggers 写道:
> > On Mon, Nov 09, 2026 at 04:22:55PM -0800, Eric Biggers wrote:
> > > As much as I'd like to reduce the use of asm, I'm not sure this is super
> > > convincing.  We get worse code generation and have to fall back to
> > > inline asm anyway, as the x86 intrinsics are still unusable in the
> > > kernel (which is different from userspace).
> > > 
> > > This patch also introduces a compiler error with gcc. It seems only
> > > clang was tested.  (Showing again that this kind of code often has
> > > compiler-specific issues, and we have to be extra careful to test it
> > > with every supported compiler version.)
> > > 
> > > There's also a subtle bug where the inline asm blocks are missing the
> > > volatile qualifier, so technically they could be reordered after the
> > > kernel_fpu_end() and corrupt a userspace process's XMM registers.
> > > Without inline asm, this issue would not have been possible.
> > > 
> > > I'd be interested in seeing what you can come up with for
> > > crc-pclmul-template.S, though I think that one is going to be harder to
> > > replace.
> > 
> > Also, just to emphasize: most "C" code using this strategy will be
> > mostly inline asm blocks, since that's what is needed to access the
> > vector registers in kernel code.  See lib/raid/*/x86/ for some examples.
> > 
> > crc32c_x86_3way() is an exception because it mostly use scalar
> > instructions, with only a few vector instructions.  So it makes this
> > strategy seem a bit more workable.  But actually, as soon as this same
> > strategy is adopted for crc-pclmul-template.S or any of the many crypto
> > assembly files (AES, GHASH, ChaCha, Poly1305, BLAKE2, etc.) that use far
> > more vector instructions, it will become mostly inline asm blocks, just
> > like the RAID code.
> > 
> > So I feel it's kind of an odd path to go down.  Perhaps as a
> > prerequisite for reimplementing some of this code in C (or will it soon
> > be Rust?), we should get the x86 intrinsics working in the kernel first?
> 
> Indeed, it works almost flawlessly in user space just because there are
> already intrinsics available, and most of the code is just regular control
> flow, with mostly scalar code.
> 
> Thanks for the feedback, I'll just give up the idea in kernel, and enjoy the
> complete intrinsics in user space for now.
> 
> Thanks,
> Qu

Okay.  I'd be interested in someone trying to get the x86 intrinsics
working in the kernel, though.  Just when I last tried it, it still
wasn't possible to include <immintrin.h> without errors.

- Eric
