Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:32769 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdA0UER (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Jan 2017 15:04:17 -0500
Received: by mail-it0-f65.google.com with SMTP id e137so9405205itc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jan 2017 12:03:22 -0800 (PST)
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
To: Hans Deragon <hans@deragon.biz>, linux-btrfs@vger.kernel.org
References: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
 <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
 <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
Cc: Adam Borowski <kilobyte@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
Date: Fri, 27 Jan 2017 15:03:18 -0500
MIME-Version: 1.0
In-Reply-To: <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-27 11:47, Hans Deragon wrote:
> On 2017-01-24 14:48, Adam Borowski wrote:
>
>> On Tue, Jan 24, 2017 at 01:57:24PM -0500, Hans Deragon wrote:
>>
>>> If I remove 'ro' from the option, I cannot get the filesystem mounted
>>> because of the following error: BTRFS: missing devices(1) exceeds the
>>> limit(0), writeable mount is not allowed So I am stuck. I can only
>>> mount the filesystem as read-only, which prevents me to add a disk.
>>
>> A known problem: you get only one shot at fixing the filesystem, but
>> that's
>> not because of some damage but because the check whether the fs is in a
>> shape is good enough to mount is oversimplistic.
>>
>> Here's a patch, if you apply it and recompile, you'll be able to mount
>> degraded rw.
>>
>> Note that it removes a safety harness: here, the harness got tangled
>> up and
>> keeps you from recovering when it shouldn't, but it _has_ valid uses
>> that.
>>
>> Meow!
>
> Greetings,
>
> Ok, that solution will solve my problem in the short run, i.e. getting
> my raid1 up again.
>
> However, as a user, I am seeking for an easy, no maintenance raid
> solution.  I wish that if a drive fails, the btrfs filesystem still
> mounts rw and leaves the OS running, but warns the user of the failing
> disk and easily allow the addition of a new drive to reintroduce
> redundancy.  Are there any plans within the btrfs community to implement
> such a feature?  In a year from now, when the other drive will fail,
> will I hit again this problem, i.e. my OS failing to start, booting into
> a terminal, and cannot reintroduce a new drive without recompiling the
> kernel?
Before I make any suggestions regarding this, I should point out that 
mounting read-write when a device is missing is what caused this issue 
in the first place.  Doing so is extremely dangerous in any RAID setup, 
regardless of your software stack.  The filesystem is expected to store 
things reliably when a write succeeds, and if you've got a broken RAID 
array, claiming that you can store things reliably is generally a lie. 
MD and LVM both have things in place to mitigate most of the risk, but 
even there it's still risky.  Yes, it's not convenient to have to deal 
with a system that won't boot, but it's at least a whole lot easier from 
Linux than it is in most other operating systems.

Now, the first step to reliable BTRFS usage is using up-to-date kernels. 
  If you're actually serious about using BTRFS, you should be doing this 
anyway though.  Assuming you're keeping up-to-date on the kernel, then 
you won't hit this same problem again (or at least you shouldn't, since 
multiple people now have checks for this in their regression testing 
suites for BTRFS).

The second is proper monitoring.  A well set up monitoring system will 
let you know when the disk is failing before it gets to the point of 
just disappearing from the system most of the time.  There is currently 
no specific monitoring tool for BTRFS, but it's really easy to set up 
automated monitoring for stuff like this.  It's impractical for me to 
cover exact configuration here, since I don't know how much background 
you have dealing with stuff like this (and you're probably using systemd 
since it's Ubnutu, and I have near zero background dealing with 
recurring task scheduling with that).  I can however cover a list of 
what you should be monitoring and roughly how often:
1. SMART status from the storage devices.  You'll need smartmontools for 
this.  In general, I'd suggest using smartctl through cron or a systemd 
timer unit to monitor this instead of smartd.  Basic command-line that 
will work on all modern SATA disks to perform the checks you want is:
smartctl -H /dev/sda
You'll need one call for each disk, just replace /dev/sda with each 
device.  Note that this should be the device itself, not the partitions. 
  If that command spits out a warning (or returns with an exit code 
other than 0), something's wrong and you should at least investigate 
(and possibly look at replacing the disk).  I would suggest checking 
SMART status at least daily, and potentially much more frequently. 
When the self-checks in the disk firmware start failing (which is what 
this is checking), it generally means that failure is imminent, usually 
within a couple of days at most.
2. BTRFS scrub.  if you're serious about data safety, you should be 
running a scrub on the filesystem regularly.  As a general rule, once a 
week is reasonable unless you have marginal hardware or are seriously 
paranoid.  Make sure to check the results later with the 'btrfs scrub 
status' command.  It will tell you if it found any errors, and how many 
it was able to fix.  Isolated single errors are generally not a sign of 
imminent failure, it's when they start happening regularly or you see a 
whole lot at once that you're in trouble.  Scrub will also fix most 
synchronization issues between devices in a RAID set.
3. BTRFS device stats.  BTRFS stores per-device error counters in the 
filesystem.  These track cumulative errors since the last time they were 
reset, including errors encountered during normal operation.  You should 
be checking these regularly.  I"m a bit paranoid, so most of my systems 
check every hour.  Daily is usually sufficient for most people.  There 
are a couple of options for checking these.  The newest versions of 
btrfs-progs (which are not in Ubuntu yet) have a switch that will change 
the exit code if any counter is non-zero.  The other option 9which works 
regardless of btrfs-progs version) is to use a script to check the output.
4. Filesystem mount flags.  When BTRFS encounters a severe error (I'm 
not sure about the full list that will trigger this, except that it 
doesn't include read errors if they get corrected (which they should if 
you're using RAID)), it will remount the filesystem read-only.  This is 
a safety measure to prevent the kernel or the rest of the system from 
making any issues with the filesystem worse.  If you monitor the mount 
options for the filesystem to know when this happens (note that the 
response _SHOULD NOT_ be remounting the FS writable again, if the kernel 
remounted it read-only, something is seriously wrong).  A number of 
monitoring tools can actually automate checking this one for you (as 
well other stuff like disk usage), but it's pretty easy to find scripts 
that can do this on the internet because this is pretty standard 
behavior among a wide variety of Linux filesystems.
