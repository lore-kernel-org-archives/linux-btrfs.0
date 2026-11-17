Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794921232;
	b=orjX94dofjA7GrSG7m35PAOiSe8/0BPje0yjJLe5sZmB+BNrJAiP0ESvHyeSQ5X463EH
	 2abePMVVUdqmSFtpbXgV3Bf/Pu+7uEWbrPj83N7VZ65oAv9Q5uCVArSWkGcRGJQ46fabv
	 /SF7jo1uzrBnjDtIEia0ABwc9hjid6JuDlpc8GV3sxfx5KCgzYs62F+Vs1qUEt0BnEzHh
	 o1twNFfiZf2hXzPqfzEJ26RRY6t7lLzDJN0s89VZMLOlWSce5MBOMZ8UsnHbAseL1WdHd
	 BGNw4UT+4OEoTE4Zev3rars3lRixZ9tFLeMVoZ/H3vH9r/JTFuCdWcHllhNgf9CqouQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794921232;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=0V6Hn6Bzy9lL0q161tKd2Kz567msE8dbDMP1VHYg+7M=;
	b=MytaWYuvCxVtqn3qFCbDF5qC3ej99tpeMSLwE9gV232ErIAqkKjLpIW8GO4YjuO8T5yU
	 xMPOKRWOCfE4vyQ9pHyGeeIxu00/Tc72ma2taULTvLqsbva/VHUGmd4RH+6UMH9KBE0Yr
	 +EgQFEnQYXTHcrwuJghYvXk0InSNOw4ooYREzvpAGoFQhiThleDFUDYuGm4WnCDH4wlch
	 Q8t5DSwui5sIBIul7QZmJbcGathz7/PhB9fo2PXkAt+p4A+vxaEQRIqi2ekl7o48JgqMY
	 sFJ2q1RkTByxVUUpzMOqBkBt4XS80TGxUisHStrSM3/y3TxFBwSizriOhdr3NOGADxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ykheu33k;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2F6606A31C;
	Tue, 17 Nov 2026 13:13:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E2F6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ykheu33k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794921231; x=1826457231;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gGBVdmYhKcN8lVHFGD4v7uz42UJ0d7Axml0auQE91Uw=;
  b=Ykheu33k/g8FSWc/OfYnY8oc+LetEqw0+zA46k4oAh21M+BOQFTff/9T
   UJHK+lImiL5lA902H3a5TEC/kFtRdsKLx9ykSyPAcw6r/L2RvRnnbowX5
   zNsa+qgrazXoU0l5Oz3SIjGKjlwSB6rq5cvqH67Rv5Foe0IMmiG0RPNpx
   wLJNcOnSoNSa3uHNERTly1nkSLh/BsCb9+r5Sgru2o9N7vHR2BbTtnsnj
   Qgd4ueItqk+ELsrFdjGdZ40dfgjfpJe83eLt7/fvPvIebcnHGt7xMKiKw
   P0zN5uvoiv9vG6WwpQG8N7rMqHX74FGjCU+7LIqAU44IlwbHOfshwpo7L
   g==;
X-CSE-ConnectionGUID: GGFdxVNbTbyuUuRU2yLvFg==
X-CSE-MsgGUID: c1/zBo43S3eTR5gsTzz6MA==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3692980"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3692980"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 05:12:37 -0800
X-CSE-ConnectionGUID: 7FRvp3HuTyu9zQ6iVdEGGA==
X-CSE-MsgGUID: BVcJhLL8RmmW264/t2GT+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="9737508"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 17 Nov 2026 05:12:36 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTIzB-00000001BbT-1q3a;
	Tue, 17 Nov 2026 13:12:33 +0000
Date: Tue, 17 Nov 2026 21:10:51 +0800
From: kernel test robot <lkp@intel.com>
To: Ismael Luceno <ismael@iodev.co.uk>, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Ismael Luceno <ismael@iodev.co.uk>, David Sterba <dsterba@suse.com>,
	Chris Mason <chris.mason@fusionio.com>,
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/8] btrfs: add a helper to scan all block devices
Message-ID: <202611172034.2xFLZZpu-lkp@intel.com>
References: <20261116224316.11237-14-ismael@iodev.co.uk>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116224316.11237-14-ismael@iodev.co.uk>

Hi Ismael,

kernel test robot noticed the following build errors:

[auto build test ERROR on kdave/for-next]
[also build test ERROR on btrfs/for-next brauner-vfs/vfs.all linus/master v7.4-rc3 next-20261116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ismael-Luceno/btrfs-add-config-options-for-the-root-device-scan/20261116-234317
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
patch link:    https://lore.kernel.org/r/20261116224316.11237-14-ismael%40iodev.co.uk
patch subject: [PATCH 4/8] btrfs: add a helper to scan all block devices
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20261117/202611172034.2xFLZZpu-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261117/202611172034.2xFLZZpu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611172034.2xFLZZpu-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: fs/btrfs/btrfs.ko: symbol 'block_class' undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
