Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754357AbdJIPpS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Oct 2017 11:45:18 -0400
Date: Mon, 9 Oct 2017 17:43:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/1] Btrfs: heuristic add shannon entropy calculation
Message-ID: <20171009154333.GE3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171005100726.16438-1-nefelim4ag@gmail.com>
 <20171005100726.16438-2-nefelim4ag@gmail.com>
 <20171006182451.GB3521@twin.jikos.cz>
 <CAGqmi76Jf4mXpGYkW-_3jW7hLOrUef3VwCZMggPWePmwnGJPDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi76Jf4mXpGYkW-_3jW7hLOrUef3VwCZMggPWePmwnGJPDA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 07, 2017 at 03:08:26AM +0300, Timofey Titovets wrote:
> > I hear the compiler scream, trying to optimize all the ifs. And I think
> > the CPU branch prediction would have a hard time, there's practically no
> > expected pattern and the performance could be worse compared to the
> > formula calculation.
> >
> > What's the reason you opencode it like that? Could you please post how
> > it would be implemented in C? There are potentially optimized functions
> > to do integer log2 (ilog2).
> 
> That is just:
> log2_lshift4(n) { return ilog2(pow(n, 16)); }
> But that will cause a overflow.
> 
> log2(8192) -> 13 - 13 bit long
> 13 * 4 = 52, 52 < 64
> 
> That also restrict sample size to 15 bit
> 
> So we can get approximately same behaviour,
> by doing like ilog2(pow(n, 4));
> 
> https://pastebin.com/VryvqkCy - some numbers
> TL;DR version:
> pow(n, 4)
>  - count        100          7    28300
>  - error %    0.0%     1.1%    3.0%
> pow(n, 16)
>  - count     18843    11483    14
>  - error %     0.0%     1.0%    2.8%
> 
> (I sample Win10.iso image as just big file with different data).
> I gen error value by:
> if (shannon_e_f > 0)
>     error = 100 - (shannon_e_i * 1.0 * 100 / shannon_e_f);
> 
> In fact that cause errors in entropy level like:
> TRUE -> Integer
> 83 -> 80
> 87 -> 84
> 32 -> 28
> 
> In theory that possible to just make entropy level markers more aggressive,
> like: 70->65 and 85 -> 80
> 
> That will cover precision errors.

With the v2 patch and direct calculation, I'm ok with leaving some
imprecision there. This is fine-tuning that can be done in parallel.

> or make a byte level BigInt in kernel (bigint_log2, bigint_Lshift & etc) %)
> (But this seems inexcusable to me + i'm unsure about performance + I'm
> afraid Big/Little.Endian)

I think we need to keep it fast and not anything too complex to
calculate, unless there's a significant win in the heuristic results.

> > Code like that could be microbenchmarked so we can see actual numbers,
> > so far I'm just guessing.
> 
> I'm mentioned in a cover letter https://github.com/Nefelim4ag/companalyze
> (implement the heuristic with no optimizations, all code run, to get
> RAW counters)
> Over in memory bad compressible data:
>  8188. BSize: 131072, RepPattern: 0, BSet: 256, BCSet: 220, ShanEi%:
> 99| 99 ~0.0%, RndDist:     0, out: -3
> 
> With -O0 - ~1100 MiB/s
> With -O2 - ~2500 MiB/s
> 
> With (i found in kernel and add pow(n, 4))
> static int ilog2(uint64_t v)
> {
>     int l = 0;
>     v = v*v*v*v;
>     while ((1UL << l) < v)
>         l++;

The while() implementation is generic and works on all architectures,
but x86_64 has an instruction for that and will be even faster:

ilog2 ->

http://elixir.free-electrons.com/linux/latest/source/include/linux/log2.h#L26

fls (find lowest set bit) ->

http://elixir.free-electrons.com/linux/latest/source/arch/x86/include/asm/bitops.h#L450

bsrl

>     return l;
> }
> 
> With -O0 - ~1150 MiB/s
> With -O2 - ~2500 MiB/s
> 
> So, my solutions looks more bad at code, than performance
> (i may be that because most requests for bad compressible data got
> directly to lookup table)

Ok, thanks for collecting the numbers.
