Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48025 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbbHDGri (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Aug 2015 02:47:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZMW0e-0002hi-Go
	for linux-btrfs@vger.kernel.org; Tue, 04 Aug 2015 08:47:36 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2015 08:47:36 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2015 08:47:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
Date: Tue, 4 Aug 2015 06:47:28 +0000 (UTC)
Message-ID: <pan$2aa9c$6f3b26db$628bcc6$ac147f6d@cox.net>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
	<55BADEC4.3020409@cn.fujitsu.com>
	<CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
	<55BAFEF9.1070107@cn.fujitsu.com>
	<CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
	<55BB0A39.1050208@cn.fujitsu.com>
	<CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
	<CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
	<55C017E7.40704@cn.fujitsu.com>
	<CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
	<55C02AF9.3070600@cn.fujitsu.com>
	<CAJ3TwYQUX-CgqSXMxxU+6tcb0_0tuJbwKqHHPufCnsDBYuXycw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Ettedgui posted on Mon, 03 Aug 2015 21:58:09 -0700 as excerpted:

> Current mount options in fstab:
> defaults,noatime,compress=lzo,space_cache,autodefrag 0 0



Just a few hints for a tidier fstab.  Feel free to ignore if you don't 
care, as the practical difference in mount options is nil.  =:^)

1) You should be able to delete that space_cache option.  Btrfs has 
defaulted to space_cache since at least 3.0 I think and probably way 
before that, and even when it wasn't the absolute default, you only had 
to enable it once, to have it on after that unless you turned it off 
again.

I know I've never specifically added space_cache to my mount options, 
yet /proc/mounts always has said it was there, and I've been on btrfs 
solidly since kernel 3.5 era, with tests before that (tho I do think I 
had to turn it on once, after which it stayed on for that filesystem, 
back in my earliest tests, which would have been late kernel 2.6 era).

2) Similarly you can omit defaults, since that's only a field placeholder 
in case you don't have any other options in that field.  As soon as you 
have your first non-default option holding the place of that field, you 
can omit defaults, since that's exactly what they are, defaults, 
regardless of whether the kernel is told to use them or not.

So all you really need there is noatime,compress=lzo,autodefrag.  FWIW, 
that's what I use as my normal mount options, too.

3) Actually, assuming you're running a half-way modern util-linux (which 
you should be if you're not on an old enterprise distro), you can omit 
the trailing 0 0 as well, since those fields are now optional and default 
to 0 if they aren't there.

See the fstab(5) manpage for more on the last two.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

