Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964911AbeEJOUz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 10:20:55 -0400
Date: Thu, 10 May 2018 16:18:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        misono.tomohiro@jp.fujitsu.com
Subject: Re: [PATCH v2 5/8] btrfs: add helpers for FS_XFLAG_* conversion
Message-ID: <20180510141816.GK6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1525873677.git.dsterba@suse.com>
 <a4136c4ded65ad0c588d01357253f180ccad22f6.1525873677.git.dsterba@suse.com>
 <e6327855-66c3-f340-84f6-d09b1c305e4f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e6327855-66c3-f340-84f6-d09b1c305e4f@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 09:44:23AM +0300, Nikolay Borisov wrote:
> 
> 
> On  9.05.2018 16:54, David Sterba wrote:
> > Preparatory work for the FS_IOC_FSGETXATTR ioctl, basic conversions and
> > checking helpers.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/ioctl.c | 32 ++++++++++++++++++++++++++++++++
> >  1 file changed, 32 insertions(+)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 40eeb99310d5..54dfcb851ec2 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -338,6 +338,38 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
> >  	return ret;
> >  }
> >  
> > +/*
> > + * Translate btrfs internal inode flags to xflags as expected by the
> > + * FS_IOC_FSGETXATT ioctl. Filter only the supported ones, unknown flags are
> > + * silently dropped.
> > + */
> > +static unsigned int btrfs_inode_flags_to_xflags(unsigned int flags)
> > +{
> > +	unsigned int xflags = 0;
> > +
> > +	if (flags & BTRFS_INODE_APPEND)
> > +		xflags |= FS_XFLAG_APPEND;
> > +	if (flags & BTRFS_INODE_IMMUTABLE)
> > +		xflags |= FS_XFLAG_IMMUTABLE;
> > +	if (flags & BTRFS_INODE_NOATIME)
> > +		xflags |= FS_XFLAG_NOATIME;
> > +	if (flags & BTRFS_INODE_NODUMP)
> > +		xflags |= FS_XFLAG_NODUMP;
> > +	if (flags & BTRFS_INODE_SYNC)
> > +		xflags |= FS_XFLAG_SYNC;
> > +
> > +	return xflags;
> > +}
> 
> same suggestion as previous patch:
> 
> BTRFS_XFLAGS(ip)/btrfs_xflags(ip) (macro/function variants). Imho it
> makes sense for such function to actually take an inode. Otherwise we
> are exposing an implementation detail how we derive the iflags/xflags
> from an inode - i.e query the ->flags field. Let's keep this
> encapsulated behind whatever interface we decide.

So the inode as argument does not sound bad, I'd rather do it as a
separate patch as I don't see how to squash the prototype change into
any of the patches. The helper btrfs_inode_flags_to_xflags now follows
the style of the other helpers.
