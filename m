Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:36857 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3DBNqa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 09:46:30 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1FFC29A069C
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2013 07:46:30 -0600 (MDT)
Date: Tue, 2 Apr 2013 09:46:26 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Roman Mamedov <rm@romanrm.ru>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Still getting a lot of -28 (ENOSPC?) errors during balance
Message-ID: <20130402134626.GO1876@localhost.localdomain>
References: <20130402140452.2b71794f@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130402140452.2b71794f@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 02, 2013 at 02:04:52AM -0600, Roman Mamedov wrote:
> Hello,
> 
> With kernel 3.7.10 patched with "Btrfs: limit the global reserve to 512mb".
> (the problem was occuring also without this patch, but seemed to be even worse).
> 
> At the start of balance:
> 
> Data: total=31.85GB, used=9.96GB
> System: total=4.00MB, used=16.00KB
> Metadata: total=1.01GB, used=696.17MB
> 
> "btrfs balance start -musage=5 -dusage=5" is going on for about 50 minutes
> 
> Current situation:
> 
> Balance on '/mnt/r1/' is running
> 1 out of about 2 chunks balanced (20 considered),  50% left
> 
> Data: total=30.85GB, used=10.04GB
> System: total=4.00MB, used=16.00KB
> Metadata: total=1.01GB, used=851.69MB
> 
> And a constant stream of these in dmesg:
> 

Can you try this out and see if it helps?  Thanks,

Josef

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0d89ff0..9830e86 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2548,6 +2548,13 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 	list_for_each_entry(edge, &node->upper, list[LOWER]) {
 		cond_resched();
 
+		ret = btrfs_block_rsv_refill(rc->extent_root, rc->block_rsv,
+					     rc->extent_root->leafsize,
+					     BTRFS_RESERVE_FLUSH_ALL);
+		if (ret) {
+			err = ret;
+			break;
+		}
 		upper = edge->node[UPPER];
 		root = select_reloc_root(trans, rc, upper, edges, &nr);
 		BUG_ON(!root);
