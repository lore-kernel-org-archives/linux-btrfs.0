Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54972 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbcDVA0k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 20:26:40 -0400
Subject: Re: [PATCH] btrfs: Test that qgroup counts are valid after snapshot
 creation
To: Mark Fasheh <mfasheh@suse.de>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
References: <20160419222530.GU2187@wotan.suse.de>
 <5716D1F6.6010507@jp.fujitsu.com> <20160421235348.GW2187@wotan.suse.de>
CC: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <dd1ae558-9214-022f-10e2-5efd68857e2e@cn.fujitsu.com>
Date: Fri, 22 Apr 2016 08:26:33 +0800
MIME-Version: 1.0
In-Reply-To: <20160421235348.GW2187@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2016/04/21 16:53 -0700:
> Thank you for the review, comments are below.
>
> On Wed, Apr 20, 2016 at 09:48:54AM +0900, Satoru Takeuchi wrote:
>> On 2016/04/20 7:25, Mark Fasheh wrote:
>>> +# Force a small leaf size to make it easier to blow out our root
>>> +# subvolume tree
>>> +_scratch_mkfs "--nodesize 16384"
>>
>> nodesize 16384 is the default value. Do you
>> intend other value, for example 4096?
>
> "future proofing" I suppose - if we up the default, the for loop below may
> not create a level 1 tree.
>
> If we force it smaller than 16K I believe that may mean we can't run this
> test on some kernels with page size larger than the typical 4k.
> 	--Mark
>
>
> --
> Mark Fasheh
>
>

Sorry for the late reply.

Unfortunately, for system with 64K page size, it will fail(mount and 
mkfs) if we use 16K nodesize.

IIRC, like some other btrfs qgroup test case, we use 64K nodesize as the 
safest nodesize.

And for level 1 tree create, the idea is to use inline file extents to 
rapidly create level 1 tree.

16 4K files should create a level 1 tree.
Although in this case, max_inline=4096 would be added to mount option 
though.

Thanks,
Qu


