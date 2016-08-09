Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:34070 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbcHIUuk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Aug 2016 16:50:40 -0400
Date: Wed, 10 Aug 2016 04:50:04 +0800
From: kbuild test robot <lkp@intel.com>
To: Josef Bacik <jbacik@fb.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com, jack@suse.com,
        viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@lst.de
Subject: Re: [PATCH 1/2] remove mapping from balance_dirty_pages*()
Message-ID: <201608100438.99yA9LoM%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1470769707-26079-2-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.8-rc1 next-20160809]
[cannot apply to linux/master]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Josef-Bacik/Provide-accounting-for-dirty-metadata/20160810-031219
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:230:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> drivers/mtd/devices/block2mtd.c:74:64: sparse: not enough arguments for function balance_dirty_pages_ratelimited
   drivers/mtd/devices/block2mtd.c:165:56: sparse: not enough arguments for function balance_dirty_pages_ratelimited
   drivers/mtd/devices/block2mtd.c: In function '_block2mtd_erase':
   drivers/mtd/devices/block2mtd.c:74:37: error: passing argument 1 of 'balance_dirty_pages_ratelimited' from incompatible pointer type [-Werror=incompatible-pointer-types]
        balance_dirty_pages_ratelimited(mapping);
                                        ^~~~~~~
   In file included from include/linux/backing-dev.h:15:0,
                    from drivers/mtd/devices/block2mtd.c:23:
   include/linux/writeback.h:367:6: note: expected 'struct backing_dev_info *' but argument is of type 'struct address_space *'
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/mtd/devices/block2mtd.c:74:5: error: too few arguments to function 'balance_dirty_pages_ratelimited'
        balance_dirty_pages_ratelimited(mapping);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/backing-dev.h:15:0,
                    from drivers/mtd/devices/block2mtd.c:23:
   include/linux/writeback.h:367:6: note: declared here
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/mtd/devices/block2mtd.c: In function '_block2mtd_write':
   drivers/mtd/devices/block2mtd.c:165:36: error: passing argument 1 of 'balance_dirty_pages_ratelimited' from incompatible pointer type [-Werror=incompatible-pointer-types]
       balance_dirty_pages_ratelimited(mapping);
                                       ^~~~~~~
   In file included from include/linux/backing-dev.h:15:0,
                    from drivers/mtd/devices/block2mtd.c:23:
   include/linux/writeback.h:367:6: note: expected 'struct backing_dev_info *' but argument is of type 'struct address_space *'
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/mtd/devices/block2mtd.c:165:4: error: too few arguments to function 'balance_dirty_pages_ratelimited'
       balance_dirty_pages_ratelimited(mapping);
       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/backing-dev.h:15:0,
                    from drivers/mtd/devices/block2mtd.c:23:
   include/linux/writeback.h:367:6: note: declared here
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   include/linux/compiler.h:230:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> fs/ntfs/attrib.c:2548:48: sparse: not enough arguments for function balance_dirty_pages_ratelimited
   fs/ntfs/attrib.c:2589:48: sparse: not enough arguments for function balance_dirty_pages_ratelimited
   fs/ntfs/attrib.c:2606:48: sparse: not enough arguments for function balance_dirty_pages_ratelimited
   fs/ntfs/attrib.c: In function 'ntfs_attr_set':
   fs/ntfs/attrib.c:2548:35: error: passing argument 1 of 'balance_dirty_pages_ratelimited' from incompatible pointer type [-Werror=incompatible-pointer-types]
      balance_dirty_pages_ratelimited(mapping);
                                      ^~~~~~~
   In file included from include/linux/memcontrol.h:30:0,
                    from include/linux/swap.h:8,
                    from fs/ntfs/attrib.c:26:
   include/linux/writeback.h:367:6: note: expected 'struct backing_dev_info *' but argument is of type 'struct address_space *'
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ntfs/attrib.c:2548:3: error: too few arguments to function 'balance_dirty_pages_ratelimited'
      balance_dirty_pages_ratelimited(mapping);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/memcontrol.h:30:0,
                    from include/linux/swap.h:8,
                    from fs/ntfs/attrib.c:26:
   include/linux/writeback.h:367:6: note: declared here
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ntfs/attrib.c:2589:35: error: passing argument 1 of 'balance_dirty_pages_ratelimited' from incompatible pointer type [-Werror=incompatible-pointer-types]
      balance_dirty_pages_ratelimited(mapping);
                                      ^~~~~~~
   In file included from include/linux/memcontrol.h:30:0,
                    from include/linux/swap.h:8,
                    from fs/ntfs/attrib.c:26:
   include/linux/writeback.h:367:6: note: expected 'struct backing_dev_info *' but argument is of type 'struct address_space *'
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ntfs/attrib.c:2589:3: error: too few arguments to function 'balance_dirty_pages_ratelimited'
      balance_dirty_pages_ratelimited(mapping);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/memcontrol.h:30:0,
                    from include/linux/swap.h:8,
                    from fs/ntfs/attrib.c:26:
   include/linux/writeback.h:367:6: note: declared here
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ntfs/attrib.c:2606:35: error: passing argument 1 of 'balance_dirty_pages_ratelimited' from incompatible pointer type [-Werror=incompatible-pointer-types]
      balance_dirty_pages_ratelimited(mapping);
                                      ^~~~~~~
   In file included from include/linux/memcontrol.h:30:0,
                    from include/linux/swap.h:8,
                    from fs/ntfs/attrib.c:26:
   include/linux/writeback.h:367:6: note: expected 'struct backing_dev_info *' but argument is of type 'struct address_space *'
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ntfs/attrib.c:2606:3: error: too few arguments to function 'balance_dirty_pages_ratelimited'
      balance_dirty_pages_ratelimited(mapping);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/memcontrol.h:30:0,
                    from include/linux/swap.h:8,
                    from fs/ntfs/attrib.c:26:
   include/linux/writeback.h:367:6: note: declared here
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   include/linux/compiler.h:230:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> fs/ntfs/file.c:279:48: sparse: not enough arguments for function balance_dirty_pages_ratelimited
   fs/ntfs/file.c:1917:48: sparse: not enough arguments for function balance_dirty_pages_ratelimited
   fs/ntfs/file.c: In function 'ntfs_attr_extend_initialized':
   fs/ntfs/file.c:279:35: error: passing argument 1 of 'balance_dirty_pages_ratelimited' from incompatible pointer type [-Werror=incompatible-pointer-types]
      balance_dirty_pages_ratelimited(mapping);
                                      ^~~~~~~
   In file included from include/linux/backing-dev.h:15:0,
                    from fs/ntfs/file.c:22:
   include/linux/writeback.h:367:6: note: expected 'struct backing_dev_info *' but argument is of type 'struct address_space *'
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ntfs/file.c:279:3: error: too few arguments to function 'balance_dirty_pages_ratelimited'
      balance_dirty_pages_ratelimited(mapping);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/backing-dev.h:15:0,
                    from fs/ntfs/file.c:22:
   include/linux/writeback.h:367:6: note: declared here
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ntfs/file.c: In function 'ntfs_perform_write':
   fs/ntfs/file.c:1917:35: error: passing argument 1 of 'balance_dirty_pages_ratelimited' from incompatible pointer type [-Werror=incompatible-pointer-types]
      balance_dirty_pages_ratelimited(mapping);
                                      ^~~~~~~
   In file included from include/linux/backing-dev.h:15:0,
                    from fs/ntfs/file.c:22:
   include/linux/writeback.h:367:6: note: expected 'struct backing_dev_info *' but argument is of type 'struct address_space *'
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ntfs/file.c:1917:3: error: too few arguments to function 'balance_dirty_pages_ratelimited'
      balance_dirty_pages_ratelimited(mapping);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/backing-dev.h:15:0,
                    from fs/ntfs/file.c:22:
   include/linux/writeback.h:367:6: note: declared here
    void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +74 drivers/mtd/devices/block2mtd.c

^1da177e Linus Torvalds     2005-04-16  58  	int pages = len >> PAGE_SHIFT;
^1da177e Linus Torvalds     2005-04-16  59  	u_long *p;
^1da177e Linus Torvalds     2005-04-16  60  	u_long *max;
^1da177e Linus Torvalds     2005-04-16  61  
^1da177e Linus Torvalds     2005-04-16  62  	while (pages) {
21d31f1f Joern Engel        2007-02-20  63  		page = page_read(mapping, index);
^1da177e Linus Torvalds     2005-04-16  64  		if (IS_ERR(page))
^1da177e Linus Torvalds     2005-04-16  65  			return PTR_ERR(page);
^1da177e Linus Torvalds     2005-04-16  66  
0ffb74cc Joern Engel        2007-02-20  67  		max = page_address(page) + PAGE_SIZE;
0ffb74cc Joern Engel        2007-02-20  68  		for (p=page_address(page); p<max; p++)
^1da177e Linus Torvalds     2005-04-16  69  			if (*p != -1UL) {
^1da177e Linus Torvalds     2005-04-16  70  				lock_page(page);
^1da177e Linus Torvalds     2005-04-16  71  				memset(page_address(page), 0xff, PAGE_SIZE);
^1da177e Linus Torvalds     2005-04-16  72  				set_page_dirty(page);
^1da177e Linus Torvalds     2005-04-16  73  				unlock_page(page);
031da73f NeilBrown          2012-12-12 @74  				balance_dirty_pages_ratelimited(mapping);
^1da177e Linus Torvalds     2005-04-16  75  				break;
^1da177e Linus Torvalds     2005-04-16  76  			}
^1da177e Linus Torvalds     2005-04-16  77  
09cbfeaf Kirill A. Shutemov 2016-04-01  78  		put_page(page);
^1da177e Linus Torvalds     2005-04-16  79  		pages--;
^1da177e Linus Torvalds     2005-04-16  80  		index++;
^1da177e Linus Torvalds     2005-04-16  81  	}
^1da177e Linus Torvalds     2005-04-16  82  	return 0;

:::::: The code at line 74 was first introduced by commit
:::::: 031da73fca29ebba3eea5a512746e01d52e542cd mtd: block2mtd: throttle writes by calling balance_dirty_pages_ratelimited.

:::::: TO: NeilBrown <neilb@suse.de>
:::::: CC: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
