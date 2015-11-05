Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38753 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880AbbKEESZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Nov 2015 23:18:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZuC0E-0005DA-HB
	for linux-btrfs@vger.kernel.org; Thu, 05 Nov 2015 05:18:22 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2015 05:18:17 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2015 05:18:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unable to allocate for space usage in particular btrfs volume
Date: Thu, 5 Nov 2015 04:18:11 +0000 (UTC)
Message-ID: <pan$b856e$b1f161a7$4a31aba1$83a27ad@cox.net>
References: <563A7452.4050202@startmail.com>
	<20151104213039.GC27446@carfax.org.uk> <563A7E45.1050806@startmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OmegaPhil posted on Wed, 04 Nov 2015 21:53:09 +0000 as excerpted:

> The volume doesn't change hugely over time, so it really ought not to
> have broken so quickly - a quick rundown of the storage usage:
> 
> 36% general (small files, some smallish videos)
> 24% music 23% pr0n 17% VMs
> 
> But in terms of 'large files changing', it could be the VM disks perhaps
> -
> I'll move them out, balance, and then back in again, hopefully that'd be
> a meaningful test.

VM image files (and large database files, for the same reason) are a bit 
of a problem on btrfs, and indeed, any COW-based filesystem, since the 
random rewrite pattern matching that use-case is pretty much the absolute 
worst-case match for a COW-based filesystem there is.

And that would be the worst-case in terms of the unsplit extents issue 
Hugo was talking about as well.  So they may well be the problem, indeed.

Since you're not doing snapshotting (which conflicts with this option, 
with an imperfect workaround), setting nocow on those files may well 
eliminate the problem, but be aware if you aren't already that (1) nocow 
does turn off checksumming as well, in ordered to avoid a race that could 
easily lead to data corruption, and (2) you can't just activate nocow on 
the existing file and expect it to work, the procedure is a bit more 
complicated than that, since nocow is only guaranteed to work if it's set 
at file creation.  Detailed instructions for #2 skipped as they've been 
posted many times, but if you are interested and haven't seen them, ask.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

