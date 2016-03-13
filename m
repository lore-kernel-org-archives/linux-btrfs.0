Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:60566 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbcCMU4H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 16:56:07 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afD3V-00054j-Lo
	for linux-btrfs@vger.kernel.org; Sun, 13 Mar 2016 21:56:05 +0100
Date: Sun, 13 Mar 2016 21:56:05 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160313205605.GV2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <CAPmG0jbUJ8rUM4ttk3MvDPMjAV=fxqwa93Ce0s6kOLQb=3qm=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPmG0jbUJ8rUM4ttk3MvDPMjAV=fxqwa93Ce0s6kOLQb=3qm=g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2016 at 08:14:45PM +0100, Henk Slager wrote:
> On Sun, Mar 13, 2016 at 12:58 PM, Marc Haber
> <mh+linux-btrfs@zugschlus.de> wrote:
> > Hi,
> >
> > On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
> >> The alternative if this can't be fixed, is to recreate the filesystem
> >> because there's no practical way yet to migrate so many snapshots to a
> >> new file system.
> >
> > I recreated the file system on March 7, with 200 GiB in size, using
> > btrfs-tools 4.4. The snapshot-taking process has been running since
> > then, but I also regularly cleaned up. The number of snapshots on the
> > new filesystem has never exceeded 1000, with the current count being
> > at 148.
> 
> Is the snapshotting still read-write?

Yes, I want to keep the possibility to remove huge files from
snapshots that shouldnt have been on a snapshotted volume in the first
place without having to ditch the entire snapshot.

> Also, If some part of the OS or tools scans through the snapshot dirs
> every now and then with atime creation on, metadata grows without a
> real need.

I mount with noatime and nodiratime anyway, and the directory the
snapshots are mounted to (/mnt/snapshots) are excluded in
updatedb.conf. Any other idea which tool might scan filesystems and
that might not be noticed when it's running about a five digit number
of snapshots?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
