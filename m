Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40397 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752732AbdLDOba (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 09:31:30 -0500
Date: Mon, 4 Dec 2017 15:29:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs: SETFLAGS ioctl: use helper for compression
 type conversion
Message-ID: <20171204142930.GY3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1512058075.git.dsterba@suse.com>
 <233097e27401c0f3163e7dc7c72442f50309705a.1512058075.git.dsterba@suse.com>
 <f2ae8299-098a-3e87-2a04-f1b9558043d8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f2ae8299-098a-3e87-2a04-f1b9558043d8@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 01, 2017 at 06:08:53AM +0800, Anand Jain wrote:
> 
> 
> On 12/01/2017 12:09 AM, David Sterba wrote:
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >   fs/btrfs/ioctl.c | 10 ++++------
> >   1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index e8adebc8c1b0..c41c259d9283 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -307,12 +307,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
> >   		ip->flags |= BTRFS_INODE_COMPRESS;
> >   		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
> >   
> > -		if (fs_info->compress_type == BTRFS_COMPRESS_LZO)
> > -			comp = "lzo";
> > -		else if (fs_info->compress_type == BTRFS_COMPRESS_ZLIB)
> > -			comp = "zlib";
> > -		else
> > -			comp = "zstd";
> 
>   Bit deviating from the stuff here. Looks like zstd changed the default
>   compression algo to zstd (from zlib). I remember seeing your comment
>   on that too which I thought is fixed, but now I can't locate. Shouldn't
>   this be a bug ?

It's not a bug, zlib is still the default, but proving that needs more
code for the context.

https://patchwork.kernel.org/patch/10034957/
