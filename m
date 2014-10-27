Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dub004-omc1s35.hotmail.com ([157.55.0.234]:60913 "EHLO
	DUB004-OMC1S35.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330AbaJ0QEV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 12:04:21 -0400
Message-ID: <DUB118-W25D606066B84BE0694286DA9E0@phx.gbl>
From: Jasper Verberk <jverberk@hotmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Problem converting data raid0 to raid1: enospc errors during
 balance
Date: Mon, 27 Oct 2014 16:04:19 +0000
In-Reply-To: <544DCECB.7060007@cn.fujitsu.com>
References: <DUB118-W4605047D55E17E62C8F651DA930@phx.gbl>
 <544DA288.8040907@cn.fujitsu.com>
 <1304C47B-8A9D-4AEA-B64A-C6566C77A5E1@colorremedies.com>,<544DCECB.7060007@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hej guys!

Thanks for your input on the issue this far.

Too my knowledge raid1 in btrfs means 2 copies of each piece of data independent of the amount of disks used.

So 4 x 2,73tb would result in a totaal storage of roughly 5,5tb right?

Shouldn't this be more then enough?

btw, here is the output for df:

http://paste.debian.net/128932/


----------------------------------------
> Date: Mon, 27 Oct 2014 12:49:15 +0800
> From: quwenruo@cn.fujitsu.com
> To: lists@colorremedies.com
> CC: jverberk@hotmail.com; linux-btrfs@vger.kernel.org
> Subject: Re: Problem converting data raid0 to raid1: enospc errors during balance
>
>
> -------- Original Message --------
> Subject: Re: Problem converting data raid0 to raid1: enospc errors
> during balance
> From: Chris Murphy <lists@colorremedies.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2014$BG/(B10$B7n(B27$BF|(B 12:40
>> On Oct 26, 2014, at 7:40 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>> Hi,
>>>
>>> Although I'm not completely sure, but it seems that, you really ran out of space.
>>>
>>> [1] Your array won't hold raid1 for 1.97T data
>>> Your array used up 1.97T raid0 data, it takes 1.97T for raid0.
>>> But if converted to 1.97T, it will occupy 1.97T X2 = 3.94T.
>>> Your array are only 2.73T, it is too small to contain the data.
>> I'm not understanding. The btrfs fi show, shows 4x 2.73TiB devices, so that seems like it's a 10+TiB array.
>>
>> There's 2.04TiB raid0 data chunks, so roughly 500GiB per device, yet 1.94TiB is reported used per device by fi show. Confusing.
>>
>> Also it's still very confusing: Data, RAID1: total=2.85TiB, used=790.46GiB whether this means 2.85TiB out of 10TiB is allocated, or if it's twice that due to raid1. I can't ever remember this presentation detail, so again the secret decode ring where the UI doesn't expressly tell us what's going on is going to continue to be a source of confusion for users.
>>
>>
>> Chris Murphy
> Oh, I misread the output....
>
> That turns strange now....
> BTW what's the output of 'df' command?
>
> Thanks,
> Qu
>
 		 	   		  ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
