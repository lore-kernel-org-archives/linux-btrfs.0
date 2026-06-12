Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A8330FC27
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 19:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781291592; cv=none; b=BYJHFjBkZyVFWQ4m9POaWE9gZuLHTir7AIlE6IIlpakrC5feiKT5Ltb8994aIDpZEF64PIbdptyUnUd7mgaQ6Oi3U3iMFnAiSL47I8AN/3d+SrJZ40yDWCvrgr1lZkIM5t1tQMbPcmO4iKCumNbJA5tPi0EJzFGLzUKkJ8Z4zaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781291592; c=relaxed/simple;
	bh=EZKHQfZXZMlzFD8M6pPaJhcHLtn8tPSz4c3opMOyT+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slh8eREml/u8gGoYVdVyfRn+wxcvPHpDxlqA1WSotZOvILelXHGpiCO8ZPwiVLhH9dB9vlPEJ1oql9Yi6X/aai0wcrnOwUjVPTl4oFzoDZReqTWybhWE9MaJQbYz/dLGb8prODBpM8puTTxZMVAUJpy7i4sPmK2JhCGOBV9HZ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c2u+zZNg; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c2u+zZNg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781291591; x=1812827591;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EZKHQfZXZMlzFD8M6pPaJhcHLtn8tPSz4c3opMOyT+8=;
  b=c2u+zZNgBe2JF/UsG8DWhoEUTO64iSFhGv79X6QYbUs9+dHVoLuUoeoe
   eNMjg85vdyb9Fy7UqDa1CFkRH4/ZP6cYj3Eu4mRJJjRNO9QJzoeGklyKl
   ZUZm7QqpnetWzw7E7T69L0aQoQb3S3DSrkUgeW0su+o8yrkdrpMgWGQj2
   mRN8/mzFTeRxGG29KGxor77CNGsbE2xPgxHkUMwxDbUIF4wTVDCz0bbFv
   17h7n0WsR2qT9IOyBuBZ9Kdg3y5YRnXIPYXPm2tlTPEtqDTWhj9ADoHVb
   +JGUcz7yGXOUR+2dgIsY6P8tC7Y7Q6Kf1iXBHih4rqTQYJdVdoRn89aWG
   w==;
X-CSE-ConnectionGUID: GaNzBVwPR9+/0dJ/8VO92Q==
X-CSE-MsgGUID: d6DCOz4xSX2lr5/HACM+Vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11815"; a="82236792"
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="82236792"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 12:13:10 -0700
X-CSE-ConnectionGUID: wV6Mb0DxRfWo5woygTye5Q==
X-CSE-MsgGUID: 5H/ePxY/Q+urQpE4Vs6/dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="270939007"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by fmviesa001.fm.intel.com with ESMTP; 12 Jun 2026 12:13:09 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wY7JT-000000004If-10CS;
	Fri, 12 Jun 2026 19:13:07 +0000
Date: Fri, 12 Jun 2026 21:13:03 +0200
From: kernel test robot <lkp@intel.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 2/2] btrfs: fix memory barrier order in
 reloc_root_is_dead()
Message-ID: <202606122155.6ncF2GHC-lkp@intel.com>
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
[also build test ERROR on linus/master v7.1-rc7 next-20260611]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/fdmanana-kernel-org/btrfs-fix-reloc-root-cleanup-in-merge_reloc_roots/20260612-202603
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
patch link:    https://lore.kernel.org/r/62602395bf1488aa81645ea59e22405d6c06d3f7.1781263239.git.fdmanana%40suse.com
patch subject: [PATCH 2/2] btrfs: fix memory barrier order in reloc_root_is_dead()
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260612/202606122155.6ncF2GHC-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project f43d6834093b19baf79beda8c0337ab020ac5f17)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260612/202606122155.6ncF2GHC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606122155.6ncF2GHC-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/btrfs/relocation.c:1928:6: error: call to undeclared function 'clear_reloc_root'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1928 |                                         clear_reloc_root(root);
         |                                         ^
   fs/btrfs/relocation.c:1928:6: note: did you mean 'create_reloc_root'?
   fs/btrfs/relocation.c:631:27: note: 'create_reloc_root' declared here
     631 | static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
         |                           ^
   1 error generated.


vim +/clear_reloc_root +1928 fs/btrfs/relocation.c

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
