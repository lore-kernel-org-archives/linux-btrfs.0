Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:43591 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752386AbeFJVor (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Jun 2018 17:44:47 -0400
Received: by mail-ot0-f195.google.com with SMTP id i19-v6so21603806otk.10
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Jun 2018 14:44:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9C0633CD-D4FC-4A93-9A6F-1EF185F4205D@gmail.com>
References: <9C0633CD-D4FC-4A93-9A6F-1EF185F4205D@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 10 Jun 2018 15:44:46 -0600
Message-ID: <CAJCQCtSmWzXKRmJv2Wk=7eb1txAfX6y1Ap+_a+CfziaoNZe9nw@mail.gmail.com>
Subject: Re: Filesystem read-only (btrbk, bad metadata, unable to find ref byte)
To: Vote 539 <vote539@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 10, 2018 at 12:42 PM, Vote 539 <vote539@gmail.com> wrote:
> I have a btrfs filesystem that I use as a target for send/receive incremental snapshots.  I use btrbk to perform hourly backups.
>
> The target filesystem was offline for a few days.  When I mounted it today, the filesystem was read-only, with dmesg errors:
>
>     …
>     [  167.004684] BTRFS error (device sda2): unable to find ref byte nr 40366194688 parent 0 root 6894  owner 1 offset 0
>     [  167.004722] ------------[ cut here ]------------
>     [  167.004735] WARNING: CPU: 0 PID: 1273 at /build/linux-E14mqW/linux-4.4.0/fs/btrfs/extent-tree.c:6553 __btrfs_free_extent.isra.68+0x8ff/0xd30 [btrfs]()
>     [  167.004736] BTRFS: Transaction aborted (error -2)
>     …
>     [  167.005011] BTRFS: error (device sda2) in __btrfs_free_extent:6553: errno=-2 No such entry
>     [  167.005041] BTRFS info (device sda2): forced readonly
>     [  167.005044] BTRFS: error (device sda2) in btrfs_run_delayed_refs:2930: errno=-2 No such entry
>     …
>
> Full dmesg: https://pastebin.com/XNKJbN15

I suggest trying a more recent kernel and see if that can handle the
problem better, 4.14.48 or newer.

>
> I unmounted the filesystem and ran btrfs check.  I let it run overnight.  Output:

The crossing stripe boundaries message sounds like messages we saw
with an older btrfs-progs. What version are you using? I suggest
4.16.2 and running 'btrfs check --mode=lowmem' option. It will be slow
but it's a different implementation than the default.

-- 
Chris Murphy
