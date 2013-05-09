Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48726 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab3EIMWP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 08:22:15 -0400
Date: Thu, 9 May 2013 15:22:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jbacik@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: Btrfs: cleanup destroy_marked_extents
Message-ID: <20130509122206.GA997@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef Bacik,

This is a semi-automatic email about new static checker warnings.

The patch fd8b2b611580: "Btrfs: cleanup destroy_marked_extents" from 
Apr 24, 2013, leads to the following Smatch complaint:

fs/btrfs/disk-io.c:3814 btrfs_destroy_marked_extents()
	 warn: variable dereferenced before check 'eb' (see line 3813)

fs/btrfs/disk-io.c
  3812							   root->leafsize);
  3813				start += eb->len;
                                         ^^^^^^^
New dereference.
  3814				if (!eb)
                                    ^^^
New check.  Maybe we should be adding "root->leafsize" here?  Just
the check earlier would cause a forever loop.

  3815					continue;
  3816				wait_on_extent_buffer_writeback(eb);

regards,
dan carpenter
