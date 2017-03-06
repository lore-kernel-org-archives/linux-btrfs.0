Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34089 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdCFNHv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 08:07:51 -0500
Received: by mail-io0-f170.google.com with SMTP id 90so112365023ios.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Mar 2017 05:07:50 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 17sm279451ioq.45.2017.03.06.05.07.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Mar 2017 05:07:28 -0800 (PST)
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
To: linux-btrfs@vger.kernel.org
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
 <20170302103753.x35jhe7xgnwl6ee6@angband.pl>
 <20170303065622.2a9a244e@jupiter.sol.kaishome.de>
 <88b27891-b3fc-eef6-d793-96fd32504818@gmail.com>
 <20170303211037.59abb4b7@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <81bb1bdb-cc43-0f71-ab5b-756413795c4f@gmail.com>
Date: Mon, 6 Mar 2017 08:07:24 -0500
MIME-Version: 1.0
In-Reply-To: <20170303211037.59abb4b7@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-03 15:10, Kai Krakow wrote:
> Am Fri, 3 Mar 2017 07:19:06 -0500
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>
>> On 2017-03-03 00:56, Kai Krakow wrote:
>>> Am Thu, 2 Mar 2017 11:37:53 +0100
>>> schrieb Adam Borowski <kilobyte@angband.pl>:
>>>
>>>> On Wed, Mar 01, 2017 at 05:30:37PM -0700, Chris Murphy wrote:
>>  [...]
>>>>
>>>> Well, there's Qu's patch at:
>>>> https://www.spinics.net/lists/linux-btrfs/msg47283.html
>>>> but it doesn't apply cleanly nor is easy to rebase to current
>>>> kernels.
>>  [...]
>>>>
>>>> Well, yeah.  The current check is naive and wrong.  It does have a
>>>> purpose, just fails in this, very common, case.
>>>
>>> I guess the reasoning behind this is: Creating any more chunks on
>>> this drive will make raid1 chunks with only one copy. Adding
>>> another drive later will not replay the copies without user
>>> interaction. Is that true?
>>>
>>> If yes, this may leave you with a mixed case of having a raid1 drive
>>> with some chunks not mirrored and some mirrored. When the other
>>> drives goes missing later, you are loosing data or even the whole
>>> filesystem although you were left with the (wrong) imagination of
>>> having a mirrored drive setup...
>>>
>>> Is this how it works?
>>>
>>> If yes, a real patch would also need to replay the missing copies
>>> after adding a new drive.
>>>
>> The problem is that that would use some serious disk bandwidth
>> without user intervention.  The way from userspace to fix this is to
>> scrub the FS.  It would essentially be the same from kernel space,
>> which means that if you had a multi-TB FS and this happened, you'd be
>> running at below capacity in terms of bandwidth for quite some time.
>> If this were to be implemented, it would have to be keyed off of the
>> per-chunk degraded check (so that _only_ the chunks that need it get
>> touched), and there would need to be a switch to disable it.
>
> Well, I'd expect that a replaced drive would involve reduced bandwidth
> for a while. Every traditional RAID does this. The key solution there
> is that you can limit bandwidth and/or define priorities (BG rebuild
> rate).
>
> Btrfs OTOH could be a lot more smarter, only rebuilding chunks that are
> affected. The kernel can already do IO priorities and some sort of
> bandwidth limiting should also be possible. I think IO throttling is
> already implemented in the kernel somewhere (at least with 4.10) and
> also in btrfs. So the basics are there.
I/O prioritization in Linux is crap right now.  Only one scheduler 
properly supports it, and that scheduler is deprecated, not to mention 
that it didn't work reliably to begin with.  There is a bandwidth 
limiting mechanism in place, but that's for userspace stuff, not kernel 
stuff (which is why scrub is such an issue, the actual I/O is done by 
the kernel, not userspace).
>
> In a RAID setup, performance should never have priority over redundancy
> by default.
>
> If performance is an important factor, I suggest working with SSD
> writeback caches. This is already possible with different kernel
> techniques like mdcache or bcache. Proper hardware controllers also
> support this in hardware. It's cheap to have a mirrored SSD
> writeback cache of 1TB or so if your setup already contains a multiple
> terabytes array. Such a setup has huge performance benefits in setups
> we deploy (tho, not btrfs related).
>
> Also, adding/replacing a drive is usually not a totally unplanned
> event. Except for hot spares, a missing drive will be replaced at the
> time you arrive on-site. If performance is a factor, this can be done
> the same time as manually starting the process. So why not should it be
> done automatically?
You're already going to be involved because you can't (from a practical 
perspective) automate the physical device replacement, so all that 
making it automatic does is make things more convenient.  In general, if 
you're concerned enough to be using a RAID array, you probably shouldn't 
be trading convenience for data safety, and as of right now, BTRFS isn't 
mature enough that it could be said to be consistently safe to automate 
almost anything.

There are plenty of other reasons for it to not be automatic though, the 
biggest being that it will waste bandwidth (and therefore time) if you 
plan to convert profiles after adding the device.  That said, it would 
be nice to have a switch for the add command to automatically re-balance 
the array.
