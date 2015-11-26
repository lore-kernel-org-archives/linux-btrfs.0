Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38725 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbbKZX3Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 18:29:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a25yR-0001P3-DX
	for linux-btrfs@vger.kernel.org; Fri, 27 Nov 2015 00:29:11 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 00:29:11 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 00:29:11 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs: poor performance on deleting many large files
Date: Thu, 26 Nov 2015 23:29:06 +0000 (UTC)
Message-ID: <pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<pan$eea04$e9596e27$78b44461$c5754723@cox.net>
	<1448488198.4717.4.camel@gmail.com>
	<pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
	<1448562347.8809.16.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Thu, 26 Nov 2015 19:25:47 +0100 as
excerpted:

> On Thu, 2015-11-26 at 16:52 +0000, Duncan wrote:
>> For people doing snapshotting in particular, atime updates can be a big
>> part of the differences between snapshots, so it's particularly
>> important to set noatime if you're snapshotting.

> What everything happens when that is left at relatime?
> 
> I'd guess that obviously everytime the atime is updated there will be
> some CoW, but only on meta-data blocks, right?

Yes.
 
> Does this then lead to fragmentation problems in the meta-data block
> groups?

I don't believe so.  I think individual metadata elements tend to be 
small enough that several fit in a metadata node (16 KiB by default these 
days, IIRC), so there's no "metadata fragmentation" to speak of.

> And how serious are the effects on space that is eaten up... say I have
> n snapshots and access all of their files... then I'd probably get n
> times the metadata, right? Which would sound quite dramatic...
> 
> Or is just parts of the metadate copied with new atimes?

I think it's whole 4 KiB blocks and possibly whole metadata nodes (16 
KiB), copy-on-write, and these would be relatively small changes 
triggering cow of the entire block/node, aka write amplification.  While 
not too large in themselves, it's the number of them that becomes a 
problem.

IIRC relatime updates once a day on access.  If you're doing daily 
snapshots, updating metadata blocks for all files accessed in the last 24 
hours...

Again, individual snapshots aren't so much of a problem, and if you're 
thinning to the 250 snapshots per subvolume or less as I recommend, the 
problem will remain controlled, but at 250, starting at daily snapshots 
so they all have atime changes for at least all files accessed during 
that 24 hours, that's still a sizable set of unnecessarily modified and 
thus space-taking snapshotted metadata.

But I wouldn't worry about it too much if you're doing say monthly 
snapshots and only keeping a year's worth or less, 12-13 snapshots per 
subvolume total.

In my case, I'm on SSD with their limited write cycles, so while the 
snapshot thing doesn't affect me since my use-case doesn't involve 
snapshots, the SSD write cycle count thing certainly does, and noatime is 
worth it to me for that alone.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

