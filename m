Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DA22D1F44
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Aug 2026 22:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786227622; cv=none; b=nluFE1vnqsWX8Hf/GDfxojHOeRnnqLgdLB77WgoqQXOOoQzW9wcavPEsQJb3a2WrRDF2hgXrxQcy5QLQhNjx38ZkNoZs/WWoUAlSDIJ2gsJwJcX9rc9iTKRE1yiss9P9zKbHZ7TImiFVfEpkjj6zc9/kWZNwZz68tX+/7Sp4+sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786227622; c=relaxed/simple;
	bh=ShKimpRPkyn5dp6RpZlNmH6gSFr5rOw/auN6UnVXT3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gibDNfAa4hEJckoI2hUH9nso4ihvytyrC1+/G+8r/4AFFXf9etQ/28BhI3Ow/7xpkWBRI+VSwYJsn8S2F0OVPAovaLEm+z0QiaEnqTvZ+IBE0J/xTOAwVCW47J5S0bu3fRb8fQmMU9XMNp46wMA9k+4a5QFkLUvxQrO7GZzhFT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G7zELRmF; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G7zELRmF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786227619; x=1817763619;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ShKimpRPkyn5dp6RpZlNmH6gSFr5rOw/auN6UnVXT3Y=;
  b=G7zELRmFQkv09HCTCoIY61pW7ZEFM9oNd0xl7woQo8ffv5DuQYfRnxoM
   0Y0M+lxFXOD47VbVoSeV4efJKMLZSiMW/jWh/0CsTMPv2yj3UfhRKtdQE
   IWiw0Hh6fW0rbiWFgWR9xg9h+93KabVWBm5LmSuyURKhJQaVzr5G+mNFe
   y3wgDj02ZmEL/CzZFy2bX3MYJCXT4YERaPIJaWEWlaVhB2wiscLBIwiS4
   chjwsWn85z3zLIZe5jfb0AedzZyaheMprXCU4/AlbN9f8ILZARskQ/2pf
   ZI1Ql1ITuEvIJXkhBgN+U92iH5eY6cO0yVsQqNNqEYVB2UcfYxfXhbDIh
   w==;
X-CSE-ConnectionGUID: qAf3B8M2SBqhWK7jIw4XcA==
X-CSE-MsgGUID: kV03KYqIS+qAkWTUkJWB8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11869"; a="86903808"
X-IronPort-AV: E=Sophos;i="6.25,212,1779174000"; 
   d="scan'208";a="86903808"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2026 15:20:18 -0700
X-CSE-ConnectionGUID: zw4HOGf+Qve+KuM4A2rF+Q==
X-CSE-MsgGUID: MEkLvKlgRPa6dg6g3zGnEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,212,1779174000"; 
   d="scan'208";a="266545170"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 08 Aug 2026 15:20:17 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wspOo-00000000Ksn-3t5T;
	Sat, 08 Aug 2026 22:20:14 +0000
Date: Sun, 9 Aug 2026 06:19:33 +0800
From: kernel test robot <lkp@intel.com>
To: Sun YangKai <sunk67188@gmail.com>, linux-btrfs@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Sun YangKai <sunyangkai@fnnas.com>
Subject: Re: [PATCH] btrfs: check if root is readonly when setting posix acl
Message-ID: <202608090528.DQ0KtccR-lkp@intel.com>
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
[cannot apply to kdave/for-next next-20260807]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sun-YangKai/btrfs-check-if-root-is-readonly-when-setting-posix-acl/20260807-183739
base:   linus/master
patch link:    https://lore.kernel.org/r/20260709071529.4033-1-sunk67188%40gmail.com
patch subject: [PATCH] btrfs: check if root is readonly when setting posix acl
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260809/202608090528.DQ0KtccR-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260809/202608090528.DQ0KtccR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608090528.DQ0KtccR-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/btrfs/acl.c:110:26: error: call to undeclared function 'BTRFS_I'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     110 |         if (btrfs_root_readonly(BTRFS_I(inode)->root))
         |                                 ^
>> fs/btrfs/acl.c:110:42: error: member reference type 'int' is not a pointer
     110 |         if (btrfs_root_readonly(BTRFS_I(inode)->root))
         |                                 ~~~~~~~~~~~~~~  ^
   2 errors generated.


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
