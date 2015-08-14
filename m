Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:33704 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbbHNSo5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 14:44:57 -0400
Received: by vkbg64 with SMTP id g64so20163620vkb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 11:44:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU8hWWVn0KxyKLPsmar2EzSKO_V5fYm5gDor=QycqzrfPQ@mail.gmail.com>
References: <CAK7bmU8hWWVn0KxyKLPsmar2EzSKO_V5fYm5gDor=QycqzrfPQ@mail.gmail.com>
Date: Fri, 14 Aug 2015 12:44:56 -0600
Message-ID: <CAJCQCtQBey_UvXLDBrDkKxbEmWLZw6N1NbGVJV3XCjwF+exBLg@mail.gmail.com>
Subject: Re: Can't mount degraded. How to remove/add drives OFFLINE?
From: Chris Murphy <lists@colorremedies.com>
To: Timothy Normand Miller <theosib@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 12:12 PM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> Sorry about that empty email.  I hit a wrong key, and gmail decided to send.
>
> Anyhow, my replacement drive is going to arrive this evening, and I
> need to know how to add it to my btrfs array.  Here's the situation:
>
> - I had a drive fail, so I removed it and mounted degraded.
> - I hooked up a replacement drive, did an "add" on that one, and did a
> "delete missing".
> - During the rebalance, the replacement drive failed, there were OOPSes, etc.
> - Now, although all of my data is there, I can't mount degraded,
> because btrfs is complaining that too many devices are missing (3 are
> there, but it sees 2 missing).

It might be related to this (long) bug:
https://bugzilla.kernel.org/show_bug.cgi?id=92641

While Btrfs RAID 1 can tolerate only a single device failure, what you
have is an in-progress rebuild of a missing device. If it becomes
missing, the volume should be no worse off than it was before. But
Btrfs doesn't see it this way, instead is sees this as two separate
missing devices and now too many devices missing and it refuses to
proceed. And there's no mechanism to remove missing devices unless you
can mount rw. So it's stuck.


> So I could use some help with cleaning up this mess.  All the data is
> there, so I need to know how to either force it to mount degraded, or
> add and remove devices offline.  Where do I begin?

You can try to ask on IRC. I have no ideas for this scenario, I've
tried and failed. My case was throw away, what should still be
possible is using btrfs restore.


> Also, doesn't it seem a bit arbitrary that there are "too many
> missing," when all of the data is there?  If I understand correctly,
> all four drives in my RAID1 should all have copies of the metadata,

No that's not correct. RAID 1 means 2 copies of metadata. In a 4
device RAID 1 that's still only 2 copies. It is not n-way RAID 1.

But that doesn't matter here, the problem is that Btrfs has a narrow
idea of the volume, it assumes without context that once the number of
devices is below the minimum, the volume can't be mounted. In reality,
an exception exists if the failure is for an in-progress rebuild of a
missing drive. That drive failing should mean the volume is no worse
off than before but Btrfs doesn't know that.

Pretty sure about that anyway.


> and of the remaining three good drives, there should be one or two
> copies of every data block.  So it's all there, but btrfs has decided,
> based on the NUMBER of missing devices, that it won't mount.
> Shouldn't it refuse to mount if it knows there is data missing?  For
> that matter, why should it even refuse in that case?  So some data
> might missing, so it should throw some errors if you try to access
> that missing data.  Right?

I think no data is missing, no metadata is missing, and Btrfs is
confused and stuck in this case.

-- 
Chris Murphy
