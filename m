Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589872036E9;
	Sat, 28 Mar 2026 09:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774691722; cv=none; b=J0ZwR6pCXdfjZbBH8LqBWrZ89CZWyjW4ypKaFjXWDeyuVSP6fKqRQERzsDq5I0/GWFnmz7fGEYkdUs2rwM2wg1l0lGNWAhL3apXO1BTzwYXhVd7I0vMstgIxDjbxyDPv+qkW5WklncLILqESyeF6LXA5HPfgxOtUHQgaDqqBa34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774691722; c=relaxed/simple;
	bh=tGRNjEkmKkP55RyI36TLF24P2O39ClA0J2pu35ocaXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i1cHWh5IHTmTOfaFQ+z8a/UpVYrGQ6HvSafMM/GG7RE1FepfoOY9FGOeLsSyOpBX4DuE9RCejCnmw2K+HO/bihIdh+0PlZDm1ua+Fqqx8r/SNWfs7ZQQ/JT63P6z5zal0jyZo4ec9sXO5mY5rWFZcU5237ws52XBpzGkK0zDQoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Td77NANE; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Td77NANE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774691720; x=1806227720;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tGRNjEkmKkP55RyI36TLF24P2O39ClA0J2pu35ocaXQ=;
  b=Td77NANE9E85rUskshjPxE+WliZPVu9phaaqu+WHFxlnlnMxJEmQEE9p
   ZMRlQyE0MpRL87F/95nwzYQHClmBTmnM6mKS6o6BZJUbEvYNux/+taTeV
   xXlIBJKcLVE2fY0eVcrGNn8O1YHdozx9QEsbEioJzu8c7xGIlP9i/Cn9m
   ctyTyMlt9QA69Hv+kpl2Ulicg9+wsuKcdtN3NzkG9/Ua3Nbk27+VR0gi6
   TSsBcQlRuoaqCJPE199FbUVy1scrIYvOKn0TXvFmxkClSzlVRAE11GWV5
   kDDzSA+NSOG6vjkb9m3HG+ARacCu7/8bexJyDB1+7sJiOTyMXNhW8jOwn
   g==;
X-CSE-ConnectionGUID: MElUTVqtTAGzIGihEaFh3w==
X-CSE-MsgGUID: B7iBwJZTSJeFciKc7vNhCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75633807"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75633807"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 02:55:19 -0700
X-CSE-ConnectionGUID: v9BKKQRJS6W2wyd96Ksx5Q==
X-CSE-MsgGUID: kuXnB5WIS620/P7LJwxCMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="248786208"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 28 Mar 2026 02:55:13 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6QNp-00000000BI1-3ouf;
	Sat, 28 Mar 2026 09:55:09 +0000
Date: Sat, 28 Mar 2026 17:54:51 +0800
From: kernel test robot <lkp@intel.com>
To: Zi Yan <ziy@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: oe-kbuild-all@lists.linux.dev, Chris Mason <chris.mason@fusionio.com>,
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
Message-ID: <202603281704.ILlsxaUM-lkp@intel.com>
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
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260328/202603281704.ILlsxaUM-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260328/202603281704.ILlsxaUM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603281704.ILlsxaUM-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/mm.h:1746,
                    from include/linux/pid_namespace.h:7,
                    from include/linux/ptrace.h:10,
                    from arch/nios2/kernel/asm-offsets.c:10:
>> include/linux/huge_mm.h:625:1: error: expected identifier or '(' before '{' token
     625 | {
         | ^
>> include/linux/huge_mm.h:623:19: warning: 'folio_split' declared 'static' but never defined [-Wunused-function]
     623 | static inline int folio_split(struct folio *folio, unsigned int new_order,
         |                   ^~~~~~~~~~~
   make[3]: *** [scripts/Makefile.build:184: arch/nios2/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1337: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +625 include/linux/huge_mm.h

e220917fa50774 Luis Chamberlain 2024-08-22  622  
9ee18d22957981 Zi Yan           2026-03-26 @623  static inline int folio_split(struct folio *folio, unsigned int new_order,
9ee18d22957981 Zi Yan           2026-03-26  624  		struct page *page, struct list_head *list);
7460b470a131f9 Zi Yan           2025-03-07 @625  {
a488ba3124c82d Pankaj Raghav    2025-09-05  626  	VM_WARN_ON_ONCE_FOLIO(1, folio);
a488ba3124c82d Pankaj Raghav    2025-09-05  627  	return -EINVAL;
7460b470a131f9 Zi Yan           2025-03-07  628  }
7460b470a131f9 Zi Yan           2025-03-07  629  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
