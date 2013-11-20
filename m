Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:39576 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab3KTS7o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 13:59:44 -0500
Message-ID: <528D0694.3060703@zytor.com>
Date: Wed, 20 Nov 2013 10:59:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Andrea Mazzoleni <amadvance@gmail.com>
CC: David Brown <david.brown@hesbynett.no>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<528B3A6F.2010304@hesbynett.no>	<CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>	<528C8F8E.9030908@hesbynett.no>	<CAGKKSfV+TyONu0EgSy9r5k7SiP5ZM3n7pGajY62DBSBw6YvR+w@mail.gmail.com>	<1fe6f763-a5a4-4cc7-b23d-7928b0925f09@email.android.com> <CAGKKSfV-jie=6X+DuJJB6L7AdW4f83bQofYHBHwuuZvV+6mUxg@mail.gmail.com>
In-Reply-To: <CAGKKSfV-jie=6X+DuJJB6L7AdW4f83bQofYHBHwuuZvV+6mUxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/20/2013 10:56 AM, Andrea Mazzoleni wrote:
> Hi,
> 
> Yep. At present to multiply for 2^-1 I'm using in C:
> 
> static inline uint64_t d2_64(uint64_t v)
> {
>         uint64_t mask = v & 0x0101010101010101U;
>         mask = (mask << 8) - mask;
>         v = (v >> 1) & 0x7f7f7f7f7f7f7f7fU;
>         v ^= mask & 0x8e8e8e8e8e8e8e8eU;
>         return v;
> }
> 
> and for SSE2:
> 
> asm volatile("movdqa %xmm2,%xmm4");
> asm volatile("pxor %xmm5,%xmm5");
> asm volatile("psllw $7,%xmm4");
> asm volatile("psrlw $1,%xmm2");
> asm volatile("pcmpgtb %xmm4,%xmm5");
> asm volatile("pand %xmm6,%xmm2"); with xmm6 == 7f7f7f7f7f7f...
> asm volatile("pand %xmm3,%xmm5"); with xmm3 == 8e8e8e8e8e...
> asm volatile("pxor %xmm5,%xmm2");
> 
> where xmm2 is the intput/output
> 

Now, that doesn't sound like something that can get neatly meshed into
the Cauchy matrix scheme, I assume.  It is somewhat nice to have a
scheme which is arbitrarily expandable without having to fall back to
dual parity during the restripe operation.  It probably also reduces the
amount of code necessary.

	-hpa


