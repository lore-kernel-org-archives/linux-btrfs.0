Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44966 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2KCEkx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2012 00:40:53 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2101915eek.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 21:40:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACCfv7rQ4Gqiaf8r7XRMDQnXe_xT0-eJPoLCFTFneWOYwkuaEQ@mail.gmail.com>
References: <CACCfv7pVYHCb_rO-ZefogCrvvvO0C3PN2BOArk4O2sRScWWTxg@mail.gmail.com>
	<CAE5mzvj38wxYWgcV+77hB-YmCS7ZKH_4sigf3ybcyMY9NB==zg@mail.gmail.com>
	<CACCfv7rQ4Gqiaf8r7XRMDQnXe_xT0-eJPoLCFTFneWOYwkuaEQ@mail.gmail.com>
Date: Sat, 3 Nov 2012 15:10:52 +1030
Message-ID: <CACCfv7o-=NEYAWu=Q2CTZYuk2ii6kmYoNuA94XxdMPrf3Sg_Kg@mail.gmail.com>
Subject: Re: What's the minimum size I can shrink my FS to?
From: Jordan Windsor <jordanw2@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
here's the new output:

[root@archpc ~]# btrfs bal start -musage=1 -dusage=1 /home/jordan/Storage/
Done, had to relocate 3 out of 609 chunks

[root@archpc ~]# btrfs fi df /home/jordan/Storage/
Data: total=580.88GB, used=490.88GB
System, DUP: total=32.00MB, used=76.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=13.01GB, used=1001.83MB

[root@archpc ~]# btrfs fi sh
failed to read /dev/sr0
Label: 'Storage'  uuid: 717d4a43-38b3-495f-841b-d223068584de
Total devices 1 FS bytes used 491.86GB
devid    1 size 612.04GB used 606.96GB path /dev/sda6

Btrfs Btrfs v0.19

[root@archpc ~]# btrfs file res 500g /home/jordan/Storage/
Resize '/home/jordan/Storage/' of '500g'
ERROR: unable to resize '/home/jordan/Storage/' - No space left on device

Thanks.

(Had to resend forgot to CC the mailing list, sorry)

On Sat, Nov 3, 2012 at 3:09 PM, Jordan Windsor <jordanw2@gmail.com> wrote:
> Hello,
> here's the new output:
>
> [root@archpc ~]# btrfs bal start -musage=1 -dusage=1 /home/jordan/Storage/
> Done, had to relocate 3 out of 609 chunks
>
> [root@archpc ~]# btrfs fi df /home/jordan/Storage/
> Data: total=580.88GB, used=490.88GB
> System, DUP: total=32.00MB, used=76.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=13.01GB, used=1001.83MB
>
> [root@archpc ~]# btrfs fi sh
> failed to read /dev/sr0
> Label: 'Storage'  uuid: 717d4a43-38b3-495f-841b-d223068584de
> Total devices 1 FS bytes used 491.86GB
> devid    1 size 612.04GB used 606.96GB path /dev/sda6
>
> Btrfs Btrfs v0.19
>
> [root@archpc ~]# btrfs file res 500g /home/jordan/Storage/
> Resize '/home/jordan/Storage/' of '500g'
> ERROR: unable to resize '/home/jordan/Storage/' - No space left on device
>
> Thanks.
>
> On Sat, Nov 3, 2012 at 2:43 PM, cwillu <cwillu@cwillu.com> wrote:
>> Run "btrfs balance start -musage=1 -dusage=1", and then try it again.
>> This may require update btrfs tools however.
>>
>> On Fri, Nov 2, 2012 at 10:09 PM, Jordan Windsor <jordanw2@gmail.com> wrote:
>>> Hello,
>>> I'm trying to shrink my Btrfs filesystem to the smallest size it can
>>> go, here's the information:
>>>
>>> failed to read /dev/sr0
>>> Label: 'Storage'  uuid: 717d4a43-38b3-495f-841b-d223068584de
>>> Total devices 1 FS bytes used 491.86GB
>>> devid    1 size 612.04GB used 605.98GB path /dev/sda6
>>>
>>> Btrfs Btrfs v0.19
>>>
>>> Data: total=580.90GB, used=490.88GB
>>> System, DUP: total=32.00MB, used=76.00KB
>>> System: total=4.00MB, used=0.00
>>> Metadata, DUP: total=12.51GB, used=1001.61MB
>>>
>>> Here's the command I use to resize:
>>>
>>> [root@archpc ~]# btrfs file res 500g /home/jordan/Storage/
>>> Resize '/home/jordan/Storage/' of '500g'
>>> ERROR: unable to resize '/home/jordan/Storage/' - No space left on device
>>>
>>> I was wondering if that size doesn't work then what's the minimum I
>>> can shrink to?
>>>
>>> Thanks.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
