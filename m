Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE5BC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 19:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D0A82175B
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 19:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfCVTKi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 15:10:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:33534 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726215AbfCVTKi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 15:10:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5BA3AAFAE;
        Fri, 22 Mar 2019 19:10:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 94804DA825; Fri, 22 Mar 2019 20:11:49 +0100 (CET)
Date:   Fri, 22 Mar 2019 20:11:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 1/2] btrfs: reserve space for inheriting properties
Message-ID: <20190322191149.GC10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20190207165426.15866-1-josef@toxicpanda.com>
 <20190207165426.15866-2-josef@toxicpanda.com>
 <12a76243-ae38-974b-957f-c50955d53934@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12a76243-ae38-974b-957f-c50955d53934@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 08, 2019 at 08:30:08AM +0200, Nikolay Borisov wrote:
> On 7.02.19 г. 18:54 ч., Josef Bacik wrote:
> > We've been seeing errors on our build servers related to failing to
> > inherit inode properties.  This is because we do not pre-reserve space
> > for them, instead trying to reserve space with NO_FLUSH at inheritance
> > time.  NO_FLUSH can transiently fail, but we'll still complain.  It's
> 
> Put one or two sentences describing the implications of
> BTRFS_RESERVE_NO_FLUSH. I.e that it NO_FLUSH won't try to flush current
> metadata reservation which could result in the said transient failure.
> Just to give a bit more context for someone who might be reading the
> commit message in the future.
> 
> > just an extra credit, so simply add that to the places that call

There's not term 'credit' used in btrfs, though it has probably the same
meanting as the journal credits. We should use a consistent terminology
so it's transaction item. I think I'v seen 'credit' used in the other
patch in a comment too.

> > btrfs_new_inode and call it good enough.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/inode.c | 78 ++++++++++++++++++++++----------------------------------
> >  fs/btrfs/ioctl.c | 27 ++++++++++++--------
> >  2 files changed, 46 insertions(+), 59 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 6126de9b8b9c..0da4a9d6d9fe 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -59,6 +59,14 @@ struct btrfs_dio_data {
> >  	int overwrite;
> >  };
> >  
> > +/*
> > + * 2 for inode item and ref
> > + * 2 for dir items
> > + * 1 for xattr if selinux is on
> > + * 1 for inherited properties
> > + */
> > +#define BTRFS_NEW_INODE_ITEMS 6
> 
> Rather than having scattered defines I'd much prefer if we have an enum
> and over time add all distinct reservations to that enum and change
> btrfs_start_transaction's interface to take this enum. It will be much
> more descriptive than having scattered defines.

Some of the values are calculated based on features that can be used at
that point, so I'm not sure enum would be the best thing, eg. when all
variants need to be defined. Picking a short name will become hard. OTOH
something like

items = NEW_INODE_ITEMS
if (rename_whiteout)
	items += RENAME_WHITEOUT_ITEMS

...

looks better to me.

> > +
> >  static const struct inode_operations btrfs_dir_inode_operations;
> >  static const struct inode_operations btrfs_symlink_inode_operations;
> >  static const struct inode_operations btrfs_dir_ro_inode_operations;
> > @@ -6479,12 +6487,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
> >  	u64 objectid;
> >  	u64 index = 0;
> >  
> > -	/*
> > -	 * 2 for inode item and ref
> > -	 * 2 for dir items
> > -	 * 1 for xattr if selinux is on
> > -	 */
> > -	trans = btrfs_start_transaction(root, 5);
> > +	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
> >  	if (IS_ERR(trans))
> >  		return PTR_ERR(trans);
> >  
> > @@ -6543,12 +6546,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
> >  	u64 objectid;
> >  	u64 index = 0;
> >  
> > -	/*
> > -	 * 2 for inode item and ref
> > -	 * 2 for dir items
> > -	 * 1 for xattr if selinux is on
> > -	 */
> > -	trans = btrfs_start_transaction(root, 5);
> > +	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
> >  	if (IS_ERR(trans))
> >  		return PTR_ERR(trans);
> >  
> > @@ -6695,12 +6693,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
> >  	u64 objectid = 0;
> >  	u64 index = 0;
> >  
> > -	/*
> > -	 * 2 items for inode and ref
> > -	 * 2 items for dir items
> > -	 * 1 for xattr if selinux is on
> > -	 */
> > -	trans = btrfs_start_transaction(root, 5);
> > +	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
> >  	if (IS_ERR(trans))
> >  		return PTR_ERR(trans);
> >  
> > @@ -9428,14 +9421,11 @@ static int btrfs_rename_exchange(struct inode *old_dir,
> >  		down_read(&fs_info->subvol_sem);
> >  
> >  	/*
> > -	 * We want to reserve the absolute worst case amount of items.  So if
> > -	 * both inodes are subvols and we need to unlink them then that would
> > -	 * require 4 item modifications, but if they are both normal inodes it
> > -	 * would require 5 item modifications, so we'll assume their normal
> > -	 * inodes.  So 5 * 2 is 10, plus 2 for the new links, so 12 total items
> > -	 * should cover the worst case number of items we'll modify.
> > +	 * The same math from btrfs_rename applies here, except we need an extra
> > +	 * 2 items for the new links.
> >  	 */
> > -	trans = btrfs_start_transaction(root, 12);
> > +	trans = btrfs_start_transaction(root,
> > +					(BTRFS_NEW_INODE_ITEMS << 1) + 2);
> >  	if (IS_ERR(trans)) {
> >  		ret = PTR_ERR(trans);
> >  		goto out_notrans;
> > @@ -9768,19 +9758,19 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
> >  	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
> >  		down_read(&fs_info->subvol_sem);
> >  	/*
> > -	 * We want to reserve the absolute worst case amount of items.  So if
> > -	 * both inodes are subvols and we need to unlink them then that would
> > -	 * require 4 item modifications, but if they are both normal inodes it
> > -	 * would require 5 item modifications, so we'll assume they are normal
> > -	 * inodes.  So 5 * 2 is 10, plus 1 for the new link, so 11 total items
> > -	 * should cover the worst case number of items we'll modify.
> > -	 * If our rename has the whiteout flag, we need more 5 units for the
> > -	 * new inode (1 inode item, 1 inode ref, 2 dir items and 1 xattr item
> > -	 * when selinux is enabled).
> > +	 * We want to reserve the absolute worst case amount of items.  Subvol
> > +	 * inodes don't have an inode item to worry about and don't have a
> > +	 * selinux attr, so we use the BTRFS_NEW_INODE_ITEMS counter for how
> > +	 * much it costs per inode to modify.  Worse case we'll have to mess
> > +	 * with 2 inodes, so 2 x BTRFS_NEW_INODE_ITEMS, and then we need an
> > +	 * extra reservation for the new link.
> > +	 *
> > +	 * If our rename has the whiteout flag we need a full new inode which
> > +	 * means another set of BTRFS_NEW_INODE_ITEMS.
> >  	 */
> > -	trans_num_items = 11;
> > +	trans_num_items = (BTRFS_NEW_INODE_ITEMS << 1) + 1;
> >  	if (flags & RENAME_WHITEOUT)
> > -		trans_num_items += 5;
> > +		trans_num_items += BTRFS_NEW_INODE_ITEMS;
> >  	trans = btrfs_start_transaction(root, trans_num_items);
> >  	if (IS_ERR(trans)) {
> >  		ret = PTR_ERR(trans);
> > @@ -10149,14 +10139,8 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
> >  	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info))
> >  		return -ENAMETOOLONG;
> >  
> > -	/*
> > -	 * 2 items for inode item and ref
> > -	 * 2 items for dir items
> > -	 * 1 item for updating parent inode item
> > -	 * 1 item for the inline extent item
> > -	 * 1 item for xattr if selinux is on
> > -	 */
> > -	trans = btrfs_start_transaction(root, 7);
> > +	/* 1 item for the inline extent item */
> > +	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS + 1);
> >  	if (IS_ERR(trans))
> >  		return PTR_ERR(trans);
> >  
> > @@ -10427,10 +10411,8 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
> >  	u64 index;
> >  	int ret = 0;
> >  
> > -	/*
> > -	 * 5 units required for adding orphan entry
> > -	 */
> > -	trans = btrfs_start_transaction(root, 5);
> > +	/* 1 unit required for adding orphan entry */
> > +	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS + 1);
> >  	if (IS_ERR(trans))
> >  		return PTR_ERR(trans);
> >  
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index f38a659c918c..21f8ab2d8570 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -83,6 +83,17 @@ struct btrfs_ioctl_send_args_32 {
> >  			       struct btrfs_ioctl_send_args_32)
> >  #endif
> >  
> > +/*
> > + * 1 - parent dir inode
> > + * 2 - dir entries
> > + * 1 - root item
> > + * 2 - root ref/backref
> > + * 1 - root of snapshot
> > + * 1 - UUID item
> > + * 1 - properties
> > + */
> > +#define BTRFS_NEW_ROOT_ITEMS 9
> 
> Even if you choose to have defines currently, I insist on them being
> grouped in one place e.g. ctree.h

Absolutelly, and don't overload ctree.h anymore, trasaction.h seems to
be the right place.
