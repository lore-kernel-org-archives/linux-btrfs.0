Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320206;
	b=nPd3dsI97ObWy1E+60DwNamQaOOP9p1zdRvoXvbXGSL2CnKBiVa967VAlzs7t6PtQjac
	 X6ljtRe3UO1yFF8CjB/V5dJHPQcwoNTrV5K/pc4CGnL8DhlTJac1vapQC0K4wqAnmwtmj
	 MPSUprWRxbp0hndIFTUzCnkvpIPmA+l8SgK5z3OA5A9UDtfbBReU5Qb+utDSMuHokoRax
	 1UQvoQeGOSeSCpFR+A9v+lV4TKHlx9Hja6s6CnTVKytzJRbdrSPcLbqxheXRoW69u6pls
	 qSPZtq11qIbOeSd7QxYuZagJskvYgC+igcjzOo+4/7+OTi/HanHcNYlJKSgsVyaPugg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320206;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=4+eeFvuJfyHDd+BuwMG2B+Gd8aNxZAE+8wiGXBSlO+s=;
	b=xS63fvH4b7YlA1/LFjRLVjYu0WkTW4I0LZt5cmWg6sVFUf0CM5xPBx4AjXN7y6Yl4Svm
	 2VfMFy0ctFS0MpxugLw3cyQc+75JmIAdiape27MJrNYfc4f1fAyc2PGMZdaRhKyfmNrJs
	 VCOb36dBSCa0xt6Zobn15rk+xsI3SUGhpTBnTuFuEVby47NWUwD5vhZ2cQOZISM41JwPH
	 c+Omn+Yult66h5OrtBaZ6GM5oyC4vDXE/LgZjdo+PaedEdlC/IUqk2Kkiz2N2fEMIxnPG
	 iwaKZPWs82HRhqtBEhsUA1K/A3e73+qyQSmh9nveuQoXiOMlhRmqJWJ7p1lzvoPnwYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SAqh8Bs2;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BFB606A32A;
	Tue, 10 Nov 2026 14:16:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48BFB606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SAqh8Bs2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794320207; x=1825856207;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qHIoRdta/Rz12+sgDyk+MbbHJpDaq49xq1iYbp05iFo=;
  b=SAqh8Bs2qK5EjAJ/3pxC2yV8fjHpkZZsIasREG34gZ2cjEsn4K61RGyN
   nlq9u9/Np7qGdiHgkpyWCuSEaEkRBP7G5U7NtJell7FF0p6uXRshpKvns
   +U9TLEVw7UgsoJws4rliKqRcXOjnI2nnTOvMT2m81q8C26mu+EAcNH3d8
   mzgQRwMwC4eWf0h2sqgPOUUcTkNa11TPZFzwtjn5EO4mNyLFjN5VY22qe
   p9XBDttVSUHX3cs1vtoCBBde/GxRxB9zELQZtu1eoDkUG2OwADNz9zmcZ
   pxJ5FMc3F1Vh9PoA9YOcEHwtZ6KAC077/92Wle9IuDzPFXXRy2SDg7ack
   A==;
X-CSE-ConnectionGUID: rCnyLOtmRqG60fKEGxBh4g==
X-CSE-MsgGUID: 03ut2M50QmiWJSrhT15WQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2971072"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2971072"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 06:16:46 -0800
X-CSE-ConnectionGUID: TjYZSHtDQLCCdUxLQAHSMA==
X-CSE-MsgGUID: bYRN2TmjTzSgMB/r4uvwpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="7992142"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 10 Nov 2026 06:16:44 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQmeQ-00000000wwt-0Do9;
	Tue, 10 Nov 2026 14:16:42 +0000
Date: Tue, 10 Nov 2026 22:15:50 +0800
From: kernel test robot <lkp@intel.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, ebiggers@kernel.org, ardb@kernel.org
Subject: Re: [PATCH] lib/crc: x86: rewrite crc32c_x86_3way() in C with inline
 asm
Message-ID: <202611102233.Xe1YmTvH-lkp@intel.com>
References: <090c5f6603b1102c877c8649f7a6569f362bfe61.1794268279.git.wqu@suse.com>
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
In-Reply-To: <090c5f6603b1102c877c8649f7a6569f362bfe61.1794268279.git.wqu@suse.com>

Hi Qu,

kernel test robot noticed the following build errors:

[auto build test ERROR on ebiggers/crc-next]
[also build test ERROR on linus/master v7.4-rc2 next-20261109]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qu-Wenruo/lib-crc-x86-rewrite-crc32c_x86_3way-in-C-with-inline-asm/20261110-102248
base:   https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-next
patch link:    https://lore.kernel.org/r/090c5f6603b1102c877c8649f7a6569f362bfe61.1794268279.git.wqu%40suse.com
patch subject: [PATCH] lib/crc: x86: rewrite crc32c_x86_3way() in C with inline asm
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261110/202611102233.Xe1YmTvH-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261110/202611102233.Xe1YmTvH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611102233.Xe1YmTvH-lkp@intel.com/

All errors (new ones prefixed by >>):

   In function 'crc32c_fold_lanes',
       inlined from 'crc32c_x86_3way' at lib/crc/x86/crc32c-3way.c:285:12:
>> lib/crc/x86/crc32c-3way.c:217:9: error: the register 'xmm2' cannot be clobbered in 'asm' for the current target
     217 |         asm("pmovzxdq   %[k], %%xmm0\n\t"       /* 2 consts: K2:K1 */
         |         ^~~


vim +217 lib/crc/x86/crc32c-3way.c

   208	
   209	/*
   210	 * Fold the CRCs of lane 0 and lane 1 into a single 64-bit value, which is to be
   211	 * XOR'ed into the last qword of lane 2 before being CRC'ed.
   212	 */
   213	static __always_inline u64 crc32c_fold_lanes(u32 crc0, u32 crc1, const u32 *k)
   214	{
   215		u64 res;
   216	
 > 217		asm("pmovzxdq	%[k], %%xmm0\n\t"	/* 2 consts: K2:K1 */
   218		    "movq	%[crc0], %%xmm1\n\t"	/* CRC for lane 0 */
   219		    "pclmulqdq	$0x00, %%xmm0, %%xmm1\n\t" /* Multiply by K2 */
   220		    "movq	%[crc1], %%xmm2\n\t"	/* CRC for lane 1 */
   221		    "pclmulqdq	$0x10, %%xmm0, %%xmm2\n\t" /* Multiply by K1 */
   222		    "pxor	%%xmm2, %%xmm1\n\t"
   223		    "movq	%%xmm1, %[res]"
   224		    : [res] "=r" (res)
   225		    : [crc0] "r" ((u64)crc0), [crc1] "r" ((u64)crc1),
   226		      [k] "m" (*(const u64 *)k)
   227		    : "xmm0", "xmm1", "xmm2");
   228		return res;
   229	}
   230	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
