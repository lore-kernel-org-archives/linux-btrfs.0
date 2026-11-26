Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795659044;
	b=iaISXVCfr0zQ6OVFLNZCnx1oXLOnI2OMsoCvwUhnJCTy9LS5hEQLUdUwcRgISjj04b34
	 quCGJiIbGYTfuXoZ3HrQ+NdUGTCMuuZnWGQ07wtX7dYOLUd+GdbVj+e8tgpUeDRwuXNqP
	 KFqpHF3R6S0LWyUiCHjV8bd2qxGWMxeIk4YilEvozbr3JITNqEnkSZ65qsZwgwxvRUJ07
	 S3ikr1JUZQZpLY21xwFOjgxI7oKYpvpRAJ+TjVIPnusEoPFHpz31lB1dSRBDIObg9oK0R
	 Qaqy9k9RWlWRNEx80NOQwBb+naqL6Zqc9wHlQM9JMsUCOjEeoBAKDDOFpUfxdkS2NGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795659044;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=7Xrm3Ii2UMn6o6i/Sx3ADDnGnCPb7sChuDPD//evDPc=;
	b=sfDOs6if9V7LD5Vgi7Hr3oo2BB/mFplFHBWKO+p+Ac+FmXVJ7pZGgqX/sTqOh2buMXHa
	 DiV2STqiCmlFDA2PycSFw2gyZhd5GWGSGMRzpw7utS8RfwnlXRCSVoDMB/Rh10cAd0YBk
	 G/JVPwHYfkckW35iIlESvsyuqnao7QfkflzAPmi2iKUzGidKPkPlB6aLPrIZNMDu+QO0e
	 5+w5RiBEhkZVApeYjh5UaZ94F+Z2vzj/JzDKkksp6itFMdFJTTH4BqMaF4GNRqGzOGuZt
	 0J5v124sx2I7Upur8uqV82t44O5sW5Kd4JIE2hAjd4yr/094GEYFqA7dExra+CVu4dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Gud3aQtn;
	arc=none smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4250606A321
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 02:10:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4250606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Gud3aQtn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795659044; x=1827195044;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5cPPsvKVfKbmEot/zcim5f/Zke1K+AxY3gPtiCc13S0=;
  b=Gud3aQtnxcZ1XLkS/UYWdpFW5daSVsen7onmhG+hMVqSMmilXDRyLyYg
   c3CH9SmqO4/f8nry2rv/BemZQR/m2C12cjNfacsMpD59yy6u6tLkU+Eym
   UB3yJwug00VvjLjnU48VgsQSum89LwHnZ5XkfjF/giVnoCsGqZMhantcW
   izKzJ7mgTpbCgFbtoBjYjfssC8LBE/9MQ8vQxsW2DXdeTJeTufw6Tzbju
   iEwBEdoJyoOqewiktyQB9gOhOH70o1/tf8cnyazLlw1xkI5YGNabawOnW
   zbVuKRwAEFJIi453sszYiNYP+2MJPL4+7G1uAe8c4Dxd7sO9Xrmevu7s7
   A==;
X-CSE-ConnectionGUID: tT6R7Xx6SjicrmLfMHnopw==
X-CSE-MsgGUID: aJnx5o2jQ72cChfZ+vipfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4576882"
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="4576882"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 18:10:43 -0800
X-CSE-ConnectionGUID: CFmCtIdJSgCv7Rg1Busaug==
X-CSE-MsgGUID: pparLZx3QaeJTphX7N1TDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="11904551"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 25 Nov 2026 18:10:41 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWOwY-00000001T78-1FF6;
	Thu, 26 Nov 2026 02:10:38 +0000
Date: Thu, 26 Nov 2026 10:09:39 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-btrfs@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v8 25/27] btrfs: zoned: keep a zone free for relocation
 when allocating data chunks
Message-ID: <20261126095818.PPaSJDyv-lkp@intel.com>
References: <20261125102956.266389-26-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20261125102956.266389-26-johannes.thumshirn@wdc.com>

Hi Johannes,

kernel test robot noticed the following build errors:

[auto build test ERROR on kdave/for-next]
[also build test ERROR on btrfs/for-next]
[cannot apply to linux-review/Johannes-Thumshirn/btrfs-zoned-don-t-wait-for-a-zone-finish-after-a-filesystem-error/20261117-195824 linus/master v7.4-rc4 next-20261125]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Johannes-Thumshirn/btrfs-zoned-don-t-wait-for-a-zone-finish-after-a-filesystem-error/20261125-112930
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
patch link:    https://lore.kernel.org/r/20261125102956.266389-26-johannes.thumshirn%40wdc.com
patch subject: [PATCH v8 25/27] btrfs: zoned: keep a zone free for relocation when allocating data chunks
config: hexagon-randconfig-1000-20261126 (https://download.01.org/0day-ci/archive/20261126/20261126095818.PPaSJDyv-lkp@intel.com/config)
compiler: clang version 21.1.8 (https://github.com/llvm/llvm-project 2078da43e25a4623cab2d0d60decddf709aaea28)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261126/20261126095818.PPaSJDyv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261126095818.PPaSJDyv-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: __hexagon_udivdi3
   >>> referenced by zoned.c
   >>>               fs/btrfs/zoned.o:(btrfs_zoned_data_chunk_allowed) in archive vmlinux.a
   >>> referenced by zoned.c
   >>>               fs/btrfs/zoned.o:(btrfs_zoned_data_chunk_allowed) in archive vmlinux.a
   >>> did you mean: __hexagon_udivsi3
   >>> defined in: vmlinux.a(arch/hexagon/lib/udivsi3.o)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
