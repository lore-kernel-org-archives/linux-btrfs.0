Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34425 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbcGIFad (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jul 2016 01:30:33 -0400
Received: by mail-lf0-f68.google.com with SMTP id a10so7025121lfb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 22:30:32 -0700 (PDT)
Subject: Re: rollback to a snapshot and delete old top volume - missing of "@"
To: Chris Murphy <lists@colorremedies.com>
References: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
 <CAPmG0jZZ7FB0teBGGHojPoGctRyVC3D2cS56q1kYDMFrC=fOnA@mail.gmail.com>
 <CAJCQCtQt2A7w4JNUuhU7YOHTyj_z8M_RqsZCDw0G2YEENXaBvg@mail.gmail.com>
 <0e0dcbb3-73a4-0c5f-9978-67109d505b79@freenet.de>
 <CAJCQCtSd9NTffBJUFwT2ja6PahdCqa=Sm5joP3aptD4OmVoW7w@mail.gmail.com>
 <CAJCQCtRMjGjcqPq08urpuRk-y4JvUO+LCuVqtsk1O5rxP68JEA@mail.gmail.com>
Cc: Kai Herlemann <nesadaw@freenet.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <57808BF6.6030204@gmail.com>
Date: Sat, 9 Jul 2016 08:30:30 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRMjGjcqPq08urpuRk-y4JvUO+LCuVqtsk1O5rxP68JEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

09.07.2016 00:50, Chris Murphy пишет:
>>
>> Instead those utilities should employ rootflags=subvol or subvolid to
>> explicitly use a particular fs tree for rootfs, rather that hide this
>> fact by using subvolume set-default.
> 
> The only distro installer I know that works this way out of the box is
> Fedora/Red Hat's Anaconda. It leaves the default subvolume as 5, but
> does not install the OS there. Instead each mountpoint is created as a
> subvolume in that top level, and rootflags kernel parameter and fstab
> are used to assemble those subvolumes per the FHS virtually. It's
> completely discoverable, you can follow each step along the way, it's
> not obscured.
> 
> The additional benefit is no nested subvolumes.
> 

Does it use grub2? Where /boot/grub is located - on one of those
snapshots or on partition outside of btrfs control?

Does it support booting from previous read-only snapshot directly and/or
rollback to previous snapshot?
