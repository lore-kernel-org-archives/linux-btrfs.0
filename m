Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:13198 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728219AbeIJTzg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 15:55:36 -0400
Date: Mon, 10 Sep 2018 23:00:28 +0800
From: kbuild test robot <lkp@intel.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: kbuild-all@01.org, David Sterba <dsterba@suse.com>,
        Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [linux-next:master 3022/3360] fs/btrfs/extent-tree.c:2540:5: sparse:
 symbol 'btrfs_run_delayed_refs_for_head' was not declared. Should it be
 static?
Message-ID: <201809102215.95hxOLVe%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   43783a8f68478e81fe183f86162d3e7ca29ba923
commit: ac75a14eb672441d674d46b64a03f59d0f186cae [3022/3360] btrfs: Factor out loop processing all refs of a head
reproduce:
        # apt-get install sparse
        git checkout ac75a14eb672441d674d46b64a03f59d0f186cae
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   fs/btrfs/extent-tree.c:273:39: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:273:39: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:397:16: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:2506:31: sparse: symbol 'btrfs_obtain_ref_head' was not declared. Should it be static?
>> fs/btrfs/extent-tree.c:2540:5: sparse: symbol 'btrfs_run_delayed_refs_for_head' was not declared. Should it be static?
   fs/btrfs/extent-tree.c:4439:26: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:4789:31: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:4789:31: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:4984:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5001:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5001:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:4984:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5001:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5001:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:4984:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5001:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5001:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:4984:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5001:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5001:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5553:48: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5553:48: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5795:21: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5800:27: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5806:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5806:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6196:29: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6196:29: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6617:23: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6617:23: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6620:31: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6620:31: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6663:42: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6663:42: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7382:24: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7382:24: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7383:24: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7383:24: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7547:43: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7547:43: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7892:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7892:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7895:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7895:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:8446:35: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:8449:35: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:8449:35: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:10961:25: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:10961:25: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:10962:23: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:10962:23: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:2419:20: sparse: context imbalance in 'cleanup_extent_op' - unexpected unlock
   fs/btrfs/extent-tree.c:2452:28: sparse: context imbalance in 'cleanup_ref_head' - unexpected unlock
>> fs/btrfs/extent-tree.c:2557:36: sparse: context imbalance in 'btrfs_run_delayed_refs_for_head' - unexpected unlock
   fs/btrfs/extent-tree.c:2664:26: sparse: context imbalance in '__btrfs_run_delayed_refs' - different lock contexts for basic block
   fs/btrfs/extent-tree.c:7249:39: sparse: context imbalance in 'btrfs_lock_cluster' - wrong count at exit
   fs/btrfs/extent-tree.c:7526:44: sparse: context imbalance in 'find_free_extent' - unexpected unlock
   fs/btrfs/extent-tree.c:9712:9: sparse: context imbalance in 'btrfs_put_block_group_cache' - wrong count at exit

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
