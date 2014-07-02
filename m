Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38897 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaGBFlC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 01:41:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X2DHw-0007iq-T5
	for linux-btrfs@vger.kernel.org; Wed, 02 Jul 2014 07:41:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 07:41:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 07:41:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Corrupt filesystem after hardware failure: Scrub causes kernel
 GPF
Date: Wed, 2 Jul 2014 05:40:48 +0000 (UTC)
Message-ID: <pan$84417$648ac343$a399577a$88d87100@cox.net>
References: <53B2DF4B.4080708@fos4x.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Philipp Tölke posted on Tue, 01 Jul 2014 18:18:19 +0200 as excerpted:


> root@filer:~# btrfs fi df /home
> Data, single: total=9.61TiB, used=9.32TiB
> System, single: total=32.00MiB, used=1.04MiB
> Metadata, single: total=19.00GiB, used=17.37GiB
> unknown, single: total=512.00MiB, used=0.00
> root@filer:~# uname -a
> Linux filer 3.15-trunk-amd64 #1 SMP Debian
> 3.15.1-1~exp1 (2014-06-20) x86_64 GNU/Linux

> Doing a scrub scrubs over the first TiB of the filesystem and then
> caused this OOPS:

Well, it shouldn't GPF and there's obviously other more complex problems 
that I won't attempt to address, but as a btrfs user and list regular I 
can pick off the the low hanging fruit for you...

Btrfs scrub is designed to detect and possibly fix exactly one sort of 
problem: bad checksums.  Since btrfs does checksumming by default, btrfs 
scrub should detect bad checksums whenever the calculated checksum 
doesn't match the recorded one, but it can only /correct/ the problem if 
there's another copy of the data available that still has a /valid/ 
checksum.

And your filesystem, as reported above, is all single, data single, 
metadata single, system single, and "unknown" (kernel 3.15 split out, I 
believe it was the free-space cache-tree, into its own type, but there's 
no corresponding btrfs-progs release to label it, and it's simply listed 
as "unknown" in current userspace) single.

Single means there's only the one copy, so scrub couldn't correct any 
invalid checksums it detected anyway, altho at least it should detect 
them, and it should NOT segfault.

So as I said there's obviously a more complex problem as well, well at 
least one, but scrub wouldn't/couldn't fix anything for you anyway, since 
the only way it can fix is if there's a second copy (single-device dup 
mode or multi-device raid1/10 mode, etc), and you have single mode for 
everything so there's no further copy to checksum verify and restore the 
bad copy from, assuming checksum verification of the second.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

