Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50347 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756968AbcH3Buc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 21:50:32 -0400
Subject: Re: [PATCH] btrfs-progs: check: skip shared node or leaf check for
 low_memory mode
To: <dsterba@suse.cz>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
References: <20160819095946.31917-1-wangxg.fnst@cn.fujitsu.com>
 <20160824124431.GQ16983@twin.jikos.cz> <57BE8261.4040308@cn.fujitsu.com>
 <20160829152035.GV16983@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <0158e565-3bb8-01fb-362f-6d5d8ec4cf35@cn.fujitsu.com>
Date: Tue, 30 Aug 2016 09:50:20 +0800
MIME-Version: 1.0
In-Reply-To: <20160829152035.GV16983@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/29/2016 11:20 PM, David Sterba wrote:
> On Thu, Aug 25, 2016 at 01:30:09PM +0800, Wang Xiaoguang wrote:
>> Hi,
>>
>> On 08/24/2016 08:44 PM, David Sterba wrote:
>>> On Fri, Aug 19, 2016 at 05:59:46PM +0800, Wang Xiaoguang wrote:
>>>> The basic idea is simple. Assume a middle tree node A is shared and
>>>> its referenceing fs/file tree root ids are 5, 258 and 260, then we
>>>> only check node A in the tree who has the smallest root id. That means
>>>> in this case, when checking root tree(5), we check inode A, for root
>>>> tree 258 and 260, we can just skip it.
>>>>
>>>> Notice even with this patch, we still may visit a shared node or leaf
>>>> multiple times. This happens when a inode metadata occupies multiple
>>>> leaves.
>>>>
>>>>                   leaf_A     leaf_B
>>>> When checking inode item in leaf_A, assume inode[512] have file extents
>>>> in leaf_B, and leaf_B is shared. In the case, for inode[512], we must
>>>> visit leaf_B to have inode item check. After finishing inode[512] check,
>>>> here we walk down tree root to leaf_B to check whether node or leaf
>>>> is shared, if some node or leaf is shared, we can just skip it and below
>>>> nodes or leaf's check.
>>>>
>>>> I also fill a disk partition with linux source codes and create 3 snapshots
>>>> in it. Before this patch, it averagely took 46s to finish one btrfsck
>>>> execution, with this patch, it averagely took 15s.
>>>>
>>>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>> Can you please refresh the patch on top of current devel branch? I get
>>> too many conflicts to resolve.
>> This patch is to improve low memory mode fs/file tree check, but it seems
>> Lu Fengqi's low memory fs/file tree check patches are not merged into your
>> devel branch :)
>
> Are they not? The low-memory patchset has been released in 4.7.1, the
> devel branch is always on top of master branch. I see both branches
> pushed to the public git repos so I don't see what you mean.

Unfortunately, the low memory mode is not fully merged into devel branch.

Only the first part (extent and chunk tree) is merged.

The second part(fs tree) is not merged yet.

Patches like the following is not in either devel/master branch:
Lu Fengqi (13):
   btrfs-progs: move btrfs_extref_hash() to hash.h
   btrfs-progs: check: introduce function to find dir_item
   btrfs-progs: check: introduce function to check inode_ref
   btrfs-progs: check: introduce function to check inode_extref
   btrfs-progs: check: introduce function to find inode_ref
   btrfs-progs: check: introduce a function to check dir_item
   btrfs-progs: check: introduce function to check file extent
   btrfs-progs: check: introduce function to check inode item
   btrfs-progs: check: introduce function to check fs root
   btrfs-progs: check: introduce function to check root ref
   btrfs-progs: check: introduce low_memory mode fs_tree check
   btrfs-progs: check: fix the return value bug of cmd_check()
   btrfs-progs: check: fix false warning for check_extent_item()

So Wang found it confusing and unable to apply his patch to devel branch.

Thanks,
Qu


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


