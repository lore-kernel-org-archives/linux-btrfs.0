Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18378 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbcCRFhV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 01:37:21 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u2I5bKiU023181
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 05:37:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0022.oracle.com (8.14.4/8.13.8) with ESMTP id u2I5bKvH031231
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 05:37:20 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u2I5bJxW015233
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 05:37:20 GMT
Date: Fri, 18 Mar 2016 08:37:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: Btrfs: fix up read_tree_block to return proper error
Message-ID: <20160318053713.GA2111@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Liu Bo,

The patch 64c043de466d: "Btrfs: fix up read_tree_block to return
proper error" from May 25, 2015, leads to the following static
checker warning:

	fs/btrfs/relocation.c:1858 replace_path()
	error: 'eb' dereferencing possible ERR_PTR()

fs/btrfs/relocation.c
  1850                          eb = read_tree_block(dest, old_bytenr, old_ptr_gen);
  1851                          if (IS_ERR(eb)) {
                                    ^^^^^^^^^^

  1852                                  ret = PTR_ERR(eb);

Missing break or continue?

  1853                          } else if (!extent_buffer_uptodate(eb)) {
  1854                                  ret = -EIO;
  1855                                  free_extent_buffer(eb);
  1856                                  break;
  1857                          }
  1858                          btrfs_tree_lock(eb);
                                                ^^
Dereference.

  1859                          if (cow) {
  1860                                  ret = btrfs_cow_block(trans, dest, eb, parent,
  1861                                                        slot, &eb);

regards,
dan carpenter
