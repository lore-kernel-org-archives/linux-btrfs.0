Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36243 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbaDHNCC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Apr 2014 09:02:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WXVf1-0005Mc-Qn
	for linux-btrfs@vger.kernel.org; Tue, 08 Apr 2014 15:01:55 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 15:01:55 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 15:01:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is there any way to determine fragmentation for compressed
 btrfs volumes?
Date: Tue, 8 Apr 2014 13:01:43 +0000 (UTC)
Message-ID: <pan$73f63$4e264a95$61f7c205$43e12487@cox.net>
References: <CAFvQSYSSt_FneFeFUXYK65toiS6MSVGy_pmXd3RUuy=vam-Xsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clemens Eisserer posted on Tue, 08 Apr 2014 13:46:37 +0200 as excerpted:

> I've been running btrfs on my SSD powered laptop for about a year and a
> half  (with force-compress=lzo and autodefrag) and it seems the volume
> has degraded quite a lot although I am not using snapshot functionality.
> No matter what I do (scrub, defrag ob the whole volume), files seem to
> stay highly fragmented - at least that is my guess.
> When e.g. starting up X11+XFCE the hdd led is lid for about 10s (the
> Samsung 830 can do up to 80k/iops random read), also starting
> google-chrome results in an active SSD for ~5s (although the chrome
> binary + libs is for sure < 200mb, so should be loaded in 500ms).
> 
> What I wonder is how can I diagnose whats happening and why the FS is
> rather slow?
> The only target value I know is the extend count,  which doesn't seem to
> be meaningful when using fragmentation.

You're correct, filefrag doesn't yet understand btrfs compression, which 
breaks files into 128 MiB compression blocks, and thus reports that as 
fragmentation.  There's some work in the pipeline to teach filefrag about 
compression, but they're trying to do it in a generic/standardized way so 
other filesystems can use the same API once it's available, so they're 
obviously taking the "best" route rather than the "fast" route, and it's 
taking some time, but btrfs and Linux in general will be better for it in 
the end.

There's no other known/easy way to check filefrag, that understands btrfs 
compression, unfortunately.

You mention trying scrub and defragging the entire volume, but you don't 
mention balance.  Balance by default rewrites all chunks (tho you can add 
filters to rewrite only say data chunks, not metadata, if you like), so 
that's what I'd say to try, as it should defrag in the process.

Tho we've seen a few reports from people saying a full balance actually 
made for instance boot times longer instead of shorter, too.  I haven't 
seen and don't have an explanation for that. <shrug>

Meanwhile, have you tried a trim/discard (fstrim command), and/or do you 
run with the discard (or is it trim) mount option?  For SSDs that support 
trim, as anything half-modern should (there's a discussion in the 
archives about reading hdparm or smartctl output to tell, or just run an 
fstrim and see if it helps), a filesystem trim once in awhile could help 
a great deal, particularly if you're running close to full capacity on 
your SSD.  However, until very recently most consumer grade hardware (as 
opposed to expensive enterprise grade) implemented trim/discard as a non-
queued command, which is why it's not automatically enabled with the ssd 
mount option (which is enabled automatically on btrfs when the kernel 
detects a non-rotational media device).  For such hardware an fstrim once 
in awhile is preferred to the mount option.

Additionally, a general recommendation for SSDs is to leave 20-30% of the 
drive entirely unallocated -- create partitions smaller than the drive or 
if you're putting the filesystem on the drive directly without 
partitions, make it smaller than the drive, by 20-30%.  That leaves the 
SSD's firmware plenty of room to shuffle things around in ordered to 
manage erase-blocks and the like.

FWIW here I left over 40% free, mainly because I ended up buying bigger 
SSDs than I had intended due to price/availability when I went shopping.  
I don't use the trim/discard mount option, but I do fstrim once in 
awhile.  Additionally, I use compress=lzo (decided not to use force here) 
and noatime mount options as well as autodefrag, and the kernel detects 
ssd so adds that on its own.  I've seen no such slowdowns here and in 
fact some things seem to be faster now than they were some months ago.
I guess I'm following best-practices and thus potentially getting best-
case results, but I'm not going to complain! =:^)

One more thing to consider.  The btrfs of a year and a half ago was a 
rather less mature btrfs than we have today.  I recently booted to backup 
here, and did a brand new mkfs.btrfs on my working filesystems to take 
advantage of several of the newer features (like the larger 16k metadata 
nodes), restoring from backup afterward.  It may be that is actually part 
of the reason things seem to be faster now.  You might consider trying 
that, if you have backups around to restore from (as you should, since 
btrfs isn't yet fully mature and stable yet), and either a current kernel 
and btrfs rescue media, or can boot from the backups (as I did).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

