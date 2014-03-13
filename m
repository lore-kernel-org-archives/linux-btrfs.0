Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:10788 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaCMXEA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 19:04:00 -0400
Received: from fuchsia.localnet (p5DE8FFB9.dip0.t-ipconnect.de [93.232.255.185])
	by smtp.strato.de (RZmta 32.27 DYNA|AUTH)
	with ESMTPSA id Q074c1q2DN3w6n7
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Fri, 14 Mar 2014 00:03:58 +0100 (CET)
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup for a raid1
Date: Fri, 14 Mar 2014 00:03:58 +0100
Message-ID: <2106363.nA97oxn4hn@fuchsia>
In-Reply-To: <0AD708D8-5380-465E-8119-DD6FDD1BF1BA@colorremedies.com>
References: <1564384.fRV1HUkfCq@fuchsia> <5491122.Fap633Kp83@fuchsia> <0AD708D8-5380-465E-8119-DD6FDD1BF1BA@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 13 March 2014 16:04:33 Chris Murphy wrote:
> On Mar 13, 2014, at 3:14 PM, Michael Schuerig 
<michael.lists@schuerig.de> wrote:
> > On Thursday 13 March 2014 14:48:55 Andrew Skretvedt wrote:
> >> On 2014-Mar-13 14:28, Hugo Mills wrote:
> >>> On Thu, Mar 13, 2014 at 08:12:44PM +0100, Michael Schuerig wrote:
> >>>> My backup use case is different from the what has been recently
> >>>> discussed in another thread. I'm trying to guard against hardware
> >>>> failure and other causes of destruction.
> >>>> 
> >>>> I have a btrfs raid1 filesystem spread over two disks. I want to
> >>>> backup this filesystem regularly and efficiently to an external
> >>>> disk (same model as the ones in the raid) in such a way that
> >>>> 
> >>>> * when one disk in the raid fails, I can substitute the backup
> >>>> and
> >>>> rebalancing from the surviving disk to the substitute only
> >>>> applies
> >>>> the missing changes.
> >>>> 
> >>>> * when the entire raid fails, I can re-build a new one from the
> >>>> backup.
> >>>> 
> >>>> The filesystem is mounted at its root and has several nested
> >>>> subvolumes and snapshots (in a .snapshots subdir on each subvol).
> > 
> > [...]
> > 
> >> I'm new; btrfs noob; completely unqualified to write intelligently
> >> on
> >> this topic, nevertheless:
> >> I understand your setup to be btrfs RAID1 with /dev/A /dev/B, and a
> >> backup device someplace /dev/C
> >> 
> >> Could you, at the time you wanted to backup the filesystem:
> >> 1) in the filesystem, break RAID1: /dev/A /dev/B <-- remove /dev/B
> >> 2) reestablish RAID1 to the backup device: /dev/A /dev/C <-- added
> >> 3) balance to effect the backup (i.e. rebuilding the RAID1 onto
> >> /dev/C) 4) break/reconnect the original devices: remove /dev/C;
> >> re-add /dev/B to the fs
> > 
> > I've thought of this but don't dare try it without approval from the
> > experts. At any rate, for being practical, this approach hinges on
> > an
> > ability to rebuild the raid1 incrementally. That is, the rebuild
> > would have to start from what already is present on disk B (or C,
> > when it is re-added). Starting from an effectively blank disk each
> > time would be prohibitive.
> > 
> > Even if this would work, I'd much prefer keeping the original raid1
> > intact and to only temporarily add another mirror: "lazy mirroring",
> > to give the thing a name.

[...]
> In the btfs device add case, you now have a three disk raid1 which is
> a whole different beast. Since this isn't n-way raid1, each disk is
> not stand alone. You're only assured data survives a one disk failure
> meaning you must have two drives.

Yes, I understand that. Unless someone convinces me that it's a bad 
idea, I keep wishing for a feature that allows to intermittently add a 
third disk to a two disk raid1 and update that disk so that it could 
replace one of the others.

> So the btrfs replace scenario might work but it seems like a bad idea.
> And overall it's a use case for which send/receive was designed
> anyway so why not just use that?

Because it's not "just". Doing it right doesn't seem trivial. For one 
thing, there are multiple subvolumes; not at the top-level but nested 
inside a root subvolume. Each of them already has snapshots of its own. 
If there already is a send/receive script that can handle such a setup 
I'll happily have a look at it.

Michael

-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/

