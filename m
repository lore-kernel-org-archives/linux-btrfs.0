Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35778 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751256AbdGQHEN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 03:04:13 -0400
Date: Mon, 17 Jul 2017 15:03:52 +0800
From: kbuild test robot <lkp@intel.com>
To: Sargun Dhillon <sargun@sargun.me>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        quwenruo@cn.fujitsu.com
Subject: Re: [PATCH v3 2/2] btrfs: Add new ioctl uapis for qgroup creation /
 removal
Message-ID: <201707171518.Kplhx7it%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7d071875077a30dd1694bf6fab43bbc9c12c2487.1499941625.git.sargun@sargun.me>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Sargun,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.13-rc1 next-20170717]
[cannot apply to btrfs/next]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Sargun-Dhillon/New-qgroup-creation-removal-ioctls/20170715-195435
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:260:8: sparse: attribute 'no_sanitize_address': unknown attribute
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
442244c9 Qu Wenruo          2015-04-16  241  	 * quota.
442244c9 Qu Wenruo          2015-04-16  242  	 */
b9ef22de Feifei Xu          2016-06-01  243  	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
faa2dbf0 Josef Bacik        2014-05-07  244  	if (ret) {
442244c9 Qu Wenruo          2015-04-16  245  		ulist_free(old_roots);
442244c9 Qu Wenruo          2015-04-16  246  		test_msg("Couldn't find old roots: %d\n", ret);
faa2dbf0 Josef Bacik        2014-05-07  247  		return ret;
faa2dbf0 Josef Bacik        2014-05-07  248  	}
faa2dbf0 Josef Bacik        2014-05-07  249  
ef9f2db3 Feifei Xu          2016-06-01  250  	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
ef9f2db3 Feifei Xu          2016-06-01  251  				BTRFS_FS_TREE_OBJECTID);
faa2dbf0 Josef Bacik        2014-05-07  252  	if (ret)
faa2dbf0 Josef Bacik        2014-05-07  253  		return ret;
faa2dbf0 Josef Bacik        2014-05-07  254  
b9ef22de Feifei Xu          2016-06-01  255  	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
442244c9 Qu Wenruo          2015-04-16  256  	if (ret) {
442244c9 Qu Wenruo          2015-04-16  257  		ulist_free(old_roots);
442244c9 Qu Wenruo          2015-04-16  258  		ulist_free(new_roots);
442244c9 Qu Wenruo          2015-04-16  259  		test_msg("Couldn't find old roots: %d\n", ret);
442244c9 Qu Wenruo          2015-04-16  260  		return ret;
442244c9 Qu Wenruo          2015-04-16  261  	}
442244c9 Qu Wenruo          2015-04-16  262  
b9ef22de Feifei Xu          2016-06-01  263  	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
b9ef22de Feifei Xu          2016-06-01  264  					  nodesize, old_roots, new_roots);
faa2dbf0 Josef Bacik        2014-05-07  265  	if (ret) {
442244c9 Qu Wenruo          2015-04-16  266  		test_msg("Couldn't account space for a qgroup %d\n", ret);
faa2dbf0 Josef Bacik        2014-05-07  267  		return ret;
faa2dbf0 Josef Bacik        2014-05-07  268  	}
faa2dbf0 Josef Bacik        2014-05-07  269  
ef9f2db3 Feifei Xu          2016-06-01  270  	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
ef9f2db3 Feifei Xu          2016-06-01  271  				nodesize, nodesize)) {
faa2dbf0 Josef Bacik        2014-05-07  272  		test_msg("Qgroup counts didn't match expected values\n");
faa2dbf0 Josef Bacik        2014-05-07  273  		return -EINVAL;
faa2dbf0 Josef Bacik        2014-05-07  274  	}
442244c9 Qu Wenruo          2015-04-16  275  	old_roots = NULL;
442244c9 Qu Wenruo          2015-04-16  276  	new_roots = NULL;
442244c9 Qu Wenruo          2015-04-16  277  
b9ef22de Feifei Xu          2016-06-01  278  	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
442244c9 Qu Wenruo          2015-04-16  279  	if (ret) {
442244c9 Qu Wenruo          2015-04-16  280  		ulist_free(old_roots);
442244c9 Qu Wenruo          2015-04-16  281  		test_msg("Couldn't find old roots: %d\n", ret);
442244c9 Qu Wenruo          2015-04-16  282  		return ret;
442244c9 Qu Wenruo          2015-04-16  283  	}
faa2dbf0 Josef Bacik        2014-05-07  284  
b9ef22de Feifei Xu          2016-06-01  285  	ret = remove_extent_item(root, nodesize, nodesize);
faa2dbf0 Josef Bacik        2014-05-07  286  	if (ret)
faa2dbf0 Josef Bacik        2014-05-07  287  		return -EINVAL;
faa2dbf0 Josef Bacik        2014-05-07  288  
b9ef22de Feifei Xu          2016-06-01  289  	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
faa2dbf0 Josef Bacik        2014-05-07  290  	if (ret) {
442244c9 Qu Wenruo          2015-04-16  291  		ulist_free(old_roots);
442244c9 Qu Wenruo          2015-04-16  292  		ulist_free(new_roots);
442244c9 Qu Wenruo          2015-04-16  293  		test_msg("Couldn't find old roots: %d\n", ret);
442244c9 Qu Wenruo          2015-04-16  294  		return ret;
faa2dbf0 Josef Bacik        2014-05-07  295  	}
faa2dbf0 Josef Bacik        2014-05-07  296  
b9ef22de Feifei Xu          2016-06-01  297  	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
b9ef22de Feifei Xu          2016-06-01  298  					  nodesize, old_roots, new_roots);
faa2dbf0 Josef Bacik        2014-05-07  299  	if (ret) {
442244c9 Qu Wenruo          2015-04-16  300  		test_msg("Couldn't account space for a qgroup %d\n", ret);
faa2dbf0 Josef Bacik        2014-05-07  301  		return -EINVAL;
faa2dbf0 Josef Bacik        2014-05-07  302  	}
faa2dbf0 Josef Bacik        2014-05-07  303  
ef9f2db3 Feifei Xu          2016-06-01  304  	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID, 0, 0)) {
faa2dbf0 Josef Bacik        2014-05-07  305  		test_msg("Qgroup counts didn't match expected values\n");
faa2dbf0 Josef Bacik        2014-05-07  306  		return -EINVAL;
faa2dbf0 Josef Bacik        2014-05-07  307  	}
faa2dbf0 Josef Bacik        2014-05-07  308  
faa2dbf0 Josef Bacik        2014-05-07  309  	return 0;
faa2dbf0 Josef Bacik        2014-05-07  310  }
faa2dbf0 Josef Bacik        2014-05-07  311  

:::::: The code at line 232 was first introduced by commit
:::::: ef9f2db365c31433e52b0c5863793273bb632666 Btrfs: self-tests: Use macros instead of constants and add missing newline

:::::: TO: Feifei Xu <xufeifei@linux.vnet.ibm.com>
:::::: CC: David Sterba <dsterba@suse.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
