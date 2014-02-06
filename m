Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbaBFTth (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 14:49:37 -0500
Date: Thu, 6 Feb 2014 20:49:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_GET_DEVS
Message-ID: <20140206194935.GT1364@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390812770-11720-1-git-send-email-anand.jain@oracle.com>
 <1390812770-11720-2-git-send-email-anand.jain@oracle.com>
 <20140127084709.GK3314@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140127084709.GK3314@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 27, 2014 at 08:47:09AM +0000, Hugo Mills wrote:
> On Mon, Jan 27, 2014 at 04:52:50PM +0800, Anand Jain wrote:
> > The user land progs needs   a simple way to read
> > the raw list of disks and its parameters as
> > btrfs kernel understands it. This patch will
> > introduce BTRFS_IOC_GET_DEVS which dumps
> > every thing under fs_devices.
> > 
> > As of now btrfs-devlist uses this ioctl.
> > 
> > In the long run this ioctl would help to optimize
> > some part of btrfs-progs, mainly the current
> > btrfs filesystem show
> 
>    Just thinking out loud here, really, but can we export this
> information in /sys instead, rather than adding yet more ioctls?

I tend to agree that this belongs to sysfs, it's more flexible in case
we'll add more per-device stats, ie. one file that holds all the stats
about the device. This is also easier to use from scripts that gather
system information.

With 3.14 the sysfs interface is available, but the devices under
 /sys/fs/btrfs/<fs-uuid>/devices/...
are symlinks to the sysfs devices, so this btrfs-specific device
information has to be located in a separate directory.
