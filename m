Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:17291 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934802AbaDJOxm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 10:53:42 -0400
Received: from fuchsia.localnet (p57A571D5.dip0.t-ipconnect.de [87.165.113.213])
	by smtp.strato.de (RZmta 32.33 DYNA|AUTH)
	with ESMTPSA id c01a49q3AEre0rv
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Thu, 10 Apr 2014 16:53:40 +0200 (CEST)
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Copying a disk containing a btrfs filesystem
Date: Thu, 10 Apr 2014 16:53:40 +0200
Message-ID: <2372099.9RZW56XdBN@fuchsia>
In-Reply-To: <pan$90756$dc7a7f84$91c0b585$f9cdfc6f@cox.net>
References: <4783411.VVGoQz5kVU@fuchsia> <pan$90756$dc7a7f84$91c0b585$f9cdfc6f@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 10 April 2014 13:58:45 Duncan wrote:
> Michael Schuerig posted on Thu, 10 Apr 2014 15:21:01 +0200 as 
excerpted:
> > SMART indicates that my notebook disk may soon be failing (an
> > unreadable/uncorrectable sector), therefore I intend to exchange it.
> > The disk contains a single btrfs filesystem with several nested(!)
> > subvolumes, each with several read-only snapshots in a .snapshots
> > subdirectory.
> > 
> > As far as I can tell, btrfs currently does not offer a sensible way
> > to duplicate the entire contents of the old disk onto a new one. I
> > can use cp, rsync, or send/receive to copy the "main" subvolumes.
> > But unless I'm missing something obvious, the snapshots are
> > effectively lost. btrfs send optionally takes multiple clone
> > sources, but I've never seen an example of its usage.
> > 
> > If that's what "experimental" means, I'm willing to accept it.
> > However, I'd like to emphasize that there's still something
> > missing. Of course, most of all I'd like to be proved wrong.
> 
> It's not a btrfs tool, but several of the tools you mentioned aren't,
> and you didn't mention dd (or ddrescue, if your source device starts
> giving you issues while you're cloning).  Using it you'd clone the
> entire raw device, including any not yet allocated areas, in a
> straight-across bit- perfect copy.  Of course you'd need a target of
> either the same size or larger in ordered to do so...
> 
> That should give you a bit-perfect copy including the filesystem
> UUIDs, etc, which will confuse btrfs if you try to mount anything
> btrfs with both devices attached, so don't.  Do your clone, then
> umount and disconnect the old device before trying to mount the new
> one.

Thanks for pointing out dd and especially ddrescue, which I didn't know. 
I regularly use dd to copy images onto USB thumb drives, but I'm a bit 
wary regarding its use on hard disks. I've always been concerned that if 
I get another disk, not necessarily of the same make, that has nominally 
the same capacity, it still might be a few blocks smaller. Well, I just 
found one that has the right size, apparently.

Thanks again,
Michael

-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/

