Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:25524 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727286AbeHaUGc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 16:06:32 -0400
Received: from mail.tol.fr (unknown [IPv6:2a01:e34:eeaf:c5f0:428d:5cff:fee6:854e])
        by smtp2-g21.free.fr (Postfix) with ESMTP id 7B903200385
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 17:58:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.tol.fr (Postfix) with ESMTP id 1362E978037D
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 17:58:21 +0200 (CEST)
Received: from mail.tol.fr ([127.0.0.1])
        by localhost (sos.couderc.eu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3Lk_lYdMDrCU for <linux-btrfs@vger.kernel.org>;
        Fri, 31 Aug 2018 17:58:20 +0200 (CEST)
Received: from [192.168.163.11] (unknown [192.168.163.254])
        by mail.tol.fr (Postfix) with ESMTPSA id 03A5C9780362
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 17:58:13 +0200 (CEST)
Subject: Re: How to erase a RAID1 (+++)?
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
 <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
 <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
 <CAJCQCtTcCWavzu5k6ZnhCDU+jaHxWfzfuR5Whic1-ic0s+x+8g@mail.gmail.com>
 <pan$4e7f0$2612a395$18eaf6d3$f09fc7a4@cox.net>
 <076f8cb5-1a34-4d1b-727a-466de1e30088@couderc.eu>
 <VI1PR08MB0862F346E3B20945F73133CE920F0@VI1PR08MB0862.eurprd08.prod.outlook.com>
From: Pierre Couderc <pierre@couderc.eu>
Message-ID: <c05bf792-35fe-daa9-b374-fca0b89a129a@couderc.eu>
Date: Fri, 31 Aug 2018 17:58:03 +0200
MIME-Version: 1.0
In-Reply-To: <VI1PR08MB0862F346E3B20945F73133CE920F0@VI1PR08MB0862.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 08/31/2018 04:54 PM, Alberto Bursi wrote:
> On 8/31/2018 8:53 AM, Pierre Couderc wrote:
>> OK, I have understood the message... I was planning that as you said
>> "semi-routinely", and I understand btrfs is not soon enough ready, and
>> I am very very far to be a specialist as you are.
>> So, I shall mount my RAID1 very standard, and I  shall expect the
>> disaster, hoping it does not occur....
>> Now, I shall try to absorb all that...
>>
>> Thank you very much !
>>
> I just keep around a USB drive with a full Linux system on it, to act as
> "recovery". If the btrfs raid fails I boot into that and I can do
> maintenance with a full graphical interface and internet access so I can
> google things.
>
> Of course on a home server you can't do that without some automation
> that will switch boot device after some amount of boot failures of the
> main OS.
>
> While if your server has BMC (lights-out management) you can switch boot
> device through that.
>
> -Alberto
Thank you Alberto, yes,I have some other computers to react in case of 
failure.
