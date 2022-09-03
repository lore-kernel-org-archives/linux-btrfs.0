Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C08ECAAD4
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Sep 2022 12:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiICMUi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Sep 2022 08:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiICMUg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Sep 2022 08:20:36 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBEC5F6C
        for <linux-btrfs@vger.kernel.org>; Sat,  3 Sep 2022 05:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662207633; x=1693743633;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q03e9CNXRPeeE/8HIef7LRQHVfoS9sYDKJcGKArXI0Y=;
  b=BzysLW9/BgvTECNyYjIYN7AhfMfhcxB1a6axcgrfck/3xoCJ/OwMWBc4
   NJAtNWKr2Qi2u06m1EI30uRAqdiovteNBLfkoU2z3LVkWzUXQ8ltKsJtM
   P2f+rlYTdol2oOSnsYsKJFNP02BjFmdh8mp/5fnDTdjupg+MgwCMTcbwa
   SxF2SWOnCSTM0j7MADFvvMKwBj7AZoFbOMMpMK4jqDaLrO3F6bGqizreg
   JbKY1sPQakrb93DCMRRH2sh7/RYwWh7Spsbl/2q5PyWS3NGrSrQjHGxVp
   jTy18YvY1r2X3AW0ODG+jiyv5sU1RBexm4GgOs12DTinY55i/KAnnxv5M
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="357868483"
X-IronPort-AV: E=Sophos;i="5.93,287,1654585200"; 
   d="scan'208";a="357868483"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 05:20:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,287,1654585200"; 
   d="scan'208";a="643255699"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2022 05:20:32 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oUS8V-0001e7-18;
        Sat, 03 Sep 2022 12:20:31 +0000
Date:   Sat, 3 Sep 2022 20:19:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org
Subject: Re: [PATCH PoC 5/9] btrfs: scrub: add helpers to fulfill
 csum/extent_generation
Message-ID: <202209032021.ryUdsh1f-lkp@intel.com>
References: <e8c6d760b9c9bf5826751909ce30a6f0c0a2a056.1662191784.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8c6d760b9c9bf5826751909ce30a6f0c0a2a056.1662191784.git.wqu@suse.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Qu,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kdave/for-next]
[also build test ERROR on next-20220901]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qu-Wenruo/btrfs-scrub-introduce-a-new-family-of-ioctl-scrub_fs/20220903-162128
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
config: arm-randconfig-r031-20220903 (https://download.01.org/0day-ci/archive/20220903/202209032021.ryUdsh1f-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project c55b41d5199d2394dd6cdb8f52180d8b81d809d4)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/02fbe0e7c98836561e983171c7cd0bcb8990915b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Qu-Wenruo/btrfs-scrub-introduce-a-new-family-of-ioctl-scrub_fs/20220903-162128
        git checkout 02fbe0e7c98836561e983171c7cd0bcb8990915b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__aeabi_uldivmod" [fs/btrfs/btrfs.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
