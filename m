Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792446813;
	b=PdFSYAoCsyeM4Ra5Bm9zBJvtk0FW5p20KpKABHMyiHSNvy3MXyC7GilsN/UemO2KBNgf
	 rtNmIaCsASyZgTm7z8oSyiZm7NK4zGFDivRTz8fYHIpYbh0QgUpjIz/jNgpAJMk5EByqP
	 NtK3WJDwWyt7lJ8lTi40b7eQwJmxxEzTnylP5GFe5tsKOR75vzeW5cKWdhMpqohuM9dSd
	 N+YDulkFYX2hMauZQ3Kc+t6rQshALCC14HbuggxFSSzjIBxUbp1rId3TEiz7IUh61q+83
	 yREoBqTsSju3pxqnn1DGrXT4MQ5vclNBRd82cUckOPSoPaf2O8C79MG0A0mZZZZZ4kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792446813;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=deJ4JDd7JrQ46MApnKk9GC8z8ZzpAvU7U9Bz2cxAbP8=;
	b=GAUQZeIA8Qbun90GmATgK22UXlQq5ycMSfUZ3LW7PHdbJ/AECMwNDUPDo/BMfcc/3RSD
	 H8C9gEXWFJLbv9O3z8vmsJJWolnVjedst+BVqGEvNplV4VtIg9lVNnzzAsdLGVfSaH0hu
	 MM9c2gpTMehzaaRAelMlixGlKS6ISo6uNW6+vWRwu61mCIKGuimruWJ7458Ugtee2VGZl
	 MGZ4+fbrnN/72qmgDaKnDnhbm1+ZsrNkiV68PGR/WAI+3f6koJyQkkWcny7gEJuDG6GX1
	 a71c/DwTTjN0oc1Lid/03C0wHb7jPBAyCjWicvCopOBaKskC3EkF7uBNbYoHnQkbgEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=a4Devs1T;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FDE606A31B
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 21:53:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35FDE606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=a4Devs1T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792446811; x=1823982811;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w+SxmmuWZ0wgtYyeJ6jlaBhya4rjOcaFx2xwl7Ub0Tk=;
  b=a4Devs1TCdrb5zekFj54koAGhZ6p6yBiF3+D5MLoSh0zAGF0NiARzRm2
   lRBKeZ87Sgo5ByTTdmVqDXeVvUmUOKfO/azYCFh3O/9thrbKqC4k56fau
   vqbnrVffRLyL3ExxMQh0GewoosvMRb+heXU2dL2ot4JPIZq3ZRgT/gFal
   F/Jf23Scy3Gj4Ce3cly2B3+P5GonOHScUPIy+pkl+5XbviKhVyXt/gyD4
   tRbnADTxJSG6b6+i+hxwMgePTJCiS6xv8031XNf8CFgSAgrB+/qvi0p9h
   3gbdIwMrBYpi9qYzFn6qJFe0H4DYyF86wFANx6Api7wmZwTQPX4ysOFVC
   g==;
X-CSE-ConnectionGUID: WmQpGFyaSiW6RwKZPdL6pA==
X-CSE-MsgGUID: ZWGQzeuyRPGHqj993rLLdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1022208"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1022208"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 14:53:31 -0700
X-CSE-ConnectionGUID: ZcCftAquTjOYPbzpgNZtTw==
X-CSE-MsgGUID: RUi1VPXOS7a1kLBD36+wMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2593589"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 19 Oct 2026 14:53:30 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIvIN-00000000MTK-2CNb;
	Mon, 19 Oct 2026 21:53:27 +0000
Date: Tue, 20 Oct 2026 05:52:43 +0800
From: kernel test robot <lkp@intel.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5/9] btrfs: add a new 'stripe_len' parameter to
 btrfs_stripe_nr_to_offset()
Message-ID: <202610200549.0ma4is7Y-lkp@intel.com>
References: <48b407f8488edc890710cdf8ebfefe413e7721c2.1792391732.git.wqu@suse.com>
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
In-Reply-To: <48b407f8488edc890710cdf8ebfefe413e7721c2.1792391732.git.wqu@suse.com>

Hi Qu,

kernel test robot noticed the following build errors:

[auto build test ERROR on btrfs/for-next]
[also build test ERROR on linus/master v7.3 next-20261016]
[cannot apply to kdave/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qu-Wenruo/btrfs-reduce-the-width-of-num_stripes-and-sub_stripes/20261019-170957
base:   https://github.com/btrfs/linux.git for-next
patch link:    https://lore.kernel.org/r/48b407f8488edc890710cdf8ebfefe413e7721c2.1792391732.git.wqu%40suse.com
patch subject: [PATCH 5/9] btrfs: add a new 'stripe_len' parameter to btrfs_stripe_nr_to_offset()
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20261020/202610200549.0ma4is7Y-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261020/202610200549.0ma4is7Y-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610200549.0ma4is7Y-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/error-injection.h:5,
                    from fs/btrfs/tree-checker.c:20:
   fs/btrfs/tree-checker.c: In function 'btrfs_check_chunk_valid':
>> fs/btrfs/tree-checker.c:1061:32: error: too few arguments to function 'btrfs_stripe_nr_to_offset'; expected 2, have 1
    1061 |         if (unlikely(length >= btrfs_stripe_nr_to_offset(U32_MAX))) {
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:77:45: note: in definition of macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from fs/btrfs/tree-checker.c:25:
   fs/btrfs/volumes.h:725:19: note: declared here
     725 | static inline u64 btrfs_stripe_nr_to_offset(u32 stripe_nr, u32 stripe_len)
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~
   fs/btrfs/tree-checker.c:1064:35: error: too few arguments to function 'btrfs_stripe_nr_to_offset'; expected 2, have 1
    1064 |                           length, btrfs_stripe_nr_to_offset(U32_MAX));
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~
   fs/btrfs/volumes.h:725:19: note: declared here
     725 | static inline u64 btrfs_stripe_nr_to_offset(u32 stripe_nr, u32 stripe_len)
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~


vim +/btrfs_stripe_nr_to_offset +1061 fs/btrfs/tree-checker.c

c3d6dda60c9da79 Mark Harmstone 2026-01-07   958  
82fc28fbedbb596 Qu Wenruo      2019-03-20   959  /*
82fc28fbedbb596 Qu Wenruo      2019-03-20   960   * The common chunk check which could also work on super block sys chunk array.
82fc28fbedbb596 Qu Wenruo      2019-03-20   961   *
2a9bb78cfd367fd Qu Wenruo      2024-12-21   962   * If @leaf is NULL, then @chunk must be an on-stack chunk item.
2a9bb78cfd367fd Qu Wenruo      2024-12-21   963   * (For superblock sys_chunk array, and fs_info->sectorsize is unreliable)
2a9bb78cfd367fd Qu Wenruo      2024-12-21   964   *
bf871c3b43b1dcc Qu Wenruo      2019-03-20   965   * Return -EUCLEAN if anything is corrupted.
82fc28fbedbb596 Qu Wenruo      2019-03-20   966   * Return 0 if everything is OK.
82fc28fbedbb596 Qu Wenruo      2019-03-20   967   */
2a9bb78cfd367fd Qu Wenruo      2024-12-21   968  int btrfs_check_chunk_valid(const struct btrfs_fs_info *fs_info,
2a9bb78cfd367fd Qu Wenruo      2024-12-21   969  			    const struct extent_buffer *leaf,
2a9bb78cfd367fd Qu Wenruo      2024-12-21   970  			    const struct btrfs_chunk *chunk, u64 logical,
2a9bb78cfd367fd Qu Wenruo      2024-12-21   971  			    u32 sectorsize)
82fc28fbedbb596 Qu Wenruo      2019-03-20   972  {
82fc28fbedbb596 Qu Wenruo      2019-03-20   973  	u64 length;
347fb0cfc9bab51 Su Yue         2021-01-03   974  	u64 chunk_end;
82fc28fbedbb596 Qu Wenruo      2019-03-20   975  	u64 stripe_len;
82fc28fbedbb596 Qu Wenruo      2019-03-20   976  	u16 num_stripes;
82fc28fbedbb596 Qu Wenruo      2019-03-20   977  	u16 sub_stripes;
82fc28fbedbb596 Qu Wenruo      2019-03-20   978  	u64 type;
82fc28fbedbb596 Qu Wenruo      2019-03-20   979  	u64 features;
2a9bb78cfd367fd Qu Wenruo      2024-12-21   980  	u32 chunk_sector_size;
82fc28fbedbb596 Qu Wenruo      2019-03-20   981  	bool mixed = false;
c3d6dda60c9da79 Mark Harmstone 2026-01-07   982  	bool remapped;
85d07fbe09efd1c Daniel Xu      2020-10-08   983  	int raid_index;
85d07fbe09efd1c Daniel Xu      2020-10-08   984  	int nparity;
85d07fbe09efd1c Daniel Xu      2020-10-08   985  	int ncopies;
82fc28fbedbb596 Qu Wenruo      2019-03-20   986  
2a9bb78cfd367fd Qu Wenruo      2024-12-21   987  	if (leaf) {
82fc28fbedbb596 Qu Wenruo      2019-03-20   988  		length = btrfs_chunk_length(leaf, chunk);
82fc28fbedbb596 Qu Wenruo      2019-03-20   989  		stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
82fc28fbedbb596 Qu Wenruo      2019-03-20   990  		num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
82fc28fbedbb596 Qu Wenruo      2019-03-20   991  		sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
82fc28fbedbb596 Qu Wenruo      2019-03-20   992  		type = btrfs_chunk_type(leaf, chunk);
2a9bb78cfd367fd Qu Wenruo      2024-12-21   993  		chunk_sector_size = btrfs_chunk_sector_size(leaf, chunk);
2a9bb78cfd367fd Qu Wenruo      2024-12-21   994  	} else {
2a9bb78cfd367fd Qu Wenruo      2024-12-21   995  		length = btrfs_stack_chunk_length(chunk);
2a9bb78cfd367fd Qu Wenruo      2024-12-21   996  		stripe_len = btrfs_stack_chunk_stripe_len(chunk);
2a9bb78cfd367fd Qu Wenruo      2024-12-21   997  		num_stripes = btrfs_stack_chunk_num_stripes(chunk);
2a9bb78cfd367fd Qu Wenruo      2024-12-21   998  		sub_stripes = btrfs_stack_chunk_sub_stripes(chunk);
2a9bb78cfd367fd Qu Wenruo      2024-12-21   999  		type = btrfs_stack_chunk_type(chunk);
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1000  		chunk_sector_size = btrfs_stack_chunk_sector_size(chunk);
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1001  	}
85d07fbe09efd1c Daniel Xu      2020-10-08  1002  	raid_index = btrfs_bg_flags_to_raid_index(type);
85d07fbe09efd1c Daniel Xu      2020-10-08  1003  	ncopies = btrfs_raid_array[raid_index].ncopies;
85d07fbe09efd1c Daniel Xu      2020-10-08  1004  	nparity = btrfs_raid_array[raid_index].nparity;
c3d6dda60c9da79 Mark Harmstone 2026-01-07  1005  	remapped = (type & BTRFS_BLOCK_GROUP_REMAPPED);
82fc28fbedbb596 Qu Wenruo      2019-03-20  1006  
c3d6dda60c9da79 Mark Harmstone 2026-01-07  1007  	if (unlikely(!remapped && !num_stripes)) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1008  		chunk_err(fs_info, leaf, chunk, logical,
f114024376bceb1 Qu Wenruo      2019-03-20  1009  			  "invalid chunk num_stripes, have %u", num_stripes);
bf871c3b43b1dcc Qu Wenruo      2019-03-20  1010  		return -EUCLEAN;
82fc28fbedbb596 Qu Wenruo      2019-03-20  1011  	}
c3d6dda60c9da79 Mark Harmstone 2026-01-07  1012  	if (unlikely(num_stripes != 0 && num_stripes < ncopies)) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1013  		chunk_err(fs_info, leaf, chunk, logical,
85d07fbe09efd1c Daniel Xu      2020-10-08  1014  			  "invalid chunk num_stripes < ncopies, have %u < %d",
85d07fbe09efd1c Daniel Xu      2020-10-08  1015  			  num_stripes, ncopies);
85d07fbe09efd1c Daniel Xu      2020-10-08  1016  		return -EUCLEAN;
85d07fbe09efd1c Daniel Xu      2020-10-08  1017  	}
c7c01a4a2524b3f David Sterba   2020-11-04  1018  	if (unlikely(nparity && num_stripes == nparity)) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1019  		chunk_err(fs_info, leaf, chunk, logical,
85d07fbe09efd1c Daniel Xu      2020-10-08  1020  			  "invalid chunk num_stripes == nparity, have %u == %d",
85d07fbe09efd1c Daniel Xu      2020-10-08  1021  			  num_stripes, nparity);
85d07fbe09efd1c Daniel Xu      2020-10-08  1022  		return -EUCLEAN;
85d07fbe09efd1c Daniel Xu      2020-10-08  1023  	}
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1024  	if (unlikely(!IS_ALIGNED(logical, sectorsize))) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1025  		chunk_err(fs_info, leaf, chunk, logical,
f114024376bceb1 Qu Wenruo      2019-03-20  1026  		"invalid chunk logical, have %llu should aligned to %u",
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1027  			  logical, sectorsize);
bf871c3b43b1dcc Qu Wenruo      2019-03-20  1028  		return -EUCLEAN;
82fc28fbedbb596 Qu Wenruo      2019-03-20  1029  	}
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1030  	if (unlikely(chunk_sector_size != sectorsize)) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1031  		chunk_err(fs_info, leaf, chunk, logical,
f114024376bceb1 Qu Wenruo      2019-03-20  1032  			  "invalid chunk sectorsize, have %u expect %u",
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1033  			  chunk_sector_size, sectorsize);
bf871c3b43b1dcc Qu Wenruo      2019-03-20  1034  		return -EUCLEAN;
82fc28fbedbb596 Qu Wenruo      2019-03-20  1035  	}
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1036  	if (unlikely(!length || !IS_ALIGNED(length, sectorsize))) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1037  		chunk_err(fs_info, leaf, chunk, logical,
f114024376bceb1 Qu Wenruo      2019-03-20  1038  			  "invalid chunk length, have %llu", length);
bf871c3b43b1dcc Qu Wenruo      2019-03-20  1039  		return -EUCLEAN;
82fc28fbedbb596 Qu Wenruo      2019-03-20  1040  	}
347fb0cfc9bab51 Su Yue         2021-01-03  1041  	if (unlikely(check_add_overflow(logical, length, &chunk_end))) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1042  		chunk_err(fs_info, leaf, chunk, logical,
347fb0cfc9bab51 Su Yue         2021-01-03  1043  "invalid chunk logical start and length, have logical start %llu length %llu",
347fb0cfc9bab51 Su Yue         2021-01-03  1044  			  logical, length);
347fb0cfc9bab51 Su Yue         2021-01-03  1045  		return -EUCLEAN;
347fb0cfc9bab51 Su Yue         2021-01-03  1046  	}
c7c01a4a2524b3f David Sterba   2020-11-04  1047  	if (unlikely(!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN)) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1048  		chunk_err(fs_info, leaf, chunk, logical,
f114024376bceb1 Qu Wenruo      2019-03-20  1049  			  "invalid chunk stripe length: %llu",
82fc28fbedbb596 Qu Wenruo      2019-03-20  1050  			  stripe_len);
bf871c3b43b1dcc Qu Wenruo      2019-03-20  1051  		return -EUCLEAN;
82fc28fbedbb596 Qu Wenruo      2019-03-20  1052  	}
6ded22c1bfe6a8a Qu Wenruo      2023-02-17  1053  	/*
6ded22c1bfe6a8a Qu Wenruo      2023-02-17  1054  	 * We artificially limit the chunk size, so that the number of stripes
6ded22c1bfe6a8a Qu Wenruo      2023-02-17  1055  	 * inside a chunk can be fit into a U32.  The current limit (256G) is
6ded22c1bfe6a8a Qu Wenruo      2023-02-17  1056  	 * way too large for real world usage anyway, and it's also much larger
6ded22c1bfe6a8a Qu Wenruo      2023-02-17  1057  	 * than our existing limit (10G).
6ded22c1bfe6a8a Qu Wenruo      2023-02-17  1058  	 *
6ded22c1bfe6a8a Qu Wenruo      2023-02-17  1059  	 * Thus it should be a good way to catch obvious bitflips.
6ded22c1bfe6a8a Qu Wenruo      2023-02-17  1060  	 */
cb091225a538005 Qu Wenruo      2023-06-22 @1061  	if (unlikely(length >= btrfs_stripe_nr_to_offset(U32_MAX))) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1062  		chunk_err(fs_info, leaf, chunk, logical,
6ded22c1bfe6a8a Qu Wenruo      2023-02-17  1063  			  "chunk length too large: have %llu limit %llu",
cb091225a538005 Qu Wenruo      2023-06-22  1064  			  length, btrfs_stripe_nr_to_offset(U32_MAX));
6ded22c1bfe6a8a Qu Wenruo      2023-02-17  1065  		return -EUCLEAN;
6ded22c1bfe6a8a Qu Wenruo      2023-02-17  1066  	}
ef6a31d035a1000 Mark Harmstone 2026-01-07  1067  	if (unlikely(type & ~BTRFS_BLOCK_GROUP_VALID)) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1068  		chunk_err(fs_info, leaf, chunk, logical,
f114024376bceb1 Qu Wenruo      2019-03-20  1069  			  "unrecognized chunk type: 0x%llx",
ef6a31d035a1000 Mark Harmstone 2026-01-07  1070  			  type & ~BTRFS_BLOCK_GROUP_VALID);
bf871c3b43b1dcc Qu Wenruo      2019-03-20  1071  		return -EUCLEAN;
82fc28fbedbb596 Qu Wenruo      2019-03-20  1072  	}
82fc28fbedbb596 Qu Wenruo      2019-03-20  1073  
c7c01a4a2524b3f David Sterba   2020-11-04  1074  	if (unlikely(!has_single_bit_set(type & BTRFS_BLOCK_GROUP_PROFILE_MASK) &&
c7c01a4a2524b3f David Sterba   2020-11-04  1075  		     (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) != 0)) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1076  		chunk_err(fs_info, leaf, chunk, logical,
80e46cf22ba0bcb Qu Wenruo      2019-03-13  1077  		"invalid chunk profile flag: 0x%llx, expect 0 or 1 bit set",
80e46cf22ba0bcb Qu Wenruo      2019-03-13  1078  			  type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
80e46cf22ba0bcb Qu Wenruo      2019-03-13  1079  		return -EUCLEAN;
80e46cf22ba0bcb Qu Wenruo      2019-03-13  1080  	}
c7c01a4a2524b3f David Sterba   2020-11-04  1081  	if (unlikely((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0)) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1082  		chunk_err(fs_info, leaf, chunk, logical,
f114024376bceb1 Qu Wenruo      2019-03-20  1083  	"missing chunk type flag, have 0x%llx one bit must be set in 0x%llx",
f114024376bceb1 Qu Wenruo      2019-03-20  1084  			  type, BTRFS_BLOCK_GROUP_TYPE_MASK);
bf871c3b43b1dcc Qu Wenruo      2019-03-20  1085  		return -EUCLEAN;
82fc28fbedbb596 Qu Wenruo      2019-03-20  1086  	}
82fc28fbedbb596 Qu Wenruo      2019-03-20  1087  
c7c01a4a2524b3f David Sterba   2020-11-04  1088  	if (unlikely((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
c7c01a4a2524b3f David Sterba   2020-11-04  1089  		     (type & (BTRFS_BLOCK_GROUP_METADATA |
c7c01a4a2524b3f David Sterba   2020-11-04  1090  			      BTRFS_BLOCK_GROUP_DATA)))) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1091  		chunk_err(fs_info, leaf, chunk, logical,
f114024376bceb1 Qu Wenruo      2019-03-20  1092  			  "system chunk with data or metadata type: 0x%llx",
f114024376bceb1 Qu Wenruo      2019-03-20  1093  			  type);
bf871c3b43b1dcc Qu Wenruo      2019-03-20  1094  		return -EUCLEAN;
82fc28fbedbb596 Qu Wenruo      2019-03-20  1095  	}
82fc28fbedbb596 Qu Wenruo      2019-03-20  1096  
82fc28fbedbb596 Qu Wenruo      2019-03-20  1097  	features = btrfs_super_incompat_flags(fs_info->super_copy);
82fc28fbedbb596 Qu Wenruo      2019-03-20  1098  	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
82fc28fbedbb596 Qu Wenruo      2019-03-20  1099  		mixed = true;
82fc28fbedbb596 Qu Wenruo      2019-03-20  1100  
82fc28fbedbb596 Qu Wenruo      2019-03-20  1101  	if (!mixed) {
c7c01a4a2524b3f David Sterba   2020-11-04  1102  		if (unlikely((type & BTRFS_BLOCK_GROUP_METADATA) &&
c7c01a4a2524b3f David Sterba   2020-11-04  1103  			     (type & BTRFS_BLOCK_GROUP_DATA))) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1104  			chunk_err(fs_info, leaf, chunk, logical,
82fc28fbedbb596 Qu Wenruo      2019-03-20  1105  			"mixed chunk type in non-mixed mode: 0x%llx", type);
bf871c3b43b1dcc Qu Wenruo      2019-03-20  1106  			return -EUCLEAN;
82fc28fbedbb596 Qu Wenruo      2019-03-20  1107  		}
82fc28fbedbb596 Qu Wenruo      2019-03-20  1108  	}
82fc28fbedbb596 Qu Wenruo      2019-03-20  1109  
18addf9ec82f857 Mark Harmstone 2026-03-04  1110  	if (unlikely((type & BTRFS_BLOCK_GROUP_METADATA_REMAP) &&
18addf9ec82f857 Mark Harmstone 2026-03-04  1111  		     !(features & BTRFS_FEATURE_INCOMPAT_REMAP_TREE))) {
18addf9ec82f857 Mark Harmstone 2026-03-04  1112  		chunk_err(fs_info, leaf, chunk, logical,
18addf9ec82f857 Mark Harmstone 2026-03-04  1113  		"METADATA_REMAP chunk type without REMAP_TREE incompat bit");
18addf9ec82f857 Mark Harmstone 2026-03-04  1114  		return -EUCLEAN;
18addf9ec82f857 Mark Harmstone 2026-03-04  1115  	}
18addf9ec82f857 Mark Harmstone 2026-03-04  1116  
18addf9ec82f857 Mark Harmstone 2026-03-04  1117  	if (unlikely(remapped &&
18addf9ec82f857 Mark Harmstone 2026-03-04  1118  		     !(features & BTRFS_FEATURE_INCOMPAT_REMAP_TREE))) {
18addf9ec82f857 Mark Harmstone 2026-03-04  1119  		chunk_err(fs_info, leaf, chunk, logical,
18addf9ec82f857 Mark Harmstone 2026-03-04  1120  		"REMAPPED chunk flag without REMAP_TREE incompat bit");
18addf9ec82f857 Mark Harmstone 2026-03-04  1121  		return -EUCLEAN;
18addf9ec82f857 Mark Harmstone 2026-03-04  1122  	}
18addf9ec82f857 Mark Harmstone 2026-03-04  1123  
a6e5521ecc5e712 Filipe Manana  2026-09-16  1124  	if (unlikely(!remapped &&
c3d6dda60c9da79 Mark Harmstone 2026-01-07  1125  		     !valid_stripe_count(type & BTRFS_BLOCK_GROUP_PROFILE_MASK,
a6e5521ecc5e712 Filipe Manana  2026-09-16  1126  					 num_stripes, sub_stripes))) {
2a9bb78cfd367fd Qu Wenruo      2024-12-21  1127  		chunk_err(fs_info, leaf, chunk, logical,
82fc28fbedbb596 Qu Wenruo      2019-03-20  1128  			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
82fc28fbedbb596 Qu Wenruo      2019-03-20  1129  			num_stripes, sub_stripes,
82fc28fbedbb596 Qu Wenruo      2019-03-20  1130  			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
bf871c3b43b1dcc Qu Wenruo      2019-03-20  1131  		return -EUCLEAN;
82fc28fbedbb596 Qu Wenruo      2019-03-20  1132  	}
82fc28fbedbb596 Qu Wenruo      2019-03-20  1133  
82fc28fbedbb596 Qu Wenruo      2019-03-20  1134  	return 0;
fce466eab7ac6ba Qu Wenruo      2018-07-03  1135  }
fce466eab7ac6ba Qu Wenruo      2018-07-03  1136  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
