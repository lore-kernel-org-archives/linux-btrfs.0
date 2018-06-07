Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:41265 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751797AbeFGGxO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 02:53:14 -0400
Subject: Re: [PATCH v2 0/3] btrfs-progs: check: verify symlinks with
 append/immutable flags
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20180515013324.18838-1-suy.fnst@cn.fujitsu.com>
 <20180531114031.GP3539@twin.jikos.cz>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <7274f886-2635-6bc0-5689-0e4ebffda3db@cn.fujitsu.com>
Date: Thu, 7 Jun 2018 14:59:23 +0800
MIME-Version: 1.0
In-Reply-To: <20180531114031.GP3539@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/31/2018 07:40 PM, David Sterba wrote:
> On Tue, May 15, 2018 at 09:33:21AM +0800, Su Yue wrote:
>> This patchset can be fetch from my github:
>> https://github.com/Damenly/btrfs-progs/commits/odd_inode_flags
>> It's based on devel.
>>
>> symlinks should never have append/immutable attributes.
>> This patchset enables btrfs check to verify such corruption.
>>
>> PATCH[1] is for original mode.
>> PATCH[2] is for original mode.
>>
>> PATCH[3] adds a test image.
>> For further use, the directory is called bad-inode-flags.
>>
>> #issue 133
>>
>> ---
>> Changelog:
>> v2:
>>    Use "rec->errors |=" instead of "rec->errors =" in patch[1].
>>    Define new error bit of invalid inode flags in lowmem mode.
>>    Adjust print message in patch[2]. Thanks, Qu and Nikolay.
>>    Rename test directory from odd-inode-flags to bad-inode-flags.
>>
>> Su Yue (3):
>>    btrfs-progs: check: check symlinks with append/immutable flags
>>    btrfs-progs: lowmem: check symlinks with append/immutable flags
>>    btrfs-progs: fsck-tests: add test case to check symlinks with bad
>>      flags
> 
> Applied, thanks.

Hi David,
	Could you replace this patchset with new V3? It fixes the problem 
reported by Misono.

Thanks,
Su

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


