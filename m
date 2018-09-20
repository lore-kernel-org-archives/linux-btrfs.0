Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37012 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731091AbeITXH3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 19:07:29 -0400
Received: by mail-pl1-f193.google.com with SMTP id q5-v6so1187325pli.4
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 10:22:59 -0700 (PDT)
Date: Thu, 20 Sep 2018 10:22:57 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v8 6/6] Btrfs: support swap files
Message-ID: <20180920172257.GA26479@vader>
References: <cover.1537419652.git.osandov@fb.com>
 <0a585197abaedd39d0f6caec59ce3976f4654752.1537419652.git.osandov@fb.com>
 <20180920171541.GD5847@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180920171541.GD5847@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2018 at 07:15:41PM +0200, David Sterba wrote:
> On Wed, Sep 19, 2018 at 10:02:17PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Btrfs has not allowed swap files since commit 35054394c4b3 ("Btrfs: stop
> > providing a bmap operation to avoid swapfile corruptions"). However, now
> > that the proper restrictions are in place, Btrfs can support swap files
> > through the swap file a_ops, similar to iomap in commit 67482129cdab
> > ("iomap: add a swapfile activation function").
> > 
> > For Btrfs, activation needs to make sure that the file can be used as a
> > swap file, which currently means that it must be fully allocated as
> > nocow with no compression on one device. It must also do the proper
> > tracking so that ioctls will not interfere with the swap file.
> > Deactivation clears this tracking.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  fs/btrfs/inode.c | 317 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 317 insertions(+)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 3ea5339603cf..0586285b1d9f 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c

[snip]

> > +static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
> > +			       sector_t *span)
> > +{
> > +	struct inode *inode = file_inode(file);
> > +	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
> > +	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
> > +	struct extent_state *cached_state = NULL;
> > +	struct extent_map *em = NULL;
> > +	struct btrfs_device *device = NULL;
> > +	struct btrfs_swap_info bsi = {
> > +		.lowest_ppage = (sector_t)-1ULL,
> > +	};
> > +	int ret = 0;
> > +	u64 isize = inode->i_size;
> > +	u64 start;
> > +
> > +	/*
> > +	 * If the swap file was just created, make sure delalloc is done. If the
> > +	 * file changes again after this, the user is doing something stupid and
> > +	 * we don't really care.
> > +	 */
> > +	ret = btrfs_wait_ordered_range(inode, 0, (u64)-1);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * The inode is locked, so these flags won't change after we check them.
> > +	 */
> > +	if (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS) {
> > +		btrfs_info(fs_info, "swapfile must not be compressed");
> > +		return -EINVAL;
> > +	}
> > +	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW)) {
> > +		btrfs_info(fs_info, "swapfile must not be copy-on-write");
> > +		return -EINVAL;
> > +	}
> 
> I wonder if we should also explicitly check for the checkums flag, ie.
> that NODATASUM is present. Right now it's bound to NODATACOW, but as
> with other sanity checks, it does not hurt to have it here.
> 
> > +
> > +	/*
> > +	 * Balance or device remove/replace/resize can move stuff around from
> > +	 * under us. The EXCL_OP flag makes sure they aren't running/won't run
> > +	 * concurrently while we are mapping the swap extents, and
> > +	 * fs_info->swapfile_pins prevents them from running while the swap file
> > +	 * is active and moving the extents. Note that this also prevents a
> > +	 * concurrent device add which isn't actually necessary, but it's not
> > +	 * really worth the trouble to allow it.
> > +	 */
> > +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
> > +		return -EBUSY;
> 
> This could be also accompanied by a message, "why does not my swapfile
> activate?" -> "there's an exclusive operation running". I've checked if
> there are similar messages for the other exclusive ops. There are.

Sounds good. I addressed all of your comments and pushed to
https://github.com/osandov/linux/tree/btrfs-swap. The only thing I
didn't change was the btrfs_info about not being able to relocate an
active swapfile. I think it makes sense as btrfs_info since we already
log every block group we are relocating as info (see
describe_relocation()).
