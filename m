Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:48408 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbbLXN4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 08:56:18 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: <jwalmer@rbox.co>
Reply-To: jwalmer@rbox.co
To: "Gerald Hopf" <gerald.hopf@nv-systems.net>
CC: "Duncan" <1i5t5.duncan@cox.net>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: Raid 5/6 Stability
Date: Thu, 24 Dec 2015 08:56:15 -0500 (EST)
In-Reply-To: <567BC911.4080707@nv-systems.net>
Message-Id: <E1aC6NL-0003SE-1x@rmm6prod02.runbox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the speedy replies! Earlier Duncan said, "there's still no user-side multi-device filesystem health monitoring application." I'm mostly worried about device errors/failures, not my filesystem health. Since my implimentation of btrfs will be on a storage array, I'm not going to be doing anything unusual that should lend itself to creating filesystem errors.

How serious of a concern should it be that the filesystem health is not easily monitored? i.e., Since this is not a RAID-level-specific-issue, should the lack of filesystem monitoring be enough to stop me from playing with btrfs deployments for now?

On Thu, 24 Dec 2015 11:29:37 +0100, Gerald Hopf <gerald.hopf@nv-systems.net> wrote:

> Duncan wrote:
> > So 4.4 is what I'd consider the magical raid56-stability release, and 
> > I'd actually expect the wiki to be updated shortly thereafter, tho 4.4 
> > is close enough now, and there have been no major raid56 bugs reported 
> > in the 4.3 and 4.4 cycles, that arguably the wiki's raid56 status 
> > could be updated now to reflect that.
> 
> I don't think the wiki should be updated to show raid5/6 as production 
> ready. The state of raid5/6 is still bad:
> 
> 1) you STILL can't even properly check for free space
> btrfs fi usage /my/device
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
> (btrfs-progs v4.3.1-31-g0ab3d31)
> 
> 2) Scrub is STILL horribly slow. Basically takes forever, unusable for 
> anything large (and who uses raid5/6 for something small?)
> 
> 3) the already mentioned problem that unlike mdadm there is no email 
> notification and no proper fault handling if problems occur
> 
> And all those 3 problems are unlikely to be fixed in kernel 4.4 cycle at 
> least as far as I was able to observe.
> 
> However: I'm using btrfs-raid5 and I'm mostly HAPPY with it. But I 
> consider my use experimental and I rsync my btrfs-raid5 contents to an 
> external off-site backup storage bimonthly and I can live with a worst 
> case of 2 months of data loss for what I'm storing on it. Would love to 
> see 1+2+3 fixed though.
> 
> Gerald
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


