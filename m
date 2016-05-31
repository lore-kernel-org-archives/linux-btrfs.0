Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:38278 "EHLO
	mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbcEaMVx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 08:21:53 -0400
Received: by mail-it0-f42.google.com with SMTP id i127so25736702ita.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 May 2016 05:21:53 -0700 (PDT)
Subject: Re: Hot data tracking / hybrid storage
To: Ferry Toth <ftoth@exalondelft.nl>, linux-btrfs@vger.kernel.org
References: <nh9p2p$cns$1@ger.gmane.org>
 <pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
 <20160516010524.7e208f96@jupiter.sol.kaishome.de>
 <nhedk2$dpq$1@ger.gmane.org> <0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
 <20160517203335.5ff99a05@jupiter.sol.kaishome.de>
 <nhir96$8n4$1@ger.gmane.org>
 <20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
 <e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
 <CAPmG0jYi+gCO3Ps4Xi1ahE4qoqMt6ZmLMrxT_URDHdaA_cZCLg@mail.gmail.com>
 <1c1358af-4549-618a-c408-b93832d33225@gmail.com> <nhnfu8$igq$1@ger.gmane.org>
 <9bde1aa8-fac5-34c4-dffc-0bf15d86c008@gmail.com> <574A8AFF.7020606@gmail.com>
 <CAJCQCtRnLekmARtLNySDofJah12CpKO0VpKygwf7NfQJzS8URg@mail.gmail.com>
 <574B2EE6.6080402@applied-asynchrony.com>
 <CAJCQCtQpCkTP0uPc9TTLn0S+pQpLsAgBodKZvsYKm9vTuFv=Kg@mail.gmail.com>
 <nifkcs$ovp$1@ger.gmane.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9340ef1a-6746-1c3c-88f9-56fa2a0b7f0e@gmail.com>
Date: Tue, 31 May 2016 08:21:48 -0400
MIME-Version: 1.0
In-Reply-To: <nifkcs$ovp$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-29 16:45, Ferry Toth wrote:
> Op Sun, 29 May 2016 12:33:06 -0600, schreef Chris Murphy:
>
>> On Sun, May 29, 2016 at 12:03 PM, Holger Hoffstätte
>> <holger@applied-asynchrony.com> wrote:
>>> On 05/29/16 19:53, Chris Murphy wrote:
>>>> But I'm skeptical of bcache using a hidden area historically for the
>>>> bootloader, to put its device metadata. I didn't realize that was the
>>>> case. Imagine if LVM were to stuff metadata into the MBR gap, or
>>>> mdadm. Egads.
>>>
>>> On the matter of bcache in general this seems noteworthy:
>>>
>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/
> commit/?id=4d1034eb7c2f5e32d48ddc4dfce0f1a723d28667
>>>
>>> bummer..
>>
>> Well it doesn't mean no one will take it, just that no one has taken it
>> yet. But the future of SSD caching may only be with LVM.
>>
>> --
>> Chris Murphy
>
> I think all the above posts underline exacly my point:
>
> Instead of using a ssd cache (be it bcache or dm-cache) it would be much
> better to have the btrfs allocator be aware of ssd's in the pool and
> prioritize allocations to the ssd to maximize performance.
>
> This will allow to easily add more ssd's or replace worn out ones,
> without the mentioned headaches. After all adding/replacing drives to a
> pool is one of btrfs's biggest advantages.
It would still need to be pretty configurable, and even then would still 
be a niche use case.  It would also need automatic migration to be 
practical beyond a certain point, most people using regular computers 
outside of corporate environments don't have that same 'access frequency 
decreases over time' pattern that the manual migration scheme you 
suggested would be good for.

I think overall the most useful way of doing it would be something like 
the L2ARC on ZFS, which is essentially swap space for the page-cache, 
put on an SSD.

