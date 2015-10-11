Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38726 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbbJKL2o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 07:28:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZlEny-0005uQ-Ep
	for linux-btrfs@vger.kernel.org; Sun, 11 Oct 2015 13:28:42 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 13:28:42 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 13:28:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: kernel BUG at /linux/fs/btrfs/extent-tree.c:1833!
Date: Sun, 11 Oct 2015 11:28:36 +0000 (UTC)
Message-ID: <pan$79537$59fa2bae$d82578cd$79406a63@cox.net>
References: <CAEtw4r3r-E1deboGDCfNkUL-ZKUdn4+B++oeu9M4H_7hHDj0TA@mail.gmail.com>
	<BLU436-SMTP5651E81A1B27D60895E652A9340@phx.gbl>
	<CAEtw4r3Qg-5cian-GjAuCmjaTnzea0OrHgxZO_VM1OwjoF2oxQ@mail.gmail.com>
	<CAEtw4r2HMrJciX4tgC9d9qSVucCJng-tyJxWPFX7h-5oqePV_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Peter Becker posted on Sat, 10 Oct 2015 21:48:31 +0200 as excerpted:

> btrfs balance start -m /media/RAID
> 
> complete with out any error but the resulte of device usage is confusing
> me.
> Metadata on sdb and sdc are 2 GiB, but on sdd (the new added device)
> is 4 GiB. And the 2. one that's confusing me, is that sdd has a "System"
> entry but sdb and sdc dosn't
> 
> floyd@nas ~ $ sudo btrfs dev us /media/RAID/
> /dev/sdb, ID: 1
>    Device size:             2.73TiB
>    Data,RAID1:              2.11TiB
>    Metadata,RAID1:          2.00GiB
>    System,RAID1:           32.00MiB
>    Unallocated:           628.49GiB
> 
> /dev/sdc, ID: 2
>    Device size:             2.73TiB
>    Data,RAID1:              2.11TiB
>    Metadata,RAID1:          2.00GiB
>    Unallocated:           628.52GiB
> 
> /dev/sdd, ID: 3
>    Device size:             2.73TiB
>    Data,RAID1:            792.00GiB
>    Metadata,RAID1:          4.00GiB
>    System,RAID1:           32.00MiB
>    Unallocated:             1.95TiB

FWIW, there's also btrfs fi usage, which prints a somewhat different 
layout of pretty much the same statistics.  It may be useful to compare 
output styles and choose the one you prefer.  I prefer fi usage to dev 
usage in most cases, but YMMV.

The key thing to remember about btrfs raid1 on more than two devices is 
that it's exactly two copies, not N copies, where N is the number of 
devices.  In a three-device raid1, by definition, for each chunk that 
will mean one copy each on two devices, with the third device not getting 
a copy of that particular chunk, since btrfs raid1 is exactly two copies, 
no more, no less.

So system is raid1, and sdb and sdd each have a copy of the (apparently 
just one) system chunk, one copy each for two copies total, leaving no 
system chunk to be placed on sdc, which is why it has none.

And, given the stats, there are 4 GiB of raid1 metadata chunks comprising 
two copies of 2 GiB worth of metadata.  Half that metadata has a copy 
each on sdb and sdd, while the other half has a copy each on sdc and sdd.  
IOW, sdd has a copy of all metadata, but sdb and sdc only have a copy of 
half the metadata each.

Since the chunk allocator creates new chunks on the device with the most 
available space, subject to the restriction that for raid1, there's two 
copies and both copies cannot be on the same device, because sdd was 
recently added and thus the one most empty, when you ran the metadata 
balance, it created one copy of the raid1 two copies on the new device as 
it had the most free space, and then had to select one of the other two 
devices for the other copy.  Since the other two devices were basically 
evenly filled, it alternated, selecting one and then the other, so each 
one got the second copy of half of the metadata, while the new device 
with the most free space got the first copy of all metadata as it was 
rewritten by the balance.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

