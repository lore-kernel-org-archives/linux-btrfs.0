Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38779 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbaAIRxY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 12:53:24 -0500
Date: Thu, 9 Jan 2014 20:53:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: fholton@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: Btrfs: convert printk to btrfs_ and fix BTRFS prefix
Message-ID: <20140109175314.GA3827@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Frank Holton,

This is a semi-automatic email about new static checker warnings.

The patch f2ee0bf65a1c: "Btrfs: convert printk to btrfs_ and fix 
BTRFS prefix" from Dec 20, 2013, leads to the following Smatch 
complaint:

fs/btrfs/super.c:298 __btrfs_panic()
	 error: we previously assumed 'fs_info' could be null (see line 294)

fs/btrfs/super.c
   293		errstr = btrfs_decode_error(errno);
   294		if (fs_info && (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR))
                    ^^^^^^^
Existing check.

   295			panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
   296				s_id, function, line, &vaf, errno, errstr);
   297	
   298		btrfs_crit(fs_info, "panic in %s:%d: %pV (errno=%d %s)",
                           ^^^^^^^
Patch introduces new unchecked dereference inside btrfs_crit().

   299			   function, line, &vaf, errno, errstr);
   300		va_end(args);

regards,
dan carpenter
