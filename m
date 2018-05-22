Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751020AbeEVMfX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 08:35:23 -0400
Subject: Re: [PATCH v2 0/6] btrfs_search_slot cleanups
To: dsterba@suse.cz, Su Yue <suy.fnst@cn.fujitsu.com>,
        Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <9b80bec0-b7cf-10da-f379-373fe6ec776a@cn.fujitsu.com>
 <20180522120214.GG6649@twin.jikos.cz>
Cc: Qu Wenruo <wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fd6e7b1c-6cd2-c5c2-9895-1df0db5f2ccc@suse.com>
Date: Tue, 22 May 2018 15:35:21 +0300
MIME-Version: 1.0
In-Reply-To: <20180522120214.GG6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.05.2018 15:02, David Sterba wrote:
> On Tue, May 22, 2018 at 07:05:14PM +0800, Su Yue wrote:
>> Hi Liu and David,
>> 	During my local xfstests on kdave/for-next, btrfs/139 failed and
>> btrfs BUG_ON due to qgroup rescan.
>> 	The bisect result is commit 560215eb3f32("Merge branch
>> 'ext/liubo/search-cleanups-wip' into for-next-next-v4.18-20180521")
>> which seems merged this patchset.
>> 	The dmesg file is attached.
>>
>> On 05/18/2018 11:00 AM, Liu Bo wrote:
>>> Here are a collection of patches I did for btrfs_search_slot().
>>>
>>> v2: more explicit commit log for each patch.
>>>
>>> Liu Bo (6):
>>>   Btrfs: remove superfluous free_extent_buffer
>>>   Btrfs: use more straightforward extent_buffer_uptodate
>>>   Btrfs: move get root of btrfs_search_slot to a helper
>>>   Btrfs: remove unused check of skip_locking
>>>   Btrfs: grab write lock directly if write_lock_level is the max level
>>>   Btrfs: remove always true check in unlock_up
>>>
>>>  fs/btrfs/ctree.c | 121 +++++++++++++++++++++++++++++++++----------------------
>>>  1 file changed, 73 insertions(+), 48 deletions(-)
>>>
>>
>>
> 
>> [   46.129166] BTRFS info (device vdb): disk space caching is enabled
>> [   46.130545] BTRFS info (device vdb): has skinny extents
>> [   46.171386] mount (2798) used greatest stack depth: 12920 bytes left
>> [   46.508170] BTRFS: device fsid 83a117c7-a9ea-4bf5-b42f-7092078610d5 devid 1 transid 5 /dev/vdc
>> [   46.562428] BTRFS info (device vdc): disk space caching is enabled
>> [   46.563690] BTRFS info (device vdc): has skinny extents
>> [   46.564563] BTRFS info (device vdc): flagging fs with big metadata feature
>> [   46.587441] BTRFS info (device vdc): checking UUID tree
>> [   46.766765] BTRFS info (device vdb): disk space caching is enabled
>> [   46.768197] BTRFS info (device vdb): has skinny extents
>> [   46.875534] run fstests btrfs/139 at 2018-05-22 18:40:36
>> [   47.559411] BTRFS: device fsid 065f3825-057e-451f-8722-0d94d4a3f36f devid 1 transid 5 /dev/vdc
>> [   47.612001] BTRFS info (device vdc): disk space caching is enabled
>> [   47.613254] BTRFS info (device vdc): has skinny extents
>> [   47.614147] BTRFS info (device vdc): flagging fs with big metadata feature
>> [   47.632377] BTRFS info (device vdc): checking UUID tree
>> [   47.681656] btrfs (3176) used greatest stack depth: 12632 bytes left
>> [   47.691156] ------------[ cut here ]------------
>> [   47.692084] kernel BUG at fs/btrfs/locking.c:286!
> 
> I saw the crash too but did not investigate the root cause. So I'll
> remove the branch from for-next until it's fixed. Thanks for the report.

I think the problem stems from Qu's patch, which sets search_commit_root
=1 but doesn't set skip_locking, as a result we don't lock the tree when
we obtain a reference to the root node, yet later when traversing the
tree due to skip_locking not being set we try to lock it, and this
causes btrfs_assert_tree_locked to triggers. Can you test whether the
following diff solves the issues:


diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index bc19a7d11c98..23fadb640c59 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2702,6 +2702,7 @@ static void btrfs_qgroup_rescan_worker(struct
btrfs_work *work)
         * should be recorded by qgroup
         */
        path->search_commit_root = 1;
+       path->skip_locking = 1;

        err = 0;
        while (!err && !btrfs_fs_closing(fs_info)) {


If it does, this only means we need to make skip_locking = 1 being
conditional on search_commit_root being set and this situation should be
handled in btrfs_search_slot.
