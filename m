Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13625 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933635AbbIVRzR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 13:55:17 -0400
Date: Wed, 23 Sep 2015 01:54:26 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: kbuild-all@01.org, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: [josef-btrfs:enospc-rework 1/9] fs/btrfs/qgroup.c:1463:2-7: WARNING:
 NULL check before freeing functions like kfree, debugfs_remove,
 debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider
 reorganizing relevant code to avoid passing NULL values.
Message-ID: <201509230124.0LoGc02q%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git enospc-rework
head:   ea67b575b6cd2be0775ddd1ff66968d11288f2c6
commit: 1aa3e6f33600e899b38591d9da156dfdb37ea325 [1/9] Major qgroup regression in 4.2?


coccinelle warnings: (new ones prefixed by >>)

>> fs/btrfs/qgroup.c:1463:2-7: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
