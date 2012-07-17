Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:38478 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2GQLxq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 07:53:46 -0400
Date: Tue, 17 Jul 2012 13:53:34 +0200
From: David Sterba <dave@jikos.cz>
To: kreijack@inwind.it
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org,
        harald@redhat.com
Subject: Re: [PATCH] Btrfs: add DEVICE_READY ioctl
Message-ID: <20120717115334.GA11226@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1340309431-9972-1-git-send-email-jbacik@fusionio.com>
 <1340309431-9972-2-git-send-email-jbacik@fusionio.com>
 <4FE4B5A4.90603@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FE4B5A4.90603@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 22, 2012 at 08:12:52PM +0200, Goffredo Baroncelli wrote:
> On 06/21/2012 10:10 PM, Josef Bacik wrote:
> > This will be used in conjunction with btrfs device ready <dev>.  This is
> > needed for initrd's to have a nice and lightweight way to tell if all of the
> > devices needed for a file system are in the cache currently.  This keeps
> > them from having to do mount+sleep loops waiting for devices to show up.
> > Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  fs/btrfs/ioctl.h   |    3 ++-
> >  fs/btrfs/super.c   |    7 +++++++
> >  fs/btrfs/volumes.c |    9 ++++++++-
> >  fs/btrfs/volumes.h |    1 +
> >  4 files changed, 18 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> > index 497c530..34317cf 100644
> > --- a/fs/btrfs/ioctl.h
> > +++ b/fs/btrfs/ioctl.h
> > @@ -363,5 +363,6 @@ struct btrfs_ioctl_get_dev_stats {
> >  				      struct btrfs_ioctl_get_dev_stats)
> >  #define BTRFS_IOC_GET_AND_RESET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 53, \
> >  					struct btrfs_ioctl_get_dev_stats)
> > -
> > +#define BTRFS_IOC_DEVICES_READY _IOW(BTRFS_IOCTL_MAGIC, 54, \
> > +				     struct btrfs_ioctl_vol_args)
> 
> What is the purpose of the ioctl args ? This could confuses the user (as
> programmer). However IIRC for the other ioctls without argument the same
> policy was applied.Maybe a better name than btrfs_ioctl_vol_args would
> help, like btrfs_generic_ioctl.
> 
> Anyway, I suggest to return not a boolean value but a pair of integers:
> both the number of devices registered and the total number of devices.
> Better would be the dev-id found and the dev-id missing. This could help
> a lot the diagnostic of mount problem.

I thought that this could be implemented in a more generic way,
something like a DEVICE_QUERY, where we can get all sorts of details
about the particular device.

And if the device is not already discovered and cached, then the query
would simply indicate this.

> Finally I am starting to think that we should definitely switch to a
> /sys/btrfs style of interface

I'm all for a sysfs interface, having an ioctl way of retrieving
information is good, but not practical for use from scripting languages,
namely for writing tests.

There are some guys working on the sysfs patches, I did preliminary
reviews. The first step is to bring back the core sysfs support (mostly
done iirc) and then exporting various information.
I'll check what's the status.

> think something like:
> 
> /sys/btrfs/<fs-uuid>/<dev-uuid>/present
>                                size
>                                space-occuped
>                                number-of-error
>                                [...]
> 
> /sys/btrfs/<fs-uuid>/<subvolume-id>/read-only
>                                     compressed
>                                     raid-mode
>                                     path
>                                     [...]
> 
> /sys/btrfs/<fs-uuid>/label
>                      mounted
>                      read-only
>                      compressed
>                      raid-mode
>                      [...]

That's a good start for a discussion.


david
