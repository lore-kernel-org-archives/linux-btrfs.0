Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63277 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932400AbbFIHJw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 03:09:52 -0400
Message-ID: <5576913B.8000903@cn.fujitsu.com>
Date: Tue, 9 Jun 2015 15:09:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, Chris Mason <clm@fb.com>
CC: <adam900710@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Qgroup rework with other Fujitsu fix.
References: <557506BC.701@cn.fujitsu.com> <557681C6.7050608@gmail.com>
In-Reply-To: <557681C6.7050608@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Hi Qu,
>
>> Hi Chris,
>>
>> Please pull the 19 patchset from my branch for_chris_4.2.
>> We have tested it in a week.
>>
>> Although it is originally based on 4.1-rc5, not the integration branch.
>> Quick tests shows no new bugs, although we will rerun the full test,
>> I'll send the patchset first for your reviewing:
>>
>> https://github.com/adam900710/linux.git for_chris_4.2
>>
>> This contains the following patches.
>>
>> 1. Qgroup rework (first 18 commits)
>> These commits rework the qgroup framework.
>> Now, quota won't need to do per-delayed-ref accounting.
>> But only need to record dirty delayed-ref, and account quota at transaction time.
>
> Can you share perfomaces results with/without patches with quota enabled.
> Especially, if there are thounds of snapshots, how much performaces down or up
> with these patches applied.
>
> Regards,
> Wang Shilong
For multi-snapshot case, the test is still running and I'll post the
result ASAP.

But we already have the performance(sysbench) result between quota
disabled and quota enabled with the pull.

Note: we have already done tests on the pull branch, and it shows no
performance regression compared to 4.1-rc5 without quota.
So the result without quota should be a correct baseline.

Overall, the performance drop is below 5% and I think it's completely
acceptable for the complex of btrfs quota compared to other filesystems.

Only one tests shows a performance drop over 5%:
1. Random read with DIO on small files, single thread, 4K block size.

The drop is about 11%.

And some result may not be stable enough, we will double check but it 
needs a lot of time to do performance test.

For the full result, please refer to the google docs URL:
https://docs.google.com/spreadsheets/d/1m5c96PrxigtLl_m5OlMdrTUxr82CxJuOGDbjtDrv_I8/edit?usp=sharing

Thanks,
Qu

>
>>
>> The good thing is, at transaction time, we have no other interruption or
>> concurrency, account can be quite accurate and only need to account once
>> for every dirty extent.(especially faster for shared extents)
>>
>> And clearer codes and logic. Codes changes from 1K to 0.5K, even a lot
>> of comments are added.
>>
>> With the patchset, btrfs can pass all qgroup test in fstests.
>> No longer minus number now.
>>
>> The only problem left is, we need a new mechanism to account subvolume deletion. But this is the long-existing problem, I'd prefer to address
>> it in next merge windows if we have a pretty method to solve it.
>>
>> Or maybe a small patch to mark qgroup inconsistent when delete subvolume with level higher than 0.
>>
>> 2. write-rm-loop fixes from Zhao Lei.
>> Other patches from Zhao Lei and Forrest Liu have already been merged
>> into mainline, but this is the one still unmerged.
>>
>> This patch fixes the last super rare problem we found in write-rm-loop
>> case.
>> And the patch will only modify the minor routine, so it won't affect the normal routine.
>>
>> Thanks,
>> Qu
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
