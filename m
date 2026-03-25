Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8933E9580;
	Wed, 25 Mar 2026 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774454316; cv=none; b=Rf8l0BmT10S+p9Q1SwbmldrlK8vBBAc1Wvn0OQ6G7l8MMhZ9PjZfEDZ3sAp63FrOKI46h8Ol/DqnNOJa7INwIxMmhfY82xYJYx0Qpz1d7WxFRsqOSSnLTnl17/LEfK0jwnYB7/a2Yo4/33uFmOSNU6lhMokMTuoTm4z/qwWbI/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774454316; c=relaxed/simple;
	bh=3xxfI6gRTrix+3bAjHjl+NqvLIsP+3Ljt4acojJrtbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UXkurVSZsy/o9Z9tSPnzrSAAjCoveZHpl57DcBhGxHkZ7MQh3O+uwHTe9sPDY1hwYQ+jVlsCr/EB9rQbjCAtGjP5zjzvT2VGwdIcvA7HQmCR/uILU4XzvYicVPJ8lF6QUQHTgtRdAh18q9hSr/4DMYsofmCNqwOT+Td8/d1gj/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=RHklxLfi; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="RHklxLfi"
Received: from [IPV6:2601:646:8081:9481:619:3ffd:957c:6748] ([IPv6:2601:646:8081:9481:619:3ffd:957c:6748])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 62PFE0CM3057644
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 25 Mar 2026 08:14:01 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 62PFE0CM3057644
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1774451646;
	bh=m+c64TX9TAStG5n4QBbOwBHxDLYCJ+PjBNcVbNtGMx8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RHklxLfiOlJf6ydmRmJruDGnJeWMZSbz2TgxABeLCgguQaUbYsc9vR9kpgjAtaRk6
	 D7BSdsEd+lvAoCQg+RbZcvgtOjl5ikAs97OdfN6AYdowAx+SkUCmf/8a7rxvIX1199
	 n1C53Bc4syiY0JVf3wcgOdQFaGlli8ZPulCYU+tqXHoikLbqaKaukH46nBwaABbmkR
	 FqzyBozoAq6ydYU475wWtUu9yg9VB2ezfO6KFROa2nbUotE425BtfRIaR4mJKhTxf8
	 dVWONsYwf/QQWCyfrPeHYwfZmG0pn9A7Kw7p2V6FDiyY1iJynsS0qMGEvvGfkQIYvu
	 dNPPZv5PxcbxQ==
Message-ID: <59d1d178-c141-4229-81e9-a6c23fa81f2f@zytor.com>
Date: Wed, 25 Mar 2026 08:13:55 -0700
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/17] raid6: remove __KERNEL__ ifdefs
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
References: <20260324064115.3217136-1-hch@lst.de>
 <20260324064115.3217136-3-hch@lst.de>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20260324064115.3217136-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026-03-23 23:40, Christoph Hellwig wrote:
> With the test code ported to kernel space, none of this is required.

I really *really* don't like this.

The ability of running in user space is really useful when it comes to
developing new code for new platforms, which happens often enough for this code.

	-hpa

