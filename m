Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49682 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbbEBE2d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 May 2015 00:28:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YoP2V-0006Np-0V
	for linux-btrfs@vger.kernel.org; Sat, 02 May 2015 06:28:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 May 2015 06:28:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 May 2015 06:28:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to find corrupted files?
Date: Sat, 2 May 2015 04:28:25 +0000 (UTC)
Message-ID: <pan$c16ae$f1e42671$8cb4e01f$fcc44e0f@cox.net>
References: <20150501200648.GA4418@kabis.intra.monte-stello.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Antoine Sirinelli posted on Fri, 01 May 2015 22:06:48 +0200 as excerpted:

> Hi,
> 
> I had a btrfs system running for a couple of years with an old kernel
> (3.14.xx). Recently I have tried to backup it to a remote host using the
> send/receive functionality. It results in a couple of kernel oops. I
> decided to upgrade the kernel to 3.16 (Debian Jessie) and I was able to
> use send/receive without too much problems.

=:^)  The send/receive code has gotten a lot of attention and fixes for 
various corner-cases over the last few kernels, and your experience 
demonstrates that.

Of course btrfs isn't entirely stable yet, and people on this list 
generally consider 3.16 pretty old, as well.  Generally stated, the full-
stability reasons one might wish to run a long-term-stable kernel are 
incompatible with running a not yet fully stable filesystem like btrfs.  
Either you want stable and btrfs is still too leading and possibly 
bleeding edge for you, or you want leading edge not entirely stable yet 
stuff like btrfs, and you can't expect to run old kernels as they tend to 
have known and already long fixed bugs for rapidly moving features such 
as btrfs.

What I've been recommending recently for people who want btrfs and 
reasonable stability as well, is staying a release-kernel series back.  
4.0 is current release, so in this mode, you'd be on 3.19 currently, and 
would upgrade to 4.0.x about the time 4.1 comes out, provided no serious 
current btrfs bugs are known for it at that time.  That gives at least 
the worst and most common bugs time enough to flush out, so they'll at 
least be known by then, and generally either already fixed or at least 
they'll be hot on the trail of a fix.  That is of course assuming you 
don't want the risk of running newer, say late rcs, which are already 
usually pretty stable, altho there have been a couple major exceptions of 
late.

(Personally, I've gotten a bit more conservative due to those exceptions, 
and haven't been updating until say rc5 at least, if not full release, 
while I used to try to update by rc3.)

> Since the kernel upgrade I have notices a lot of the following lines in
> the kernel log:
> 
> [145059.990123] BTRFS info (device sda4): csum failed ino 101147
> off 1114112 csum 1810207416 expected csum 3082675757
> [145060.500612] BTRFS info (device sda4): csum failed ino 101148
> off 110592 csum 1418370968 expected csum 496354029
> 
> I understand these are corrupted file. By running btrfs scrub, I have
> been able to find some of them but I still have 20 inodes with failed
> csum. As I have quite a lot of subvolumes (1075, mainly for backup), it
> is not easy to find the path to the corrupted files. Is there an easy
> way to find these files?

If the corruption is in a data chunk and thus in a file, with a current 
kernel at least, dmesg covering the period of a scrub should contain a 
file mapping.  If the corruption is metadata, mapping to a file is 
obviously not possible, but unlike data, metadata defaults to dup mode on 
a single-device-btrfs (except for ssds where it defaults to single), and 
raid1 mode for a multi-device-btrfs, so chances are much better there 
will be a valid second copy that scrub can use to fix the bad copy.

There's also the btrfs-inspect-internal tool, which can resolve various 
items including inodes for debugging purposes.

But I'm not exactly sure how either one works with snapshots, 
particularly when the corruption is referenced by multiple snapshots.  My 
use-case doesn't involve subvolumes or snapshots (I prefer small and 
therefore manageable whole filesystems, generally under 100 GiB each, 
with multiple backup copies as appropriate), and I've not seen that bit 
documented or happened across it discussed on the list, so...

Of course here too, you'll be best served by running a current btrfs-progs 
userspace.  The git/master repo is currently serving v4.0 (which I 
grabbed just tonite).

> A side note, I have also noticed the following line appearing regularly
> in the logs:
> 
> [58562.612121] btrfs_readpage_end_io_hook: 12 callbacks suppressed
> 
> Do you know what it means?

I believe that's a logging noise-reduction mechanism -- 12 lines 
substantially similar to a previously printed line were suppressed.

So just above that should be another btrfs_readpage_end_io_hook line, 
with an actual message.  The suppression line says 12 more of those 
occurred but weren't logged.

Beyond that, I don't know what btrfs_readpage_end_io_hook actually does, 
as I'm just a btrfs using admin and list regular too, not a dev.  
Presumably you'll get a /bit/ more info from the /not/ suppressed line, 
and presumably it's at least worth warning about or it wouldn't be 
repeating-logged like that, but I guess a dev would have to see the 
unsuppressed line to explain further.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

