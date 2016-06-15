Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:31673 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488AbcFOD0o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 23:26:44 -0400
Date: Wed, 15 Jun 2016 11:26:17 +0800
From: kbuild test robot <lkp@intel.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Josef Bacik <jbacik@fb.com>, Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH v11 13/13] btrfs: dedupe: fix false ENOSPC
Message-ID: <201606151159.1Cb70j45%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160615021001.9588-14-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

[auto build test WARNING on v4.7-rc3]
[cannot apply to btrfs/next next-20160614]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Qu-Wenruo/Btrfs-dedupe-framework/20160615-101646
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:232:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> fs/btrfs/tests/extent-io-tests.c:117:28: sparse: not enough arguments for function set_extent_delalloc
   fs/btrfs/tests/extent-io-tests.c:148:28: sparse: not enough arguments for function set_extent_delalloc
   fs/btrfs/tests/extent-io-tests.c:203:28: sparse: not enough arguments for function set_extent_delalloc
   fs/btrfs/tests/extent-io-tests.c: In function 'test_find_delalloc':
   fs/btrfs/tests/extent-io-tests.c:117:2: error: too few arguments to function 'set_extent_delalloc'
     set_extent_delalloc(&tmp, 0, sectorsize - 1, NULL);
     ^~~~~~~~~~~~~~~~~~~
   In file included from fs/btrfs/tests/../ctree.h:40:0,
                    from fs/btrfs/tests/extent-io-tests.c:24:
   fs/btrfs/tests/../extent_io.h:294:19: note: declared here
    static inline int set_extent_delalloc(struct extent_io_tree *tree, u64 start,
                      ^~~~~~~~~~~~~~~~~~~
   fs/btrfs/tests/extent-io-tests.c:148:2: error: too few arguments to function 'set_extent_delalloc'
     set_extent_delalloc(&tmp, sectorsize, max_bytes - 1, NULL);
     ^~~~~~~~~~~~~~~~~~~
   In file included from fs/btrfs/tests/../ctree.h:40:0,
                    from fs/btrfs/tests/extent-io-tests.c:24:
   fs/btrfs/tests/../extent_io.h:294:19: note: declared here
    static inline int set_extent_delalloc(struct extent_io_tree *tree, u64 start,
                      ^~~~~~~~~~~~~~~~~~~
   fs/btrfs/tests/extent-io-tests.c:203:2: error: too few arguments to function 'set_extent_delalloc'
     set_extent_delalloc(&tmp, max_bytes, total_dirty - 1, NULL);
     ^~~~~~~~~~~~~~~~~~~
   In file included from fs/btrfs/tests/../ctree.h:40:0,
                    from fs/btrfs/tests/extent-io-tests.c:24:
   fs/btrfs/tests/../extent_io.h:294:19: note: declared here
    static inline int set_extent_delalloc(struct extent_io_tree *tree, u64 start,
                      ^~~~~~~~~~~~~~~~~~~
--
   include/linux/compiler.h:232:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> fs/btrfs/tests/inode-tests.c:969:40: sparse: not enough arguments for function btrfs_set_extent_delalloc
   fs/btrfs/tests/inode-tests.c:984:40: sparse: not enough arguments for function btrfs_set_extent_delalloc
   fs/btrfs/tests/inode-tests.c:1018:40: sparse: not enough arguments for function btrfs_set_extent_delalloc
   fs/btrfs/tests/inode-tests.c:1041:40: sparse: not enough arguments for function btrfs_set_extent_delalloc
   fs/btrfs/tests/inode-tests.c:1060:40: sparse: not enough arguments for function btrfs_set_extent_delalloc
   fs/btrfs/tests/inode-tests.c:1097:40: sparse: not enough arguments for function btrfs_set_extent_delalloc
   fs/btrfs/tests/inode-tests.c: In function 'test_extent_accounting':
   fs/btrfs/tests/inode-tests.c:969:8: error: too few arguments to function 'btrfs_set_extent_delalloc'
     ret = btrfs_set_extent_delalloc(inode, 0, BTRFS_MAX_EXTENT_SIZE - 1,
           ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/btrfs/tests/inode-tests.c:21:0:
   fs/btrfs/tests/../ctree.h:3099:5: note: declared here
    int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
        ^~~~~~~~~~~~~~~~~~~~~~~~~
   fs/btrfs/tests/inode-tests.c:984:8: error: too few arguments to function 'btrfs_set_extent_delalloc'
     ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE,
           ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/btrfs/tests/inode-tests.c:21:0:
   fs/btrfs/tests/../ctree.h:3099:5: note: declared here
    int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
        ^~~~~~~~~~~~~~~~~~~~~~~~~
   fs/btrfs/tests/inode-tests.c:1018:8: error: too few arguments to function 'btrfs_set_extent_delalloc'
     ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE >> 1,
           ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/btrfs/tests/inode-tests.c:21:0:
   fs/btrfs/tests/../ctree.h:3099:5: note: declared here
    int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
        ^~~~~~~~~~~~~~~~~~~~~~~~~
   fs/btrfs/tests/inode-tests.c:1041:8: error: too few arguments to function 'btrfs_set_extent_delalloc'
     ret = btrfs_set_extent_delalloc(inode,
           ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/btrfs/tests/inode-tests.c:21:0:
   fs/btrfs/tests/../ctree.h:3099:5: note: declared here
    int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
        ^~~~~~~~~~~~~~~~~~~~~~~~~
   fs/btrfs/tests/inode-tests.c:1060:8: error: too few arguments to function 'btrfs_set_extent_delalloc'
     ret = btrfs_set_extent_delalloc(inode,
           ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/btrfs/tests/inode-tests.c:21:0:
   fs/btrfs/tests/../ctree.h:3099:5: note: declared here
    int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
        ^~~~~~~~~~~~~~~~~~~~~~~~~
   fs/btrfs/tests/inode-tests.c:1097:8: error: too few arguments to function 'btrfs_set_extent_delalloc'
     ret = btrfs_set_extent_delalloc(inode,
           ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/btrfs/tests/inode-tests.c:21:0:
   fs/btrfs/tests/../ctree.h:3099:5: note: declared here
    int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
        ^~~~~~~~~~~~~~~~~~~~~~~~~

vim +117 fs/btrfs/tests/extent-io-tests.c

294e30fe Josef Bacik        2013-10-09  101  			ret = -ENOMEM;
294e30fe Josef Bacik        2013-10-09  102  			goto out;
294e30fe Josef Bacik        2013-10-09  103  		}
294e30fe Josef Bacik        2013-10-09  104  		SetPageDirty(page);
294e30fe Josef Bacik        2013-10-09  105  		if (index) {
294e30fe Josef Bacik        2013-10-09  106  			unlock_page(page);
294e30fe Josef Bacik        2013-10-09  107  		} else {
09cbfeaf Kirill A. Shutemov 2016-04-01  108  			get_page(page);
294e30fe Josef Bacik        2013-10-09  109  			locked_page = page;
294e30fe Josef Bacik        2013-10-09  110  		}
294e30fe Josef Bacik        2013-10-09  111  	}
294e30fe Josef Bacik        2013-10-09  112  
294e30fe Josef Bacik        2013-10-09  113  	/* Test this scenario
294e30fe Josef Bacik        2013-10-09  114  	 * |--- delalloc ---|
294e30fe Josef Bacik        2013-10-09  115  	 * |---  search  ---|
294e30fe Josef Bacik        2013-10-09  116  	 */
b9ef22de Feifei Xu          2016-06-01 @117  	set_extent_delalloc(&tmp, 0, sectorsize - 1, NULL);
294e30fe Josef Bacik        2013-10-09  118  	start = 0;
294e30fe Josef Bacik        2013-10-09  119  	end = 0;
294e30fe Josef Bacik        2013-10-09  120  	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
294e30fe Josef Bacik        2013-10-09  121  					 &end, max_bytes);
294e30fe Josef Bacik        2013-10-09  122  	if (!found) {
294e30fe Josef Bacik        2013-10-09  123  		test_msg("Should have found at least one delalloc\n");
294e30fe Josef Bacik        2013-10-09  124  		goto out_bits;
294e30fe Josef Bacik        2013-10-09  125  	}

:::::: The code at line 117 was first introduced by commit
:::::: b9ef22dedde08ab1b4ccd5f53344984c4dcb89f4 Btrfs: self-tests: Support non-4k page size

:::::: TO: Feifei Xu <xufeifei@linux.vnet.ibm.com>
:::::: CC: David Sterba <dsterba@suse.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
