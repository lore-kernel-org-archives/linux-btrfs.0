Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60613 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758455AbeD1Rht (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 13:37:49 -0400
Date: Sun, 29 Apr 2018 01:36:54 +0800
From: kbuild test robot <lkp@intel.com>
To: ethanwu <ethanwu@synology.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com,
        ethanwu <ethanwu@synology.com>
Subject: Re: [PATCH] btrfs: Take trans lock before access running trans in
 check_delayed_ref
Message-ID: <201804290134.1oV0XvXX%fengguang.wu@intel.com>
References: <1524823126-23414-1-git-send-email-ethanwu@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524823126-23414-1-git-send-email-ethanwu@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi ethanwu,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v4.17-rc2]
[also build test WARNING on next-20180426]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/ethanwu/btrfs-Take-trans-lock-before-access-running-trans-in-check_delayed_ref/20180428-223414
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   fs/btrfs/extent-tree.c:278:39: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:278:39: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:401:16: sparse: expression using sizeof(void)
>> fs/btrfs/extent-tree.c:3148:29: sparse: incorrect type in argument 1 (different base types) @@    expected struct atomic_t [usertype] *v @@    got ct atomic_t [usertype] *v @@
   fs/btrfs/extent-tree.c:3148:29:    expected struct atomic_t [usertype] *v
   fs/btrfs/extent-tree.c:3148:29:    got struct refcount_struct *<noident>
   fs/btrfs/extent-tree.c:4502:26: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:4850:31: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:4850:31: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5043:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5060:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5060:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5043:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5060:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5060:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5043:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5060:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5060:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5043:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5060:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5060:22: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5612:48: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5612:48: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5861:21: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5866:27: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5872:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:5872:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6308:29: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6308:29: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6737:23: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6737:23: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6740:31: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6740:31: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6782:42: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:6782:42: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7551:24: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7551:24: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7552:24: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7552:24: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7716:43: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:7716:43: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:8064:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:8064:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:8067:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:8067:37: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:8586:35: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:8589:35: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:8589:35: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:11035:25: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:11035:25: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:11036:23: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:11036:23: sparse: expression using sizeof(void)
   fs/btrfs/extent-tree.c:2558:20: sparse: context imbalance in 'cleanup_extent_op' - unexpected unlock
   fs/btrfs/extent-tree.c:2590:28: sparse: context imbalance in 'cleanup_ref_head' - unexpected unlock
   fs/btrfs/extent-tree.c:2702:26: sparse: context imbalance in '__btrfs_run_delayed_refs' - different lock contexts for basic block
   fs/btrfs/extent-tree.c:7418:39: sparse: context imbalance in 'btrfs_lock_cluster' - wrong count at exit
   fs/btrfs/extent-tree.c:7695:44: sparse: context imbalance in 'find_free_extent' - unexpected unlock
   fs/btrfs/extent-tree.c:9830:9: sparse: context imbalance in 'btrfs_put_block_group_cache' - wrong count at exit
   fs/btrfs/extent-tree.c: In function 'check_delayed_ref':
   fs/btrfs/extent-tree.c:3148:14: error: passing argument 1 of 'atomic_inc' from incompatible pointer type [-Werror=incompatible-pointer-types]
      atomic_inc(&cur_trans->use_count);
                 ^
   In file included from arch/x86/include/asm/atomic.h:283:0,
                    from include/linux/atomic.h:5,
                    from include/linux/rcupdate.h:38,
                    from include/linux/rculist.h:11,
                    from include/linux/pid.h:5,
                    from include/linux/sched.h:14,
                    from fs/btrfs/extent-tree.c:6:
   include/asm-generic/atomic-instrumented.h:100:29: note: expected 'atomic_t * {aka struct <anonymous> *}' but argument is of type 'refcount_t * {aka struct refcount_struct *}'
    static __always_inline void atomic_inc(atomic_t *v)
                                ^~~~~~~~~~
   cc1: some warnings being treated as errors

vim +3148 fs/btrfs/extent-tree.c

  3132	
  3133	static noinline int check_delayed_ref(struct btrfs_root *root,
  3134					      struct btrfs_path *path,
  3135					      u64 objectid, u64 offset, u64 bytenr)
  3136	{
  3137		struct btrfs_delayed_ref_head *head;
  3138		struct btrfs_delayed_ref_node *ref;
  3139		struct btrfs_delayed_data_ref *data_ref;
  3140		struct btrfs_delayed_ref_root *delayed_refs;
  3141		struct btrfs_transaction *cur_trans;
  3142		struct rb_node *node;
  3143		int ret = 0;
  3144	
  3145		spin_lock(&root->fs_info->trans_lock);
  3146		cur_trans = root->fs_info->running_transaction;
  3147		if (cur_trans)
> 3148			atomic_inc(&cur_trans->use_count);
  3149		spin_unlock(&root->fs_info->trans_lock);
  3150		if (!cur_trans)
  3151			return 0;
  3152	
  3153		delayed_refs = &cur_trans->delayed_refs;
  3154		spin_lock(&delayed_refs->lock);
  3155		head = btrfs_find_delayed_ref_head(delayed_refs, bytenr);
  3156		if (!head) {
  3157			spin_unlock(&delayed_refs->lock);
  3158			btrfs_put_transaction(cur_trans);
  3159			return 0;
  3160		}
  3161	
  3162		if (!mutex_trylock(&head->mutex)) {
  3163			refcount_inc(&head->refs);
  3164			spin_unlock(&delayed_refs->lock);
  3165	
  3166			btrfs_release_path(path);
  3167	
  3168			/*
  3169			 * Mutex was contended, block until it's released and let
  3170			 * caller try again
  3171			 */
  3172			mutex_lock(&head->mutex);
  3173			mutex_unlock(&head->mutex);
  3174			btrfs_put_delayed_ref_head(head);
  3175			btrfs_put_transaction(cur_trans);
  3176			return -EAGAIN;
  3177		}
  3178		spin_unlock(&delayed_refs->lock);
  3179	
  3180		spin_lock(&head->lock);
  3181		/*
  3182		 * XXX: We should replace this with a proper search function in the
  3183		 * future.
  3184		 */
  3185		for (node = rb_first(&head->ref_tree); node; node = rb_next(node)) {
  3186			ref = rb_entry(node, struct btrfs_delayed_ref_node, ref_node);
  3187			/* If it's a shared ref we know a cross reference exists */
  3188			if (ref->type != BTRFS_EXTENT_DATA_REF_KEY) {
  3189				ret = 1;
  3190				break;
  3191			}
  3192	
  3193			data_ref = btrfs_delayed_node_to_data_ref(ref);
  3194	
  3195			/*
  3196			 * If our ref doesn't match the one we're currently looking at
  3197			 * then we have a cross reference.
  3198			 */
  3199			if (data_ref->root != root->root_key.objectid ||
  3200			    data_ref->objectid != objectid ||
  3201			    data_ref->offset != offset) {
  3202				ret = 1;
  3203				break;
  3204			}
  3205		}
  3206		spin_unlock(&head->lock);
  3207		mutex_unlock(&head->mutex);
  3208		btrfs_put_transaction(cur_trans);
  3209		return ret;
  3210	}
  3211	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
