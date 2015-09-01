Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59090 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbbIAHSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 03:18:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZWfpU-0006e0-1Y
	for linux-btrfs@vger.kernel.org; Tue, 01 Sep 2015 09:18:04 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2015 09:17:59 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2015 09:17:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount command now shows subvol and subvolid
Date: Tue, 1 Sep 2015 07:17:53 +0000 (UTC)
Message-ID: <pan$76183$87074bc$e26a0ee$dfbc2e3a@cox.net>
References: <CAJCQCtSx8yvtbm+7i3bNtv1DaRtTAgRTdk+iMTrk5nNhssgRLQ@mail.gmail.com>
	<20150831134517.GQ11834@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Mon, 31 Aug 2015 15:45:17 +0200 as excerpted:

> On Sun, Aug 30, 2015 at 11:17:44AM -0600, Chris Murphy wrote:
>> Does anyone know when this changed? Maybe it's a 4.2 thing... anyway
>> it's very much welcome!
> 
> And another "side effect" is that /proc/self/mountinfo will report the
> mounted subvolume, even if it was an implicit mount of non-toplevel
> subvolume.

Another very nice side effect, likely accidental, but still very nice... 
is how subvol= ends up being reported for bind-mounts.

I don't use subvolumes here, but I do use multiple separate btrfs, so 
subvolid=5, subvol=/ for all of them, would be technically correct, if 
not particularly useful.  But while the subvolid=5 is indeed constant 
(and actually useful given the following), subvol= turns out to be rather 
more helpful than the / that would normally be expected.

I have a number of bind-mounts.  Formerly mount's output for these wasn't 
particularly helpful, since I ended up with a number of...

/dev/sda5 on <mountpoint> ...

... lines (/dev/sda5 being my rootfs), for instance.  The mountpoint is 
listed, but exactly what part of the filesystem is being bind-mounted 
there isn't (tho /proc/self/mountinfo does contain it).  While the 
filesystem component (/etc/bind, for instance) actually being bind-
mounted was generally what I was interested in, it wasn't actually 
displayed, and could only be indirectly derived from the mountpoint,
by looking up the mountpoint in fstab, for instance, or by using /proc/
self/mountinfo instead of the mount output or /proc/mounts.

With the new subvolume thing, despite the fact that as I said I don't use 
subvolumes so subvolume=/ would be technically correct, the subvol= now 
points at the particular component of the filesystem being bind-mounted 
at the given mountpoint.

So while I still have a bunch of /dev/sda5 on <mountpoint> lines, now the 
subvolume= bit actually tells me what's bind-mounted there, as in (sda5 
is /, sda4 is /var/log)...

/dev/sda5 on /mnt/cbind/etc/bind type btrfs (...,subvol=/etc/bind)
/dev/sda4 on /mnt/cbind/var/log/named type btrfs (...,subvol=/named)

Again, technically the subvol is actually / in both cases, since I don't 
use subvols.  And the subvolid is indeed 5, as expected.  But the 
actually reported subvol=/etc/bind is *so* much more helpful than the 
subvol=/ that I might have expected. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

