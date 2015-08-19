Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:57726 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbbHSRiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 13:38:03 -0400
Message-ID: <55D4BEF2.4040107@friedels.name>
Date: Wed, 19 Aug 2015 19:37:54 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: understanding btrfs fi df
References: <55D09F50.5070900@friedels.name> <20150816145719.GU12976@carfax.org.uk> <55D4AA5E.60306@friedels.name> <20150819161703.GZ12976@carfax.org.uk>
In-Reply-To: <20150819161703.GZ12976@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

thanks for your help.

 >> Now the output is:
>> root@homeserver:/media# btrfs fi df /mnt/__Complete_Disk
>>
>> Data, RAID5: total=3.79TiB, used=3.78TiB
>> System, RAID5: total=32.00MiB, used=416.00KiB
>> Metadata, RAID5: total=6.46GiB, used=4.85GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> root@homeserver:/media# btrfs fi show
>> Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
>>          Total devices 3 FS bytes used 3.79TiB
>>          devid    1 size 2.73TiB used 2.43TiB path /dev/sdf
>>          devid    2 size 2.73TiB used 2.43TiB path /dev/sdd
>>          devid    3 size 2.73TiB used 1.38TiB path /dev/sde
>>
>> How can only 1.38TiB be used on devid 3?
>
>     It shouldn't happen, as I understand how the process works. Can you
> show the output of "btrfs fi df /mnt/__Complete_Disk"? Let's just
> check that everything is indeed RAID-5 still.

Here we go:

btrfs fi df /mnt/__Complete_Disk

Data, RAID5: total=3.79TiB, used=3.78TiB
System, RAID5: total=32.00MiB, used=416.00KiB
Metadata, RAID5: total=6.46GiB, used=4.85GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


Greetings,
Hendrik

Greetings,
Hendrik


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Tel. 04203 8394854
Mobil 0178 1874363

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

