Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8017D34DCD9;
	Sun, 12 Apr 2026 04:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775969612; cv=none; b=glmhuZRJbEEQsVvWOhMHeWvKZM/fosjwbW6GBjYzPlfouTpimreLNVmpiLP3SHrRENkRvyNDuIQriXHt6YkAC07s9N2wFRFQL9LjgsN1iaD5zgwGINjH94wvEM1qntaUiVypCsH9O9D5sS+YhXbVr4T8XyXtziSIc8KrfMr3Ls0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775969612; c=relaxed/simple;
	bh=k6i6n7ANp7UUruZNPHaNrTVWuktyoAPTYZQ0XKKtND8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rs1JkPU+Qqh+qJWKw0y4a2xFs8AeFAhZFsQWjIJ/GzDJCw9y01gV5zONJRFA7YxNcotMMIBGqAcoFwCAKXsEvQ/4mvHJjVlWHZyxF9NTiVuGCDqH0pU0uSD9IFTrZ5p5dDESA8hUiW31bV1FZDXFM2h5VQSe7rNxARuVZAp1F/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b6LdGF/G; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b6LdGF/G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775969610; x=1807505610;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k6i6n7ANp7UUruZNPHaNrTVWuktyoAPTYZQ0XKKtND8=;
  b=b6LdGF/GgDGUdUvvazxSt0d6u93NuUMy3hOOG6NdDPio/JzgkP1KUkE1
   KL+Wcjec49xsYFniqdLukkrGzvTekZhBOKT3eqbrqVzSwcH6A3BZd7wZ3
   ybt2vzmL2JnhJ5mMkDLdVE9CXYA2ISDQIvVWL/7VSg39YcgOgE88d3Uif
   1MV7FUpB/FXkE+SvtBtXxNCeIAqKZaKYam5QqBaV4+xsWmUD+0HD2DfOz
   7dEyKPO7BOMWEsekZFMGBo2jthE6l1vXHWmBoZMNOnI3lAkm70GJZ/35f
   vF4Diq5kGYXGCy8oojUQ2ImB5dT+Q/t6Jk7X0dMaOYWGttJUxy3buNQRd
   A==;
X-CSE-ConnectionGUID: 2X5VVjlwQdOO1fAAiCScDw==
X-CSE-MsgGUID: kG0bAPzBTkuTDq9CnjEWHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="77051686"
X-IronPort-AV: E=Sophos;i="6.23,174,1770624000"; 
   d="scan'208";a="77051686"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2026 21:53:29 -0700
X-CSE-ConnectionGUID: 8BJ0Oqp+Rn6Bxb0/pHaWnw==
X-CSE-MsgGUID: e70vVnQcRy2L3hkGAo6IEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,174,1770624000"; 
   d="scan'208";a="267438707"
Received: from lkp-server01.sh.intel.com (HELO 3eaaf1a74b89) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 11 Apr 2026 21:53:26 -0700
Received: from kbuild by 3eaaf1a74b89 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wBmp1-000000001sf-1joS;
	Sun, 12 Apr 2026 04:53:23 +0000
Date: Sun, 12 Apr 2026 12:53:15 +0800
From: kernel test robot <lkp@intel.com>
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com,
	zheng.yan@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
	r33s3n6@gmail.com, zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: Re: [PATCH v2] btrfs: reject empty non-root tree blocks at read time
Message-ID: <202604121228.ciXtbZT6-lkp@intel.com>
References: <20260409081140.3400650-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409081140.3400650-1-gality369@gmail.com>

Hi ZhengYuan,

kernel test robot noticed the following build errors:

[auto build test ERROR on kdave/for-next]
[also build test ERROR on linus/master v7.0-rc7 next-20260410]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/ZhengYuan-Huang/btrfs-reject-empty-non-root-tree-blocks-at-read-time/20260412-051345
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
patch link:    https://lore.kernel.org/r/20260409081140.3400650-1-gality369%40gmail.com
patch subject: [PATCH v2] btrfs: reject empty non-root tree blocks at read time
config: i386-randconfig-141-20260412 (https://download.01.org/0day-ci/archive/20260412/202604121228.ciXtbZT6-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
smatch: v0.5.0-9004-gb810ac53
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260412/202604121228.ciXtbZT6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604121228.ciXtbZT6-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/btrfs/disk-io.c:431:9: error: use of undeclared label 'out'
     431 |                         goto out;
         |                              ^
   1 error generated.


vim +/out +431 fs/btrfs/disk-io.c

   355	
   356	/* Do basic extent buffer checks at read time */
   357	int btrfs_validate_extent_buffer(struct extent_buffer *eb,
   358					 const struct btrfs_tree_parent_check *check)
   359	{
   360		struct btrfs_fs_info *fs_info = eb->fs_info;
   361		u64 found_start;
   362		const u32 csum_size = fs_info->csum_size;
   363		u8 found_level;
   364		u8 result[BTRFS_CSUM_SIZE];
   365		const u8 *header_csum;
   366		int ret = 0;
   367		const bool ignore_csum = btrfs_test_opt(fs_info, IGNOREMETACSUMS);
   368	
   369		ASSERT(check);
   370	
   371		found_start = btrfs_header_bytenr(eb);
   372		if (unlikely(found_start != eb->start)) {
   373			btrfs_err_rl(fs_info,
   374				"bad tree block start, mirror %u want %llu have %llu",
   375				     eb->read_mirror, eb->start, found_start);
   376			return -EIO;
   377		}
   378		if (unlikely(check_tree_block_fsid(eb))) {
   379			btrfs_err_rl(fs_info, "bad fsid on logical %llu mirror %u",
   380				     eb->start, eb->read_mirror);
   381			return -EIO;
   382		}
   383		found_level = btrfs_header_level(eb);
   384		if (unlikely(found_level >= BTRFS_MAX_LEVEL)) {
   385			btrfs_err(fs_info,
   386				"bad tree block level, mirror %u level %d on logical %llu",
   387				eb->read_mirror, btrfs_header_level(eb), eb->start);
   388			return -EIO;
   389		}
   390	
   391		csum_tree_block(eb, result);
   392		header_csum = folio_address(eb->folios[0]) +
   393			get_eb_offset_in_folio(eb, offsetof(struct btrfs_header, csum));
   394	
   395		if (memcmp(result, header_csum, csum_size) != 0) {
   396			btrfs_warn_rl(fs_info,
   397	"checksum verify failed on logical %llu mirror %u wanted " BTRFS_CSUM_FMT " found " BTRFS_CSUM_FMT " level %d%s",
   398				      eb->start, eb->read_mirror,
   399				      BTRFS_CSUM_FMT_VALUE(csum_size, header_csum),
   400				      BTRFS_CSUM_FMT_VALUE(csum_size, result),
   401				      btrfs_header_level(eb),
   402				      ignore_csum ? ", ignored" : "");
   403			if (unlikely(!ignore_csum))
   404				return -EUCLEAN;
   405		}
   406	
   407		if (unlikely(found_level != check->level)) {
   408			btrfs_err(fs_info,
   409			"level verify failed on logical %llu mirror %u wanted %u found %u",
   410				  eb->start, eb->read_mirror, check->level, found_level);
   411			return -EIO;
   412		}
   413		if (unlikely(check->transid &&
   414			     btrfs_header_generation(eb) != check->transid)) {
   415			btrfs_err_rl(eb->fs_info,
   416	"parent transid verify failed on logical %llu mirror %u wanted %llu found %llu",
   417					eb->start, eb->read_mirror, check->transid,
   418					btrfs_header_generation(eb));
   419			return -EIO;
   420		}
   421		if (check->has_first_key) {
   422			const struct btrfs_key *expect_key = &check->first_key;
   423			struct btrfs_key found_key;
   424	
   425			/* We have @first_key, so this @eb must have at least one item. */
   426			if (unlikely(btrfs_header_nritems(eb) == 0)) {
   427				btrfs_err(fs_info,
   428					  "invalid tree nritems, bytenr=%llu nritems=0 expect >0",
   429					  eb->start);
   430				ret = -EUCLEAN;
 > 431				goto out;
   432			}
   433	
   434			if (found_level)
   435				btrfs_node_key_to_cpu(eb, &found_key, 0);
   436			else
   437				btrfs_item_key_to_cpu(eb, &found_key, 0);
   438			if (unlikely(btrfs_comp_cpu_keys(expect_key, &found_key))) {
   439				btrfs_err(fs_info,
   440	"tree first key mismatch detected, bytenr=%llu parent_transid=%llu key expected=(%llu,%u,%llu) has=(%llu,%u,%llu)",
   441					  eb->start, check->transid,
   442					  expect_key->objectid,
   443					  expect_key->type, expect_key->offset,
   444					  found_key.objectid, found_key.type,
   445					  found_key.offset);
   446				return -EUCLEAN;
   447			}
   448		}
   449		if (check->owner_root) {
   450			ret = btrfs_check_eb_owner(eb, check->owner_root);
   451			if (ret < 0)
   452				return ret;
   453		}
   454	
   455		/* If this is a leaf block and it is corrupt, just return -EIO. */
   456		if (found_level == 0 && btrfs_check_leaf(eb))
   457			ret = -EIO;
   458	
   459		if (found_level > 0 && btrfs_check_node(eb))
   460			ret = -EIO;
   461	
   462		if (ret)
   463			btrfs_err(fs_info,
   464			"read time tree block corruption detected on logical %llu mirror %u",
   465				  eb->start, eb->read_mirror);
   466		return ret;
   467	}
   468	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
