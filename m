Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay0-omc2-s22.bay0.hotmail.com ([65.54.190.97]:57540 "EHLO
	bay0-omc2-s22.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935554Ab3E3QkU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 12:40:20 -0400
Message-ID: <BAY172-DS11658F206CE940C65E97E0B0910@phx.gbl>
From: "Kyle Gates" <kylegates@hotmail.com>
To: <miaox@cn.fujitsu.com>, <bo.li.liu@oracle.com>
Cc: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com> <h1rh5a-1lg.ln1@hurikhan.ath.cx> <CADn-QaNEdWiyKaniOhzAmaGb6p=PuZ4=FxPPPiVLZZJ3zB7xpQ@mail.gmail.com> <BAY172-DS142AB5E40D200CC3946388B0A40@phx.gbl> <20130510051500.GB5615@liubo.jp.oracle.com> <BAY172-DS77BDBEADA4D3971B47F29B0A50@phx.gbl> <BAY172-DS3707AF83BC83C3B48502DB0A30@phx.gbl> <20130517070443.GN20202@liubo.jp.oracle.com> <BAY172-DS16C3FC74BB7793F893E2B0B0970@phx.gbl> <20130529015510.GA6571@liubo> <51A5BD76.40504@cn.fujitsu.com>
In-Reply-To: <51A5BD76.40504@cn.fujitsu.com>
Subject: Re: nocow 'C' flag ignored after balance
Date: Thu, 30 May 2013 11:40:50 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 29, 2013 Miao Xie wrote:
> On wed, 29 May 2013 10:55:11 +0900, Liu Bo wrote:
>> On Tue, May 28, 2013 at 09:22:11AM -0500, Kyle Gates wrote:
>>>> From: Liu Bo <bo.li.liu@oracle.com>
>>>>
>>>> Subject: [PATCH] Btrfs: fix broken nocow after a normal balance
>>>>
>>> [...]
>>>
>>> Sorry for the long wait in replying.
>>> This patch was unsuccessful in fixing the problem (on my 3.8 Ubuntu
>>> Raring kernel). I can probably try again on a newer version if you
>>> think it will help.
>>> This was my first kernel compile so I patched by hand and waited (10
>>> hours on my old 32 bit single core machine).
>>>
>>> I did move some of the files off and back on to the filesystem to
>>> start fresh and compare but all seem to exhibit the same behavior
>>> after a balance.
>>>
>>
>> Thanks for testing the patch although it didn't help you.
>> Actually I tested it to be sure that it fixed the problems in my 
>> reproducer.
>>
>> So anyway can you please apply this debug patch in order to nail it down?
>
> Your patch can not fix the above problem is because we may 
> update ->last_snapshot
> after we relocate the file data extent.
>
> For example, there are two block groups which will be relocated, One is 
> data block
> group, the other is metadata block group. Then we relocate the data block 
> group firstly,
> and set the new generation for the file data extent item/the relative 
> extent item and
> set (new_generation - 1) for ->last_snapshot. After the relocation of this 
> block group,
> we will end the transaction and drop the relocation tree. If we end the 
> space balance now,
> we won't break the nocow rule because ->last_snapshot is less than the 
> generation of the file
> data extent item/the relative extent item. But there is still one block 
> group which will be
> relocated, when relocating the second block group, we will also start a 
> new transaction,
> and update ->last_snapshot if need. So, ->last_snapshot is greater than 
> the generation of the file
> data extent item we set before. And the nocow rule is broken.
>
> Back to this above problem. I don't think it is a serious problem, we only 
> do COW once after
> the relocation, then we will still honour the nocow rule. The behaviour is 
> similar to snapshot.
> So maybe it needn't be fixed.

I would argue that for large vm workloads, running a balance or adding disks 
is a common practice that will result in a drastic drop in performance as 
well as massive increases in metadata writes and fragmentation.
In my case my disks were thrashing severely, performance was poor and ntp 
couldn't even hold my clock stable.
If the fix is nontrival please add this to the todo list.
Thanks,
Kyle

> If we must fix this problem, I think the only way is that get the 
> generation at the beginning
> of the space balance, and then set it to ->last_snapshot 
> if ->last_snapshot is less than it,
> don't use (current_generation - 1) to update the ->last_snapshot. Besides 
> that, don't forget
> to store the generation into btrfs_balance_item, or the problem will 
> happen after we resume the
> balance.
>
> Thanks
> Miao
>
>>
>> thanks,
>> liubo
>>
>> [...]
>>
>
 

