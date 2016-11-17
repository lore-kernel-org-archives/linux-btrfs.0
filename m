Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:50478 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbcKQFBx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 00:01:53 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 0DC17AC01DC
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Nov 2016 14:01:48 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3051.s.css.fujitsu.com (Postfix) with SMTP id F1285655
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Nov 2016 14:01:47 +0900 (JST)
Message-Id: <201611170501.AA00016@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 17 Nov 2016 14:01:31 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: qgroup: fix error in ASSERT condition expression
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Option -f, -F and --sort don't work because a conditional expression
of ASSERT is wrong.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 qgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 9d10cb8..071d15e 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -480,7 +480,7 @@ int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_comparer_set  **comp_set,
 		*comp_set = set;
 	}
 
-	ASSERT(set->comps[set->ncomps].comp_func != NULL);
+	ASSERT(set->comps[set->ncomps].comp_func == NULL);
 
 	set->comps[set->ncomps].comp_func = all_comp_funcs[comparer];
 	set->comps[set->ncomps].is_descending = is_descending;
@@ -847,7 +847,7 @@ int btrfs_qgroup_setup_filter(struct btrfs_qgroup_filter_set **filter_set,
 		*filter_set = set;
 	}
 
-	ASSERT(set->filters[set->nfilters].filter_func != NULL);
+	ASSERT(set->filters[set->nfilters].filter_func == NULL);
 	set->filters[set->nfilters].filter_func = all_filter_funcs[filter];
 	set->filters[set->nfilters].data = data;
 	set->nfilters++;
-- 
2.9.3
