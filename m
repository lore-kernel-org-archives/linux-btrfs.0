Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53097 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbbKXFmY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 00:42:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a16Mr-0004gO-NN
	for linux-btrfs@vger.kernel.org; Tue, 24 Nov 2015 06:42:17 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 06:42:17 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 06:42:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send reproducibly fails for a specific subvolume after
 sending 15 GiB, scrub reports no errors
Date: Tue, 24 Nov 2015 05:42:11 +0000 (UTC)
Message-ID: <pan$7e9cd$79273243$6e85efe7$7ee378ef@cox.net>
References: <56530608.50906@gmail.com>
	<20151123211012.GA12286@ny.voidptr.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nils Steinger posted on Mon, 23 Nov 2015 22:10:12 +0100 as excerpted:

> Do we anything about what might cause a filesystem to enter a state
> which `send` chokes on?
> I've only seen a small sample of the corrupted files before growing
> tired of the process and just recreating the whole thing, but all of
> them were database files (presumably SQLite). Could it be that the files
> were being written to during an unclean shutdown, leading to some kind
> of corruption of the FS? Unfortunately, I was a little triggerhappy when
> cleaning up old snapshots, so there aren't any left to aid in
> troubleshooting this problem further…

Austin's the one attempting to trace down the problem, so he'd have the 
most direct answer there.  (My use-case doesn't involve snapshotting or 
send/receive at all.)

But if any type of files would be likely to create issues, it'd be 
something like database or VM image files, since the random-file-rewrite-
pattern they typically have is in general the most problematic for copy-
on-write (COW) filesystems such as btrfs.  Without some sort of 
additional fragmentation management (like the autodefrag mount option), 
these files will end up _highly_ fragmented on btrfs, often thousands of 
fragments, tens of thousands when the files in question are multi-gig.

For the typically smallish sqlite database files, autodefrag can help 
with the fragmentation such a rewrite pattern generally triggers with 
COW, and it'd be recommended in general if all such files on the 
filesystem are smallish (quarter to a half gig or smaller), but if you're 
running large VM images, etc, autodefrag doesn't scale so well to them, 
and much more complex fragmentation management will be needed.  But 
that'd be for a different post as I don't yet know if it applies here, 
and I'm trying to keep this one short.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

