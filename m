Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161035Ab3CVRJB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 13:09:01 -0400
Date: Fri, 22 Mar 2013 18:08:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clmason@fusionio.com>
Cc: Alexandre Oliva <oliva@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: corruption of active mmapped files in btrfs snapshots
Message-ID: <20130322170859.GO31559@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130319120940.29898.80124@localhost.localdomain>
 <ora9pzdwdw.fsf@livre.home>
 <or1ubaesrx.fsf@livre.home>
 <ord2utb4xx.fsf@livre.home>
 <20130321180614.30044.29961@localhost.localdomain>
 <20130321230621.30044.80640@localhost.localdomain>
 <orzjxw9f75.fsf@livre.home>
 <20130322120754.27874.14389@localhost.localdomain>
 <orobeba58l.fsf@livre.home>
 <20130322142659.27874.81283@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130322142659.27874.81283@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 22, 2013 at 10:26:59AM -0400, Chris Mason wrote:
> Quoting Alexandre Oliva (2013-03-22 10:17:30)
> > On Mar 22, 2013, Chris Mason <clmason@fusionio.com> wrote:
> > 
> > > Are you using compression in btrfs or just in leveldb?
> > 
> > btrfs lzo compression.
> 
> Perfect, I'll focus on that part of things.

> > > I'd like to take snapshots out of the picture for a minute.

I've reproduced this without compression, with autodefrag on. The test
was using snapshots (ie. the unmmodified versino) and ended with

1087 blocks, 4316779 total size
snaptest.268/ca snaptest.268/db differ: char 4245170, line 16

after a few minutes.

Before that, I was running the NOSNAPS mode for many-minutes (up to 50k
rounds) without a reported problem.

There was the same 'make clean && make -j 32' kernel compilation running
in parallel, the box has 8 cpus, 4GB ram. Watching 'free' showed the
memory going up to a few gigs and down to ~130MB.


david
