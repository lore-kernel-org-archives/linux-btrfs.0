Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BC830EF94;
	Fri, 10 Apr 2026 03:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775791191; cv=none; b=ZhdP/ahQccFp6cEXo28A4/5sic6/Q5rIRiakN03DY3aUyHhoa1AZ9aBt9VCokLJ9SLYF0wmAM0LyulPYQYaCtIdX9zP2ssuNJbtD6fCZqc8oGFLOfKDhZY56f/Etz3o6kGkdOTaHl8hojWmEdqpjxPke0kYTQ4kcpsnVNHfUZrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775791191; c=relaxed/simple;
	bh=++Koq39UWrgs6Y9/teNpfuGX4Prd7yZehxjZlfBpaLk=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=Ak0nrvXkPexITmWLxBs7XylQK+RYfnICDTD60Y6sA7K0Q038mPcgp661khz47fXka2ISiV0cLqgihMmp2a54s/XZ/yzHzuhNZJ4HuYOqQ8DwcdvuH7Ru0kBuG0gaxSkPimHXhKlfFDSM7IKq3zUl4elUACKjw28WExZx3WDqx1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdYIM+3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdYIM+3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35C1C4CEF7;
	Fri, 10 Apr 2026 03:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775791191;
	bh=++Koq39UWrgs6Y9/teNpfuGX4Prd7yZehxjZlfBpaLk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=mdYIM+3nOOfJk2sQndWIVe1crpn+qIFglFUaJi6YUZ8om+pF74JbkoMG1pCSpEb9w
	 XY42HnmovukKhj85guOzmyhoPciXUmwPx7036BzxDj+GBwDX7w8ZX/kQj6Kf75C9nQ
	 yMJOxpzFMvk+DFq2q3tbouAiWajtfDS+AXyxjQFI3HFmtdEmAwU/TRZgmOQyhKh0dz
	 oTEcDPh4RcJYLV/DB6MyHh1cNOYj4HnTWHBSTgpco77/7Mk4f7CQSMgdwxNaeolZeG
	 11Id3MhuCNF2BddA3SZqi8zEZAyyZSbKwJdKtgyQMtKdIjBxiedoSXRHs0s+vuBPie
	 fHhNTH/TVHimw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id BEAFCF4007B;
	Thu,  9 Apr 2026 23:19:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 09 Apr 2026 23:19:48 -0400
X-ME-Sender: <xms:VGzYaRzc9F2SaA_dXGONVlZncUeqwfeC1knsfsUGLqCLtL9x7AJ9oQ>
    <xme:VGzYaXbKB70COhi6wU5zcJDCn3jfZcRswNA20Sizt_IZgoixIWdWvIaDWTE9UJGaO
    0gyCPv6TWv531UsombbNhRf0U-TJegFRbhlgcIH7rcKGm2a1YHwez-u>
X-ME-Received: <xmr:VGzYaeCIWm-xaXNHRiAOee5n1VgDRaIYH8ii2WphVWSDkg5IlPqKJ2tQQw7rWGta-3eIj1g2bSuh8bC3JY4Fe1PIIjMC3ZQPqnM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvkedvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefkjghfufggtgfgsehtjeertddttdejnecuhfhrohhmpeffrghnucghihhl
    lhhirghmshcuoegujhgsfieskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    elhfeiudfgvdeijedtleeltdduueekffejjedvjefhgeevjeefueejledtleetjeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegujhgsfidomh
    gvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudejjedvfedtgeehhedqfeeffeel
    gedtgeejqdgujhgsfieppehkvghrnhgvlhdrohhrghesfhgrshhtmhgrihhlrdgtohhmpd
    hnsggprhgtphhtthhopeehjedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhgt
    hheslhhsthdruggvpdhrtghpthhtoheprhhitghhrghrugdrhhgvnhguvghrshhonheslh
    hinhgrrhhordhorhhgpdhrtghpthhtohepmhgrthhtshhtkeeksehgmhgrihhlrdgtohhm
    pdhrtghpthhtoheplhhinhhmrghgjeesghhmrghilhdrtghomhdprhgtphhtthhopehlih
    hnuhigsegrrhhmlhhinhhugidrohhrghdruhhkpdhrtghpthhtoheptggrthgrlhhinhdr
    mhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopeifihhllheskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhopegt
    hhgvnhhhuhgrtggriheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:VGzYaRWWYH9YS5_KZb8QZgCAsWZfUiB9ORAbpTx2OwSeNwf8aS1oTQ>
    <xmx:VGzYaYKyeSQq62O7WlXYf1xoalWcpZEhKySYJd9-cJQMpEvayfPE0g>
    <xmx:VGzYaaJiDRoNy9BMYAaTC41fiA_6sbPjbfWZ4OvQdt7iOTvnCgAc1A>
    <xmx:VGzYac91Cyql-IFbLq_KalJjxN3efCc9QroVK6-eoTOUQqKKiQULjQ>
    <xmx:VGzYaQXpDuEx9ex4m7qF5l0GU1hi1krNMW-ZgN0aa1e6laSCn6NuISRa>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Apr 2026 23:19:47 -0400 (EDT)
Date: Thu, 09 Apr 2026 20:19:47 -0700
From: Dan Williams <djbw@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Richard Henderson <richard.henderson@linaro.org>,
  Matt Turner <mattst88@gmail.com>,  Magnus Lindholm <linmag7@gmail.com>,
  Russell King <linux@armlinux.org.uk>,
  Catalin Marinas <catalin.marinas@arm.com>,
  Will Deacon <will@kernel.org>,  Ard Biesheuvel <ardb@kernel.org>,
  Huacai Chen <chenhuacai@kernel.org>,  WANG Xuerui <kernel@xen0n.name>,
  Madhavan Srinivasan <maddy@linux.ibm.com>,
  Michael Ellerman <mpe@ellerman.id.au>,
  Nicholas Piggin <npiggin@gmail.com>,
  "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
  Paul Walmsley <pjw@kernel.org>,  Palmer Dabbelt <palmer@dabbelt.com>,
  Albert Ou <aou@eecs.berkeley.edu>,  Alexandre Ghiti <alex@ghiti.fr>,
  Heiko Carstens <hca@linux.ibm.com>,  Vasily Gorbik <gor@linux.ibm.com>,
  Alexander Gordeev <agordeev@linux.ibm.com>,
  Christian Borntraeger <borntraeger@linux.ibm.com>,
  Sven Schnelle <svens@linux.ibm.com>,
  "David S. Miller" <davem@davemloft.net>,
  Andreas Larsson <andreas@gaisler.com>,
  Richard Weinberger <richard@nod.at>,
  Anton Ivanov <anton.ivanov@cambridgegreys.com>,
  Johannes Berg <johannes@sipsolutions.net>,
  Thomas Gleixner <tglx@kernel.org>,  Ingo Molnar <mingo@redhat.com>,
  Borislav Petkov <bp@alien8.de>,
  Dave Hansen <dave.hansen@linux.intel.com>,  x86@kernel.org,
  "H. Peter Anvin" <hpa@zytor.com>,
  Herbert Xu <herbert@gondor.apana.org.au>,
  Dan Williams <dan.j.williams@intel.com>,  Chris Mason <clm@fb.com>,
  David Sterba <dsterba@suse.com>,  Arnd Bergmann <arnd@arndb.de>,
  Song Liu <song@kernel.org>,  Yu Kuai <yukuai@fnnas.com>,
  Li Nan <linan122@huawei.com>,  Theodore Ts'o <tytso@mit.edu>,
  "Jason A. Donenfeld" <Jason@zx2c4.com>,  linux-alpha@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  loongarch@lists.linux.dev,  linuxppc-dev@lists.ozlabs.org,
  linux-riscv@lists.infradead.org,  linux-s390@vger.kernel.org,
  sparclinux@vger.kernel.org,  linux-um@lists.infradead.org,
  linux-crypto@vger.kernel.org,  linux-btrfs@vger.kernel.org,
  linux-arch@vger.kernel.org,  linux-raid@vger.kernel.org
Message-ID: <69d86c53cfc4_2b31100e7@djbw-dev.notmuch>
In-Reply-To: <20260327061704.3707577-25-hch@lst.de>
References: <20260327061704.3707577-1-hch@lst.de>
 <20260327061704.3707577-25-hch@lst.de>
Subject: Re: [PATCH 24/28] async_xor: use xor_gen
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Christoph Hellwig wrote:
> Replace use of the loop around xor_blocks with the easier to use xor_gen
> API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  crypto/async_tx/async_xor.c | 34 ++++++++++------------------------
>  1 file changed, 10 insertions(+), 24 deletions(-)
[..]
> @@ -168,11 +156,10 @@ dma_xor_aligned_offsets(struct dma_device *device, unsigned int offset,
>   *
>   * honored flags: ASYNC_TX_ACK, ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DST
>   *
> - * xor_blocks always uses the dest as a source so the
> - * ASYNC_TX_XOR_ZERO_DST flag must be set to not include dest data in
> - * the calculation.  The assumption with dma engines is that they only
> - * use the destination buffer as a source when it is explicitly specified
> - * in the source list.
> + * xor_gen always uses the dest as a source so the ASYNC_TX_XOR_ZERO_DST flag
> + * must be set to not include dest data in the calculation.  The assumption with
> + * dma engines is that they only use the destination buffer as a source when it
> + * is explicitly specified in the source list.
>   *
>   * src_list note: if the dest is also a source it must be at index zero.
>   * The contents of this array will be overwritten if a scribble region
> @@ -259,11 +246,10 @@ EXPORT_SYMBOL_GPL(async_xor_offs);
>   *
>   * honored flags: ASYNC_TX_ACK, ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DST
>   *
> - * xor_blocks always uses the dest as a source so the
> - * ASYNC_TX_XOR_ZERO_DST flag must be set to not include dest data in
> - * the calculation.  The assumption with dma engines is that they only
> - * use the destination buffer as a source when it is explicitly specified
> - * in the source list.
> + * xor_gen always uses the dest as a source so the ASYNC_TX_XOR_ZERO_DST flag
> + * must be set to not include dest data in the calculation.  The assumption with
> + * dma engines is that they only use the destination buffer as a source when it
> + * is explicitly specified in the source list.

In retrospect, no need to duplicate this help, but as is:

Reviewed-by: Dan Williams <djbw@kernel.org>
