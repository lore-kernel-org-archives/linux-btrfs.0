Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:49201 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725783AbeGKEDG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 00:03:06 -0400
Subject: Re: btrfs check lowmem, take 2
To: Marc MERLIN <marc@merlins.org>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>,
        Su Yue <Damenly_Su@gmx.com>
References: <20180710180915.onnxuak7vb7uywyn@merlins.org>
 <9afce26c-0a3f-3389-ba0f-597b26a8cd7e@cn.fujitsu.com>
 <20180711005852.prhnmohkzjplw54j@merlins.org>
 <9b612c36-f59c-b4c7-bb84-4a30c4a7d453@cn.fujitsu.com>
 <20180711014401.hic5vcp5h2tzgyxh@merlins.org>
 <9b0990aa-05aa-3e0e-463f-b4eb9894dc81@cn.fujitsu.com>
 <20180711033614.glhs2yt53napbrpr@merlins.org>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <e8e4b853-a20d-cd55-550e-2f2263d1984e@cn.fujitsu.com>
Date: Wed, 11 Jul 2018 12:07:05 +0800
MIME-Version: 1.0
In-Reply-To: <20180711033614.glhs2yt53napbrpr@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/11/2018 11:36 AM, Marc MERLIN wrote:
> On Wed, Jul 11, 2018 at 09:58:36AM +0800, Su Yue wrote:
>>
>>
>> On 07/11/2018 09:44 AM, Marc MERLIN wrote:
>>> On Wed, Jul 11, 2018 at 09:08:40AM +0800, Su Yue wrote:
>>>>
>>>>
>>>> On 07/11/2018 08:58 AM, Marc MERLIN wrote:
>>>>> On Wed, Jul 11, 2018 at 08:53:58AM +0800, Su Yue wrote:
>>>>>>> Problems
>>>>>>> 1) btrfs check --repair _still_ takes all 32GB of RAM and crashes the
>>>>>>> server, despite my deleting lots of snapshots.
>>>>>>> Is it because I have too many files then?
>>>>>>>
>>>>>> Yes. Original check first gather all infomation about extent tree and
>>>>>> your files in RAM, then process one by one.
>>>>>> But deleting still counts, it does speed lowmem check up.
>>>>>
>>>>> Understood.
>>>>>
>>>>>>> 2) I tried Su's master git branch for btrfs-progs to try and see how
>>>>>> Oh..No... My master branch is still 4.14. The true mater branch is
>>>>>> David's here:
>>>>>> https://github.com/kdave/btrfs-progs
>>>>>> But the master branch has a known bug which I fixed yesterday, please see
>>>>>> the mail.
>>>>>
>>>>> So, if I git sync it now, it should have your fix, and I can run it,
>>>>> correct?
>>>>>
>>>> Yes, please.
>>>
>>> Ok, I am now running
>>> gargamel:~# time btrfs check --mode=lowmem --repair /dev/mapper/dshelf2
>>> using git master from https://github.com/kdave/btrfs-progs
>>>
>> Please stop check, plese.
>>
>> The branch 'it' which I mean is
>> https://github.com/Damenly/btrfs-progs/tree/tmp1
> 
> Ok, sorry I thought you said you had pushed your changes to https://github.com/kdave/btrfs-progs
> yesterday.
> 
> So, I went back to https://github.com/Damenly/btrfs-progs.git/tmp1 and
> I'm running it without the extra options you added with hardcoded stuff:
> gargamel:/var/local/src/btrfs-progs.sy-test# ./btrfsck --mode=lowmem --repair /dev/mapper/dshelf2
> 
This is okay. Let's wait to see the result.

Thanks
Su
> Marc
> 


