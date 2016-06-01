Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbcFAVYC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 17:24:02 -0400
Date: Wed, 1 Jun 2016 14:24:01 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs: fix check_shared for fiemap ioctl
Message-ID: <20160601212400.GJ7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1464760085-12078-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160601211522.GI7633@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160601211522.GI7633@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 02:15:22PM -0700, Mark Fasheh wrote:
> > +static int ref_tree_add(struct ref_root *ref_tree, u64 root_id, u64 object_id,
> > +			u64 offset, u64 parent, int count)
> > +{
> > +	struct ref_node *node = NULL;
> > +	struct rb_node **pos = NULL;
> > +	struct rb_node *pos_parent = NULL;
> > +	int origin_count;
> > +	int ret;
> > +
> > +	if (!count)
> > +		return 0;
> > +
> > +	node = __ref_tree_search(ref_tree, &pos, &pos_parent, root_id,
> > +				 object_id, offset, parent);
> > +	if (node == NULL) {
> > +		node = kmalloc(sizeof(*node), GFP_KERNEL);
> > +		if (!node)
> > +			return -ENOMEM;
> > +
> > +		node->root_id = root_id;
> > +		node->object_id = object_id;
> > +		node->offset = offset;
> > +		node->parent = parent;
> > +		node->ref_mod = count;
> > +
> > +		ret = ref_tree_insert(ref_tree, pos, pos_parent, node);
> > +		ASSERT(!ret);
> > +		if (ret) {
> > +			kfree(node);
> > +			return ret;
> > +		}
> 
> If you put the open coded comparisons into their own function, then it
> should be trivial to call that here and we can have a 'standard' looking
> rbtree insert instead of this custom version. See the rbtree.h header for an
> example.

oops, I meant Documentation/rbtree.txt instead of include/linux/rbtree.h.
	--Mark

--
Mark Fasheh
