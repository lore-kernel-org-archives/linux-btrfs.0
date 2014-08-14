Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:46518 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbaHNTkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 15:40:04 -0400
References: <8951EA18-525B-43F4-8B8E-499611A69465@free.fr> <CAGqmi75Sk2F1uvVf=dMdhMss8NPNH0QMxzG8qgEsi3FVGTE82Q@mail.gmail.com> <53EB510D.5090502@infinidat.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <53EB510D.5090502@infinidat.com>
Content-Type: text/plain;
	charset=utf-8
Message-Id: <69E28C17-D38D-455D-BB9C-644A493A2583@free.fr>
Cc: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Cyril Scetbon <cyril.scetbon@free.fr>
Subject: Re: Using Btrfs with Ubuntu 14.04
Date: Thu, 14 Aug 2014 21:39:56 +0200
To: nivw <nivw@infinidat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do you know what was happening with UEFI ?

Did you identify a list of important fixes needed to go for 3.14 ? If I understand well you kept the kernel and just change the driver version, right ?

Thanks Niv !

Cyril Scetbon

> Le 13 août 2014 à 13:50, nivw <nivw@infinidat.com> a écrit :
> 
> Cyril,
> I fresh installed ubuntu 14.04 with btrfs on the boot SSD and btrfs on a 1Tb HDD.
> I had some issue with the UEFI, when I turned it off in the BIOS , all worked fine.
> I am also running three other laptops , all with a single hard drive and 14.04 and run fine.
> I so need to remove snapshots ever once in a while, as I apt-get upgrade.
> I installed 3.14 on the three laptops as there where many btrfs bugs fixed there, and it all works fine.
> Niv
> 
>> On 12/08/14 18:34, Timofey Titovets wrote:
>> I not so long install ubuntu 14.04 to my friend and it working good,
>> but i don't know, devs of distro port fixes from newer kernel to 3.13
>> or not.
>> 
>> 2014-08-12 10:46 GMT+03:00 Cyril Scetbon <cyril.scetbon@free.fr>:
>>> Hi guys,
>>> 
>>> Can you tell me if there are any pitfalls to use Btrfs under Ubuntu 14.04 (Btrfs 3.12). Are there any well known bug that are only fixed later ? Please, send me links just to check if it could hurt or not ..
>>> 
>>> Thanks
>>> --
>>> Cyril SCETBON
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
