Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36248 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab2ISIKA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 04:10:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TEFM9-0007jM-Hs
	for linux-btrfs@vger.kernel.org; Wed, 19 Sep 2012 10:10:01 +0200
Received: from 50C58B65.flatrate.dk ([80.197.139.101])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 10:10:01 +0200
Received: from casper.bang by 50C58B65.flatrate.dk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 10:10:01 +0200
To: linux-btrfs@vger.kernel.org
From: Casper Bang <casper.bang@gmail.com>
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
Date: Wed, 19 Sep 2012 08:09:47 +0000 (UTC)
Message-ID: <loom.20120919T094704-616@post.gmane.org>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com> <5058068C.4040704@oracle.com> <loom.20120919T083653-817@post.gmane.org> <CAG1y0sfmGczX1u+JApcB3Dz_gd9g=mT6JGDKkqJR5fRfSViOTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> IIRC there were some patches post-3.0 which relates to sync. If oracle
> db uses sync writes (or call sync somewhere, which it should), it
> might help to re-run the test with more recent kernel. kernel-ml
> repository might help.

Yeah there doesn't seem to be a shortage of patches coming into btrfs
 (just looking around the mailing-list) so that doesn't surprise me. 
Indeed, reading about race conditions, deadlocks and locks being held too 
long, does not serve to promote btrfs as particular production ready.

> > Ext4 starts out with a realtime to SCN ratio of about 3.4 and ends down 
around a
> > factor 2.2.
> >
> > ZFS starts out with a realtime to SCN ratio of about 7.5 and ends down 
around 
a
> > factor 4.4.
> 
> So zfsonlinux is actually faster than ext4 for that purpuse? coool !

Yes, rather amazingly fast - again, seems to us ZFS is optimized for write 
while btrfs is optimized for read.

> Just wondering, did you use "discard" option by any chance? In my
> experience it makes btrfs MUCH slower.

I actually don't remember when we added this (we started out without it), 
but I don't recall seeing a major difference. We should disable it however,
since the stupid fancy HP RAID controller refuses to pass on TRIM and Smart
commands anyway (and the propriatary HP SSD tools refuse to access 
non-enterprise HP SSD's.

