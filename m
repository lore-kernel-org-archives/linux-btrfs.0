Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34480 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965590AbcAURkw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 12:40:52 -0500
Received: by mail-io0-f177.google.com with SMTP id 1so61871712ion.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 09:40:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$a0430$c59023ae$8ef223cd$7c2025cc@cox.net>
References: <CAHRikPEe9JVRmBysLQ8r1OhwXsSpfJOXy4EWU8m=egbkt9zE7w@mail.gmail.com>
	<CAJCQCtSyc1YAsVgNcPCeA5fW8cofwqSVuF69acZo+GYm2rUx4A@mail.gmail.com>
	<pan$a0430$c59023ae$8ef223cd$7c2025cc@cox.net>
Date: Thu, 21 Jan 2016 10:40:51 -0700
Message-ID: <CAJCQCtQpHuN9QYeTY+dZ7KH09cjD1=CPUw1Ba8vY-8bVgicTdQ@mail.gmail.com>
Subject: Re: Out of space on small-ish partition, clobber and other methods
 haven't worked
From: Chris Murphy <lists@colorremedies.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 3:41 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Wed, 20 Jan 2016 19:28:35 -0700 as excerpted:
>
>> On Wed, Jan 20, 2016 at 2:22 PM, Jerry Steinhauer
>> <jerry.steinhauer@singlewire.com> wrote:
>>
>>> % rm a.file
>>> rm: cannot remove 'a.file': No space left on device
>>> % cat /dev/null > a.file
>>> -sh: a.file: No space left on device
>
>>> % btrfs fi df /data
>>> System, single: total=32.00MiB, used=4.00KiB
>>> Data+Metadata, single: total=506.00MiB, used=500.39MiB
>>> GlobalReserve, single: total=12.00MiB, used=6.45MiB
>>
>>
>> I see somewhere between 6MiB and 12MiB that should be available for file
>> removal.
>
> I don't.  See that global reserve?  6.45 MiB into its emergency reserve,
> so effectively -6.45 MiB of space available for file removal.

Data+Metadata, single: total=506.00MiB, used=500.39MiB = 5.61MiB
GlobalReserve, single: total=12.00MiB, used=6.45MiB = 5.55

5.61+5.55= 11.16 MiB

I see somewhere between 5.61MiB and 11.16MiB "not used". Per usual
Btrfs is coy about what's actually available for writing, it just
tells us a total and what's used, leaving it up to us to guess what's
not used.

Qu has previously said Global Reserve is actually baked into Metadata
which is why I'm giving it a range, which excludes GlobalReserve at
the small end. So in any case there is ~5MiB that is not used either
in Metadata or in GlobalReserve, depending on your point of view.

And in any case, a single rm command should not take 5MiB to cow. If
there are no snapshots or reflinks then it's probably less than 100K
of writes.

But even if that's wrong, then the reserve is inadequate. There should
be no such thing as a filesystem, even cow, wedging itself into a
situation where it will allow too much data with normal write commands
to fill the file system up such that no files can then be deleted. A
non-privileged user could do that easily and totally nerf the file
system, don't you think that's a security risk?





>
> First of all, any time global reserve is used at all the filesystem is in
> very dire straits, and he's 6.45 MiB into the 12.00 MiB global reserve,
> so that alone tells us "we're not in Kansas any more!" =8^0
>
> Second, the btrfs fi show (which you didn't quote) says 540 MiB capacity.
>
> System           32 MiB total, can't be used for anything else
> Data+Metadata   506 MiB total, shared data/metadata as it's a small
> filesystem  (See why I didn't list global reserve here, below.)
>
>
> Total           538 MiB chunked out.  While that's 2 MiB from the
> reported 540 capacity, I don't believe system includes the reserved space
> (for boot loader, etc) at the beginning of the partition.  Between that
> and the limits of the chunk-allocator, he's likely all chunked-out, no
> possibility of allocating further chunks.




>
> Global reserve is normally reserved from metadata, which of course is
> shared data/metadata here, due to the size of the filesystem (which makes
> shared a practical necessity, the problems would be much worse if data
> and metadata chunks were separate!).
>
> So of the 506 MiB in data/metadata, 12 MiB are global reserve.  Which
> means there's only 494 MiB of normal data/metadata space, plus 12 MiB of
> global reserve.
>
> But the DF shows 500.39 MiB of data/metadata used, which means we're
> roughly 6.4 MiB past normal data/metadata usage into the emergency use
> only global reserve, which is indeed (roughly) what global reserve shows,
> 6.45 MiB used.

OK that's a fine explanation, but the UI is not explaining this at
all. In fact it's completely misleading *away* from the explanation
you give. It's suggesting there's free space by the fact "used" is
less than "total".


So no matter what, there's more than one bug here. The file system
shouldn't get itself into this situation, that's first and foremost,
it should have started to ENOSPC before it can no longer delete files.
And the user space tools shouldn't mislead the user about how much
free space there is, or require the user to do a bunch of side
calculations to find out that it's saying something other than what
it's saying.


-- 
Chris Murphy
