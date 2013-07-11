Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42952 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab3GKPV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 11:21:28 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 52B817C0680
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 09:21:28 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: <dsterba@suse.cz>, David Sterba <dsterba@suse.cz>,
        Mitch Harder <mitch.harder@sabayonlinux.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130710225454.GJ25386@twin.jikos.cz>
CC: Roger Pack <rogerpack2005@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CADCGFBVa42xr+4ie20GupFfZJzteihPNDnr4b_8_8UmfK_0M5w@mail.gmail.com>
 <CAKcLGm-JPT9XY7pS2Fv_G1RWXyovcYVQeO1WMR3a+DHm_PNoHg@mail.gmail.com>
 <20130710225454.GJ25386@twin.jikos.cz>
Message-ID: <20130711152126.12026.91759@localhost.localdomain>
Subject: Re: lz4 status?
Date: Thu, 11 Jul 2013 11:21:26 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-07-10 18:54:54)
> On Sun, Jun 30, 2013 at 12:35:09PM -0500, Mitch Harder wrote:
> > There's been a parallel effort to incorporate a general set of lz4
> > patches in the kernel.
> > 
> > I see these patches are currently queued up in the linux-next tree, so
> > we may see them in the 3.11 kernel.
> 
> The patches are now merged into 3.11.
> 
> > It looks like lz4 and lz4hc will be provided.
> 
> Regarding HC mode, there are some core compression code changes needed
> in order to fully utilize the its potential, namely larger chunk size
> that's compressed at a time. There was some tiny yet measurable gain of
> HC against ordinary mode compared on current 4k-at-a-time
> implementation, but the space savings did not justify the speed drop of
> HC mode.
> 
> I can't say if the patchset will be ready for 3.12 though.

The current limits on the amount of data compressed at a time and the
amount of delayed allocation sent down at a time were pulled out of the
air.  

Changes to those limits are definitely ok if they are helping specific
workloads.

-chris

