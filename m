Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51383 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbbI3Egt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 00:36:49 -0400
Date: Wed, 30 Sep 2015 12:35:45 +0800
From: kbuild test robot <lkp@intel.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v4 6/9] Btrfs: implement the free space B-tree
Message-ID: <201509301242.BVTVNkGj%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3319d371e22491b6901af33842b57db37b77c52c.1443583874.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Omar,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]


coccinelle warnings: (new ones prefixed by >>)

>> fs/btrfs/free-space-tree.c:1255:1-4: WARNING: end returns can be simpified
   fs/btrfs/free-space-tree.c:1168:1-4: WARNING: end returns can be simpified

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
