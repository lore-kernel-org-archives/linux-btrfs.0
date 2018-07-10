Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40665 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933145AbeGJNYV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 09:24:21 -0400
Date: Tue, 10 Jul 2018 21:24:14 +0800
From: kbuild test robot <lkp@intel.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org, nborisov@suse.com
Subject: Re: [PATCH v2 2/2] btrfs: get fs_devices pointer form
 btrfs_scan_one_device
Message-ID: <201807102115.iSByfuic%fengguang.wu@intel.com>
References: <1531218442-12885-2-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1531218442-12885-2-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gu,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v4.18-rc4]
[cannot apply to btrfs/next next-20180709]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Gu-Jinxiang/btrfs-make-fs_devices-to-be-a-local-variable/20180710-191730


coccinelle warnings: (new ones prefixed by >>)

>> fs/btrfs/super.c:2243:8-14: WARNING: PTR_ERR_OR_ZERO can be used

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
