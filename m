Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269A515B971;
	Sun, 28 Dec 2025 01:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766886103; cv=none; b=EGtd4or/Z1hZ1pYb04HTHSfE2zpa5xokRuPH9ODFeNmTfeZIrVQAruSegC8GS/0M8O1CrPND+SAOytDPBaVKOoa9DCodeSNCnS4enb69wXJpnyrn6D0wJXDfbLfms5wuoLwwPyO83i4HCXg/N67s3pAWL7DZneEzp74wE4VhKyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766886103; c=relaxed/simple;
	bh=XGPDATEJoD0Tjpv7B97lYqqg0PSD96XgRnmEqo5BcEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjlqB/m6YRVIo5uXlFQZBi8ytMdFluHMSgHAncJwzS1YkAQj9y6UT2G11FldE6te9Co+pf4lfdcBHbQiZnM3NrbmCGfye8hagwqoz4cZ5wweATGVXmKWQuEnIHJhZ6rqsz5Gh2an7uDUAn7sowEvUEwx9zSvD0h2K1DqvCUuP1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C/WvCQAZ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C/WvCQAZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766886100; x=1798422100;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XGPDATEJoD0Tjpv7B97lYqqg0PSD96XgRnmEqo5BcEk=;
  b=C/WvCQAZPvXs0IzxZyjiKeXXeEw8FkX9dxfsDna7ke67YekWqUQi+yS2
   zm4ptN9jsxIN4xxxRtpnN7iTTnfwmHXiHw9L5HZuQaPuyfne0fpM9oCfz
   +0ryAqIdUsQhzFFuNirqnJqUcPVyZOtSOHm+JX20LfDsFLfdMPN4HdQBw
   nYBqDCcmvn3GBtX3dPQusyudQR+9roasNg3ruImZkHG+QwaUlpBFWOIzC
   6RMrthFKoLeqEmp0J81hQ93UGyQ77bxfYNayfrSCwREqH8dWBz0air55Z
   MkV6YKZhrgw62HENtsTMEoSnkLFfUh8YpAC429HI17+jU0u2G+E2YQXog
   w==;
X-CSE-ConnectionGUID: D9UShO3uT6mxO6zR1IuDBg==
X-CSE-MsgGUID: jpGoS+6pRGiUrlXfiQj9WA==
X-IronPort-AV: E=McAfee;i="6800,10657,11654"; a="56128929"
X-IronPort-AV: E=Sophos;i="6.21,182,1763452800"; 
   d="scan'208";a="56128929"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2025 17:41:39 -0800
X-CSE-ConnectionGUID: xxgYEPKsT9mW/owCO/TLhw==
X-CSE-MsgGUID: pT9BLpqlRbGBwYqXnI3Q/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,182,1763452800"; 
   d="scan'208";a="200267571"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 27 Dec 2025 17:41:34 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vZfme-000000006BJ-2pmJ;
	Sun, 28 Dec 2025 01:41:28 +0000
Date: Sun, 28 Dec 2025 09:41:05 +0800
From: kernel test robot <lkp@intel.com>
To: Vincent Mailhol <mailhol@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Chris Mason <chris.mason@fusionio.com>,
	David Sterba <dsterba@suse.com>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kbuild@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, dri-devel@lists.freedesktop.org,
	linux-btrfs@vger.kernel.org, linux-hardening@vger.kernel.org,
	Vincent Mailhol <mailhol@kernel.org>
Subject: Re: [PATCH v3 3/3] overflow: Remove is_non_negative() and
 is_negative()
Message-ID: <202512280906.wt7UNpya-lkp@intel.com>
References: <20251220-remove_wtype-limits-v3-3-24b170af700e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220-remove_wtype-limits-v3-3-24b170af700e@kernel.org>

Hi Vincent,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 3e7f562e20ee87a25e104ef4fce557d39d62fa85]

url:    https://github.com/intel-lab-lkp/linux/commits/Vincent-Mailhol/kbuild-remove-gcc-s-Wtype-limits/20251220-190509
base:   3e7f562e20ee87a25e104ef4fce557d39d62fa85
patch link:    https://lore.kernel.org/r/20251220-remove_wtype-limits-v3-3-24b170af700e%40kernel.org
patch subject: [PATCH v3 3/3] overflow: Remove is_non_negative() and is_negative()
config: arm-randconfig-r071-20251224 (https://download.01.org/0day-ci/archive/20251228/202512280906.wt7UNpya-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 8.5.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512280906.wt7UNpya-lkp@intel.com/

smatch warnings:
fs/xfs/xfs_mount.c:144 xfs_sb_validate_fsb_count() warn: unsigned '*_d' is never less than zero.
fs/xfs/xfs_mount.c:144 xfs_sb_validate_fsb_count() warn: unsigned '_a' is never less than zero.

vim +144 fs/xfs/xfs_mount.c

27174203f570b9 Christoph Hellwig 2009-03-30  130  
4cc929ee305c69 Nathan Scott      2007-05-14  131  /*
4cc929ee305c69 Nathan Scott      2007-05-14  132   * Check size of device based on the (data/realtime) block count.
4cc929ee305c69 Nathan Scott      2007-05-14  133   * Note: this check is used by the growfs code as well as mount.
4cc929ee305c69 Nathan Scott      2007-05-14  134   */
4cc929ee305c69 Nathan Scott      2007-05-14  135  int
4cc929ee305c69 Nathan Scott      2007-05-14  136  xfs_sb_validate_fsb_count(
4cc929ee305c69 Nathan Scott      2007-05-14  137  	xfs_sb_t	*sbp,
c8ce540db5f67d Darrick J. Wong   2017-06-16  138  	uint64_t	nblocks)
4cc929ee305c69 Nathan Scott      2007-05-14  139  {
cebf9dacd5c3ce Pankaj Raghav     2024-08-22  140  	uint64_t		max_bytes;
cebf9dacd5c3ce Pankaj Raghav     2024-08-22  141  
4cc929ee305c69 Nathan Scott      2007-05-14  142  	ASSERT(sbp->sb_blocklog >= BBSHIFT);
4cc929ee305c69 Nathan Scott      2007-05-14  143  
cebf9dacd5c3ce Pankaj Raghav     2024-08-22 @144  	if (check_shl_overflow(nblocks, sbp->sb_blocklog, &max_bytes))
cebf9dacd5c3ce Pankaj Raghav     2024-08-22  145  		return -EFBIG;
cebf9dacd5c3ce Pankaj Raghav     2024-08-22  146  
d5cf09baced0ef Christoph Hellwig 2014-07-30  147  	/* Limited by ULONG_MAX of page cache index */
cebf9dacd5c3ce Pankaj Raghav     2024-08-22  148  	if (max_bytes >> PAGE_SHIFT > ULONG_MAX)
2451337dd04390 Dave Chinner      2014-06-25  149  		return -EFBIG;
4cc929ee305c69 Nathan Scott      2007-05-14  150  	return 0;
4cc929ee305c69 Nathan Scott      2007-05-14  151  }
^1da177e4c3f41 Linus Torvalds    2005-04-16  152  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
