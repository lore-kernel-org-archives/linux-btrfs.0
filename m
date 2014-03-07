Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout.artfiles.de ([80.252.97.80]:56513 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaCGKNz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Mar 2014 05:13:55 -0500
Received: from [178.13.30.175] (helo=discus.localnet)
	smtp-after-pop=wir@brain-frog.de
	by mailout.artfiles.de with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80.1)
	id 1WLrmq-0004sC-RI
	for linux-btrfs@vger.kernel.org; Fri, 07 Mar 2014 11:13:53 +0100
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Understanding btrfs and backups
Date: Fri, 07 Mar 2014 11:13:51 +0100
Message-ID: <2875521.9HaU3OuHLy@discus>
In-Reply-To: <pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>
References: <loom.20140306T191655-366@post.gmane.org> <pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan, thank you for this comprehensive post. Really helpful as always!

[...]

> As for restoring, since a snapshot is a copy of the filesystem as it
> existed at that point, and the method btrfs exposes for accessing them is
> to mount that specific snapshot, to restore an individual file from a
> snapshot, you simply mount the snapshot you want somewhere and copy the
> file as it existed in that snapshot over top of your current version
> (which will have presumably already been mounted elsewhere, before you
> mounted the snapshot to retrieve the file from), then unmount the
> snapshot and go about your day. =:^)

Please, how do I list mounted snapshots only?

[...]

> 
> Since a snapshot is an image of the filesystem as it was at that
> particular point in time, and btrfs by nature copies blocks elsewhere
> when they are modified, all (well, not "all" as there's metadata like
> file owner, permissions and group, too, but that's handled the same way)
> the snapshot does is map what blocks composed each file at the time the
> snapshot was taken.

Is it correct, that e.g. ownership is recorded separately from the data 
itself, so if I would change the owner of all my files, the respective 
snapshot would only store the old owner information?

[...]

> 
> The first time you do this, there's no existing copy at the other end, so
> btrfs send sends a full copy and btrfs receive writes it out.  After
> that, the receive side has a snapshot identical to the one created on the
> send side and further btrfs send/receives to the same set simply
> duplicate the differences between the reference and the new snapshot from
> the send end to the receive end.  As with local snapshots, old ones can
> be deleted on both the send and receive ends, as long as at least one
> common reference snapshot is maintained on both ends, so diffs taken
> against the send side reference can be applied to an appropriately
> identical receive side reference, thereby updating the receive side to
> match the new read-only snapshot on the send side.

Is the receiving side a complete file system in its own right? If so, I only 
need to maintain one common reference in order to apply the received snapshot, 
right. If I would in any way get the send and receive side out of sync, such 
that they do not share a common reference any more, only the send/receive 
would fail, but I still would have the complete filesystem on the receiving 
side, and could copy it all over (cp, rscync) to the send side in case of a 
disaster on the send side. Is this correct?

Thank you!
Best,
Wolfgang

-- 
Wolfgang Mader
Wolfgang.Mader@fdm.uni-freiburg.de
Telefon: +49 (761) 203-7710
Institute of Physics
Hermann-Herder Str. 3, 79104 Freiburg, Germany
Office: 207
