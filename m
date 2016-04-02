Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36919 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbcDBHbv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Apr 2016 03:31:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amG29-0002QX-NO
	for linux-btrfs@vger.kernel.org; Sat, 02 Apr 2016 09:31:49 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 09:31:49 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 09:31:49 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Another ENOSPC situation
Date: Sat, 2 Apr 2016 07:31:44 +0000 (UTC)
Message-ID: <pan$9f448$74821e54$55580fe7$7b88b8c6@cox.net>
References: <20160401134029.GH9342@torres.zugschlus.de>
	<pan$68f59$f32b7e2a$86338be2$5ab70cec@cox.net>
	<CAJCQCtR8RNJddBXAcTsbFN51YrwEDSz2Get45oQyJsP3o6xS-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 01 Apr 2016 23:43:46 -0600 as excerpted:

> On Fri, Apr 1, 2016 at 10:55 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Marc Haber posted on Fri, 01 Apr 2016 15:40:29 +0200 as excerpted:
> 
>>> [4/502]mh@swivel:~$ sudo btrfs fi usage / Overall:
>>>     Device size:                 600.00GiB Device allocated:          
>>>      600.00GiB Device unallocated:            1.00MiB
>>
>> That's the problem right there.  The admin didn't do his job and spot
>> the near full allocation issue
> 
> 
> I don't yet agree this is an admin problem. This is the 2nd or 3rd case
> we've seen only recently where there's plenty of space in all chunk
> types and yet ENOSPC happens, seemingly only because there's no
> unallocated space remaining. I don't know that this is a regression for
> sure, but it sure seems like one.

Notice that he said _balance_ failed with ENOSPC.  He did _NOT_ say he 
was getting it in ordinary usage, just yet.  Which would fit a 100% 
allocated situation, with plenty of space left in both data and metadata 
chunks.  The plenty of space left inside the chunks would keep ordinary 
usage from running into problems just yet, but balance really /does/ need 
room to allocate at least one new chunk in ordered to properly handle the 
chunk rewrite via COW.  (At least for data, metadata seems to work a bit 
differently.  See below.)

Balance has always failed with ENOSPC if there was no unallocated space 
left.  It used to happen all the time, before btrfs learned how to delete 
empty chunks in 3.17, but while that helps, it only works for literally 
/empty/ chunks.  Chunks with even a single block/node still in use don't 
get deleted automatically.

What I think is happening now is that while the empty-chunk deleting from 
3.17 on helped, it has been long enough since then, now, that people with 
particular usage patterns, I'd strongly suspect those with heavy 
snapshotting, don't tend to fully empty their chunks to the extent that 
those with other usage patterns do, and it has been just long enough now 
that we're beginning to see the problem reported again, because deleting 
empty chunks helped, but they weren't fully emptying enough chunks to 
keep up with things that way, in their particular use-cases.

>>> Data,single: Size:553.93GiB, Used:405.73GiB
>>>    /dev/mapper/swivelbtr         553.93GiB
>>>
>>> Metadata,DUP: Size:23.00GiB, Used:3.83GiB
>>>    /dev/mapper/swivelbtr          46.00GiB
>>>
>>> System,DUP: Size:32.00MiB, Used:112.00KiB
>>>    /dev/mapper/swivelbtr          64.00MiB
>>>
>>> Unallocated:
>>>    /dev/mapper/swivelbtr           1.00MiB
>>> [5/503]mh@swivel:~$
>>
>> Both data and metadata have several GiB free, data ~140 GiB free, and
>> metadata isn't into global reserve, so the system isn't totally wedged,
>> only partially, due to the lack of unallocated space.
> 
> Unallocated space alone hasn't ever caused this that I can remember.
> It's most often been totally full metadata chunks, with free space in
> allocated data chunks, with no unallocated space out of which to create
> another metadata chunk to write out changes.

Unallocated space alone doesn't cause ENOSPC with normal operations; for 
those you're correct, running out of either data or metadata space is 
required as well.  (Normally it's metadata that runs out, but I recall 
seeing one post from someone who had metadata room but full data.  The 
behavior was.. "interesting", as he could do renames, etc, and even 
create small files as long as they were small enough to stay in 
metadata.  As soon as he tried to do anything that needed an actual data 
extent, however, ENOSPC.)

But balance has always required space to allocate at least one chunk, as 
COW means the existing chunk can't be released until everything is 
rewritten into the new one.

Tho it seems that btrfs can sometimes either write very small metadata 
chunks, which don't forget are dup by default on a single device, as they 
are in this case.  He has 1 MiB unallocated.  Split in half that's 512 
KiB.  I'm not sure if btrfs can go that small, but if it can, and it can 
find a low enough usage metadata chunk to write into it, freeing the 
larger metadata chunk...

Or maybe btrfs can actually use the global reserve for that, since global 
reserve is part of metadata.  If it can, a 512 MiB global reserve would 
be just large enough to write the two copies of a nominally 256 MiB 
metadata chunk.

Either way, I've seen a number of times now where btrfs was able to 
balance metadata, when it had less than the 256 (*2 if dup) MiB 
unallocated that would normally be required.  Maybe it /is/ able to use 
global reserve for that, which would allow it to work, as long as 
metadata isn't so tight that it's already using global reserve.  That's 
actually what I bet it's doing, now that I think about it.  Because as 
long as the global reserve isn't being used, 512 MiB of global reserve 
would be exactly 2*256 MiB metadata chunks, and if they're unused, that 
would allow balance to claim them without actually having to allocate 
them.  But, I'd bet it works only if global reserve remains at absolutely 
0 usage.

> There should be plenty of space for either a -dusage=1 or -musage=1
> balance to free up a bunch of partially allocated chunks. Offhand I
> don't think the profiles filter is helpful in this case.
> 
> OK so where I could be wrong is that I'm expecting balance doesn't
> require allocated space to work. I'd expect that it can COW extents from
> one chunk into another existing chunk (of the same type) and then once
> that's successful, free up that chunk, i.e. revert it back to
> unallocated. If balance can only copy into newly allocated chunks, that
> seems like a big problem. I thought that problems had been fixed a very
> long time ago.

I don't believe it can.  It has to create new chunks.  (Tho if it works 
as in the metadata and global reserve discussion above, that would be an 
exception, as it could then use those 100% unused metadata global reserve 
chunks without having to actually allocate them first.)

> And what we don't see from 'usage' that we will see from 'df' is the
> GlobalReserve values. I'd like to see that.

Actually... look again.  It's there, and I quoted it, but you snipped 
that part. =:^)

Tho I don't blame you, an actually usable btrfs fi usage is new enough to 
all of us that we're still getting used to it, and don't have its format 
hard-wired into our wetware by repetition just yet, as we do btrfs fi 
show and btrfs fi df.  I know there's been several times when I "lost" a 
figure in fi usage that I knew was there... somewhere! and had to start 
from the top and go thru every line one by one to find it, because I just 
don't know usage like I know show and df yet. =:^\

Plus, I think it's a bit more difficult because the display is more 
spread out, so there's more "haystack" to lose the "needle" in. =;^P

But I suppose we'll get used to it, over time.

> Anyway, in the meantime there is a work around:
> 
> btrfs dev add
> 
> Just add a device, even if it's an 8GiB flash drive. But it can be a
> spare space on a partition, or it can be a logical volume, or whatever
> you want. That'll add some gigs of unallocated space. Now the balance
> will work, or for absolutely sure there's a bug (and a new one because
> this has always worked in the past). After whatever filtered or full
> balance is done, make sure to 'btfs dev rem' and confirm it's gone with
> 'btrfs fi show' before removing the device. It's a two device volume
> until that device is successfully removed and is in something of a
> fragile state until then because any loss of data on that 2nd device has
> a good chance of face planting the file system.

Agreed.  This is the next step if he can't finagle enough room out of 
metadata without it ENOSPCing.  But as I said, I've actually seen it 
(metadata only, not data... until metadata shrunk enough to leave some 
gigs unallocated) work a couple times recently when I didn't think it 
could due to no unallocated space, and I'm actually beginning to think 
that's due to balance being able to use the (metadata-only) global 
reserve.

Which would make sense, but it's either a relatively new development, or 
one I simply didn't know about previously.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

