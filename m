Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C57146D5A;
	Sat, 27 Jun 2026 01:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782524217; cv=none; b=GG3z24Y8jgsaEmL9lYxfbBnRYAZD4n4SQRWf8IYId9y5KnjeR7XAwCxAugYOix5PKG7+2kD7fK2emsExyso5+NN8DNDEKnUURHaOtezhINYZSpFWf1sB+eZCBmIov3A9VzpO/Zx5mu6T4M+A2U2BKrl+1U2i/6PHFTXG9YN0Qgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782524217; c=relaxed/simple;
	bh=vlFmuIXNikKGJcM/rV+RwQGeISv45Ze+30sLXQvpSug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=szZyCKuy/+bRIchGnwD3bXDx7kkZ4Y4QSSXOTc2F+K7GA7xscXv0EVxgIMIh1APr7aBDTmwpzRlAETlSak9PqVgwXLzV9UNJfNB4l10yBKHCC6POVMGoCqj6ime4K2WtlAZrIsHj4E3i9yBShpAEI5DJOoB+1C+JUoUzqZ3k1w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=qMyBFc1g; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="qMyBFc1g"
Received: from [IPV6:2601:646:8081:7da1:dcd4:e1f8:5d79:bdb4] ([IPv6:2601:646:8081:7da1:dcd4:e1f8:5d79:bdb4])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65R0qN0N2285168
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 26 Jun 2026 17:52:24 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65R0qN0N2285168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026052701; t=1782521550;
	bh=CoKSivJMaQDV2sSkRTRw7olGkcZfQ72Xwmih/Aa0td0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qMyBFc1gnGXRksBwsJ1/rUznZgiE7lPuLPv/lWpmOM+5Q3Fqu1GkBtPV/i01hTsmm
	 FyrrwODPBIMXlAoyCpEVfCiClmUhwPWsNagz78j3LDMf+Ut0XXJAAidVe9l1aTOAut
	 7WQuEQASgzET2NWeiLHKYC5brvZfsPACaGhvlYNW5X1iG8c+02aTJiS4yaJSFbtRty
	 RzVpKhz70FSqCBKm8TK2gLW8sDPukFdgs1lqJ60AGqtpglwDIA/PnerR6f0L+dvu0f
	 tzL0aZnBm0Ed9q+Fj1E4zhVGr5LPAVMhZk4GFV4YP0Rst/9nwzTfe9CuWNPpW58FjU
	 Q8Foj51/YA5sw==
Message-ID: <7d8efc7c-65e3-49f8-9381-910de7affef2@zytor.com>
Date: Fri, 26 Jun 2026 17:52:18 -0700
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: cleanup the RAID6 P/Q library v3
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
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
References: <20260518051804.462141-1-hch@lst.de>
 <20260518141205.c100f76eec5f58e78bbbf7af@linux-foundation.org>
 <20260519082432.GA14956@lst.de>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20260519082432.GA14956@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026-05-19 01:24, Christoph Hellwig wrote:
> 
> raid6: rework registration of optimized algorithms
> 
>  - avx2 instead of avx512 is probably the right thing for no
>    benchmarking, but if it was intentional (it wasn't), that should
>    be document.  So I'll just switch back to the previous version to
>    keep the state of the art

It is unlikely to be the right thing *going forward*, though.

The very unfortunate performance inversion is likely model-specific. It is one
of those things where you largely would have to have a list of quirks :(

	-hpa

