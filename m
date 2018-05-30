Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49676 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbeE3KTS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 06:19:18 -0400
Date: Wed, 30 May 2018 13:19:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: misono.tomohiro@jp.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: Add unprivileged version of ino_lookup ioctl
Message-ID: <20180530101906.bsnokgp5w2rfh3oh@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Tomohiro Misono,

The patch 56bfce6502b7: "btrfs: Add unprivileged version of
ino_lookup ioctl" from May 16, 2018, leads to the following static
checker warning:

	fs/btrfs/ioctl.c:2478 btrfs_search_path_in_tree_user()
	error: 'temp_inode' dereferencing possible ERR_PTR()

fs/btrfs/ioctl.c
  2469                          l = path->nodes[0];
  2470                          slot = path->slots[0];
  2471                          btrfs_item_key_to_cpu(l, &key2, slot);
  2472                          if (key2.objectid != dirid) {
  2473                                  ret = -ENOENT;
  2474                                  goto out;
  2475                          }
  2476  
  2477                          temp_inode = btrfs_iget(sb, &key2, root, NULL);
                                ^^^^^^^^^^^^^^^^^^^^^^^
  2478                          ret = inode_permission(temp_inode, MAY_READ | MAY_EXEC);
                                                       ^^^^^^^^^^
  2479                          iput(temp_inode);
  2480                          if (ret) {
  2481                                  ret = -EACCES;
  2482                                  goto out;
  2483                          }
  2484  


regards,
dan carpenter
