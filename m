Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030B634C155;
	Thu, 12 Mar 2026 13:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773323212; cv=none; b=vCKMQg4VWnTxAHMobonoj/BoKmtFjxn8f++VMKgtYlR6WBUNk6iLK2qB16Zxr8KudKh+Nzkdgdn+R/yhKIm/ZDawEepVNa9zj/j+X+dXSr+S63vgDPsXm56UA5Yt/UOoOGbv42WS6YZDABfSBVRX2cZV8PntGh/hPzRIS5yqEzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773323212; c=relaxed/simple;
	bh=l8xdTzfmFI9blWnX69yppRL0CTG4tWAVHoV5RzxnJ4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e3szPqUW2HQk/WsgBaaiKQi3OK9Lgms9FdbJf+fxLOdV18jAwKpwXTRiHOMJJniQGTkP4FBs2msWCh14hxgfLT41bpDjaQez2YKUVgWqEIiGxO4qBb78EZcZbYexzJE8owy5p2Az4uaptmnx9NweKk4mIw7ohl6a0vG2macg+gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=aNowo7eU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aNowo7eU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0435C4CEF7;
	Thu, 12 Mar 2026 13:46:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aNowo7eU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1773323205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l8xdTzfmFI9blWnX69yppRL0CTG4tWAVHoV5RzxnJ4M=;
	b=aNowo7eUwaDEsiVlTqmEAkItMBfiAqnQpwNdW5+Iir3vEvTnk82QibP2d05ImlF0a165mh
	nmvWlvpeFzo1/3YJJgy9A68B3kA75iz0ORvDTg44s5evgsV+Q5arPoARsc9Mpj0kc03vTo
	y0krEtMS6grTzTv7HePJJwYz8b+7S/w=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d18605ad (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 12 Mar 2026 13:46:44 +0000 (UTC)
Date: Thu, 12 Mar 2026 14:46:39 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
	Li Nan <linan122@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 26/27] random: factor out a __limit_random_u32_below
 helper
Message-ID: <abLDvwa7c3OXm_e2@zx2c4.com>
References: <20260311070416.972667-1-hch@lst.de>
 <20260311070416.972667-27-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260311070416.972667-27-hch@lst.de>

On Wed, Mar 11, 2026 at 08:03:58AM +0100, Christoph Hellwig wrote:
> Factor out the guts of __get_random_u32_below into a new helper,
> so that callers with their own prng state can reuse this code.

What Eric said. random.c is not "some library code" meant to be pulled
apart like this. If you think there are some good general purpose
arithmetic functions, by all means develop shared infrastructure in the
right place. But I think for this super simple/trivial _below function,
you can probably just place it additionally where you're using it,
without needing to touch random.c.
