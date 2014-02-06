Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681AbaBFWFg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 17:05:36 -0500
Date: Thu, 6 Feb 2014 23:05:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@libero.it>
Cc: Hugo Mills <hugo@carfax.org.uk>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_GET_DEVS
Message-ID: <20140206220535.GV1364@suse.cz>
Reply-To: dsterba@suse.cz
References: <1390812770-11720-1-git-send-email-anand.jain@oracle.com>
 <1390812770-11720-2-git-send-email-anand.jain@oracle.com>
 <20140127084709.GK3314@carfax.org.uk>
 <20140206194935.GT1364@twin.jikos.cz>
 <52F3EC15.1000508@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52F3EC15.1000508@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 06, 2014 at 09:09:57PM +0100, Goffredo Baroncelli wrote:
> > With 3.14 the sysfs interface is available, but the devices under
> >  /sys/fs/btrfs/<fs-uuid>/devices/...
> > are symlinks to the sysfs devices, so this btrfs-specific device
> > information has to be located in a separate directory.
> 
> yes please; it would scale better than the ioctl()s; anyway I suggest 1
> file per property, and not "...one file that holds all the stats
>  about the device"

Well, we can do both, I don't have a preference and both make sense.
