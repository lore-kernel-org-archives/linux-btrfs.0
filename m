Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:44499 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbaL0LxE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 06:53:04 -0500
Message-ID: <549E9D98.7010102@pobox.com>
Date: Sat, 27 Dec 2014 03:52:56 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>, Hugo Mills <hugo@carfax.org.uk>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
References: <3738341.y7uRQFcLJH@merkaba> <4232026.31LFOYpm2s@merkaba> <20141227093043.GJ25267@carfax.org.uk> <3538352.CI4nobbHtu@merkaba>
In-Reply-To: <3538352.CI4nobbHtu@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/27/2014 02:54 AM, Martin Steigerwald wrote:
> Am Samstag, 27. Dezember 2014, 09:30:43 schrieb Hugo Mills:
>> On Sat, Dec 27, 2014 at 10:01:17AM +0100, Martin Steigerwald wrote:
>>> Am Freitag, 26. Dezember 2014, 14:48:38 schrieb Robert White:
>>>> On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
>>>>> Hello!
>>>>>
>>>>> First: Have a merry christmas and enjoy a quiet time in these days.
>>>>>
>>>>> Second: At a time you feel like it, here is a little rant, but also a
>>>>> bug
>>>>> report:
>>>>>
>>>>> I have this on 3.18 kernel on Debian Sid with BTRFS Dual SSD RAID with
>>>>> space_cache, skinny meta data extents – are these a problem? – and
>>>>
>>>>> compress=lzo:
>>>> (there is no known problem with skinny metadata, it's actually more
>>>> efficient than the older format. There has been some anecdotes about
>>>> mixing the skinny and fat metadata but nothing has ever been
>>>> demonstrated problematic.)
>>>>
>>>>> merkaba:~> btrfs fi sh /home
>>>>> Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a
>>>>>
>>>>>           Total devices 2 FS bytes used 144.41GiB
>>>>>           devid    1 size 160.00GiB used 160.00GiB path
>>>>>           /dev/mapper/msata-home
>>>>>           devid    2 size 160.00GiB used 160.00GiB path
>>>>>           /dev/mapper/sata-home
>>>>>
>>>>> Btrfs v3.17
>>>>> merkaba:~> btrfs fi df /home
>>>>> Data, RAID1: total=154.97GiB, used=141.12GiB
>>>>> System, RAID1: total=32.00MiB, used=48.00KiB
>>>>> Metadata, RAID1: total=5.00GiB, used=3.29GiB
>>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>>
>>>> This filesystem, at the allocation level, is "very full" (see below).
>>>>
>>>>> And I had hangs with BTRFS again. This time as I wanted to install tax
>>>>> return software in Virtualbox´d Windows XP VM (which I use once a year
>>>>> cause I know no tax return software for Linux which would be suitable
>>>>> for
>>>>> Germany and I frankly don´t care about the end of security cause all
>>>>> surfing and other network access I will do from the Linux box and I
>>>>> only
>>>>> run the VM behind a firewall).
>>>>
>>>>> And thus I try the balance dance again:
>>>> ITEM: Balance... it doesn't do what you think it does... 8-)
>>>>
>>>> "Balancing" is something you should almost never need to do. It is only
>>>> for cases of changing geometry (adding disks, switching RAID levels,
>>>> etc.) of for cases when you've radically changed allocation behaviors
>>>> (like you decided to remove all your VM's or you've decided to remove a
>>>> mail spool directory full of thousands of tiny files).
>>>>
>>>> People run balance all the time because they think they should. They are
>>>> _usually_ incorrect in that belief.
>>>
>>> I only see the lockups of BTRFS is the trees *occupy* all space on the
>>> device.
>>     No, "the trees" occupy 3.29 GiB of your 5 GiB of mirrored metadata
>> space. What's more, balance does *not* balance the metadata trees. The
>> remaining space -- 154.97 GiB -- is unstructured storage for file
>> data, and you have some 13 GiB of that available for use.
>
> Ok, let me rephrase that: Then the space *reserved* for the trees occupies all
> space on the device. Or okay, when that I see in btrfs fi df as "total" in
> summary occupies what I see as "size" in btrfs fi sh, i.e. when "used" equals
> space in "btrfs fi sh"
>
> What happened here is this:
>
> I tried
>
>   https://blogs.oracle.com/virtualbox/entry/how_to_compact_your_virtual
>
> in order to regain some space from the Windows XP VDI file. I just wanted to
> get around upsizing the BTRFS again.
>
> And on the defragementation step in Windows it first ran fast. For about 46-47%
> there, during that fast phase btrfs fi df showed that BTRFS was quickly
> reserving the remaining free device space for data trees (not metadata).

The above statement is word-salad. The storage for data is not a "data 
tree", the tree that maps data into a file is metadata. The data is 
data. There is no "data tree".

> Only after a while after it did so, it got slow again, basically the Windows
> defragmentation process stopped at 46-47% altogether and then after a while
> even the desktop locked due to processes being blocked in I/O.

If you've over-organized your very-large data files you can get waste 
some terrific amounts of space.

[---------------------------------------]
   [-------]     [uuuuuuu]  [] [-----]
       [------] [-----][----]   [-------]
                    [----]

As you write new segments you don't actually free the lower extents 
unless they are _completely_ obscured end-to-end by a later extent. So 
if you've _ever_ defragged the BTRFS extent to be fully contiguous and 
you've not overwritten each and every byte later, the original expanse 
is still going to be there.

In the above exampel only the "uuu" block is ever freed, and only when 
the fourth generation finally covers the little gap.

In the worst case you can end up with (N*(N+1))/2 total blocks used up 
on disk when only N blocks are visible. (See the Gauss equation for the 
sum of consecutive integers for why this is the correct approximation 
for the worst case.)

[------------]
[-----------]
[----------]
...
[-]

Each generation, being one block shorter than the previous one, exposes 
N blocks, one from each generation. So 1+2+3+4+5...+N blocks allocated 
if each ovewrite is one block shorter than the previous.

So if your original VDI file was all in little pieces all through the 
disk, it will waste less space (statistically).

But if you keep on defragging the file internally and externally you can 
end up with many times the total file size "in use" to represent the 
disk file.

So like I said, if you start trying to _force_ order you will end up 
paying significant expenses as the file ages.

COW can help, but every snapshot counts as a generation, so really it's 
not necessarily ideal.

I suspect that copying the file as 100 blocks (400k) [or so] at a time 
would lead to a file likely to sanitize its history with overwrites.

As it is, coercing order is not your friend. But once done, the best 
thing to do is periodically copy the whole file anew to burp the history 
out of it.

>
> I decided to forget about this downsizing of the Virtualbox VDI file, it will
> extend again on next Windows work and it is already 18 GB of its maximum 20GB,
> so… I dislike the approach anyway, and don´t even understand why the
> defragmentation step would be necessary as I think Virtualbox can poke holes
> into the file for any space not allocated inside the VM, whether it is
> defragmented or not.

If you don't have trim turned on in both the virtual box and the base 
system then there is no discarding to be done. And defrag is "meh" in 
your arrangement. [See "lsblk -D" to see if you are doing real discards. 
Check windows as well.

Then consider using _raw_ disk format instead of VDI since the 
"container format" may not result in trim operations comming through to 
the underlying filesystem as such. (I don't know for sure).

So basically, you've arranged your storage almost exactly wrong by 
defragging and such, particularly since you are doing it at both layers.

I know where you got the advice from, but its not right for the BTRFS 
assumptions.

>
>>     Now, since you're seeing lockups when the space on your disks is
>> all allocated I'd say that's a bug. However, you're the *only* person
>> who's reported this as a regular occurrence. Does this happen with all
>> filesystems you have, or just this one?
>
> The *only* person? The compression lockups with 3.15 and 3.16, quite some
> people saw them, I thought. For me also these lockups only happened with all
> space on device allocated.
>
> And these seem to be gone. In regular use it doesn´t lockup totally hard. But
> in the a processes writes a lot into one big no-cowed file case, it seems it
> can still get into a lockup, but this time one where a kworker thread consumes
> 100% of CPU for minutes.



>
>>> I *never* so far saw it lockup if there is still space BTRFS can allocate
>>> from to *extend* a tree.
>>
>>     It's not a tree. It's simply space allocation. It's not even space
>> *usage* you're talking about here -- it's just allocation (i.e. the FS
>> saying "I'm going to use this piece of disk for this purpose").
>
> Okay, I thought it is the space BTRFS reserves for a tree or well the *chunks*
> the tree manages. I am aware of that it isn´t already *used* space, its just
> *reserved*
>
>>> This may be a bug, but this is what I see.
>>>
>>> And no amount of "you should not balance a BTRFS" will make that
>>> perception go away.
>>>
>>> See, I see the sun coming out on a morning and you tell me "no, it
>>> doesn´t". Simply that is not going to match my perception.
>>
>>     Duncan's assertion is correct in its detail. Looking at your space
>> usage, I would not suggest that running a balance is something you
>> need to do. Now, since you have these lockups that seem quite
>> repeatable, there's probably a lurking bug in there, but hacking
>> around with balance every time you hit it isn't going to get the
>> problem solved properly.
>
> It was Robert writing this I think.
>
> Well I do not like to balance the FS, but I see the result, I see that it
> helps here. And thats about it.
>
> My theory from watching the Windows XP defragmentation case is this:
>
> - For writing into the file BTRFS needs to actually allocate and use free space
> in the current tree allocation, or, as we seem to misunderstood from the words
> we use, it needs to fit data in
>
> Data, RAID1: total=144.98GiB, used=140.94GiB
>
> between 144,98 GiB and 140,94 GiB given that total space of this tree, or if
> its not a tree, but the chunks in that the tree manages, in these chunks can
> *not* be extended anymore.

If your file was actually COW (and you have _not_ been taking snapshots) 
then there is no extenting to be had. But if you are using snapper 
(which I believe you mentioned previously) then the snapshots cause a 
write boundary and a layer of copying. Frequently taking snapshots of a 
COW file is self defeating. If you are going to take snapshots then you 
might as well turn copy on write back on and, for the love of pete, stop 
defragging things.


> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=5.00GiB, used=3.24GiB
>
> - What I see now is as long as it can be extended, BTRFS on this workload
> *happily* does so. *Quickly*. Up to the amount of the free, unreserved space
> of the device. And *even* if in my eyes there is a big enough difference
> between total and used in btrfs fi df.
>
> - Then as all the device space is *reserved*, BTRFS needs to fit the allocation
> within the *existing* chunks instead of reserving a new one and fill the empty
> one. And I think this is where it gets problems.
>
>
> I extended both devices of /home by 10 GiB now and I was able to comlete some
> balance steps with these results.
>
> Original after my last partly failed balance attempts:
>
> Label: 'home'  uuid: […]
>          Total devices 2 FS bytes used 144.20GiB
>          devid    1 size 170.00GiB used 159.01GiB path /dev/mapper/msata-home
>          devid    2 size 170.00GiB used 159.01GiB path /dev/mapper/sata-home
>
> Btrfs v3.17
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=153.98GiB, used=140.95GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=5.00GiB, used=3.25GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> Then balancing, but not all of them:
>
> merkaba:~#1> btrfs balance start -dusage=70 /home
> Done, had to relocate 9 out of 162 chunks
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=146.98GiB, used=140.95GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=5.00GiB, used=3.25GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> merkaba:~> btrfs balance start -dusage=80 /home
> Done, had to relocate 9 out of 155 chunks
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=144.98GiB, used=140.94GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=5.00GiB, used=3.24GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> merkaba:~> btrfs fi sh /home
> Label: 'home'  uuid: […]
>          Total devices 2 FS bytes used 144.19GiB
>          devid    1 size 170.00GiB used 150.01GiB path /dev/mapper/msata-home
>          devid    2 size 170.00GiB used 150.01GiB path /dev/mapper/sata-home
>
> Btrfs v3.17
>
>
> This is a situation where I do not see any slowdowns with BTRFS.
>
> As far as I understand the balance commands I used I told BTRFS the following:
>
> - go and balance all chunks that has 70% or less used
> - go and balance all chunks that have 80% or less used
>
> I rarely see any chunks that have 60% or less used and get something like this
> if I try:
>
> merkaba:~> btrfs balance start -dusage=60 /home
> Done, had to relocate 0 out of 153 chunks
>
>
>
> Now my idea is this: BTRFS will need to satisfy the allocations it need to do
> for writing heavily into a cow´ed file from the already reserved space. Yet if
> I have lots of chunks that are filled between 60-70% it needs to spread the
> allocations in the 40-30% of the chunk that are not yet used.
>
> My theory is this: If BTRFS needs to do this *heavily*, it at some time gets
> problems while doing so. Apparently it seems *easier* to just reserve a new
> chunk and fill the fresh chunk then. Otherwise I don´t know why BTRFS is doing
> it like this. It prefers to reserve free device space on this defragmentation
> inside VM then.

When you defrag inside the VM, it gets scrambled through the VDI 
container, then layered into the BTRFS filesystem. This can consume vast 
amounts of space wiht no purpose. so...

Don't do that.


> And these issues may be due to an inefficient implementation or bug.

Or just stop fighting the system with all the unnecessary defragging. 
Watch the picture as it defrags. Look at all that layered writing. 
That's what's killing you.

(I do agree, however, that the implementation can become very 
inefficient, especially if you do exactly the wrong things.)

>
> Now if no one else if ever having this, this may be a speciality with my
> filesystem and heck I can recreate it from scratch if need be. Yet I would
> prefer to find out what is happening here.
>
>
>>     I think I would suggest the following:
>>
>>   - make sure you have some way of logging your dmesg permanently (use
>>     a different filesystem for /var/log, or a serial console, or a
>>     netconsole)
>>
>>   - when the lockup happens, hit Alt-SysRq-t a few times
>>
>>   - send the dmesg output here, or post to bugzilla.kernel.org
>>
>>     That's probably going to give enough information to the developers
>> to work out where the lockup is happening, and is clearly the way
>> forward here.
>
> Thanks, I think this seems to be a way to go.
>
> Actually the logging should be safe I´d say, cause it wents into a different
> BTRFS. The BTRFS for /, which is also a RAID 1 and which didn´t show this
> behavior yet, although it has also all space reserved since quite some time:
>
> merkaba:~> btrfs fi sh /
> Label: 'debian'  uuid: […]
>          Total devices 2 FS bytes used 17.79GiB
>          devid    1 size 30.00GiB used 30.00GiB path /dev/mapper/sata-debian
>          devid    2 size 30.00GiB used 30.00GiB path /dev/mapper/msata-debian
>
> Btrfs v3.17
> merkaba:~> btrfs fi df /
> Data, RAID1: total=27.99GiB, used=17.21GiB
> System, RAID1: total=8.00MiB, used=16.00KiB
> Metadata, RAID1: total=2.00GiB, used=596.12MiB
> GlobalReserve, single: total=208.00MiB, used=0.00B
>
>
> *Unlike* if one BTRFS locks up the other will also lock up, logging should be
> safe.
>
> Actually I got the last task hung messages as I posted them here. So I may
> just try to reproduce this and trigger
>
> echo "t" > /proc/sysrq-trigger
>
> this gives
>
> [32459.707323] systemd-journald[314]: /dev/kmsg buffer overrun, some messages
> lost.
>
> but I bet rsyslog will capture it just nice. I may even disable journald to
> reduce writes to / during reproducing the bug.
>
> Ciao,
>


ASIDE: I've been considering recreating my raw extents with COW turned 
_off_, but doing it as a series of 4Meg appends so that the underlying 
allocation would look like

[--][--][--][--][--][--][--][--][--][--][--][--][--]...[--][--]

this would net the most naturally discard-ready/cleanable history.

It's the vast expanse of the preallocated base.
