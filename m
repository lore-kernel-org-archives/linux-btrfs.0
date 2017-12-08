Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49554 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753696AbdLHLIm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 06:08:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB8B79Z9160168
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Dec 2017 11:08:41 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2eqs8sr285-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Dec 2017 11:08:41 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vB8B8exc011580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Dec 2017 11:08:40 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB8B8eVN013619
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Dec 2017 11:08:40 GMT
Date: Fri, 8 Dec 2017 14:08:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: anand.jain@oracle.com
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: cleanup device states define
 BTRFS_DEV_STATE_IN_FS_METADATA
Message-ID: <20171207202858.vomwdy3r4b3hsc7n@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Anand Jain,

The patch 2dcfcdc43524: "btrfs: cleanup device states define
BTRFS_DEV_STATE_IN_FS_METADATA" from Dec 4, 2017, leads to the
following static checker warning:

	fs/btrfs/super.c:2007 btrfs_calc_avail_data_space()
	warn: test_bit() takes a bit number

fs/btrfs/super.c
  2004  
  2005          rcu_read_lock();
  2006          list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
  2007                  if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This BTRFS_DEV_STATE_IN_FS_METADATA define is BIT(1) but for test_bit()
we should just take 1.  In other words we are doing double BIT(BIT(1)).

  2008                                                  &device->dev_state) ||
  2009                      !device->bdev ||
  2010                      test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
  2011                          continue;
  2012  
  2013                  if (i >= nr_devices)
  2014                          break;
  2015  

I get a bunch of these warnings.

drivers/md/md-bitmap.c:1993 bitmap_copy_from_slot() warn: 'bitmap_file_test_bit(bitmap, block)' returns positive and negative
    [ I threw this one is as a bonus.  The warning is because are we
      handling the -EINVAL return from bitmap_file_test_bit() correctly?
      I have no idea. ]

fs/btrfs/super.c:2007 btrfs_calc_avail_data_space() warn: test_bit() takes a bit number
fs/btrfs/super.c:2010 btrfs_calc_avail_data_space() warn: test_bit() takes a bit number
fs/btrfs/super.c:2315 btrfs_show_devname() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3351 write_dev_flush() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3361 wait_dev_flush() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3364 wait_dev_flush() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3392 barrier_all_devices() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3396 barrier_all_devices() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3397 barrier_all_devices() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3406 barrier_all_devices() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3412 barrier_all_devices() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3413 barrier_all_devices() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3510 write_all_supers() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3511 write_all_supers() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3550 write_all_supers() warn: test_bit() takes a bit number
fs/btrfs/disk-io.c:3551 write_all_supers() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:695 btrfs_open_one_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:699 btrfs_open_one_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:701 btrfs_open_one_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:709 btrfs_open_one_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:713 btrfs_open_one_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:829 device_list_add() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:831 device_list_add() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:913 btrfs_close_extra_devices() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:915 btrfs_close_extra_devices() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:935 btrfs_close_extra_devices() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:945 btrfs_close_extra_devices() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:947 btrfs_close_extra_devices() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:948 btrfs_close_extra_devices() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:980 btrfs_close_bdev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:997 btrfs_prepare_close_one_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:1003 btrfs_prepare_close_one_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:1258 btrfs_account_dev_extents_size() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:1437 find_free_dev_extent_start() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:1644 btrfs_alloc_dev_extent() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:1645 btrfs_alloc_dev_extent() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:1891 btrfs_find_next_active_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:1953 btrfs_rm_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:1958 btrfs_rm_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:1964 btrfs_rm_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:1986 btrfs_rm_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2006 btrfs_rm_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2026 btrfs_rm_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2053 btrfs_rm_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2081 btrfs_rm_dev_replace_remove_srcdev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2084 btrfs_rm_dev_replace_remove_srcdev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2096 btrfs_rm_dev_replace_free_srcdev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2206 btrfs_find_device_missing_or_by_path() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2448 btrfs_init_new_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2459 btrfs_init_new_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2460 btrfs_init_new_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2655 btrfs_init_dev_replace_tgtdev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2668 btrfs_init_dev_replace_tgtdev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2669 btrfs_init_dev_replace_tgtdev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2697 btrfs_init_dev_replace_tgtdev_for_resume() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2755 btrfs_grow_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:2765 btrfs_grow_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:3575 __btrfs_balance() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:3578 __btrfs_balance() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:4446 btrfs_shrink_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:4458 btrfs_shrink_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:4583 btrfs_shrink_device() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:4743 __btrfs_alloc_chunk() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:4749 __btrfs_alloc_chunk() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:4751 __btrfs_alloc_chunk() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:5099 btrfs_chunk_readonly() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:5104 btrfs_chunk_readonly() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6135 btrfs_schedule_bio() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6283 btrfs_map_bio() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6332 add_missing_dev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6551 read_one_chunk() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6582 fill_device_from_item() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6695 read_one_dev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6703 read_one_dev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6708 read_one_dev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6723 read_one_dev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6730 read_one_dev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6731 read_one_dev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6732 read_one_dev() warn: test_bit() takes a bit number
fs/btrfs/volumes.c:6896 btrfs_check_rw_degradable() warn: test_bit() takes a bit number
fs/btrfs/extent-tree.c:9696 btrfs_can_relocate() warn: test_bit() takes a bit number
fs/btrfs/extent-tree.c:10881 btrfs_trim_free_extents() warn: test_bit() takes a bit number
fs/btrfs/scrub.c:2525 scrub_pages() warn: test_bit() takes a bit number
fs/btrfs/scrub.c:2860 scrub_extent_for_parity() warn: test_bit() takes a bit number
fs/btrfs/scrub.c:4102 btrfs_scrub_dev() warn: test_bit() takes a bit number
fs/btrfs/scrub.c:4109 btrfs_scrub_dev() warn: test_bit() takes a bit number
fs/btrfs/scrub.c:4120 btrfs_scrub_dev() warn: test_bit() takes a bit number
fs/btrfs/scrub.c:4121 btrfs_scrub_dev() warn: test_bit() takes a bit number
fs/btrfs/extent_io.c:2030 repair_io_failure() warn: test_bit() takes a bit number
fs/btrfs/ioctl.c:1504 btrfs_ioctl_resize() warn: test_bit() takes a bit number
fs/btrfs/ioctl.c:1529 btrfs_ioctl_resize() warn: test_bit() takes a bit number
fs/btrfs/dev-replace.c:175 btrfs_init_dev_replace() warn: test_bit() takes a bit number
fs/btrfs/dev-replace.c:310 btrfs_dev_name() warn: test_bit() takes a bit number
fs/btrfs/dev-replace.c:570 btrfs_dev_replace_finishing() warn: test_bit() takes a bit number

regards,
dan carpenter
