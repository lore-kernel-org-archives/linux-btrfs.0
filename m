Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35813 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbcEISUc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 14:20:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1azpn9-0002Tv-WD
	for linux-btrfs@vger.kernel.org; Mon, 09 May 2016 20:20:28 +0200
Received: from ip5f5ae06c.dynamic.kabel-deutschland.de ([95.90.224.108])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 20:20:27 +0200
Received: from hurikhan77 by ip5f5ae06c.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 20:20:27 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
Date: Mon, 9 May 2016 20:20:15 +0200
Message-ID: <20160509202015.1ed10049@jupiter.sol.kaishome.de>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
	<CAD=QJKiQb0Ryedw+52pfZ-Tp0W9O0jPqxgGqxhY7b=U+2eP3wg@mail.gmail.com>
	<20160503084814.3e355f56@jupiter.sol.kaishome.de>
	<20160505083537.0811b46f@jupiter.sol.kaishome.de>
	<20160507134010.08e50734@jupiter.sol.kaishome.de>
	<CAD=QJKjfmpb9_b3s6kh6CaAOKLRLZkD5pRryxC3R7iiuA8rvAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 9 May 2016 13:13:53 -0400
schrieb Nicholas D Steeves <nsteeves@gmail.com>:

> On May 7, 2016 7:43 AM, "Kai Krakow" <hurikhan77@gmail.com> wrote:
> >
> > Am Thu, 5 May 2016 08:35:37 +0200
> > schrieb Kai Krakow <hurikhan77@gmail.com>:
> >  
> > > Am Tue, 3 May 2016 08:48:14 +0200
> > > schrieb Kai Krakow <hurikhan77@gmail.com>:
> > >  
>  [...]  
>  [...]  
> > >  [...]  
>  [...]  
>  [...]  
> > >
> > > With the snapshot and sync related bits disabled in my script, I
> > > no longer experience freezing df/du/... commands.  
> >
> > Ah well, I still do - it just triggers much less often.
> >
> > But I can track it down to the automounter now: As soon as I stop
> > the automounter of my backup device, du/df/etc no longer hang.
> > Still I'm not sure if the problem is originating from btrfs or
> > autofs itself. 
> 
> Hi Kai,
> 
> If it's anything like what I've encountered it can be worked around
> with careful use of sleep, sync, btrfs sub sync and/or btrfs fi sync.
> Also, if it's a similar issue to my own then from what I've read on
> this list it's a timing or race issue (or maybe a locking issue).
> There's a Debian bug where someone is testing out different
> values/strategies.  The values/strategy I use can be found in
> btrfs-borg on github.  If I'm correct, you'll probably also need to
> script in delays to things time to settle with your automounter.
> 
> Of course, ideally someone will one day spend the time debugging
> what's actually going on.

Thanks for the pointer... Maybe I could just remove the idle timeout of
the automount unit, so it never tries to automatically unmount once
mounted. Tho, I prefer if it did that. I don't want the backup FS being
online all of the time.

Maybe such a race results from btrfs still doing background work (like
removing snapshots) while there is no longer a user of the mount point
running (processes terminated) - and now, when systemd's automounter
tries to unmount, it doesn't work and autofs hangs.

If I know experience hanging processes, I can simply "systemctl restart
mnt-usbdevice.automount" and the hanging processes start to work again.

-- 
Regards,
Kai

Replies to list-only preferred.

