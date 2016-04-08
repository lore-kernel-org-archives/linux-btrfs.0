Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53585 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbcDHNOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 09:14:15 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive using generation number as source
Date: Fri, 08 Apr 2016 15:14:11 +0200
Message-ID: <4309812.MUa0uALYJp@merkaba>
In-Reply-To: <20160408111254.GU29474@carfax.org.uk>
References: <7303236.im7zcVY3uK@merkaba> <20160408111254.GU29474@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Freitag, 8. April 2016 11:12:54 CEST Hugo Mills wrote:
> On Fri, Apr 08, 2016 at 01:01:03PM +0200, Martin Steigerwald wrote:
> > Hello!
> > 
> > As far as I understood, for differential btrfs send/receive – I didn´t use
> > it yet – I need to keep a snapshot on the source device to then tell
> > btrfs send to send the differences between the snapshot and the current
> > state.
> > 
> > Now the BTRFS filesystems on my SSDs are often quite full, thus I do not
> > keep any snapshots except for one during rsync or borgbackup script
> > run-time.
> > 
> > Is it possible to tell btrfs send to use generation number xyz to
> > calculate
> > the difference? This way, I wouldn´t have to keep a snapshot around, I
> > believe.
> 
>    btrfs sub find-new
> 
>    BUT that will only tell you which files have been added or updated.
> It won't tell you which files have been deleted. It's also unrelated
> to send/receive, so you'd have to roll your own solution.

I am aware of this one.

> > I bet not, at the time cause -c wants a snapshot. Ah and it wants a
> > snapshot of the same state on the destination as well. Well on the
> > destination I let the script make a snapshot after the backup so…
> > what I would need is to remember the generation number of the source
> > snapshot that the script creates to backup from and then tell btrfs
> > send that generation number + the destination snapshots.
> > 
> > Well, or get larger SSDs or get rid of some data on them.
> 
>    Those are the other options, of course.

Hm, I see.

Thanks,
-- 
Martin
