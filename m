Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:64024 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab3KTS4n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 13:56:43 -0500
MIME-Version: 1.0
In-Reply-To: <1fe6f763-a5a4-4cc7-b23d-7928b0925f09@email.android.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<528B3A6F.2010304@hesbynett.no>
	<CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>
	<528C8F8E.9030908@hesbynett.no>
	<CAGKKSfV+TyONu0EgSy9r5k7SiP5ZM3n7pGajY62DBSBw6YvR+w@mail.gmail.com>
	<1fe6f763-a5a4-4cc7-b23d-7928b0925f09@email.android.com>
Date: Wed, 20 Nov 2013 19:56:42 +0100
Message-ID: <CAGKKSfV-jie=6X+DuJJB6L7AdW4f83bQofYHBHwuuZvV+6mUxg@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Brown <david.brown@hesbynett.no>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Yep. At present to multiply for 2^-1 I'm using in C:

static inline uint64_t d2_64(uint64_t v)
{
        uint64_t mask = v & 0x0101010101010101U;
        mask = (mask << 8) - mask;
        v = (v >> 1) & 0x7f7f7f7f7f7f7f7fU;
        v ^= mask & 0x8e8e8e8e8e8e8e8eU;
        return v;
}

and for SSE2:

asm volatile("movdqa %xmm2,%xmm4");
asm volatile("pxor %xmm5,%xmm5");
asm volatile("psllw $7,%xmm4");
asm volatile("psrlw $1,%xmm2");
asm volatile("pcmpgtb %xmm4,%xmm5");
asm volatile("pand %xmm6,%xmm2"); with xmm6 == 7f7f7f7f7f7f...
asm volatile("pand %xmm3,%xmm5"); with xmm3 == 8e8e8e8e8e...
asm volatile("pxor %xmm5,%xmm2");

where xmm2 is the intput/output

Ciao,
Andrea

On Wed, Nov 20, 2013 at 7:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> It is also possible to quickly multiply by 2^-1 which makes for an interesting R parity.
>
> Andrea Mazzoleni <amadvance@gmail.com> wrote:
>>Hi David,
>>
>>>> The choice of ZFS to use powers of 4 was likely not optimal,
>>>> because to multiply by 4, it has to do two multiplications by 2.
>>> I can agree with that.  I didn't copy ZFS's choice here
>>David, it was not my intention to suggest that you copied from ZFS.
>>Sorry to have expressed myself badly. I just mentioned ZFS because it's
>>an implementation that I know uses powers of 4 to generate triple
>>parity, and I saw in the code that it's implemented with two
>>multiplication
>>by 2.
>>
>>Ciao,
>>Andrea
>
> --
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.
