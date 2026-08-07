Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D113478E20
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2026 12:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786107402; cv=none; b=b/NcxoWtIatoXwulcNsP+Fe++dwVgjJufS0C2UH9Ro8imwheYWEBgviPo9G0xEy+AMe66uWnNz002PsMfanFkL3HQnpclemEyfoU81VWa6itBkncjWqlT94sbSPIGEj8Ehv0LHvIWDgkKoC5QF+RutKTqzj0Xr1O84gDiKxf3IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786107402; c=relaxed/simple;
	bh=PEbAMoff827kAviFUHr88q3xvr3rVhcfj8DtBLJdft4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X882sYRuR0UY0DKrBaVhoEzwEWGMphh1ZAMOXQ46RtSrM3fVx2I6nT5MHjT9i99RT4DxP2+kMM7kerPC7wb11zkx+NAjv/ehoz1v5edSonXws7VbFrNkV7nmvK1XjeaGbTuLCtUSpngGRsXjVbFw5gFW/yOatGAxTVd+0DGvd0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R0Qrrufa; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R0Qrrufa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786107397; x=1817643397;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PEbAMoff827kAviFUHr88q3xvr3rVhcfj8DtBLJdft4=;
  b=R0QrrufatW8+zpfsUO2VExbl6jCwAWO+Ncie0Tn8yZrBWbQLSbzGZ8sG
   wRZF/PUgos6i2W9yHJnA8egXG2mVlhL1FUKFnRl64fXrjuDW2/DMZgY5o
   MbYbZ5Qe/xssBWlCBLSQ24gzexd9jGy0pWpjcWssAwitowg0B/MK7sydj
   vNDo1KZEI+TvYUya0etk0391648B7SbsxMqpdN7hQo7QB1I4Cle9NiK88
   H+FdWJ5tieFrAhWkJgb0WeyRVpFGgbkH5gbSmDOCC+LX/0V5QE7LhZS83
   3/Pr3Tiwjn2qqgyvcbazpdgYN+SsXxnJEC96QspYAD01ofx5tXJLrR3KQ
   g==;
X-CSE-ConnectionGUID: 3LB+EOeESGmd3a379L1IkQ==
X-CSE-MsgGUID: X8kO2W10QMmWfw/HvhFAqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11867"; a="97064308"
X-IronPort-AV: E=Sophos;i="6.25,210,1779174000"; 
   d="scan'208";a="97064308"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 05:56:34 -0700
X-CSE-ConnectionGUID: Gi5HKVBJSkyQRu3qYs/OzA==
X-CSE-MsgGUID: 4xyoRoUOQ+mthxCW5psUYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,210,1779174000"; 
   d="scan'208";a="256170391"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 07 Aug 2026 05:56:32 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wsK7h-00000000IFl-2SCM;
	Fri, 07 Aug 2026 12:56:29 +0000
Date: Fri, 7 Aug 2026 20:56:23 +0800
From: kernel test robot <lkp@intel.com>
To: Sun YangKai <sunk67188@gmail.com>, linux-btrfs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Sun YangKai <sunyangkai@fnnas.com>
Subject: Re: [PATCH] btrfs: check if root is readonly when setting posix acl
Message-ID: <202608072012.WLkLdXMW-lkp@intel.com>
References: <20260709071529.4033-1-sunk67188@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709071529.4033-1-sunk67188@gmail.com>

Hi Sun,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.2-rc6]
[cannot apply to kdave/for-next next-20260806]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sun-YangKai/btrfs-check-if-root-is-readonly-when-setting-posix-acl/20260807-183739
base:   linus/master
patch link:    https://lore.kernel.org/r/20260709071529.4033-1-sunk67188%40gmail.com
patch subject: [PATCH] btrfs: check if root is readonly when setting posix acl
config: alpha-allmodconfig (https://download.01.org/0day-ci/archive/20260807/202608072012.WLkLdXMW-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260807/202608072012.WLkLdXMW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608072012.WLkLdXMW-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/btrfs/acl.c: In function 'btrfs_set_acl':
>> fs/btrfs/acl.c:110:33: error: implicit declaration of function 'BTRFS_I' [-Wimplicit-function-declaration]
     110 |         if (btrfs_root_readonly(BTRFS_I(inode)->root))
         |                                 ^~~~~~~
>> fs/btrfs/acl.c:110:47: error: invalid type argument of '->' (have 'int')
     110 |         if (btrfs_root_readonly(BTRFS_I(inode)->root))
         |                                               ^~


vim +/BTRFS_I +110 fs/btrfs/acl.c

   102	
   103	int btrfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
   104			  struct posix_acl *acl, int type)
   105	{
   106		int ret;
   107		struct inode *inode = d_inode(dentry);
   108		umode_t old_mode = inode->i_mode;
   109	
 > 110		if (btrfs_root_readonly(BTRFS_I(inode)->root))

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
