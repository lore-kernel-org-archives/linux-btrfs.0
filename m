Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36899 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbHNTDa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 15:03:30 -0400
Received: by igui7 with SMTP id i7so18330731igu.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 12:03:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQBey_UvXLDBrDkKxbEmWLZw6N1NbGVJV3XCjwF+exBLg@mail.gmail.com>
References: <CAK7bmU8hWWVn0KxyKLPsmar2EzSKO_V5fYm5gDor=QycqzrfPQ@mail.gmail.com>
	<CAJCQCtQBey_UvXLDBrDkKxbEmWLZw6N1NbGVJV3XCjwF+exBLg@mail.gmail.com>
Date: Fri, 14 Aug 2015 15:03:30 -0400
Message-ID: <CAK7bmU8i119-igp=cE_djV2RvOX4unpg1pcDkaeDh-AY=gn3qA@mail.gmail.com>
Subject: Re: Can't mount degraded. How to remove/add drives OFFLINE?
From: Timothy Normand Miller <theosib@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not sure my situation is quite like the one you linked, so here's
my bug report:

https://bugzilla.kernel.org/show_bug.cgi?id=102881

On Fri, Aug 14, 2015 at 2:44 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Fri, Aug 14, 2015 at 12:12 PM, Timothy Normand Miller
> <theosib@gmail.com> wrote:
>> Sorry about that empty email.  I hit a wrong key, and gmail decided to send.
>>
>> Anyhow, my replacement drive is going to arrive this evening, and I
>> need to know how to add it to my btrfs array.  Here's the situation:
>>
>> - I had a drive fail, so I removed it and mounted degraded.
>> - I hooked up a replacement drive, did an "add" on that one, and did a
>> "delete missing".
>> - During the rebalance, the replacement drive failed, there were OOPSes, etc.
>> - Now, although all of my data is there, I can't mount degraded,
>> because btrfs is complaining that too many devices are missing (3 are
>> there, but it sees 2 missing).
>
> It might be related to this (long) bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=92641
>
> While Btrfs RAID 1 can tolerate only a single device failure, what you
> have is an in-progress rebuild of a missing device. If it becomes
> missing, the volume should be no worse off than it was before. But
> Btrfs doesn't see it this way, instead is sees this as two separate
> missing devices and now too many devices missing and it refuses to
> proceed. And there's no mechanism to remove missing devices unless you
> can mount rw. So it's stuck.
>
>
>> So I could use some help with cleaning up this mess.  All the data is
>> there, so I need to know how to either force it to mount degraded, or
>> add and remove devices offline.  Where do I begin?
>
> You can try to ask on IRC. I have no ideas for this scenario, I've
> tried and failed. My case was throw away, what should still be
> possible is using btrfs restore.
>
>
>> Also, doesn't it seem a bit arbitrary that there are "too many
>> missing," when all of the data is there?  If I understand correctly,
>> all four drives in my RAID1 should all have copies of the metadata,
>
> No that's not correct. RAID 1 means 2 copies of metadata. In a 4
> device RAID 1 that's still only 2 copies. It is not n-way RAID 1.
>
> But that doesn't matter here, the problem is that Btrfs has a narrow
> idea of the volume, it assumes without context that once the number of
> devices is below the minimum, the volume can't be mounted. In reality,
> an exception exists if the failure is for an in-progress rebuild of a
> missing drive. That drive failing should mean the volume is no worse
> off than before but Btrfs doesn't know that.
>
> Pretty sure about that anyway.
>
>
>> and of the remaining three good drives, there should be one or two
>> copies of every data block.  So it's all there, but btrfs has decided,
>> based on the NUMBER of missing devices, that it won't mount.
>> Shouldn't it refuse to mount if it knows there is data missing?  For
>> that matter, why should it even refuse in that case?  So some data
>> might missing, so it should throw some errors if you try to access
>> that missing data.  Right?
>
> I think no data is missing, no metadata is missing, and Btrfs is
> confused and stuck in this case.
>
> --
> Chris Murphy



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
