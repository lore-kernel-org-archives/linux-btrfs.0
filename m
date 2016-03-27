Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52880 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbcC0RbQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 13:31:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1akEWw-0007AW-KA
	for linux-btrfs@vger.kernel.org; Sun, 27 Mar 2016 19:31:14 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 19:31:14 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 19:31:14 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
Date: Sun, 27 Mar 2016 19:31:05 +0200
Message-ID: <20160327193105.0ba5c557@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<CAJCQCtSzKT2BZ15JwgR4b6Nk+n2tsHBLizwJXOqJ93Jbuv05rQ@mail.gmail.com>
	<CAJCQCtQYkCDLks0Wvnt2nqTRMAvh6wQ5nsHB4GPD4wFA8geAsw@mail.gmail.com>
	<20160327033032.6dce42e0@jupiter.sol.kaishome.de>
	<CAJCQCtSOURe5Cy-ytB3Tg_s46hgWsGKLn6fXjy8vt+TBQKNucg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 26 Mar 2016 22:57:53 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

> On Sat, Mar 26, 2016 at 7:30 PM, Kai Krakow <hurikhan77@gmail.com>
> wrote:
> 
> > Both filesystems on this PC show similar corruption now - but they
> > are connected to completely different buses (SATA3 bcache + 3x SATA2
> > backing store bache{0,1,2}, and USB3 without bcache = sde), use
> > different compression (compress=lzo vs. compress-force=zlib), but
> > similar redundancy scheme (draid=0,mraid=1 vs.
> > draid=single,mraid=dup). A hardware problem would induce completely
> > random errors on these pathes.
> >
> > Completely different hardware shows similar problems - but that
> > system is currently not available to me, and will stay there for a
> > while (it's a non-production installation at my workplace). Why
> > would similar errors show up here, if it'd be a hardware error of
> > the first system?  
> 
> Then there's something about the particular combination of mount
> options you're using with the workload that's inducing this, if it's
> reproducing on two different systems. What's the workload and what's
> the full history of the mount options? Looks like it started life as
> compress lzo and then later compress-force zlib and then after that
> the addition of space_cache=v2?

Still, that's two (or three) different filesystems:

The first (my main system) had compress=lzo forever, I never used
compress-force or something different than lzo.

The second (my main system backup) had compress-force=zlib forever,
never used a different compression option.

The third (the currently offline system) had compress=lzo like the
first one. It has no backup, system can be rebuild from scratch, no
important data there. I don't bother about that currently.

> Hopefully Qu has some advice on what's next. It might not be a bad
> idea to get a btrfs-image going.

I first upgraded to btrfs-progs 4.5 and removed the space_cache=v2
option (space tree has been removed, ro-incompat flag was reset
according to dmesg). I only activated that to see if it changes things,
and I made sure beforehand that this can be removed. Looks like that
works as documented.

I'll come back to the other thread as soon as I've run the check. It
takes a while (it contains a few weeks worth of snapshots). Meanwhile
I'll see if the main fs looks any different with btrfs-progs 4.5. I
need to get into dracut pre-mount for that.

At least, with space_cache=v2 removed, the delayed_refs problem there
is gone - so that code obviously has problems.

The main system didn't use space_cache=v2, tho, when the "object
already exists" problem hit me first.

I'll prepare for btrfs-image. How big is that going to be? I'd prefer
to make it as sparse as possible. I could hook it up to a 100mbit
upload but I need to get storage for that first.

-- 
Regards,
Kai

Replies to list-only preferred.

