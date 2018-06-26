Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34121 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753131AbeFZRPH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 13:15:07 -0400
Date: Tue, 26 Jun 2018 19:12:12 +0200
From: David Sterba <dsterba@suse.cz>
To: kbuild test robot <lkp@intel.com>
Cc: Nikolay Borisov <nborisov@suse.com>, kbuild-all@01.org, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Add graceful handling of V0 extents
Message-ID: <20180626171212.GN27958@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530021456-20749-1-git-send-email-nborisov@suse.com>
 <201806262305.0zHSrCSO%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201806262305.0zHSrCSO%fengguang.wu@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2018 at 12:05:39AM +0800, kbuild test robot wrote:
> Hi Nikolay,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on next-20180626]
> [cannot apply to btrfs/next v4.18-rc2 v4.18-rc1 v4.17 v4.18-rc2]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Nikolay-Borisov/btrfs-Add-graceful-handling-of-V0-extents/20180626-231445
> config: x86_64-randconfig-x015-201825 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    fs//btrfs/extent-tree.c: In function 'btrfs_lookup_extent_info':
> >> fs//btrfs/extent-tree.c:871:4: error: implicit declaration of function 'btrfs_print_v0_err'; did you mean 'btrfs_print_tree'? [-Werror=implicit-function-declaration]
>        btrfs_print_v0_err(fs_info);
>        ^~~~~~~~~~~~~~~~~~

Fixed by using trans->fs_info in the original patch so the followup that
removes 'fs_info' does not break compilation. Updated for-next branch
pushed.
