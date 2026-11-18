Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794964794;
	b=16rmDe/fVzsnqObTY9jAW3poJ0Q4JBVCgXMe+NlvM0Y6ZZQEg5lu3CzF7hIGHDEuDZkS
	 tHby18kLFBeY2Ve3qRj8oPC0jr1oloJeQpN4Yhe5lDExVWQg+6053ZUhP9RrtfUD2Vwjw
	 ozvZCR3hkh9SrpR6Bm6ZEyLzvkDPqfac99S1pb5eXtdXp3f8AhuSmgBloI0+c4OXrRYbH
	 DjDmf04QZ5wTO2SEYMJTEyAeYdmz/HjJydTDfIONVERdSgDRn5qsAcLtKXrqM3i3BOxKK
	 k6bz/kt4gauUFqmAHxsNvSF0MA0m6pnNBV85LWjFZFiguIZvYy6UPli7UPrnVfwj5xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794964794;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=j+lyVy1XIoepo4OJa3E7LPVFtuYyG2w2DUX2gvIm1B8=;
	b=bL5TIKFE1YIzpNENxCZcngzkLqGWB21aLMtXkndunA9G1W3EJq9hr5oTyZowrt9OQSQU
	 +nza0r6is6fVWK+oPEqI8TQUlfElScx1cY1x/6My44Ta3esussSCqfvv9ssPzOdObwykb
	 3JHqmyu3kt61/bS+wWj067sP0yeZ0m3f8pxxTbwRefrrsiQNm8XWcqBcumjffR2yPfgs/
	 AjN+WjrCfoIW52VKvde/NZizORinIsVlBvpaYoStu8vvjryFMbi0Gl+jsAEo6f8qK2EUs
	 uWbLGdbDRoL+TAr2T4pAzZKeNBnAfEuuRaAfE5z15Yr8OnEoLdhEGC9fJIRJ2/BFHiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Q8a1tFmr;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1148C606A32A;
	Wed, 18 Nov 2026 01:19:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1148C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Q8a1tFmr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794964793; x=1826500793;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1RO2WASPHYGEpgsZ/IL52wHL/UpclaRM43x6zLC6lcA=;
  b=Q8a1tFmrgvrN1P8TF9OuYlGkWrjH/FPGuPSaaBKpySMxF3hNrtruyFAx
   vPkXHdwnq/7qbrYfBqyRLp7lylR5EkymZf3oechPsF61aKQHkFDB83r+t
   un8Vk1+zMH70ZgmmFZelAj6eZnxT1pVCHuW55eW/fizHHErmYHrK3K2p2
   pxS7MYTWfLlTiGdKmh9pNj1kqpi6PQGtCyTZHutbCyYl2rKLYI6xjdoAi
   vqhoJh/V8UplpwKJxURBy6ZAbSho0uzuwBlgBrAlFyFss0KIuEOTi2Tjc
   jJunQ/GCROLwPgbgLKg146E67F68xjg5q2cLM/0yLpUwTIXGdTnctPj/w
   w==;
X-CSE-ConnectionGUID: eWqFB5T/R3Sj0EzKGciHeg==
X-CSE-MsgGUID: aLiLmhzYQvWyLNJHmHc8Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3761524"
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="3761524"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 17:19:51 -0800
X-CSE-ConnectionGUID: SQt30y6vQxOAbIvaTV61nQ==
X-CSE-MsgGUID: ZhZpn5vCQxKvsNvEaXbHKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="10167717"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 17 Nov 2026 17:19:49 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTUKv-00000001Cu1-2san;
	Wed, 18 Nov 2026 01:19:45 +0000
Date: Wed, 18 Nov 2026 09:19:28 +0800
From: kernel test robot <lkp@intel.com>
To: Ismael Luceno <ismael@iodev.co.uk>, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Ismael Luceno <ismael@iodev.co.uk>, David Sterba <dsterba@suse.com>,
	Chris Mason <chris.mason@fusionio.com>,
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/8] btrfs: wait for the root filesystem to have all its
 devices
Message-ID: <202611180910.jhiJTiNT-lkp@intel.com>
References: <20261116224316.11237-15-ismael@iodev.co.uk>
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
In-Reply-To: <20261116224316.11237-15-ismael@iodev.co.uk>

Hi Ismael,

kernel test robot noticed the following build errors:

[auto build test ERROR on kdave/for-next]
[also build test ERROR on btrfs/for-next brauner-vfs/vfs.all linus/master v7.4-rc3 next-20261116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ismael-Luceno/btrfs-add-config-options-for-the-root-device-scan/20261116-234317
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
patch link:    https://lore.kernel.org/r/20261116224316.11237-15-ismael%40iodev.co.uk
patch subject: [PATCH 5/8] btrfs: wait for the root filesystem to have all its devices
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20261118/202611180910.jhiJTiNT-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261118/202611180910.jhiJTiNT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611180910.jhiJTiNT-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: fs/btrfs/btrfs.ko: symbol 'block_class' undefined!
>> ERROR: modpost: fs/btrfs/btrfs.ko: symbol 'root_wait' undefined!
>> ERROR: modpost: fs/btrfs/btrfs.ko: symbol 'is_root_dev' undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
