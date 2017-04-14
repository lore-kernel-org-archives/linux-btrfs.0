Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34966 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbdDNQrB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Apr 2017 12:47:01 -0400
Received: by mail-yw0-f169.google.com with SMTP id v207so22060027ywc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 09:47:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFKQ2Bs9-=serb7F-PHDVNQ-X2AXcWPG5jBs9xKXTKkTQ59O7Q@mail.gmail.com>
References: <CAFKQ2Bs9-=serb7F-PHDVNQ-X2AXcWPG5jBs9xKXTKkTQ59O7Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 14 Apr 2017 10:46:55 -0600
Message-ID: <CAJCQCtSc42UVczbDvVfWBma4eeoAMHRQJMX0vbSMt9yE4nPjeg@mail.gmail.com>
Subject: Re: Encountered kernel bug#72811. Advice on recovery?
To: Ank Ular <ankular.anime@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Summary: 22x device raid6 (data and metadata). One device vanished,
and the volume is rw,degraded mounted with writes happening; next time
it's mounted the formerly missing device is not missing so it's a
normal mount, and writes are happening. Then later, the filesystem
goes read only. Now there are problems, what are the escape routes?



OK the Autopsy Report:

> In my case, I had rebooted my system and one of the drives on my main
> array did not come up. I was able to mount in degraded mode. I needed
> to re-boot the following day. This time, all the drives in the array
> came up. Several hours later, the array went into read only mode.
> That's when I discovered the odd device out had been re-added without
> any kind of error message or notice.

The instant Btrfs complains about something, you cannot make
assumptions, and you have to fix it. You can't turn your back on it.
It's an angry goose with an egg nearby. And if you turn your back on
it, it'll beat your ass down. But because this is raid6, you thought
it's OK, it's a reliable predictable mule. And you made a lot of
assumptions that are totally reasonable because it's called raid6,
except that those assumptions are all wrong because Btrfs is not like
anything else, and it's raid doesn't work like anything else.



1. The first mount attempt fails. OK why? On Btrfs you must find out
why normal mount failed, because you don't want to use degraded mode
unless absolutely necessary. But you didn't troubleshoot it.

2. The second mount attempt with degraded works. This mode exists for
one reason, you are ready right now to add a new device and delete the
missing one. Other raid56's you can wait and just hope another drive
doesn't die. Not Btrfs. You might get one chance with rw,degraded to
do a device replacement and you have to make 'dev add' and 'dev del
missing' the top priority before writing anything else to the volume.
So if you're not ready to do this, the default first action is
ro,degraded. You can get data off the volume but not change it and
lose your chance to use degraded,rw which has a decent chance of being
a one time event. But you didn't do this, you assumed Btrfs raid56 is
OK to use rw,degraded like any other raid.

3. The third mount, you must have mounted with -o degraded right off
the bat, assuming the formerly missing device was still missing and
you'd  still need -o degraded. If you'd tried a normal mount, it would
have succeeded, which would have informed you the formerly missing
device had been found and was being used. Now you have normal chunks,
degraded chunks, and more normal chunks. This array is very confused.

4. Btrfs does not do active heals (auto generation limited scrub) when
a previously missing device becomes available again. It only does
passive healing as it encounters wrong or missing data.

5. Btrfs raid6 is obviously broken somehow, because you're not the
only person who has had a file system with all available information
and two copies, and it still breaks. Most of your data is raid6,
that's three copies (data plus two parity). Some of it is degraded
raid6 which is effectively raid5, so that's data plus one copy. And
yet at some point Btrfs gets confused in normal, non-degraded mount,
and splats to read-only.  This is definitely a bug. This requires a
complete call traces prior to and include the read-only splat, in a
bug report. Or it simply won't get better. It's unclear where the devs
are at priority wise with raid56, it's also unclear if they're going
to fix it, or rewrite it.


The point is, you made a lot of mistakes by making too many
assumptions, and not realizing that degraded state in Btrfs is
basically an emergency. Finally at the very end, it still could have
saved you from your own mistakes, but there's a missing feature
(active auto heal to catch up the missing device), and there's a bug
making the fs read-only. And now it's in a sufficiently
non-deterministic state that the repair tools probably can't repair
it.


>
> The practical problem with bug#72811 is that all the csum and transid
> information is treated as being just as valid on the automatically
> re-added drive as the same information on all the other drives.

My guess is that the first normal mount after degraded writes, the
readded drive has a new super block that has current valid
information, pointing to missing data, and only as it goes looking for
the data or metadata, does it start fixing things up. Passive. So it's
own passive healing is eventually hitting a brick wall the farther
backward in time it has to go to do these fix ups.

The passive repair works when it's a few bad sectors on the drive. But
when it's piles of missing data, this is the wrong mode. It needs a
limited scrub or balance to fix things. Right now you have to manually
do a full scrub or balance after you've mounted for even one second
using degraded,rw. That's why you want to avoid it at all costs.


>
> I don't have issues with the above tools not being ready for for
> raid56. Despite the mass quantities, none of the data involved it
> irretrievable, irreplaceable or of earth shattering importance on any
> level. This is a purely personal setup.

I think there's no justification for a 22 drive raid6 on Btrfs. It's
such an extreme usage case I expect something will go wrong, it will
totally betray the user, and there's so much other work that needs to
be done on Btrfs raid56 that it's not even interesting to do this
extreme case as an experiment to try and make Btrfs raid56 better.

Even aside from raid56, even if it were raid1 or 10 or single. It's a
problem. If you're doing snapshots, as Btrfs intends and makes easy
and cost free, it still comes with a cost with such a huge file
system. Balance will take a long time. If it gets into one of these
slow balance states, it can take weeks to do a scrub or balance.

Btrfs has scalability problems other than raid56. Once those are
mostly all fixed maybe the devs announce a plan for raid56 getting
fixed or replaced. Until then I think Btrfs raid56 is not interesting.


> I mention all this because I KNOW someone is going to go off on how I
> should have back ups of everything and how I should not run raid56 and
> how I should run mirrored instead etc. Been there. Done that. I have
> the same canned lecture for people running data centers for
> businesses.

As long as you've learned something, it's fine.



>
> Now that I've gotten that out of my system, what I would really like
> is some input/help into putting together a recovery strategy. As it
> happens, I had already scheduled and budgeted for the purchase of 8
> additional 6TB hard drives. This was in line with approaching 80%
> storage utilization. I've accelerated the purchase of these drives and
> now have them in hand. I do not currently have the resources to
> purchase a second drive chassis nor anymore additional drives. This
> means I cannot simply copy the entire array either directly nor via
> 'btrfs restore'.

You've got too much data for the available resources is what that
says. And that's a case for triage.



> On a superficial level, what I'd like to do is set up the new drives
> as a second array. Copy/move approximately 20TBs of pre-event data
> from the degraded array. Delete/remove/free up those 20TBs from the
> degraded array. Reduce the number of devices in the degraded array.
> Initialized and add those devices to the new array. Wash. Rinse.
> Repeat. Eventually, I'd like all the drives in the external drive
> chassis to be the new, recovered array. I'd re-purpose the internal
> drives in the server for other uses.

OK but you can't mount normally anymore. It pretty much immediately
goes read-only either at mount time, or shortly thereafter (?).

So it's stuck. You can't modify this volume without risking all the
data on it, in my opinion.




>
> The potential problem is controlling what happens once I mount the
> degraded array in read/write mode to delete copied data and perform
> device reduction. I have no clue how to or even if this can be done
> safely.

Non-deterministic. First of all it's unclear whether it will delete
files without splatting to read only. Even if that works, it's far
from clear, and almost certainly true, that it will splat when you're
doing a device delete (and the ensuing shrink).

If this were a single chunk setup it might be possible. But device
delete on raid56 is not easy, it has to do a reshape. All chunks have
to be read in and then written back out.

So maybe what you do is copy off the most important 20TB you can,
because chances are that's all that you're going to get off this array
given the limitations you have set. Once that 20TB is  copied off, I
think it's not worth it to delete it. Because deleting on Btrfs is
COW, and thus you're actually writing. And writing all these deletions
is more change to the file system and what you want is less change.

The next step, I'd say is convert it to single/raid1.

# btrfs balance start -dconvert=single -mconvert=raid1 /mnt

And then hope to f'n god nothing dies. This is COW so in theory it
should not get worse. But... there is a better chance it gets worse,
than it chops off all the crusty stale bad parts in raid56, and leaves
you with clean single chunks. But once it's single, it's much, much
easier to delete that 20TB, and then start deleting individual
devices. Moving single chunks around is very efficient on Btrfs
compared to distributed chunks were literally every 1GiB chunk is on
22 drives. Now a 1Gib chunk is on exactly one drive. So it will be
easy to do exactly what you want. If the convert doesn't totally eat
shit and die, which it probably will.

So backup your 20TB, expecting that it will be the only 20TB you get
off this volume. So choose wisely.

And then convert to single chunks.



> The alternative is to continue to run this array in read only degraded
> mode until I can accumulate sufficient funds for a second chassis and
> approximately 20 more drives.This probably won't be until Jan 2018.


Yeah that can work. Read-only degraded might even survive another
drive failure, so why not? It's only a year. That'll go by fast.


>
> As I see it, the key here to to be able to safely delete copied files
> and to safely reduce the number of devices in the array.


The only safe option you have is read-only degraded until you have the
resources to make an independent copy. The more you change this
volume, the more likely it is irrecoverable and there will be data
loss.



-- 
Chris Murphy
