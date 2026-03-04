Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C027B3148D8;
	Wed,  4 Mar 2026 15:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772637395; cv=none; b=GONBNsGnNXkC4vorZbqXxoDzrUxwwqfm3d/aweDb8dYcFdn+QifbGcEKSwahA70LD+I2+2zO8/6e5Wd+rKk1M+oDDawujY4LjOR6+ogIi+w/h1rZZvfeHlCh6nroF6sDGZ3f3r91lICia/EO6MMHWgTCbr+lu+npLofYmA4mV4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772637395; c=relaxed/simple;
	bh=LzQr+Wol7e2Y8ftHqltb++bMZa3SFiDaTCD+VxBflsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=he4faeEDls9NhH7BlLXtK7b7bKg0yWz1r9Gq1GcczWEo+Ey4qlOpVFfzm9uSBTjXXSw6EuqkKVDElQOGtLpiNmZhNJLuAz4NsBx19yEtFl4a8fK63kUso5ggE21ckFP+W5jblT0M16mal4SmlSOKBMtRT8oeWflwgXOQt+fpbjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q1J4oN1p; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q1J4oN1p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6YOM2WbXA6Qkgtapqxkvfve9MfkbbU3JEb7qOmomVt8=; b=q1J4oN1pPBSexJBFfjtr2VdcfT
	cPjNy395v4gDWuxsi/ha9yDNRWUDE6LFqfzn4Yd1LrI2S8TpWPL9z3MhAmoIER+ZDJyxwPon5M1aZ
	AskUH2Doi34eCDyGezZO7dFjB0MasMnhHu+waAlY2mSgI1X8HVcdj0ldXYJVqOQJGTHaRlrHebAgJ
	7wxEvMsC0Uv8vstvbUoelynHMruTuwwfR7BfY5x5rRwbRWYnr5u0aOyOekToDV4C2BditkWs1U/DG
	GZMgOgAqSwHzeMa0C5li6urfh2f+Xx0KFGH88a+OERM2YwXtwihCtup0aktg8uAV14j68e34o5DP6
	1F2fSdZQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxnwz-0000000DTMB-31pq;
	Wed, 04 Mar 2026 15:15:49 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 20C7A300FB6; Wed, 04 Mar 2026 16:15:48 +0100 (CET)
Date: Wed, 4 Mar 2026 16:15:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH 01/25] xor: assert that xor_blocks is not called from
 interrupt context
Message-ID: <20260304151548.GN1395266@noisy.programming.kicks-ass.net>
References: <20260226151106.144735-1-hch@lst.de>
 <20260226151106.144735-2-hch@lst.de>
 <20260227142455.GG1282955@noisy.programming.kicks-ass.net>
 <20260303160050.GB7021@lst.de>
 <20260303195517.GC2846@sol>
 <20260304145134.GA21983@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304145134.GA21983@lst.de>

On Wed, Mar 04, 2026 at 03:51:34PM +0100, Christoph Hellwig wrote:

> > How about "WARN_ON_ONCE(!preemptible())"?  I think that covers the union
> > of the context restrictions correctly.  (Compared to in_task(), it
> > handles the cases where hardirqs or softirqs are disabled.)
> 
> Good enough I guess.  Peter?

Sure. The only caveat with that is that for PREEMPT_COUNT=n this might
not work, it unconditionally returns 0.
