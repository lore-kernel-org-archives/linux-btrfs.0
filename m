Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:40073 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3EILvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 07:51:33 -0400
Received: by mail-da0-f52.google.com with SMTP id o9so290110dan.25
        for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 04:51:32 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: syslog message repeated 3x
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <BF628B33-2657-4A04-B9D6-18BA462F819D@gmail.com>
Date: Thu, 9 May 2013 19:51:15 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <2E037A1E-86CE-4472-9A03-88BD16379D5D@gmail.com>
References: <518B6BC1.8020504@gmx.de> <BF628B33-2657-4A04-B9D6-18BA462F819D@gmail.com>
To: =?utf-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh, My kernel version is btrfs-next.

This message gets from kernel..so you can try this url:
git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git


> Hi,
> 
> I just try your steps, but only 1x log message.
> 
> Anyway, i use the latest btrfs-progs.
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> 
> 
> Can you try this and see if it happens again?
> 
> 
> Thanks,
> Wang
>> I'm just curious why the last of the following 3 commands :
>> 
>> $> dd if=/dev/zero of=/mnt/ramdisk/disk1 bs=1M count=257
>> $> yes | /sbin/mkfs.btrfs /mnt/ramdisk/disk1
>> $> mount -o loop /mnt/ramdisk/disk1 /mnt/t
>> 
>> gives 3x the same log message :
>> 
>> 2013-05-09T11:23:00.230+02:00 n22 kernel: device fsid 5b4be7c4-e662-459a-a2a7-066e9384c901 devid 1 transid 4 /dev/loop1
>> 2013-05-09T11:23:00.581+02:00 n22 kernel: device fsid 5b4be7c4-e662-459a-a2a7-066e9384c901 devid 1 transid 4 /dev/loop1
>> 2013-05-09T11:23:00.583+02:00 n22 kernel: device fsid 5b4be7c4-e662-459a-a2a7-066e9384c901 devid 1 transid 4 /dev/loop1
>> 
>> -- 
>> MfG/Sincerely
>> Toralf Förster
>> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

