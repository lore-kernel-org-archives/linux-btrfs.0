Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754949AbeDWNO3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 09:14:29 -0400
Date: Mon, 23 Apr 2018 15:11:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/7] btrfs: rename btrfs_flags_to_ioctl to reflect which
 flags it touches
Message-ID: <20180423131155.GU21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1524242295.git.dsterba@suse.com>
 <2f7110c081dcf9c2523de8ca5357ad7efeeba40d.1524242295.git.dsterba@suse.com>
 <3f774d5d-e756-9491-abbb-31415088644e@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3f774d5d-e756-9491-abbb-31415088644e@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 23, 2018 at 11:37:08AM +0900, Misono Tomohiro wrote:
> On 2018/04/21 2:02, David Sterba wrote:
> > Converts btrfs_inode::flags to the FS_*_FL flags.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/ioctl.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 953473f2a136..f0e6074233fa 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -105,9 +105,10 @@ static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
> >  }
> >  
> >  /*
> > - * Export inode flags to the format expected by the FS_IOC_GETFLAGS ioctl.
> > + * Export internal inode flags to the format expected by the FS_IOC_GETFLAGS
> > + * ioctl.
> >   */
> > -static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
> > +static unsigned int btrfs_inode_flags_to_fsflags(unsigned int flags)
> >  {
> >  	unsigned int iflags = 0;
> >  
> > @@ -161,7 +162,7 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
> >  static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
> >  {
> >  	struct btrfs_inode *ip = BTRFS_I(file_inode(file));
> 
> *ip here and in btrfs_ioctl_setflags() should be changed to *binode as in 1st patch?

Yeah this would be at least consistent with the 1st patch, on a second
look I'm not sure if the variable renaming should be part of the patch,
so I'll move it to another patch.
