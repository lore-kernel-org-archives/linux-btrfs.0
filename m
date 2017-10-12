Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41558 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752798AbdJLUjI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 16:39:08 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9CKd7eQ024183
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 20:39:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9CKd7nx014140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 20:39:07 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9CKd67E006226
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 20:39:07 GMT
Date: Thu, 12 Oct 2017 23:39:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: anand.jain@oracle.com
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: error out if btrfs_attach_transaction() fails
Message-ID: <20171012203900.dqdsfcpbfjyl7bea@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Anand Jain,

The patch 1eea2715ca9b: "btrfs: error out if
btrfs_attach_transaction() fails" from Sep 28, 2017, leads to the
following static checker warning:

	fs/btrfs/volumes.c:2502 btrfs_init_new_device()
	error: 'trans' dereferencing possible ERR_PTR()

fs/btrfs/volumes.c
  2479                  ret = btrfs_relocate_sys_chunks(fs_info);
  2480                  if (ret < 0)
  2481                          btrfs_handle_fs_error(fs_info, ret,
  2482                                      "Failed to relocate sys chunks after device initialization. This can be fixed using the \"btrfs balance\" command.");
  2483                  trans = btrfs_attach_transaction(root);
  2484                  if (IS_ERR(trans)) {
  2485                          if (PTR_ERR(trans) == -ENOENT)
  2486                                  return 0;
  2487                          ret = PTR_ERR(trans);
  2488                          goto error_sysfs;
                                ^^^^^^^^^^^^^^^^
We used to have a direct return here.

  2489                  }
  2490                  ret = btrfs_commit_transaction(trans);
  2491          }
  2492  
  2493          /* Update ctime/mtime for libblkid */
  2494          update_dev_time(device_path);
  2495          return ret;
  2496  
  2497  error_sysfs:
  2498          btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
  2499  error_trans:
  2500          if (seeding_dev)
  2501                  sb->s_flags |= MS_RDONLY;
  2502          btrfs_end_transaction(trans);
                                      ^^^^^^
But now it's dereferencing an error pointer inside this function.

  2503          rcu_string_free(device->name);
  2504          kfree(device);
  2505  error:
  2506          blkdev_put(bdev, FMODE_EXCL);
  2507          if (seeding_dev && !unlocked) {
  2508                  mutex_unlock(&uuid_mutex);
  2509                  up_write(&sb->s_umount);
  2510          }
  2511          return ret;
  2512  }

regards,
dan carpenter
