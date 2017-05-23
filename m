Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:52648 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751929AbdEWG2f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 02:28:35 -0400
Date: Tue, 23 May 2017 14:27:54 +0800
From: kbuild test robot <lkp@intel.com>
To: Sargun Dhillon <sargun@sargun.me>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/8] btrfs: Add code to prevent qgroup creation for a
 non-existent subvol
Message-ID: <201705231422.TNq0owUW%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170520083954.GA4253@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Sargun,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.12-rc2 next-20170522]
[cannot apply to btrfs/next]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Sargun-Dhillon/BtrFS-QGroups-uapi-improvements/20170523-111746
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> fs/btrfs/tests/qgroup-tests.c:232:34: sparse: not enough arguments for function btrfs_create_qgroup
   fs/btrfs/tests/qgroup-tests.c:334:34: sparse: not enough arguments for function btrfs_create_qgroup
   fs/btrfs/tests/qgroup-tests.c: In function 'test_no_shared_qgroup':
   fs/btrfs/tests/qgroup-tests.c:232:8: error: too few arguments to function 'btrfs_create_qgroup'
     ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FS_TREE_OBJECTID);
           ^~~~~~~~~~~~~~~~~~~
   In file included from fs/btrfs/tests/qgroup-tests.c:24:0:
   fs/btrfs/tests/../qgroup.h:127:5: note: declared here
    int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
        ^~~~~~~~~~~~~~~~~~~
   fs/btrfs/tests/qgroup-tests.c: In function 'test_multiple_refs':
   fs/btrfs/tests/qgroup-tests.c:334:8: error: too few arguments to function 'btrfs_create_qgroup'
     ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FIRST_FREE_OBJECTID);
           ^~~~~~~~~~~~~~~~~~~
   In file included from fs/btrfs/tests/qgroup-tests.c:24:0:
   fs/btrfs/tests/../qgroup.h:127:5: note: declared here
    int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
        ^~~~~~~~~~~~~~~~~~~

vim +232 fs/btrfs/tests/qgroup-tests.c

faa2dbf0 Josef Bacik        2014-05-07  216  	btrfs_free_path(path);
faa2dbf0 Josef Bacik        2014-05-07  217  	return ret;
faa2dbf0 Josef Bacik        2014-05-07  218  }
faa2dbf0 Josef Bacik        2014-05-07  219  
b9ef22de Feifei Xu          2016-06-01  220  static int test_no_shared_qgroup(struct btrfs_root *root,
b9ef22de Feifei Xu          2016-06-01  221  		u32 sectorsize, u32 nodesize)
faa2dbf0 Josef Bacik        2014-05-07  222  {
faa2dbf0 Josef Bacik        2014-05-07  223  	struct btrfs_trans_handle trans;
faa2dbf0 Josef Bacik        2014-05-07  224  	struct btrfs_fs_info *fs_info = root->fs_info;
442244c9 Qu Wenruo          2015-04-16  225  	struct ulist *old_roots = NULL;
442244c9 Qu Wenruo          2015-04-16  226  	struct ulist *new_roots = NULL;
faa2dbf0 Josef Bacik        2014-05-07  227  	int ret;
faa2dbf0 Josef Bacik        2014-05-07  228  
7c55ee0c Omar Sandoval      2015-09-29  229  	btrfs_init_dummy_trans(&trans);
faa2dbf0 Josef Bacik        2014-05-07  230  
faa2dbf0 Josef Bacik        2014-05-07  231  	test_msg("Qgroup basic add\n");
ef9f2db3 Feifei Xu          2016-06-01 @232  	ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FS_TREE_OBJECTID);
faa2dbf0 Josef Bacik        2014-05-07  233  	if (ret) {
faa2dbf0 Josef Bacik        2014-05-07  234  		test_msg("Couldn't create a qgroup %d\n", ret);
faa2dbf0 Josef Bacik        2014-05-07  235  		return ret;
faa2dbf0 Josef Bacik        2014-05-07  236  	}
faa2dbf0 Josef Bacik        2014-05-07  237  
442244c9 Qu Wenruo          2015-04-16  238  	/*
01327610 Nicholas D Steeves 2016-05-19  239  	 * Since the test trans doesn't have the complicated delayed refs,
442244c9 Qu Wenruo          2015-04-16  240  	 * we can only call btrfs_qgroup_account_extent() directly to test

:::::: The code at line 232 was first introduced by commit
:::::: ef9f2db365c31433e52b0c5863793273bb632666 Btrfs: self-tests: Use macros instead of constants and add missing newline

:::::: TO: Feifei Xu <xufeifei@linux.vnet.ibm.com>
:::::: CC: David Sterba <dsterba@suse.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
