Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbcFBUan (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 16:30:43 -0400
Date: Thu, 2 Jun 2016 13:30:41 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v2] btrfs: fix check_shared for fiemap ioctl
Message-ID: <20160602203041.GR7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <7cbe0295-f6db-e810-68f7-3d51ae892e44@cn.fujitsu.com>
 <42d1c7d3-0f0c-11c3-6029-cd7c1e201c4e@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <42d1c7d3-0f0c-11c3-6029-cd7c1e201c4e@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 02, 2016 at 01:46:27PM +0800, Lu Fengqi wrote:
> 
> At 06/02/2016 05:15 AM, Mark Fasheh wrote:
> >Thanks for trying to fix this problem, comments below.
> >
> >On Wed, Jun 01, 2016 at 01:48:05PM +0800, Lu Fengqi wrote:
> >>Only in the case of different root_id or different object_id, check_shared
> >>identified extent as the shared. However, If a extent was referred by
> >>different offset of same file, it should also be identified as shared.
> >>In addition, check_shared's loop scale is at least  n^3, so if a extent
> >>has too many references,  even causes soft hang up.
> >>
> >>First, add all delayed_ref to the ref_tree and calculate the unqiue_refs,
> >>if the unique_refs is greater than one, return BACKREF_FOUND_SHARED.
> >>Then individually add the  on-disk reference(inline/keyed) to the ref_tree
> >>and calculate the unique_refs of the ref_tree to check if the unique_refs
> >>is greater than one.Because once there are two references to return
> >>SHARED, so the time complexity is close to the constant.
> >Constant time in the best case, but still n^3 in the worst case right? I'm
> >not complaining btw, I just want to be sure we're not over promising  :)
> Only in case of a large number of delayed_ref, the worst case time
> complexity will be n^2*logn. Otherwise, it will be constant even if
> there are many on-disk references.

Ahh ok so it's driven more by the # of delayed refs. That makes sense,
thanks.


> >>@@ -34,6 +35,253 @@ struct extent_inode_elem {
> >>  	struct extent_inode_elem *next;
> >>  };
> >>
> >>+/*
> >>+ * ref_root is used as the root of the ref tree that hold a collection
> >>+ * of unique references.
> >>+ */
> >>+struct ref_root {
> >>+	struct rb_root rb_root;
> >>+
> >>+	/*
> >>+	 * the unique_refs represents the number of ref_nodes with a positive
> >>+	 * count stored in the tree. Even if a ref_node(the count is greater
> >>+	 * than one) is added, the unique_refs will only increase one.
> >>+	 */
> >>+	unsigned int unique_refs;
> >>+};
> >>+
> >>+/* ref_node is used to store a unique reference to the ref tree. */
> >>+struct ref_node {
> >>+	struct rb_node rb_node;
> >>+
> >>+	/* for NORMAL_REF, otherwise all these fields should be set to 0 */
> >>+	u64 root_id;
> >>+	u64 object_id;
> >>+	u64 offset;
> >>+
> >>+	/* for SHARED_REF, otherwise parent field should be set to 0 */
> >>+	u64 parent;
> >>+
> >>+	/* ref to the ref_mod of btrfs_delayed_ref_node(delayed-ref.h) */
> >>+	int ref_mod;
> >>+};
> >Why are we mirroring so much of the backref structures here? It seems like
> >we're just throwing layers on top of layers. Can't we modify the backref
> >structures and code to handle whatever small amount of unique accounting you
> >must do?
> The original structure(struct __prelim_ref) store reference in list,
> and I have to perform many search operations that not suitable for
> list. However, if I modify the original structure, it would require
> a lot of rework. So I just want to fix fiemap with this patch. If
> necessary, we can use this structure to replace the original
> structure later.

Well there's room for an rb_node on that structure so we can solve the 'it
only uses a list' problem trivially. I definitely understand your reluctance
to modify the backref code, but to me that just sounds like we need someone
who is familiar with that code to review your work and provide advice when
needed.

Otherwise, I believe my point holds. If there's some technical reason why
this is a bad idea, that's a different story. So far though this just seems
like a situation where we need some extra review from the primary
developers. I cc'd Josef in the hopes he could shed some light for us.


> >>+/* dynamically allocate and initialize a ref_root */
> >>+static struct ref_root *ref_root_alloc(void)
> >>+{
> >>+	struct ref_root *ref_tree;
> >>+
> >>+	ref_tree = kmalloc(sizeof(*ref_tree), GFP_KERNEL);
> >I'm pretty sure we want GFP_NOFS here.
> Yes, perhaps you're right.
> >Because there's no need to narrow the allocation constraints. GFP_NOFS
> >is necessary when the caller is on a critical path that must not recurse
> >back to the filesystem through the allocation (ie. if the allocator
> >decides to free some memory and tries tro write dirty data). FIEMAP is
> >called from an ioctl.
> But David seems to have a different point of view with you, so I
> would like to ask for his advice again.

Sounds good, hopefully David and I can figure it out  :)

Thanks again Lu,
	--Mark

--
Mark Fasheh
