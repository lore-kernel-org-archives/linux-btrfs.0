Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34792 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbLMXTj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Dec 2015 18:19:39 -0500
Date: Sun, 13 Dec 2015 15:19:14 -0800
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20151213231914.GJ2662@merlins.org>
References: <8336788.myI8ELqtIK@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <8336788.myI8ELqtIK@merkaba>
Subject: Re: Still not production ready
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 13, 2015 at 11:35:08PM +0100, Martin Steigerwald wrote:
> Hi!
> 
> For me it is still not production ready. Again I ran into:
> 
> btrfs kworker thread uses up 100% of a Sandybridge core for minutes on random 
> write into big file
> https://bugzilla.kernel.org/show_bug.cgi?id=90401
 
Sorry you're having issues. I haven't seen this before myself.
I couldn't find the kernel version you're using in your Email or the bug
you filed (quick scan).

That's kind of important :)

Marc
 
> No matter whether SLES 12 uses it as default for root, no matter whether 
> Fujitsu and Facebook use it: I will not let this onto any customer machine 
> without lots and lots of underprovisioning and rigorous free space monitoring. 
> Actually I will renew my recommendations in my trainings to be careful with 
> BTRFS.
> 
> From my experience the monitoring would check for:
> 
> merkaba:~> btrfs fi show /home
> Label: 'home'  uuid: […]
>         Total devices 2 FS bytes used 156.31GiB
>         devid    1 size 170.00GiB used 164.13GiB path /dev/mapper/msata-home
>         devid    2 size 170.00GiB used 164.13GiB path /dev/mapper/sata-home
> 
> If "used" is same as "size" then make big fat alarm. It is not sufficient for 
> it to happen. It can run for quite some time just fine without any issues, but 
> I never have seen a kworker thread using 100% of one core for extended period 
> of time blocking everything else on the fs without this condition being met.
> 
> 
> In addition to that last time I tried it aborts scrub any of my BTRFS 
> filesstems. Reported in another thread here that got completely ignored so 
> far. I think I could go back to 4.2 kernel to make this work.
> 
> 
> I am not going to bother to go into more detail on any on this, as I get the 
> impression that my bug reports and feedback get ignored. So I spare myself the 
> time to do this work for now.
> 
> 
> Only thing I wonder now whether this all could be cause my /home is already 
> more than one and a half year old. Maybe newly created filesystems are created 
> in a way that prevents these issues? But it already has a nice global reserve:
> 
> merkaba:~> btrfs fi df /
> Data, RAID1: total=27.98GiB, used=24.07GiB
> System, RAID1: total=19.00MiB, used=16.00KiB
> Metadata, RAID1: total=2.00GiB, used=536.80MiB
> GlobalReserve, single: total=192.00MiB, used=0.00B
> 
> 
> Actually when I see that this free space thing is still not fixed for good I 
> wonder whether it is fixable at all. Is this an inherent issue of BTRFS or 
> more generally COW filesystem design?
> 
> I think it got somewhat better. It took much longer to come into that state 
> again than last time, but still, blocking like this is *no* option for a 
> *production ready* filesystem.
> 
> 
> 
> I am seriously consider to switch to XFS for my production laptop again. Cause 
> I never saw any of these free space issues with any of the XFS or Ext4 
> filesystems I used in the last 10 years.
> 
> Thanks,
> -- 
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
