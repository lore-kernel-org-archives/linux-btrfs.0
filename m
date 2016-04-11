Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35988 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbcDKLdU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 07:33:20 -0400
Received: by mail-qg0-f47.google.com with SMTP id f52so140984980qga.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 04:33:19 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id e127sm10986545qkb.34.2016.04.11.04.33.18
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 11 Apr 2016 04:33:18 -0700 (PDT)
Subject: Re: Missing device handling
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
 <CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
 <57064231.2070201@gmail.com>
 <CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
 <5707961D.6000803@gmail.com>
 <CAJCQCtT1Pt__k+aYqSjNPLmcgpH7F4N+ueJ3b+z+aVTYTYtGEg@mail.gmail.com>
 <57080530.7030805@gmail.com> <20160408195259.GA23661@jeknote.loshitsa1.net>
 <pan$b9ec0$9af87166$9880d70a$1ad778e5@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <570B8B4F.3070805@gmail.com>
Date: Mon, 11 Apr 2016 07:32:31 -0400
MIME-Version: 1.0
In-Reply-To: <pan$b9ec0$9af87166$9880d70a$1ad778e5@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-09 03:24, Duncan wrote:
> Yauhen Kharuzhy posted on Fri, 08 Apr 2016 22:53:00 +0300 as excerpted:
>
>> On Fri, Apr 08, 2016 at 03:23:28PM -0400, Austin S. Hemmelgarn wrote:
>>> On 2016-04-08 12:17, Chris Murphy wrote:
>>>
>>> I would personally suggest adding a per-filesystem node in sysfs to
>>> handle both 2 and 5. Having it open tells BTRFS to not automatically
>>> attempt countermeasures when degraded, select/epoll on it will return
>>> when state changes, reads will return (at minimum): what devices
>>> comprise the FS, per disk state (is it working, failed, missing, a
>>> hot-spare, etc), and what effective redundancy we have (how many
>>> devices we can lose and still be mountable, so 1 for raid1, raid10, and
>>> raid5, 2 for raid6, and 0 for raid0/single/dup, possibly higher for
>>> n-way replication (n-1), n-order parity (n), or erasure coding). This
>>> would make it trivial to write a daemon to monitor the filesystem,
>>> react when something happens, and handle all the policy decisions.
>>
>> Hm, good proposal. Personally I tried to use uevents for this but they
>> cause locking troubles, and I didn't continue this attempt.
>
> Except that... in sysfs (unlike proc) there's a rather strictly enforced
> rule of one property per file.
Good point, I had forgotten about this.
>
> So you could NOT hold a single sysfs file open, that upon read would
> return 1) what devices comprise the FS, 2) per device (um, disk in the
> original, except that it can be a non-disk device, so changed to device
> here) state, 3) effective number of can-be-lost devices.
>
> The sysfs style interface would be a filesystem directory containing a
> devices subdir, with (read-only?) per-device state-files in that subdir.
> The listing of per-device state-files would thus provide #1, with the
> contents of each state-file being the status of that device, therefore
> providing #2.  Back in the main filesystem dir, there'd be a devices-
> loseable file, which would provide #3.
>
> There could also be a filesystem-level state file which could be read for
> the current state of the filesystem as a whole or selected/epolled for
> state-changes, and probably yet another file, we'll call it leave-be here
> simply because I don't have a better name, that would be read/write
> allowing reading or setting the no-countermeasures property.
I actually rather like this suggestion, with the caveat that we ideally 
should have multiple options for the auto-recovery mode:
1. Full auto-recovery, go read-only when an error is detected.
2. Go read-only when an error is detected but don't do auto-recovery 
(probably not very useful).
3. Do auto-recovery, but don't go read-only when an error is detected.
4. Don't do auto-recovery, and don't go read-only when an error is detected.
5-8. Same as the above, but require that the process that set the state 
keep the file open to maintain it (useful for cases when we need some 
kind of recovery if at all possible, but would prefer the monitoring 
tool to do it if possible).

In theory, we could do it as a bit-field to control what gets recovered 
and what doesn't.
>
>
> Actually, after looking at the existing /sys/fs/btrfs layout, we already
> have filesystem directories, each with a devices subdir, tho the symlinks
> therein point to the /sys/devices tree device dirs.  The listing thereof
> already provides #1, at least for operational devices.
>
> I'm not going to go testing what happens to the current sysfs devices
> listings when a device goes missing, but we already know btrfs doesn't
> dynamically use that information.  Presumably, once it does, the symlinks
> could be replaced with subdirs for missing devices, with the still known
> information in the subdir (which could then be named as either the btrfs
> device ID or as missing-N), and the status of the device being detectable
> by whether it's a symlink to a devices tree device (device online) or a
> subdir (device offline).
IIRC, under the current implementation, the symlink stays around as long 
as the device node in /dev stays around (so usually until the filesystem 
gets unmounted).

That said, there are issues inherent in trying to do something like 
replacing a symlink with a directory in sysfs, especially if the new 
directory contains a different layout than the one the symlink was 
pointing at:
1. You horribly break compatibility with existing tools.
2. You break the expectations of stability that are supposed to be 
guaranteed by sysfs for a given mount of it.
3. Sysfs isn't designed in a way that this could be done atomically, 
which severely limits usability (because the node might not be there, or 
it might be an empty directory).
This means we would need a separate directory to report device state.
>
> The per-filesystem devices-losable, fs-status, and leave-be files could
> be added to the existing syfs btrfs interface.
>
