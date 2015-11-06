Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33724 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033352AbbKFUP7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Nov 2015 15:15:59 -0500
Received: by iodd200 with SMTP id d200so133559257iod.0
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2015 12:15:58 -0800 (PST)
Message-ID: <1446840956.3899.13.camel@kepstin.ca>
Subject: Re: Unable to allocate for space usage in particular btrfs volume
From: Calvin Walton <calvin.walton@kepstin.ca>
To: OmegaPhil <OmegaPhil@startmail.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Date: Fri, 06 Nov 2015 15:15:56 -0500
In-Reply-To: <563B3323.8080609@startmail.com>
References: <563A7452.4050202@startmail.com>
		<20151104213039.GC27446@carfax.org.uk> <563A7E45.1050806@startmail.com>
	 <pan$b856e$b1f161a7$4a31aba1$83a27ad@cox.net>
	 <563B3323.8080609@startmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2015-11-05 at 10:44 +0000, OmegaPhil wrote:
> On 05/11/15 04:18, Duncan wrote:
> > OmegaPhil posted on Wed, 04 Nov 2015 21:53:09 +0000 as excerpted:
> > VM image files (and large database files, for the same reason) are
> > a bit 
> > of a problem on btrfs, and indeed, any COW-based filesystem, since
> > the 
> > random rewrite pattern matching that use-case is pretty much the
> > absolute 
> > worst-case match for a COW-based filesystem there is.
> > Since you're not doing snapshotting (which conflicts with this
> > option, 
> > with an imperfect workaround), setting nocow on those files may
> > well 
> > eliminate the problem, but be aware if you aren't already that (1)
> > nocow 
> > does turn off checksumming as well, in ordered to avoid a race that
> > could 
> > easily lead to data corruption, and (2) you can't just activate

> So a couple of gig still unaccountable but irrelevant. Thanks,
> problem
> solved! Although hopefully checksumming will be allowed on nocow
> files
> in the future as thats currently 17% of all data unprotected and will
> get worse...

There's actually an interesting workaround to this: Although the VM
disk images aren't checksummed on the host filesystem, you can use
btrfs *inside* the VMs and enable checksumming there. The downside is
that you can only verify the VM data by booting the VM and running a
scrub from inside.

This of course doesn't help if your VMs are Windows or legacy versions
of Linux without btrfs support. On BSD you could try ZFS.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

