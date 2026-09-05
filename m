Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2687B324B24;
	Sat,  5 Sep 2026 14:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788618351; cv=none; b=IkNtCben9y7XSAi/WDjsdoBRh/769I0Bj+4PNI6i5wwA2rQ4kanfAOp7UfkyUfSWNMtmrtDFupRewlP3PnIchP0z9O0po8JypfGwYTuyhVf9YmJ7k4Lyn1V84zGCqicGVKqlPwhlUImzFVdNri4gYL6NB2Z/Fgnph/5heu6wHCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788618351; c=relaxed/simple;
	bh=jndXAAKHidpqftMQBa26cKlXG5nvYlOXafytPCALO5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hDklFlvx/tg1A+J+Sa9ePF4UHoO4XaApLQtcDSUSB/+Ra3fJlqR0cJz4g+QVnZN+jsi77SH41qncOZNFWP0+WLU1sl3COW0ZZMKUk5deeTxgIKjk8PiBndmanP8SUBXCi2ObXfdexXpP6cRvWNW3TEI6POkV1cmTgQMMH0KOdvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dUGZCBem; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dUGZCBem"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788618348; x=1820154348;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jndXAAKHidpqftMQBa26cKlXG5nvYlOXafytPCALO5Q=;
  b=dUGZCBemVzGI3Yv0mWk75ahfd3A1Z1XFKypefigZ9uzvtfTw7lm14ADA
   tKxNXruVYTPPHNQj93pV4Knloab5ThDFwJTtUbLjKWb9LbQMjcsKbtp0D
   YbmC1JXiYpeg2SyzZ89+Cbh5lQFmNLBoJ5m9He3IHuO6l/A6TrePx6dzR
   cdtIRem0BHzDwWceKcK8sEIL2h4LHb5HT559bOFCsTdE2+vmA6p8NMxIX
   bIAJZrianiAE03HPERatIyp137ui+njaHNK8fwhvmPzaoR7HMahBP8XAZ
   3wqghnF2uh/yq8Bc1ID/waBkxnClk8cbsrP5WDxTFQ4d19C7wQZ5rnBR7
   A==;
X-CSE-ConnectionGUID: XH7xWYRCQ02VGJu+2MvdLQ==
X-CSE-MsgGUID: RAvUzEy+Tiyo2asooDXV/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11896"; a="99755054"
X-IronPort-AV: E=Sophos;i="6.25,263,1779174000"; 
   d="scan'208";a="99755054"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2026 07:25:46 -0700
X-CSE-ConnectionGUID: 8U27AxlCS3SUnHoCDZJdLA==
X-CSE-MsgGUID: iracYlDuRPuLQIaGChvIkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,263,1779174000"; 
   d="scan'208";a="272247298"
Received: from lkp-server01.sh.intel.com (HELO 73f3364bc37e) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 05 Sep 2026 07:25:42 -0700
Received: from kbuild by 73f3364bc37e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2rKs-000000000Z9-3kZH;
	Sat, 05 Sep 2026 14:25:38 +0000
Date: Sat, 5 Sep 2026 22:25:12 +0800
From: kernel test robot <lkp@intel.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Bart Van Assche <bvanassche@acm.org>,
	Markus Elfring <Markus.Elfring@web.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	lkp@intel.com, oe-lkp@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Hillf Danton <hdanton@sina.com>, Mark Brown <broonie@kernel.org>,
	Oliver Sang <oliver.sang@intel.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v8] loop: Fix NULL pointer dereference in lo_rw_aio()
Message-ID: <202609052240.ovdWUOyj-lkp@intel.com>
References: <dc2f1e00-5e10-4e02-9415-c6ecb2cbc6b3@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc2f1e00-5e10-4e02-9415-c6ecb2cbc6b3@I-love.SAKURA.ne.jp>

Hi Tetsuo,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe/for-next]
[also build test ERROR on linus/master v7.3-rc1 next-20260904]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tetsuo-Handa/loop-Fix-NULL-pointer-dereference-in-lo_rw_aio/20260904-085046
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/dc2f1e00-5e10-4e02-9415-c6ecb2cbc6b3%40I-love.SAKURA.ne.jp
patch subject: [PATCH v8] loop: Fix NULL pointer dereference in lo_rw_aio()
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20260905/202609052240.ovdWUOyj-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 0edd1b088cc36b4faee80358c925a91e16006258)
rustc: rustc 1.96.0 (ac68faa20 2026-05-25)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260905/202609052240.ovdWUOyj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609052240.ovdWUOyj-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0063]: missing field `post_release` in initializer of `block_device_operations`
   --> rust/kernel/block/mq/gen_disk.rs:128:58
   |
   128 |         const TABLE: bindings::block_device_operations = bindings::block_device_operations {
   |                                                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ missing `post_release`

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
