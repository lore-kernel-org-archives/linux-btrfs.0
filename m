Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56026 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab3KJLO3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 06:14:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VfSyJ-0006g9-Nw
	for linux-btrfs@vger.kernel.org; Sun, 10 Nov 2013 12:14:27 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 12:14:27 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 12:14:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs might be gradually slowing the boot process
Date: Sun, 10 Nov 2013 11:14:08 +0000 (UTC)
Message-ID: <pan$4dd5e$f5631722$5803e40a$fdc51295@cox.net>
References: <527d2ee689e077.81319728@wp.pl>
	<72h1la-adf.ln1@hurikhan77.spdns.de>
	<04B39B7F-24A2-42E0-8C4A-31D710A844E6@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 09 Nov 2013 21:53:10 -0700 as excerpted:

> What's leafsize was used when making the file system? The default is now
> (as of yesterday) 16KB to avoid metadata fragmentation.

I saw the discussion of that, but two questions it didn't answer -- (1) 
what was the default size before, and (2) how do I check what I actually 
have?

The wiki mkfs.btrfs page answers the first question: 4KiB, standard page-
size.  (Of course that needs updated now.)

The same page says nodesize defaults to the same as leafsize.  Is that 
still true, or does it remain 4KiB?  Also, sectorsize defaults to 4KiB, 
but the wiki doesn't note whether it always defaults to that, or whether 
it too defaults to the same as leafsize.

And nowhere on the wiki do I see a sysadmin's level guide to how 
leafsize, nodesize and sectorsize relate to each other, nor how they 
relate to chunks or how btrfs manages chunksize.

Josef Bacik's article, "Btrfs - The Swiss Army Knife of Storage"[1], 
linked below and in the wiki articles section, does mention that nodes 
and leaves are b-tree terms, where nodes contain keys and links to the 
next level nodes or leaves, and leaves contain actual data, which helps 
somewhat.  But where do sectors fit in to this?

The same article says data chunk sizes are 1GiB by default, metadata 
256MiB, but when space starts getting tight (and how tight is tight, with 
the last full gig be allocated to a full gig data chunk or will it go 
smaller before it reserves the last fill gig?  how much before, 10 gig, 2 
gig?), does it shrink by orders of two or does it jump down from a gig to 
say 128 meg in one jump, and do data and metadata follow the same jump 
rules or not?

And hardly any of this is actually on the wiki, at least the sysadmin's 
docs (the dev docs might cover it, I'm not a dev and haven't looked that 
closely at them, but that still leaves sysadmins).

[1] http://static.usenix.org/publications/login/2012-02/openpdfs/Bacik.pdf

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

