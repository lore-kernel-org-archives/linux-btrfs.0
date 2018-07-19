Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44148 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730628AbeGSIwK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 04:52:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6J896ki159492
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 08:10:13 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2k9yjx61d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 08:10:13 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6J8ADut015942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 08:10:13 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6J8ACSr016369
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 08:10:12 GMT
Date: Thu, 19 Jul 2018 11:10:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: anand.jain@oracle.com
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: add helper function check device delete able
Message-ID: <20180719080855.xytzxnj5vfvabipj@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Anand Jain,

The patch a6500c9ef8ac: "btrfs: add helper function check device
delete able" from Jul 10, 2018, leads to the following static checker
warning:

	fs/btrfs/volumes.c:1871 btrfs_device_delete_able()
	error: passing non negative 4 to ERR_PTR

	fs/btrfs/volumes.c:1876 btrfs_device_delete_able()
	error: passing non negative 6 to ERR_PTR

	fs/btrfs/volumes.c:1879 btrfs_device_delete_able()
	error: passing non negative 5 to ERR_PTR

	fs/btrfs/volumes.c:1883 btrfs_device_delete_able()
	error: passing non negative 7 to ERR_PTR

fs/btrfs/volumes.c
  1861  static struct btrfs_device *btrfs_device_delete_able(
  1862                                  struct btrfs_fs_info *fs_info,
  1863                                  const char *device_path, u64 devid)
  1864  {
  1865          int ret;
  1866          struct btrfs_device *device;
  1867  
  1868          ret = btrfs_check_raid_min_devices(fs_info,
  1869                                             btrfs_num_devices(fs_info) - 1);
  1870          if (ret)
  1871                  return ERR_PTR(ret);
                                       ^^^
This is a btrfs_err_code enum, not a negative error code.  It leads to
a NULL dereference in the caller.

  1872  
  1873          ret = btrfs_find_device_by_devspec(fs_info, devid, device_path,
  1874                                             &device);
  1875          if (ret)
  1876                  return ERR_PTR(ret);
                                       ^^^
  1877  
  1878          if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
  1879                  return ERR_PTR(BTRFS_ERROR_DEV_TGT_REPLACE);
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
Same only even more so.

  1880  
  1881          if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
  1882              fs_info->fs_devices->rw_devices == 1)
  1883                  return ERR_PTR(BTRFS_ERROR_DEV_ONLY_WRITABLE);
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  1884  
  1885          return device;
  1886  }

See also:

regards,
dan carpenter
