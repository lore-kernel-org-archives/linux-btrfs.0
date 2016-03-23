Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:34902 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcCWXIk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 19:08:40 -0400
Received: by mail-io0-f178.google.com with SMTP id v187so39078457ioe.2
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 16:08:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGGqMYRRprO_x51A5ZX4ABKcS6_LyTWgf=meZE+aAX990kAJEw@mail.gmail.com>
References: <CAO5K3OeqQUx18gjHNVcOK8=Zo=JLOJhHBJz4jdti73DGakeAfQ@mail.gmail.com>
	<CAGGqMYRRprO_x51A5ZX4ABKcS6_LyTWgf=meZE+aAX990kAJEw@mail.gmail.com>
Date: Wed, 23 Mar 2016 23:08:39 +0000
Message-ID: <CAO5K3Oc_B6X90CEqx1QtT2LseBhf2mGmBbtZSw0aYyKdM4mG-Q@mail.gmail.com>
Subject: Re: btrfs ways to travel back in time
From: Vytautas D <vytdau@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> atime). Also, this might break some configurations not expecting the
> set-default method

I have never seen this before. Can you extend on this or provide a
link so i can read more about such limitation?
>
> >  2. reboot
> > b) always mount into snapshot
> >  1. mount -o suvol=/.current $disk # at initrd
> >  2. btrfs subvol del /.current
> >  3. btrfs subvol snapshot /.snapshotA /.current
> >  4. reboot
> > c) rsync
> >  1. rsync $options /.snapshotA /.current
> >  2. reboot
>
> Depending on how broken the setup is, I'd probably go for the btrfs
> sub snap ./__snapshots/@oldsnap ./@current approach.
Is there a technical reason behind this ?

> If it is very broken (as in not bootable), then a temporary boot into
> a readonly snapshot might be required. This is quite easy to do in
> the grub menu, changing the boot parameter. I've also heard of
> symlinking to the actual subvolume you want to use, and resymlink it
> when an older snapshot is desired.

Just to make it clear, i don't have broken system and have full
control. I am interested in strategies and reasoning.
