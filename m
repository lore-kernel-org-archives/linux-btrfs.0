Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40326 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbcDDTgs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 15:36:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anAIn-0007Kp-Qe
	for linux-btrfs@vger.kernel.org; Mon, 04 Apr 2016 21:36:45 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 21:36:45 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 21:36:45 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Mon, 4 Apr 2016 21:36:37 +0200
Message-ID: <20160404213637.58ad33b1@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
	<pan$2593b$f74bb320$4b6df891$663eb0b@cox.net>
	<20160404001925.2abc2649@jupiter.sol.kaishome.de>
	<CAJCQCtTjoQ93wiMRgzHJ+3D_GPwygK1EzGPCFyKdoi1=Mjip_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 3 Apr 2016 18:51:07 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

> > BTW: Is it possible to use my backup drive (it's btrfs single-data
> > dup-metadata, single device) as a seed device for my newly created
> > btrfs pool (raid0-data, raid1-metadata, three devices)?  
> 
> Yes.
> 
> I just tried doing the conversion to raid1 before and after seed
> removal, but with the small amount of data (4GiB) I can't tell a
> difference. It seems like -dconvert=raid with seed still connected
> makes two rw copies (i.e. there's a ro copy which is the original, and
> then two rw copies on 2 of the 3 devices I added all at the same time
> to the seed), and the 'btrfs dev remove' command to remove the seed
> happened immediately, suggested the prior balances had already
> migrated copies off the seed. This may or may not be optimal for your
> case.
> 
> Two gotchas.
> 
> I ran into this bug:
> btrfs fi usage crash when volume contains seed device
> https://bugzilla.kernel.org/show_bug.cgi?id=115851
> 
> And there is a phantom single chunk on one of the new rw devices that
> was added. Data,single: Size:1.00GiB, Used:0.00B
>    /dev/dm-8       1.00GiB
> 
> It's still there after the -dconvert=raid1 and separate -mconvert=raid
> and after seed device removal. A balance start without filters removes
> it, chances are had I used -dconvert=raid1,soft it would have vanished
> also but I didn't retest for that.

Good to know, thanks.

> > I guess the
> > seed source cannot be mounted or modified...  
> 
> ?

In the following sense: I should disable the automounter and backup job
for the seed device while I let my data migrate back to main storage in
the background...

My intention is to use fully my system while btrfs migrates the data
from seed to main storage. Then, afterwards I'd like to continue using
the seed device for backups.

I'd probably do the following:

1. create btrfs pool, attach seed
2. recreate my original subvolume structure by snapshotting the backup
   scratch area multiple times into each subvolume
3. rearrange the files in each subvolume to match their intended use by
   using rm and mv
4. reboot into full system
4. remove all left-over snapshots from the seed
5. remove (detach) the seed device
6. rebalance
7. switch bcache to write-back mode (or attach bcache only now)


-- 
Regards,
Kai

Replies to list-only preferred.

