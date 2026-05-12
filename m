Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EC449250D;
	Tue, 12 May 2026 09:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778579438; cv=none; b=LZK8fkvRk/dFZAkO9G/xced0hT5FWewK2Adblrbj56UhN5hkuIS9egXbMJ2jqM7UXjn4J/wx7t4vm2oAGI8xjWSQWfXtq2Np9CusecHTev6UN1s1JvJ0iaWp0zN8YS2Kml0IruAiESqZ8vz9xHpIZLcZGU8RxzXnZ+PQ0VQpOt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778579438; c=relaxed/simple;
	bh=iodQUQY7CnisbRWz7ZX1kdnUrHJlSwk4Axa8QKYq830=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Uy2VUqZKm8UTXT513Dfcv5Ygz1flKPozBxk4LqqKZM80+vpjYEnHtsmIoT3OYbB0+6kb+0ChFzC0scTrPXRgpUEsWhWs/uDV6Cg6AMf7l7ENROt+tU2pmrNvQC4pVqIeSv/67U/vLY7xMfTQJcEC3gdh1fiHtKFvEfvpB7P24/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFOgFHvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFOgFHvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F87C4AF0B;
	Tue, 12 May 2026 09:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778579438;
	bh=iodQUQY7CnisbRWz7ZX1kdnUrHJlSwk4Axa8QKYq830=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=XFOgFHvn9mBF2xBvRAZWYN4FsdnnUCfPsyFwGq5E9zA90qIOCobVdiEX9IjRuOO7A
	 a4koWchkllcAIttf8zp8nn4DNgAVrP9LdSX7c7Wd2O/Ip/XWfV7tEV0OA9U7Udc+UE
	 fEBu5x2ef3P1zVecOZKVBZrnFtNm/j8jBWssv5lVpyaW+nKCdX9FnSHkuv+MOahJJE
	 QNDdbgoh7OoscH495SUEFI0BJnaKehG0YhHRaOpuk7FVyVPOsRcJRVWd+JLcdYAR9J
	 Mh1IFQ3qEmNBYLJIOPrHNmKAZ1ztNQxjTy4SJZikX6wyepAIsQBzQb9nb5w/at5zDd
	 CFzv2hvfalSuw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 69211F4007E;
	Tue, 12 May 2026 05:50:36 -0400 (EDT)
Received: from phl-imap-14 ([10.202.2.87])
  by phl-compute-01.internal (MEProxy); Tue, 12 May 2026 05:50:36 -0400
X-ME-Sender: <xms:7PcCam9YJOHuCSkFlDq4ISbUnfEsy1OEjiwfu2I0G97RJXn0Y9Qj3Q>
    <xme:7PcCahg10CcdO5ywOYNj_MoUADdtr56c-r9bHz7tueJKnmE7BlO5CNe34OWAHP6O0
    K2ZP7MTmRqCKNmM6To0iTGAEXW_mzbRu-_Ppobim0hC3yvVCtlniA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvddugeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeetgedvtddttdeuffegvdefgffgteeiueejuefhjefhvdekkeelkeduteej
    tdetheenucffohhmrghinhepihhnfhhrrgguvggrugdrohhrghenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhguodhmvghsmhhtphgruhht
    hhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqdeffedvudeigeduhedqrghrug
    gspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurdgtohhmpdhnsggprhgtphht
    thhopeegfedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnke
    druggvpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdp
    rhgtphhtthhopegrrhhnugesrghrnhgusgdruggvpdhrtghpthhtohepphgrlhhmvghrse
    gurggssggvlhhtrdgtohhmpdhrtghpthhtoheprghouhesvggvtghsrdgsvghrkhgvlhgv
    hidrvgguuhdprhgtphhtthhopehmphgvsegvlhhlvghrmhgrnhdrihgurdgruhdprhgtph
    htthhopegtlhhmsehfsgdrtghomhdprhgtphhtthhopeihuhhkuhgrihesfhhnnhgrshdr
    tghomhdprhgtphhtthhopegrlhgvgiesghhhihhtihdrfhhr
X-ME-Proxy: <xmx:7PcCalktau1ceeO9LVmwrvdgtBQqFGLkbXstpSg8yybS685IYcHORw>
    <xmx:7PcCasmugZGdftyVI7SsXjAnPbfXZESq-0jgJf5WHEk-4Op-5tihhg>
    <xmx:7PcCakOBuua_a1L3B6_7D8BIKwPWLDsIB0zTRk7q4odJEd-XR7f0rg>
    <xmx:7PcCamtx3Q0fvbGtW41fj2F_sqDaICjJw47CJSybFMv4EVU0bnkNFA>
    <xmx:7PcCauA9QdM04AOLLlOCDA53c0jW-oZSzKQywL6_3ngSclabTlPoqQSc>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 38C50C4006F; Tue, 12 May 2026 05:50:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 12 May 2026 11:50:15 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Christoph Hellwig" <hch@lst.de>,
 "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Catalin Marinas" <catalin.marinas@arm.com>,
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
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Dan Williams" <dan.j.williams@intel.com>, "Chris Mason" <clm@fb.com>,
 "David Sterba" <dsterba@suse.com>, "Arnd Bergmann" <arnd@arndb.de>,
 "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fnnas.com>,
 "Li Nan" <linan122@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-raid@vger.kernel.org
Message-Id: <d40e984f-7dec-425c-bf80-a255980c7457@app.fastmail.com>
In-Reply-To: <20260512052230.2947683-1-hch@lst.de>
References: <20260512052230.2947683-1-hch@lst.de>
Subject: Re: cleanup the RAID6 P/Q library v2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Tue, 12 May 2026, at 07:20, Christoph Hellwig wrote:
> Hi all,
>
> this series cleans up the RAID6 P/Q library to match the recent updates
> to the RAID 5 XOR library and other CRC/crypto libraries.  This includes
> providing properly documented external interfaces, hiding the internals,
> using static_call instead of indirect calls and turning the user space
> test suite into an in-kernel kunit test which is also extended to
> improve coverage.
>
> Note that this changes registration so that non-priority algorithms are
> not registered, which greatly helps with the benchmark time at boot time.
> I'd like to encourage all architecture maintainers to see if they can
> further optimized this by registering as few as possible algorithms when
> there is a clear benefit in optimized or more unrolled implementations.
>
> This series sits on top of the "cleanup the RAID5 XOR library v3" series.
>
> A git tree is also available here:
>
>     git://git.infradead.org/users/hch/misc.git lib-raid6
>
> Gitweb:
>
>     
> https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/lib-raid6
>
> Changes since v1:
>  - fix arm64 objdir != srcdir builds
>  - call the kunit module raid6_kunit.ko from the beginning
>  - update MAINTAINERS
>  - don't require preemptible context and apply the same restrictions as
>    the merged version of the XOR API
>  - fix the arm64 default in Kconfig
>  - pick the last registered (and presumably most optimized) algorithm when
>    benchmarking is disabled
>  - port over the randomization fixes from the XOR series
>  - misc other kunit cleanups
>  - require at least 4 devices for RAID6 to skip broken special cases
>

Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
Acked-by: Ard Biesheuvel <ardb@kernel.org>
