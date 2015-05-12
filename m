Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850AbbELPCr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 11:02:47 -0400
Date: Tue, 12 May 2015 17:02:45 +0200
From: David Sterba <dsterba@suse.cz>
To: sam tygier <samtygier@yahoo.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check metadata redundancy
Message-ID: <20150512150245.GZ23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <mi2sgj$urs$1@ger.gmane.org>
 <20150505145432.GG5099@twin.jikos.cz>
 <mibc2f$a9$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <mibc2f$a9$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 05, 2015 at 10:18:07PM +0100, sam tygier wrote:
> On 05/05/15 15:54, David Sterba wrote:
> > On Sat, May 02, 2015 at 05:03:31PM +0100, sam tygier wrote:
> >> Currently BTRFS allows you to make bad choices of data and
> >> metadata levels. For example -d raid1 -m raid0 means you can
> >> only use half your total disk space, but will loose everything
> >> if 1 disk fails. This patch prevents you creating the situation
> >> another will be need to prevent rebalancing in to it.
> >>
> >> When making a filesystem check that metadata mode is at least
> >> as redundant as the data mode. For example don't allow:
> >> 	-d raid1 -m raid0
> > 
> > This is enforcing some policty that makes sense for some usecases, but I
> > think that the tool should be flexible enough to create any kind of raid
> > profiles. It's up to the user. I'm willing to add a warning that the
> > profiles seem fishy, but failing mkfs without any way to override that
> > is IMHO not a good thing.
> 
> There already seems to be policy in test_num_disk_vs_raid() disallowing
> DUP for multiple devices. Is there really a useful case better protected
> data than metadata?

In case of DUP/data and single device it's not a policy but lack of
implementation. And not a simple change to make it work AFAIK.

DUP/metadata on multiple devices can exist only if a new device is added
to an existing filesystem until it's balanced. Here it is a policy that
multiple devices need RAID1.

> In btrfs_balance() fs/btrfs/volumes.c, operations that reduce integrity
> require a 'force' option. Would that be a good way of handling
> questionable data/metadata combinations? If so should it overload the
> existing for option, or additional one, e.g. --force-raid-level?

I think changing the integrity is something different than the mkfs
profile setup.

The force flag prevents irreversible changes (overwriting an existing
filesystem). Overloading it for the raid profiles does not sound good to
me, it would have to be another flag. But, I still think that the user
hould be aware of the properties of the respective raid levels, so the
warning is IMHO enough.

> Otherwise I could redo it as just a warning.

Yes please.

> If wrote a similar check for rebalancing is there a way to share the
> group_profile_max_safe_loss() function between the kernel and btrfs-progs?

No, the source code is not shared now, both have to be patched
separately.
