Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:32918 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdCBEHd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Mar 2017 23:07:33 -0500
Received: by mail-qk0-f178.google.com with SMTP id n127so105214242qkf.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Mar 2017 20:06:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSY2xqsM28bWh6xhGZbnj2d0tQ3mZkgYx--7DqM4+xhSQ@mail.gmail.com>
References: <CAGqmi76oFUFtD1TDjns_BFujkRc8fHSpL6Wt5yYt3SX0QPf+5A@mail.gmail.com>
 <20170301203800.4f9cbfa0@jupiter.sol.kaishome.de> <CAJCQCtSY2xqsM28bWh6xhGZbnj2d0tQ3mZkgYx--7DqM4+xhSQ@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 2 Mar 2017 05:30:16 +0300
Message-ID: <CAGqmi74RECZJnkgk+0E6kHD7YCV_AKK455EKq=TVeqWt+tLZ2A@mail.gmail.com>
Subject: Re: Please add more info to dmesg output on I/O error
To: Chris Murphy <lists@colorremedies.com>
Cc: Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-03-02 3:40 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
> On Wed, Mar 1, 2017 at 12:38 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
>> Am Wed, 1 Mar 2017 19:04:26 +0300
>> schrieb Timofey Titovets <nefelim4ag@gmail.com>:
>>
>>> Hi, today i try move my FS from old HDD to new SSD
>>> While processing i catch I/O error and device remove operation was
>>> canceled
>>>
>>> Dmesg:
>>> [ 1015.010241] blk_update_request: I/O error, dev sda, sector 81353664
>>> [ 1015.010246] BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0,
>>> rd 23, flush 0, corrupt 0, gen 0
>>> [ 1015.010282] ata5: EH complete
>>> [ 1017.016721] ata5.00: exception Emask 0x0 SAct 0x10000 SErr 0x0
>>> action 0x0 [ 1017.016730] ata5.00: irq_stat 0x40000008
>>> [ 1017.016737] ata5.00: failed command: READ FPDMA QUEUED
>>> [ 1017.016748] ata5.00: cmd 60/08:80:c0:5b:d9/00:00:04:00:00/40 tag 16
>>> ncq dma 4096 in
>>>                        res 41/40:00:c0:5b:d9/00:00:04:00:00/40 Emask
>>> 0x409 (media error) <F>
>>> [ 1017.016754] ata5.00: status: { DRDY ERR }
>>> [ 1017.016757] ata5.00: error: { UNC }
>>> [ 1017.029479] ata5.00: configured for UDMA/133
>>> [ 1017.029506] sd 4:0:0:0: [sda] tag#16 UNKNOWN(0x2003) Result:
>>> hostbyte=0x00 driverbyte=0x08
>>> [ 1017.029511] sd 4:0:0:0: [sda] tag#16 Sense Key : 0x3 [current]
>>> [ 1017.029516] sd 4:0:0:0: [sda] tag#16 ASC=0x11 ASCQ=0x4
>>> [ 1017.029520] sd 4:0:0:0: [sda] tag#16 CDB: opcode=0x28 28 00 04 d9
>>> 5b c0 00 00 08 00
>>>
>>> At now, i fixed this problem by doing scrub FS and delete damaged
>>> files, but scrub are slow, and if btrfs show me a more info on I/O
>>> error, it's will be more helpful
>>> i.e. something like i getting by scrub:
>>> [ 1260.559180] BTRFS warning (device sdb1): i/o error at logical
>>> 40569896960 on dev /dev/sda1, sector 81351616, root 309, inode 55135,
>>> offset 71278592, length 4096, links 1 (path:
>>> nefelim4ag/.config/skypeforlinux/Cache/data_3)
>>>
>>> Thanks.
>>
>> You should turn off SCT ERC with smartctl or set it to lower values,
>
> Unlikely. The OP suggests single HDD to single SSD. Only if there is
> redundancy is it appropriate to set SCT ERC to a low value like 70
> deciseconds.
>
> If it's a single drive, the thing to do is disable SCT ERC in the case
> it's enabled (?) which might be what's going on, so that there's a
> longer recovery time and maybe the drive figures out the problem and
> recovers the data.
>
> smartctl -l scterc /dev/sdX
>
> That should report back the SCT ERC status. Don't change it until we
> know the configuration.
>
>
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


JFYI:
Data: single
Metadata: dup
It's just a notebook with 2.5 hdd

Guys, thanks, but i don't need a help with solving problem, i already
solved the problem by finding and remove damaged data from FS.
I only say that:
  first message generated after:
  # btrfs device remove /dev/sdXn <path>
  BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 23, flush
0, corrupt 0, gen 0
  It's only notify me that i have a problem with read, but did not say
me "where"

  second message generated after:
  # btrfs scrub start /dev/sdXn
  it's more useful:
  BTRFS warning (device sdb1): i/o error at logical 40569896960 on dev
/dev/sda1, sector 81351616, root 309, inode 55135, offset 71278592,
length 4096, links 1 (path:
nefelim4ag/.config/skypeforlinux/Cache/data_3)

i already understand after first message that i have a bad sectors on
HDD and smart also say me that.
i just want replace a drive, and i understood btrfs behaviour, btrfs
just try keep data save and abort device delete operation on I/O
error.
But btrfs, your are smart enough, please give me more info on error,
what stored on corrupted sector?

  if btrfs show this message early (i.e. after increasing error
counter), then it could save my time (~1,5h while i trying understand
what happen and doing full FS Scrub)

Thanks.

-- 
Have a nice day,
Timofey.
