Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54115 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbaEJCC7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 22:02:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wiwcq-000571-Oo
	for linux-btrfs@vger.kernel.org; Sat, 10 May 2014 04:02:56 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 May 2014 04:02:56 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 May 2014 04:02:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
Date: Sat, 10 May 2014 02:02:44 +0000 (UTC)
Message-ID: <pan$b4b3b$cb4c25df$c163ab62$5bed98f2@cox.net>
References: <20140507233959.GB11401@merlins.org> <536AD20E.70004@fb.com>
	<20140508004344.GE11401@merlins.org> <20140508013440.GH11401@merlins.org>
	<CAKgsxVR=6GTesbtqG_SAyKnpw9pxz1TZ0oOi_MB8Ej3j4-vMiw@mail.gmail.com>
	<20140508220242.GO11401@merlins.org>
	<CAKhhfD5DTPfKvWcRDERxWa_pjfhCkZxW3WBtznYC94EFy7A0mQ@mail.gmail.com>
	<423AB9BE-EDBF-478B-8CED-C1A9A0FAE736@colorremedies.com>
	<20140509223659.GW11401@merlins.org>
	<0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com>
	<20140510010902.GQ16185@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sat, 10 May 2014 02:09:02 +0100 as excerpted:

> Life would be so much easier if filesystems didn't store any
> persistent state... :)
> 
> The number of people who don't quite get that that's the function
> and natural behaviour of a filesystem is... surprising.
> 
> As in, "Your filesystem got corruption as a result of a bug in some
> earlier version. Upgrading to the new version isn't magically going to
> make that corruption go away". (Not saying that's what's happened here,
> but it's common, and commonly misunderstood).

FWIW, this is why I'm currently doing a mkfs.btrfs and copying over from 
primary backup (an identically sized partition on the same set of 
physical devices, also btrfs, secondary backup is reiserfs on a different 
device, just in case) every few kernel cycles, perhaps twice a year or 
every eight months.

My thinking is that even if scrub/balance/btrfs-check report no problems:

a) There are new on-device filesystem features I can now take advantage 
of (at least, there have been in each of the two mkfs.btrfs cycles I've 
done so far).  And...

b) Recreating the filesystem and copying everything over new limits the 
time-window I'm exposed to old and potentially latent bugs that may have 
in fact been fixed in new deployments without every having triggered at 
the time, due to masking from some other bug or happenstance that may 
eventually go away, otherwise leaving me exposed to this strange corner-
case bug from two years or whatever ago.

I'll probably continue to do that until btrfs is considered stable, or 
even past that (tho then likely at a rather lower frequency, say every 
year to year and a half), because it's relatively easy to do with the way 
I handle backups.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

