Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45175 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab3EEM4J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 May 2013 08:56:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UYyU4-00041L-FF
	for linux-btrfs@vger.kernel.org; Sun, 05 May 2013 14:56:08 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 14:56:08 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 14:56:08 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: Possible to dedpulicate read-only snapshots for space-efficient
 backups
Date: Sun, 5 May 2013 12:55:54 +0000 (UTC)
Message-ID: <km5ksq$p15$1@ger.gmane.org>
References: <mjnh5a-mcf.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 05 May 2013 12:07:17 +0200, Kai Krakow wrote:
> Hey list,
> 
> I wonder if it is possible to deduplicate read-only snapshots.
> 
> Background:
> 
> I'm using an bash/rsync script[1] to backup my whole system on a nightly 
> basis to an attached USB3 drive into a scratch area, then take a snapshot of 
> this area. I'd like to have these snapshots immutable, so they should be 
> read-only.
> 
> Since rsync won't discover moved files but instead place a new copy of that 
> in the backup, I'm running the wonderful bedup application[2] to deduplicate 
> my backup drive from time to time and it almost always gains back a good 
> pile of gigabytes. The rest of storage space issues is taken care of by 
> using rsync's inplace option (although this won't cover the case of files 
> moved and changed between backup runs) and using compress-force=gzip.

> I've read about ongoing work to integrate offline (and even online) 
> deduplication into the kernel so that this process can be made atomic (and 
> even block-based instead of file-based). This would - to my understandings - 
> result in the immutable attribute no longer needed. So, given the fact above 
> and for the case read-only snapshots cannot be used for this application 
> currently, will these patches address the problem and read-only snapshots 
> could be deduplicated? Or are read-only snapshots meant to be what the name 
> suggests: Immutable, even for deduplication?

There's no deep reason read-only snapshots should keep their storage
immutable, they can be affected by raid rebalancing for example.

The current bedup restriction comes from the clone call; Mark Fasheh's
dedup ioctl[3] appears to be fine with snapshots.  The bedup integration
(in a branch) is a work in progress at the moment.  I need to fix a scan
bug, tweak parameters for the latest kernel dedup patch, remove a lot of
logic that is now unnecessary, and figure out the compatibility story.

> Regards,
> Kai
> 
> [1]: https://gist.github.com/kakra/5520370
> [2]: https://github.com/g2p/bedup

[3]: http://comments.gmane.org/gmane.comp.file-systems.btrfs/25062


