Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47107 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbbLQEHE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 23:07:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a9PqH-0006sk-IP
	for linux-btrfs@vger.kernel.org; Thu, 17 Dec 2015 05:07:01 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 05:07:01 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 05:07:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
Date: Thu, 17 Dec 2015 04:06:56 +0000 (UTC)
Message-ID: <pan$7df3b$2174f8e9$efd1ab67$2dbe2f31@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
	<pan$3c463$5dc6ffa1$704b2ca2$141e65cc@cox.net>
	<5667C00B.4010100@scientia.net>
	<pan$7e682$345fe6d2$de13162d$f5ac4118@cox.net>
	<1450303141.6242.50.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 16 Dec 2015 22:59:01 +0100 as
excerpted:

> On Wed, 2015-12-09 at 16:36 +0000, Duncan wrote:
>> But... as I've pointed out in other replies, in many cases including
>> this specific one (bittorrent), applications have already had to
>> develop their own integrity management features

> Well let's move discussion upon that into the "dear developers, can we
> have notdatacow + checksumming, plz?" where I showed in one of the more
> recent threads that bittorrent seems rather to be the only thing which
> does use that per default... while on the VM image front, nothing seems
> to support it, and on the DB front, some support it, but don't use it
> per default.
> 
>> In the bittorrent case specifically, torrent chunks are already
>> checksummed, and if they don't verify upon download, the chunk is
>> thrown away and redownloaded.

> I'm not a bittorrent expert, because I don't use it, but that sounds to
> be more like the edonkey model, where - while there are checksums -
> these are only used until the download completes. Then you have the
> complete file, any checksum info thrown away, and the file again being
> "at risk" (i.e. not checksum protected).

[I'm breaking this into smaller replies again.]

Just to mention here, that I said "integrity management features", which 
includes more than checksumming.  As Austin Hemmelgarn has been pointing 
out, DBs and some VMs do COW, some DBs do checksumming or at least have 
that option, and both VMs and DBs generally do at least some level of 
consistency checking as they load.  Those are all "integrity management 
features" at some level.

As for bittorrent, I /think/ the checksums are in the torrent files 
themselves (and if I'm not mistaken, much as git, the chunks within the 
file are actually IDed by checksum, not specific position, so as long as 
the torrent is active, uploading or downloading, these will by definition 
be retained).  As long as those are retained, the checksums should be 
retained.  And ideally, people will continue to torrent the files long 
after they've finished downloading them, in which case they'll still need 
the torrent files themselves, along with the checksums info.

And for longer term storage, people really should be copying/moving their 
torrented files elsewhere, in such a way that they either eliminate the 
fragmentation if the files weren't nocowed, or eliminate the nocow 
attribute and get them checksum-protected as normal for files not 
intended to be constantly randomly rewritten, which will be the case once 
they're no longer being actively downloaded.  Of course that's at the 
slightly technically oriented user level, but then, the whole nocow 
thing, or even caring about checksums and longer term file integrity in 
the first place, is also technically oriented user level.  Normal users 
will just download without worrying about the nocow in the first place, 
and perhaps wonder why the disk is thrashing so, but not be inclined to 
do anything about it except perhaps switch back to their old filesystem, 
where it was faster and the disk didn't sound as bad.  In doing so, 
they'll either automatically get the checksuming along with the worse 
performance, or go back to a filesystem without the checksumming, and 
think it's fine as they know no different.

Meanwhile, if they do it correctly there's no window without protection, 
as the torrent file can be used to double-verify the file once moved, as 
well, before deleting it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

