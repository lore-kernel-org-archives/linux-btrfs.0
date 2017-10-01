Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56630 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdJAJ5j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Oct 2017 05:57:39 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dyb04-0005WY-M1
        for linux-btrfs@vger.kernel.org; Sun, 01 Oct 2017 11:57:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Cannot remove device, no space left on device
Date: Sun, 1 Oct 2017 09:57:22 +0000 (UTC)
Message-ID: <pan$aaead$785b887d$ea0bcdb5$7a154f5c@cox.net>
References: <CACzgC9iBu13Ziiji134MDwxLcdCNqth-EJ=pSjfKpmzg22G_yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Bahe posted on Sun, 01 Oct 2017 02:48:19 -0500 as excerpted:

> Hello,

Hi, Just a user and list regular here, not a dev, but perhaps some of 
this will be of help.

> I have a hard drive that is about a year old with some pending sectors
> on it. I'd like to RMA this drive out of an abundance of caution. Doing
> so requires me removing it from my raid10 array. However I am unable to
> do so as it eventually errors out by saying there is no space left on
> the device. I have 21 drives in a raid10 array. Totalling about 100TB
> raw. I'm using around 28TB. So I should have plenty of space left.

Yes, and your btrfs * outputs below reflect plenty of space...

> I have done a number of balances with incremental increases in dusage
> and musage values from 5-100%. Each balance completed successfully. So
> it looks as though my filesystem is balanced fine. I'm on kernel 4.10

FWIW, this list, being btrfs development focused, with btrfs itself still 
stabilizing, not fully stable and mature, tends to focus forward rather 
than backward.  As such, our recommendation for best support is one of 
the latest two mainline kernel series in either current or LTS track.  
With the current kernel being 4.13, 4.13 and 4.12 are supported there.  
On the LTS track 4.9 is the latest, with the second latest.  4.14 is 
scheduled to be an LTS release as well, which is good because 4.4 was 
quite a long time ago in btrfs history and is getting hard to support.

Your 4.10 is a bit dated for current, and isn't an LTS, so the 
recommendation would be to try a newer 4.12 or 4.13, or drop a notch to 
4.9 LTS.

We do still try to support out of the above range, but it won't be as 
well, and similarly you're running a distro kernel, because we don't 
track what they've added or backported and what they haven't backported.  
Of course in the distro kernel case they're better placed to provide 
support as they know what they've backported, etc.

Meanwhile, as it happens there's a patch that should be in 4.14-rcs and 
will eventually be backported to the stable series tho I'm not sure it 
has been yet, that fixes an erroneous ENOSPC condition that triggers most 
frequently during balances.  There was something reserving (or attempting 
to reserve) waaayyy too much space in such large transactions, triggering 
the ENOSPCs.

Given your time constraints, I'd suggest trying first the latest 4.13.x 
stable series kernel and hope it has that patch (which I haven't tracked 
well enough to give you the summary of, or I would and you could check), 
and if it doesn't work, 4.14-rc3, which should be out late today (Sunday, 
US time), because your symptoms fit the description and it's very likely 
to be fixed in at least the latest 4.14-rcs.

Another less pressing note below...

> btrfs device usage:
> 
> /dev/sdc, ID: 19
> Device size:             9.10TiB
> Device slack:              0.00B
> Data,RAID10:           463.85GiB
> Data,RAID10:            61.43GiB
> Data,RAID10:           115.98GiB
> Data,RAID10:           118.31GiB
> Data,RAID10:            10.93GiB
> Data,RAID10:           776.75GiB
> Metadata,RAID10:         1.13GiB
> Metadata,RAID10:        99.00MiB
> Metadata,RAID10:       211.75MiB
> Metadata,RAID10:        59.09MiB
> System,RAID10:           2.16MiB
> Unallocated:             7.58TiB

[Other devices similar]

Those multiple entries for the same chunk type indicate chunks of 
differing stripe widths.  That won't hurt but you might want the better 
performance of a full stripe, and all those extra lines in the listing 
would bother me.

Once you get that device removed and are in normal operation again, you 
can, if desired, try balancing using the "stripes=" balance filter to try 
to get them all to full stripe width, at least until your space on the 
smallest drives is out and you have to drop to a lower stripe width.  
You'll need a reasonably new btrfs-progs to recognize the stripes= 
filter.  See the btrfs-balance manpage and/or previous threads here.  (On 
a quick look I didn't see it on the wiki yet, but it's possible I missed 
it.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

