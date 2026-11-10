Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272985;
	b=dLL8Mj89C3QssK4nb5V4qZvmxSBFxEyTnIhkC5RfaNjS93VvM3Hssx8z2CIY+fYEw0x6
	 X0vl+84Br7sjOUWhS6Lr3wo1YY4gDVgxzzpTjBxTbQBnFIEqZFViCDgH/6eyDthU6MYse
	 Vi9OUBvcYP5szageqrrwu/pUqyAVRWfP6j+c/eolxvDqYbBNde63MXHyR6jmWgukqcswU
	 v53qQH1qS0EmHVK3yORbD9P+q9XW8y1u/MCuyBvTlXpNYWkVjwaAzyB5ZPc5NHQreTShG
	 N35l7UaCjCt8jNsf49NoV/XLBn11Qmt8HEzr6x297swAxcxAg5Bw2GJKBdgtqIK2jSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272985;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=to4URsqxtJTbFmKpwZytobao7Gf403ptNh65jyzE0WM=;
	b=5RCMprPG3viUkBZynRHSXskWi7tkkcFiSq9k3Ia1Pi2JNrCuZUFr+4AW70BUdstOfIjm
	 8RtoOy5uf5uICUmIpk9oXk9qdoae3GhmmfepgLtsLeXaQ8pGVolO+YnmvbBN2vqHL19mH
	 TezRENCTrx9mnE7RXCbNsUlC0gKDhAxSXHSNhg7y8NxQ65diP6JkAmrETVk/brGg1/4a6
	 L3vGvJSRQfN1vtB3lW5WwdyzJlsnfkfppr0xe0UX3VEdb4Pxi7K0sTekCBYsgcYqHkxjq
	 +hr+72VRfjYPHxLHgyEf9LCSH1wa7Ry6LPQUd0MlBND1XCb3aSrzkLTmfmSic1W57+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gXV1WQGr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C391606A331;
	Tue, 10 Nov 2026 01:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gXV1WQGr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058481F0089F;
	Tue, 10 Nov 2026 01:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794272985;
	bh=to4URsqxtJTbFmKpwZytobao7Gf403ptNh65jyzE0WM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gXV1WQGrQcPdjiUv/tsrb40RSdvpIdiCSqfT3/UnWFIdH4Ye8LJJxjR8jXiX6LY+s
	 sFo4uQ77lb1CNsdJAqKBlm8fg91TdCqiP/s/mCWJ4s63sM2ErDt+aw15N61G6NjFRn
	 Q3AkOD8/YtfYeplsoFE3SEu8KWDaRGU15bupzOwaBwrjXkBxeGMmm3v/pRWkoHq072
	 JLiI+tE+vLyFkJSW1UTLv6na5wyMQBSdqWOdynbd5kz7j6JmnBoGnfEybZbllbCkYu
	 yNdAno4Cyc8Xx0HUtUf7O/cmglmiXZw6+d6b+OFigffvV4mmdVlxYVQtdKbhlTWigV
	 QWrpsaq0EdCAQ==
Date: Mon, 9 Nov 2026 17:09:43 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
	ardb@kernel.org
Subject: Re: [PATCH] lib/crc: x86: rewrite crc32c_x86_3way() in C with inline
 asm
Message-ID: <20261110010943.GB1958@quark>
References: <090c5f6603b1102c877c8649f7a6569f362bfe61.1794268279.git.wqu@suse.com>
 <20261110002255.GA1958@quark>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110002255.GA1958@quark>

On Mon, Nov 09, 2026 at 04:22:55PM -0800, Eric Biggers wrote:
> As much as I'd like to reduce the use of asm, I'm not sure this is super
> convincing.  We get worse code generation and have to fall back to
> inline asm anyway, as the x86 intrinsics are still unusable in the
> kernel (which is different from userspace).
> 
> This patch also introduces a compiler error with gcc. It seems only
> clang was tested.  (Showing again that this kind of code often has
> compiler-specific issues, and we have to be extra careful to test it
> with every supported compiler version.)
> 
> There's also a subtle bug where the inline asm blocks are missing the
> volatile qualifier, so technically they could be reordered after the
> kernel_fpu_end() and corrupt a userspace process's XMM registers.
> Without inline asm, this issue would not have been possible.
> 
> I'd be interested in seeing what you can come up with for
> crc-pclmul-template.S, though I think that one is going to be harder to
> replace.

Also, just to emphasize: most "C" code using this strategy will be
mostly inline asm blocks, since that's what is needed to access the
vector registers in kernel code.  See lib/raid/*/x86/ for some examples.

crc32c_x86_3way() is an exception because it mostly use scalar
instructions, with only a few vector instructions.  So it makes this
strategy seem a bit more workable.  But actually, as soon as this same
strategy is adopted for crc-pclmul-template.S or any of the many crypto
assembly files (AES, GHASH, ChaCha, Poly1305, BLAKE2, etc.) that use far
more vector instructions, it will become mostly inline asm blocks, just
like the RAID code.

So I feel it's kind of an odd path to go down.  Perhaps as a
prerequisite for reimplementing some of this code in C (or will it soon
be Rust?), we should get the x86 intrinsics working in the kernel first?

- Eric
