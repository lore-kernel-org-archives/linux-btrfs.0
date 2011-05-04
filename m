From: Martin Schitter <ms@mur.at>
Subject: Re: btrfs csum failed
Date: Wed, 04 May 2011 13:39:46 +0200
Message-ID: <4DC13B02.9030604@mur.at>
References: <4DC07A10.7070200@mur.at>	<20110504002815.GA27861@dhcp231-156.rdu.redhat.com>	<4DC0A153.3080806@mur.at> <BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am 2011-05-04 04:18, schrieb Fajar A. Nugraha:
>> could you give me some advice how to debug/report this specific
>> problem more
>>> precise?
> If it's not reproducible then I'd suspect it'd be hard to do.

the last working snapshot is from 2011-05-02-17:13. i can reproduce this 
file system corruption on one specific file in any hourly snapshot later.

whenever i make a simple:

   cat snapshot-2011-05-02-18:13/sata-images/image_xy.raw > /dev/null

i get an "Input/output error" and the quoted debug messages in dmesg and
kernel-log

could this be seen as an useful starting point for further investigations?

> Usually checksum errors is early sign of hardware failure (most
> common are disk or power supply).

that looks very unplausible to me. there is an RAID1 layer beneath btrfs 
in our setup and i don't see any errors there.

and the 'nodatasum' option should also ignore csum issues.-- isn't it?

martin
