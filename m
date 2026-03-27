Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09553D6664;
	Fri, 27 Mar 2026 08:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774599946; cv=none; b=HgC6oIurogoSYLPLVF/uh8D4kpePUd+ffWSjQQ0EUnAF9aaSz3kOOh4i/xo8JQtKfh9XHBU/t1CVZM2sqqZHiCqOlIv6lm/0yUeuecc4fQL0buNRS1AMaCMfVTbF8mo98HYnZcglpYHOneKWZAmGQCPxiA9FMqj+5djp989xrhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774599946; c=relaxed/simple;
	bh=oGcTlThlcrf/a6X6Pba0yaQBbOhK2gU5HD6vMRqLYbw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=hXcpfFv4ywoZBxpJBjttOJj8lWNYgJ3TuA1uwK6mnRpIfZEjJte+Pwg0aOI/38j3t2PWcW+KZ4reCJD9SH4dFFgQLiXNWOE9VieajAzy+LiopP1I6zJcQRyC6w02ASrJ7IrTqXSOQQEQiE8/2d4LI93SnrHJIGvzPccovZTcmvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njQORTNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njQORTNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F944C4AF0D;
	Fri, 27 Mar 2026 08:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774599945;
	bh=oGcTlThlcrf/a6X6Pba0yaQBbOhK2gU5HD6vMRqLYbw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=njQORTNYseBfNIOCfwhdeA9ppWJ7maUSfI1m29FCLMsOAc3VLwzoUH5yF8yKr6mea
	 bx+1V7DTQAZd4ojLaeGJ0Cf3haex4YnlcYGkJc6gqWpYVE6NyhljsbVP0BA8rn4ocl
	 th3E+L/MxnnFaA65UP+0OZlA+Vah5cD2+QCQtpMoLgNIFhCA8eqtKOZpCOxJlAkmXg
	 mk+TUk0Rtz4vIo7JSvIUgAmQeWqKyPfMFemVWMOZXJJwErSg1qzGGRRVp3lXzBSaJ8
	 C68setmayjda5hFti2rXgLBBjXsEJfs82WxkzWojyXlsFObrjk5392Uz/bQO/irUHV
	 e65UQpbwEdk/A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6F5B9F4006E;
	Fri, 27 Mar 2026 04:25:43 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 27 Mar 2026 04:25:43 -0400
X-ME-Sender: <xms:Bz_GaeV3zNaSpHJHySYxTNOI14Bf1EmJgTqGji8Tx6XrdR-ly4fPVA>
    <xme:Bz_GaVaecSFZVaUx_LS_q-dDchW3x2ph_U-FNZZvjkVa-2Cbgvi2qQJJQEWm1pEen
    o2Nmsvazvbril7mJ2bFLAHoL0kR_6ydzStl4XH8vMJ4O7DQEb3zgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdelkedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeehtddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrh
    hinhgrshesrghrmhdrtghomhdprhgtphhtthhopehlihhnuhigsegrrhhmlhhinhhugidr
    ohhrghdruhhkpdhrtghpthhtoheprghrnhgusegrrhhnuggsrdguvgdprhgtphhtthhope
    grnhhtohhnrdhivhgrnhhovhestggrmhgsrhhiughgvghgrhgvhihsrdgtohhmpdhrtghp
    thhtohepphgrlhhmvghrsegurggssggvlhhtrdgtohhmpdhrtghpthhtohepuggrvhgvmh
    esuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopegrohhusegvvggtshdrsggvrhhk
    vghlvgihrdgvughupdhrtghpthhtohepmhhpvgesvghllhgvrhhmrghnrdhiugdrrghu
X-ME-Proxy: <xmx:Bz_GadcJkX20GupXEUp-1Bp1i56g4LWcqwmuAAUTXMfU5fJkgo7Tdw>
    <xmx:Bz_Gae4Ua-AeB83mS_pFrGVbAUqLQoAnmgxrDbHOol1S2B-duVR5XQ>
    <xmx:Bz_GaRnLH2iPqmlmio84hLTWA0CS_wnMOI2-h11M3d92fo7SmGfrqA>
    <xmx:Bz_GaUbPhoo7c5hIYcd0gM0CfIgT0rg3SwoJSuxv9v4EumISMkIDVQ>
    <xmx:Bz_GafNBX4aAxc6vxqjfi2htd4zy-WLnaQnlHHZvUG3bWFOqd9K8W1h7>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3B247700065; Fri, 27 Mar 2026 04:25:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ALG_cRBuf6HF
Date: Fri, 27 Mar 2026 09:25:22 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Christoph Hellwig" <hch@lst.de>,
 "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Richard Henderson" <richard.henderson@linaro.org>,
 "Matt Turner" <mattst88@gmail.com>,
 "Magnus Lindholm" <linmag7@gmail.com>,
 "Russell King" <linux@armlinux.org.uk>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Huacai Chen" <chenhuacai@kernel.org>,
 "WANG Xuerui" <kernel@xen0n.name>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>,
 "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Sven Schnelle" <svens@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Richard Weinberger" <richard@nod.at>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Dan Williams" <dan.j.williams@intel.com>, "Chris Mason" <clm@fb.com>,
 "David Sterba" <dsterba@suse.com>, "Arnd Bergmann" <arnd@arndb.de>,
 "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fnnas.com>,
 "Li Nan" <linan122@huawei.com>, "Theodore Ts'o" <tytso@mit.edu>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-raid@vger.kernel.org
Message-Id: <e7979928-b33a-4132-b08b-d95b91b14295@app.fastmail.com>
In-Reply-To: <20260327061704.3707577-4-hch@lst.de>
References: <20260327061704.3707577-1-hch@lst.de>
 <20260327061704.3707577-4-hch@lst.de>
Subject: Re: [PATCH 03/28] arm64/xor: fix conflicting attributes for xor_block_template
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 27 Mar 2026, at 07:16, Christoph Hellwig wrote:
> Commit 2c54b423cf85 ("arm64/xor: use EOR3 instructions when available")
> changes the definition to __ro_after_init instead of const, but failed to
> update the external declaration in xor.h.  This was not found because
> xor-neon.c doesn't include <asm/xor.h>, and can't easily do that due to
> current architecture of the XOR code.
>

Even if it did, it wouldn't matter - __ro_after_init has no effect on declarations, only on definitions - it only controls the placement of the object in the .data..ro_after_init section (and declarations don't generate any code)

> Fixes: 2c54b423cf85 ("arm64/xor: use EOR3 instructions when available")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/arm64/include/asm/xor.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
