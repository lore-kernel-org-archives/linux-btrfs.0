Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34675 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750787AbbFXGyu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 02:54:50 -0400
Subject: Re: [GIT PULL] Qgroup rework with other Fujitsu fix.
To: Wang Shilong <wangshilong1991@gmail.com>, Chris Mason <clm@fb.com>
References: <557506BC.701@cn.fujitsu.com> <557681C6.7050608@gmail.com>
CC: <adam900710@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <558A5436.6080907@cn.fujitsu.com>
Date: Wed, 24 Jun 2015 14:54:46 +0800
MIME-Version: 1.0
In-Reply-To: <557681C6.7050608@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Wang Shilong wrote on 2015/06/09 14:03 +0800:
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
Our test is done but the test result doesn't show much improvement nor 
regression on our multi subvolume test.

Since there is not such indicated performance test for multi snapshot 
case, we use the following script body to generate such environment.
---
btrfs subvolume create $MNT/orig_subv
for i in `seq 1 50`; do
	$FSSTRESS -s $i -n 500 -w -d $MNT/orig_subv
	btrfs subvolume snapshot $MNT/orig_subv $MNT/snap_$i
done
---

And then do sysbench in snap_25.

The result can be get from the following URL:
https://drive.google.com/file/d/0BxpkL3ehzX3pVElpTjAtTE52Rm8/view?usp=sharing

The above result maybe not accurate since we don't have enough time to 
run them several times, and we reuse the data from our internal 4.0-rc1 
result.
So the changes from 4.0-rc1 to the integration branch may also have some 
impact.
But should gives a overall view on performance change, which is on par 
with previous kernel.

Although I'm pretty sure for muliti snapshot case number of calling 
btrfs_find_all_roots() can be greatly reduced with the patchset, but it 
seems that's not the hotspot....

So this patchset is better considered as a bug fix. :(

Thanks,
Qu
>
> Regards,
> Wang Shilong
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
