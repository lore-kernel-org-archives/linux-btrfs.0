Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:33347 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753416AbeBPHBR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Feb 2018 02:01:17 -0500
Date: Fri, 16 Feb 2018 15:01:08 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Josef Bacik <jbacik@fb.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH josef-btrfs] block: blkcg_qos_init() can be static
Message-ID: <20180216070108.GA17588@lkp-wsm-ep1>
References: <201802161335.keR3zHOI%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201802161335.keR3zHOI%fengguang.wu@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Fixes: 6389939532e7 ("block: introduce blkcg-qos io controller")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 blkcg-qos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blkcg-qos.c b/block/blkcg-qos.c
index a28adcc..6588b1c 100644
--- a/block/blkcg-qos.c
+++ b/block/blkcg-qos.c
@@ -337,7 +337,7 @@ static struct rq_qos_ops blkcg_qos_ops = {
 	.done_bio = blkcg_qos_done_bio,
 };
 
-int blkcg_qos_init(struct request_queue *q)
+static int blkcg_qos_init(struct request_queue *q)
 {
 	struct blkcg_qos *blkqos;
 	struct rq_qos *rqos;
