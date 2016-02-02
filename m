Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay05.ispgateway.de ([80.67.31.97]:35607 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbcBBWAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 17:00:03 -0500
Subject: Re: booting from BTRFS works only with one device in the pool
To: Chris Murphy <lists@colorremedies.com>
References: <56AFCEC3.9050803@friedels.name>
 <CAJCQCtRox+q5u902iwA3YL2yvEP+9_=02HJzpZU6TWZ1R9V+Qg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hendrik Friedel <hendrik@friedels.name>
Message-ID: <56B126DD.90009@friedels.name>
Date: Tue, 2 Feb 2016 22:59:57 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRox+q5u902iwA3YL2yvEP+9_=02HJzpZU6TWZ1R9V+Qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

> That's a bit weird. This is BIOS or UEFI system? On UEFI, the prebaked
> grubx64.efi includes btrfs, so insmod isn't strictly needed. But on
> BIOS it would be.
it is a Virtual-Box-VM. It is a BIOS system

 > It might be as simple as manually mounting:
 >btrfs dev scan
 >btrfs fi show
## hopefully both devices are now associated with the volume
 > mount /dev/sdXY /sysroot
 > exit

The mount works.
After entering "exit" I get the feedback "logout" and the system hangs.

 > If it mounts, you can exit to continue the startup process. And then: 
dracut -f That'll rebuild the initramfs.

And dracut then somehow understands that btrfs dev scan is needed?
>> set root='hd0,msdos1'
>> search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1
>> --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 --hint='hd0,msdos1'
>> 4a470ac6-f013-4e7b-a4f3-3a58cc4debc3
>>
>> after removing sda3 from the pool again, the system boots normally.
> That's unexpected. Both devices should now refer to each other, so
> either device missing should fail, it's effectively raid0 except on a
> chunk level.
>
That's way beyond my understanding. I am not sure how this entry is 
generated. But it is somehow a default behavior, as it seems (I have not 
done this)

Greetings,
Hendrik

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

