From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: fix dentry->d_parent abuses
Date: Thu, 28 Oct 2010 02:43:33 -0400
Message-ID: <20101028064332.GA8899@dhcp231-156.rdu.redhat.com>
References: <1288190373-21381-1-git-send-email-josef@redhat.com> <1288237324.3151.17.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288237324.3151.17.camel@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 28, 2010 at 11:42:04AM +0800, Ian Kent wrote:
> On Wed, 2010-10-27 at 10:39 -0400, Josef Bacik wrote:
> > There are lots of places where we do dentry->d_parent->d_inode without holding
> > the dentry->d_lock.  This could cause problems with rename.  So instead use
> > dget_parent where we can, or in some cases we don't even need to use
> > dentry->d_parent->d_inode since we get the inode of the dir passed to us from
> > VFS.  I tested this with xfstests and my no space tests and everything turned
> > out fine.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >  fs/btrfs/file.c        |    2 ++
> >  fs/btrfs/inode.c       |   48 ++++++++++++++++++++++++------------------------
> >  fs/btrfs/ioctl.c       |   11 +++++++++--
> >  fs/btrfs/transaction.c |    5 ++++-
> >  fs/btrfs/tree-log.c    |   22 ++++++++++++++++++----
> >  5 files changed, 57 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index e354c33..6a4daa0 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -1047,8 +1047,10 @@ out:
> >  
> >  		if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
> >  			trans = btrfs_start_transaction(root, 0);
> 
> If btrfs_start_transaction() fails now the inode mutex will be held as
> well. I guess the resulting oops makes this irrelevant, ;)
> 
> Looking through the dead end BUG_ON()s in the transaction code, and
> callers, one thing I've found difficult is working out how to recover
> from IS_ERR() returns from btrfs_start_transaction() in situations like
> this.
> 
> Any chance of a patch to handle this to give me an example (well one
> case anyway) of how to do it?
>

Yup I can do that.  Recovering from some of these errors is going to be tricky,
if you are going to work on that what I had in mind was doing alot of

static foo = 0;

foo++;

if (foo % 10000)
	return (error where we used to BUG_ON());

so to be sure that all of a sudden returning an error doesn't cause an panic
farther up the callchain.
 
> > +			mutex_lock(&inode->i_mutex);
> >  			ret = btrfs_log_dentry_safe(trans, root,
> >  						    file->f_dentry);
> > +			mutex_unlock(&inode->i_mutex);
> >  			if (ret == 0) {
> >  				ret = btrfs_sync_log(trans, root);
> >  				if (ret == 0)
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 7146971..e77ee56 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -4144,6 +4144,7 @@ static int btrfs_dentry_delete(struct dentry *dentry)
> >  		if (btrfs_root_refs(&root->root_item) == 0)
> >  			return 1;
> >  	}
> > +
> >  	return 0;
> >  }
> >  
> > @@ -4627,12 +4628,12 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
> >  }
> >  
> >  static int btrfs_add_nondir(struct btrfs_trans_handle *trans,
> > -			    struct dentry *dentry, struct inode *inode,
> > -			    int backref, u64 index)
> > +			    struct inode *dir, struct dentry *dentry,
> > +			    struct inode *inode, int backref, u64 index)
> >  {
> > -	int err = btrfs_add_link(trans, dentry->d_parent->d_inode,
> > -				 inode, dentry->d_name.name,
> > -				 dentry->d_name.len, backref, index);
> > +	int err = btrfs_add_link(trans, dir, inode,
> > +				 dentry->d_name.name, dentry->d_name.len,
> > +				 backref, index);
> >  	if (!err) {
> >  		d_instantiate(dentry, inode);
> >  		return 0;
> > @@ -4673,8 +4674,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
> >  	btrfs_set_trans_block_group(trans, dir);
> >  
> >  	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
> > -				dentry->d_name.len,
> > -				dentry->d_parent->d_inode->i_ino, objectid,
> > +				dentry->d_name.len, dir->i_ino, objectid,
> >  				BTRFS_I(dir)->block_group, mode, &index);
> >  	err = PTR_ERR(inode);
> >  	if (IS_ERR(inode))
> > @@ -4687,7 +4687,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
> >  	}
> >  
> >  	btrfs_set_trans_block_group(trans, inode);
> > -	err = btrfs_add_nondir(trans, dentry, inode, 0, index);
> > +	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
> >  	if (err)
> >  		drop_inode = 1;
> >  	else {
> > @@ -4735,10 +4735,8 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
> >  	btrfs_set_trans_block_group(trans, dir);
> >  
> >  	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
> > -				dentry->d_name.len,
> > -				dentry->d_parent->d_inode->i_ino,
> > -				objectid, BTRFS_I(dir)->block_group, mode,
> > -				&index);
> > +				dentry->d_name.len, dir->i_ino, objectid,
> > +				BTRFS_I(dir)->block_group, mode, &index);
> >  	err = PTR_ERR(inode);
> >  	if (IS_ERR(inode))
> >  		goto out_unlock;
> > @@ -4750,7 +4748,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
> >  	}
> >  
> >  	btrfs_set_trans_block_group(trans, inode);
> > -	err = btrfs_add_nondir(trans, dentry, inode, 0, index);
> > +	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
> >  	if (err)
> >  		drop_inode = 1;
> >  	else {
> > @@ -4810,15 +4808,17 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
> >  	btrfs_set_trans_block_group(trans, dir);
> >  	atomic_inc(&inode->i_count);
> >  
> > -	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
> > +	err = btrfs_add_nondir(trans, dir, dentry, inode, 1, index);
> >  
> >  	if (err) {
> >  		drop_inode = 1;
> >  	} else {
> > +		struct dentry *parent = dget_parent(dentry);
> >  		btrfs_update_inode_block_group(trans, dir);
> >  		err = btrfs_update_inode(trans, root, inode);
> >  		BUG_ON(err);
> > -		btrfs_log_new_name(trans, inode, NULL, dentry->d_parent);
> > +		btrfs_log_new_name(trans, inode, NULL, parent);
> > +		dput(parent);
> >  	}
> >  
> >  	nr = trans->blocks_used;
> > @@ -4858,8 +4858,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> >  	btrfs_set_trans_block_group(trans, dir);
> >  
> >  	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
> > -				dentry->d_name.len,
> > -				dentry->d_parent->d_inode->i_ino, objectid,
> > +				dentry->d_name.len, dir->i_ino, objectid,
> >  				BTRFS_I(dir)->block_group, S_IFDIR | mode,
> >  				&index);
> >  	if (IS_ERR(inode)) {
> > @@ -4882,9 +4881,8 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> >  	if (err)
> >  		goto out_fail;
> >  
> > -	err = btrfs_add_link(trans, dentry->d_parent->d_inode,
> > -				 inode, dentry->d_name.name,
> > -				 dentry->d_name.len, 0, index);
> > +	err = btrfs_add_link(trans, dir, inode, dentry->d_name.name,
> > +			     dentry->d_name.len, 0, index);
> >  	if (err)
> >  		goto out_fail;
> >  
> > @@ -6613,8 +6611,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
> >  	BUG_ON(ret);
> >  
> >  	if (old_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
> > +		struct dentry *parent = dget_parent(new_dentry);
> > +
> >  		btrfs_log_new_name(trans, old_inode, old_dir,
> > -				   new_dentry->d_parent);
> > +				   parent);
> > +		dput(parent);
> >  		btrfs_end_log_trans(root);
> >  	}
> >  out_fail:
> > @@ -6764,8 +6765,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
> >  	btrfs_set_trans_block_group(trans, dir);
> >  
> >  	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
> > -				dentry->d_name.len,
> > -				dentry->d_parent->d_inode->i_ino, objectid,
> > +				dentry->d_name.len, dir->i_ino, objectid,
> >  				BTRFS_I(dir)->block_group, S_IFLNK|S_IRWXUGO,
> >  				&index);
> >  	err = PTR_ERR(inode);
> > @@ -6779,7 +6779,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
> >  	}
> >  
> >  	btrfs_set_trans_block_group(trans, inode);
> > -	err = btrfs_add_nondir(trans, dentry, inode, 0, index);
> > +	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
> >  	if (err)
> >  		drop_inode = 1;
> >  	else {
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index e264072..396ccd1 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -232,13 +232,17 @@ static noinline int create_subvol(struct btrfs_root *root,
> >  	struct btrfs_inode_item *inode_item;
> >  	struct extent_buffer *leaf;
> >  	struct btrfs_root *new_root;
> > -	struct inode *dir = dentry->d_parent->d_inode;
> > +	struct dentry *parent = dget_parent(dentry);
> > +	struct inode *dir;
> >  	int ret;
> >  	int err;
> >  	u64 objectid;
> >  	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
> >  	u64 index = 0;
> >  
> > +	dir = parent->d_inode;
> > +	dput(parent);
> 
> I get that parent is, well, the parent so the child were using will hold
> a reference to it and so the dput() should be safe. But, since we have
> the reference why not hold it while we use the inode to make certain the
> inode cannot go away?
>

Yeah good point, I wasn't entirely sure how to deal with these cases so I just
made something up.  I'm happy to have a more solid alternative.  Thanks for the
review, I'll fix all this up at a more reasonable hour,

Josef 
