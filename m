Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:44270 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaHMLul (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 07:50:41 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so11243766wes.20
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 04:50:40 -0700 (PDT)
Message-ID: <53EB510D.5090502@infinidat.com>
Date: Wed, 13 Aug 2014 14:50:37 +0300
From: nivw <nivw@infinidat.com>
MIME-Version: 1.0
To: Timofey Titovets <nefelim4ag@gmail.com>,
        Cyril Scetbon <cyril.scetbon@free.fr>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Using Btrfs with Ubuntu 14.04
References: <8951EA18-525B-43F4-8B8E-499611A69465@free.fr> <CAGqmi75Sk2F1uvVf=dMdhMss8NPNH0QMxzG8qgEsi3FVGTE82Q@mail.gmail.com>
In-Reply-To: <CAGqmi75Sk2F1uvVf=dMdhMss8NPNH0QMxzG8qgEsi3FVGTE82Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cyril,
I fresh installed ubuntu 14.04 with btrfs on the boot SSD and btrfs on a 
1Tb HDD.
I had some issue with the UEFI, when I turned it off in the BIOS , all 
worked fine.
I am also running three other laptops , all with a single hard drive and 
14.04 and run fine.
I so need to remove snapshots ever once in a while, as I apt-get upgrade.
I installed 3.14 on the three laptops as there where many btrfs bugs 
fixed there, and it all works fine.
Niv

On 12/08/14 18:34, Timofey Titovets wrote:
> I not so long install ubuntu 14.04 to my friend and it working good,
> but i don't know, devs of distro port fixes from newer kernel to 3.13
> or not.
>
> 2014-08-12 10:46 GMT+03:00 Cyril Scetbon <cyril.scetbon@free.fr>:
>> Hi guys,
>>
>> Can you tell me if there are any pitfalls to use Btrfs under Ubuntu 14.04 (Btrfs 3.12). Are there any well known bug that are only fixed later ? Please, send me links just to check if it could hurt or not ..
>>
>> Thanks
>> --
>> Cyril SCETBON
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

