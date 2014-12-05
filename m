Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:64698 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLEQti (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Dec 2014 11:49:38 -0500
Received: by mail-yk0-f169.google.com with SMTP id 79so484509ykr.0
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Dec 2014 08:49:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3146bf116f41e590e8ce4fdb610def31@admin.virtall.com>
References: <3146bf116f41e590e8ce4fdb610def31@admin.virtall.com>
Date: Fri, 5 Dec 2014 09:49:37 -0700
Message-ID: <CAJCQCtRNt=4HpUP6XL4sjBZKQAB95xKOojh+QQp2AwpmwKttTg@mail.gmail.com>
Subject: Re: btrfs device delete missing - Input/output error
From: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 5, 2014 at 3:03 AM, Tomasz Chmielewski <tch@virtall.com> wrote:
>> The first way to try to recover the current volume would be to
>> overwrite LBA 2262535088 which you should only do with the filesystem
>> unmounted. That's the sector causing the read error. If this is a 512
>> byte drive:
>>
>> dd if=/dev/zero of=/dev/sdb count=1 seek=2262535088
>
>
> It is a 512 byte drive.
>
> Unfortunately overwriting that fails - which is quite weird, given that
> there are 0 reallocated sectors, according to SMART.
>
> Is there a way to determine what's stored there (i.e. if it's a file?).
>
>
> # dd if=/dev/zero of=/dev/sdb count=1 seek=2262535088
> dd: writing to `/dev/sdb': Input/output error
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 2.88439 s, 0.0 kB/s
>
> # dmesg -c
> [ 8177.713212] ata4.00: exception Emask 0x0 SAct 0x400 SErr 0x0 action 0x0
> [ 8177.713285] ata4.00: irq_stat 0x40000008
> [ 8177.713349] ata4.00: failed command: READ FPDMA QUEUED



You're getting a read error when writing. This is expected when writing 512
bytes to a 4k sector.

What do you get for
parted /dev/sdb u s p



-- 
Chris Murphy
