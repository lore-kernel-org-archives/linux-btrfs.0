Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752735AbdGLPRC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 11:17:02 -0400
Date: Wed, 12 Jul 2017 17:15:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.de>
Cc: dsterba@suse.cz, Edmund Nadolski <enadolski@suse.com>, jeffm@suse.com,
        linux-btrfs@vger.kernel.org, lufq.fnst@cn.fujitsu.com
Subject: Re: [PATCH v2 08/13] btrfs: convert prelimary reference tracking to
 use rbtrees
Message-ID: <20170712151547.GG2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170629035705.1589-1-enadolski@suse.com>
 <20170629035705.1589-9-enadolski@suse.com>
 <20170711151554.GU2866@twin.jikos.cz>
 <7a46a9f0-9e73-7484-c1be-e0116ab87688@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7a46a9f0-9e73-7484-c1be-e0116ab87688@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 05:12:27PM -0600, Edmund Nadolski wrote:
> 
> 
> On 07/11/2017 09:15 AM, David Sterba wrote:
> > On Wed, Jun 28, 2017 at 09:57:00PM -0600, Edmund Nadolski wrote:
> >> It's been known for a while that the use of multiple lists
> >> that are periodically merged was an algorithmic problem within
> >> btrfs.  There are several workloads that don't complete in any
> >> reasonable amount of time (e.g. btrfs/130) and others that cause
> >> soft lockups.
> >>
> >> The solution is to use a pair of rbtrees that do insertion merging
> >> for both indirect and direct refs, with the former converting
> >> refs into the latter.  The result is a btrfs/130 workload that
> >> used to take several hours now takes about half of that. This
> >> runtime still isn't acceptable and a future patch will address that
> >> by moving the rbtrees higher in the stack so the lookups can be
> >> shared across multiple calls to find_parent_nodes.
> >>
> >> Signed-off-by: Edmund Nadolski <enadolski@suse.com>
> >> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> > 
> > I've bisected to this patch, the self-tests run at module load time
> > fail:
> > 
> > tests/qgroup-tests.c:272
> > 
> > 270         if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
> > 271                                 nodesize, nodesize)) {
> > 272                 test_msg("Qgroup counts didn't match expected values\n");
> > 273                 return -EINVAL;
> > 274         }
> > 
> >  245 int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
> >  246                                u64 rfer, u64 excl)
> >  247 {
> >  248         struct btrfs_qgroup *qgroup;
> >  249
> >  250         qgroup = find_qgroup_rb(fs_info, qgroupid);
> >  251         if (!qgroup)
> >  252                 return -EINVAL;
> >  253         if (qgroup->rfer != rfer || qgroup->excl != excl)
> >  254                 return -EINVAL;
> >  255         return 0;
> >  256 }
> > 
> > the second if fails, with 0 != 4096 || 0 != 4096
> > 
> > Tested branch was current for-next-test (top commit
> > 8d73f8348287a3d3be10795f45d313f63cdcd72c), with
> > CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
> 
> This looks like a consequence of an existing check in __resolve_indirect_ref():
> 
> 	if (btrfs_is_testing(fs_info)) {
> 		srcu_read_unlock(&fs_info->subvol_srcu, index);
> 		ret = -ENOENT;
> 		goto out;
> 	}
> 
> The existing code simply leaves the ref on the pref list, to be picked up later
> in find_parent_nodes(), which will ulist_add() an entry onto the roots list for
> it.  The patch otoh when it sees -ENOENT just frees the ref so no entry is
> ever added to the ulist.
> 
> The patch can be fixed to behave similarly to the existing code by
> inserting the ref into the direct tree instead of freeing it.  This seems
> a bit odd since technically the ref isn't actually 'resolved'. Considering
> that this code path is really just a special case for the sanity check when
> the fs_info is in a BTRFS_FS_STATE_DUMMY_FS_INFO state, perhaps that's not
> too great a concern. Thoughts?

Yeah, this has been introduced by d9ee522ba3ab51b7e3c6d and it wants to
take some shortcuts for the self-tests. I'm concerned because the module
does not load when the self-tests are enabled.

So at this moment I'd take simpler approach and work around it so we can
continue testing and then fix it properly (either populate the trees or
add more exceptions for the self-tests).
