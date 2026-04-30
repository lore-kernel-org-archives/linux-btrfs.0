Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD6C33A70E;
	Thu, 30 Apr 2026 03:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777519544; cv=none; b=OzeGNLfqR2Wyw0s0vlX8nqiEgg8NHeRkdAqbBGRXhZrvZ0IQOJcE/uPbQX5lwwmlIRva10hGuTF6OP1CzGDELcN4ALXUbsU9xKqxu/7BIr3gL09lO5Sc8Z4/iCd8AcHvkd8u4cs+ESsrQkKymRag3gv89yhOWnEU/kBcsfrMl3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777519544; c=relaxed/simple;
	bh=wBz7OM7TlHLm2WIVihmJBmiohjoSXyxgTPPi2XUGXGY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=pv5PBTPYzaa9+eYPjyqxzPwEdlz4tO71YYGwHouilj5OJVsF1b4Ou7XoAYor1LlMcUFFgzSpBX13kLPL71kFV6zeRKyz0HD0KYgeAetSufzLVmgDFV54KAOT+n/GPA70DpQES/jQDlKZ7vSeB8fNsQlXNqXNbcDxckpwpL0NYl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTpJPZRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTpJPZRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD70C2BCB9;
	Thu, 30 Apr 2026 03:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519544;
	bh=wBz7OM7TlHLm2WIVihmJBmiohjoSXyxgTPPi2XUGXGY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=uTpJPZRCgWp5AfDjLmVTacGdTqRQtgMVXovLDOgY5LJHM1kRJTcTAjAjlzCgBpZvp
	 PVuwPlNReHlcJ1FQ9PgNdCrqANSuP5dIHOg1WFVE1UPqOFQrLsNyEaAv1TIimY3yJ6
	 dNLJ1aTEBqXG6wIIAe+hTTilZEZmiRBioNt3vpRgGA7/f1YWR+zd1uAs2cIdkGAHSF
	 MZVBM6p+H1jvCofKth5JZ3lRO/w2r49uSYovI3hCogvHxcTwqsMRM3nY6Ct3vVu9oR
	 CmYp2PZ4xwBzwNein821COzMLGD6YCZFeFgtsAQGoLKs2+1jduSB39tglFke+SexZz
	 n/9KGgA7orfhA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D0473809A07;
	Thu, 30 Apr 2026 03:25:00 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/28] xor: assert that xor_blocks is not call from
 interrupt
 context
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751949930.2274119.9590297379331785751.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:24:59 +0000
References: <20260327061704.3707577-2-hch@lst.de>
In-Reply-To: <20260327061704.3707577-2-hch@lst.de>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com,
 linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org,
 ardb@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 chleroy@kernel.org, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, richard@nod.at,
 anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, herbert@gondor.apana.org.au, dan.j.williams@intel.com,
 clm@fb.com, dsterba@suse.com, arnd@arndb.de, song@kernel.org,
 yukuai@fnnas.com, linan122@huawei.com, tytso@mit.edu, Jason@zx2c4.com,
 linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-raid@vger.kernel.org

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Mar 2026 07:16:33 +0100 you wrote:
> Most of the optimized xor_blocks versions require FPU/vector registers,
> which generally are not supported in interrupt context.
> 
> Both callers already are in user context, so enforce this at the highest
> level.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> [...]

Here is the summary with links:
  - [01/28] xor: assert that xor_blocks is not call from interrupt context
    https://git.kernel.org/riscv/c/d8593b8f9354
  - [02/28] arm/xor: remove in_interrupt() handling
    https://git.kernel.org/riscv/c/b7ca705758b9
  - [03/28] arm64/xor: fix conflicting attributes for xor_block_template
    https://git.kernel.org/riscv/c/675a0dd596e7
  - [04/28] um/xor: cleanup xor.h
    https://git.kernel.org/riscv/c/3ea16a98518a
  - [05/28] xor: move to lib/raid/
    https://git.kernel.org/riscv/c/9e229025e247
  - [06/28] xor: small cleanups
    https://git.kernel.org/riscv/c/7c6e6b2b48e8
  - [07/28] xor: cleanup registration and probing
    https://git.kernel.org/riscv/c/0471415f3fd6
  - [08/28] xor: split xor.h
    https://git.kernel.org/riscv/c/54e20be48fd4
  - [09/28] xor: remove macro abuse for XOR implementation registrations
    https://git.kernel.org/riscv/c/35ebc4de1059
  - [10/28] xor: move generic implementations out of asm-generic/xor.h
    https://git.kernel.org/riscv/c/c46928fdcfa0
  - [11/28] alpha: move the XOR code to lib/raid/
    https://git.kernel.org/riscv/c/503793b1340e
  - [12/28] arm: move the XOR code to lib/raid/
    https://git.kernel.org/riscv/c/0d64a24ec0c0
  - [13/28] arm64: move the XOR code to lib/raid/
    https://git.kernel.org/riscv/c/3786f2ad0095
  - [14/28] loongarch: move the XOR code to lib/raid/
    https://git.kernel.org/riscv/c/033bee3e4963
  - [15/28] powerpc: move the XOR code to lib/raid/
    https://git.kernel.org/riscv/c/3f276cece4dd
  - [16/28] riscv: move the XOR code to lib/raid/
    https://git.kernel.org/riscv/c/5265d55b2146
  - [17/28] sparc: move the XOR code to lib/raid/
    https://git.kernel.org/riscv/c/7f96362396ee
  - [18/28] s390: move the XOR code to lib/raid/
    https://git.kernel.org/riscv/c/95c104cc5571
  - [19/28] x86: move the XOR code to lib/raid/
    https://git.kernel.org/riscv/c/77fd47e57a09
  - [20/28] xor: avoid indirect calls for arm64-optimized ops
    https://git.kernel.org/riscv/c/352ebd066b62
  - [21/28] xor: make xor.ko self-contained in lib/raid/
    https://git.kernel.org/riscv/c/e20043b4765c
  - [22/28] xor: add a better public API
    (no matching commit)
  - [23/28] xor: add a better public API
    (no matching commit)
  - [24/28] async_xor: use xor_gen
    https://git.kernel.org/riscv/c/7c12c32b9f73
  - [25/28] btrfs: use xor_gen
    https://git.kernel.org/riscv/c/0f629e7283ad
  - [26/28] xor: pass the entire operation to the low-level ops
    https://git.kernel.org/riscv/c/80dcf0a7832a
  - [27/28] xor: use static_call for xor_gen
    https://git.kernel.org/riscv/c/a21921dd02d3
  - [28/28] xor: add a kunit test case
    https://git.kernel.org/riscv/c/af53e85ef797

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


