Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:64770 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732263AbeGKBDY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 21:03:24 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: Marc MERLIN <marc@merlins.org>
CC: Su Yue <Damenly_Su@gmx.com>, <quwenruo.btrfs@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180709031501.iutlokfvodtkkfhe@merlins.org>
 <17cc0cc1-b64d-4daa-18b5-bb2da3736ea1@cn.fujitsu.com>
 <20180709034058.wjavwjdyixx6smbw@merlins.org>
 <29302c14-e277-2c69-ac08-c4722c2b18aa@cn.fujitsu.com>
 <20180709155306.zr3p2kolnanvkpny@merlins.org>
 <trinity-4aae1c42-a85e-4c73-a30e-8b0d0be05e86-1531152875875@msvc-mesg-gmx023>
 <20180709174818.wq2d4awmgasxgwad@merlins.org>
 <trinity-4546309e-d603-4d29-885a-e76da594f792-1531159860064@msvc-mesg-gmx021>
 <20180709222218.GP9859@merlins.org>
 <440b7d12-3504-8b4f-5aa4-b1f39f549730@cn.fujitsu.com>
 <20180710041037.4ynitx3flubtwtvc@merlins.org>
 <58b36f04-3094-7de0-8d5e-e06e280aac00@cn.fujitsu.com>
Message-ID: <db8df5b1-9358-1413-79a3-afc912d4e816@cn.fujitsu.com>
Date: Wed, 11 Jul 2018 09:08:10 +0800
MIME-Version: 1.0
In-Reply-To: <58b36f04-3094-7de0-8d5e-e06e280aac00@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/10/2018 06:53 PM, Su Yue wrote:
> 
> 
> On 07/10/2018 12:10 PM, Marc MERLIN wrote:
>> On Tue, Jul 10, 2018 at 08:56:15AM +0800, Su Yue wrote:
>>>> I'm just not clear if my FS is still damaged and btrfsck was just 
>>>> hacked to
>>>> ignore the damage it can't deal with, or whether it was able to repair
>>>> things to a consistent state.
>>>> The fact that I can mount read/write with no errors seems like a 
>>>> good sign.
>>>>
>>> Yes, a good sign. Since extent tree is fixed, the errors left are in
>>> other trees. The most bad result I can see is that writes of some 
>>> files will
>>> reports IO Error. This is the cost of RW.
>>
>> Ok, so we agreed that btrfs scrub won't find this, so ultimately I
>> should run normal btrfsck --repair without the special block skip code
>> you added?
>>
> Yes. Here is the normal btrfsck which skips extent tree to save time.
> And I fixed a bug which is mentioned in other mail by Qu.
> I have no time to add progress of fs trees check though.
> https://github.com/Damenly/btrfs-progs/tree/tmp1
> 
> It may take a long time to fix errors unresolved.
> #./btrfsck -e 2 --mode=lowmem --repair $dev
> '-e' means to skip extent tree.
> Here is the mail. Running above command should sloves errors.
If no other errors occurs, your FS will be good.

Please not run repair of master branch, please :(.
It will ruin all things we did in recent days.

Thanks,
Su
> Thanks
> Su
> 
>> Since I can mount the filesystem read/write though, I can probably
>> delete a lot of snapshots to help the next fsck to run.
>> I assume the number of snapshots also affects the amount of memory taken
>> by regular fsck, so maybe if I delete enough of them regular fsck
>> --repair will work again?
>>
>> Thanks,
>> Marc
>>


