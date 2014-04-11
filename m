Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54177 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaDKR6d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 13:58:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WYfih-00063T-N6
	for linux-btrfs@vger.kernel.org; Fri, 11 Apr 2014 19:58:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 19:58:31 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 19:58:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: using same btrfs from diferent distros/kernels
Date: Fri, 11 Apr 2014 17:58:18 +0000 (UTC)
Message-ID: <pan$b19e5$dc629c17$71950df8$84dad83d@cox.net>
References: <5347FA01.3090809@netvision.com.py>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Julio E. Gonzalez P. posted on Fri, 11 Apr 2014 10:19:45 -0400 as
excerpted:

> I have a multiboot PC with Centos 6.5, Fedora 20, and Ubuntu 13.10. Also
> there is a btrfs partition I want to mount, read and write from the 3
> diferent distros.
> 
> Is this "safe" ? Is the btrfs versions from this 3 distros compatible
> between them ?
> This is for testing and learning only.

I've no idea what kernels all those distros ship with, but in general, 
for some time now btrfs on-device format has been guaranteed forward 
compatibility, but not necessarily backward compatibility (or the 
reverse, from the kernel's perspective instead of the device's on-disk 
format, backward compatibility since newer kernels can mount older on-
device-formats, but not forward compatibility since older kernels won't 
necessarily mount newer on-device-formats without error).  That is, you 
can always move to a newer kernel, but if there were changes in on-device 
format between kernels, once mounted read/write with the newer kernel, 
you aren't guaranteed that mounting with the older kernel will still be 
error free.

Further, until very recently (kernel v3.13 IIRC), btrfs still being under 
rather active development and bug-fixing, users are always encouraged to 
run the latest stable kernel, as it will have fixes for known bugs that 
affected earlier kernels.  So regardless of the distro you run, you want 
to run a new kernel.

That said, with kernel v3.13, the btrfs kconfig option warning was toned 
down quite a bit, and they're making stronger efforts to backport fixes 
to stable now.  So in theory at least you should be able to run the 
latest version of any stable-series kernel newer than v3.13 (tho still 
with the forward compatibility only guarantee).  Active stable series 
before that are likely to get fixes as they are making the backporting 
effort now, but it's not guaranteed.

Of course v3.13 is still relatively new as the newest release is only the 
v3.14 series, and to my knowledge nobody has yet taken up either v3.13 or 
v3.14 as a longterm support kernel, so their stable series support is 
likely to be rather short, but going forward it's still an important 
turning point, as a year from now the current kernel will be perhaps 
v3.19, and there's likely to be at least one v3.13+ longer term support 
kernel available.

So bottom line, regardless of what distro(s) you run, you should be good 
as long as you're running the latest stable kernel series on each.  And 
from v3.13 on, you should be good as long as you're running /any/ 
currently active stable kernel series v3.13 or newer.  But in any case, 
try to keep your kernels in sync between distros, because there is still 
that one-way-compatibility-guarantee only.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

