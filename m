Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42706 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753269AbcJNCsW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 22:48:22 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1busXX-0003gd-BW
        for linux-btrfs@vger.kernel.org; Fri, 14 Oct 2016 04:48:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unable to rescue RAID5
Date: Fri, 14 Oct 2016 02:47:53 +0000 (UTC)
Message-ID: <pan$b3ec1$5f43718$b476c91b$81bb21ae@cox.net>
References: <20161013102819.214E.13A92CCA@incoming.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hiroshi Honda posted on Thu, 13 Oct 2016 10:28:19 +0900 as excerpted:

> I am using Btrfs RAID5 with 10x4T disks.
> Around 2 weeks ago, one disk of it was taking long time when read and
> write.
> So, I tried replace the disk with new disk by replace command ( btrfs
> replace ... ).
> But, it failed. So, I added new disk into the array by add command and
> then deleted the bad disk by delete command.
> But, this deletion failed with error message as well. So, I deleted new
> disk from the array at the moment to return to first situation.
> But, system is showing some error message with number and the number is
> counting up.
> So, I rebooted the OS. Because, I felt this situation is something bad.
> After that, I can not mount the array...

Btrfs parity-raid currently has serious known issues that aren't likely 
to be corrected in the short term, as to some extent they're in the 
design.  The recommendation is thus not to use btrfs raid56 in 
production, and if you're already on it, to get off it ASAP, because 
while it runs fine in normal operation, failure and repair modes simply 
can't be guaranteed to work as one might expect at this point.

There's more about that on the list if you're interested, and others 
following raid56 mode more closely than I will likely reply with further 
specific details, as well, but that's the basic raid56 mode status and 
recommendation in practical terms.


As for rescuing files from the array, the proper answer is that btrfs as 
a whole is still stabilizing, not fully stable and mature, so the 
sysadmin's rule that if you don't have at least one backup, you are by 
definition of your failure to backup, defining the data as worth, at 
maximum, less than the time, hassle and resources necessary to take that 
backup, applies even more strongly to the not yet fully stable and mature 
btrfs, than it does to properly stable and mature filesystems.

And of course btrfs raid56 mode as a feature is newer and less stabilized 
than btrfs in general, so the rule that if you don't have a backup, you 
really are defining the data as of throw-away value, applies even more to 
anything on btrfs raid56.

So to rescue the data, restore it from backups to a preferably non-btrfs-
raid56 mode filesystem.  Or if you don't have backups, don't worry about 
it, because you effectively already defined the data as no more than 
throw-away value by not having those backups in the first place.

That's the proper answer.  In practice... all hope isn't yet lost.  
There's some chance to rescue your data, but it'll take time and 
patience, and likely a significant level of technical understanding along 
with some help from btrfs experts that know more about the btrfs raid56 
technical details than I do.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

