Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:46157 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761966AbaGRNkL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 09:40:11 -0400
From: Russell Coker <russell@coker.com.au>
To: Sam Bull <sam.hacking@sent.com>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Questions on incremental backups
Date: Fri, 18 Jul 2014 23:40:07 +1000
Message-ID: <1483007.OXNgJN24dh@xev>
In-Reply-To: <1405688218.3085.16.camel@s-Air>
References: <1405627978.2630.39.camel@s-Air> <e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com> <1405688218.3085.16.camel@s-Air>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 18 Jul 2014 13:56:58 Sam Bull wrote:
> On ven, 2014-07-18 at 14:35 +1000, Russell Coker wrote:
> > Ignoring directories in send/recv is done by subvol. Even if you use
> > rsync it's a good idea to have different subvols for directory trees
> > with different backup requirements.
> 
> So, an inner subvol won't be backed up? If I wanted a full backup, I
> would presumably get snapshots of each subvol separately, right?

If you use btrfs send/recv then it won't get the inner subvol.  If you use 
rsync then by default it goes through the entire directory tree unless you use 
the -x option.

> > Displaying backups is an issue of backup software. It is above the
> > level that BTRFS development touches. While people here can probably
> > offer generic advice on backup software it's not the topic of the
> > list.
> 
> As said, I don't mind developing the software. But, is the required
> information easily available? Is there a way to get a diff, something
> like a list of changed/added/removed files between snapshots?

Your usual diff utility will do it.  I guess you could parse the output of 
btrfs send.

> And, finally, nobody has mentioned on the possibility of merging
> multiple snapshots into a single snapshot. Would this be possible, to
> create a snapshot that contains the most recent version of each file
> present across all of the snapshots (including files which may be
> present in only one of the snapshots)?

There is no btrfs functionality for that.  But I'm sure you could do something 
with standard Unix utilities and copying files around.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

