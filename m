Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37275 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbcDLDnW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 23:43:22 -0400
Received: by mail-ig0-f178.google.com with SMTP id g8so9365197igr.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 20:43:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcrkYK9C41wrXWkw4pgfrpSGgUbZ3amSD1y49_06dPH8oERgw@mail.gmail.com>
References: <CAAcrkYLYu7Gk8_O+vMYp3B2z+yJiktp7AyEc1mONNHtA8kpxUw@mail.gmail.com>
	<CAJCQCtSagDUoA_tf4tTMMYK3K5bCtmHNSRjc=OLgoLYQpXw0cg@mail.gmail.com>
	<CAAcrkYK9C41wrXWkw4pgfrpSGgUbZ3amSD1y49_06dPH8oERgw@mail.gmail.com>
Date: Mon, 11 Apr 2016 21:43:21 -0600
Message-ID: <CAJCQCtRiTcy3OSA60G=N7LMA3xEpjeqmxv+gNyv7E+HyvG68Mg@mail.gmail.com>
Subject: Re: KERNEL PANIC + CORRUPTED BTRFS?
From: Chris Murphy <lists@colorremedies.com>
To: lenovomi <lenovomi@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 11, 2016 at 3:51 PM, lenovomi <lenovomi@gmail.com> wrote:
> Hi,
>
> i didnt try mount -o ro, when i tried to mount it via esata i got
> kernel panic immediately. Then i conntected enclosure with drives via
> usb and tried to mount it :

OK so try '-o ro,recovery' and report back what you get.



>
> https://bpaste.net/show/641ab9172539
> plugged via usb -> mount randomly one of the drive mount /dev/sda /mnt/brtfs
>
> I was told on irc channel that i should not run btrfs check and if so
> i should run it as
> btrfs check --repair --init-extent-tree
>
>
> Also there was recommendation to run btrfs restore before repair.

Did you use btrfs restore?
https://btrfs.wiki.kernel.org/index.php/Restore

And did you use --repair --init-extent-tree? I don't recommend it
until you use restore as well.



> Still not clear what should i do as next step.

1. mount with -o ro,recovery  and get important date backed up. It
sounds like you don't have a backup?

2. If that doesn't work, use btrfs restore. It's tedious but at least
you can update your backup.

3. Next try btrfs check without repair. There's some nuance whether
it's better to use init-extent-tree or try zeroing the log. But don't
use repair until there's a current backup with 1 or 2.

-- 
Chris Murphy
