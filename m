Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36588 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728Ab3GDRuH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jul 2013 13:50:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UunfP-0002YX-7F
	for linux-btrfs@vger.kernel.org; Thu, 04 Jul 2013 19:50:03 +0200
Received: from c-71-192-29-158.hsd1.ma.comcast.net ([71.192.29.158])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 19:50:03 +0200
Received: from kxra by c-71-192-29-158.hsd1.ma.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 19:50:03 +0200
To: linux-btrfs@vger.kernel.org
From: =?utf-8?b?S+G6j3Jh?= <kxra@fsf.org>
Subject: Re: Fractal Tree Indexing over B-Trees?
Date: Thu, 4 Jul 2013 17:48:21 +0000 (UTC)
Message-ID: <loom.20130704T194442-3@post.gmane.org>
References: <loom.20120328T160525-464@post.gmane.org>    <20120328184204.GB1941@localhost.localdomain>    <20120328185720.GC1941@localhost.localdomain>    <4F736B6F.2080805@zabbo.net>    <20120328201306.GD1941@localhost.localdomain>    <c15ca7b1e51f4bbbd2b96bf2651b72ae.squirrel@webmail.decarpentier.com>    <20120328205329.GE1941@localhost.localdomain> <f18270bffa7724e63753821b4d0d5fa0.squirrel@webmail.decarpentier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Niels de Carpentier <niels <at> decarpentier.com> writes:
> > I'd like to see how they do that.  The fact is you are still going to get
> > random
> > seeks since you have to binary search the blocks in an entire row since
> > there is
> > no way you can read a several thousand block row into memory to search it,
> > so
> > once your rows get pretty big you are doing just as much if not more
> > random io
> > as a btree.
> 
> Why? The rows are sequential on disk, so you're never doing more random
> seeks than the number of rows as long as you can search faster than the
> disk can provide data. If they indeed can limit the number of searches per
> row to a constant, it shouldn't be an issue at all.
> 
> > I don't buy that its better in the insert case either for similar reasons,
> > you
> > are talking about having to rewrite entire rows to maintain the sequential
> > nature of everything, so if you end up adding a giant row you have to go
> > and
> > write the whole thing out again, so you are talking about a lot more IO
> > than
> > with b-trees, albeit sequential.  So maybe it's a win since it's
> > sequential but
> > I wonder at what tree size that benefit no longer exists.
> 
> The worst case might be bad, but on average it should be good. I don't
> doubt it is always better on rotating disks, probably not on ssd's.
> >
> > Of course all this analysis is based on a power point presentation and
> > there may
> > be some detail I'm missing, but that's mostly my point, claiming that
> > b-trees
> > are now obsolete because we can maybe do inserts faster is just idiotic.
> 
> It's a presentation from a company, so lots of marketing. Of course it
> doesn't make btrees obsolete, it's optimized for specific cases. Like they
> say they reduce random seeks at the cost of disk bandwidth and cpu usage.
> It depends on the use case if that is useful or not. Probably not for
> btrfs, since the future will be ssd's, and meta data will generally be
> cached.
> 
> Niels
> 

I'm reviving a very old thread from here:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/16484

I found a bunch of more recent info from the company doing most of the work
behind fractal tree FS that I'd love to hear your thoughts on.

https://www.youtube.com/watch?v=c-n2LGPpQEw
http://www.tokutek.com/2013/02/mongodb-fractal-tree-indexes-high-compression
https://www.usenix.org/conference/hotstorage12/tokufs-streaming-file-system

Does this address earlier concerns at all? 

I just hope their work will be
released as unpatented GPL-compatible free software. 

