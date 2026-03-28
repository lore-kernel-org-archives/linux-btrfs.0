Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ACD378D68;
	Sat, 28 Mar 2026 09:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774691724; cv=none; b=EYmFo0wxdq+nwmuJydZXtUrj9WZVH8p9I94UJBh6YqzJrAC/swoStecSTIih273WDIMKfrs+OjQgXKz76WZxLqtqjSn4jwvrLjnxY3nZasHflRSmrpz0LuxTqDnHvijGQIiFPbw3QFuE/zib0UrNiKcXycJgnrJIBp3IOqx2vk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774691724; c=relaxed/simple;
	bh=GAqpCsRCdatJLMn/LB4VPXAG5/+DxNvNB1DDK+7U/SA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l50HweUmOCu4yvSkPG/HEa+W5wh1ZRmkoou1zMy9dUJq9TeaV/aYCIR5x9fwKu+xCVJF7BdXxFQv5P3nEoUEHf8/yURaYn846Z17g0lVcO8ONLIGwGBmO2k0qdAJO4mkyC0TrCDPXELzcWig6rBCc8QjVXtGBNn3zbmAr5nRtvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hCQf05mQ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hCQf05mQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774691723; x=1806227723;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GAqpCsRCdatJLMn/LB4VPXAG5/+DxNvNB1DDK+7U/SA=;
  b=hCQf05mQyKUG/4yUibUBFYnfQjH2vwpwLGOwF3rAb9zeDUS90uO2aztN
   GG79sKnjtoaq7UV/Agaj6dBGuq0bG/G44O93+jJtT86WkAn4AZ6W2893k
   AXmrjwk68AgbCAH3FVs841a2L9sH+yfPw5ktjm4RNDrq3GCB+917MbYBx
   QRq4aj0J8PiP8aJl7OJvO3Fz1GKzXCLX6a5rtqDIbSh1GrLKwPO1ifulh
   lvUwqCsVel5MaUc0xArUBWXAEKY4Lji6nkofBed9DCxnkr5zSMVj2Gi8o
   wAPkfYgecd1sT97nHikl/oWyA0++Y6sVgSOYpDOXIawGLadYCRIw1mn62
   g==;
X-CSE-ConnectionGUID: /vyV7dRkSUuVlpNPLQyYYg==
X-CSE-MsgGUID: uGtkHkMqRJiOAj9g9D+spg==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75633832"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75633832"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 02:55:19 -0700
X-CSE-ConnectionGUID: mkBLqmVQQa+7lsX1dF1hXw==
X-CSE-MsgGUID: nMNCMgLgQ7q8oZG85wWGBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="248786209"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 28 Mar 2026 02:55:13 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6QNp-00000000BI3-3sXI;
	Sat, 28 Mar 2026 09:55:09 +0000
Date: Sat, 28 Mar 2026 17:54:52 +0800
From: kernel test robot <lkp@intel.com>
To: Zi Yan <ziy@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Chris Mason <chris.mason@fusionio.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 07/10] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
Message-ID: <202603281736.bi9GWnsF-lkp@intel.com>
References: <20260327014255.2058916-8-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-8-ziy@nvidia.com>

Hi Zi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on brauner-vfs/vfs.all kdave/for-next linus/master v7.0-rc5 next-20260327]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zi-Yan/mm-remove-READ_ONLY_THP_FOR_FS-Kconfig-option/20260327-142622
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260327014255.2058916-8-ziy%40nvidia.com
patch subject: [PATCH v1 07/10] mm/truncate: use folio_split() in truncate_inode_partial_folio()
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260328/202603281736.bi9GWnsF-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260328/202603281736.bi9GWnsF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603281736.bi9GWnsF-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:21:
   In file included from include/linux/mm.h:1746:
>> include/linux/huge_mm.h:625:1: error: expected identifier or '('
     625 | {
         | ^
   1 error generated.
   make[3]: *** [scripts/Makefile.build:184: arch/x86/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1337: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +625 include/linux/huge_mm.h

e220917fa50774f Luis Chamberlain 2024-08-22  622  
9ee18d22957981f Zi Yan           2026-03-26  623  static inline int folio_split(struct folio *folio, unsigned int new_order,
9ee18d22957981f Zi Yan           2026-03-26  624  		struct page *page, struct list_head *list);
7460b470a131f98 Zi Yan           2025-03-07 @625  {
a488ba3124c82d7 Pankaj Raghav    2025-09-05  626  	VM_WARN_ON_ONCE_FOLIO(1, folio);
a488ba3124c82d7 Pankaj Raghav    2025-09-05  627  	return -EINVAL;
7460b470a131f98 Zi Yan           2025-03-07  628  }
7460b470a131f98 Zi Yan           2025-03-07  629  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
