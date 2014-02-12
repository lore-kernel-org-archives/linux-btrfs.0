Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbaBLQBZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 11:01:25 -0500
Date: Wed, 12 Feb 2014 17:01:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Anand Jain <Anand.Jain@oracle.com>,
        Goffredo Baroncelli <kreijack@libero.it>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_GET_DEVS
Message-ID: <20140212160123.GP16073@suse.cz>
Reply-To: dsterba@suse.cz
References: <1390812770-11720-1-git-send-email-anand.jain@oracle.com>
 <1390812770-11720-2-git-send-email-anand.jain@oracle.com>
 <20140127084709.GK3314@carfax.org.uk>
 <20140206194935.GT1364@twin.jikos.cz>
 <52F3EC15.1000508@libero.it>
 <20140206220535.GV1364@suse.cz>
 <52F4B0B8.2080804@oracle.com>
 <20140207102010.GE6490@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140207102010.GE6490@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 07, 2014 at 10:20:10AM +0000, Hugo Mills wrote:
> On Fri, Feb 07, 2014 at 06:08:56PM +0800, Anand Jain wrote:
> >  mainly here sysfs way defeats the purpose - debug as
> >  mentioned. Sysfs would/should show only mounted disks,
> 
>    So let's find a way of showing the "known-about" data structure
> separately from the "mounted" data structure. Just thinking aloud
> here, how about something like this:
> 
> For unmounted, but known filesystems:
> /sys/fs/btrfs/devmap/<UUID>/<symlink to device>   (for each device known)
> /sys/fs/btrfs/devmap/<UUID>/label
> /sys/fs/btrfs/devmap/<UUID>/complete      (0 if missing devices, 1 otherwise)
> /sys/fs/btrfs/devmap/<UUID>/<other properties>

I like that, the device map represents the global state maintained by the
module, does not interfere with the current sysfs structure.

One minor comment, the symlink to device should have probably a fixed
name so it can be easily located.

> And then for mounted filesystems, we can populate the <other
> properties> with more details as appropriate (and remove them when
> unmounted again). We can also add a symlink to the <UUID> directory
> for the filesystem to e.g.:
> 
> /sys/fs/btrfs/mounted/<symlink to UUID>
> 
>    If truly the *only* reason to do this is debug, then simply dump
> the info in debugfs and have done with it. However, there are good
> reasons to want to have this information in an ordinary running
> system, too. So stick with sysfs, IMO.

Agreed.

> >  the ioctl way doesn't have such a limitation (of course
> >  as I commented memory dump way would have been best choice
> >  but I got stuck with that approach if anybody wants to give
> >  a try with that approach you are most welcome).
> > 
> >  IMO no harm to have both sysfs way and ioctl way let user
> >  or developer use which were is suitable in their context.
> 
>    Extra maintenance overhead; divergence of the APIs. "You can find
> out the label of the filesystem using sysfs, but not the ioctl. You
> can find out the size of the filesystem using the ioctl, but not using
> sysfs." That way lies quite a bit of pain for the user of the
> interfaces.

I won't mind having several ways how to get the information, sysfs,
ioctl or the properties. Each way has it's own pros and cons or is
suitable for some type of user (C program, shell scripts).
