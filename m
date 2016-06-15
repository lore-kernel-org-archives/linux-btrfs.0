Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40309 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473AbcFODTv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 23:19:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bD1Mi-0006G9-IJ
	for linux-btrfs@vger.kernel.org; Wed, 15 Jun 2016 05:19:41 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 05:19:40 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 05:19:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
Date: Wed, 15 Jun 2016 03:19:35 +0000 (UTC)
Message-ID: <pan$b3671$36ea03da$e28136e8$8de0280e@cox.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
	<38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net>
	<0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net>
	<e4c67cb3-b5f3-5dbb-1fb1-4d9a3b9a2f60@gmail.com>
	<E0C7FC1F-AEEE-4A79-9031-51FF616D027B@bueechi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

boli posted on Tue, 14 Jun 2016 21:28:57 +0200 as excerpted:

> So I was back to a 4-drive raid1, with 3x 6 TB drives and 1x 8 TB drive
> (though that 8 TB drive had very little data on it). Then I tried to
> "remove" (without "-r" this time) the 6 TB drive with the least amount
> of data on it (one had 4.0 TiB, where the other two had 5.45 TiB each).
> This failed after a few minutes because of "no space left on device".
> 
> Austin's mail reminded me to resize due to the larger disk, which I then
> did, but that device still couldn't be removed, same error message.
> I then consulted the wiki, which mentions that space for metadata might
> be rather full (11.91 used of 12.66 GiB total here), and to try a
> "balance" with a low "dusage" in such cases.
> 
> For now I avoided that by removing one of the other two (rather full) 6
> TB drives at random, and this has been going on for the last 20 hours or
> so. Thanks to running it in a screen I can check the progress this time
> around, and it's doing its thing at ~41 MiB/s, or ~7 hours per TiB, on
> average.

The ENOSPC errors are likely due to the fact that the raid1 allocator 
needs _two_ devices with free space.  If your 6T devices get too full, 
even if the 8T device is nearly empty, you'll run into ENOSPC, because 
you have just one device with unallocated space and the raid1 allocator 
needs two.

btrfs device usage should help diagnose this condition, with btrfs 
filesystem show also showing the individual device space allocation but 
not as much other information as usage will.

If you run into this, you may just have to do the hardware yank and 
replace-missing thing again, yanking a 6T and replacing with an 8T.  
Don't forget the resize.  That should leave you with two devices with 
free space and thus hopefully allow normal raid1 reallocation with a 
device remove again.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

