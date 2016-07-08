Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:33587 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbcGHXVS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 19:21:18 -0400
Received: by mail-vk0-f41.google.com with SMTP id b192so73613600vke.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 16:21:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRMjGjcqPq08urpuRk-y4JvUO+LCuVqtsk1O5rxP68JEA@mail.gmail.com>
References: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
 <CAPmG0jZZ7FB0teBGGHojPoGctRyVC3D2cS56q1kYDMFrC=fOnA@mail.gmail.com>
 <CAJCQCtQt2A7w4JNUuhU7YOHTyj_z8M_RqsZCDw0G2YEENXaBvg@mail.gmail.com>
 <0e0dcbb3-73a4-0c5f-9978-67109d505b79@freenet.de> <CAJCQCtSd9NTffBJUFwT2ja6PahdCqa=Sm5joP3aptD4OmVoW7w@mail.gmail.com>
 <CAJCQCtRMjGjcqPq08urpuRk-y4JvUO+LCuVqtsk1O5rxP68JEA@mail.gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Sat, 9 Jul 2016 01:21:16 +0200
Message-ID: <CAPmG0jZetVR9039Fe=z6T8gT3iYUEoGrUrgo7RoAJRWNT3XLHw@mail.gmail.com>
Subject: Re: rollback to a snapshot and delete old top volume - missing of "@"
To: Chris Murphy <lists@colorremedies.com>
Cc: Kai Herlemann <nesadaw@freenet.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 8, 2016 at 11:50 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Fri, Jul 8, 2016 at 3:39 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Fri, Jul 8, 2016 at 2:08 PM, Kai Herlemann <nesadaw@freenet.de> wrote:
>>
>>> If here any developers read along: I'd like to suggest that there's
>>> automatically made a subvolume "@" by default, which is set as default
>>> subvolume, or a tip to the distribution, that it would made sense to do that
>>> with the installation. It would protect other users against confusion and
>>> work like I had it.
>>
>> I think that upstream won't do that or recommend it. There is already
>> a subvolume created at mkfs time, that's subvolid=5 (a.k.a. 0) and it
>> is set as the default subvolume. I don't see the point in having two
>> of them. If you want it, make it. If your distro wants it, it should
>> be done in the installer, not mkfs.
>>
>> Further I think it's inappropriate to take 'btrfs sub set-default'
>> away from the user. That is a user owned setting. It is not OK for
>> some utility to assert domain over that setting, and depend on it for
>> proper booting. It makes the entire boot process undiscoverable,
>> breaks self-describing boot process which are simpler to understand
>> and troubleshoot, in favor of secret decoder ring booting that now
>> requires even more esoteric knowledge on the part of users. So I think
>> it's a bad design.
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
> A possible improvement for those distros that will likely continue
> doing things the way they are, would be if the kernel code stated what
> fs tree ID was being mounted when the default subvolume is not 5, and
> neither subvol nor subvolid mount options were used. *shrug*

On a running system as non-root:
$ mount | grep "on / type btrfs"
/dev/sda1 on / type btrfs
(rw,noatime,compress=lzo,ssd,discard,space_cache,subvolid=2429,subvol=/@/latestrootfs)

On an image of a disk or some separate disk with rootfs tree mounted
somewhere, I agree that it might look 'hidden'; you will have to
realize that the filesystem is Btrfs and that the default subvol might
not be 5, but  btrfs sub list / gives the answer to what more is in
the pool.
