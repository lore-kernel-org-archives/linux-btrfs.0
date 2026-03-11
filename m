Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0222F371892;
	Wed, 11 Mar 2026 18:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773255477; cv=none; b=YDNfCOO8wwfIqNvRVTKhCEOFVpNTSJ1FVjMlALgfnKn2U11PHYL3Bu1ytge1j+yRzhSflJzAbKbFa10AbrMRkZfBteDTFuye349I9HFRg1dfRLg9YudK2tS7A5dIevrIxhKtLX596K4j03hyb/C35FpL/AhfJFoCHQ7G06ucjuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773255477; c=relaxed/simple;
	bh=RIP4VTL8ZKfCAED/llWzV24bhb3+EBezOHbYfQlNNVw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=JXln7/F1KaLkPWddVMdeSqNh5bnrGxSL3R7eaMHnZUe98kJlWVSjIxjcpx+Sox6HmMCYI2d0HDh2VYPo5JTM46F4sPdrxleze6XXsFqnaoIOBT/stK3DAiqpnhCV/bivhhArnLIA3jmpivar0JFeoph+ydYhbx/zip+F9JmKW8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lwNHqHof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lwNHqHof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B60C4CEF7;
	Wed, 11 Mar 2026 18:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773255476;
	bh=RIP4VTL8ZKfCAED/llWzV24bhb3+EBezOHbYfQlNNVw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lwNHqHofCZymV9ZwzL4O4QC3oCCorqSKfgbbui0vSPfhppxGKPRL/IJ69bcF8P337
	 vhDG95oCrnrO9ZlV2DZHEmUO88ZgVNVnKPQNiPvM1Z9VRi+eMXmLsJiRCJ8qnumnHG
	 0HNrR7TfydlMZ9E+xCePC4BRnc2O1ZREJXn9QWnU=
Date: Wed, 11 Mar 2026 11:57:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Richard Henderson <richard.henderson@linaro.org>, Matt Turner
 <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, Russell King
 <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
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
 <linan122@huawei.com>, "Theodore Ts'o" <tytso@mit.edu>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: cleanup the RAID5 XOR library v2
Message-Id: <20260311115754.ca2206d1428c49c3bd6e93cf@linux-foundation.org>
In-Reply-To: <20260311070416.972667-1-hch@lst.de>
References: <20260311070416.972667-1-hch@lst.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Mar 2026 08:03:32 +0100 Christoph Hellwig <hch@lst.de> wrote:

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

Cool, thanks, I updated mm.git's mm-nonmm-unstable branch (and hence
linux-next) to this version.

I retained Heiko's ack on [17/27].
