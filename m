Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34598 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbbIXQia (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 12:38:30 -0400
Received: by wicfx3 with SMTP id fx3so36391292wic.1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 09:38:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55FC0D3B.9070805@gmail.com>
References: <20150916144355.GA1285@invalid>
	<55F988A6.8070109@gmail.com>
	<CABL_Pd8nOj7B1_64Us+goP=corZkCtw_WJW8eMQpiP6iQpw=HA@mail.gmail.com>
	<55F9C136.3080800@gmail.com>
	<CAHb+SPDaU-FBD2b2UN+ecubZcmzX=7KKk_7PgstCpUgmVb=YuQ@mail.gmail.com>
	<55FC0D3B.9070805@gmail.com>
Date: Thu, 24 Sep 2015 17:38:28 +0100
Message-ID: <CAHb+SPCRWt7yOrOyaMhJK6JbKnT7y67Cqx5RG3c1mo5nWPBGYg@mail.gmail.com>
Subject: Re: FYIO: A rant about btrfs
From: Aneurin Price <aneurin.price@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Martin Tippmann <martin.tippmann@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18 September 2015 at 14:10, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
> On 2015-09-17 10:52, Aneurin Price wrote:
>>
>> On 16 September 2015 at 20:21, Austin S Hemmelgarn <ahferroin7@gmail.com>
>> wrote:
>>>
>>> ZFS has been around for much longer, it's been mature and feature
>>> complete for more than a decade, and has had a long time to improve
>>> performance wise.  It is important to note though, that on low-end hardware,
>>> BTRFS can (and often does in my experience) perform better than ZFS, because
>>> ZFS is a serious resource hog (I have yet to see a stable ZFS deployment
>>> with less than 16G of RAM, even with all the fancy features turned off).
>>
>>
>> If you have a real example of ZFS becoming unstable with, say, 4 or
>> 8GB of memory, that doesn't involve attempting deduplication (which I
>> guess is what you mean by 'all the fancy features') on a many-TB pool,
>> I'd be interested to hear about it. (Psychic debugger says 'possibly
>> somebody trying to use a large L2ARC on a pool with many/large zvols')
>>
>> My home fileserver has been running zfs for about 5 years, on a system
>> maxed out at 4GB RAM. Currently up to ~9TB of data. The only stability
>> problems I ever had were towards the beginning when I was using
>> zfs-fuse because zfsonlinux wasn't ready then, *and* I was trying out
>> deduplication.
>>
>> I have a couple of work machines with 2GB RAM and pools currently
>> around 2.5TB full; no problems with these either in the couple of
>> years they've been in use, though granted these are lightly loaded
>> machines since what they mostly do is receive backup streams.
>>
>> Bear in mind that these are Linux machines, and zfsonlinux's memory
>> management is known to be inferior to ZFS on Solaris and FreeBSD
>> (because it does not integrate with the page cache and instead grabs a
>> [configurable] chunk of memory, and doesn't always do a great job of
>> dropping it in response to memory pressure).
>>
> I should qualify this further, in particular I meant using ZFS on Linux (not
> *BSD, they did an amazing job WRT stability), and actually taking advantage
> of the volume-management (ie, not just storing files on it, but also using
> zvols).  In essence, A better way to put it is that I've never seen a truly
> stable system using zfsonlinux with less than 16G or RAM which is using it
> for volume-management as well as file storage.
>

That's interesting, and I think it supports the 'large L2ARC on a pool
with many/large zvols' theory.

Apologies that this is now so off-topic, but I really wish this were
more widely known:

I've seen major problems using an L2ARC with zvols, and from reading
various reports I get the impression that a lot of other people have
too, though they may not always have diagnosed it.

It's easy to get the general impression that an L2ARC is a great thing
to have, that has the potential to improve your read throughput with
minimal downside, but in fact the downside can be pretty large - and
it is much larger by default with volumes than filesystems. Whenever a
chunk of data is stored in the L2ARC, a header for that data is stored
in the ARC, where it must remain in memory (not sure if it's pinned to
stop it being swapped out; I think it is, but if you're at the point
where that makes a difference you're probably already having a bad
day). For a filesystem, the header corresponds to a record which is,
by default, a variable size up to 128k; for a volume, the header
corresponds to a block which is, by default, 8k. Assuming that your
records are mostly close to their maximum size, this means that the
RAM overhead of having a given amount of data in L2ARC is *16x* higher
for a volume than a filesystem.

Unfortunately, if you're using volumes it's probably because you're
running VMs or a dedicated storage server, and in those circumstances
we naturally think "yes, some caching sounds like a great idea", and
then proceed to wildly underestimate the amount of memory required.
Consequently, as the L2ARC fills, ZFS fills its memory allowance with
data that is basically pure overhead - often blowing past its
configured limit without getting much mileage out of it, and becoming
barely responsive. The effect is that the system seems fine when it
first starts, and becomes slower and slower over time until it's
unusable. Practically speaking, there's not too much difference
between a storage server that spends three minutes thrashing in
response to each read and one that's locked up hard.

Basically having an L2ARC of non-trivial size without a lot of RAM to
back it up is a bad idea, so I think there's a good chance that the
problems you've observed/heard about may well be due to inappropriate
L2ARC usage without fully appreciating the memory requirements.

Nye
