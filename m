Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45920 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaJ3Dtv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 23:49:51 -0400
Message-ID: <5451B65A.9090302@oracle.com>
Date: Thu, 30 Oct 2014 11:54:02 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Rene Thomas <re.thomas@gmx.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: read block failed check_tree_block / Couldn't read chunk tree
References: <CAHOQfW0CF1CrHrZ_T_G49kXh6scKK59aYYZn48fi112RfHX=wg@mail.gmail.com>	<545062CC.6020206@oracle.com> <CAHOQfW2hKtjJ=oCGp2KbvbtBsWxQpo+zforzrashVO7zDAmLHg@mail.gmail.com>
In-Reply-To: <CAHOQfW2hKtjJ=oCGp2KbvbtBsWxQpo+zforzrashVO7zDAmLHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




  yes that's the one.

 > btrfs-progs: fix device missing of btrfs fi show with seed devices

Thanks


On 10/29/2014 08:15 PM, Rene Thomas wrote:
> Can't find commit in official repos
>
> Get "fatal: bad object 915902c5002485fb13d27c4b699a73fb66cc0f09" from git show
>
> Found
> ----------------------------
> commit 2513077f2f830b4bc83d528bfb6979eb461918bd
>
> btrfs-progs: fix device missing of btrfs fi show with seed devices
> ----------------------------
>
> Thanks
> René
>
> 2014-10-29 4:45 GMT+01:00 Anand Jain <Anand.Jain@oracle.com>:
>>
>> this is (most likely) due to patch below,
>> ----------------
>> commit 915902c5002485fb13d27c4b699a73fb66cc0f09
>>
>>      btrfs-progs: fix device missing of btrfs fi show with seed devices
>> ----------------
>>
>>   Could you try to back out the patch from progs and give it a shot ?
>>   and pls report what you see. Thanks.
>>
>>
>>
>>
>>
>> On 10/25/14 00:43, Rene Thomas wrote:
>>>
>>>    # btrfs --version
>>> Btrfs v3.17
>>>
>>>    # btrfs fi show
>>> Label: 'mythstorage'  uuid: 9b454272-6800-4b3c-b196-9e180407a6cb
>>>           Total devices 1 FS bytes used 2.36MiB
>>>           devid    1 size 931.51GiB used 10.04GiB path /dev/sdd1
>>>
>>>    Check tree block failed, want=5845480062976, have=0
>>> Check tree block failed, want=5845480062976, have=0
>>> Check tree block failed, want=5845480062976, have=65536
>>> Check tree block failed, want=5845480062976, have=0
>>> Check tree block failed, want=5845480062976, have=0
>>> read block failed check_tree_block
>>> Couldn't read chunk tree
