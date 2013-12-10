Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab3LJRgb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 12:36:31 -0500
Date: Tue, 10 Dec 2013 18:36:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Roman Mamedov <rm@romanrm.net>,
        linux-btrfs@vger.kernel.org,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH] btrfs-progs: add options to sync filesystem after subvol
 delete
Message-ID: <20131210173628.GH10658@suse.cz>
Reply-To: dsterba@suse.cz
References: <1385657947-26145-1-git-send-email-dsterba@suse.cz>
 <20131129013638.01ede78a@natsu>
 <5297F633.8090100@cn.fujitsu.com>
 <20131129173744.GP25312@suse.cz>
 <529C4CB9.8020403@cn.fujitsu.com>
 <20131209233245.GF10658@twin.jikos.cz>
 <20131210131707.16869.32138@ret>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131210131707.16869.32138@ret>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 10, 2013 at 08:17:07AM -0500, Chris Mason wrote:
> Quoting David Sterba (2013-12-09 18:32:45)
> > On Mon, Dec 02, 2013 at 05:02:49PM +0800, Wang Shilong wrote:
> > > >So an enahced interface could look like this:
> > > >
> > > >subvol delete:
> > > >--commit-each - run the ioc sync/wait ioctl after each delete ioctl
> > > >--commit-after - dtto but sync/wait after all are deleted
> > > >--wait-for-cleanup - wait until all given subvols are cleaned
> > > >
> > > >'filesystem sync' exteded to wait for subvol cleanup has following
> > > >cases:
> > > >- wait for a specific subvolume to be cleaned
> 
> It may be hard to wait for a specific subvolume from btrfs fi sync.
> You'd have to know the id, or have an interface that shows a list of ids
> currently under deletion (not a bad idea ;)

It is there, 'btrfs subvol list -d /path', but I'd rather not let
everybody parse output the output for a simple check.

> > > >- wait for all currently deleted, do not care if more subvols are
> > > >   deleted in the meantime
> > > >- wait until there are no subvolumes left to clean
> > > I think it is unnecessary to add such options for 'filesystem sync'.
> > > we may wait a long time until all subvolume deletion are finished as
> > > async subvolume deletion is implemented in cleaner thread.:-)
> > 
> > I mean that 'filesystem sync' will stay as it is now, but will be
> > enhanced with a few options to further specify what else should be
> > synced.
> 
> It's more natural to have the waiting in the subvol delete command, but
> I'm not against adding a few ways to wait in btrfs fi sync too, as long
> as they share the same core implementation.

Yeah it's natural and I guess it'll be the most frequent type of use.
I've tried to think of the possible uses so we don't miss anything
during design phase.

Knowing the ID is necessary, the subvolume path is lost at deletion
time, but let's say that the ID is available somehow, eg from
application logs.

I have a prototype for that, there's a separate subcommand to do just
the waiting for a given subvolume list id to be cleaned up (but could
be merged to fi sync if desired). It's built around the SEARCH ioctl and
does not need kernel support.
