Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:8219 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750986AbeABXP0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 18:15:26 -0500
Date: Wed, 3 Jan 2018 07:15:11 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Josef Bacik <jbacik@fb.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org
Subject: [josef-btrfs:kill-btree-inode 30/32] fs/btrfs/disk-io.c:1059:13:
 sparse: incorrect type in assignment (different base types)
Message-ID: <201801030709.FpqC6oZl%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git kill-btree-inode
head:   225f09a5848138ede157eff4aa27bfa70d354fcb
commit: fb6cad3454e3172599129cff50d5234a7abc551c [30/32] Btrfs: kill the btree_inode
reproduce:
        # apt-get install sparse
        git checkout fb6cad3454e3172599129cff50d5234a7abc551c
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


vim +1059 fs/btrfs/disk-io.c

  1047	
  1048	static blk_status_t __btree_submit_bio_done(void *private_data, struct bio *bio,
  1049						    int mirror_num, unsigned long bio_flags,
  1050						    u64 bio_offset)
  1051	{
  1052		struct btrfs_eb_info *eb_info = private_data;
  1053		int ret;
  1054	
  1055		/*
  1056		 * when we're called for a write, we're already in the async
  1057		 * submission context.  Just jump into btrfs_map_bio
  1058		 */
> 1059		ret = btrfs_map_bio(eb_info->fs_info, bio, mirror_num, 1);
  1060		if (ret) {
> 1061			bio->bi_status = ret;
  1062			bio_endio(bio);
  1063		}
> 1064		return ret;
  1065	}
  1066	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
