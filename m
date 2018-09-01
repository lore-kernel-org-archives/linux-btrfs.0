Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57799 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbeIAFrk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2018 01:47:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fvuom-0000wD-56
        for linux-btrfs@vger.kernel.org; Sat, 01 Sep 2018 03:35:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: IO errors when building RAID1.... ?
Date: Sat, 1 Sep 2018 01:35:08 +0000 (UTC)
Message-ID: <pan$58387$bfb9f3ff$f3e86426$5829b7c2@cox.net>
References: <83a74213-e66c-238c-43e4-8333c678e588@couderc.eu>
        <CAJCQCtQso9Lvw-33DmLDuOxnMcsRPzq6Ya9oo_n2_LvsvFVYqA@mail.gmail.com>
        <CAJCQCtTPieXg=8T_s78f2eQCHGknQ1+gQxCLqXr0CgEC6ub_9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 31 Aug 2018 13:02:16 -0600 as excerpted:

> If you want you can post the output from 'sudo smartctl -x /dev/sda'
> which will contain more information... but this is in some sense
> superfluous. The problem is very clearly a bad drive, the drive
> explicitly report to libata a write error, and included the sector LBA
> affected, and only the drive firmware would know that. It's not likely a
> cable problem or something like. And that the write error is reported at
> all means it's persistent, not transient.

Two points:

1) Does this happen to be an archive/SMR (shingled magnetic recording) 
device?  If so that might be the problem as such devices really aren't 
suited to normal usage (they really are designed for archiving), and 
btrfs' COW patterns can exacerbate the issue.  It's quite possible that 
the original install didn't load up the IO as heavily as the balance-
convert does, so the problem appears with convert but not for install.

2) Assuming it's /not/ an SMR issue, and smartctl doesn't say it's dying, 
I'd suggest running badblocks -w (make sure the device doesn't have 
anything valuable on it!) on the device -- note that this will take 
awhile, probably a couple days perhaps longer, as it writes four 
different patterns to the entire device one at a time, reading everything 
back to verify the pattern was written correctly, so it's actually going 
over the entire device 8 times, alternating write and read, but it should 
settle the issue of the reliability of the device.

Or if you'd rather spend the money than the time and it's not under 
warrantee still, just replace it, or at least buy a new one to use while 
you run the tests on that one.  I fully understand that tying up the 
thing running tests on it for days straight may not be viable.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
