Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34344 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641AbcFCOjD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 10:39:03 -0400
Received: by mail-oi0-f49.google.com with SMTP id e72so129773399oib.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 07:39:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dd952b29-1bea-59e1-1857-418b86951b47@gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com> <CAGQ70YeZzDgiT_v1Z0eGcWsn8prnji30hCkyjrBg8vNziLUkiQ@mail.gmail.com>
 <dd952b29-1bea-59e1-1857-418b86951b47@gmail.com>
From: Martin <rc6encrypted@gmail.com>
Date: Fri, 3 Jun 2016 16:39:00 +0200
Message-ID: <CAGQ70YcgHWDdXv785a5wwJqCPnJBscpDR3ASchTX5gpBnYKmvA@mail.gmail.com>
Subject: Re: Recommended why to use btrfs for production?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I would say it is, but I also don't have quite as much experience with it as
> with BTRFS raid1 mode.  The one thing I do know for certain about it is that
> even if it theoretically could recover from two failed disks (ie, if they're
> from different positions in the striping of each mirror), there is no code
> to actually do so, so make sure you replace any failed disks as soon as
> possible (or at least balance the array so that you don't have a missing
> device anymore).

Ok, so that really speaks for raid1...

> Most of my systems where I would run raid10 mode are set up as BTRFS raid1
> on top of two LVM based RAID0 volumes, as this gets measurably better
> performance than BTRFS raid10 mode at the moment (I see roughly a 10-20%
> difference on my home server system), and provides the same data safety
> guarantees as well.  It's worth noting for such a setup that the current
> default block size in BTRFS is 16k except on very small filesystems, so you
> may want a larger stripe size than you would on a traditional filesystem.
>
> As far as BTRFS raid10 mode in general, there are a few things that are
> important to remember about it:
> 1. It stores exactly two copies of everything, any extra disks just add to
> the stripe length on each copy.
> 2. Because each stripe has the same number of disks as it's mirrored
> partner, the total number of disks in any chunk allocation will always be
> even, which means that if your using an odd number of disks, there will
> always be one left out of every chunk.  This has limited impact on actual
> performance usually, but can cause confusing results if you have differently
> sized disks.
> 3. BTRFS (whether using raid10, raid0, or even raid5/6) will always try to
> use as many devices as possible for a stripe.  As a result of this, the
> moment you add a new disk, the total length of all new stripes will adjust
> to fit the new configuration.  If you want maximal performance when adding
> new disks, make sure to balance the rest of the filesystem afterwards,
> otherwise any existing stripes will just stay the same size.

Those are very good things to know!
