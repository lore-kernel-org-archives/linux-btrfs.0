Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44040 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbeGKJWN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 05:22:13 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: [PULL] volume and uuid_mutex cleanups
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <6c60fc86-6e19-81dc-fff1-2d92201c401a@oracle.com>
Date: Wed, 11 Jul 2018 17:22:06 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi David,

Here I have put together a set of volume related patches which were
sent to the ML as independent patches earlier. These have been
reviewed and tested. Please pull.

  git@github.com:asj/btrfs-devel.git misc-next-for-kdave

-----------------
[Anand:2]
6049bd5e9694 btrfs: add helper function check device delete able
8c96747831b0 btrfs: add helper btrfs_num_devices() to deduce num_devices
dd61850ee7cf btrfs: warn for num_devices below 0
17c285ada2e4 btrfs: use the assigned fs_devices instead of the dereference
e2f7c8a0f67b btrfs: do device clone using the btrfs_scan_one_device
89325c85d655 btrfs: fix race between free_stale_devices and close_fs_devices
0dfd68121520 btrfs: drop uuid_mutex in btrfs_free_extra_devids()

[David:2]
6fa6985bd169 btrfs: fix mount and ioctl device scan ioctl race
e9f25a7b239d btrfs: reorder initialization before the mount locks uuid_mutex
2c5058cdf788 btrfs: lift uuid_mutex to callers of btrfs_parse_early_options
8ffc96e797bb btrfs: lift uuid_mutex to callers of btrfs_open_devices
39a2036c1d13 btrfs: lift uuid_mutex to callers of btrfs_scan_one_device

[Anand:1]
e735e867d314 btrfs: fix btrfs_free_stale_devices() with needed locks
bdc6cc879388 btrfs: btrfs_free_stale_devices() rename local variables
0dd1ff5cc6be btrfs: fix device_list_add() missing device_list_mutex()
622f0a7c31fe btrfs: do btrfs_free_stale_devices() outside of 
device_list_add()

[David:1]
7302fc024079 btrfs: restore uuid_mutex in btrfs_open_devices

[Nikolay]
4da856347110 btrfs: drop pending list in device close
-----------------

Thanks, Anand
