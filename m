Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53757 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753170AbcIPC6m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 22:58:42 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bkjMJ-0001IV-JW
        for linux-btrfs@vger.kernel.org; Fri, 16 Sep 2016 04:58:35 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Thoughts on btrfs RAID-1 for cold storage/archive?
Date: Fri, 16 Sep 2016 02:58:24 +0000 (UTC)
Message-ID: <pan$2e9b3$e0d80028$f8a083d5$b81c2a7b@cox.net>
References: <CAJtFHUQOW4RBZcOu0FWe7dVoxTJWD9bMjvaXYLkXy_Pw7meC-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

E V posted on Thu, 15 Sep 2016 11:48:13 -0400 as excerpted:

> I'm investigating using btrfs for archiving old data and offsite
> storage, essentially put 2 drives in btrfs RAID-1, copy the data to the
> filesystem and then unmount, remove a drive and take it to an offsite
> location. Remount the other drive -o ro,degraded until my systems slots
> fill up, then remove the local drive and put it on a shelf. I'd verify
> the file md5sums after data is written to the drive for piece of mind,
> but maybe a btrfs scrub would give the same assurances. Seem
> straightforward? Anything to look out for? Long term format stability
> seems good, right? Also, I like the idea of being able to pull the
> offsite drive back and scrub if the local drive ever has problems, a
> nice extra piece of mind we wouldn't get with ext4. Currently using the
> 4.1.32 kernel since the driver for the r750 card in our 45 drives system
> only supports up to 4.3 ATM.

As described I believe it should work fine.

Btrfs raid1 isn't like normal raid1 in some ways and in particular isn't 
designed to be mounted degraded, writable, long term, only temporarily, 
in ordered to replace a bad device.  As that's what I thought you were 
going to propose when I read the subject line, I was all ready to tell 
you no, don't try it and expect it to work, but of course you had 
something different in mind, only read-only mounting of the degraded 
raid1 (unless needed for scrub, etc), not mounting it writable, and as 
long as you are careful to do just that, only mount it read-only, you 
should be fine.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

