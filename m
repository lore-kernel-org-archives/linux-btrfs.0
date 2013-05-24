Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476Ab3EXSRJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 14:17:09 -0400
Date: Fri, 24 May 2013 11:17:06 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>, Josef Bacik <josef@redhat.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: [PATCH 4/4] btrfs: offline dedupe
Message-ID: <20130524181706.GA5639@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1369160908-26195-1-git-send-email-mfasheh@suse.de> <1369160908-26195-5-git-send-email-mfasheh@suse.de> <20130524140536.GQ5187@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130524140536.GQ5187@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey David, thanks again for the review! Comments are inline below.

On Fri, May 24, 2013 at 04:05:36PM +0200, David Sterba wrote:
> On Tue, May 21, 2013 at 11:28:28AM -0700, Mark Fasheh wrote:
> > +static noinline int fill_data(struct inode *inode, u64 off, u64 len,
> > +			      char **cur_buffer)
> > +{
> > +	struct page *page;
> > +	void *addr;
> > +	char *buffer;
> > +	pgoff_t index;
> > +	pgoff_t last_index;
> > +	int ret = 0;
> > +	int bytes_copied = 0;
> > +	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
> > +
> > +	buffer = kmalloc(len, GFP_NOFS);
> 
> I've looked at the caller chain and len can be as big as 1MB, this is
> likely to fail to allocate. More comments below.

Well it's there in the description that we'll do this 1MB at a time at max :)


> > @@ -2476,6 +2534,236 @@ static inline void lock_extent_range(struct inode *inode, u64 off, u64 len)
> > +static int btrfs_extent_same(struct inode *src, u64 loff, u64 len,
> > +			     struct inode *dst, u64 dst_loff)
> > +{
> > +	char *orig_buffer = NULL;
> > +	char *dst_inode_buffer = NULL;
> > +	int ret;
> > +
> > +	/*
> > +	 * btrfs_clone() can't handle extents in the same file
> > +	 * yet. Once that works, we can drop this check and replace it
> > +	 * with a check for the same inode, but overlapping extents.
> > +	 */
> > +	if (src == dst)
> > +		return -EINVAL;
> > +
> > +	btrfs_double_lock(src, loff, dst, dst_loff, len);
> > +
> 
> Let's see how fill_data is actually used:
> 
> > +	ret = fill_data(src, loff, len, &orig_buffer);
> 
> Now orig_buffer is allocated from inside fill_data
> 
> > +	ret = fill_data(dst, dst_loff, len, &dst_inode_buffer);
> 
> And again, although the buffers are just memcmp'ed:
> 
> > +	ret = memcmp(orig_buffer, dst_inode_buffer, len);
> 
> extents linked:
> 
> > +	ret = btrfs_clone(src, dst, loff, len, len, dst_loff);
> > +
> > +out:
> > +	btrfs_double_unlock(src, loff, dst, dst_loff, len);
> > +
> and thrown away, all of this to be repeated on next call of
> btrfs_extent_same:
> 
> > +	kfree(dst_inode_buffer);
> > +	kfree(orig_buffer);
> > +	return ret;
> > +}
> 
> Apart from the potential kmalloc failure, I think at least the second
> fill_data can be replaced with memcpy with orig_buffer. (Possibly both
> fill_data/memcpy could be replaced by memcmp reading from both inodes in
> parallel.)

We have to do the read (fill_data) on each inode for each iteration. The
design of this is that we only lock down the inodes when we're deduping and
then relock on the next pass. Otherwise we could be doing a ton of work
while preventing access to file data. The obvious downside is that data can
change between locks so we have to always check.

Keeping the kmalloc'd buffers around isn't a bad idea and luckily is trivial
to handle. I can just alloc them up front in the caller and pass them
through on each call.


> > +#define BTRFS_MAX_DEDUPE_LEN	(16 * 1024 * 1024)
> > +#define BTRFS_ONE_DEDUPE_LEN	(1 * 1024 * 1024)
> > +
> > +static long btrfs_ioctl_file_extent_same(struct file *file,
> > +					 void __user *argp)
> > +{
> > +	struct btrfs_ioctl_same_args *args;
> > +	struct btrfs_ioctl_same_args tmp;
> > +	struct btrfs_ioctl_same_extent_info *info;
> > +	struct inode *src = file->f_dentry->d_inode;
> > +	struct file *dst_file = NULL;
> > +	struct inode *dst;
> > +	u64 off;
> > +	u64 len;
> > +	int args_size;
> > +	int i;
> > +	int ret;
> > +	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
> 
> The ioctl is available to non-root, so an extra care should be taken to
> potentail overflows etc. I haven't spotted anything so far.


Sure. Actually, you got me thinking about some sanity checks... I need to
add at least this check:

	if (btrfs_root_readonly(root))
		return -EROFS;

which isn't in there as of now.


Also I don't really check the open mode (read, write, etc) on files passed
in. We do this in the clone ioctl and it makes sense there since data (to
the user) can change. With this ioctl though data won't ever change (even if
the underlying extent does). So I left the checks out. A part of me is
thinking we might want to be conservative to start with though and just add
those type of checks in. Basically, I figure the source should be open for
read at least and target files need write access.


> > +	if (copy_from_user(&tmp,
> > +			   (struct btrfs_ioctl_same_args __user *)argp,
> > +			   sizeof(tmp)))
> > +		return -EFAULT;
> > +
> > +	args_size = sizeof(tmp) + (tmp.dest_count *
> > +			sizeof(struct btrfs_ioctl_same_extent_info));
> 
> A minor note: computing the size like this works as long as the
> structures do not require extra padding between elements, ie the gap at
> the end of an element until alignmed start of the next element. That's
> ok now and I don't think that the compiler would use alignment larger
> than 8 bytes (ie for u64).
> 
> size of btrfs_ioctl_same_extent_info is 4x u64, and 'info' starts at 3rd
> u64 inside btrfs_ioctl_same_args.
> 
> A proposed paranoid-safety check is something like
> 
> 	struct btrfs_ioctl_same_extent_info dummy[2];
> 
> 	ASSERT(sizeof(struct btrfs_ioctl_same_extent_info)
> 		== (&dummy[1] - &dummy[0]))

Maybe BUILD_BUG_ON is even better actually. If someone messed this up the
build would catch it and we'd never even get a module with bad checks.

I'll have to think up how to catch it in that context though.


> > +
> > +	ret = 0;
> > +	for (i = 0; i < args->dest_count; i++) {
> > +		u64 dest_off;
> > +		u64 src_off;
> > +		u64 op_len;
> > +
> > +		info = &args->info[i];
> > +
> > +		dst_file = fget(info->fd);
> > +		if (!dst_file) {
> > +			printk(KERN_ERR "btrfs: invalid fd %lld\n", info->fd);
> 
> I think adding the keyword 'dedup' to the messages would make it more
> clear at which operation it happend.

Good idea.... Btw, I was actually thinking of just ditching those printks in
the next iteration of this series. We don't tend to printk as often in other
parts of the btrfs code. Any opinion on that? :)
	--Mark

--
Mark Fasheh
