Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48918 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752536AbdFPIFe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 04:05:34 -0400
Date: Fri, 16 Jun 2017 16:05:25 +0800
From: Ye Xiaolong <xiaolong.ye@intel.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [kbuild-all] [PATCH] btrfs: Use btrfs_space_info_used instead of
 opencoding it
Message-ID: <20170616080525.GA23108@yexl-desktop>
References: <201706150919.Fdrnd5ZS%fengguang.wu@intel.com>
 <bf36f06d-c8fd-b54f-5027-3f3940618906@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bf36f06d-c8fd-b54f-5027-3f3940618906@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/15, Nikolay Borisov wrote:
>
>
>On 15.06.2017 04:17, kbuild test robot wrote:
>> Hi Nikolay,
>> 
>> [auto build test ERROR on v4.9-rc8]
>> [cannot apply to btrfs/next kdave/for-next next-20170614]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>> 
>> url:    https://github.com/0day-ci/linux/commits/Nikolay-Borisov/btrfs-Use-btrfs_space_info_used-instead-of-opencoding-it/20170615-084940
>> config: x86_64-randconfig-x012-201724 (attached as .config)
>> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
>> reproduce:
>>         # save the attached .config to linux build tree
>>         make ARCH=x86_64 
>> 
>> All errors (new ones prefixed by >>):
>> 
>>    fs/btrfs/extent-tree.c: In function 'btrfs_calc_reclaim_metadata_size':
>>>> fs/btrfs/extent-tree.c:4918:9: error: implicit declaration of function 'btrfs_space_info_used' [-Werror=implicit-function-declaration]
>>      used = btrfs_space_info_used(space_info, true);
>>             ^~~~~~~~~~~~~~~~~~~~~
>>    cc1: some warnings being treated as errors
>
>This patch builds cleanly on latest linux master and it's based off that
>tree. I don't see why it's being applied to 4.9-rc8.
>

Sorry it's caused by one bug in 0day, now we've fixed it in latest code.
Thanks for your information.

Thanks,
Xiaolong

>
>> 
>> vim +/btrfs_space_info_used +4918 fs/btrfs/extent-tree.c
>> 
>>   4912	
>>   4913		to_reclaim = min_t(u64, num_online_cpus() * SZ_1M, SZ_16M);
>>   4914		if (can_overcommit(root, space_info, to_reclaim,
>>   4915				   BTRFS_RESERVE_FLUSH_ALL))
>>   4916			return 0;
>>   4917	
>>> 4918		used = btrfs_space_info_used(space_info, true);
>>   4919	
>>   4920		if (can_overcommit(root, space_info, SZ_1M, BTRFS_RESERVE_FLUSH_ALL))
>>   4921			expected = div_factor_fine(space_info->total_bytes, 95);
>> 
>> ---
>> 0-DAY kernel test infrastructure                Open Source Technology Center
>> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>> 
>_______________________________________________
>kbuild-all mailing list
>kbuild-all@lists.01.org
>https://lists.01.org/mailman/listinfo/kbuild-all
