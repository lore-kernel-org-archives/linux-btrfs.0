From: Li Dongyang <lidongyang@novell.com>
Subject: Re: [PATCH] Btrfs: Batched discard support for btrfs
Date: Thu, 24 Feb 2011 10:24:45 +0800
Message-ID: <201102241024.45856.lidongyang@novell.com>
References: <201102211652.28014.lidongyang@novell.com> <alpine.LFD.2.00.1102211426200.5715@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1102211426200.5715@dhcp-27-109.brq.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, February 21, 2011 09:37:21 PM Lukas Czerner wrote:
> On Mon, 21 Feb 2011, Li Dongyang wrote:
> > Here is batched discard support for btrfs, several changes were made:
> > 
> > btrfs_test_opt(root, DISCARD) is moved from btrfs_discard_extent
> > to callers, as we still want to trim the fs even it's not mounted
> > with -o discard.
> > btrfs_discard_extent now reports errors and actual bytes trimmed to
> > callers, for EOPNOTSUPP, we will try other stripes as an extent
> > could span SSD and other drives, and we won't return error to
> > callers unless we failed with all stripes.
> > 
> > And btrfs_discard_extent calls btrfs_map_block with READ, this means
> > we won't get all stripes mapped for RAID1/DUP/RAID10, I think this
> > should be fixed, Thanks.
> 
> Hello,
> 
> First of all thanks for you effort:). I can not really comment on the
> btrfs specific code, however I have couple of comments bellow.
> 
> Btw, how did you test it ?
Thanks for mentioning trim support checking and discard_granularity, they are
added to V2, I fire fstrim from util-linux, and watch the trim command by blktrace.
> 
> Thanks!
> -Lukas
> 
> > Signed-off-by: Li Dongyang <lidongyang@novell.com>
> > ---
> > 
> >  fs/btrfs/ctree.h            |    3 +-
> >  fs/btrfs/disk-io.c          |    5 ++-
> >  fs/btrfs/extent-tree.c      |   81
> >  ++++++++++++++++++++++++++++++++++++------- fs/btrfs/free-space-cache.c
> >  |   79 +++++++++++++++++++++++++++++++++++++++++
> >  fs/btrfs/free-space-cache.h |    2 +
> >  fs/btrfs/ioctl.c            |   24 +++++++++++++
> >  6 files changed, 179 insertions(+), 15 deletions(-)
> 
> ..snip..
> 
> > diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
> > index e49ca5c..65c3b93 100644
> > --- a/fs/btrfs/free-space-cache.h
> > +++ b/fs/btrfs/free-space-cache.h
> > @@ -68,4 +68,6 @@ u64 btrfs_alloc_from_cluster(struct
> > btrfs_block_group_cache *block_group,
> > 
> >  int btrfs_return_cluster_to_free_space(
> >  
> >  			       struct btrfs_block_group_cache *block_group,
> >  			       struct btrfs_free_cluster *cluster);
> > 
> > +int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
> > +			   u64 *trimmed, u64 start, u64 end, u64 minlen);
> > 
> >  #endif
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index be2d4f6..ecd3982 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -225,6 +225,28 @@ static int btrfs_ioctl_getversion(struct file *file,
> > int __user *arg)
> > 
> >  	return put_user(inode->i_generation, arg);
> >  
> >  }
> > 
> > +static noinline int btrfs_ioctl_fitrim(struct file *file, void __user
> > *arg) +{
> > +	struct btrfs_root *root = fdentry(file)->d_sb->s_fs_info;
> > +	struct fstrim_range range;
> > +	int ret;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> 
> You might want to check whether any of the underlying device does
> actually support trim and also adjust the minlen according to the
> discard_granularity.
> 
> > +
> > +	if (copy_from_user(&range, arg, sizeof(range)))
> > +		return -EFAULT;
> > +
> > +	ret = btrfs_trim_fs(root, &range);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	if (copy_to_user(arg, &range, sizeof(range)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> > 
> >  static noinline int create_subvol(struct btrfs_root *root,
> >  
> >  				  struct dentry *dentry,
> >  				  char *name, int namelen,
> > 
> > @@ -2385,6 +2407,8 @@ long btrfs_ioctl(struct file *file, unsigned int
> > 
> >  		return btrfs_ioctl_setflags(file, argp);
> >  	
> >  	case FS_IOC_GETVERSION:
> >  		return btrfs_ioctl_getversion(file, argp);
> > 
> > +	case FITRIM:
> > +		return btrfs_ioctl_fitrim(file, argp);
> > 
> >  	case BTRFS_IOC_SNAP_CREATE:
> >  		return btrfs_ioctl_snap_create(file, argp, 0);
> >  	
> >  	case BTRFS_IOC_SNAP_CREATE_V2:
