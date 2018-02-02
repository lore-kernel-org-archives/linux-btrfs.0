Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:10970 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753553AbeBBROC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 12:14:02 -0500
Date: Sat, 3 Feb 2018 01:13:29 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Josef Bacik <jbacik@fb.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org
Subject: [josef-btrfs:current-work 3/3] block/blk-wbt.c:919:1-10: alloc with
 no test, possible model on line 924
Message-ID: <201802030126.iLSHnHGq%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git current-work
head:   1ac686f6d1b04b480cd245fb927180e1238bd3ac
commit: 1ac686f6d1b04b480cd245fb927180e1238bd3ac [3/3] current-work


coccinelle warnings: (new ones prefixed by >>)

>> block/blk-wbt.c:919:1-10: alloc with no test, possible model on line 924

vim +919 block/blk-wbt.c

   910	
   911	static int blkcg_qos_init(struct request_queue *q)
   912	{
   913		struct blkcg_qos *blkcg_qos;
   914		struct rq_qos *rqos;
   915		int i;
   916	
   917		BUILD_BUG_ON(WBT_NR_BITS > BLK_STAT_RES_BITS);
   918	
 > 919		blkcg_qos = kzalloc(sizeof(*blkcg_qos), GFP_KERNEL);
   920		if (!rwb)
   921			return -ENOMEM;
   922	
   923		rqos = &blkcg_qos->rqos;
 > 924		rqos->cb = blk_stat_alloc_callback(qos_timer_fn, wbt_data_dir, 2,
   925						   blkcg_qos);
   926		if (!rqos->cb) {
   927			kfree(blkcg_qos);
   928			return -ENOMEM;
   929		}
   930	
   931		rq_qos_add(q, rqos);
   932		blk_stat_add_callback(q, rqos->cb);
   933		atomic_set(&blkcg_qos->scale_cookie, DEFAULT_SCALE_COOKIE);
   934		blkcg_qos->scale_lat = 0;
   935	#if 0
   936		for (i = 0; i < WBT_NUM_RWQ; i++) {
   937			atomic_set(&rwb->rq_wait[i].inflight, 0);
   938			init_waitqueue_head(&rwb->rq_wait[i].wait);
   939		}
   940	
   941		rwb->enable_state = WBT_STATE_ON_DEFAULT;
   942		wbt_update_limits(rwb);
   943	
   944		/*
   945		 * Assign rwb and add the stats callback.
   946		 */
   947		if (q->rq_wb)
   948			q->rq_wb->next = rwb;
   949		else (q->rq_wb)
   950			q->rq_wb = rwb;
   951		blk_stat_add_callback(q, rwb->cb);
   952	
   953		rwb->min_lat_nsec = wbt_default_latency_nsec(q);
   954	
   955		wbt_set_queue_depth(rwb, blk_queue_depth(q));
   956		wbt_set_write_cache(rwb, test_bit(QUEUE_FLAG_WC, &q->queue_flags));
   957	#endif
   958		return 0;
   959	}
   960	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
