Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:58700 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaGGWbo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 18:31:44 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so5101065wes.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jul 2014 15:31:43 -0700 (PDT)
Message-ID: <53BB1FC7.9010307@gmail.com>
Date: Tue, 08 Jul 2014 01:31:35 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: mount time of multi-disk arrays
References: <53BAA2E5.2090801@lianse.eu> <53BAA67D.1050101@gmail.com> <pan$e34e1$34425a38$28d282d8$6ffde053@cox.net>
In-Reply-To: <pan$e34e1$34425a38$28d282d8$6ffde053@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/7/2014 6:48 μμ, Duncan wrote:
> Konstantinos Skarlatos posted on Mon, 07 Jul 2014 16:54:05 +0300 as
> excerpted:
>
>> On 7/7/2014 4:38 μμ, André-Sebastian Liebe wrote:
>>> can anyone tell me how much time is acceptable and assumable for a
>>> multi-disk btrfs array with classical hard disk drives to mount?
>>>
>>> I'm having a bit of trouble with my current systemd setup, because it
>>> couldn't mount my btrfs raid anymore after adding the 5th drive. With
>>> the 4 drive setup it failed to mount once in a few times. Now it fails
>>> everytime because the default timeout of 1m 30s is reached and mount is
>>> aborted.
>>> My last 10 manual mounts took between 1m57s and 2m12s to finish.
>> I have the exact same problem, and have to manually mount my large
>> multi-disk btrfs filesystems, so I would be interested in a solution as
>> well.
> I don't have a direct answer, as my btrfs devices are all SSD, but...
>
> a) Btrfs, like some other filesystems, is designed not to need a
> pre-mount (or pre-rw-mount) fsck, because it does what /should/ be a
> quick-scan at mount-time.  However, that isn't always as quick as it
> might be for a number of reasons:
>
> a1) Btrfs is still a relatively immature filesystem and certain
> operations are not yet optimized.  In particular, multi-device btrfs
> operations tend to still be using a first-working-implementation type of
> algorithm instead of a well optimized for parallel operation algorithm,
> and thus often serialize access to multiple devices where a more
> optimized algorithm would parallelize operations across multiple devices
> at the same time.  That will come, but it's not there yet.
>
> a2) Certain operations such as orphan cleanup ("orphans" are files that
> were deleted while they were in use and thus weren't fully deleted at the
> time; if they were still in use at unmount (remount-read-only), cleanup
> is done at mount-time) can delay mount as well.
>
> a3) Inode_cache mount option:  Don't use this unless you can explain
> exactly WHY you are using it, preferably backed up with benchmark
> numbers, etc.  It's useful only on 32-bit, generally high-file-activity
> server systems and has general-case problems, including long mount times
> and possible overflow issues that make it inappropriate for normal use.
> Unfortunately there's a lot of people out there using it that shouldn't
> be, and I even saw it listed on at least one distro (not mine!) wiki. =:^(
>
> a4) The space_cache mount option OTOH *IS* appropriate for normal use
> (and is in fact enabled by default these days), but particularly in
> improper shutdown cases can require rebuilding at mount time -- altho
> this should happen /after/ mount, the system will just be busy for some
> minutes, until the space-cache is rebuilt.  But the IO from a space_cache
> rebuild on one filesystem could slow down the mounting of filesystems
> that mount after it, as well as the boot-time launching of other post-
> mount launched services.
>
> If you're seeing the time go up dramatically with the addition of more
> filesystem devices, however, and you do /not/ have inode_cache active,
> I'd guess it's mainly the not-yet-optimized multi-device operations.
>
>
> b) As with any systemd launched unit, however, there's systemd
> configuration mechanisms for working around specific unit issues,
> including timeout issues.  Of course most systems continue to use fstab
> and let systemd auto-generate the mount units, and in fact that is
> recommended, but either with fstab or directly created mount units,
> there's a timeout configuration option that can be set.
>
> b1) The general systemd *.mount unit [Mount] section option appears to be
> TimeoutSec=.  As is usual with systemd times, the default is seconds, or
> pass the unit(s, like "5min 20s").
>
> b2) I don't see it /specifically/ stated, but with a bit of reading
> between the lines, the corresponding fstab option appears to be either
> x-systemd.timeoutsec= or x-systemd.TimeoutSec= (IOW I'm not sure of the
> case).  You may also want to try x-systemd.device-timeout=, which /is/
> specifically mentioned, altho that appears to be specifically the timeout
> for the device to appear, NOT for the filesystem to mount after it does.
>
> b3) See the systemd.mount (5) and systemd-fstab-generator (8) manpages
> for more, that being what the above is based on.
Thanks for your detailed answer. A mount unit with a larger timeout 
works fine, maybe we should tell distro maintainers to up the limit for 
btrfs to 5 minutes or so?

In my experience, mount time definitely grows as the filesystem grows 
older, and times out after snapshot count gets more than 500-1000 . I 
guess thats something that can be optimized in the future, but i believe 
stability is a much more urgent need now...

>
> So it might take a bit of experimentation to find the exact command, but
> based on the above anyway, it /should/ be pretty easy to tell systemd to
> wait a bit longer for that filesystem.
>
> When you find the right invocation, please reply with it here, as I'm
> sure there's others who will benefit as well.  FWIW, I'm still on
> reiserfs for my spinning rust (only btrfs on my ssds), but I expect I'll
> switch them to btrfs at some point, so I may well use the information
> myself.  =:^)
>


-- 
Konstantinos Skarlatos

