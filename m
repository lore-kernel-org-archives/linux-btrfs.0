Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F162030A;
	Fri, 22 May 2026 00:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779409053; cv=none; b=AOR+BXe3FHwLYwCLvOj0qQ+4R+tWu9zFrLjVZy6KgS0TaGVHDGcNruesKWw4UTYEjYU29JO6IbPq1+V3zwDFZir3gee6jzkaH2gHNprUtPhshe0ddxeiXfpUgib4aTJHwm4kKTn3pafGA2zOHKZkUEp429Fi8jsFErr5UhQHth8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779409053; c=relaxed/simple;
	bh=PZ642L4eiA5l0jaQb3SS62Q9ow/D8RsHXSgUbtVcVqs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=eMt5XKsllH8vAmv/NRMcJnE4wJfu0/wWhCRzRKrNddXnxjhiu+V8ALZzONPAjVMjGnj/AqZD5uE5MFRhboj02A07uc8x3t1Q3yYRw3uGEE3POopxW4ChOUVIJVYaubAswegUcsBhgxBXwF7Pj6aTgDZ3YVKtobiJufkpPTwG8qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tEOlAwj1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tEOlAwj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB491F000E9;
	Fri, 22 May 2026 00:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779409052;
	bh=CU1uL6EPLGCDhveEV6q88XhXLU9G2F321bQb4+LouN4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tEOlAwj1g8LscGq036JIP92ztTOZa0Zgac7ekTv/50pIaaEK2W4Kh2iSs9mjKKeU3
	 0E+2P+EF9NE/33lqS+qb4XkzDA6GlEgAvB+jA6sk+cyej3pym+Q94Vs41XiDgm/F+z
	 FHXvYWEtcRfRDonE2oSvzPrH33/ywop/mXaGAjBA=
Date: Thu, 21 May 2026 17:17:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@lst.de>, "H. Peter Anvin" <hpa@zytor.com>,
 kreijack@inwind.it, David Sterba <dsterba@suse.cz>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Ard Biesheuvel
 <ardb@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Paul Walmsley
 <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Dan Williams
 <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>, David Sterba
 <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>, Song Liu
 <song@kernel.org>, Yu Kuai
 <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, Li Nan
 <linan122@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH 01/19] btrfs: require at least 4 devices for RAID 6
Message-Id: <20260521171730.7872482df453975cf60ce7dc@linux-foundation.org>
In-Reply-To: <f46636c8-80ba-4802-a6a0-74cbc35e7bee@gmx.com>
References: <20260512052230.2947683-1-hch@lst.de>
	<20260512052230.2947683-2-hch@lst.de>
	<20260512114231.GG2558453@suse.cz>
	<20260513054742.GA1018@lst.de>
	<0a8d1ff4-f5a2-49e9-aa45-d25dbe4ded40@libero.it>
	<20260515043705.GA3855@lst.de>
	<34C16854-1065-4542-8836-DDED58EC1844@zytor.com>
	<20260518051207.GB9374@lst.de>
	<f46636c8-80ba-4802-a6a0-74cbc35e7bee@gmx.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 20 May 2026 18:11:09 +0930 Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> 
> 
> 在 2026/5/18 14:42, Christoph Hellwig 写道:
> > On Fri, May 15, 2026 at 12:59:34PM -0700, H. Peter Anvin wrote:
> >> I don't think this is a good idea. Error out; it is the btrfs maintainers' job to ensure user data isn't lost.
> >>
> >> The RAID-6 code has *never* supported only 3 units, and if it ever worked for *any* of the implementations it was purely by accident. Speaking as the original author I should know; this was deliberate as in some cases the degenerate case (3) would have required extra trays in the code to no user benefit.
> >>
> >> I would not be surprised if the kernel crashed or corrupted the page cache in that case.
> > 
> > It does, that's why I wanted to exclude it.  Anyway, for the about to be
> > resent version I'll drop this btrfs patch over the stated objection and
> > will otherwise not change anything.  This means the (IMHO hypothetical)
> > users of this configuration will get a WARN_ON_ONCE triggered, but
> > otherwise keep working (or rather not working) as before.
> > 
> 
> For the btrfs part, I believe I can get the current 2-disk-raid5 and 
> 3-disk-raid6 to fallback to raid1 inside btrfs.
> 
> I hope the btrfs part can be finished and reach the next merge window, 
> but I'm not 100% sure.
> 
> What is the planned cycle to merge this raid5/6 cleanup?

At present it's on track for the 7.2-rc1 merge window.  Does that suit?
