Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39552 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbeCCLCD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Mar 2018 06:02:03 -0500
Subject: Re: [PATCH] btrfs: rename btrfs_close_extra_device to
 btrfs_free_extra_devids
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org
References: <20180227043242.26367-1-anand.jain@oracle.com>
 <201803011216.UCOGFQ7a%fengguang.wu@intel.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c12e47db-6a5e-3f88-6f05-3fe916dd6877@oracle.com>
Date: Sat, 3 Mar 2018 19:03:35 +0800
MIME-Version: 1.0
In-Reply-To: <201803011216.UCOGFQ7a%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/01/2018 12:42 PM, kbuild test robot wrote:
> Hi Anand,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on btrfs/next]
> [also build test ERROR on v4.16-rc3 next-20180228]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

  Should use v2 in the ML.

  [PATCH v2] btrfs: rename btrfs_close_extra_device to 
btrfs_free_extra_devids

Thanks, Anand

> url:    https://github.com/0day-ci/linux/commits/Anand-Jain/btrfs-rename-btrfs_close_extra_device-to-btrfs_free_extra_devids/20180301-120850
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git next
> config: x86_64-randconfig-x016-201808 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=x86_64
> 
> All errors (new ones prefixed by >>):
> 
>     fs/btrfs/disk-io.c: In function 'open_ctree':
>>> fs/btrfs/disk-io.c:2783:2: error: implicit declaration of function 'btrfs_free_extra_devids'; did you mean 'btrfs_free_extra_devid'? [-Werror=implicit-function-declaration]
>       btrfs_free_extra_devids(fs_devices, 0);
>       ^~~~~~~~~~~~~~~~~~~~~~~
>       btrfs_free_extra_devid
>     cc1: some warnings being treated as errors
