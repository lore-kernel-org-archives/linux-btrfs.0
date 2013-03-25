Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55627 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab3CYUO3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 16:14:29 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 50F9D9A068E
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2013 14:14:29 -0600 (MDT)
Date: Mon, 25 Mar 2013 16:14:26 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
Message-ID: <20130325201426.GG1955@localhost.localdomain>
References: <20130321190249.30044.79438@localhost.localdomain>
 <514B62A4.1030201@profihost.ag>
 <5F36F35C-39BE-4244-B8FB-A80EC2B06D48@profihost.ag>
 <514C4A8C.90607@profihost.ag>
 <20130322135322.GB1955@localhost.localdomain>
 <514C6319.7030400@profihost.ag>
 <20130322155453.GD1955@localhost.localdomain>
 <514CAC8D.7010409@profihost.ag>
 <20130322204932.GE1955@localhost.localdomain>
 <514CC52B.1000201@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <514CC52B.1000201@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 22, 2013 at 02:55:07PM -0600, Stefan Priebe wrote:
> Hi Jsoef,
> 
> thanks!

Ok I don't think the thing I just fixed will make any difference for you so
here's another debug patch, just apply it on top of what I've already sent you
and re-run and give me the dmesg again.  Thanks,

Josef


diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aabaea6..bf6433f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4162,7 +4162,11 @@ out:
 	}
 	if (flushing) {
 		if (ret == -ENOSPC) {
-			printk(KERN_ERR "returning enospc, dumping space info\n");
+			spin_lock(&block_rsv->lock);
+			printk(KERN_ERR "returning enospc, space_info %u, size %Lu reserved %Lu, "
+			       "flush %d, flush_state %d  dumping space info\n", block_rsv->type,
+			       block_rsv->size, block_rsv->reserved, flush, flush_state);
+			spin_unlock(&block_rsv->lock);
 			dump_space_info(space_info, 0, 0);
 		}
 
-- 
1.7.7.6

