Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34893 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757AbcDHTYH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 15:24:07 -0400
Received: by mail-io0-f171.google.com with SMTP id g185so143424545ioa.2
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 12:24:07 -0700 (PDT)
Subject: Missing device handling (was: 'unable to mount btrfs pool...')
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
 <CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
 <57064231.2070201@gmail.com>
 <CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
 <5707961D.6000803@gmail.com>
 <CAJCQCtT1Pt__k+aYqSjNPLmcgpH7F4N+ueJ3b+z+aVTYTYtGEg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <57080530.7030805@gmail.com>
Date: Fri, 8 Apr 2016 15:23:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT1Pt__k+aYqSjNPLmcgpH7F4N+ueJ3b+z+aVTYTYtGEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-08 12:17, Chris Murphy wrote:
> On Fri, Apr 8, 2016 at 5:29 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>>
>> I entirely agree.  If the fix doesn't require any kind of decision to be
>> made other than whether to fix it or not, it should be trivially fixable
>> with the tools.  TBH though, this particular issue with devices disappearing
>> and reappearing could be fixed easier in the block layer (at least, there
>> are things that need to be fixed WRT it in the block layer).
>
> Right. The block layer needs a way to communicate device missing to
> Btrfs and Btrfs needs to have some tolerance for transience.

Being notified when a device disappears _shouldn't_ be that hard. A 
uevent gets sent already, and we should be able to associate some kind 
of callback with that happening for devices we have mounted. The bigger 
issue is going to be handling the devices _reappearing_ (if we still 
hold a reference to the device, it appears under a different 
name/major/minor, and if it's more than one device and we have no 
references, they may appear in a different order than they were 
originally), and there is where we really need to fix things. A device 
disappearing forever is bad and all, but a device losing connection and 
reconnecting completely ruining the FS is exponentially worse.

Overall, to provide true reliability here, we need:
1. Some way for userspace to disable writeback caching per-device (this 
is needed for other reasons as well, but those are orthogonal to this 
discussion). This then needs to be used on all removable devices by 
default (Windows and OS X do this, it's part of why small transfers 
appear to complete faster on Linux, and then the disk takes _forever_ to 
unmount). This would reduce the possibility of data loss when a device 
disappears.
2. A way for userspace to be notified (instead of having to poll) of 
state changes in BTRFS. Currently, the only ways for userspace to know 
something is wrong are either parsing dmesg or polling the filesystem 
flags (and based both personal experience, and statements I've seen here 
and elsewhere, polling the FS flags is not reliable for this). Most 
normal installations are going to want to trigger handlers for specific 
state changes (be it e-mail to an admin, or some other notification 
method, or even doing some kind of maintenance on the FS automatically), 
and we need some kind of notification if we want to give userspace the 
ability to properly manage things.
3. A way to tell that a device is gone _when it happens_, not when we 
try to write to it next, not when a write fails, but the moment the 
block layer knows it's not there, we need to know as well. This is a 
prerequisite for the next two items. Sadly, we're probably the only 
thing that would directly benefit from this (LVM uses uevents and 
monitoring daemons to handle this, we don't exactly have that luxury), 
which means it may be hard to get something like this merged.
4. Transparent handling of short, transient loss of a device. This goes 
together to a certain extent with 1, if something disappears for long 
enough that the kernel notices, but it reappears before we have any I/O 
to do on it again, we shouldn't lose our lunch unless userspace tells us 
to (because we told userspace that it's gone due to item 2). In theory, 
we should be able to cache a small number of internal pending writes for 
when it reappears (so for example, if a transaction is being committed, 
and the USB disk disappears for a second, we should be able to pick up 
where we left off (after verifying the last write we sent)). We should 
also have an automatic re-sync if it's a short enough period it's gone 
for. The max timeout here should probably be configurable, but probably 
could just be one tunable for the whole system.
5. Give userspace the option to handle degraded states how it wants to, 
and keep our default of remount RO when degraded when userspace doesn't 
want to handle it itself. This needs to be configured at run-time (not 
stored on the media), and it needs to be per-filesystem, otherwise we 
open up all kinds of other issues. This is a core concept in LVM and 
many other storage management systems; namely, userspace can choose to 
handle a degraded RAID array however the hell it wants, and we'll 
provide a couple of sane default handlers for the common cases.

I would personally suggest adding a per-filesystem node in sysfs to 
handle both 2 and 5. Having it open tells BTRFS to not automatically 
attempt countermeasures when degraded, select/epoll on it will return 
when state changes, reads will return (at minimum): what devices 
comprise the FS, per disk state (is it working, failed, missing, a 
hot-spare, etc), and what effective redundancy we have (how many devices 
we can lose and still be mountable, so 1 for raid1, raid10, and raid5, 2 
for raid6, and 0 for raid0/single/dup, possibly higher for n-way 
replication (n-1), n-order parity (n), or erasure coding). This would 
make it trivial to write a daemon to monitor the filesystem, react when 
something happens, and handle all the policy decisions.
