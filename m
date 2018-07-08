Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41410 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932255AbeGHIH4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jul 2018 04:07:56 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fc4hP-0006n4-15
        for linux-btrfs@vger.kernel.org; Sun, 08 Jul 2018 10:05:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how to best segment a big block device in resizeable btrfs
 filesystems?
Date: Sun, 8 Jul 2018 08:05:27 +0000 (UTC)
Message-ID: <pan$81eb5$e9127e5f$5b2e03ba$1abc9191@cox.net>
References: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
        <20180629064354.kbaepro5ccmm6lkn@merlins.org>
        <20180701232202.vehg7amgyvz3hpxc@merlins.org>
        <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
        <20180702032259.GD5567@merlins.org>
        <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
        <20180702140527.wfbq5jenm67fvvjg@merlins.org>
        <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
        <20180702151853.mwlrinipbihq46zu@merlins.org>
        <e8e78a5b-1db2-ddf0-f8ea-38f8ac9be654@gmail.com>
        <20180702173438.7c2vhflvtncfb5gz@merlins.org>
        <8de54b29-c718-0230-09b2-f849e3ad01df@gmail.com>
        <9e79a4b4-af3c-20bf-ff8e-748b9ab46bf6@gmail.com>
        <pan$3326b$1b5189ef$d6f2b03e$a3db8011@cox.net>
        <293ab6d6-f609-0e9b-3d33-053336e43744@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andrei Borzenkov posted on Fri, 06 Jul 2018 07:28:48 +0300 as excerpted:

> 03.07.2018 10:15, Duncan пишет:
>> Andrei Borzenkov posted on Tue, 03 Jul 2018 07:25:14 +0300 as
>> excerpted:
>> 
>>> 02.07.2018 21:35, Austin S. Hemmelgarn пишет:
>>>> them (trimming blocks on BTRFS gets rid of old root trees, so it's a
>>>> bit dangerous to do it while writes are happening).
>>>
>>> Could you please elaborate? Do you mean btrfs can trim data before new
>>> writes are actually committed to disk?
>> 
>> No.
>> 
>> But normally old roots aren't rewritten for some time simply due to
>> odds (fuller filesystems will of course recycle them sooner), and the
>> btrfs mount option usebackuproot (formerly recovery, until the
>> norecovery mount option that parallels that of other filesystems was
>> added and this option was renamed to avoid confusion) can be used to
>> try an older root if the current root is too damaged to successfully
>> mount.

>> But other than simply by odds not using them again immediately, btrfs
>> has
>> no special protection for those old roots, and trim/discard will
>> recover them to hardware-unused as it does any other unused space, tho
>> whether it simply marks them for later processing or actually processes
>> them immediately is up to the individual implementation -- some do it
>> immediately, killing all chances at using the backup root because it's
>> already zeroed out, some don't.
>> 
>> 
> How is it relevant to "while writes are happening"? Will trimming old
> tress immediately after writes have stopped be any different? Why?

Define "while writes are happening" vs. "immediately after writes have 
stopped".  How soon is "immediately", and does the writes stopped 
condition account for data that has reached the device-hardware write 
buffer (so is no longer being transmitted to the device across the bus) 
but not been actually written to media, or not?

On a reasonably quiescent system, multiple empty write cycles are likely 
to have occurred since the last write barrier, and anything in-process is 
likely to have made it to media even if software is missing a write 
barrier it needs (software bug) or the hardware lies about honoring the 
write barrier (hardware bug, allegedly sometimes deliberate on hardware 
willing to gamble with your data that a crash won't happen in a critical 
moment, a somewhat rare occurrence, in ordered to improve normal 
operation performance metrics).

On an IO-maxed system, data and write-barriers are coming down as fast as 
the system can handle them, and write-barriers become critical -- crash 
after something was supposed to get to media but didn't, either because 
of a missing write barrier or because the hardware/firmware lied about 
the barrier and said the data it was supposed to ensure was on-media was, 
when it wasn't, and the btrfs atomic-cow commit guarantees of consistent 
state at each commit go out the window.

At this point it becomes useful to have a number of previous "guaranteed 
consistent state" roots to fall back on, with the /hope/ being that at 
least /one/ of them is usably consistent.  If all but the last one are 
wiped due to trim...

When the system isn't write-maxed the write will have almost certainly 
made it regardless of whether the barrier is there or not, because 
there's enough idle time to finish the current write before another one 
comes down the pipe, so the last-written root is almost certain to be 
fine regardless of barriers, and the history of past roots doesn't matter 
even if there's a crash.

If "immediately after writes have stopped" is strictly defined as a 
condition when all writes including the btrfs commit updating the current 
root and the superblock pointers to the current root have completed, with 
no new writes coming down the pipe in the mean time that might have 
delayed a critical update if a barrier was missed, then trimming old 
roots in this state should be entirely safe, and the distinction between 
that state and the "while writes are happening" is clear.

But if "immediately after writes have stopped" is less strictly defined, 
then the distinction between that state and "while writes are happening" 
remains blurry at best, and having old roots around to fall back on in 
case a write-barrier was missed (for whatever reason, hardware or 
software) becomes a very good thing.

Of course the fact that trim/discard itself is an instruction written to 
the device in the combined command/data stream complexifies the picture 
substantially.  If those write barriers get missed who knows what state 
the new root is in, and if the old ones got erased...  But again, on a 
mostly idle system, it'll probably all "just work", because the writes 
will likely all make it to media, regardless, because there's not a bunch 
of other writes competing for limited write bandwidth and making ordering 
critical.

>> In the context of the discard mount option, that can mean there's never
>> any old roots available ever, as they've already been cleaned up by the
>> hardware due to the discard option telling the hardware to do it.
>> 
>> But even not using that mount option, and simply doing the trims
>> periodically, as done weekly by for instance the systemd fstrim timer
>> and service units, or done manually if you prefer, obviously
>> potentially wipes the old roots at that point.  If the system's
>> effectively idle at the time, not much risk as the current commit is
>> likely to represent a filesystem in full stasis, but if there's lots of
>> writes going on at that moment *AND* the system happens to crash at
>> just the wrong time, before additional commits have recreated at least
>> a bit of root history, again, you'll potentially be left without any
>> old roots for the usebackuproot mount option to try to fall back to,
>> should it actually be necessary.
>> 
>> 
> Sorry? You are just saying that "previous state can be discarded before
> new state is committed", just more verbosely.

No, it's more the new state gets committed before the old is trimmed, but 
should it turn out to be unusable (due to missing write barriers, etc, 
which is more of an issue on a write-bottlenecked system), having a 
history of old roots/states around to fall back to can be very useful.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

