Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36456 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaCFT1s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 14:27:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WLdxH-0005O1-HV
	for linux-btrfs@vger.kernel.org; Thu, 06 Mar 2014 20:27:43 +0100
Received: from 63.239.65.11 ([63.239.65.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Mar 2014 20:27:43 +0100
Received: from ericsbinaryworld by 63.239.65.11 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Mar 2014 20:27:43 +0100
To: linux-btrfs@vger.kernel.org
From: Eric Mesa <ericsbinaryworld@gmail.com>
Subject: Re: Understanding btrfs and backups
Date: Thu, 6 Mar 2014 19:27:13 +0000 (UTC)
Message-ID: <loom.20140306T202159-329@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brian Wong wrote: a snapshot is different than a backup, with a snapshot
you're still accessing a read-only version of the live filesystem.  i don't
know the specifics of btrfs but if you take daily snapshots, you should be
able to restore a single file from the five-days-ago snapshot by browsing
that snapshot's directory tree and then copying the file to the live version
of the filesystem, if that makes sense.

in the snapshot case the live filesystem serves the same function as the
full backup would if you did full backups then incrementals.  the snapshots
are the incrementals of the live filesystem, only going backwards in time
whereas with backup you would take a full backup then go forward in time
with incrementals.  the filesystem takes care of making sure every snapshot
is complete.

in the snapshot case redundancy is then more important because you may not
have a bunch of full backups (i.e. full copies) lying around.  so full
backups still are useful.

--

OK, I THINK I understand things a bit better. So from the point of view of
restoring a single file, that functionality is there. Excellent. And I guess
you're saying that because the snapshots are diffs off the live system, that
I'd need a backup of the live system - ie snapshots wouldn't be enough. But
what if my first snapshot was a clone of the system at that point (as it
seems from the article) And I back that up to a separate drive. Let me
illustrate with what I plan to do exactly.

Three hard drives: A, B, and C.

Hard drives A and B - btrfs RAID-1 so that if one drive dies I can keep
using my system until the replacement for the raid arrives.

Hard drive C - gets (hourly/daily/weekly/or some combination of the above)
snapshots from the RAID. (Starting with the initial state snapshot) Each
timepoint another snapshot is copied to hard drive C. 

So in the case of a file disappearing on me or being over-written or w/e - I
reach into the directory of the snapshot that contains the file just as I
would now with the backup. 

So if that's what I'm doing, do snapshots become a way to do backups?

Thanks

