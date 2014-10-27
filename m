Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40728 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaJ0HQY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 03:16:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XieXO-0003Yj-0j
	for linux-btrfs@vger.kernel.org; Mon, 27 Oct 2014 08:16:22 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 08:16:22 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 08:16:22 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Poll: time to switch skinny-metadata on by default?
Date: Mon, 27 Oct 2014 07:16:10 +0000 (UTC)
Message-ID: <pan$e9945$7fb9470e$bd432d6f$cd0e60b1@cox.net>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz>
	<20141027043924.GI17395@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Mon, 27 Oct 2014 00:39:25 -0400 as excerpted:

> One thing that may be significant is _when_ those 3 hanging filesystems
> are hanging:  when using rsync to update local files.  These machines
> are using the traditional rsync copy-then-rename method rather than
> --inplace updates.  There's no problem copying data into an empty
> directory with rsync, but as soon as I start updating existing data,
> some process (not necessarily rsync) using with the filesystem gets
> stuck within 36 hours, and stays stuck for days.  If I don't run rsync
> on the skinny filesystems,
> they'll run for a week or more without incident--and if I then start
> running rsync again, they hang later the same day.

Limited counterpoint here:

My packages partition is btrfs with skinny-metadata (skinny extents in 
dmsg), and the main gentoo tree on it gets regularly rsynced against 
gentoo servers.  In fact, my sync script does that *AND* a git-pull on 
three overlays, in parallel with the rsync so all three git-pulls and the 
rsync are happening at once.

No problems with that here. =:^)

However, I suspect other factors in my setup avoid whatever's triggering 
it for Zygo.

* The filesystem is btrfs raid1 mode data/metadata.

* Only 24 GiB in size (show says 19.78 GiB used, df says 15.84 of 18 GiB 
data used, 969 MiB of 1.75 GiB metadata used).

* Relatively fast SSD, ssd auto-detected and added as a mount option.

* I set the skinny-metadata option (and extref and no-holes) at 
mkfs.btrfs time, while Zygo converted and presumably has both fat and 
skinny metadata.

FWIW I've been spared all the rsync-triggered issues people have reported 
over time.  I'm guessing I don't hit the same race conditions because 
with the small filesystem my overhead is lower, and with the ssd I simply 
don't have the same bottlenecks.  So I'd not expect to hit this problem 
here either and that I'm not hitting it doesn't prove much, except that 
with reasonably fast ssds and smaller filesystems, whatever race 
conditions people seem to so commonly trigger with rsync elsewhere, 
simply don't seem to happen here.

So as I said, limited counterpoint, but offered FWIW.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

