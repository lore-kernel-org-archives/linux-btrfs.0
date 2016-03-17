Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60591 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbcCQUII (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 16:08:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ageDF-0006OU-0t
	for linux-btrfs@vger.kernel.org; Thu, 17 Mar 2016 21:08:05 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 21:08:05 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 21:08:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs receive hangs in "uninterruptible sleep"
Date: Thu, 17 Mar 2016 20:07:55 +0000 (UTC)
Message-ID: <pan$85015$d4f660a3$2824b4d9$5dcc5652@cox.net>
References: <87y49ggbas.wl-MarkoSchuetz@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marko Schütz Schmuck posted on Thu, 17 Mar 2016 15:21:47 -0400 as
excerpted:

> for backup purposes on a laptop I use a shell script that takes
> snapshots and then btrfs sends the increment to a btrfs receive to an
> external USB drive. This used to work for years. The last time I used it
> successfully was mid-January. After that I have not been able to do a
> successful backup. It seems the btrfs receive hangs in "uninterruptible
> sleep". I turned on verbose output and can seen that it hangs
> predictably at the same file after `df -m` on the target file system
> reports 44MB more space used and 30MB less space available. At that time
> the `btrfs receive` has used 6s of CPU time. I cannot kill the `btrfs
> receive` and a shutdown does not go through (I have to power off).
> 
> I have tried booting into an older kernel version, btrfs scrub, btrfs
> check. Always the same.
> 
> Needless to say this is annoying: my main reason for using btrfs was the
> backup using send/receive ...
> 
> Any help is greatly appreciated!
> 
> Best regards,
> 
> Marko
> 
> % uname -a
> Linux tpad-u 3.19.0-25-generic #26~14.04.1-Ubuntu SMP Fri Jul
> 24 21:16:20 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> % btrfs --version
> Btrfs v3.12

Keeping in mind that btrfs is, as far as the list is concerned, 
"stabilizing, but not yet fully stable and mature", the recommendation is 
to keep to something reasonably current.  If that's not appropriate as 
you want really old and stable, then there's a very good chance btrfs 
isn't the right filesystem for you, as it simply hasn't reached that 
level of maturity yet and fixes are still actively being found that mean 
older kernels are often known-broken kernels, at least without good 
backports.

Both your kernel and userspace (btrfs-progs) are severely outdated, and 
while I don't use send/receive locally, I believe there have been changes 
to them since your ancient versions, that fixed various send/receive 
problems specifically.

Note that recommended kernels are in one of two tracks, current or LTS.  
On the LTS track, kernel 4.4 is an LTS series, with 4.1 being the 
previous one.  The previous recommendation is to stay within two LTS 
series, tho 3.18 the one previous to that, hasn't turned out so bad, and 
is still supported to some extent.  But 3.19 wasn't an LTS series so puts 
you on the current kernel track, and that's only supported two kernels 
back.  With 4.5 out, it and 4.4 are supported, and 3.19 is more or less a 
year out of mainline kernel support.  So an upgrade to 4.1 LTS would be 
preferred, or possibly a downgrade to 3.18 LTS, but 3.19 isn't really 
supported, at least on-list, as it's not an LTS and hasn't had upstream 
backports in a year or so.

Of course distros can and do choose to support their own kernels, but if 
you're relying on that, you should be looking to them for support, as we 
don't track what the distros are doing, only mainline, and thus don't 
know what they've backported and what they haven't.

Similarly, while userspace isn't as critical until you're trying to 
repair something gone bad, 3.12 is really /really/ ancient.  The release 
numbers sync to kernel releases, and as a general rule of thumb, if you 
run at least as new a userspace version as the kernel, and you're already 
within kernel recommendations, that'll keep userspace from getting too 
outdated as well.

So please update to a 4.1 kernel or so, and a similar userspace, try 
again, and see if you still have the problem.  Alternatively, if you're 
relying on your distro for support, rely on your distro, as we'll do what 
we can to support older versions here, but when there's problems and 
they're old as yours, the first recommendation is generally exactly as I 
said, update and try again with something that's not ancient.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

