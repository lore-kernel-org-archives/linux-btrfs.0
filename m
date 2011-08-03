From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] btrfs: do not allow mounting non-subvolumes via subvol
 option
Date: Wed, 3 Aug 2011 20:47:13 +0200
Message-ID: <20110803184713.GE28122@twin.jikos.cz>
References: <1311934448-887-1-git-send-email-dsterba@suse.cz>
 <1865303E0DED764181A9D882DEF65FB6B1A8DFC32F@shsmsx502.ccr.corp.intel.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dsterba@suse.cz>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"chris.mason@oracle.com" <chris.mason@oracle.com>
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1865303E0DED764181A9D882DEF65FB6B1A8DFC32F@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 30, 2011 at 12:16:44AM +0800, Zhong, Xin wrote:
> I believe I have submit a similar patch months ago:
> http://marc.info/?l=linux-btrfs&m=130208585106572&w=2

You did! I was not aware of that. I believe adding a helper make things
more clear (if it were used all over the code).

> Hope it can be integrated this time, :-).

mehopes too,
david

> 
> 
> > -----Original Message-----
> > From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> > owner@vger.kernel.org] On Behalf Of David Sterba
> > Sent: Friday, July 29, 2011 6:14 PM
> > To: linux-btrfs@vger.kernel.org
> > Cc: chris.mason@oracle.com; David Sterba
> > Subject: [PATCH] btrfs: do not allow mounting non-subvolumes via subvol
> > option
> > 
> > There's a missing test whether the path passed to subvol=path option
> > during mount is a real subvolume, allowing any directory located in
> > default subovlume to be passed and accepted for mount.
> > 
> > (current btrfs progs prevent this early)
> > $ btrfs subvol snapshot . p1-snap
> > ERROR: '.' is not a subvolume
> > 
> > (with "is subvolume?" test bypassed)
> > $ btrfs subvol snapshot . p1-snap
> > Create a snapshot of '.' in './p1-snap'
> > 
> > $ btrfs subvol list -p .
> > ID 258 parent 5 top level 5 path subvol
> > ID 259 parent 5 top level 5 path subvol1
> > ID 260 parent 5 top level 5 path default-subvol1
> > ID 262 parent 5 top level 5 path p1/p1-snapshot
> > ID 263 parent 259 top level 5 path subvol1/subvol1-snap
> > 
> > The problem I see is that this makes a false impression of snapshotting
> > the
> > given subvolume but in fact snapshots the default one: a user expects
> > outcome
> > like ID 263 but in fact gets ID 262 .
> > 
> > This patch makes mount fail with EINVAL with a message in syslog.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> > ---
> > 
> > I did not find a better errno than EINVAL, probably adding someting
> > like
> > ENSUBVOL would be better so that other filesystems with such
> > functionality may
> > use it in future.
> > 
> >  fs/btrfs/super.c |   19 +++++++++++++++++++
> >  1 files changed, 19 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 15634d4..0c2a1d1 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -753,6 +753,15 @@ static int btrfs_set_super(struct super_block *s,
> > void *data)
> >  	return set_anon_super(s, data);
> >  }
> > 
> > +/*
> > + * subvolumes are identified by ino 256
> > + */
> > +static inline int is_subvolume_inode(struct inode *inode)
> > +{
> > +	if (inode && inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
> > +		return 1;
> > +	return 0;
> > +}
> > 
> >  /*
> >   * Find a superblock for the given device / mount point.
> > @@ -873,6 +882,16 @@ static struct dentry *btrfs_mount(struct
> > file_system_type *fs_type, int flags,
> >  			error = -ENXIO;
> >  			goto error_free_subvol_name;
> >  		}
> > +
> > +		if (!is_subvolume_inode(new_root->d_inode)) {
> > +			dput(root);
> > +			dput(new_root);
> > +			deactivate_locked_super(s);
> > +			error = -EINVAL;
> > +			printk(KERN_ERR "btrfs: '%s' is not a valid
> > subvolume\n",
> > +					subvol_name);
> > +			goto error_free_subvol_name;
> > +		}
> >  		dput(root);
> >  		root = new_root;
> >  	} else {
> > --
> > 1.7.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
