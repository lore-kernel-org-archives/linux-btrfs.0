Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44616 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755296AbdGKPRI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 11:17:08 -0400
Date: Tue, 11 Jul 2017 17:15:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: jeffm@suse.com, linux-btrfs@vger.kernel.org, lufq.fnst@cn.fujitsu.com
Subject: Re: [PATCH v2 08/13] btrfs: convert prelimary reference tracking to
 use rbtrees
Message-ID: <20170711151554.GU2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170629035705.1589-1-enadolski@suse.com>
 <20170629035705.1589-9-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170629035705.1589-9-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 09:57:00PM -0600, Edmund Nadolski wrote:
> It's been known for a while that the use of multiple lists
> that are periodically merged was an algorithmic problem within
> btrfs.  There are several workloads that don't complete in any
> reasonable amount of time (e.g. btrfs/130) and others that cause
> soft lockups.
> 
> The solution is to use a pair of rbtrees that do insertion merging
> for both indirect and direct refs, with the former converting
> refs into the latter.  The result is a btrfs/130 workload that
> used to take several hours now takes about half of that. This
> runtime still isn't acceptable and a future patch will address that
> by moving the rbtrees higher in the stack so the lookups can be
> shared across multiple calls to find_parent_nodes.
> 
> Signed-off-by: Edmund Nadolski <enadolski@suse.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

I've bisected to this patch, the self-tests run at module load time
fail:

tests/qgroup-tests.c:272

270         if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
271                                 nodesize, nodesize)) {
272                 test_msg("Qgroup counts didn't match expected values\n");
273                 return -EINVAL;
274         }

 245 int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
 246                                u64 rfer, u64 excl)
 247 {
 248         struct btrfs_qgroup *qgroup;
 249
 250         qgroup = find_qgroup_rb(fs_info, qgroupid);
 251         if (!qgroup)
 252                 return -EINVAL;
 253         if (qgroup->rfer != rfer || qgroup->excl != excl)
 254                 return -EINVAL;
 255         return 0;
 256 }

the second if fails, with 0 != 4096 || 0 != 4096

Tested branch was current for-next-test (top commit
8d73f8348287a3d3be10795f45d313f63cdcd72c), with
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
