Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47476 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbaCWM1A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 08:27:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WRhUR-0002wo-KX
	for linux-btrfs@vger.kernel.org; Sun, 23 Mar 2014 13:26:59 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 13:26:59 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 13:26:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ERROR: error during balancing '.' - No space left on device
Date: Sun, 23 Mar 2014 12:26:32 +0000 (UTC)
Message-ID: <pan$a5998$152d4a82$370a3453$dc1d788e@cox.net>
References: <20140323070144.GG12833@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 23 Mar 2014 00:01:44 -0700 as excerpted:

> legolas:/mnt/btrfs_pool2# btrfs balance .
> ERROR: error during balancing '.' - No space left on device

> But:
> # btrfs fi show `pwd`
> Label: btrfs_pool2  uuid: [...]
> 	Total devices 1 FS bytes used 646.41GiB
>       devid 1 size 820.45GiB used 820.45GiB path /dev/mapper/disk2
> # [btrfs fi df `pwd` (unused single metadata/system chunks omitted)]
> Data, single: total=800.42GiB, used=636.91GiB
> System, DUP: total=8.00MiB, used=92.00KiB
> Metadata, DUP: total=10.00GiB, used=9.50GiB
> 
> I can't see how I'm full, and now that I can't run balance to fix
> things, this is making things worse.
> Kernel is 3.14.
> 
> What am I missing?

When it rains, it pours.  What you're missing is that this is now the 
third thread in three days with exactly the same out-of-space-when-there-
appears-to-be-plenty problem, which is well explained and a solution 
presented, along with further discussion, on those threads.

Evidently you haven't read the others, but rather than rewrite a similar 
reply here with exactly the same explanation and fix, I'll just refer you 
to them.

First thread, subject, original poster, message-id, gmane link:

fresh btrfs filesystem, out of disk space, hundreds of gigs free

Jon Nelson <jnelson@jamponi.net>

<CAKuK5J0LyagDYro6Yq7h-p-VjbwrbeuFf9AdNwRNg0jv3bq9QQ@mail.gmail.com>

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/33640


Second thread (same problem altho he chose as a subject a btrfsck error 
that wasn't actually related to it) ...

free space inode generation (0) did not match free space cache
 generation

Hendrik Friedel <hendrik@friedels.name>

<532DD2DC.3030408@friedels.name>

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/33647

Very briefly, from your btrfs fi show:

devid 1 size 820.45GiB used 820.45GiB

That's total size and total of allocated chunks.  They're equal, so 
there's no space left to allocate.  Normally you'd use a balance, but a 
normal balance won't work without some space left to write the new chunks 
it's going to copy the old data/metadata into.  There is however a 
solution, balance filters, using a command something like this (-d for 
data only since df says that's what has the extra chunks that need freed, 
usage=percent-full):

btrfs balance start -dusage=5 `pwd`

Tweak the N in usage=N as needed.

The explanation for all that is in the other threads.  If that doesn't 
work (tho it most likely will), there's other solutions available, see 
the no-space discussion in the FAQ on the wiki, again as linked in the 
other threads.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

