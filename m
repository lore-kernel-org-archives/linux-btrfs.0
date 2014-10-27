Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17549 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750705AbaJ0Erb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 00:47:31 -0400
Message-ID: <544DCECB.7060007@cn.fujitsu.com>
Date: Mon, 27 Oct 2014 12:49:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Jasper Verberk <jverberk@hotmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Problem converting data raid0 to raid1: enospc errors during
 balance
References: <DUB118-W4605047D55E17E62C8F651DA930@phx.gbl> <544DA288.8040907@cn.fujitsu.com> <1304C47B-8A9D-4AEA-B64A-C6566C77A5E1@colorremedies.com>
In-Reply-To: <1304C47B-8A9D-4AEA-B64A-C6566C77A5E1@colorremedies.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Problem converting data raid0 to raid1: enospc errors 
during balance
From: Chris Murphy <lists@colorremedies.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年10月27日 12:40
> On Oct 26, 2014, at 7:40 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>> Hi,
>>
>> Although I'm not completely sure, but it seems that, you really ran out of space.
>>
>> [1] Your array won't hold raid1 for 1.97T data
>> Your array used up 1.97T raid0 data, it takes 1.97T for raid0.
>> But if converted to 1.97T, it will occupy 1.97T X2 = 3.94T.
>> Your array are only 2.73T, it is too small to contain the data.
> I'm not understanding. The btrfs fi show, shows 4x 2.73TiB devices, so that seems like it's a 10+TiB array.
>
> There's 2.04TiB raid0 data chunks, so roughly 500GiB per device, yet 1.94TiB is reported used per device by fi show. Confusing.
>
> Also it's still very confusing: Data, RAID1: total=2.85TiB, used=790.46GiB whether this means 2.85TiB out of 10TiB is allocated, or if it's twice that due to raid1. I can't ever remember this presentation detail, so again the secret decode ring where the UI doesn't expressly tell us what's going on is going to continue to be a source of confusion for users.
>
>
> Chris Murphy
Oh, I misread the output....

That turns strange now....
BTW what's the output of 'df' command?

Thanks,
Qu

