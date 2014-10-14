Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58188 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaJNULF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 16:11:05 -0400
Received: by mail-wi0-f176.google.com with SMTP id hi2so11182118wib.3
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Oct 2014 13:11:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3E469DA1-1744-4AFC-9C56-04AE2CB6BA4F@colorremedies.com>
References: <CAPF83msBVh_EqHAFxzmicnQjZKe7k4ioNEd8q3vwTxLNDx5prA@mail.gmail.com>
	<543B372F.10509@oracle.com>
	<CAPF83mufgJvTKscpAS_SwFdSrA+1dK3T89A2UiuSHArr5wDn8A@mail.gmail.com>
	<543C86C3.7040804@oracle.com>
	<CAPF83mtWrTRyfT34nNm7yjLDq+6uRegNJStkDK6+n_7fpmRTDQ@mail.gmail.com>
	<3E469DA1-1744-4AFC-9C56-04AE2CB6BA4F@colorremedies.com>
Date: Tue, 14 Oct 2014 13:11:03 -0700
Message-ID: <CAPF83msoJtpRRmMEeaLHQf=e6JyoTgR9TP3p_Q5XAZCLahh-yw@mail.gmail.com>
Subject: Re: what is the best way to monitor raid1 drive failures?
From: Suman C <schakrava@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After the reboot step, where I indicated that I mounted ro, I was
unable to mount rw or rw,degraded. I get the "mount: wrong fs type,
bad option, bad superblock...." error if I try to mount it rw.

What might be the reason for that?

Suman

On Tue, Oct 14, 2014 at 12:15 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Oct 14, 2014, at 10:48 AM, Suman C <schakrava@gmail.com> wrote:
>>
>> mounted the filesystem with ro,degraded
>>
>> tried adding the "new" sdb drive which results in the following error.
>> (-f because the new drive has a fs from past)
>>
>> # btrfs device add -f /dev/sdb /mnt2/raid1pool
>> /dev/sdb is mounted
>>
>> Unless I am missing something, this looks like a bug.
>
> Strange message. I expect a device can't be added to a volume mounted ro. If the device add command works on a volume mounted rw, then the bug is the message '/dev/sdb is mounted' when adding device to ro mounted volume.
>
>
> Chris Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
