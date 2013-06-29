Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:8834 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113Ab3F2CXL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 22:23:11 -0400
Date: Sat, 29 Jun 2013 12:22:45 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH] btrfs: fix file truncation if FALLOC_FL_KEEP_SIZE is
 specified
Message-ID: <20130629022245.GD9047@dastard>
References: <51CD1C08.40801@oracle.com>
 <20130628124100.GU4288@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130628124100.GU4288@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 28, 2013 at 08:41:00AM -0400, Josef Bacik wrote:
> On Fri, Jun 28, 2013 at 01:15:52PM +0800, Jeff Liu wrote:
> > From: Jie Liu <jeff.liu@oracle.com>
> > 
> > Create a small file and fallocate it to a big size with
> > FALLOC_FL_KEEP_SIZE option, then truncate it back to the
> > small size again, the disk free space is not changed back
> > in this case. i.e,
> > 
> > # dd if=/dev/zero of=/mnt/test bs=512 count=1
> > # ls -l /mnt
> > total 4
> > -rw-r--r-- 1 root root 512 Jun 28 11:35 test
> > 
> > # df -h
> > Filesystem      Size  Used Avail Use% Mounted on
> > ....
> > /dev/sdb1       8.0G   56K  7.2G   1% /mnt
> > 
> > # xfs_io -c 'falloc -k 512 5G' /mnt/test 
> > # ls -l /mnt/test
> > -rw-r--r-- 1 root root 512 Jun 28 11:35 /mnt/test
> > 
> > # sync; df -h
> > Filesystem      Size  Used Avail Use% Mounted on
> > ....
> > /dev/sdb1       8.0G  5.1G  2.2G  70% /mnt
> > 
> > # xfs_io -c 'truncate 512' /mnt/test
> > # sync; df -h
> > Filesystem      Size  Used Avail Use% Mounted on
> > ....
> > /dev/sdb1       8.0G  5.1G  2.2G  70% /mnt
> > 
> > With this fix, the truncated up space is back as:
> > # sync; df -h
> > Filesystem      Size  Used Avail Use% Mounted on
> > ....
> > /dev/sdb1       8.0G   56K  7.2G   1% /mnt
> > 
> > Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> > ---
> >  fs/btrfs/inode.c |    3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 4f9d16b..7e1a5ff 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -4509,9 +4509,6 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
> >  	int mask = attr->ia_valid;
> >  	int ret;
> >  
> > -	if (newsize == oldsize)
> > -		return 0;
> > -
> >  	/*
> >  	 * The regular truncate() case without ATTR_CTIME and ATTR_MTIME is a
> >  	 * special case where we need to update the times despite not having
> 
> Cc'ing a few people on this since I'd like their opinion.  Looking at other fs's
> it looks like ext4 does the same thing we do and would leave the prealloc'ed
> space, but it appears that xfs will truncate it.  What do we think is the
> correct behavior? 

XFS has had this truncate behaviour since at least the start of the
git tree history (2005). Given that these fallocate()
prealloc-blocks-beyond-EOF behaviours are modelled on what XFS has
historically provided, I think y'all can see what i think should be
done...

> I'm inclined to take this patch, but I'd like to have an
> xfstest made for it so other file systems can be made to be consistent, and I'd
> like to make sure we all agree what is the correct behavior before we wander
> down that road.  Thanks,

I couldn't have said it better myself. Jeff, can you take care of
this, please?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
