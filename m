Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:39733 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab3FRP4h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 11:56:37 -0400
Date: Tue, 18 Jun 2013 08:56:37 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: Chris Mason <chris.mason@fusionio.com>
cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: hang on 3.9, 3.10-rc5
In-Reply-To: <alpine.DEB.2.00.1306121317300.27596@cobra.newdream.net>
Message-ID: <alpine.DEB.2.00.1306180855120.27273@cobra.newdream.net>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net> <20130611162129.4914.54461@localhost.localdomain> <alpine.DEB.2.00.1306121317300.27596@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 12 Jun 2013, Sage Weil wrote:
> On Tue, 11 Jun 2013, Chris Mason wrote:
> > Quoting Sage Weil (2013-06-11 11:43:30)
> > > I'm also seeing this hang regularly with both 3.9 and 3.10-rc5.  Is this
> > > is a known problem?  In this case there is no powercycling; just a regular
> > > ceph-osd workload.
> > 
> > Everyone here is waiting for the root node, but it isn't immediately
> > clear who has the lock.  log_one_extent is the most likely suspect, but
> > I can't see how it would be scheduling with the root lock held.
> > 
> > Could you please sysrq-w?
> 
> Sorry for the slow reply; had to wait for it to reproduce again.  Attached 
> both the original dmesg output and the blocked tasks.  I'll leave the box 
> wedged this time in case there is any other info that can help.

Still seeing this hang with the latest from linus' tree.  Is there another 
tree I should try testing against?

Thanks!
sage

