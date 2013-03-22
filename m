Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:47569 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422635Ab3CVRSW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 13:18:22 -0400
Date: Fri, 22 Mar 2013 10:18:21 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: Chris Mason <clmason@fusionio.com>
cc: Alexandre Oliva <oliva@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: corruption of active mmapped files in btrfs snapshots
In-Reply-To: <20130322142659.27874.81283@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1303220842030.30554@cobra.newdream.net>
References: <orhak8fm0u.fsf@livre.home> <20130319120940.29898.80124@localhost.localdomain> <ora9pzdwdw.fsf@livre.home> <or1ubaesrx.fsf@livre.home> <ord2utb4xx.fsf@livre.home> <20130321180614.30044.29961@localhost.localdomain> <20130321230621.30044.80640@localhost.localdomain>
 <orzjxw9f75.fsf@livre.home> <20130322120754.27874.14389@localhost.localdomain> <orobeba58l.fsf@livre.home> <20130322142659.27874.81283@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 22 Mar 2013, Chris Mason wrote:
> Quoting Alexandre Oliva (2013-03-22 10:17:30)
> > On Mar 22, 2013, Chris Mason <clmason@fusionio.com> wrote:
> > 
> > > Are you using compression in btrfs or just in leveldb?
> > 
> > btrfs lzo compression.
> 
> Perfect, I'll focus on that part of things.
> 
> > 
> > > I'd like to take snapshots out of the picture for a minute.
> > 
> > That's understandable, I guess, but I don't know that anyone has ever
> > got the problem without snapshots.  I mean, even when the master copy of
> > the database got corrupted, snapshots of the subvol containing it were
> > being taken every now and again, because that's the way ceph works.
> 
> Hopefully Sage can comment, but the basic idea is that if you snapshot a
> database file the db must participate.  If it doesn't, it really is the
> same effect as crashing the box.
> 
> Something is definitely broken if we're corrupting the source files
> (either with or without snapshots), but avoiding incomplete writes in
> the snapshot files requires synchronization with the db.

In this case, we quiesce write activity, call leveldb's sync(), take the 
snapshot, and then continue.

(FWIW, this isn't the first time we've heard about leveldb corruption, but 
in each case we've looked into the user had the btrfs compression 
enabled.... so I suspect that's the right avenue of investigation!)

sage
