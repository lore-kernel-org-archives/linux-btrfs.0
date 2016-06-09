Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxout014.mail.hostpoint.ch ([217.26.49.174]:42467 "EHLO
	mxout014.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932077AbcFIRaX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 13:30:23 -0400
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
	by mxout014.mail.hostpoint.ch with esmtp (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bB3me-000O8k-IT
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 19:30:20 +0200
Received: from nat13.ergon.ch ([87.239.215.13] helo=mac.ergon.ch)
	by asmtp013.mail.hostpoint.ch with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bB3me-000D4F-GQ
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 19:30:20 +0200
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
From: bOli <btrfs@bueechi.net>
In-Reply-To: <pan$6ab4$792ded48$cf23daab$a8e4c2@cox.net>
Date: Thu, 9 Jun 2016 19:30:21 +0200
Message-Id: <B68C4D89-4EF9-4312-9952-EC48D287CF58@bueechi.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net> <pan$6ab4$792ded48$cf23daab$a8e4c2@cox.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09.06.2016, at 17:20, Duncan <1i5t5.duncan@cox.net> wrote:

> Are those the 8 TB SMR "archive" drives?

No, they are Western Digital Red drives.

Thanks for the detailed follow-up anyway. :)

Half a year ago, when I evaluated hard drives, in the 8 TB category there were only the Hitachi 8 TB Helium drives for 800 bucks, and the Seagate SMR for 250 bucks.

I bought myself one of the Seagate SMR ones for testing, and figured out it wouldn't work for my use case (I now use it in a write-very-seldom context).

For my two NASes I went with 6 TB WD Red drives all around.

Nowadays there are more choices of 8 TB drives, such as the WD Reds I'm switching my backup NAS to.

> I haven't been following the issue very closely, but be aware that there 
> were serious issues with those drives a few kernels back, and that while 
> those issues are now fixed, the drives themselves operate rather 
> differently than normal drives, and simply don't work well in normal 
> usage.
> 
> The short version is that they really are designed for archiving and work 
> well when used for that purpose -- a mostly write once and leave it there 
> for archiving and retrieval but rarely if ever rewrite it, type usage.  
> However, they work rather poorly in normal usage where data is rewritten, 
> because they have to rewrite entire zones of data, and that takes much 
> longer than simply rewriting individual sectors on normal drives does.
> 
> With the kernel patches to fix the initial problems they do work well 
> enough, tho performance may not be what you expect, but the key to 
> keeping them working well is being aware that they continue to do 
> rewrites in the background for long after they are done with the initial 
> write, and shutting them down while they are doing them can be an issue.
> 
> Due to btrfs' data checksumming feature, small variances to data that 
> wouldn't normally be detected on non-checksumming filesystems were 
> detected far sooner on btrfs, making it far more sensitive to these small 
> errors.  However, if you use the drives for their intended nearly write-
> only purpose, and/or very seldom power down the drives at all or do so 
> only long after (give it half an hour, say) any writes have completed, as 
> long as you're running a current kernel with the initial issues patched, 
> you should be fine.  Just don't treat them like normal drives.
> 
> If OTOH you need more normal drive usage including lots of data rewrites, 
> especially if you frequently poweroff the devices, strongly consider 
> avoiding those 8 TB SMR drives, at least until the technology has a few 
> more years to mature.
> 
> There's more information on other threads on the list and on other lists, 
> if you need it and nobody posts more direct information (such as the 
> specific patches in question and what specific kernel versions they hit) 
> here.  I could find it but I'd have to do a search in my own list 
> archives, and now that you are aware of the problem, you can of course do 
> the search as well, if you need to. =:^)
> 
> -- 
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

