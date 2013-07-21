Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32789 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab3GUKjJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Jul 2013 06:39:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V0r2g-0006KD-9m
	for linux-btrfs@vger.kernel.org; Sun, 21 Jul 2013 12:39:06 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jul 2013 12:39:06 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jul 2013 12:39:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Lots of harddrive chatter on after booting with btrfs on root
 (slow boot)
Date: Sun, 21 Jul 2013 10:38:49 +0000 (UTC)
Message-ID: <pan$3c802$83940fc4$86279b1e$4ddf0e4e@cox.net>
References: <CA+MxQPHSHVQQko8koeK=WCjS4wq+dss++PWUB6wq7TPOTsY3Yw@mail.gmail.
	com> <ksf42h$suu$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gabriel de Perthuis posted on Sat, 20 Jul 2013 22:47:46 +0000 as
excerpted:

> On Sat, 20 Jul 2013 17:15:50 +0200, Jason Russell wrote:
>> Ive also noted that this excessive hdd chatter does not occur
>> immediately after a fresh format with arch on btrfs root.
>> 
>> Ive made some deductions/assumptions:
>> This only seems to occur with btrfs roots.
>> This only happens after some number of reboots OR after the partition
>> fills up a little bit.
>> Im pretty sure of ruled out everything except for the filesystem.
> 
> In my experience (as of 3.8 or so), Btrfs performance degrades on a
> filled-up filesystem, even a comparatively new one.  Various background
> workers start to eat io according to atop.

I'd say it's likely fragmentation as George M mentioned, but that (as 
with most filesystems to some degree, but COW filesystems such as btrfs 
are often worse) performance (including fragmentation) tends to get worse 
when the filesystem's almost full, as Gabriel mentions here.

I do remember reading a comment on a btrfs commit to the effect that when 
the filesystem's almost full, it stops trying to allocate nice large 
extents and takes the space wherever it can get it.  Once that happens, 
especially with a COW filesystem such as btrfs, if you're doing any 
regular sort of writing at all, you **WILL** get **BAD** fragmentation.

What I'd suggest is to turn on the btrfs autodefrag mount option, and to 
do it *BEFORE* you start installing stuff on the filesystem.  I believe 
it's a known issue that a number of distro installers (what arch does I'm 
not sure) tend to fragment their files pretty badly right off the bat if 
you let them.  This would happen if they write data into an existing 
file, perhaps because they install a package and then customize the config 
files, or if they don't write whole files at once.  And a lot of btrfs 
installs don't turn on the autodefrag option when they do thet first auto-
mount to install stuff.  

So a lot of folks end up with a heavily fragmented brand new 
installation, and if they try turning on autodefrag at that point, it 
slows the system way down for several boots, because it keeps finding 
fragmented files, so they turn it off again, likely just as they'd 
otherwise start to actually see the benefits.

But either ensuring autodefrag is on starting from an empty filesystem, 
or if the installer doesn't make that easy, installing to a temp location 
and then preparing the final btrfs location, mounting it with autodefrag, 
and copying all the files over, in either case ensuring that no files are 
written to the filesystem before autodefrag is turned on, should help.

Then, do remember that btrfs is still under heavy development, so keep 
good backups if you choose to test it out.  Also, while I think they're 
actually beginning to work thru them now, until quite recently, btrfs had 
serious no-space issues when the filesystem started to fill up.  So you 
probably want to keep more freespace on btrfs than you would on ext4, 
just to be on the safe side.   Also, in keeping with the development 
nature of the filesystem, run at least the latest stable kernel (if not 
the development kernels if not btrfs-next), as the latest kernels really 
do have fixes that previous versions are missing.

Finally, if you haven't yet, take a look at the btrfs wiki, as it covers 
a lot of questions and issues you may have.

https://btrfs.wiki.kernel.org/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

