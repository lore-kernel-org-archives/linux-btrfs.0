Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56E933A9C3;
	Wed, 25 Mar 2026 19:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774468705; cv=none; b=Ihy1fJT7MjVF3zDnDheKe0WGJLY5/UGv4tJt+FIcLmP0QMAPncyCPVeGDAxxCVFg4fpbhSZ3h66o3XL91Ukpa8WXzT79/IbGJyZJYmtV6JxZi/5XcPBjFLzC+nvVCy72+IRf2qtDIO58YQayx7FbRyEjiBMzT8EYDpZmtkSROPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774468705; c=relaxed/simple;
	bh=sejDKf3P8sESG5dibTCxwy1iyZIw53jwzdWcE7qNmpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MbUAQ8+jDn66HyUdjylptDhCBYYnOquDfNw4B64z9c8QHqaQ6UzKZML6E4rEvn/MF44AyF39hG8JrCPW1yOM+xgIudsXi1k7TxjUB/Owhz5CwG6aW9+SJe2IPNhdXggv/waTAqq0WMEVh6Fhi5BoRTfsUCM1sfhpq5w/DMB+Cuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ge5aalab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ge5aalab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D017C4CEF7;
	Wed, 25 Mar 2026 19:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774468705;
	bh=sejDKf3P8sESG5dibTCxwy1iyZIw53jwzdWcE7qNmpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ge5aalabCqZpp2QV5kqs/vYycoJuqkRoa8OBOAkbF709CENIyaMYwhDvGA5ZmhPZt
	 uwKdRiC3Cl5ZK3d5Un9FUbs9cKXxNKCY6gkKzPEXJOUXDaqwkeVNlPxvdAJwqG7YKW
	 lIYxvZcgfmDmflgygmhJEUImKL9vwBOfEzSiOFGHgfj3Klvy6w4NQMdlJgbR9hMqrG
	 H4++cneHOvL+Ujzn+CcEgc7qA05317D8Q9rBGN3xJLw1p1s1oXuLQklwmmcYGJXV2A
	 FM+3W2mqWxh2TwuA4BQio+NeDp+0q0ezZAW3u3LQYmFQINgb4M2bbIWWEdcCh46Isa
	 Z617FMBDSIq2Q==
Date: Wed, 25 Mar 2026 12:58:21 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
	Li Nan <linan122@huawei.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 02/17] raid6: remove __KERNEL__ ifdefs
Message-ID: <20260325195821.GD2305@quark>
References: <20260324064115.3217136-1-hch@lst.de>
 <20260324064115.3217136-3-hch@lst.de>
 <59d1d178-c141-4229-81e9-a6c23fa81f2f@zytor.com>
 <fa11e4d3-1c70-4fa7-9f03-8772c002be6a@zytor.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa11e4d3-1c70-4fa7-9f03-8772c002be6a@zytor.com>

On Wed, Mar 25, 2026 at 09:13:16AM -0700, H. Peter Anvin wrote:
> On 2026-03-25 08:13, H. Peter Anvin wrote:
> > On 2026-03-23 23:40, Christoph Hellwig wrote:
> >> With the test code ported to kernel space, none of this is required.
> > 
> > I really *really* don't like this.
> > 
> > The ability of running in user space is really useful when it comes to
> > developing new code for new platforms, which happens often enough for this code.
> > 
> 
> That being said -- and I do say this as the original author of this code --
> this should be reduced to the maximum extent possible to a (minimal) set of
> #ifndef __KERNEL__, which should be localized as much as possible. The actual
> user space components, even such a thing as a simple #include, should be moved
> to a separate user space header.
> 
> But pretty please do leave the ability to debug the algorithms in user space.
> This is hard code to write and debug; it is not just about regression testing.

While I do like developing code in userspace as well, I've been doing it
less over time as the kernel's tests and benchmarks have been improved.
Running the KUnit tests is pretty straightforward and fast.

The issues with providing userspace build support in the tree are that:

- It has to be maintained.
- It's fundamentally a bit of a hack that is used only by developers
  (who always have the option of doing something locally that is
  tailored to the specific function they're working on)
- It diverts effort from the kernel's actual test and benchmark.

So while the faster iteration speed that userspace development enables
is definitely nice, I do think we should be cautious with committing to
maintain it in the kernel tree.  If it's causing problems for the
ongoing refactoring, dropping it for now seems reasonable to me.

I would suggest adding a benchmark to the KUnit test similar to the
crypto and CRC ones, though.

- Eric
