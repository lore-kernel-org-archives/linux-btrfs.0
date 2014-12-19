Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pecan2-mail.exetel.com.au ([220.233.0.71]:33551 "EHLO
	pecan2.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLSAZt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 19:25:49 -0500
From: Paul Jones <paul@pauljones.id.au>
To: Daniele Testa <daniele.testa@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Extra info
Date: Fri, 19 Dec 2014 00:25:42 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64593F41BC08@Server.waterlogic.com.au>
References: <CAN6BF2LwtJkjt1qB6C-wcVxizGj4bufvojR29QX5e7JJ_h-xXA@mail.gmail.com>
	<20141218153544.GB25267@carfax.org.uk>
 <CAN6BF2+32GNsVqRSMvzfWyLDsPPZ1FZz0k5ef+ZL6XLbXnwWjQ@mail.gmail.com>
In-Reply-To: <CAN6BF2+32GNsVqRSMvzfWyLDsPPZ1FZz0k5ef+ZL6XLbXnwWjQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another way to defrag the file is to move the file to another disk and then move it back. I've had trouble with virtual machine disks before (Windows server raw) and this has fixed the problem.

FYI 3.17.2 and beyond seems much better now. No crazy slow downs.

Paul.

-----Original Message-----
From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Daniele Testa
Sent: Friday, 19 December 2014 4:33 AM
To: Hugo Mills; Daniele Testa; linux-btrfs@vger.kernel.org
Subject: Re: Extra info

I am running latest Debian stable. However, I used backports to update the kernel to 3.16.

root@s4 /opt/drives/ssd # uname -a
Linux s4.podnix.com 3.16.0-0.bpo.4-amd64 #1 SMP Debian
3.16.7-ckt2-1~bpo70+1 (2014-12-08) x86_64 GNU/Linux

root@s4 /opt/drives/ssd # btrfs --version Btrfs v3.14.1

It still reports over-use, so I am running a defrag on the file:

root@s4 /opt/drives/ssd # btrfs filesystem defragment /opt/drives/ssd/disk_208.img

But I see it slowly eats even more disk space durring the defrag. I had about 7GB before. When it went down close to 1GB, I cancelled it as I'm afraid it will corrupt the file if it runs out of space.

Do you know how btrfs behaves if it runs out of space durring a defrag? Any other ideas how I can solve it?

Regards,
Daniele


2014-12-18 23:35 GMT+08:00 Hugo Mills <hugo@carfax.org.uk>:
> On Thu, Dec 18, 2014 at 11:02:34PM +0800, Daniele Testa wrote:
>> Sorry, did not read the guidelines correctly. Here comes more info:
>>
>> root@s4 /opt/drives/ssd # uname -a
>> Linux s4.podnix.com 3.2.0-4-amd64 #1 SMP Debian 3.2.46-1+deb7u1 
>> x86_64 GNU/Linux
>
>    This is your problem. I think the difficulty is that writes into 
> the middle of an extent didn't split the extent and allow the 
> overwritten area to be reclaimed, so the whole extent still takes up 
> space.
>
>    IIRC, josef fixed this about 18 months ago. You should upgrade your 
> kernel to something that isn't written in cueniform (like 3.18, say), 
> and defrag the file in question. I think that should fix the problem.
>
>> root@s4 /opt/drives/ssd # btrfs --version Btrfs Btrfs v0.19
>
>    This is also an antique, and probably needs an upgrade too 
> (although it's less critical than the kernel).
>
>    Hugo.
>
>> root@s4 /opt/drives/ssd # btrfs fi show
>> Label: none  uuid: 752ed11b-defc-4717-b4c9-a9e08ad64ba6
>>         Total devices 1 FS bytes used 404.74GB
>>         devid    1 size 410.50GB used 410.50GB path /dev/md3
>>
>> Regards,
>> Daniele
>
> --
> Hugo Mills             | Python is executable pseudocode; perl is executable
> hugo@... carfax.org.uk | line-noise.
> http://carfax.org.uk/  |
> PGP: 65E74AC0          |                                            Ben Burton
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
