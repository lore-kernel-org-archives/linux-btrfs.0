Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab2HNQvm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 12:51:42 -0400
Date: Tue, 14 Aug 2012 09:51:40 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH 1/3] btrfs: extended inode refs
Message-ID: <20120814165140.GC15159@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1344452147-19409-1-git-send-email-mfasheh@suse.de> <1344452147-19409-2-git-send-email-mfasheh@suse.de> <502A1B3B.3050804@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <502A1B3B.3050804@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2012 at 11:32:43AM +0200, Jan Schmidt wrote:
> On Wed, August 08, 2012 at 20:55 (+0200), Mark Fasheh wrote:
> > +/*
> > + * btrfs_insert_inode_extref() - Inserts an extended inode ref into a tree.
> > + *
> > + * The caller must have checked against BTRFS_LINK_MAX already.
> > + */
> > +static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
> > +				     struct btrfs_root *root,
> > +				     const char *name, int name_len,
> > +				     u64 inode_objectid, u64 ref_objectid, u64 index)
> > +{
> > +	struct btrfs_inode_extref *extref;
> > +	int ret;
> > +	int ins_len = name_len + sizeof(*extref);
> > +	unsigned long ptr;
> > +	struct btrfs_path *path;
> > +	struct btrfs_key key;
> > +	struct extent_buffer *leaf;
> > +	struct btrfs_item *item;
> > +
> > +	key.objectid = inode_objectid;
> > +	key.type = BTRFS_INODE_EXTREF_KEY;
> > +	key.offset = btrfs_extref_hash(ref_objectid, name, name_len);
> > +
> > +	path = btrfs_alloc_path();
> > +	if (!path)
> > +		return -ENOMEM;
> > +
> > +	path->leave_spinning = 1;
> > +	ret = btrfs_insert_empty_item(trans, root, path, &key,
> > +				      ins_len);
> > +	if (ret == -EEXIST) {
> > +		if (btrfs_find_name_in_ext_backref(path, name, name_len, NULL))
> > +			goto out;
> > +
> > +		btrfs_extend_item(trans, root, path, ins_len);
> > +	}
> > +	if (ret < 0)
> > +		goto out;
> 
> This doesn't look right. Did you actually test it? I haven't, but I claim that
> with this version of the patch, you won't be able to add a hash collision link.
> 
> Jeff changed btrfs_extend_item from int to void in March, so we're no longer
> setting ret there. I suggest adding "ret = 0" within the EEXIST-block.

Doh, yeah I didn't test collisions on this version of the patch (as you can
obviously see, I messed up the merge of Jeff's change).


> The rest of this patch looks good to me.

Awesome, I'll send the above as a fix to this patch series (I have at least
one other fix to send soon too)
	--Mark

--
Mark Fasheh
