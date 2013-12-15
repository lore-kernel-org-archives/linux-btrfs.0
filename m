Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48682 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab3LOXI3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 18:08:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VsKnS-0003T1-7X
	for linux-btrfs@vger.kernel.org; Mon, 16 Dec 2013 00:08:26 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 00:08:26 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 00:08:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Blocket for more than 120 seconds
Date: Sun, 15 Dec 2013 23:08:04 +0000 (UTC)
Message-ID: <pan$9369c$4a56c817$cc0b6bdf$1b4a6541@cox.net>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
	<46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
	<CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
	<337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
	<CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
	<840381F8-BDCA-43BF-A170-6E10C2908B8A@colorremedies.com>
	<CAD_cGvF8-pxXXvwpB+yNYnKRW09S4c0VuKUGiWa7=8C2uFkvqA@mail.gmail.com>
	<pan$e9ec8$f8abd102$9f0d15ad$59d83b5d@cox.net>
	<CAD_cGvHU0yaXj-CzVgNYbeqzu7ZH0mUOiwjT-GmU7F5JTqx=jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans-Kristian Bakke posted on Sun, 15 Dec 2013 15:51:37 +0100 as
excerpted:

> # Regarding torrents and preallocation I have actually turned
> preallocation on specifically in rtorrent thinking that it did btrfs a
> favour like with ext4 (system.file_allocate.set = yes). It is easy to
> turn it off.
> Is the "ideal" solution for btrfs and torrenting (or any other random
> writes to large files) to use preallocation and NOCOW, or use no
> preallocation and NOCOW? I am thinking the first, although I still do
> not understand quite why preallocation is worse than no preallocation
> for btrfs with COW enabled (or is both just as bad?)

I'm not a dev only an admin who follows this list as I run btrfs too, and 
thus don't claim to be an expert on the above -- it's mostly echoing what 
I've seen here previously.

That said, preallocation with nocow is the choice I'd make here.

Meanwhile, a subpoint I didn't make explicit previously, tho it's a 
logical conclusion from the explanation, is that once the writing is 
finished and the file becomes like most media files effectively read-
only, no further writes, NOCOW is no longer important.  That is, you can 
(sequentially) copy the file somewhere else and not have to worry about 
it.  In fact, that's a reasonably good idea, since NOCOW turns off btrfs 
checksumming too, and presumably you're still interested in maintaining 
file integrity on the thing.

So what I'd do is setup a torrent download dir (or as I mentioned, a 
dedicated partition, since I like that sort of thing because it enforces 
size discipline on the stuff I've downloaded but not fully sorted thru... 
that's what I do with binary newsgroup downloading, which I've been doing 
on and off since well before bittorrent was around), set/mount it NOCOW/
nowdatacow, and use it as a temporary download "cache".  Then after a 
file is fully downloaded to "cache", I'd copy it off to a final 
destination in my normal media partition, ultimately removing my NOCOW 
copy.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

