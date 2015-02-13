Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41523 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbBMD4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 22:56:00 -0500
Received: by pdno5 with SMTP id o5so16564222pdn.8
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 19:56:00 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Subject: Re: btrfs performance, sudden drop to 0 IOPs
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20150213024624.GB25697@localhost.localdomain>
Date: Fri, 13 Feb 2015 11:55:54 +0800
Cc: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
Message-Id: <4F8CF413-337F-4E67-9DA1-C738390416C4@gmail.com>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com> <pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net> <CABdHLQ6La7BO-TJ3cYEx_NnOUhAYJ69uv3tGnVRYsWkiUrqCsQ@mail.gmail.com> <pan$9532$65b1220e$320184ed$94bcf659@cox.net> <62ntqb-o2r.ln1@hurikhan77.spdns.de> <20150213024624.GB25697@localhost.localdomain>
To: bo.li.liu@oracle.com
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello guys,

> 
> On Thu, Feb 12, 2015 at 05:33:41AM +0100, Kai Krakow wrote:
>> Duncan <1i5t5.duncan@cox.net> schrieb:
>> 
>>> P. Remek posted on Tue, 10 Feb 2015 18:44:33 +0100 as excerpted:
>>> 
>>>> In the test, I use --direct=1 parameter for fio which basically does
>>>> O_DIRECT on target file. The O_DIRECT should guarantee that the
>>>> filesystem cache is bypassed and IO is sent directly to the underlaying
>>>> storage. Are you saying that btrfs buffers writes despite of O_DIRECT?
>>> 
>>> I'm out of my (admin, no claims at developer) league on that.  I see
>>> someone else replied, and would defer to them on this.
>> 
>> I don't think that O_DIRECT can work efficiently on COW filesystems. It 
>> probably has a negative effect and cannot be faster as normal access. Linus 
>> itself said one time that O_DIRECT is broken and should go away, and instead 
>> cache hinting should be used.
>> 
>> Think of this: For the _unbuffered_ direct-io request to be fulfilled the 
>> file system has to go through its COW logic first which it otherwise had 
>> buffered and done in background. Bypassing the cache is probably only a 
>> side-effect of O_DIRECT, not its purpose.
> 
> Hmm, not true in btrfs, the COW logic mentioned above is nothing but to allocate
> a NEW extent, and it's not done in background.
> 
> Comparing to nocow logic, the main difference comes from 
> a) COW files' calculating checksums of the dirty data in DIO pages which nocow files don't need to.
> b) their endio handlers.
> 
> Or am I missing something?


We did benchmark Btrfs aio/dio performance before, we noticed one big differences
from COW and nocow is not only checksum but checksum cost more metadata, which will
make Btrfs performance drop suddenly for a while, because of metadata reservation.


> 
> Thanks,
> 
> -liubo
>> 
>> At least I'd try with a nocow-file for the benchmark if you still have to 
>> use O_DIRECT.
>> 
>> -- 
>> Replies to list only preferred.
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

