Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:50869 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026Ab3FRQgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 12:36:41 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 082239A03DD
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 10:36:40 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Sage Weil <sage@inktank.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <alpine.DEB.2.00.1306180855120.27273@cobra.newdream.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
 <20130611162129.4914.54461@localhost.localdomain>
 <alpine.DEB.2.00.1306121317300.27596@cobra.newdream.net>
 <alpine.DEB.2.00.1306180855120.27273@cobra.newdream.net>
Message-ID: <20130618163637.9494.34639@localhost.localdomain>
Subject: Re: hang on 3.9, 3.10-rc5
Date: Tue, 18 Jun 2013 12:36:37 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Sage Weil (2013-06-18 11:56:37)
> On Wed, 12 Jun 2013, Sage Weil wrote:
> > On Tue, 11 Jun 2013, Chris Mason wrote:
> > > Quoting Sage Weil (2013-06-11 11:43:30)
> > > > I'm also seeing this hang regularly with both 3.9 and 3.10-rc5.  Is this
> > > > is a known problem?  In this case there is no powercycling; just a regular
> > > > ceph-osd workload.
> > > 
> > > Everyone here is waiting for the root node, but it isn't immediately
> > > clear who has the lock.  log_one_extent is the most likely suspect, but
> > > I can't see how it would be scheduling with the root lock held.
> > > 
> > > Could you please sysrq-w?
> > 
> > Sorry for the slow reply; had to wait for it to reproduce again.  Attached 
> > both the original dmesg output and the blocked tasks.  I'll leave the box 
> > wedged this time in case there is any other info that can help.
> 
> Still seeing this hang with the latest from linus' tree.  Is there another 
> tree I should try testing against?

No, I don't see anything in -next that should fix this.  Trying to
reproduce here...

-chris
