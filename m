Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:60702 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbbHUWpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 18:45:47 -0400
Message-ID: <55D7AA0E.1060506@friedels.name>
Date: Sat, 22 Aug 2015 00:45:34 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: understanding btrfs fi df
References: <55D09F50.5070900@friedels.name> <20150816145719.GU12976@carfax.org.uk> <55D4AA5E.60306@friedels.name> <20150819161703.GZ12976@carfax.org.uk> <55D4BEF2.4040107@friedels.name>
In-Reply-To: <55D4BEF2.4040107@friedels.name>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Hugo,

>>     It shouldn't happen, as I understand how the process works. Can you
>> show the output of "btrfs fi df /mnt/__Complete_Disk"? Let's just
>> check that everything is indeed RAID-5 still.
>
> Here we go:
>
> btrfs fi df /mnt/__Complete_Disk
>
> Data, RAID5: total=3.79TiB, used=3.78TiB
> System, RAID5: total=32.00MiB, used=416.00KiB
> Metadata, RAID5: total=6.46GiB, used=4.85GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

can you help me on this? As far as I see, it's all Raid5.
So,
 >>   After this, we're probably going to have to look at the device and
 >> chunk trees to work out what's going on.

Can you help me on this?

Regards,
Hendrik






---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

