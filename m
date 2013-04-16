Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:54357 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab3DPIQ4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 04:16:56 -0400
Date: Tue, 16 Apr 2013 10:10:23 +0200
From: Sander <sander@humilis.net>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Ochi <ochi@arcor.de>, linux-btrfs@vger.kernel.org
Subject: Re: Activating space_cache after read-only snapshots without
 space_cache have been taken
Message-ID: <20130416081023.GA24920@panda>
Reply-To: sander@humilis.net
References: <516C9B43.7040605@arcor.de>
 <20130416031141.GB22531@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130416031141.GB22531@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo wrote (ao):
> On Tue, Apr 16, 2013 at 02:28:51AM +0200, Ochi wrote:
> > The situation is the following: I have created a backup-volume to
> > which I regularly rsync a backup of my system into a subvolume.
> > After rsync'ing, I take a _read-only_ snapshot of that subvolume
> > with a timestamp added to its name.
> > 
> > Now at the time I started using this backup volume, I was _not_
> > using the space_cache mount option and two read-only snapshots were
> > taken during this time. Then I started using the space_cache option
> > and continued doing snapshots.
> > 
> > A bit later, I started having very long lags when unmounting the
> > backup volume (both during shutdown and when unmounting manually). I
> > scrubbed and fsck'd the volume but this didn't show any errors.
> > Defragmenting the root and subvolumes took a long time but didn't
> > improve the situation much.
> 
> So are you using '-o nospace_cache' when creating two RO snapshots?

No, he first created two ro snapshots, then (some time later) mounted
with nospace_cache, and then continued to take ro snapshots.

> > Now I started having the suspicion that maybe the space cache
> > possibly couldn't be written to disk for the readonly
> > subvolumes/snapshots that were created during the time when I wasn't
> > using the space_cache option, forcing the cache to be rebuilt every
> > time.
> > 
> > Clearing the cache didn't help. But when I deleted the two snapshots
> > that I think were taken during the time without the mount option,
> > the unmounting time seems to have improved considerably.
> 
> I don't know why this happens, but maybe you can observe the umount
> process's very slow behaviour by using 'cat /proc/{umount-pid}/stack'
> or 'perf top'.

AFAIUI the problem is not there anymore, but this is a good tip for the
future.

	Sander
