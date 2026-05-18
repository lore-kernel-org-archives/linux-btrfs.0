Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51053282F05;
	Mon, 18 May 2026 21:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138728; cv=none; b=RH+ym6syVUqKb9canrniJnkpFvmrlxzIkVnezP2LuMp1sv7R9Z46MYtpbNUu8r2xjEe9OyMTlLSXWA98emyvheOkAbtaSO47PWWuuewP7MYxylHbvTMjagvMc7NPHkoRJkLjYfyZV9Fox2bahCTgtCNLDwkB+PL7fvheSD1tpf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138728; c=relaxed/simple;
	bh=6CbWyBWe6ek+skQD7ezBR5R72rf11+dnwrag4D/122Q=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=CYxZz31JVhti8KfklkAKi+EFIrJO+7YO9/K0HS1cQV4v5nbPB+GvXSwLHtwvjvPnjliapXLDFwtRiqg4lREmZ6EaPlsGaJqBFf8MejHDl+QMPR6cZHASqtMAhjwlF8a0o7CnGRZk8mbpntgJSc9cJCReqnhBvXYoovzRCd8LoOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dmdzNWjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dmdzNWjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC18C2BCB7;
	Mon, 18 May 2026 21:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138727;
	bh=6CbWyBWe6ek+skQD7ezBR5R72rf11+dnwrag4D/122Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dmdzNWjTjK3Cc3C2V+DkRdbwT+d12xy/ZdRJ5bQRPDa4Caa5RS6kZ9MZ1ALFQP/+U
	 kc1KEx+sN56byuYGjJ5PbU1JGucdCZy76CwlbeuJ+r1GAPZ0VTw7F7ixRcBQbkK4OE
	 ese4fN8XpUeBQ1LjLfsivknyFMJ0f8eUvHc2/mMw=
Date: Mon, 18 May 2026 14:12:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Huacai Chen
 <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti
 <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>, Dan Williams
 <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>, David Sterba
 <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>, Song Liu
 <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
 <linan122@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-raid@vger.kernel.org
Subject: Re: cleanup the RAID6 P/Q library v3
Message-Id: <20260518141205.c100f76eec5f58e78bbbf7af@linux-foundation.org>
In-Reply-To: <20260518051804.462141-1-hch@lst.de>
References: <20260518051804.462141-1-hch@lst.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 May 2026 07:17:43 +0200 Christoph Hellwig <hch@lst.de> wrote:

> this series cleans up the RAID6 P/Q library to match the recent updates
> to the RAID 5 XOR library and other CRC/crypto libraries.  This includes
> providing properly documented external interfaces, hiding the internals,
> using static_call instead of indirect calls and turning the user space
> test suite into an in-kernel kunit test which is also extended to
> improve coverage.

Cool, I'll add this to mm.git's mm-nonmm-unstable branch for some
linux-next testing.

AI review found quite a lot to talk about:
	https://sashiko.dev/#/patchset/20260518051804.462141-1-hch@lst.de
