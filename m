Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40733 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3HFCZo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Aug 2013 22:25:44 -0400
Date: Tue, 6 Aug 2013 10:25:31 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v5 4/5] Btrfs: disable qgroups accounting when quota
 is off
Message-ID: <20130806022529.GB14277@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
 <1375285066-14173-5-git-send-email-bo.li.liu@oracle.com>
 <51FF9BD6.7000003@jan-o-sch.net>
 <20130805141817.GB10401@localhost.localdomain>
 <51FFC082.2020301@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51FFC082.2020301@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 05, 2013 at 05:10:58PM +0200, Jan Schmidt wrote:
> On Mon, August 05, 2013 at 16:18 (+0200), Liu Bo wrote:
> > On Mon, Aug 05, 2013 at 02:34:30PM +0200, Jan Schmidt wrote:
> >> Nice try hiding this one in a dedup patch set, but I finally found it :-)
> > 
> > Ahhhh, I didn't mean to ;-)
> > 
> >>
> >> On Wed, July 31, 2013 at 17:37 (+0200), Liu Bo wrote:
> >>> So we don't need to do qgroups accounting trick without enabling quota.
> >>> This reduces my tester's costing time from ~28s to ~23s.  
> >>>
> >>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >>> ---
> >>>  fs/btrfs/extent-tree.c |    6 ++++++
> >>>  fs/btrfs/qgroup.c      |    6 ++++++
> >>>  2 files changed, 12 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >>> index 10a5c72..c6612f5 100644
> >>> --- a/fs/btrfs/extent-tree.c
> >>> +++ b/fs/btrfs/extent-tree.c
> >>> @@ -2524,6 +2524,12 @@ int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
> >>>  	struct qgroup_update *qgroup_update;
> >>>  	int ret = 0;
> >>>  
> >>> +	if (!trans->root->fs_info->quota_enabled) {
> >>> +		if (trans->delayed_ref_elem.seq)
> >>> +			btrfs_put_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
> >>> +		return 0;
> >>> +	}
> >>> +
> >>>  	if (list_empty(&trans->qgroup_ref_list) !=
> >>>  	    !trans->delayed_ref_elem.seq) {
> >>>  		/* list without seq or seq without list */
> >>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> >>> index 1280eff..f3e82aa 100644
> >>> --- a/fs/btrfs/qgroup.c
> >>> +++ b/fs/btrfs/qgroup.c
> >>> @@ -1200,6 +1200,9 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
> >>>  {
> >>>  	struct qgroup_update *u;
> >>>  
> >>> +	if (!trans->root->fs_info->quota_enabled)
> >>> +		return 0;
> >>> +
> >>>  	BUG_ON(!trans->delayed_ref_elem.seq);
> >>>  	u = kmalloc(sizeof(*u), GFP_NOFS);
> >>>  	if (!u)
> >>> @@ -1850,6 +1853,9 @@ out:
> >>>  
> >>>  void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
> >>>  {
> >>> +	if (!trans->root->fs_info->quota_enabled)
> >>> +		return;
> >>> +
> >>>  	if (list_empty(&trans->qgroup_ref_list) && !trans->delayed_ref_elem.seq)
> >>>  		return;
> >>>  	pr_err("btrfs: qgroups not uptodate in trans handle %p: list is%s empty, seq is %#x.%x\n",
> >>>
> >>
> >> The second hunk looks sensible at first sight. However, hunk 1 and 3 don't. They
> >> assert consistency of qgroup state in well defined places. The fact that you
> >> need to disable those checks shows that skipping addition to the list in the
> >> second hunk cannot be right, or at least not sufficient.
> > 
> > I agree, only hunk 2 is necessary.
> > 
> >>
> >> We've got the list of qgroup operations trans->qgroup_ref_list and we've got the
> >> qgroup's delayed ref blocker, trans->delayed_ref_elem. If you stop adding to the
> >> list (hunk 2) which seems reasonable when quota is disabled, then you also must
> >> ensure you're not acquiring the delayed ref blocker element, which should give
> >> another performance boost.
> > 
> > WHY a 'must' here?
> 
> Because otherwise you are going to hit the BUG_ONs you avoided with hunk 1 and 3.
> 
> >>
> >> need_ref_seq may be the right place for this change. It just feels a bit too
> >> obvious. The critical cases obviously are quota enable and quota disable. I just
> >> don't recall why it wasn't that way from the very beginning of qgroups, I might
> >> be missing something fundamental here.
> > 
> > Yeah I thought about 'need_ref_seq', but the point is that delayed ref blocker
> > not only serves qgroups accounting, but also features based on backref
> > walking, such as scrub, snapshot-aware defragment.
> 
> I think you're confusing trans->delayed_ref_elem with other callers of
> btrfs_get_tree_mod_seq() and btrfs_put_tree_mod_seq(). trans->delayed_ref_elem
> is only used in qgroup context, as far as my grep reaches. There are other
> callers of btrfs_get_tree_mod_seq() that can put their blocker element on the
> stack, such as iterate_extent_inodes().
> 
> But I still might be missing something.

It's right that ->delayed_ref_elem is only used in qgroup context, but
as the seq now has two parts, major + minor, need_ref_seq() should be
true even not in qgroup context 'cause we also need to keep tracking the
order of delayed refs' order for tree mod log by increasing the seq's minor part.

I don't think we can disable need_ref_seq() when quota is off.

-liubo
