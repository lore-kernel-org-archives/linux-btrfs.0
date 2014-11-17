Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49255 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbaKQBmh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Nov 2014 20:42:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XqBKs-0004ME-38
	for linux-btrfs@vger.kernel.org; Mon, 17 Nov 2014 02:42:34 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 02:42:34 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 02:42:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Mon, 17 Nov 2014 01:42:23 +0000 (UTC)
Message-ID: <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

MegaBrutal posted on Sun, 16 Nov 2014 22:35:26 +0100 as excerpted:

> Hello guys,
> 
> I think you'll like this...
> https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1391429

UUID is an initialism for "Universally Unique IDentifier".[1]

If the UUID isn't unique, by definition, then, it can't be a UUID, and 
that's a bug in whatever is making the non-unique would-be UUID that 
isn't unique and thus cannot be a universally unique ID.  In this case 
that would appear to be LVM.

Meanwhile, if two or more devices are btrfs and have the same UUID, btrfs 
considers them part of the same filesystem, since btrfs /can/ be a multi-
device filesystem.  That's not a bug; that's the way btrfs IDs multiple 
devices as part of the same filesystem, because a UUID, by definition, 
can be relied upon to be unique, or it's no longer a UUID.  Additionally, 
the UUID is actually written into the metadata of the filesystem in such 
a way that it's /not/ a simple task to change the UUID.  Put simply, it's 
"ingrained" into the filesystem so deeply it cannot be changed, at least 
not without rewriting pretty much all the metadata.  (FWIW, a btrfs 
balance does just that, rewrite the data, metadata, or both.  However, I 
don't believe a balance plugin to change the UUID is yet available.  
You're simply not supposed to change the UUID once the filesystem is 
created.)

So if LVM snapshots duplicate a UUID, as I believe they do, then there's 
your bug, because they're breaking the definition of Universally *UNIQUE* 
ID.  That being the case, using them with btrfs is pretty essentially 
broken, because btrfs depends on UUIDs to be what they say on the label, 
actually "unique", and UUIDs are deeply enough ingrained into the very 
fabric of btrfs that it's simply not possible to change that on the btrfs 
side.

Meanwhile, since btrfs *DOES* depend on UUIDs being unique, if there's 
multiple btrfs that accidentally have the same UUID, btrfs will not 
distinguish between them and will very possibly be writing into both of 
them.  If I found myself in that situation, I'd very carefully copy all 
the data I wanted to save off the filesystem and do a new mkfs as soon as 
possible, because I would not consider the filesystem as it was at all 
stable, and I'd count myself very lucky if I got everything off the 
filesystem without damage.  In actuality, since the second device was a 
snapshot of the first, if you catch it reasonably quickly you likely 
won't have too many issues.  However, a btrfs in that condition is in an 
undefined state, and the longer it exists in that state, the more likely 
things are to go wrong, possibly VERY VERY wrong.  So if you don't 
already have backups for anything you consider valuable on that thing, 
get it off there as soon as you possibly can, and consider yourself very 
lucky if nothing's damaged as a result.

---
[1] http://en.wiktionary.org/wiki/UUID

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

