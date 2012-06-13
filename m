Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53249 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2FMHXX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 03:23:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SehvD-0004u6-IV
	for linux-btrfs@vger.kernel.org; Wed, 13 Jun 2012 09:23:19 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 09:23:19 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 09:23:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Moving top level to a subvolume
Date: Wed, 13 Jun 2012 07:23:04 +0000 (UTC)
Message-ID: <pan.2012.06.13.07.23.04@cox.net>
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com>
	<pan.2012.06.12.01.53.23@cox.net> <1477951.uUzcAEg64Z@when>
	<CAG1y0sfRE502A1vEGyNUz9O9XdNZ+iu4bKs0=OKsWGtoSZKT_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fajar A. Nugraha posted on Wed, 13 Jun 2012 08:49:47 +0700 as excerpted:

> As for "lose their filesystems", are there recent ones that uses one of
> the three distros above, and is purely btrfs "fault"? The ones I can
> remember (from the post to this list) were broken on earlier kernels, or
> caused by bad disks.

I tried btrfs during the 3.4 cycle for a bit, and didn't lose the whole 
filesystem, but definitely found it not upto my usual standard of 
robustness, my previous and back to now filesystem, Chris's former 
project, reiserfs.

My system's old and has a bit of a problem with overheating in the 
Phoenix summer, so has been suffering SATA resets (not the disk, the sata 
chipset most likely, and/or issues with the graphics overheating since 
I'm using an AMD 8xxx chipset with AGPGART split between IOMMU for 
storage I/O and graphics) and full system freezes.

Not only did I have way more stuff disappearing or being zeroed out than 
on reiserfs (in default data=ordered mode), but in one case I had a 
segment disappear out of the middle of a file, and in another, I had 
firefox's crash-resume-file /content/ show up as what SHOULD have been an 
entirely unrelated configuration file.

Naturally I had backups to restore from, and if it wasn't for the 
freezes, it would have likely been fine, but it's exactly this sort of 
corner-case that filesystems need to be able to deal with, and what 
bothered me wasn't disappearing or zeroed out last few seconds of work 
with well documented explanations, but having random segments of files 
that I hadn't changed (whether the app was rewriting them with the same 
data's another question) in some time disappear, and having one file's 
content show up with an entirely unrelated name.  I thought that's the 
sort of thing btrfs checksums were supposed to detect and effectively 
zero out, but...

I decided that's /too/ experimental for me ATM, especially with not-quite-
stable hardware (it's worth noting that I survived bad memory and the 
related crashes on reiserfs, without /that/ sort of damage, at least not 
since data=ordered mode!), so am back on reiserfs for now, anyway.  I'll 
likely try again next year sometime...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

