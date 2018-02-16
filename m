Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:6582 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753416AbeBPHBS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Feb 2018 02:01:18 -0500
Date: Fri, 16 Feb 2018 15:01:07 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Josef Bacik <jbacik@fb.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org
Subject: [josef-btrfs:blk-qos 13/13] block/blkcg-qos.c:340:5: sparse: symbol
 'blkcg_qos_init' was not declared. Should it be static?
Message-ID: <201802161335.keR3zHOI%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git blk-qos
head:   6389939532e7f4a0d8f19f9efc8a4936f8368d29
commit: 6389939532e7f4a0d8f19f9efc8a4936f8368d29 [13/13] block: introduce blkcg-qos io controller
reproduce:
        # apt-get install sparse
        git checkout 6389939532e7f4a0d8f19f9efc8a4936f8368d29
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
