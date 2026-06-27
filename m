Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A001862;
	Sat, 27 Jun 2026 01:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782524559; cv=none; b=MgZQoxrhdXS7a6EHjCiRCAfW81V8kj3XiDhd98zOyI725U6Ha5n7TiI2zLZZpIK5vl7mogeFqX4JXlf1CgvaeqtZh7wSwdUCn1Kh29fjiUtYjRkLHltO4MHyULIEuh0d/LEWUX4fyaESqMMNykcMbZt/icO4u5DtGGrrdYXvaBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782524559; c=relaxed/simple;
	bh=jC1FioIpIuBtK6CQyzkvitIy/jJmxmVOYdOtUFK0xSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DXsfUwLl5UlBTJYRA4MHxOpmtLwgUUnfiN0fhRYYMO4B7R/X+4GJjpHcPabqU6u9pfX/Q4JOBFwTpW5RhZs1/jhA0skE2uEPK0p95tSIshw7cL1Cm+eLMUsq8ZZXrKVyDBsXXQtfvnWnuvRErHBEkJiZ8giYzHXzHHDIAD8sEVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ieVY684F; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ieVY684F"
Received: from [IPV6:2601:646:8081:7da1:dcd4:e1f8:5d79:bdb4] ([IPv6:2601:646:8081:7da1:dcd4:e1f8:5d79:bdb4])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65R1EHQ12354017
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 26 Jun 2026 18:14:17 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65R1EHQ12354017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026052701; t=1782522861;
	bh=a3misQc9HlKUNeYqqO4Fnmvv4Fv9RkyhsTgdLQ0BWz0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ieVY684FxDj35+1OdJbAri1pdBhTN2gqeIU7j2Y370sBUQ30QPhmIZvW75cKJPbdR
	 IMWIkamCPLrfWfNgBKcB3PhaMkYzKHTrmnUKLa1e+ZLSJhv19+SOXDBLXcwGBwQUQm
	 r/XHx5z9usnk9iv+AszJJxJtR+3sMk9VLHHsh52YfG3DsQ64mFPl5qVJWfAy/D+2Rh
	 S+WMDllsVtD5pOEp++Uf505LlYCJ5QwZinre3Oi8+jbt4xxPtHa6lglEWhLpIlBWBv
	 8Y8Cvo1WqplQrMHkk6CviVuUOV0LSl6zFgnbsOyQby5POoRmSu/3wfwF+nNtjeJn02
	 kxE798jNrTxdQ==
Message-ID: <33ef4e7b-3139-4cb8-9545-6d445bf6e5f1@zytor.com>
Date: Fri, 26 Jun 2026 18:14:11 -0700
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/18] raid6: warn when using less than four devices
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
 <20260518051804.462141-9-hch@lst.de>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20260518051804.462141-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026-05-17 22:17, Christoph Hellwig wrote:
> Quoting H. Peter Anvin who came up with the RAID6 P/Q algorithm, and
> who wrote the initial implementation, then still part of the md driver:
> 
>   The RAID-6 code has *never* supported only 3 units, and if it ever
>   worked for *any* of the implementations it was purely by accident.
>   Speaking as the original author I should know; this was deliberate as
>   in some cases the degenerate case (3) would have required extra trays

Stupid autocorrect. That was of course supposed to be "tests" (as in extra
code paths) not "trays" :)

>   in the code to no user benefit.
> 
> While md never allowed less than 4 devices, btrfs does.  This new
> warning will trigger for such file systems, but given how it already
> causes havoc that is a good thing.  If btrfs wants to fix third, it
> should switch to transparently use three-way mirroring underneath,
> which will work as P and Q are copies of the single data device by
> the definition of the Linux RAID 6 P/Q algorithm.

For what it's worth, this is also true in the degenerate two-drive RAID-4|5
case (D = P).

	-hpa

