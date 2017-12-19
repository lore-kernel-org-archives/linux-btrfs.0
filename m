Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17705 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934067AbdLSDgN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 22:36:13 -0500
Date: Tue, 19 Dec 2017 11:35:27 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>, Chris Mason <clm@fb.com>,
        Jan Kara <jack@suse.cz>
Subject: [btrfs:cgroup-btrfs 3/5] fs/buffer.c:3058:12: sparse: symbol
 'create_bh_bio' was not declared. Should it be static?
Message-ID: <201712191101.m5t8a2s4%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git cgroup-btrfs
head:   2e032c72c43e8008be45f23376d9e24d75c3d85f
commit: 61b4603b83389326984a47e702a319a40d006f77 [3/5] buffer_head: separate out create_bh_bio() from submit_bh_wbc()
reproduce:
        # apt-get install sparse
        git checkout 61b4603b83389326984a47e702a319a40d006f77
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
