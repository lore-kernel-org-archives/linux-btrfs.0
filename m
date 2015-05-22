Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44938 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbbEVSLX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 May 2015 14:11:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YvrPl-0007eX-Eh
	for linux-btrfs@vger.kernel.org; Fri, 22 May 2015 20:11:21 +0200
Received: from 93.96-242-81.adsl-dyn.isp.belgacom.be ([81.242.96.93])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2015 20:11:21 +0200
Received: from jan.voet by 93.96-242-81.adsl-dyn.isp.belgacom.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2015 20:11:21 +0200
To: linux-btrfs@vger.kernel.org
From: Jan Voet <jan.voet@gmail.com>
Subject: Re: BTRFS RAID5 filesystem corruption during balance
Date: Fri, 22 May 2015 18:11:14 +0000 (UTC)
Message-ID: <loom.20150522T194305-796@post.gmane.org>
References: <loom.20150521T231006-840@post.gmane.org> <pan$1c831$68d3ab4d$212d5e11$aaf7c2b4@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

> FWIW, btrfs raid5 (and raid6, together called raid56 mode) is still 
> extremely new, only normal runtime implemented as originally introduced, 
> with complete repair from a device failure only completely implemented in 
> kernel 3.19, and while in theory complete, that implementation is still 
> very immature and poorly tested, and *WILL* have bugs, one of which you 
> may very well have found.
> 
> For in-production use, therefore, btrfs raid56 mode, while now at least 
> in theory complete, is really too immature at this point to recommend.  
> I'd recommend either btrfs raid1 or raid10 modes as more stable within 
> btrfs at this point, tho by the end of this year or early next, I predict 
> raid56 mode to have stabilized to about that of the rest of btrfs, which 
> is to say, not entirely stable, but heading that way.
> 

Hi Duncan,

Thanks for your reply.

I was under the impression that RAID5/6 was considered quite stable in the
more recent kernels, hence my use of the 3.19 kernel and the upgraded
btrfstools.  It's obvious that I was wrong in this assumption and maybe
btrfs RAID5 should be labeled as experimental code then.

A balance operation is supposed to be safe as it makes a copy of each file,
rewrites it, distributing the data over all devices and only then deletes
the original file?  This should never lead to kernel deadlocks ...
Having a corrupted filesystem after a reboot due to this is even more
worrisome, I think.  And worst of all are the btrfs kworker crashes.  Kernel
code should never crash IMHO, but maybe I'm slightly naive here ;-) .

Anyways, lots of lessons learned, and I'll see if I can repair the
filesystem as described in https://btrfs.wiki.kernel.org/index.php/Btrfsck
If it doesn't work, I'll simply start over with an alternative filesystem.

Regards,
Jan


