Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18494 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbcCRFh5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 01:37:57 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u2I5bu8P023414
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 05:37:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userv0022.oracle.com (8.14.4/8.13.8) with ESMTP id u2I5buBt000366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 05:37:56 GMT
Date: Fri, 18 Mar 2016 08:37:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: chris.mason@oracle.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: Btrfs: get/set for struct header fields
Message-ID: <20160318053745.GB2111@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris Mason,

The patch 7518a238ea01: "Btrfs: get/set for struct header fields"
from Mar 12, 2007, leads to the following static checker warning:

	fs/btrfs/print-tree.c:359 btrfs_print_tree()
	error: 'next' dereferencing possible ERR_PTR()

fs/btrfs/print-tree.c
   355          for (i = 0; i < nr; i++) {
   356                  struct extent_buffer *next = read_tree_block(root,
                                                     ^^^^^^^^^^^^^^^
This function can fail.  The original code was buggy as well before
7518a238ea01.

   357                                          btrfs_node_blockptr(c, i),
   358                                          btrfs_node_ptr_generation(c, i));
   359                  if (btrfs_is_leaf(next) &&
   360                     level != 1)
   361                          BUG();
   362                  if (btrfs_header_level(next) !=
   363                         level - 1)
   364                          BUG();
   365                  btrfs_print_tree(root, next);
   366                  free_extent_buffer(next);
   367          }


regards,
dan carpenter
