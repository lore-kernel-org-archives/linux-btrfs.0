Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45248 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaDLEmn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Apr 2014 00:42:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WYpm5-0003jr-4K
	for linux-btrfs@vger.kernel.org; Sat, 12 Apr 2014 06:42:41 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Apr 2014 06:42:41 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Apr 2014 06:42:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount options ignored / unclear
Date: Sat, 12 Apr 2014 04:42:29 +0000 (UTC)
Message-ID: <pan$726e3$4cc96c8$4136f98$23771afe@cox.net>
References: <1988570.7Waz7R0erI@zafu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Fri, 11 Apr 2014 11:21:55 +0200 as excerpted:

> It is extremely unclear which BTRFS mount options are "filesystem wide"
> and will apply to each and every mountpoint in the BTRFS filesystem, and
> which options can be set per subvolume or per mountpoint.
> 
> As far as I can tell, there is no reliable documentation about this, is
> there any ?

In general, btrfs doesn't _yet_ have the runtime infrastructure to handle 
per-subvolume mount options.  The on-device format and general approach 
in the kernel was designed to allow it, and it's on the roadmap, it just 
hasn't been done... yet.

So at this time, assume all options apply to the entire filesystem 
including all subvolumes unless you know and can demonstrate otherwise.

If you will take a look back at my posts related to nocow files, while I 
suggested a separate subvolume for those files in ordered to prevent 
snapshotting them with the rest of the filesystem, I specifically did 
*NOT* suggest using the nodatacow mount-option on that subvolume even tho 
I knew about it, instead suggesting either still using the nocow file 
attribute, or putting those file on an entirely separate partition, which 
could then be other than btrfs if desired, precisely because AFAIK the 
nodatacow option cannot apply to a single subvolume yet, and for the most 
part, if one's going to use it on the entire filesystem, one might as 
well use some other filesystem instead of btrfs, since without cow and 
checksumming and snapshotting, there's little left to recommend btrfs 
above a more stable filesystem such as ext3/4 or xfs.  Once the per-
subvolume mount-options work as is planned, simply mounting that 
dedicated subvolume nodatacow will be what I'll recommend, while keeping 
standard cow for the main filesystem, but AFAIK that doesn't work yet, so 
I can't recommend it yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

