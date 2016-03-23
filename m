Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:32865 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbcCWR7M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 13:59:12 -0400
Received: by mail-lb0-f170.google.com with SMTP id oe12so15529707lbc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 10:59:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAO5K3OeqQUx18gjHNVcOK8=Zo=JLOJhHBJz4jdti73DGakeAfQ@mail.gmail.com>
References: <CAO5K3OeqQUx18gjHNVcOK8=Zo=JLOJhHBJz4jdti73DGakeAfQ@mail.gmail.com>
Date: Wed, 23 Mar 2016 18:59:11 +0100
Message-ID: <CAGGqMYRRprO_x51A5ZX4ABKcS6_LyTWgf=meZE+aAX990kAJEw@mail.gmail.com>
Subject: Re: btrfs ways to travel back in time
From: Alexander Fougner <fougner89@gmail.com>
To: Vytautas D <vytdau@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-03-23 18:41 GMT+01:00 Vytautas D <vytdau@gmail.com>:
> I can think of few ways to revert changes with btrfs, but I wonder
> what are the trade-offs between each method and perhaps there is
> already research done on this?
>
> ways to restore a snapshot ( post kernel 3.* ):
> a) via set-default
>  1. btrfs subvolume set-default / $id

Usually snapshots are readonly because we want the ability to use
btrfs send/receive and not mistakenly change anything on them (such as
atime). Also, this might break some configurations not expecting the
set-default method.

>  2. reboot
> b) always mount into snapshot
>  1. mount -o suvol=/.current $disk # at initrd
>  2. btrfs subvol del /.current
>  3. btrfs subvol snapshot /.snapshotA /.current
>  4. reboot
> c) rsync
>  1. rsync $options /.snapshotA /.current
>  2. reboot

Depending on how broken the setup is, I'd probably go for the btrfs
sub snap ./__snapshots/@oldsnap ./@current approach.
If it is very broken (as in not bootable), then a temporary boot into
a readonly snapshot might be required. This is quite easy to do in
the grub menu, changing the boot parameter. I've also heard of
symlinking to the actual subvolume you want to use, and resymlink it
when an older snapshot is desired.

>
> - Vytas Dauksa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
