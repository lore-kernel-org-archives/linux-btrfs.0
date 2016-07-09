Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35271 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbcGIMpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jul 2016 08:45:35 -0400
Received: by mail-oi0-f45.google.com with SMTP id r2so93110486oih.2
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jul 2016 05:45:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57808BF6.6030204@gmail.com>
References: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
 <CAPmG0jZZ7FB0teBGGHojPoGctRyVC3D2cS56q1kYDMFrC=fOnA@mail.gmail.com>
 <CAJCQCtQt2A7w4JNUuhU7YOHTyj_z8M_RqsZCDw0G2YEENXaBvg@mail.gmail.com>
 <0e0dcbb3-73a4-0c5f-9978-67109d505b79@freenet.de> <CAJCQCtSd9NTffBJUFwT2ja6PahdCqa=Sm5joP3aptD4OmVoW7w@mail.gmail.com>
 <CAJCQCtRMjGjcqPq08urpuRk-y4JvUO+LCuVqtsk1O5rxP68JEA@mail.gmail.com> <57808BF6.6030204@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 9 Jul 2016 06:45:33 -0600
Message-ID: <CAJCQCtTe7Du5eVadBBFf3puuyE6Cb=pTCOCH9UxaF+HSdF8m=w@mail.gmail.com>
Subject: Re: rollback to a snapshot and delete old top volume - missing of "@"
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Kai Herlemann <nesadaw@freenet.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 8, 2016 at 11:30 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 09.07.2016 00:50, Chris Murphy пишет:
>>>
>>> Instead those utilities should employ rootflags=subvol or subvolid to
>>> explicitly use a particular fs tree for rootfs, rather that hide this
>>> fact by using subvolume set-default.
>>
>> The only distro installer I know that works this way out of the box is
>> Fedora/Red Hat's Anaconda. It leaves the default subvolume as 5, but
>> does not install the OS there. Instead each mountpoint is created as a
>> subvolume in that top level, and rootflags kernel parameter and fstab
>> are used to assemble those subvolumes per the FHS virtually. It's
>> completely discoverable, you can follow each step along the way, it's
>> not obscured.
>>
>> The additional benefit is no nested subvolumes.
>>
>
> Does it use grub2? Where /boot/grub is located - on one of those
> snapshots or on partition outside of btrfs control?

GRUB yes. The installer only permits /boot on ext4 due an ancient
grubby (not GRUB) bug [1]. It's not dissimilar to openSUSE where /boot
is on ext4, and Btrfs ends up on encrypted LVM, if you choose to
encrypt. It's rather head shaking but that's the state of affairs.

> Does it support booting from previous read-only snapshot directly and/or
> rollback to previous snapshot?

Not by default. Snapper is in the repos.

It looks like the future of rollbacks on Fedora is to not do snapshots
at all, but to deploy binaries using rpm-ostree which provides atomic
OS updates on any file system. The update is only ever applied to a
new tree, not the currently active tree, so if the update fails that
new tree is just deleted, it's never even attempted for reboot. Some
of the directories, most notably /usr, are always read-only. Basically
this is a kind of stateless and therefore resettable machine. As far
as I know there are no optimizations for Btrfs, where either snapshots
or reflinks could be employed instead of depending on hardlinks.


-- 
Chris Murphy
