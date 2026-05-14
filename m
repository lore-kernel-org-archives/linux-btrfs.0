Received: from libero.it (smtp-18.italiaonline.it [213.209.10.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3CF3B7B9D
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2026 19:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.209.10.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778788487; cv=none; b=oyGUDkVPjgrD3LrkKfSXswjx0S6pCFzg6zyjuqiDbOnBBk9edC3bB6bWCP4x0x9fvsPRJy5jlCwrCgMI4doN33uAEEwLWZKJgIQ8meLcfEa/BAAssDlqekOiLV+U4jG2eEFEHuOAdtjRuZxeal08xgALSYSlvtOAU9/MDJOYUMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778788487; c=relaxed/simple;
	bh=bxZEKtTP0qO2jIGzW7Kwa31tfboGR2aCepPMKsO9DGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pDdWIWzHt44l85xzSBWyQ+A3PPeRoEA2c8NdN/NYG4y9Gz7GRHFuDHlfrztCEk1Yo4UfNQi7ihXDguN7nGTkGDXAtSfm4KHdQTUx1UOALYBGi2n/vpWqNbs5nqfwhnwTOC1C2diG9BQYhoNTiYJ8sGDXtrtqLspSiCEUgCImIxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=libero.it; spf=pass smtp.mailfrom=libero.it; dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b=WjBd6m5G; arc=none smtp.client-ip=213.209.10.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=libero.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=libero.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="WjBd6m5G"
Received: from [192.168.1.27] ([84.220.171.3])
	by smtp-18.iol.local with ESMTPA
	id Nc6CwXG9svXD3Nc6CwmS65; Thu, 14 May 2026 21:52:07 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
	t=1778788327; bh=bD3QJ+lr63//8NcpvDCT9tKc3YLZWQgdbpAaQhjYRpQ=;
	h=From;
	b=WjBd6m5GeZLiEpJDmyyT/8VPp5EOXd4PhZx9kHUiOpqfvSBe7IFbl7krzNd92M9Ij
	 h6EhL6qXXq9UaNsQfdJ5a66jWHPe3D2L7Nu/xrybOS+yOAwV6LdAjAl7orTfUz4kwH
	 3auL6iqBbyl11V0qHQa1mg54QFrGy31tudePZPxfmDSHUVOc9cV7FN4yHppkUtjtZO
	 1eNNuq7/0Y74HmPuEqWqRhs3SrQQlZ7arXDilEcB+jEsAp8ofe+4bD0Y0I0ZeAg86U
	 3nuNpLvyVhMptjCg9r0R4NKBj3/xghtHqCInpSBZcxe6j2wOauOLHj8pRwkeniaUAa
	 v7xxVDpm6+b5w==
X-CNFS-Analysis: v=2.4 cv=KNpaDEFo c=1 sm=1 tr=0 ts=6a0627e7 cx=a_exe
 a=hciw9o01/L1eIHAASTHaSw==:117 a=hciw9o01/L1eIHAASTHaSw==:17
 a=IkcTkHD0fZMA:10 a=gdOXTq2rPY5K92qxl70A:9 a=QEXdDO2ut3YA:10
Message-ID: <0a8d1ff4-f5a2-49e9-aa45-d25dbe4ded40@libero.it>
Date: Thu, 14 May 2026 21:51:59 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 01/19] btrfs: require at least 4 devices for RAID 6
To: Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Dan Williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
 Li Nan <linan122@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-raid@vger.kernel.org
References: <20260512052230.2947683-1-hch@lst.de>
 <20260512052230.2947683-2-hch@lst.de> <20260512114231.GG2558453@suse.cz>
 <20260513054742.GA1018@lst.de>
Content-Language: en-US
From: Goffredo Baroncelli <kreijack@libero.it>
In-Reply-To: <20260513054742.GA1018@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfIDtr7UvibXhotDq/eGXiDloNUqbPDkdUcxlgBaAHHbQvsiYahHpeNORunqIajszasgr8c3B8z/XyVOyAuN5hf4175nD+vlvtMC0bIY9QJZp6woWJNrG
 aQk3PfyHHPYy0hAJeCmEsrwL+sXrn8raXvwSVFwja+mNIGcKFygU4bdVw8v1VKDOhOcKheYp3BbVwQqMojH7Fl3INb7gtuRV2KJmyAjSGXNJhncVaQGAWAXT
 oo9oBSC2F1t8jl/GotUy7wzpLHDbKBEqbAMmtYHdik+INpHro8RYa5E9Xq6OjONzHdXTvo9rbFmCDPwVpbwYHwCe0MqnMSDrNEtco2tbBGAHXZQltPV0OL6m
 Xs4XHyVNJychZ3wNHl+FP7VInrjAJxVyZarLA6h1GLmH6C7bo7xh7AiFVhmS448mJ7oddw2E4GcHCQLw5nc+mncOBuUBdW8FPmgVqBmLYRW/E1uHf5H7ymxf
 7+M72Ab7Lfz5l1ZroO9USEopaT2TBjueXvWWFJeuh+TSc+GQh5CVcLujqqlEOSlSp1R8OM48gPzAiNRzuVncRPYO912eFvGsZNofHbnJZ9P4JQlVvIPXrGUB
 k7Rksq1+0+/sGJ2glUPm+veTLd0hOFrGOX4ZELZW5Img1Rjh7oT/YM8G+lXjJbJOhlr6dtYSc1AC8AObXM80AsLIGbqAOpJVhPL0SZOZ5g6Eu3Cfm1/Q33as
 QHSlwOGbMr3uM6BXBwCA/iRSLcteO0RORQvEAQO/e8MiSvc/dUNZzTez6wHixpEXWQgZ9Z2NCRxukJhNoR1Rx4h+eGB19h2fhW2x2HiNZrbKd9S9OcLI88MY
 VUksbcbJ5ZMjktY8kGFSnH8Sl2ShB0yrH/NgA0RY1roEXSzCGqsE7TP3RQARPk+NJazqFOqfqBBqnZtd5+mQ4UNQ7vAQ8hGUUzJa0YumkRS4nD9X559FZfXe
 3QOgg2TlhwAwcQGvb+Ss+4k9h9DXM6VcEJLsA1QfBnYHYKfliz3h16SIG6W9Iv+uyDk540G1k9dytoNAOXtfwInzV/kvD8Gdkx/D5xTLs2Sy2Vsz+fiNYheM
 RnLdoR588cGVPiQvhFzHmun/E7dTIUBeFfbij8HjYQhlm3iRhm0aHJPBV9Vy9cCHzTY2Xgl9a5O9fV2pbB+fheegaejlj1NEvwMJXnqpW4b7V72sTbFeBBpq
 sV7UY0G4iFsh4psQSpK2n56bqWeEew5AkQ99Y/kUreS7WeUBfBiERWWaetQDZDCQNQA8U71Vc5hY0RLOFV2Aw7GFB7tuY8UWgz+lrNAODlW3lBkv98wvQAM2
 elm5SufYC+WToRDZbALHIfeKQaWetyvkUyIdnsY+d8sgX9LlFz8i7BQ2NdF+Kx5bVl5SHJ+7SVGlrENFPkZmuc9c76uB16GUvPNEKCGDocJxGmG4zCOAHF2C
 /C9IjdfcMCOt4BPR2AQ5I7a7UIHbl/0cLeCT3ndssV7yObVQj8fyrC9JvV103G4ONfKQAFRlbxqOghcPn/SVhhkuA7CbWDbiGwsvIIr4aWyBADP7w9O7YYob
 oxPW28FwtEbUoi7iCAVuNr75ZuhwG4v9wrI1nPiKemFdJA==

On 13/05/2026 07.47, Christoph Hellwig wrote:
> On Tue, May 12, 2026 at 01:42:31PM +0200, David Sterba wrote:

> 
>> The degenerate modes of
>> raid0, 5, or 6 are explicit as a possible middle step when converting
>> profiles.  We can use a fallback implementation for this case if the
>> accelerated implementations cannot do it.
> 
> This is not about a degenerated mode.  For a degenerated RAID 6, parity
> generation uses the RAID 5 XOR routines as the second parity will be
> missing.  This is about generating two parities for a single data disk,
> which must be explicitly selected.
> 

I think that the David concern is : "what happens for an already
existing btrfs raid6 3 disks filesystem when the user upgrade the kernel ?"
(I am thinking when a new BG needs to be allocated)...

BR
GB

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
