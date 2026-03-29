Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9212DC783;
	Sun, 29 Mar 2026 22:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774824689; cv=none; b=GnbDZlA28CCFddDI3F4KEm5zhRkG9CEI/JNKnlCYa1QVJRAarZfRD6T7rc+ndRyJCti8ButS3QfKBcJb+KGhy/KGn4NqWeQkTtdP1g3zZW0MRHGq+KSK95lxjyrcPztywVFUsjH7vuhwOwwfgONvnwFYtImpnQgTb3ykUZ4CLFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774824689; c=relaxed/simple;
	bh=xC03r/4dJ8Us44QpgIA9Ngu2zy8kWGCxh9mj0ZxoTHs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fqrqqKaXvnhzdC0BRQQLzxs/gm28moRvcuycOdomRqiY6n+57guD02b4B0yrL41IvG5bG01PjVmkhVeMu+08z3lqNo/8dol0W4j0w/tTKwFxHNtVwXDbAmUpT6U99dywNm2X/vQy8uJaJkWPX4b4R8CQQE/bGLBv8nZ4PGWtW1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JBtLNNMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JBtLNNMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6B6C116C6;
	Sun, 29 Mar 2026 22:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774824688;
	bh=xC03r/4dJ8Us44QpgIA9Ngu2zy8kWGCxh9mj0ZxoTHs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JBtLNNMxkC+Qck2+BGDNaaVFR64izaAKQJSJUR3TFGlVL+zj0esYpoV9thVBYizo5
	 2LdTKTg4q97XSRSKSMqWeByHX3v4Kwd3ip5W8A7e9SWOk90u7h9T0PIyI9/hHuozRw
	 xIxWNYXda49DMygxwfzePxOY5aQGe8Krgc64/5fY=
Date: Sun, 29 Mar 2026 15:51:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Richard Henderson
 <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, Magnus
 Lindholm <linmag7@gmail.com>, Russell King <linux@armlinux.org.uk>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Ard
 Biesheuvel <ardb@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG
 Xuerui <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Paul Walmsley
 <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>, Dan Williams
 <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>, David Sterba
 <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>, Song Liu
 <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
 <linan122@huawei.com>, Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: cleanup the RAID5 XOR library v4
Message-Id: <20260329155126.a01a5729b7d8376712182851@linux-foundation.org>
In-Reply-To: <20260329213119.GA2106@quark>
References: <20260327061704.3707577-1-hch@lst.de>
	<20260329213119.GA2106@quark>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 29 Mar 2026 14:31:19 -0700 Eric Biggers <ebiggers@kernel.org> wrote:

> On Fri, Mar 27, 2026 at 07:16:32AM +0100, Christoph Hellwig wrote:
> > Hi all,
> > 
> > the XOR library used for the RAID5 parity is a bit of a mess right now.
> > The main file sits in crypto/ despite not being cryptography and not
> > using the crypto API, with the generic implementations sitting in
> > include/asm-generic and the arch implementations sitting in an asm/
> > header in theory.  The latter doesn't work for many cases, so
> > architectures often build the code directly into the core kernel, or
> > create another module for the architecture code.
> > 
> > Changes this to a single module in lib/ that also contains the
> > architecture optimizations, similar to the library work Eric Biggers
> > has done for the CRC and crypto libraries later.  After that it changes
> > to better calling conventions that allow for smarter architecture
> > implementations (although none is contained here yet), and uses
> > static_call to avoid indirection function call overhead.
> > 
> > A git tree is also available here:
> > 
> >     git://git.infradead.org/users/hch/misc.git xor-improvements
> > 
> > Gitweb:
> > 
> >     https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/xor-improvements
> > 
> > Changes since v3:
> >  - switch away from lockdep_assert_preemption_enabled() again
> >  - fix a @ reference in a kerneldoc comment.
> >  - build the arm4regs implementation also without kernel-mode neon
> >    support
> >  - fix a pre-existing issue about mismatched attributes on arm64's
> >    xor_block_inner_neon
> >  - reject 0-sized xor request and adjust the kunit test case to not
> >    generate them
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>

Great, thanks, added to all changelogs.

> But yes, as Andrew mentioned there are two "xor: add a better public
> API" patches.  They should be folded together.

I folded them.

I'm a bit wobbly about upstreaming all this for 7.1-rc1.  It hits on a
lot of stuff and I don't think we've heard a lot from the affected
maintainers.

otoh, we're unlikely to learn much from an additional nine weeks in
linux-next so at some point one has to forge ahead and rely on seven
weeks of -rc to address any remaining niggles.  And I'm confident that
Christoph will support his work well.

But still, hearing some reassuring words about this would be
appreciated ;)

