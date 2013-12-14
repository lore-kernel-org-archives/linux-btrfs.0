Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f47.google.com ([209.85.212.47]:42220 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab3LNXTW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 18:19:22 -0500
Received: by mail-vb0-f47.google.com with SMTP id q12so2246702vbe.34
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 15:19:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
	<46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
Date: Sun, 15 Dec 2013 00:19:21 +0100
Message-ID: <CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
Subject: Re: Blocket for more than 120 seconds
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looking into triggering the error again and dmesg and sysrq, but here
are the other two:

# btrfs fi show
Label: none  uuid: 9302fc8f-15c6-46e9-9217-951d7423927c
        Total devices 8 FS bytes used 13.00TB
        devid    4 size 3.64TB used 3.48TB path /dev/sdt
        devid    3 size 3.64TB used 3.48TB path /dev/sds
        devid    8 size 3.64TB used 3.48TB path /dev/sdr
        devid    6 size 3.64TB used 3.48TB path /dev/sdp
        devid    7 size 3.64TB used 3.48TB path /dev/sdq
        devid    5 size 3.64TB used 3.48TB path /dev/sdo
        devid    1 size 3.64TB used 3.48TB path /dev/sdl
        devid    2 size 3.64TB used 3.48TB path /dev/sdm

Btrfs v0.20-rc1


# btrfs fi df /storage/storage-vol0/
Data, RAID10: total=13.89TB, used=12.99TB
System, RAID10: total=64.00MB, used=1.19MB
System: total=4.00MB, used=0.00
Metadata, RAID10: total=21.00GB, used=17.59GB

Regards,

Hans-Kristian Bakke


On 14 December 2013 22:35, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Dec 14, 2013, at 1:30 PM, Hans-Kristian Bakke <hkbakke@gmail.com> wrote:
>>
>> During high disk loads, like backups combinded with lot of writers,
>> rsync at high speed locally or btrfs defrag I always get these
>> messages, and everything grinds to a halt on the btrfs filesystem:
>>
>> [ 3123.062229] INFO: task rtorrent:8431 blocked for more than 120 seconds
>> [ 3123.062251]       Not tainted 3.12.4 #1
>
> On blocks, if this is an unknown problem, often devs will want to see dmesg after you've issued dmesg -n7 and sysrq+w. More on sysrq triggering is here:
> https://www.kernel.org/doc/Documentation/sysrq.txt
>
>> The filesystem have used about 26TB of the available 29TB (real
>> available data), and some of the files on it are heavily fragmented
>> (around 100 000 extents at about 25GB)
>
> Please include results from btrfs fi show, and btrfs fi df <mp>.
>
>
> Chris Murphy
