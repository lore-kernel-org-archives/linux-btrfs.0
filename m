Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52619 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaDNLue (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 07:50:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WZfPD-0003wx-Vl
	for linux-btrfs@vger.kernel.org; Mon, 14 Apr 2014 13:50:32 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 13:50:31 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 13:50:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Subvolumes and isolation
Date: Mon, 14 Apr 2014 11:50:19 +0000 (UTC)
Message-ID: <pan$83f14$2d652951$d4438311$791da6ce@cox.net>
References: <pan.2014.04.14.10.38.45@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte posted on Mon, 14 Apr 2014 10:38:45 +0000 as excerpted:

> So I'm happily using subvolumes and snapshots and was wondering about
> subvolume low-level isolation. Assuming metadata=single, would a corrupt
> metadata block in one subvolume's directory tree affect any other
> subvolumes on the same physical partition, or would the fallout from
> this bad block be contained?

This isn't an authoritative answer, but AFAIK, chunks are /not/ subvolume-
dedicated.  In fact, on the wiki, the sysadmin's guide page defines a 
snapshot as simply a subvolume that shares its data and metadata with 
some other subvolume, using btrfs' COW capabilities.  Obviously that 
would be rather difficult if subvolumes get dedicated data and metadata 
chunks, so...

That is in fact why I prefer entirely separate filesystems instead of 
simply subvolumes, and use separate (but identically sized) filesystems 
for primary backup as well -- using subvolumes there's only one 
filesystem superstructure and if it's damaged... Let's just say I'm not 
comfortable with all my data eggs in the same data basket... the one I 
might find someday the bottom just dropped out of (particularly since 
btrfs isn't fully stable yet)!

Of course the other benefit to multiple small partitions is that scrubs 
and balances are that much faster, too!  Having a balance or scrub take a 
minute or five is considerably different than having it take an hour or 
five! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

