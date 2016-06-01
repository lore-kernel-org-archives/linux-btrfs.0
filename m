Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp49.i.mail.ru ([94.100.177.109]:44600 "EHLO smtp49.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbcFAKpP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 06:45:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 01 Jun 2016 12:45:10 +0200
From: Dmitry Katsubo <dma_k@mail.ru>
To: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
Subject: Re: Hot data tracking / hybrid storage
In-Reply-To: <nifkcs$ovp$1@ger.gmane.org>
References: <nh9p2p$cns$1@ger.gmane.org>
 <pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
 <20160516010524.7e208f96@jupiter.sol.kaishome.de>
 <nhedk2$dpq$1@ger.gmane.org>
 <0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
 <20160517203335.5ff99a05@jupiter.sol.kaishome.de>
 <nhir96$8n4$1@ger.gmane.org>
 <20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
 <e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
 <CAPmG0jYi+gCO3Ps4Xi1ahE4qoqMt6ZmLMrxT_URDHdaA_cZCLg@mail.gmail.com>
 <1c1358af-4549-618a-c408-b93832d33225@gmail.com>
 <nhnfu8$igq$1@ger.gmane.org>
 <9bde1aa8-fac5-34c4-dffc-0bf15d86c008@gmail.com>
 <574A8AFF.7020606@gmail.com>
 <CAJCQCtRnLekmARtLNySDofJah12CpKO0VpKygwf7NfQJzS8URg@mail.gmail.com>
 <574B2EE6.6080402@applied-asynchrony.com>
 <CAJCQCtQpCkTP0uPc9TTLn0S+pQpLsAgBodKZvsYKm9vTuFv=Kg@mail.gmail.com>
 <nifkcs$ovp$1@ger.gmane.org>
Message-ID: <7478627d88e7578278a94ed20e8437ae@www.centurion.link>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-29 22:45, Ferry Toth wrote:
> Op Sun, 29 May 2016 12:33:06 -0600, schreef Chris Murphy:
> 
>> On Sun, May 29, 2016 at 12:03 PM, Holger Hoffstätte
>> <holger@applied-asynchrony.com> wrote:
>>> On 05/29/16 19:53, Chris Murphy wrote:
>>>> But I'm skeptical of bcache using a hidden area historically for the
>>>> bootloader, to put its device metadata. I didn't realize that was 
>>>> the
>>>> case. Imagine if LVM were to stuff metadata into the MBR gap, or
>>>> mdadm. Egads.
>>> 
>>> On the matter of bcache in general this seems noteworthy:
>>> 
>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=4d1034eb7c2f5e32d48ddc4dfce0f1a723d28667
>>> 
>>> bummer..
>> 
>> Well it doesn't mean no one will take it, just that no one has taken 
>> it
>> yet. But the future of SSD caching may only be with LVM.
>> 
> 
> I think all the above posts underline exacly my point:
> 
> Instead of using a ssd cache (be it bcache or dm-cache) it would be 
> much
> better to have the btrfs allocator be aware of ssd's in the pool and
> prioritize allocations to the ssd to maximize performance.
> 
> This will allow to easily add more ssd's or replace worn out ones,
> without the mentioned headaches. After all adding/replacing drives to a
> pool is one of btrfs's biggest advantages.

I would certainly vote for this feature. If I understand correctly, the
mirror is selected based on the PID of btrfs worker thread [1], which is
simple but not most effective. I would suggest implementing the queue of 
read
operations per physical device (perhaps reads/writes should be put into 
same
queue). If device is fast (and for SSD that is the case), the queue 
becomes
empty quicker which means it should be loaded more intensively. 
Allocation
logic should simply put the next request to the shortest queue. I think
this will guarantee that most operations are served by SSD (or any other
even faster technology that appears in the future).

[1] 
https://btrfs.wiki.kernel.org/index.php/Project_ideas#Better_data_balancing_over_multiple_devices_for_raid1.2F10_.28read.29


-- 
With best regards,
Dmitry
