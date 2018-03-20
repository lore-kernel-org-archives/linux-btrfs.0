Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:33509 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751913AbeCTK5V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 06:57:21 -0400
Date: Tue, 20 Mar 2018 18:57:12 +0800
From: kbuild test robot <lkp@intel.com>
To: Qu Wenruo <wqu@suse.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
Message-ID: <201803201835.WbTo1KRi%fengguang.wu@intel.com>
References: <20180319091841.18603-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180319091841.18603-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v4.16-rc4]
[also build test WARNING on next-20180319]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Qu-Wenruo/btrfs-Validate-child-tree-block-s-level-and-first-key/20180320-054353
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/btrfs/ref-verify.c:586:45: sparse: not enough arguments for function read_tree_block
   fs/btrfs/ref-verify.c:284:27: sparse: context imbalance in 'add_block_entry' - different lock contexts for basic block
   fs/btrfs/ref-verify.c:371:20: sparse: context imbalance in 'add_tree_block' - unexpected unlock
   fs/btrfs/ref-verify.c:396:28: sparse: context imbalance in 'add_shared_data_ref' - unexpected unlock
   fs/btrfs/ref-verify.c:434:28: sparse: context imbalance in 'add_extent_data_ref' - unexpected unlock
   fs/btrfs/ref-verify.c:892:20: sparse: context imbalance in 'btrfs_ref_tree_mod' - unexpected unlock
   fs/btrfs/ref-verify.c: In function 'walk_down_tree':
   fs/btrfs/ref-verify.c:586:9: error: too few arguments to function 'read_tree_block'
       eb = read_tree_block(fs_info, block_bytenr, gen);
            ^~~~~~~~~~~~~~~
   In file included from fs/btrfs/ref-verify.c:22:0:
   fs/btrfs/disk-io.h:55:23: note: declared here
    struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
                          ^~~~~~~~~~~~~~~

vim +586 fs/btrfs/ref-verify.c

fd708b81 Josef Bacik 2017-09-29  570  
fd708b81 Josef Bacik 2017-09-29  571  /* Walk down to the leaf from the given level */
fd708b81 Josef Bacik 2017-09-29  572  static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
fd708b81 Josef Bacik 2017-09-29  573  			  int level, u64 *bytenr, u64 *num_bytes)
fd708b81 Josef Bacik 2017-09-29  574  {
fd708b81 Josef Bacik 2017-09-29  575  	struct btrfs_fs_info *fs_info = root->fs_info;
fd708b81 Josef Bacik 2017-09-29  576  	struct extent_buffer *eb;
fd708b81 Josef Bacik 2017-09-29  577  	u64 block_bytenr, gen;
fd708b81 Josef Bacik 2017-09-29  578  	int ret = 0;
fd708b81 Josef Bacik 2017-09-29  579  
fd708b81 Josef Bacik 2017-09-29  580  	while (level >= 0) {
fd708b81 Josef Bacik 2017-09-29  581  		if (level) {
fd708b81 Josef Bacik 2017-09-29  582  			block_bytenr = btrfs_node_blockptr(path->nodes[level],
fd708b81 Josef Bacik 2017-09-29  583  							   path->slots[level]);
fd708b81 Josef Bacik 2017-09-29  584  			gen = btrfs_node_ptr_generation(path->nodes[level],
fd708b81 Josef Bacik 2017-09-29  585  							path->slots[level]);
fd708b81 Josef Bacik 2017-09-29 @586  			eb = read_tree_block(fs_info, block_bytenr, gen);
fd708b81 Josef Bacik 2017-09-29  587  			if (IS_ERR(eb))
fd708b81 Josef Bacik 2017-09-29  588  				return PTR_ERR(eb);
fd708b81 Josef Bacik 2017-09-29  589  			if (!extent_buffer_uptodate(eb)) {
fd708b81 Josef Bacik 2017-09-29  590  				free_extent_buffer(eb);
fd708b81 Josef Bacik 2017-09-29  591  				return -EIO;
fd708b81 Josef Bacik 2017-09-29  592  			}
fd708b81 Josef Bacik 2017-09-29  593  			btrfs_tree_read_lock(eb);
fd708b81 Josef Bacik 2017-09-29  594  			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
fd708b81 Josef Bacik 2017-09-29  595  			path->nodes[level-1] = eb;
fd708b81 Josef Bacik 2017-09-29  596  			path->slots[level-1] = 0;
fd708b81 Josef Bacik 2017-09-29  597  			path->locks[level-1] = BTRFS_READ_LOCK_BLOCKING;
fd708b81 Josef Bacik 2017-09-29  598  		} else {
fd708b81 Josef Bacik 2017-09-29  599  			ret = process_leaf(root, path, bytenr, num_bytes);
fd708b81 Josef Bacik 2017-09-29  600  			if (ret)
fd708b81 Josef Bacik 2017-09-29  601  				break;
fd708b81 Josef Bacik 2017-09-29  602  		}
fd708b81 Josef Bacik 2017-09-29  603  		level--;
fd708b81 Josef Bacik 2017-09-29  604  	}
fd708b81 Josef Bacik 2017-09-29  605  	return ret;
fd708b81 Josef Bacik 2017-09-29  606  }
fd708b81 Josef Bacik 2017-09-29  607  

:::::: The code at line 586 was first introduced by commit
:::::: fd708b81d972a0714b02a60eb4792fdbf15868c4 Btrfs: add a extent ref verify tool

:::::: TO: Josef Bacik <josef@toxicpanda.com>
:::::: CC: David Sterba <dsterba@suse.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
