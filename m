Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56548 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752069AbdEMJj7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 May 2017 05:39:59 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d9TWf-00018f-OW
        for linux-btrfs@vger.kernel.org; Sat, 13 May 2017 11:39:49 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs/SSD
Date: Sat, 13 May 2017 09:39:39 +0000 (UTC)
Message-ID: <pan$3384$13ad2b1f$3febf76a$c09fcbd7@cox.net>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
        <20170512202756.16bd785f@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Fri, 12 May 2017 20:27:56 +0200 as excerpted:

> In the end, the more continuous blocks of free space there are, the
> better the chance for proper wear leveling.

Talking about which...

When I was doing my ssd research the first time around, the going 
recommendation was to keep 20-33% of the total space on the ssd entirely 
unallocated, allowing it to use that space as an FTL erase-block 
management pool.

At the time, I added up all my "performance matters" data dirs and 
allowing for reasonable in-filesystem free-space, decided I could fit it 
in 64 GB if I had to, tho 80 GB would be a more comfortable fit, so 
allowing for the above entirely unpartitioned/unused slackspace 
recommendations, had a target of 120-128 GB, with a reasonable range 
depending on actual availability of 100-160 GB.

It turned out, due to pricing and availability, I ended up spending 
somewhat more and getting 256 GB (238.5 GiB).  Of course that allowed me 
much more flexibility than I had expected and I ended up with basically 
everything but the media partition on the ssds, PLUS I still left them at 
only just over 50% partitioned, (using the gdisk figures, 51%- 
partitioned, 49%+ free).

Given that, I've not enabled btrfs trim/discard (which saved me from the 
bugs with it a few kernel cycles ago), and while I do have a weekly fstrim 
systemd timer setup, I've not had to be too concerned about btrfs bugs 
(also now fixed, I believe) when fstrim on btrfs was known not to be 
trimming everything it really should have been.


Anyway, that 20-33% left entirely unallocated/unpartitioned 
recommendation still holds, right?  Am I correct in asserting that if one 
is following that, the FTL already has plenty of erase-blocks available 
for management and the discussion about filesystem level trim and free 
space management becomes much less urgent, tho of course it's still worth 
considering if it's convenient to do so?

And am I also correct in believing that while it's not really worth 
spending more to over-provision to the near 50% as I ended up doing, if 
things work out that way as they did with me because the difference in 
price between 30% overprovisioning and 50% overprovisioning ends up being 
trivial, there's really not much need to worry about active filesystem 
trim at all, because the FTL has effectively half the device left to play 
erase-block musical chairs with as it decides it needs to?


Of course the higher per-GiB cost of ssd as compared to spinning rust 
does mean that the above overprovisioning recommendation really does 
hurt, most of the time, driving per-usable-GB costs even higher, and as I 
recall that was definitely the case back then between 80 GiB and 160 GiB, 
and it was basically an accident of timing, that I was buying just as the 
manufactures flooded the market with newly cost-effective 256 GB devices, 
that meant they were only trivially more expensive than the 128 or 160 
GB, AND unlike the smaller devices, actually /available/ in the 500-ish 
MB/sec performance range that (for SATA-based SSDs) is actually capped by 
SATA-600 bus speeds more than the chips themselves.  (There were lower 
cost 128 GB devices, but they were lower speed than I wanted, too.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

