Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:36561 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3BMGSm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 01:18:42 -0500
Date: Wed, 13 Feb 2013 07:18:35 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: Chris Murphy <lists@colorremedies.com>
cc: linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
In-Reply-To: <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com>
Message-ID: <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 12 Feb 2013, Chris Murphy wrote:
>
> On Feb 12, 2013, at 4:01 PM, Fredrik Tolf <fredrik@dolda2000.com> wrote:
>>
>> mkfs.btrfs -d raid -m raid1 /dev/sd{d,e}1
>
> Is that a typo? -d raid isn't valid.

Ah yes, sorry. That was a typo.

> What do you get for:
> btrfs fi df /mnt

$ sudo ./btrfs fi df /mnt
Data, RAID1: total=2.66TB, used=2.66TB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=388.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=4.00GB, used=3.66GB
Metadata: total=8.00MB, used=0.00

> Please report the result for each drive:
> smartctl -a /dev/sdX

As they're a bit long for mail, so see here:
<http://www.dolda2000.com/~fredrik/tmp/smart-hde>
<http://www.dolda2000.com/~fredrik/tmp/smart-hdi>

There's not a whole lot to see, though.

> smartctl -l scterc /dev/sdX

"Warning: device does not support SCT Error Recovery Control command"

>> Also, why does it say that the errors are occuring /dev/sdd1? Is it just remembering the whole filesystem by that name since that's how I mounted it, or is it still trying to access the old removed instance of that disk and is that, then, why it's giving all these errors?
>
> I suspect bad sectors at the moment.

Doesn't seem that way to me; partly because of the SMART data, and partly 
because of the errors that were logged as the drive failed:

Feb 12 16:36:49 nerv kernel: [36769.546522] ata6.00: Ata error. fis:0x21
Feb 12 16:36:49 nerv kernel: [36769.550454] ata6: SError: { Handshk }
Feb 12 16:36:51 nerv kernel: [36769.554129] ata6.00: failed command: WRITE FPDMA QUEUED
Feb 12 16:36:51 nerv kernel: [36769.559375] ata6.00: cmd 61/00:00:00:ec:2e/04:00:cd:00:00/40 tag 0 ncq 524288 out
Feb 12 16:36:51 nerv kernel: [36769.559375]          res 41/84:d0:00:98:2e/84:00:cd:00:00/40 Emask 0x10 (ATA bus error)
Feb 12 16:36:51 nerv kernel: [36769.574831] ata6.00: status: { DRDY ERR }
Feb 12 16:36:52 nerv kernel: [36769.578867] ata6.00: error: { ICRC ABRT }

That's not typical for actual media problems, in my experience. :)

What kernel version?

Oh, sorry, it's 3.7.1. The system is otherwise a pretty much vanilla 
Debian Squeeze (curreny Stable) that I've just compiled a newer kernel 
(and btrfs-tools) for.

Thanks for replying!

--

Fredrik Tolf
