Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50238 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758420AbaGQXPI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 19:15:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X7utE-0001Ih-VE
	for linux-btrfs@vger.kernel.org; Fri, 18 Jul 2014 01:15:05 +0200
Received: from 2.27.65.250 ([2.27.65.250])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 01:15:04 +0200
Received: from gareth.clay by 2.27.65.250 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 01:15:04 +0200
To: linux-btrfs@vger.kernel.org
From: Gareth Clay <gareth.clay@gmail.com>
Subject: Re: Unmountable btrfs filesystem - 'unable to find logical' / 'no mapping'
Date: Thu, 17 Jul 2014 23:09:08 +0000 (UTC)
Message-ID: <loom.20140718T004316-587@post.gmane.org>
References: <CABibBbuGtAC7Rpptdd_wF7m87MSqg8zUEHvWSFsfk3KH+w2Jmg@mail.gmail.com> <pan$1a915$ec9d1e93$7b7c14f1$dea1f150@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

> 
> Gareth Clay posted on Tue, 15 Jul 2014 14:35:22 +0100 as excerpted:
> 
> > I noticed yesterday that the mount points on my btrfs RAID1 filesystem
> > had become read-only. On a reboot, the filesystem fails to mount. I
> > wondered if someone here might be able offer any advice on how to
> > recover (if possible) from this position?
> 
> I had a similar (but I think different) issue some weeks ago.  It was my 
> first real experience with btrfs troubleshooting and recovery.
> 
> First, the recommendation is do NOT do btrfs check --repair except either 
> at the recommendation of a dev after they've seen the details and 
> determined it can fix them, or if your next step would be a new mkfs of 
> the filesystem, thus blowing away what's there anyway, so you've nothing 
> to lose.  You can try btrfs check (aka btrfsck) without --repair to see 
> what it reports as that's read-only and thus won't break anything 
> further, but similarly, won't repair anything either.
> 
> Also, as a general recommendation, try a current kernel as btrfs is still 
> developing fast enough that if you're a kernel series behind, there's 
> fixes in the new version that you won't have in older kernels.  I see 
> you're on an ubuntu 3.13 series kernel, and the recommendation would be 
> the latest 3.15 series stable kernel, if not the 3.16-rc series 
> development kernel, since that's past rc5 now and thus getting close to 
> release.
> 
> The userspace, btrfs-progs, isn't quite as critical, but running at least 
> v3.12 (which you are), is recommended.  FWIW, v3.14.2 is current (as of 
> when I last checked a couple days ago anyway) and is what I am running 
> here.
> 
> In general, you can try mounting with recovery and then with recovery,ro 
> options, but that didn't work here.  You can also try with the degraded 
> option (tho I didn't), to see if it'll mount with just one of the pair.
> 
> Of course, btrfs is still not fully stable and keeping current backups is 
> recommended.  I did have backups, but they weren't as current as I wanted.
> 
> Beyond that, there's btrfs restore (a separate btrfs-restore executable 
> in older btrfs-progs, part of the main btrfs executable in newer 
> versions), which is what I ended up using and is what the rest of this 
> reply is about.  That does NOT mount or write to the filesystem, but DOES 
> let you pull files off the unmounted filesystem and write them to a 
> working filesystem (btrfs or other, it was reiserfs here) in ordered to 
> recover what you can.  You can use --dry-run to list files that would be 
> recovered in ordered to get an idea of how much it can recover.
> 
> There's a page on the wiki about using btrfs recover in combination with 
> btrfs-find-root, if the current root is damaged and won't let you recover 
> much.  Note that "generation" and "transid" refer to the same thing, and 
> you want to specify the root (using the -t location option, with the 
> location found using find-root) that lets you recover the most.  The -l 
> (list tree roots) option is also useful in this context.
> 
> https://btrfs.wiki.kernel.org/index.php/Restore
> 
> Of course restoring in this manner means you have to have somewhere else 
> to put what you restore, which was fine for me as I'm using relatively 
> small independent btrfs filesystems and could restore to a larger 
> reiserfs on a different device, but could be rather tougher for large 
> multi-terabyte filesystems, unless you have (or purchase) a spare disk to 
> put it on.
> 
> One thing I did NOT realize until later, however, is that btrfs restore 
> loses the user and permissions information (at least without -x, which 
> says it restores extended attributes, I didn't try it with that).  I 
> hacked up a find script to compare the restore to the backup and set 
> ownership/permissions appropriately based on the files in the backup, but 
> of course that didn't help for files that were new since the backup, and 
> I had to set their ownership/permissions manually.
> 


Hi Duncan,

Thanks for your thorough response and the tips - sorry to hear you've had
issues too. Point taken  on the kernel updates! I'm in a similar situation to
you - this is my first btrfs recovery experience. I've  been playing with the fs
for some time and have had no apparent issues, but this has been a useful
reality check. Read / write error counts were high so there's a suggestion that
it might be down to  drive failure.

In the end I had a lot of help from xaba on the #btrfs IRC channel, whose
suggestions got me to the  point where, with a bang up to date version of the
userspace utils, I could get a successful btrfsck run  using the -b option (3.12
only got part way). At that point btrfs restore still couldn't be run, degraded
mounting also wouldn't work, and I'd spent about as much time as I was prepared
to spend on  recovering this fs, so I took a deep breath and ran btrfsck
--repair. That's got me to the point where  btrfs restore can now be run, so I'm
going to dump as much as I can to a spare drive and then blow  the file system
(and maybe a dodgy disk) away.

I'm not fully sure about the btrfs restore -x behaviour either. Ownership of the
restored files is still  incorrect, but maybe it affects r/w/x permissions,
which look fairly sensible for the small set of files  I've looked at so far...


