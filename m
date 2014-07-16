Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38443 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbaGPIAX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 04:00:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X7K8S-0002jb-0S
	for linux-btrfs@vger.kernel.org; Wed, 16 Jul 2014 10:00:20 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jul 2014 10:00:20 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jul 2014 10:00:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unmountable btrfs filesystem - 'unable to find logical' / 'no
 mapping'
Date: Wed, 16 Jul 2014 08:00:04 +0000 (UTC)
Message-ID: <pan$1a915$ec9d1e93$7b7c14f1$dea1f150@cox.net>
References: <CABibBbuGtAC7Rpptdd_wF7m87MSqg8zUEHvWSFsfk3KH+w2Jmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Clay posted on Tue, 15 Jul 2014 14:35:22 +0100 as excerpted:

> I noticed yesterday that the mount points on my btrfs RAID1 filesystem
> had become read-only. On a reboot, the filesystem fails to mount. I
> wondered if someone here might be able offer any advice on how to
> recover (if possible) from this position?

I had a similar (but I think different) issue some weeks ago.  It was my 
first real experience with btrfs troubleshooting and recovery.

First, the recommendation is do NOT do btrfs check --repair except either 
at the recommendation of a dev after they've seen the details and 
determined it can fix them, or if your next step would be a new mkfs of 
the filesystem, thus blowing away what's there anyway, so you've nothing 
to lose.  You can try btrfs check (aka btrfsck) without --repair to see 
what it reports as that's read-only and thus won't break anything 
further, but similarly, won't repair anything either.

Also, as a general recommendation, try a current kernel as btrfs is still 
developing fast enough that if you're a kernel series behind, there's 
fixes in the new version that you won't have in older kernels.  I see 
you're on an ubuntu 3.13 series kernel, and the recommendation would be 
the latest 3.15 series stable kernel, if not the 3.16-rc series 
development kernel, since that's past rc5 now and thus getting close to 
release.

The userspace, btrfs-progs, isn't quite as critical, but running at least 
v3.12 (which you are), is recommended.  FWIW, v3.14.2 is current (as of 
when I last checked a couple days ago anyway) and is what I am running 
here.

In general, you can try mounting with recovery and then with recovery,ro 
options, but that didn't work here.  You can also try with the degraded 
option (tho I didn't), to see if it'll mount with just one of the pair.

Of course, btrfs is still not fully stable and keeping current backups is 
recommended.  I did have backups, but they weren't as current as I wanted.

Beyond that, there's btrfs restore (a separate btrfs-restore executable 
in older btrfs-progs, part of the main btrfs executable in newer 
versions), which is what I ended up using and is what the rest of this 
reply is about.  That does NOT mount or write to the filesystem, but DOES 
let you pull files off the unmounted filesystem and write them to a 
working filesystem (btrfs or other, it was reiserfs here) in ordered to 
recover what you can.  You can use --dry-run to list files that would be 
recovered in ordered to get an idea of how much it can recover.

There's a page on the wiki about using btrfs recover in combination with 
btrfs-find-root, if the current root is damaged and won't let you recover 
much.  Note that "generation" and "transid" refer to the same thing, and 
you want to specify the root (using the -t location option, with the 
location found using find-root) that lets you recover the most.  The -l 
(list tree roots) option is also useful in this context.

https://btrfs.wiki.kernel.org/index.php/Restore

Of course restoring in this manner means you have to have somewhere else 
to put what you restore, which was fine for me as I'm using relatively 
small independent btrfs filesystems and could restore to a larger 
reiserfs on a different device, but could be rather tougher for large 
multi-terabyte filesystems, unless you have (or purchase) a spare disk to 
put it on.

One thing I did NOT realize until later, however, is that btrfs restore 
loses the user and permissions information (at least without -x, which 
says it restores extended attributes, I didn't try it with that).  I 
hacked up a find script to compare the restore to the backup and set 
ownership/permissions appropriately based on the files in the backup, but 
of course that didn't help for files that were new since the backup, and 
I had to set their ownership/permissions manually.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

