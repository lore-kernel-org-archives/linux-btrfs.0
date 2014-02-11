Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33432 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaBKBXk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 20:23:40 -0500
Message-ID: <52F97B3E.9060608@cn.fujitsu.com>
Date: Tue, 11 Feb 2014 09:22:06 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>
CC: Wang Shilong <wangshilong1991@gmail.com>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: btrfs/004: fix to make test really work
References: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com> <52F925EA.20600@fb.com>
In-Reply-To: <52F925EA.20600@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On 02/11/2014 03:18 AM, Josef Bacik wrote:
>
>
> On 02/10/2014 07:10 AM, Wang Shilong wrote:
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>
>> So i was wandering why test 004 could pass my previous wrong
>> kernel patch while it defenitely should not.
>>
>> By some debugging, i found here perl script is wrong, we did not
>> filter out anything and this unit test did not work acutally.so
>> it came out we will never fail this test.
>>
>
> So now with this patch I'm failing it, is there some btrfs patch I 
> need to make it not fail or is it still not supposed to fail normally 
> and is this patch broken?  Thanks,
You should not have updated my previous patch(Btrfs: switch to 
btrfs_previous_extent_item()) when you fail this test.
I update your latest btrfs-next which has updated my previous patch and 
it can pass this case, did you miss that?

Thanks,
Wang
>
> Josef
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

