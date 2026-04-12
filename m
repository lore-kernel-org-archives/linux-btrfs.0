Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CCB24A06A;
	Sun, 12 Apr 2026 03:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775964568; cv=none; b=oTHpbnUYx6cqoEEStI8knp1utHbvvNuhOB5Fxtu2TaswxyeFPk9wbOy3ljlmQWasis9+JogERMFWoRzUFld/JQBBpKq3bEPnLbrEMPBIh8FsVOBW3psru8VoBkahbJ0zH63MyPhQkfZtLuMtVOtIZi8wwN9BaCg1gF0MGfD0Ta0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775964568; c=relaxed/simple;
	bh=lIQELmMxuaftXa8bMfWGue/ZyovOopcKOU58vKX4QlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DGxNbrKVEh52AlHs3An03AzbPhNi39M0d9MSBgos7BbUFOfyKKS1lhksy8CVJXIndF6Cv/IxnNxuj07c7y2fqYnL0U2+oOz7GXnHm/ZA+KhhnFzT5TWXqb0I2e3t/hZ8ol7OX8mCx2BTiS2ORAMekW3XggW0OvzPPhcm6JL2rpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C5W8CpR2; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C5W8CpR2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775964566; x=1807500566;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lIQELmMxuaftXa8bMfWGue/ZyovOopcKOU58vKX4QlY=;
  b=C5W8CpR2m5mk5uZAaHjTy11WosHaoMIiR/jwxtwFkNwgbKM2wXYoflII
   WTxIAF0lssB+sFkgt1gWo6B/gYKfPlkn/MUAzfBXDl7ekgx8Z2/ItzWnR
   xTpM2K5MHAmrRW2smYq9+2RWIHvm+slu2d8anafii5O41TdytQU1Du+t0
   teEgXbIe61Wp6Kos/YHLbAe2L4yeZvbGJVkbN77nIZYZEM3n1VrqIx550
   7HCxvw36E7FFuXQMhn85SPmoXdPcAPUMG5qp5PS9aZtE+/SHtHIfHLMW5
   Nqs1aLuKzrDJR5UbdNrbu963JJbEZsNh0rNxs/jMhd3x+oKxT12cFUO1l
   g==;
X-CSE-ConnectionGUID: B2Erp/YcR8GlwqtoS09nXw==
X-CSE-MsgGUID: /sfM+oz2R/WVvWVac7hgNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="88322632"
X-IronPort-AV: E=Sophos;i="6.23,174,1770624000"; 
   d="scan'208";a="88322632"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2026 20:29:25 -0700
X-CSE-ConnectionGUID: Hf9nYDQITW2JkPq2lZNLuQ==
X-CSE-MsgGUID: KrYZZ5rWQme55V1riUzLSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,174,1770624000"; 
   d="scan'208";a="228604344"
Received: from lkp-server01.sh.intel.com (HELO 3eaaf1a74b89) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 11 Apr 2026 20:29:23 -0700
Received: from kbuild by 3eaaf1a74b89 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wBlVg-000000001o9-0biU;
	Sun, 12 Apr 2026 03:29:20 +0000
Date: Sun, 12 Apr 2026 11:29:15 +0800
From: kernel test robot <lkp@intel.com>
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com,
	zheng.yan@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
	r33s3n6@gmail.com, zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: Re: [PATCH v2] btrfs: reject empty non-root tree blocks at read time
Message-ID: <202604121109.U7Y29jQ1-lkp@intel.com>
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
config: arm-randconfig-002-20260412 (https://download.01.org/0day-ci/archive/20260412/202604121109.U7Y29jQ1-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260412/202604121109.U7Y29jQ1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604121109.U7Y29jQ1-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/btrfs/disk-io.c: In function 'btrfs_validate_extent_buffer':
>> fs/btrfs/disk-io.c:431:25: error: label 'out' used but not defined
     431 |                         goto out;
         |                         ^~~~


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
