Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40582 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbcEDSec (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 14:34:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ay1cx-0004Vs-Jy
	for linux-btrfs@vger.kernel.org; Wed, 04 May 2016 20:34:27 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 20:34:27 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 20:34:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: /etc/fstab rootfs options vs grub2 rootflags cmdline
Date: Wed, 4 May 2016 18:34:19 +0000 (UTC)
Message-ID: <pan$b7a2d$25647256$6ea52b4$e3976a4a@cox.net>
References: <79249c4d-eab0-43fa-a6ae-b670699891dc@linuxsystems.it>
	<pan$7b1b$2e968d2f$7ddc7045$1ba7386@cox.net>
	<f8233c24-e336-4d31-a4cb-f3b0f97d1305@linuxsystems.it>
	<CAJCQCtQ5q_VUw0rCWWRZBFo=Lhx0ouYeuCDMxDLxcWKowUwbUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 04 May 2016 12:07:39 -0600 as excerpted:

> If you think it's worth the hassle, then you have to directly modify the
> grub.cfg to include an expanded rootflags parameter. Right now
> grub-mkconfig logic doesn't not include all options in fstab for
> rootflags.

And...

That might explain why his grub2 behavior didn't match what I expected.

Here, I entirely did away with the high-level grub config machinery like 
grub-mkconfig (to the point I install-mask some of the files so they 
don't get installed and thus can't accidentally be run, by some third 
party configuration script or something, and mess up my direct config) 
and I strictly do direct editing of the actual grub.cfg (and included 
files) in grub's native shell-like script.

I tend to forget that grub has this entire higher level config machinery 
that most people use, but that wasn't configuring grub the way I wanted, 
and that I'd have to learn IN ADDITION to the low-level scripting in 
ordered to get grub to do what I wanted, if I was to continue to use the 
high-level stuff at all.  Problem solved locally by simply deleting and 
masking the high-level stuff so it doesn't install, so I had to learn 
only the low-level script config, but that doesn't help me remember that 
few others will be doing that, and that the high-level stuff even exists.

So, umm, yeah, I was envisioning editing the low-level grub.cfg script 
file directly.  If he's editing the higher level config and running grub-
mkconfig or whatever to attempt to apply it to the lower level, then yes, 
that high level machinery could apply something entirely different than 
what I envisioned at the lower level, that of course being the major 
reason I use exclusively the lower level scripting language config stuff, 
here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

