Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:44433 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756342AbdGLDiO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 23:38:14 -0400
Date: Wed, 12 Jul 2017 05:38:06 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nick Terrell <terrelln@fb.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Message-ID: <20170712033806.xlkzyo56gmtrr6f5@angband.pl>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
 <20170706163225.xbluc2gi2nlaafzo@angband.pl>
 <A077809C-5D3A-4F3C-B859-E6C371A6EA4F@fb.com>
 <20170707234018.syyfaktjxyxvwglc@angband.pl>
 <20170708030706.tle2mpfe376jneft@angband.pl>
 <046c7611-be6d-ec4d-6489-e8f49a4453f6@gmail.com>
 <15FC42E2-5823-4AF4-A945-0F7C60E7751C@fb.com>
 <816FA2EC-C072-41D3-A14D-9891BBFEB7DB@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <816FA2EC-C072-41D3-A14D-9891BBFEB7DB@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 06:01:38AM +0000, Nick Terrell wrote:
> On 7/10/17, 9:57 PM, "Nick Terrell" <terrelln@fb.com> wrote:
> > The problem is caused by a gcc-7 bug [1]. It miscompiles
> > ZSTD_wildcopy(void *dst, void const *src, ptrdiff_t len) when len is 0.
>
> Sorry, my patch still triggered the gcc bug, I used the wrong compiler.
> This patch works, and runs about the same speed as before the patch for
> small inputs, and slightly faster for larger inputs (100+ bytes). I'll
> look for a faster workaround if benchmarks show it matters.

Confirmed, the fix stops the crash for me.  Yay!

> --- a/lib/zstd/zstd_internal.h
> +++ b/lib/zstd/zstd_internal.h
> @@ -139,12 +139,8 @@ static void ZSTD_copy8(void *dst, const void *src) { memcpy(dst, src, 8); }
>  #define WILDCOPY_OVERLENGTH 8
>  ZSTD_STATIC void ZSTD_wildcopy(void *dst, const void *src, ptrdiff_t length)
>  {
> -	const BYTE *ip = (const BYTE *)src;
> -	BYTE *op = (BYTE *)dst;
> -	BYTE *const oend = op + length;
> -	do
> -		COPY8(op, ip)
> -	while (op < oend);
> +	if (length > 0)
> +		memcpy(dst, src, length);
>  }
>  
>  ZSTD_STATIC void ZSTD_wildcopy_e(void *dst, const void *src, void *dstEnd) /* should be faster for decoding, but strangely, not verified on all platform */

-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
