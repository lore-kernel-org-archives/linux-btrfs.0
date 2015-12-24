Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m.nv-systems.net ([176.9.99.115]:36425 "EHLO m.nv-systems.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619AbbLXK3h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 05:29:37 -0500
Subject: Re: Raid 5/6 Stability
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <E1aBsGQ-0007zz-4V@rmm6prod02.runbox.com>
 <pan$3b05a$667561e3$4f808486$449baaf4@cox.net>
From: Gerald Hopf <gerald.hopf@nv-systems.net>
Message-ID: <567BC911.4080707@nv-systems.net>
Date: Thu, 24 Dec 2015 11:29:37 +0100
MIME-Version: 1.0
In-Reply-To: <pan$3b05a$667561e3$4f808486$449baaf4@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan wrote:
> So 4.4 is what I'd consider the magical raid56-stability release, and 
> I'd actually expect the wiki to be updated shortly thereafter, tho 4.4 
> is close enough now, and there have been no major raid56 bugs reported 
> in the 4.3 and 4.4 cycles, that arguably the wiki's raid56 status 
> could be updated now to reflect that.

I don't think the wiki should be updated to show raid5/6 as production 
ready. The state of raid5/6 is still bad:

1) you STILL can't even properly check for free space
btrfs fi usage /my/device
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
(btrfs-progs v4.3.1-31-g0ab3d31)

2) Scrub is STILL horribly slow. Basically takes forever, unusable for 
anything large (and who uses raid5/6 for something small?)

3) the already mentioned problem that unlike mdadm there is no email 
notification and no proper fault handling if problems occur

And all those 3 problems are unlikely to be fixed in kernel 4.4 cycle at 
least as far as I was able to observe.

However: I'm using btrfs-raid5 and I'm mostly HAPPY with it. But I 
consider my use experimental and I rsync my btrfs-raid5 contents to an 
external off-site backup storage bimonthly and I can live with a worst 
case of 2 months of data loss for what I'm storing on it. Would love to 
see 1+2+3 fixed though.

Gerald
