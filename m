Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:59381 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323Ab2IDPMk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Sep 2012 11:12:40 -0400
Date: Tue, 4 Sep 2012 11:12:35 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] opensvc btrfs send/receive driver
Message-ID: <20120904151235.GC2358@shiny.int.fusionio.com>
References: <1346768600.27224.29.camel@lapoo.opensvc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1346768600.27224.29.camel@lapoo.opensvc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 04, 2012 at 08:23:20AM -0600, Christophe Varoqui wrote:
> Hi list,
> 
> OpenSVC >= 120904.1516 now contains a replication driver for the btrfs
> send/receive mecanism. This new driver adds up to the zfs, rsync, dds,
> netapp, datacore and drbd existing drivers.
> 
> It is no more mature than btrfs send/receive itself, so don't use in
> production clusters for now.

Great, thanks for wiring this up.

> - btrfs receive is easily confused when looking for a subvol parent id :
> for now opensvc has to mount the ID5 root vol
> on /opt/opensvc/var/btrfs/<label> and uses a flat/root-level snapshot
> hosting. If the btrfs feature matures we want to move to a .osvcsnap/
> dedicated subvol mounted in /opt/opensvc/var/btrfs/<label>.osvcnap/
> instead to not expose the whole btrfs structure. Some failure scenarios
> I tested included "receive in a subvol" and "receive in a subdir"

Yes, I'm changing the receive code to be more flexible on where it
receives things.

> 
> - some kernel stacks and hangs when off-roading (trying to delete a
> parent subvol for example) ... most on btrfs_get_token_64+0x90/0xca .
> Let me know if you are interested in the details.

Definitely interested.  There are a number of fixes for send/receive in
my send-recv branch.  These will go into the next merge window.

-chris
