Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33732 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbcFGRTK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jun 2016 13:19:10 -0400
Date: Tue, 7 Jun 2016 20:18:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: lufq.fnst@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: btrfs: fix check_shared for fiemap ioctl
Message-ID: <20160607171848.GA29093@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Lu Fengqi,

The patch ac8332f0c3ac: "btrfs: fix check_shared for fiemap ioctl"
from Jun 1, 2016, leads to the following static checker warning:

	fs/btrfs/backref.c:277 ref_tree_add()
	error: dereferencing freed memory 'node'

fs/btrfs/backref.c
   271          origin_count = node->ref_mod;
   272          node->ref_mod += count;
   273  
   274          if (!node->ref_mod)
   275                  ref_tree_remove(ref_tree, node);
                                                  ^^^^
Freed here.

   276  
   277          if (node->ref_mod > 0)
                    ^^^^^^^^^^^^^
Use after free.

   278                  ref_tree->unique_refs += origin_count > 0 ? 0 : 1;
   279          else if (node->ref_mod <= 0)
   280                  ref_tree->unique_refs += origin_count > 0 ? -1 : 0;
   281  
   282          return 0;

regards,
dan carpenter
