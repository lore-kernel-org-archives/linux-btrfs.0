From: Erik Logtenberg <erik@logtenberg.eu>
Subject: Re: Kernel error during btrfs balance
Date: Tue, 18 Jan 2011 15:29:04 +0100
Message-ID: <4D35A3B0.3000401@logtenberg.eu>
References: <4D344EBB.6030903@logtenberg.eu>	<AANLkTikhU0N+zTWmZ-og43fDGEsaxsAV7fAeAqutyF_t@mail.gmail.com>	<4D35942B.2020601@logtenberg.eu> <AANLkTimFK+rj3U0fpviNR0iQVkWcmyqE4g9ooYEqQDPB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimFK+rj3U0fpviNR0iQVkWcmyqE4g9ooYEqQDPB@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/18/2011 03:13 PM, Yan, Zheng wrote:
> On Tue, Jan 18, 2011 at 9:22 PM, Erik Logtenberg <erik@logtenberg.eu> wrote:
>> On 01/18/2011 01:54 AM, Yan, Zheng wrote:
>>> On Mon, Jan 17, 2011 at 10:14 PM, Erik Logtenberg <erik@logtenberg.eu> wrote:
>>>> Hi,
>>>>
>>>> btrfs balance results in:
>>>>
>>>> http://pastebin.com/v5j0809M
>>>>
>>>> My system: fully up-to-date Fedora 14 with rawhide kernel to make btrfs
>>>> balance do useful stuff to my free space:
>>>>
>>>> kernel-2.6.37-2.fc15.x86_64
>>>> btrfs-progs-0.19-12.fc14.x86_64
>>>>
>>>> Filesystem had 0 bytes free, should be 45G, so on darklings advice I ran
>>>> btrfs balance on the fs, while doing heavy I/O (re-running 5 backup jobs
>>>> that had failed due to ENOSP).
>>>> Up until the crash, btrfs balance did retrieve a couple of Gigs free
>>>> space though, so that part of the plan worked just fine.
>>>>
>>>
>>> Please try 2.6.36 kernel.
>>
>> Thanks for your (short) advice. Could you please elaborate. I was in
>> fact using a 2.6.35.10-74.fc14.x86_64 kernel before, but darkling
>> adviced me to switch to a newer kernel to reclaim free space by
>> balancing -- the idea was that newer kernels have better balancing
>> implementation, more effective at reclaiming free space.
>>
>> Now your advice is to take a small step back again, from 2.6.37 to
>> 2.6.36 (which is still higher than the 2.6.35 I was using before). Is
>> that because you think that 2.6.37 may have introduced the bug that I
>> ran into? Do you think that 2.6.36 is still recent enough to have the
>> effective balancing so that I will in fact be able to reclaim some free
>> space? Or is is just a shot in the dark with no reasoning whatsoever ;)
>>
>> Please don't feel offended, but from your 4-word sentence I really can't
>> tell.
>>
> 
> Just try narrowing down the bug, because I never saw bug like this before.

Okay I can try that. Please note though that I cannot reliably reproduce
the bug. At this moment I am in the middle of my second try at balancing
the FS (still on 2.6.37), this time without 8 rsync's banging on the FS.
So far, everything is completely stable.

I could downgrade to 2.6.36 after this balance and then re-try
balancing, but if this second go doesn't crash like the first try, then
a succesful rebalance on 2.6.36 won't tell us much.

Please note that it could be a combination of bugs. I ran into an
out-of-space issue in the middle of a backup first (at that time on
2.6.35), and also noticed some minor file corruption as a result.
Then I switched over to 2.6.37 to fix the out-of-space issue (as there
should have been 45G free) using a balance. During that balance
operation I then ran in to the bug that I reported in my previous email.

So it could be the 2.6.37 kernel hitting a minor FS corruption caused by
out-of-space issues with the 2.6.35 kernel. I have no idea how I could
reproduce this at all.

Thanks,

Erik.
