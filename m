Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795645123;
	b=gCLIP/XiNApy8jQrlLttCmo6iC2AWLwH1saVBG6+bs9BrlK00LfunHm3BzpoXze5Y1lO
	 /u+ga7LWPAiSyX2ZKhY+NDU79TQmmiXgc/Y4ipAZ6+e6WKaffXwOJrB4erNjbyWqiqqYn
	 dyvUgPQU5JBaw+j+irWN0V0lDqXpIDDYekTfvnjgyNd5hpAYtq8pwOIya4R/Qux5ZzuMZ
	 ALciUu5Hw+mV/6ptb3HXZGXuF/JBMBZ0FSxxP1yZ70SszeHXMWoyhYc8GXlO8PNZ3ZXs2
	 UF1y40toBP1IuY/3GXroXMtK4G2kQaU7I/G97NDHZCwO5v++OEhk/IqycNj7HkW3KmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795645123;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=o5KFqUXXjfeTfqARHGi1E8eWl4G8Q6kAjZPv4QHZ+Z8=;
	b=j8EH7MXCyLF7msY0ugyJ9Ft+fs/jUqytBToIBaBGWwSa11fh1jDlmln5Tlnz/I7esm+Z
	 G+c4yQ9QhooplfE+QpDaqaM5yN3JQGPYnAvCyAz3dbocxR03a6x0g3pDKDxW/q4VVjyVo
	 9WiuhYFDkU/N5T2f8fDe7GUAczwwOsf3bqv0Nv+Mc+r2twgax0X7V/M6WTM7N93lh0PC1
	 ZICcKdOSaqjQMJjwLPZJFYIkUaSFdr5AgYk3E/SSaNPwwOqk/C5yNUZKEBaGbmx7r8oVw
	 XousrV3xHYrxLfzqFpUaxrBHdwUxRk92zVDSIhAQtKzhtpS5c1v7XYS6uhdWEqsPefA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mHZcxydn;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E28606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 22:18:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08E28606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mHZcxydn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795645122; x=1827181122;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PPukY6G2SgZJasLiTZ5RJSGQ781r9OSE3UZlYheDPgc=;
  b=mHZcxydnJBf7K5826MxY+ZwAbCW7uf3iEaEOdvBpjkFhzgvAtcOOyL24
   dNQE/zA+1OQNFPeBEYv7YjJegC21tfWtyDjYxhnxMQ5uR3C7lFHlN5UEr
   K32ItfVgcdBt/mGFloy/ZZ/r2gLXcZ0Y04ZGHTfaqq4MjX12DwkvmOMx+
   en/9FvDSLprDc7ePJZ1NcAUsj62hfAXFCafNcv7r29XWYj+xjQIYNAiob
   pkmai7fhmCd2lH+M5c0HM5mSLxabkQ6Yv5Zs68Qukh6W3xwGQXQ0I8rsc
   IZkHBveGtX8qoz4aXP2c9E1eMXxgCDZPJpC8jZZVeWdlv0VlIZ4rdlgqm
   g==;
X-CSE-ConnectionGUID: B3K/SqDhRiSdyLx/G8OeNg==
X-CSE-MsgGUID: rMaZLJUmRCeE4Sb8x3ZH4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4512055"
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="4512055"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 14:18:41 -0800
X-CSE-ConnectionGUID: fJrdTqlmT3uj9FZd8amQpQ==
X-CSE-MsgGUID: Fy48RiB9TUqmlTK2M7JttA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="11866513"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 25 Nov 2026 14:18:38 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWLK0-00000001SlM-1Gj4;
	Wed, 25 Nov 2026 22:18:36 +0000
Date: Thu, 26 Nov 2026 06:18:31 +0800
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
Message-ID: <20261126060952.TMeGle2I-lkp@intel.com>
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
config: hexagon-randconfig-1001-20261126 (https://download.01.org/0day-ci/archive/20261126/20261126060952.TMeGle2I-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 2012344e5da8e03ea4b8283ecd6fad6e13f09d64)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261126/20261126060952.TMeGle2I-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261126060952.TMeGle2I-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: fs/btrfs/btrfs.ko: symbol '__hexagon_udivdi3' undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
