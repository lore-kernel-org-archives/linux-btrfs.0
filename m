Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:60770 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbdDGVZc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 17:25:32 -0400
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <572D0C8B.8010404@mendix.com>
 <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Josef Bacik <jbacik@fb.com>
Message-ID: <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
Date: Fri, 7 Apr 2017 23:25:29 +0200
MIME-Version: 1.0
In-Reply-To: <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, I'm going to revive a year old mail thread here with interesting new
info:

On 05/31/2016 03:36 AM, Qu Wenruo wrote:
> 
> 
> Hans van Kranenburg wrote on 2016/05/06 23:28 +0200:
>> Hi,
>>
>> I've got a mostly inactive btrfs filesystem inside a virtual machine
>> somewhere that shows interesting behaviour: while no interesting disk
>> activity is going on, btrfs keeps allocating new chunks, a GiB at a time.
>>
>> A picture, telling more than 1000 words:
>> https://syrinx.knorrie.org/~knorrie/btrfs/keep/btrfs_usage_ichiban.png
>> (when the amount of allocated/unused goes down, I did a btrfs balance)

That picture is still there, for the idea.

> Nice picture.
> Really better than 1000 words.
> 
> AFAIK, the problem may be caused by fragments.

Free space fragmentation is a key thing here indeed.

The major two things involved here are 1) the extent allocator, which
causes the free space fragmentation 2) the extent allocator, which
doesn't handle the fragmentation it just caused really well.

Let's start with the pictures, instead of too many words. The following
two videos are png images of the 4 block groups with highest vaddr.
Every 15 minutes a picture is created, and then they're added together:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-01-19-noautodefrag-ichiban.mp4

And, with autodefrag enabled, which was the first thing I tried as a change:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-01-13-autodefrag-ichiban.mp4

So, this is why putting your /var/log, /var/lib/mailman and /var/spool
on btrfs is a terrible idea.

Because the allocator keeps walking forward every file that is created
and then removed leaves a blank spot behind.

Autodefrag makes the situation only a little bit better, changing the
resulting pattern from a sky full of stars into a snowstorm. The result
of taking a few small writes and rewriting them again is that again the
small parts of free space are left behind.

Just a random idea.. for this write pattern, always putting new writes
in the first free available spot at the beginning of the block group
would make a total difference, since the little 4/8KiB parts would be
filled up again all the time, preventing the shotgun blast to spread all
over.

> And even I saw some early prototypes inside the codes to allow btrfs do
> allocation smaller extent than required.
> (E.g. caller needs 2M extent, but btrfs returns 2 1M extents)
> 
> But it's still prototype and seems no one is really working on it now.
> 
> So when btrfs is writing new data, for example, to write about 16M data,
> it will need to allocate a 16M continuous extent, and if it can't find
> large enough space to allocate, then create a new data chunk.
> 
> [...]

That's the cluster idea right? Combining free space fragments into a
bigger piece of space to fill with writes?

The fun thing is that this might work, but because of the pattern we end
up with, a large write apparently fails (the files downloaded when doing
apt-get update by daily cron) which causes a new chunk allocation. This
is clearly visible in the videos. Directly after that, the new chunk
gets filled with the same pattern, because the extent allocator now
continues there and next day same thing happens again etc...

And voila, there's the answer to my original question.

Now, another surprise:

>From the exact moment I did mount -o remount,nossd on this filesystem,
the problem vanished.

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-07-ichiban-munin-nossd.png

I don't have a new video yet, but I'll set up a cron tonight and post it
later.

I'm going to send another mail specifically about the nossd/ssd
behaviour and other things I found out last week, but that'll probably
be tomorrow.

-- 
Hans van Kranenburg
