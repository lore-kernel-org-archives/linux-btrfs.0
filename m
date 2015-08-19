Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:62733 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbbHSQKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 12:10:14 -0400
Message-ID: <55D4AA5E.60306@friedels.name>
Date: Wed, 19 Aug 2015 18:10:06 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: understanding btrfs fi df
References: <55D09F50.5070900@friedels.name> <20150816145719.GU12976@carfax.org.uk>
In-Reply-To: <20150816145719.GU12976@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Hugo,

thanks for your hint.

On 16.08.2015 16:57, Hugo Mills wrote:
>     Here's your problem -- you've got a RAID 5 filesystem, which has a
> minimum allocation of 2 devices, but only one device has free space on
> it for allocation, so no more chunks can be allocated. I'm not sure
> how it ended up in this situation, but that's what's happened.
>
> 2) convert a few chunks of the existing FS, on devices 1 and 3, to
> single, which should free up some space across all the devices, and
> then run a full balance, and finally convert the single back to RAID
> 5:
>
> # btrfs balance start -dconvert=single,devid=1,limit=4/mnt/__Complete_Disk
> # btrfs balance start -dconvert=single,devid=3,limit=4/mnt/__Complete_Disk
> # btrfs balance start -dprofiles=raid5/mnt/__Complete_Disk
> # btrfs balance start -dconvert=raid5,soft/mnt/__Complete_Disk


I did that. In order to run the first two commands I had to free some 
space though, which was no problem.

Now the output is:
root@homeserver:/media# btrfs fi df /mnt/__Complete_Disk 

Data, RAID5: total=3.79TiB, used=3.78TiB
System, RAID5: total=32.00MiB, used=416.00KiB
Metadata, RAID5: total=6.46GiB, used=4.85GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

root@homeserver:/media# btrfs fi show
Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
         Total devices 3 FS bytes used 3.79TiB
         devid    1 size 2.73TiB used 2.43TiB path /dev/sdf
         devid    2 size 2.73TiB used 2.43TiB path /dev/sdd
         devid    3 size 2.73TiB used 1.38TiB path /dev/sde

How can only 1.38TiB be used on devid 3?


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

