Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34405 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758012AbcILLhz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 07:37:55 -0400
Received: by mail-oi0-f50.google.com with SMTP id m11so306996906oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 04:37:55 -0700 (PDT)
Subject: Re: btrfs kernel oops on mount
To: moparisthebest <admin@moparisthebest.com>, linux-btrfs@vger.kernel.org
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
 <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
 <a6bbb384-f51a-34f8-0789-27a9945a20f6@moparisthebest.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e659931f-5af8-b60c-b71a-4dbf24a44c1d@gmail.com>
Date: Mon, 12 Sep 2016 07:37:50 -0400
MIME-Version: 1.0
In-Reply-To: <a6bbb384-f51a-34f8-0789-27a9945a20f6@moparisthebest.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-09 15:23, moparisthebest wrote:
> On 09/09/2016 02:47 PM, Austin S. Hemmelgarn wrote:
>> On 2016-09-09 12:12, moparisthebest wrote:
>>> Hi,
>>>
>>> I'm hoping to get some help with mounting my btrfs array which quit
>>> working yesterday.  My array was in the middle of a balance, about 50%
>>> remaining, when it hit an error and remounted itself read-only [1].
>>> btrfs fi show output [2], btrfs df output [3].
>>>
>>> I unmounted the array, and when I tried to mount it again, it locked up
>>> the whole system so even alt+sysrq would not work.  I rebooted, tried to
>>> mount again, same lockup.  This was all kernel 4.5.7.
>>>
>>> I rebooted to kernel 4.4.0, tried to mount, crashed again, this time a
>>> message appeared on the screen and I took a picture [4].
>>>
>>> I rebooted into an arch live system with kernel 4.7.2, tried to mount
>>> again, got some dmesg output before it crashed [5] and took a picture
>>> when it crashed [6], says in part 'BUG: unable to handle kernel NULL
>>> pointer dereference at 00000000000001f0'.
>>>
>>> Is there anything I can do to get this in a working state again or
>>> perhaps even recover some data?
>>>
>>> Thanks much for any help
>>>
>>> [1]: https://www.moparisthebest.com/btrfs/initial_crash.txt
>>> [2]: https://www.moparisthebest.com/btrfs/btrfsfishow.txt
>>> [3]: https://www.moparisthebest.com/btrfs/btrfsdf.txt
>>> [4]: https://www.moparisthebest.com/btrfsoops.jpg
>>> [5]: https://www.moparisthebest.com/btrfs/dmsgprecrash.txt
>>> [6]: https://www.moparisthebest.com/btrfsnulldereference.jpg
>>
>> The output from btrfs fi show and fi df both indicate that the
>> filesystem is essentially completely full.  You've gotten to the point
>> where your using the global metadata reserve, and I think things are
>> getting stuck trying (and failing) to reclaim the space that's used
>> there.  The fact that the kernel is crashing in response to this is
>> concerning, but it isn't surprising as this is not something that's
>> really all that tested, and is very much not a normal operational
>> scenario.  I'm guessing that the error you hit that forced the
>> filesystem read-only is something that requires recovery, which in turn
>> requires copy-on-write updates of some of the metadata, which you have
>> essentially zero room for, and that's what's causing the kernel to choke
>> when trying to mount the filesystem.
>>
>> Given that the FS is pretty much wedged, I think your best bet for
>> fixing this is probably going to be to use btrfs restore to get the data
>> onto a new (larger) set of disks.  If you do take this approach, a
>> metadata dump might be useful, if somebody could find enough room to
>> extract it.
>>
>> Alternatively, because of the small amount of free space on the largest
>> device in the array, you _might_ be able to fix things if you can get it
>> mounted read-write by running a balance converting both data and
>> metadata to single profiles, adding a few more disks (or replacing some
>> with bigger ones), and then converting back to raid1 profiles.  This is
>> exponentially more risky than just restoring to a new filesystem, and
>> will almost certainly take longer.
>>
>> A couple of other things to comment about on this:
>> 1. 'can_overcommit' (the function that the Arch kernel choked on) is
>> from the memory management subsystem.  The fact that that's throwing a
>> null pointer says to me either your hardware has issues, or the Arch
>> kernel itself has problems (which would probably mean the kernel image
>> is corrupted).
>> 2. You may want to look for more symmetrically sized disks if you're
>> going to be using raid1 mode.  The space that's free on the last listed
>> disk in the filesystem is unusable in raid1 mode because there are no
>> other disks with usable space.
>> 3. In general, it's a good idea to keep an eye on space usage on your
>> filesystems.  If it's getting to be more than about 95% full, you should
>> be looking at getting some more storage space.  This is especially true
>> for BTRFS, as a 100% full BTRFS filesystem functionally becomes
>> permanently read-only because there's nowhere for the copy-on-write
>> updates to write to.
>
> If I read btrfs fi show right, it's got minimum ~600gb free on each one
> of the 8 drives, shouldn't that be more than enough for most things?  (I
> guess unless I have single files over 600gb that need COW'd, I don't though)
Ah, you're right, I misread all but the last line, sorry about the 
confusion!

That said, like Duncan mentioned, the fact the GlobalReserve is 
allocated combined with all that free space is not a good sign.  I think 
that balancing metadata may use it sometimes, but I'm not certain, and 
it definitely should not be showing anything allocated there in normal 
usage.
>
> Didn't ubuntu on kernel 4.4 die in the same can_overcommit function?
> (https://www.moparisthebest.com/btrfsoops.jpg) what kind of hardware
> issues would cause a repeatable kernel crash like that?  Like am I
> looking at memory issues or the SAS controller or what?
It doesn't look like it died in can_overcommit, as that's not anywhere 
on the stack trace.  The second item on the stack though 
(btrfs_async_reclaim_metadata_space) at least partly reinforces the 
suspicion that something is messed up in the filesystems metadata (which 
could explain the allocations in GlobalReserve, which is a subset of the 
Metadata chunks).  It looks like each crash was in a different place, 
but at least the first two could easily be different parts of the kernel 
choking on the same thing.  As far as the crash in can_overcommit, that 
combined with the apparent corrupted metadata makes me think there may 
be a hardware problem.  The first thing I'd check in that respect is the 
cabling to the drives themselves, followed by system RAM, the PSU, and 
the the storage controller.  I generally check in that order because 
it's trivial to check the cabling, and not all that difficult to check 
the RAM and PSU (and RAM is more likely to go bad than the PSU), and 
properly checking a storage controller is extremely dificult unless you 
have another known working one you can swap it for (and even then, it's 
only practical to check if you know the state on disk won't cause the 
kernel to choke).
>
> Thanks!
>

