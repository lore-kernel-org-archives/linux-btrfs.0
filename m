Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37742 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab2GIVwe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 17:52:34 -0400
Received: by weyx8 with SMTP id x8so1589967wey.19
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jul 2012 14:52:33 -0700 (PDT)
Date: Tue, 10 Jul 2012 00:52:34 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs fi df won't show total=
Message-ID: <20120709215234.GA1942@zambezi.lan>
References: <alpine.LNX.2.01.1207092111360.16359@frira.zrqbmnf.qr>
 <20120709192500.GG28701@carfax.org.uk>
 <alpine.LNX.2.01.1207092204450.23294@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.2.01.1207092204450.23294@frira.zrqbmnf.qr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 09, 2012 at 10:06:24PM +0200, Jan Engelhardt wrote:
> 
> On Monday 2012-07-09 21:25, Hugo Mills wrote:
> >On Mon, Jul 09, 2012 at 09:14:03PM +0200, Jan Engelhardt wrote:
> >> 
> >> On openSUSE_12.1 with Btrfs v0.19+20120406, the following can be
> >> observed: after a change of the profiles, total=,used= is no
> >> longer shown:
> >> 
> >> 20:49 mmsrv1:~ # btrfs fi df /top.srv/
> >> Data, RAID10: total=152.00GiB, used=121.07GiB
> >> System, RAID1: total=40.00MiB, used=44.00KiB
> >> System: total=4.00MiB, used=0.00
> >> Metadata, RAID1: total=112.00GiB, used=1.30GiB
> >> Metadata: total=8.00MiB, used=0.00
> >>[...]
> >> 21:10 mmsrv1:~ # btrfs fi df /top.srv/
> >> Data, RAID10: total=156.00GiB, used=124.35GiB
> >> System, RAID10: total=128.00MiB, used=48.00KiB
> >> System: total=4.00MiB, used=0.00
> >> Metadata, RAID10: total=112.00GiB, used=1.38GiB
> >
> >   What's the problem here? You no longer have any RAID1 chunks, so
> >it's not showing them.
> 
> Rather tha a 4-line output, I would have expected this 6-line output
> that I would also get when mkfs'ing a new fresh btrfs volume with
> raid10 from the start:
> 
> Data, RAID10: total=156.00GiB, used=124.35GiB
> Data: total=foo, used=bar
> System, RAID10: total=128.00MiB, used=48.00KiB
> System: total=4.00MiB, used=0.00
> Metadata, RAID10: total=112.00GiB, used=1.38GiB
> Metadata: total=foo, used=bar

mkfs creates those non-raid chunks for a pretty stupid reason, they
really shouldn't be there if you create a raid10 fs.  Balance does the
right thing and removes them.  Fixing this along with another mkfs
annoyance related to this one is on my TODO list.

Thanks,

		Ilya
