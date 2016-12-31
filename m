Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53000 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754554AbcLaEVq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Dec 2016 23:21:46 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cNBAf-0002N0-JF
        for linux-btrfs@vger.kernel.org; Sat, 31 Dec 2016 05:21:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can't add/replace a device on degraded filesystem
Date: Sat, 31 Dec 2016 04:21:20 +0000 (UTC)
Message-ID: <pan$93a95$88f43a29$cbe9ed47$1f230279@cox.net>
References: <86f5b7b9-b54e-8b80-26a9-6f13f3609a7b@richgannon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Gannon posted on Thu, 29 Dec 2016 19:27:30 -0500 as excerpted:

> Well I certainly got myself into a pickle.  Been a Btrfs user since 2008
> and this is the first time I've had a serious problem....and I got two
> on the same day (I'm separating them in a different emails).
> 
> I had 4x 4TB harddrives in a d=single m=raid1 array for about a year now
> containing many media files I really want to save.

It's a bit late now, but as I've posted previously, any admin worth the 
name knows that failing to have a backup is by that failure of action, in 
an actions speak louder than words way defining the un-backedup data as 
worth less than the time, trouble and resources necessary to do that 
backup.  And that's the normal case, with fully stable and mature 
filesystems.  Since btrfs is still under heavy development, not as 
unstable as it once was, but still very definitely in the process of 
stabilizing and maturing, that rule of backups is even stronger than it'd 
be otherwise -- if you don't have those backups, you're *seriously* 
defining the data as not worth that hassle.

So it's pretty simple.  Regardless of the outcome you can rest easy, 
because either you had a backup, and by having it defined that data as 
worth the bother to do that backup, or you don't have it, and by that 
failure, defined that data as not worth the trouble.  But because in 
either case you saved what was your actions defined as most important to 
you, either way, you can be happy that you couldn't and didn't lose the 
really important stuff, and can, worst-case, retrieve it from backup with 
a bit more time and energy spent in restoring that backup.  =:^)

That said, there remains a big difference between a theoretical/
calculated risk of loss, which you might have calculated to be worth that 
risk, and actually being faced with the it no longer being a relatively 
low chance theoretical risk, but potential reality you're now trying to 
avoid.  Lower value than insuring against a relatively low chance 
theoretical risk is one thing, lower value than time and hassle spent 
avoiding otherwise certain loss is something else entirely, and even 
given the truth of the above, once faced with that reality one can 
legitimately find it worth it to spend some time and hassle avoiding it, 
as the cost equations have now changed.

FWIW I've been there myself, even after knowingly taking that calculated 
risk and losing the bet I made with fate, only to find the cost equations 
now justify at least /some/ additional effort to get back, in my case, 
the time-delta difference between the backup I had that I had let get 
rather more stale than I arguably should have, and my previously working 
copy.

Luckily in my case I was able to recover most of that delta, and chances 
are very good that you can as well, particularly because you /can/ still 
mount read-only, and as you say, should still have at least one copy of 
that data safely available on the remaining devices.

> Yesterday I removed
> them from my desktop, installed them into a "new-to-me" Supermicro 2U
> server and even swapped over my HighPoint MegaRAID 2720 SAS HBA (yes,
> it's acting as a direct pass-thruHBA only).  With the added space, I
> also installed an additional 4TB drive to the filesystem and was
> performing a rebalance with filters:
> 
> btrfs balance start -dconvert=raid10 -mconvert=raid10 /mnt/bpool-btrfs
> 
> I found that the new drive dropped off-line during the rebalance.  I
> swapped the drive into a different bay to see if it was backplane,cord,
> or drive related.  Upon remount, the same drive dropped offline.  I had
> another new 4TB drive and swapped it in for the dead drive.
> 
> I can mount my filesystem with -o degraded, but I can not do btrfs
> replace or btrfs device add as the filesystem is in read-only mode, and
> I can not mount read-write.

Yes.  This is a known gotcha in the current btrfs implementation.  It 
remains rather easier than it should be to find oneself caught between a 
rock and a hard place, with a read-only filesystem that can't be repaired 
because that requires a writable mount, but without the ability to do a 
writable mount, at least with current mainline code, until you can do 
that repair.  The problem is mentioned, without a real explanation, on 
the wiki gotchas page (under raid1 volumes only mountable once RW if 
degraded, your problem's slightly different as it was an interrupted 
conversion, but the same root problem applies).

The problem is that while btrfs with current code is smart enough to know 
that single mode chunks only have one copy and thus you're likely in 
trouble if you are missing a device, and that a single missing device 
shouldn't be a big deal if everything's raid1 or raid10, what it doesn't 
understand is that just because there's some single-mode chunks on a 
partially raid1 or raid10 filesystem with one device missing, doesn't 
/necessarily/ mean that any of those single mode chunks actually happened 
to /be/ on that missing device, and thus missing!  It's entirely possible 
that all the single-mode chunks are on devices that are still available, 
along with at least one copy of all the raid1/10 stuff, so there's no 
chunks actually entirely missing at all, in which case the filesystem 
isn't in /immediate/ danger of further damage if mounted writable with 
that missing device, and thus it should be allowed, tho ideally an admin 
will ensure only being in that state long enough to do the actual repair.

In the raid1 case, btrfs raid1 knows it needs two devices to do raid1, 
and in the event of a degraded-writable mount with only a single device, 
will write any new chunks as single mode because it can't write raid1.  
That's why there's only one chance to fix it, because if you don't fix it 
during that one mount, the filesystem will see those single mode chunks 
on a filesystem with a missing device and will refuse to mount writable 
the next time, even tho by definition they couldn't have been created on 
the missing device, because its being missing is what triggered the 
single-mode chunk writing in the first place, thus triggering the rock 
and hard place scenario on next mount.

You're seeing the same problem now, single mode chunks on a filesystem 
with a device missing causing a failure to mount degraded-writable, but 
in your case, it was because the single mode chunks were already there, 
and the device went missing just as you were converting to redundant raid 
after adding a new device.  But because it /was/ the new device that went 
missing, nothing, or at least very little, should have been written to 
/it/ in single mode, as only the old chunks would be single mode, new 
ones would be redundant raid, raid10 in your case.

> From my understanding, my data should all be safe as during the
> balance, no single-copy files should have made it onto the new drive
> (that subsequently failed).  Is this a correct assumption?

Yes, altho there's a narrow chance of a few chunks being written to the 
new and now missing device in single mode, between the time the 
filesystem was mounted writable and the time you started the conversion.  
After you started the conversion, any new chunks /should/ have been 
written in the new raid10 mode.

But the good news is that only data chunks should be subject to that 
narrow window, as all your metadata is either raid1 (the multi-device 
default) or raid10.  So the potential damage should be pretty limited.

> Here is some btrfs data:
> proton bpool-btrfs # btrfs fi df /mnt/bpool-btrfs/
> Data, RAID10: total=2.17TiB, used=1.04TiB
> Data, single: total=7.79TiB, used=7.59TiB
> System, RAID1: total=32.00MiB, used=1.08MiB
> Metadata, RAID10: total=1.00GiB, used=1023.88MiB
> Metadata, RAID1: total=10.00GiB, used=8.24GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

> proton bpool-btrfs # btrfs fi sh /mnt/bpool-btrfs/
> Label: 'bigpool'  uuid: 85e8b0dd-fbbd-48a2-abc4-ccaefa5e8d18
>     Total devices 5 FS bytes used 8.64TiB
>     devid 5 size 3.64TiB used 2.77TiB path /dev/mapper/bpool-3
>     devid 6 size 3.64TiB used 2.77TiB path /dev/mapper/bpool-4
>     devid 7 size 3.64TiB used 2.77TiB path /dev/mapper/bpool-1
>     devid 8 size 3.64TiB used 2.77TiB path /dev/mapper/bpool-2
>     *** Some devices missing
> 
> 
> NOTE: The drives are all fully encrypted with LUKS/dm_crypt.
> 
> Please help me save the data :)
> 
> Rich

Interesting.  There's another rich that runs btrfs multi-device raid for 
his media files and occasionally posts to the list.  He's a gentoo dev 
and I happen to run gentoo, the context in which we normally interact, so 
it's interesting seeing him here, too.  But he normally goes by rich0, 
and AFAIK he isn't running btrfs on top of an encryption layer too, as 
you are...


OK, so there's two ways you can go to save things, here.  Your choice, as 
both will be a hassle, but they're different hassles.

1) The less technical throw money at it and brute force it method, is to 
simply take advantage of the fact that you can still mount read-only and 
should still have everything or nearly everything intact, file-wise, and 
throw together some additional storage to copy everything off to.  The 
good thing about this is that when you're done you'll have a backup, the 
current read-only filesystem for now, but when it comes time to update 
that backup, you can blow away the current filesystem and recreate it, 
using it as a backup after that.

The problem, of course, is that at the multi-TB sizes you're talking, 
it'll take at least 2-3 free devices, and that's going to be money, 
potentially even more than just the devices, if you don't have room to 
connect them all in your current setup, so have to to either setup a 
second machine or install additional multi-device cards if there's room 
for even that, in the current one.

Of course a second problem is that given the near double-digits TB size 
we're dealing with, doing /anything/ with that much data takes a decent 
amount of time, during which the devices dealing with the copy, repair, 
or whatever it is, are under significant stress and thus more likely to 
fail than normal, so there's a definite non-zero chance of something else 
failing before you get everything safely out of the danger zone and 
squared away.  Of course that's a risk that comes with the big-data 
territory; you just gotta deal with it if you're dealing with TB-scale 
data, but it /is/ worth mentioning one difference with btrfs raid10 as 
compared to more common raid10s, that you may not have factored in for 
the additional risk.

That being... btrfs raid10 is per-chunk, unlike standard raid10 which is 
per-device, and btrfs can and sometimes does switch around which devices 
get what part of the chunk.  IOW, the device that gets A1 may well get B4 
and D3 and C2, with the other pieces of the chunk stripe vs. mirror 
similarly distributed amongst the other devices.  In general the ultimate 
implication being that you can only lose a single device of the raid10.  
Once you lose a second device, chances are pretty high that the two 
devices will have both mirrors of /some/ of the chunk-strips, making the 
filesystem unrepairable, along with at least some of the data.

There's talk of exposing some way to configure the chunk allocator so it 
keeps the same mirror vs. strip of each chunk, consistently, and it 
should be possible and will very likely eventually happen, but it could 
be three months from now, or five-plus-years.  So don't plan on it being 
right away...

If you're fine with that and planned on only one device-loss safety 
anyway, great.  Otherwise...

2) Meanwhile, your second choice, the more technically skilled, less 
brute force, method.  As I said the problem is known, and there's 
actually a patch floating around to fix it.  But the patch, reasonably 
simple on its own, got tangled up in a rather more complex and longer 
term project, bringing hot-spare functionality to btrfs, and as such, it 
has remained out of tree because it's now to be submitted with that 
project, which is still cooking and isn't mature enough to be mainline-
merged just yet.

What the patch does is teach btrfs to actually check per-chunk whether it 
has at least one copy of the chunk data available, and allow writable 
mounts if so, thus eliminating the you-only-get-one-shot-at-a-fix 
problem, because later degraded mounts should see all the chunks are 
available and thus allow mounting writable, where current btrfs does not.

This more technically inclined method involves tracking down those 
patches and applying them to your own kernel/btrfs build, after which you 
should, with any decent luck, be able to mount the filesystem writable in 
ordered to continue the conversion and ultimately eliminate the trigger 
problem as all the single mode chunks are converted to raid10.

Of course besides this requiring a bit more technical skill, the other 
problem is that once the immediate issue is gone and you're all raid10, 
you still have only that single working copy, with mirrors, yes, but no 
real backup.  While the other way, you end up with a backup, and thus in 
a much safer place in terms of that data, than you apparently are now.

3) There's actually a third method too, involving using btrfs restore on 
the unmounted filesystem to retrieve the files and copy them elsewhere.  
However, this is really designed for when the filesystem can't be mounted 
read-only either.  Since you can mount it read-only and should be able to 
recover most or all files that way, you don't need to try to resort to 
this third method.  But it's nice to know it's there, if you do end up 
needing to use it, as I have a couple times, tho AFAIK not since before 
kernel 4.0, so it has been awhile.

Looking at the longer perspective, then, btrfs really does seem to be 
gradually stabilizing/maturing, as before it seemed that every year or 
so, something would happen and I'd need to think about actually using 
those backups, tho unlike some, I've always been lucky enough to be able 
to get fresher versions via restore, than I had in backup.  But I imagine 
the moment I begin actually counting on that, I'll have a problem that 
restore can't fix, so I really do consider those backups a measure of the 
value I place on the data, and would be stressed to a point, but only to 
a point, if I ended up losing any changes between my sometimes too stale 
backups, and my working copy.  But if I do I'll only have myself to 
blame, because after all, actions don't lie, and I obviously had things I 
considered more important than freshening those backups, so if I lose 
that delta, so be it, I still saved what I obviously thought was more 
important.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

