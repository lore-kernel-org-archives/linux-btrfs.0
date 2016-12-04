Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56955 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750804AbcLDSYV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 13:24:21 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cDbSQ-0005VF-6N
        for linux-btrfs@vger.kernel.org; Sun, 04 Dec 2016 19:24:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: system hangs due to qgroups
Date: Sun, 4 Dec 2016 18:24:08 +0000 (UTC)
Message-ID: <pan$69035$81ae24e2$d7110ac$22963947@cox.net>
References: <1776088.42rHLKPlSp@thetick> <4615776.dvopQOigxY@thetick>
        <CAJCQCtRUO1pByA3HXjbKRNVFmC9zcFvbLi22hAJS8VLafXnoew@mail.gmail.com>
        <3405186.JXS0fWUK5s@thetick>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Sun, 04 Dec 2016 17:02:48 +0100 as excerpted:

> That's a good idea, although I'll probably start with sysrescuecd (Linux
> 4.8.5 and btrfs-progs 4.7.3), as I already have experience with it.
> 
> [After trying it]
> 
> Well, crap, I was able to get images of the file system (one sanitized),
> but mounting always fails with "device or resource busy" (with no
> corresponding dmesg output).  (Also, that drive's partitions weren't
> discovered on bootup, I had to run partprobe first.)  I never see that
> in the initramfs, so I'm not sure what's causing that.

If I understand correctly what you're doing, that part is easily enough 
explained.

Remember that btrfs, unlike most filesystems, is multi-device capable.  
The way it tracks which devices belong to which filesystems is by UUID, 
universally *UNIQUE* ID.  If you image a device via dd or similar, you of 
course image its UUID as well, destroying the "unique" assumption in UUID 
and confusing btrfs, which will consider it part of the existing 
filesystem if the original devices with that filesystem UUID remain 
hooked up.

So if you did what I believe you did, try to mount the image while the 
original filesystem devices remain attached and mounted, btrfs is simply 
saying that filesystem (which btrfs identifies by UUID) is already 
mounted: "device or resource busy".

Furthermore, if the original filesystem remains mounted writable, you're 
at serious risk of (further) corruption, because btrfs now considers them 
part of the same filesystem and may write partial updates to the wrong 
one!

Bottom line, with btrfs, make sure your universally UNIQUE IDs remain 
what they say on the tin, UNIQUE.  When you do clones including the UUID, 
don't expose the new image files as devices to btrfs while the original 
filesystem remains mounted!  Because btrfs /depends/ on UUIDs actually 
being what they say on the tin, UNIQUE.

(And FWIW, this discussion has occurred before on the list.  The btrfs 
assumption of UUID uniqueness is apparently embedded deeply enough in 
btrfs code that it can't be practically removed.  The entire thing would 
have to be rewritten; we're talking man-years worth of work.  So it's not 
going to happen and if it did the result would no longer be btrfs.  It 
may be possible to make btrfs a bit safer in terms of refusing to mount 
and/or going read-only if new devices with the same UUIDs appear in 
ordered to avoid corruption, but the basic UUID uniqueness assumption 
itself is apparently buried deeply enough in btrfs that it's not going to 
be possible to change that.  Starting fresh with a new filesystem project 
would be easier.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

