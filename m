Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55147 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3JYELV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 00:11:21 -0400
Message-ID: <5269EEA3.50704@cn.fujitsu.com>
Date: Fri, 25 Oct 2013 12:08:03 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, dustymabe@gmail.com
Subject: Re: [PATCH] Btrfs: fix negative qgroup tracking from owner accounting
 (bug #61951)
References: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net> <801531AB-DF1E-44AC-B58E-D0388C7FCC55@gmail.com> <52693E77.30709@jan-o-sch.net>
In-Reply-To: <52693E77.30709@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,

On 10/24/2013 11:36 PM, Jan Schmidt wrote:
> On Thu, October 24, 2013 at 16:49 (+0200), Wang Shilong wrote:
>> Hello Jan,
>>
>>> btrfs_dec_ref() queued a delayed ref for owner of a tree block. The qgroup
>>> tracking is based on delayed refs. The owner of a tree block is set when a
>>> tree block is allocated, it is never updated.
>>>
>>> When you allocate a tree block and then remove the subvolume that did the
>>> allocation, the qgroup accounting for that removal is correct. However, the
>>> removal was accounted again for each subvolume deletion that also referenced
>>> the tree block, because accounting was erroneously based on the owner.
>>>
>>> Instead of queueing delayed refs for the non-existent owner, we now
>>> queue delayed refs for the root being removed. This fixes the qgroup
>>> accounting.
>> Thanks for tracking this, i apply your patch, and using the flowing patch,
>> found the problem still exist, the test script like the following:
> Reproduced. Gives more negative numbers due to accounting triggered by the
> cleaner thread, that's the common part here. I still believe that the fix I sent
> is correct, it's probably not complete. Looking into it.
I really wait cleaner thread to finish work, and i use btrfs-debug-tree 
to confirm
all the fs tree have been deleted.

But using btrfs qgroup show, i still get negative numers, also root 
subvolume's
exclusive is wrong.. Statices are like following.

0/5 13090816 471040
0/257 13078528 0
0/259 13078528 0
0/260 13078528 0
0/261 13078528 0
.........................
........................
.......................
0/350 13078528 0
0/351 13078528 0
0/352 13078528 0
0/353 13078528 0
0/354 13078528 0
0/355 13078528 0
0/356 13078528 0
0/357 13078528 0
0/358 12619776 -155648

Thanks,
Wang
>
> Thanks,
> -Jan
>
>> #!/bin/sh
>>
>> for i in $(seq 1000)
>> do
>> 	dd if=/dev/zero of=<mnt>/$i""aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  bs=10K count=1
>> done
>>
>> btrfs sub snapshot <mnt> <mnt>/1
>> for i in $(seq 100)
>> do
>> 	btrfs sub snapshot <mnt>/$i <mnt>/$(($i+1))
>> done
>>
>> for i in $(seq 101)
>> do
>> 	btrfs sub delete <mnt>/$i
>> done
>>
>>
>> Thanks,
>> Wang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


