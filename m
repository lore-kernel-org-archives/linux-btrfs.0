Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47683 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbcEQG1b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 02:27:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b2YTU-0001yC-29
	for linux-btrfs@vger.kernel.org; Tue, 17 May 2016 08:27:24 +0200
Received: from 145.132.48.198 ([145.132.48.198])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 08:27:24 +0200
Received: from ftoth by 145.132.48.198 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 08:27:24 +0200
To: linux-btrfs@vger.kernel.org
From: Ferry Toth <ftoth@exalondelft.nl>
Subject: Re: Hot data tracking / hybrid storage
Date: Tue, 17 May 2016 06:27:14 +0000 (UTC)
Message-ID: <nhedk2$dpq$1@ger.gmane.org>
References: <nh9p2p$cns$1@ger.gmane.org>
	<pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
	<20160516010524.7e208f96@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Op Mon, 16 May 2016 01:05:24 +0200, schreef Kai Krakow:

> Am Sun, 15 May 2016 21:11:11 +0000 (UTC)
> schrieb Duncan <1i5t5.duncan@cox.net>:
> 
>> Ferry Toth posted on Sun, 15 May 2016 12:12:09 +0000 as excerpted:
>> 
<snip>
> 
> You can go there with only one additional HDD as temporary storage. Just
> connect it, format as bcache, then do a "btrfs dev replace". Now wipe
> that "free" HDD (use wipefs), format as bcache, then... well, you get
> the point. At the last step, remove the remaining HDD. Now add your
> SSDs, format as caching device, and attach each individual HDD backing
> bcache to each SSD caching bcache.
> 
> Devices don't need to be formatted and created at the same time. I'd
> also recommend to add all SSDs only in the last step to not wear them
> early with writes during device replacement.
> 
> If you want, you can add one additional step to get the temporary hard
> disk back. But why not simply replace the oldest hard disk with the
> newest. Take a look at smartctl to see which is the best candidate.
> 
> I went a similar route but without one extra HDD. I had three HDDs in
> mraid1/draid0 and enough spare space. I just removed one HDD, prepared
> it for bcache, then added it back and removed the next.
> 
That's what I mean, a lot of work. And it's still a cache, with 
unnecessary copying from the ssd to the hdd.

And what happens when either a hdd or ssd starts failing?

> --
> Regards,
> Kai
> 
> Replies to list-only preferred.


