Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B8D30F534
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 20:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781297175; cv=none; b=qMgcF6WIN12GXZyhjl/kC9sy0ZE/IAJPx53jfQmp6N4FdbVL0foKWDerE37v/MI9PHAek0ykb4zgr7viyXqXpMBVoE6KHxSSxBVwFoYEaFY9YgHJoD68ryW3UXWf2FRLMqO8coqW94YKUWbwPWhzDs/IoPGeaHvWBNLmjk1f+Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781297175; c=relaxed/simple;
	bh=qw16pzg+spJSBFaBH6p+wtZ2FjrMwVxg9uT9MtPqAoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAwCq/mY2Y/sJExFd51eZTE3Nw/e+grtmbbu+7GMM3lSB5kTt5Q8nQr3ce98QVDE/2Lb3a6vN5RNVAhEkqJBuupbaYgRObhjj5tDrUc60PcKrXSxhrRo9FRroK9OU3zZKgizm7EW/2VKRDTcCcfSQzi7Y5RNelDmTIMKm1nv4bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hQnVWUDh; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hQnVWUDh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781297172; x=1812833172;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qw16pzg+spJSBFaBH6p+wtZ2FjrMwVxg9uT9MtPqAoc=;
  b=hQnVWUDhIGpKmiszlOBoi4YSX9QZ1/tOnkcxIw3AkacicXSXfiUZYUgn
   92lmWFFnZ5LNtHCo7ym+shbhLcI22t70p6wl9iTlOxtYv+iEzh0yLtO0E
   HpILJvXSXeCUGnVbCUEaeXb5vo+PywZKYKGLwmrv/Euzs0dnX5i8ww3nn
   zTSzZYTUcJlZVbCPGra7E3SIvsAwX7Tx7dKzLkUO2g9cSeAq3ucTnIs0+
   1eIws1Eaz5pCtTVSbV8pXPg+nUf3fy9wEX/OMwf91DaQZfF4tqmxQnkW7
   8LMPfcD8BKziMqUDLKuLUzq/3C1i80vQCqiTSBOSLzcKLtLFdxRvb+tRC
   g==;
X-CSE-ConnectionGUID: xQ6d7QjgTye03linH/aUuQ==
X-CSE-MsgGUID: oRu1rfqWTYOdscveNQdp+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11815"; a="99556672"
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="99556672"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 13:46:12 -0700
X-CSE-ConnectionGUID: +hisyQPnTaqgIeltM+iCVw==
X-CSE-MsgGUID: h8wQOF3TSuGUBtnQ/ImtpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="242537654"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 12 Jun 2026 13:46:10 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wY8lU-000000004Jx-2bcs;
	Fri, 12 Jun 2026 20:46:08 +0000
Date: Fri, 12 Jun 2026 22:45:13 +0200
From: kernel test robot <lkp@intel.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 2/2] btrfs: fix memory barrier order in
 reloc_root_is_dead()
Message-ID: <202606122213.j2TtzMBn-lkp@intel.com>
References: <62602395bf1488aa81645ea59e22405d6c06d3f7.1781263239.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62602395bf1488aa81645ea59e22405d6c06d3f7.1781263239.git.fdmanana@suse.com>

Hi Filipe,

kernel test robot noticed the following build errors:

[auto build test ERROR on kdave/for-next]
[also build test ERROR on linus/master v7.1-rc7 next-20260612]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/fdmanana-kernel-org/btrfs-fix-reloc-root-cleanup-in-merge_reloc_roots/20260612-202603
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
patch link:    https://lore.kernel.org/r/62602395bf1488aa81645ea59e22405d6c06d3f7.1781263239.git.fdmanana%40suse.com
patch subject: [PATCH 2/2] btrfs: fix memory barrier order in reloc_root_is_dead()
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260612/202606122213.j2TtzMBn-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260612/202606122213.j2TtzMBn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606122213.j2TtzMBn-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/btrfs/relocation.c: In function 'merge_reloc_roots':
>> fs/btrfs/relocation.c:1928:41: error: implicit declaration of function 'clear_reloc_root'; did you mean 'create_reloc_root'? [-Wimplicit-function-declaration]
    1928 |                                         clear_reloc_root(root);
         |                                         ^~~~~~~~~~~~~~~~
         |                                         create_reloc_root


vim +1928 fs/btrfs/relocation.c

  1867	
  1868	static noinline_for_stack
  1869	void merge_reloc_roots(struct reloc_control *rc)
  1870	{
  1871		struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
  1872		struct btrfs_root *root;
  1873		struct btrfs_root *reloc_root;
  1874		LIST_HEAD(reloc_roots);
  1875		bool found = false;
  1876		int ret = 0;
  1877	again:
  1878		root = rc->extent_root;
  1879	
  1880		/*
  1881		 * this serializes us with btrfs_record_root_in_transaction,
  1882		 * we have to make sure nobody is in the middle of
  1883		 * adding their roots to the list while we are
  1884		 * doing this splice
  1885		 */
  1886		mutex_lock(&fs_info->reloc_mutex);
  1887		list_splice_init(&rc->reloc_roots, &reloc_roots);
  1888		mutex_unlock(&fs_info->reloc_mutex);
  1889	
  1890		while (!list_empty(&reloc_roots)) {
  1891			found = true;
  1892			reloc_root = list_first_entry(&reloc_roots, struct btrfs_root, root_list);
  1893	
  1894			root = btrfs_get_fs_root(fs_info, reloc_root->root_key.offset,
  1895						 false);
  1896			if (btrfs_root_refs(&reloc_root->root_item) > 0) {
  1897				if (WARN_ON(IS_ERR(root))) {
  1898					/*
  1899					 * For recovery we read the fs roots on mount,
  1900					 * and if we didn't find the root then we marked
  1901					 * the reloc root as a garbage root.  For normal
  1902					 * relocation obviously the root should exist in
  1903					 * memory.  However there's no reason we can't
  1904					 * handle the error properly here just in case.
  1905					 */
  1906					ret = PTR_ERR(root);
  1907					goto out;
  1908				}
  1909				if (WARN_ON(root->reloc_root != reloc_root)) {
  1910					/*
  1911					 * This can happen if on-disk metadata has some
  1912					 * corruption, e.g. bad reloc tree key offset.
  1913					 */
  1914					ret = -EINVAL;
  1915					goto out;
  1916				}
  1917				ret = merge_reloc_root(rc, root);
  1918				btrfs_put_root(root);
  1919				if (ret) {
  1920					if (list_empty(&reloc_root->root_list))
  1921						list_add_tail(&reloc_root->root_list,
  1922							      &reloc_roots);
  1923					goto out;
  1924				}
  1925			} else {
  1926				if (!IS_ERR(root)) {
  1927					if (root->reloc_root == reloc_root) {
> 1928						clear_reloc_root(root);
  1929						/* Drop the ref for root->reloc_root. */
  1930						btrfs_put_root(reloc_root);
  1931					}
  1932					btrfs_put_root(root);
  1933				}
  1934	
  1935				list_del_init(&reloc_root->root_list);
  1936				/* Don't forget to queue this reloc root for cleanup */
  1937				list_add_tail(&reloc_root->reloc_dirty_list,
  1938					      &rc->dirty_subvol_roots);
  1939			}
  1940		}
  1941	
  1942		if (found) {
  1943			found = false;
  1944			goto again;
  1945		}
  1946	out:
  1947		if (ret) {
  1948			btrfs_handle_fs_error(fs_info, ret, NULL);
  1949			free_reloc_roots(&reloc_roots);
  1950	
  1951			/* new reloc root may be added */
  1952			mutex_lock(&fs_info->reloc_mutex);
  1953			list_splice_init(&rc->reloc_roots, &reloc_roots);
  1954			mutex_unlock(&fs_info->reloc_mutex);
  1955			free_reloc_roots(&reloc_roots);
  1956		}
  1957	
  1958		/*
  1959		 * We used to have
  1960		 *
  1961		 * BUG_ON(!RB_EMPTY_ROOT(&rc->reloc_root_tree.rb_root));
  1962		 *
  1963		 * here, but it's wrong.  If we fail to start the transaction in
  1964		 * prepare_to_merge() we will have only 0 ref reloc roots, none of which
  1965		 * have actually been removed from the reloc_root_tree rb tree.  This is
  1966		 * fine because we're bailing here, and we hold a reference on the root
  1967		 * for the list that holds it, so these roots will be cleaned up when we
  1968		 * do the reloc_dirty_list afterwards.  Meanwhile the root->reloc_root
  1969		 * will be cleaned up on unmount.
  1970		 *
  1971		 * The remaining nodes will be cleaned up by put_reloc_control().
  1972		 */
  1973	}
  1974	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
