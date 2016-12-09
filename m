Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23966 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751324AbcLISlo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Dec 2016 13:41:44 -0500
Date: Fri, 9 Dec 2016 10:41:34 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/6] Btrfs: add mount option for dax
Message-ID: <20161209184134.GB28006@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
 <1481147110-20048-2-git-send-email-bo.li.liu@oracle.com>
 <20161209044720.GN4219@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161209044720.GN4219@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 09, 2016 at 03:47:20PM +1100, Dave Chinner wrote:
> On Wed, Dec 07, 2016 at 01:45:05PM -0800, Liu Bo wrote:
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/ctree.h |  1 +
> >  fs/btrfs/super.c | 40 +++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 40 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 0b8ce2b..e54c6e6 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -1317,6 +1317,7 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_root *root)
> >  #define BTRFS_MOUNT_FRAGMENT_METADATA	(1 << 25)
> >  #define BTRFS_MOUNT_FREE_SPACE_TREE	(1 << 26)
> >  #define BTRFS_MOUNT_NOLOGREPLAY		(1 << 27)
> > +#define BTRFS_MOUNT_DAX		(1 << 28)
> >  
> >  #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
> >  #define BTRFS_DEFAULT_MAX_INLINE	(2048)
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 74ed5aa..9b18f3d 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -323,7 +323,7 @@ enum {
> >  	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
> >  	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
> >  	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_usebackuproot,
> > -	Opt_nologreplay, Opt_norecovery,
> > +	Opt_nologreplay, Opt_norecovery, Opt_dax,
> 
> Can we please not create more filesystems with a DAX mount option?
> This was only even an enabler, and not meant to be a permanent
> thing. The permanent functionality for DAX is supposed to be
> per-inode inheritable DAX flags - not mount options - so that
> applications can choose on a per file basis to enable/disable DAX
> access as they see fit.
> 
> This also enables the filesystem to reject the attempt to turn on
> DAX if the set of contexts for the file are not DAX compatible....

Sounds good, I'll try to update it to use inode DAX flag directly.

Thanks,

-liubo
