Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40403 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbcAAINO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jan 2016 03:13:14 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aEupk-0008LK-9V
	for linux-btrfs@vger.kernel.org; Fri, 01 Jan 2016 09:13:12 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 09:13:12 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 09:13:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unrecoverable fs corruption?
Date: Fri, 1 Jan 2016 08:13:07 +0000 (UTC)
Message-ID: <pan$775e4$fad1d9d7$a69e525a$ff4dac1a@cox.net>
References: <4bfedb90694d34a9a311d532715560d1@mail.mended-drum.net>
	<CAJCQCtSDpGnXpFpHxO9eyb7pLWKQis6+yOBznFkJO85e0NLyyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 31 Dec 2015 18:22:09 -0700 as excerpted:

> On Thu, Dec 31, 2015 at 4:36 PM, Alexander Duscheleit
> <alexander.duscheleit@gmail.com> wrote:
>> Hello,
>>
>> I had a power fail today at my home server and after the reboot the
>> btrfs RAID1 won't come back up.
>>
>> When trying to mount one of the 2 disks of the array I get the
>> following error:
>> [ 4126.316396] BTRFS info (device sdb2): disk space caching is enabled
>> [ 4126.316402] BTRFS: has skinny extents [ 4126.337324] BTRFS: failed
>> to read chunk tree on sdb2 [ 4126.353027] BTRFS: open_ctree failed
> 
> 
> Why are you trying to mount only one? What mount options did you use
> when you did this?

Yes, please.

>> btrfs restore -viD seems to find most of the files accessible but since
>> I don't have a spare hdd of sufficient size I would have to break the
>> array and reformat and use one of the disk as restore target. I'm not
>> prepared to do this before I know there is no other way to fix the
>> drives since I'm essentially destroying one more chance at saving the
>> data.

> Anyway, in the meantime, my advice is do not mount either device rw
> (together or separately). The less changes you make right now the
> better.
> 
> What kernel and btrfs-progs version are you using?

Unless you've already tried it (hard to say without the mount options you 
used above), I'd first try a different tact than C Murphy suggests, 
falling back to what he suggests if it doesn't work.  I suppose he 
assumes you've already tried this...

But first things first, as C Murphy suggests, when you post problems like 
this, *PLEASE* post kernel and progs userspace versions.  Given the rate 
at which btrfs is still changing, that's pretty critical information.  
Also, if you're not running the latest or second latest kernel or LTS 
kernel series and a similar or newer userspace, be prepared to be asked 
to try a newer version.  With the almost released 4.4 set to be an LTS, 
that means it if you want to try it, or the LTS kernel series 4.1 and 
3.18, or the current or previous current kernel series 4.3 or 4.2 (tho 
with 4.2 not being an LTS updates are ended or close to it, so people on 
it should be either upgrading to 4.3 or downgrading to 4.1 LTS anyway).  
And for userspace, a good rule of thumb is whatever the kernel series, a 
corresponding or newer userspace as well.

With that covered...

This is a good place to bring in something else CM recommended, but in a 
slightly different context.  If you've read many of my previous posts 
you're likely to know what I'm about to say.  The admin's first rule of 
backups says, in simplest form[1], that if you don't have a backup, by 
your actions you're defining the data that would be backed up as not 
worth the hassle and resources to do that backup.  If in that case you 
lose the data, be happy, as you still saved what you defined by your 
actions as of /true/ value regardless of any claims to the contrary, the 
hassle and resourced you would have spent making that backup.  =:^)

While the rule of backups applies in general, for btrfs it applies even 
more, because btrfs is still under heavy development and while btrfs is 
"stabilizING, it's not yet fully stable and mature, so the risk of 
actually needing to use that backup remains correspondingly higher than 
it'd ordinarily be.

But, you didn't mention having backups, and did mention that you didn't 
have a spare hdd so would have to break the array to have a place to do a 
btrfs restore to, which reads very much like you don't have ANY BACKUPS 
AT ALL!!

Of course, in the context of the above backups rule, I guess you 
understand the implications, that you consider the value of that data 
essentially throw-away, particularly since you still don't have a backup, 
despite running a not entirely stable filesystem that puts the data at 
greater risk than would a fully stable filesystem.

Which means no big deal.  You've obviously saved the time, hassle and 
resources necessary to make that backup, which is obviously of more value 
to you than the data that's not backed up, so the data is obviously of 
low enough value you can simply blow away the filesystem with a fresh 
mkfs and start over. =:^)

Except... were that the case, you probably wouldn't be posting.

Which brings entirely new urgency to what CM said about getting that 
spare hdd, so you can actually create that backup, and count yourself 
very lucky if you don't lose your data before you have it backed up, 
since your previous actions were unfortunately not in accordance with the 
value you seem to be claiming for the data.

OK, the rest of this post is written with the assumption that your claims 
and your actions regarding the value of the data in question, agree, and 
that since you're still trying to recover the data, you don't consider it 
just throw-away, which means you now have someplace to put that backup, 
should you actually be lucky enough to get the chance to make it...


With your try to mount, did you try the degraded mount option?  That's 
primarily what this post is about as it's not clear you did, and what I'd 
try first, as without that, btrfs will normally refuse to mount if a 
device is missing, failing with the rather generic ctree open failure 
error, as your attempt did.

And as CM suggests, trying the degraded,ro mount options together is a 
wise idea, at least at first, in ordered to help prevent further damage.

If a degraded,ro mount fails, then it's time to try CM's suggestions.

If a degraded,ro mount succeeds, then do a btrfs device scan, and a btrfs 
filesystem show, and see if it shows both devices or just one.  If you 
like you can also try a read-only scrub (a scrub without read-only will 
fail if the filesystem is read-only), to see if there's any corruption.

If after a device scan, a show still shows just one device, then the 
other device is truly damaged and your best bet is to try to recover from 
just the one device, see below.  If it shows both devices, then (after 
taking the opportunity while read-only mounted to do that backup to the 
other device we're assuming you now have) try unmounting and mounting 
again, normally.  With luck it'll work and the initial mount failure was 
due to btrfs only seeing the one device as btrfs device scan hadn't been 
run to let it know of the other one yet.  With the now normally mounted 
filesystem, I'd strongly suggest a btrfs scrub as first order of 
business, to try to get the two devices back in sync after the crash.

If on the degraded,ro mount, a btrfs device scan followed by btrfs fi 
show, shows the filesystem still with only one device, the other device 
would appear to be dead as far as btrfs is concerned.  In this case, 
you'll need to recover from the degraded-mount working device as if the 
second one had entirely failed.

What I'd do in this case, if you haven't done so already, is that read-
only btrfs scrub, just to see where you are in terms of corruption on the 
remaining device.  If it comes out clean, you will likely be able to 
recover with little if any data loss.  If not, hopefully you can still 
recover most of it.

At this point, now that we're assuming that you have another device to 
make a backup to, if you haven't already, take the opportunity to do that 
backup to the other device.  Be sure to unmount and remount that other 
device after the backup and test to be sure what's there is usable, 
because sysadmin's backups rule #2 is that a would-be backup that hasn't 
been tested isn't yet a backup, for the purposes of rule #1, because a 
backup isn't completed until it has been tested.

With the backup safely done and tested, you can now afford to attempt a 
bit riskier stuff on the existing btrfs.

Even tho btrfs isn't recognizing that second device, let's be sure it 
doesn't suddenly decide to be recognized, complicating things.  Either 
wipe the filesystem (dd if=/dev/zero, of=<unrecognized former btrfs 
device, or better yet, run badblocks on it in destructive mode, to both 
wipe and test it at the same time), or if you're impatient, at least use 
wipefs on it, to wipe the superblock.  Alternatively, do a temporary 
mkfs.btrfs on it, just to wipe the existing superblocks.

Now you can treat that device as a fresh device and replace the missing 
device on the degraded btrfs.

First you need to remount the degraded filesystem rw, because you can't 
add/delete/replace devices on a read-only mounted filesystem.

How you do the replace depends on the kernel and userspace you're 
running, and newer versions make it far easier.

With a reasonably current btrfs setup, you can use btrfs replace start, 
feeding it the ID number of the missing device and the device node (/dev/
whatever) of the replacement device, plus the mountpoint path.  See the 
btrfs-replace manpage.

But the ID parameter wasn't added until relatively recently.  If you 
aren't running a recent enough btrfs, you can try missing in place of the 
missing device, but with some versions that didn't work either.

Older btrfs versions didn't have btrfs replace.  If you're running 
something that old, you really should upgrade, but meanwhile, will have 
to use separate btrfs device add, followed by btrfs device delete (or 
remove, older versions only had delete, which remains an alias to remove 
in newer versions).  The add should be fast.  The delete will take quite 
a long time as it'll do a rebalance in the process.

Meanwhile, on some older versions, you often effectively got only one 
chance at the replace after mounting the filesystem writable, as if you 
rebooted (or had a crash) with the filesystem still degraded, a bug would 
often prevent mounting degraded,rw again, only degraded,ro, and of course 
the replace couldn't continue or a new attempt made, while the filesystem 
was mounted ro.  In that case, the only option (if you didn't already 
have a current backup) was to use the read-only mount as a backup and 
copy the files elsewhere, because the existing filesystem was stuck in 
read-only mode.

So keeping relatively current really does have its advantages. =:^)


Finally, repeating what I said above, this assumes you didn't try 
mounting with the degraded option, with or without ro, and that it works 
when you do, giving you a chance to at least copy the data off the read-
only filesystem.  If it doesn't, as CM evidently assumed, and if you 
don't have backups, then you have to fall back to CM's suggestions.

---
[1] Sysadmin's first rule of backups:  The more complex form covers 
multiple backups and accounts for the risk factor of actually needing to 
use them.  It says that for any level of backup, either you have it, or 
you consider the value of the data multiplied by the risk factor of 
having to actually use that level of backup, to be less than the resource 
and hassle cost of making that backup.  In this form, data such as your 
internet cache is probably not worth enough to justify even a single 
level of backup, while truly valuable data might be worth 101 levels of 
backup or more, some of them offsite and others onsite but not normally 
physically connected, because the data is truly valuable enough that even 
multiplied by the extremely tiny chance of actually having 100 levels of 
backup fail and actually needing that 101st level, justifies having it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

