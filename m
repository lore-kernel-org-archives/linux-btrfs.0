Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35436 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbcBBWEl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 17:04:41 -0500
Received: by mail-io0-f173.google.com with SMTP id d63so34125755ioj.2
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Feb 2016 14:04:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B126DD.90009@friedels.name>
References: <56AFCEC3.9050803@friedels.name>
	<CAJCQCtRox+q5u902iwA3YL2yvEP+9_=02HJzpZU6TWZ1R9V+Qg@mail.gmail.com>
	<56B126DD.90009@friedels.name>
Date: Tue, 2 Feb 2016 15:04:40 -0700
Message-ID: <CAJCQCtT0S6CiErJYUju5D5-q0s-KBXuYkXxMURjppZcgURP4wA@mail.gmail.com>
Subject: Re: booting from BTRFS works only with one device in the pool
From: Chris Murphy <lists@colorremedies.com>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 2, 2016 at 2:59 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello Chris,
>
>> That's a bit weird. This is BIOS or UEFI system? On UEFI, the prebaked
>> grubx64.efi includes btrfs, so insmod isn't strictly needed. But on
>> BIOS it would be.
>
> it is a Virtual-Box-VM. It is a BIOS system
>
>> It might be as simple as manually mounting:
>>btrfs dev scan
>>btrfs fi show
> ## hopefully both devices are now associated with the volume
>> mount /dev/sdXY /sysroot
>> exit
>
> The mount works.
> After entering "exit" I get the feedback "logout" and the system hangs.
>
>> If it mounts, you can exit to continue the startup process. And then:
>> dracut -f That'll rebuild the initramfs.
>
> And dracut then somehow understands that btrfs dev scan is needed?
>>>
>>> set root='hd0,msdos1'
>>> search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1
>>> --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 --hint='hd0,msdos1'
>>> 4a470ac6-f013-4e7b-a4f3-3a58cc4debc3
>>>
>>> after removing sda3 from the pool again, the system boots normally.
>>
>> That's unexpected. Both devices should now refer to each other, so
>> either device missing should fail, it's effectively raid0 except on a
>> chunk level.
>>
> That's way beyond my understanding. I am not sure how this entry is
> generated. But it is somehow a default behavior, as it seems (I have not
> done this)

This is CentOS 7.2 installed to a single VDI file, and then you use
'btrfs dev add' to add another VDI file? I'd like to know how to
reproduce the conditions so I can figure out what's wrong because it
ought to work, seeing as it worked for me with Fedora 19 and CentOS
7.x is in the vicinity of Fedora 19/20.

What do you get for
rpm -q grub2

-- 
Chris Murphy
