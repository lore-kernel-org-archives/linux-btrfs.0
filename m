Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31634 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751329AbcEKCYI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 22:24:08 -0400
Subject: Re: [PATCH v10 02/21] btrfs: dedupe: Introduce function to initialize
 dedupe info
To: Mark Fasheh <mfasheh@suse.de>
References: <1459492512-31435-3-git-send-email-quwenruo@cn.fujitsu.com>
 <201604011730.6UVg1lC7%fengguang.wu@intel.com>
 <20160511000053.GE7633@wotan.suse.de>
 <d3a920c7-d1df-5697-7a9d-c7163197986d@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <1e2e1789-edc0-0759-5401-d960a2da6817@cn.fujitsu.com>
Date: Wed, 11 May 2016 10:24:04 +0800
MIME-Version: 1.0
In-Reply-To: <d3a920c7-d1df-5697-7a9d-c7163197986d@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Qu Wenruo wrote on 2016/05/11 08:21 +0800:
>
>
> Mark Fasheh wrote on 2016/05/10 17:00 -0700:
>> On Fri, Apr 01, 2016 at 05:59:13PM +0800, kbuild test robot wrote:
>>> Hi Wang,
>>>
>>> [auto build test ERROR on btrfs/next]
>>> [also build test ERROR on v4.6-rc1 next-20160401]
>>> [if your patch is applied to the wrong git tree, please drop us a
>>> note to help improving the system]
>>>
>>> url:
>>> https://github.com/0day-ci/linux/commits/Qu-Wenruo/Btrfs-dedupe-framework/20160401-143937
>>>
>>> base:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
>>> next
>>> config: x86_64-rhel (attached as .config)
>>> reproduce:
>>>         # save the attached .config to linux build tree
>>>         make ARCH=x86_64
>>>
>>> Note: the
>>> linux-review/Qu-Wenruo/Btrfs-dedupe-framework/20160401-143937 HEAD
>>> 0a445f5009c064ee1d3fc966e41bb75627594afe builds fine.
>>>       It only hurts bisectibility.
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>>> ERROR: "btrfs_dedupe_disable" [fs/btrfs/btrfs.ko] undefined!
>>>
>>> ---
>>> 0-DAY kernel test infrastructure                Open Source
>>> Technology Center
>>> https://lists.01.org/pipermail/kbuild-all                   Intel
>>> Corporation
>>
>> Please correct this, we need to be able to bisect a kernel without random
>> patches breaking the build.
>>     --Mark
>>
>> --
>> Mark Fasheh
>>
>>
> The build bot is just using wrong branch.
>
> We're using integration-4.6, which is not in their build bot branching.
>
> Thanks,
> Qu

Oh, my fault, I just get confused it with old days when it uses wrong 
branch.

Will fix it in v11 patchset.

Thanks,
Qu
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


