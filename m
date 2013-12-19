Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab3LSQx3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 11:53:29 -0500
Date: Thu, 19 Dec 2013 17:53:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: ioctls would need unique id
Message-ID: <20131219165328.GH6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1387425992-15268-1-git-send-email-anand.jain@oracle.com>
 <20131219081908.GO11281@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131219081908.GO11281@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 19, 2013 at 08:19:08AM +0000, Hugo Mills wrote:
> On Thu, Dec 19, 2013 at 12:06:32PM +0800, Anand Jain wrote:
> > BTRFS_IOC_SET_FEATURES and BTRFS_IOC_GET_SUPPORTED_FEATURES
> > conflicts with BTRFS_IOC_GET_FEATURES
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> >  include/uapi/linux/btrfs.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> > index 7d7f776..0fe736e 100644
> > --- a/include/uapi/linux/btrfs.h
> > +++ b/include/uapi/linux/btrfs.h
> > @@ -634,9 +634,9 @@ struct btrfs_ioctl_fslist_args {
> >  					struct btrfs_ioctl_fslist_args)
> >  #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
> >  				   struct btrfs_ioctl_feature_flags)
> > -#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
> > +#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 58, \
> >  				   struct btrfs_ioctl_feature_flags[2])
> > -#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
> > +#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 59, \
> >  				   struct btrfs_ioctl_feature_flags[3])
> 
>    The ioctls are distinct as tehy are, as they have different-sized
> parameters.

We're already using the trick to distinguish the ioctls by argument
size, so it's not strictly necessary to make the main numbers different.

> Changing these numbers is changing the public interface,
> which is a big no-no.

The related feature hasn't been merged yet so it's still time to change
them.

I'd say to keep it as it is now.

david
