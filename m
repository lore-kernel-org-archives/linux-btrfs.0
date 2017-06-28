Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41788 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751498AbdF1L3W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 07:29:22 -0400
Date: Wed, 28 Jun 2017 14:29:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: josef@toxicpanda.com
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] Btrfs: replace tree->mapping with tree->private_data
Message-ID: <20170628112912.u3ivq4ge77u7pp7d@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef Bacik,

The patch c6100a4b4e3d: "Btrfs: replace tree->mapping with
tree->private_data" from May 5, 2017, leads to the following static
checker warning:

	fs/btrfs/extent_io.c:3424 __extent_writepage_io()
	error: we previously assumed 'tree->ops' could be null (see line 3334)

fs/btrfs/extent_io.c
  3404                           * compressed extents
  3405                           */
  3406                          if (!compressed && tree->ops &&
                                                   ^^^^^^^^^
This function consistently check tree->ops before dereferencing it.

  3407                              tree->ops->writepage_end_io_hook)
  3408                                  tree->ops->writepage_end_io_hook(page, cur,
  3409                                                           cur + iosize - 1,
  3410                                                           NULL, 1);
  3411                          else if (compressed) {
  3412                                  /* we don't want to end_page_writeback on
  3413                                   * a compressed extent.  this happens
  3414                                   * elsewhere
  3415                                   */
  3416                                  nr++;
  3417                          }
  3418  
  3419                          cur += iosize;
  3420                          pg_offset += iosize;
  3421                          continue;
  3422                  }
  3423  
  3424                  set_range_writeback(tree, cur, cur + iosize - 1);
                                            ^^^^
The patch adds a new unchecked dereference.

regards,
dan carpenter
