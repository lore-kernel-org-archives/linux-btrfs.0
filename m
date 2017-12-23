Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:41482 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757161AbdLWEIT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 23:08:19 -0500
Date: Sat, 23 Dec 2017 05:08:16 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171223040815.GA31330@polanet.pl>
References: <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl>
 <CAJCQCtT+DjUDf3NBEQNxYm6SRhDL_FFXpz===fgub_k+AMmABg@mail.gmail.com>
 <20171219211757.GC14726@polanet.pl>
 <CAJCQCtSqw=-_6PBzaTiVhA=yoN4Fm=uwwjtqKgncK4B6R-zfJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <CAJCQCtSqw=-_6PBzaTiVhA=yoN4Fm=uwwjtqKgncK4B6R-zfJw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 17:08:28 -0700, Chris Murphy wrote:

>>>> Now, if the current kernels won't toggle degraded RAID1 as ro, can I
>>>> safely add "degraded" to the mount options? My primary concern is the
>> [...]
> 
> Well it only does rw once, then the next degraded is ro - there are
> patches dealing with this better but I don't know the state. And
> there's no resync code that I'm aware of, absolutely it's not good
> enough to just kick off a full scrub - that has huge performance
> implications and I'd consider it a regression compared to
> functionality in LVM and mdadm RAID by default with the write intent
> bitmap.  Without some equivalent short cut, automatic degraded means a

I read about the 'scrub' all over the time here, so let me ask this
directly, as this is also not documented clearly:

1. is the full scrub required after ANY desync? (like: degraded mount
followed by readding old device)?

2. if the scrub is omitted - is it possible that btrfs return invalid data (from the
desynced and readded drive)?

3. is the scrub required to be scheduled on regular basis? By 'required'
I mean by design/implementation issues/quirks, _not_ related to possible
hardware malfunctions.

-- 
Tomasz Pala <gotar@pld-linux.org>
