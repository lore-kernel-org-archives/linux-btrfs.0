Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39859 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750814AbdFOGcr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 02:32:47 -0400
Subject: Re: [PATCH] btrfs: Use btrfs_space_info_used instead of opencoding it
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <201706150919.Fdrnd5ZS%fengguang.wu@intel.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bf36f06d-c8fd-b54f-5027-3f3940618906@suse.com>
Date: Thu, 15 Jun 2017 09:32:44 +0300
MIME-Version: 1.0
In-Reply-To: <201706150919.Fdrnd5ZS%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.06.2017 04:17, kbuild test robot wrote:
> Hi Nikolay,
> 
> [auto build test ERROR on v4.9-rc8]
> [cannot apply to btrfs/next kdave/for-next next-20170614]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Nikolay-Borisov/btrfs-Use-btrfs_space_info_used-instead-of-opencoding-it/20170615-084940
> config: x86_64-randconfig-x012-201724 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    fs/btrfs/extent-tree.c: In function 'btrfs_calc_reclaim_metadata_size':
>>> fs/btrfs/extent-tree.c:4918:9: error: implicit declaration of function 'btrfs_space_info_used' [-Werror=implicit-function-declaration]
>      used = btrfs_space_info_used(space_info, true);
>             ^~~~~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors

This patch builds cleanly on latest linux master and it's based off that
tree. I don't see why it's being applied to 4.9-rc8.


> 
> vim +/btrfs_space_info_used +4918 fs/btrfs/extent-tree.c
> 
>   4912	
>   4913		to_reclaim = min_t(u64, num_online_cpus() * SZ_1M, SZ_16M);
>   4914		if (can_overcommit(root, space_info, to_reclaim,
>   4915				   BTRFS_RESERVE_FLUSH_ALL))
>   4916			return 0;
>   4917	
>> 4918		used = btrfs_space_info_used(space_info, true);
>   4919	
>   4920		if (can_overcommit(root, space_info, SZ_1M, BTRFS_RESERVE_FLUSH_ALL))
>   4921			expected = div_factor_fine(space_info->total_bytes, 95);
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
