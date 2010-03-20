From: Dan Carpenter <error27@gmail.com>
Subject: locking problems: Btrfs: be more selective in the defrag ioctl
Date: Sat, 20 Mar 2010 14:38:51 +0300
Message-ID: <20100320113851.GB5331@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

There is a locking problem in 
	940100a4a7b78 "Btrfs: be more selective in the defrag ioctl"

There are two places where we break out of the while loop under the 
lock.

fs/btrfs/ioctl.c +708 btrfs_defrag_file(159) error: double lock 'mutex:&inode->i_mutex'
   600                  mutex_lock(&inode->i_mutex);
   601                  if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
   602                          BTRFS_I(inode)->force_compress = 1;
   603  
   604                  ret = btrfs_check_data_free_space(root, inode, PAGE_CACHE_SIZE);
   605                  if (ret) {
   606                          ret = -ENOSPC;
   607                          break;

	Here.

   608                  }
   609  
   610                  ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
   611                  if (ret) {
   612                          btrfs_free_reserved_data_space(root, inode,
   613                                                         PAGE_CACHE_SIZE);
   614                          ret = -ENOSPC;
   615                          break;

	And here.

   616                  }

Maybe we should have "goto err_reservations;" instead of break?  I
don't know the code well enough to say.

regards,
dan carpenter
