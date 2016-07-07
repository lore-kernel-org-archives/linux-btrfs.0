Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:33498 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbcGGQBQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 12:01:16 -0400
Received: by mail-vk0-f41.google.com with SMTP id b192so26044870vke.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 09:01:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
References: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
From: Henk Slager <eye1tm@gmail.com>
Date: Thu, 7 Jul 2016 18:01:14 +0200
Message-ID: <CAPmG0jZZ7FB0teBGGHojPoGctRyVC3D2cS56q1kYDMFrC=fOnA@mail.gmail.com>
Subject: Re: rollback to a snapshot and delete old top volume - missing of "@"
To: Kai Herlemann <nesadaw@freenet.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 7, 2016 at 2:17 PM, Kai Herlemann <nesadaw@freenet.de> wrote:
> Hi,
>
> I want to rollback a snapshot and have done this by execute "btrfs sub
> set-default / 618".
maybe just a typo here, command syntax is:
# sudo btrfs sub set-default
btrfs subvolume set-default: too few arguments
usage: btrfs subvolume set-default <subvolid> <path>

   Set the default subvolume of a filesystem

> Now I want to delete the old top volume to save space, but google and
> manuals didn't helped.
>
> I mounted for the following the root volume at /mnt/gparted with subvolid=0,
> subvol=/ has the same effect.
> Usually, the top volume is saved in /@, so I would be able to delete it by
> execute "btrfs sub delete /@" (or move at first @ to @_badroot and the
> snapshot to @). But that isn't possible, the output of that command is
> "ERROR: cannot access subvolume /@: No such file or directory".
> I've posted the output of "btrfs sub list /mnt/gparted" at
> http://pastebin.com/r7WNbJq8. As you can see, there's no subvolume named @.

I think one or the other commandtyping didn't have its expected
effect, just to make sure I get the right state, can you do:

mkdir -p /fsroot
mount -o subvolid=0 UUID=<uuid of filesystem> /fsroot
btrfs sub list /fsroot
btrfs subvolume get-default /

What the latest debian likes as naming convention I dont know, but in
openSuSE @ is a directory in the toplevel volume (ID=5 or ID=0 as
alias) and that directory contains subvolumes. You can do whatever you
like best, but at least make sure you have mount entries in fstab
subvolumes like var/cache/apt and usr/src, otherwise this magnificent
rootfstree snapshotting gets you into trouble.

I think your current default subvolume is still 5, so you would need:

fstab:
UUID=<uuid of filesystem>    /    btrfs    defaults   0 0
#UUID=<uuid of filesystem>    /home    btrfs    defaults,subvol=@/home   0 0
UUID=<uuid of filesystem>    /usr/src    btrfs
defaults,subvol=@/usr/src   0 0
UUID=<uuid of filesystem>    /var/cache/apt    btrfs
defaults,subvol=@/var/cache/apt   0 0
UUID=<uuid of filesystem>    /.snapshots    btrfs
defaults,subvol=@/.snapshots   0 0
UUID=<uuid of filesystem>    /fsroot    btrfs    noauto,subvolid=0   0 0


mkdir -p /fsroot
mount -o subvolid=0 UUID=<uuid of filesystem> /fsroot

mkdir -p /usr/src
mkdir -p /var/cache/apt
mkdir -p /.snapshots

mkdir -p /fsroot/@/usr
mkdir -p /fsroot/@/var/cache

btrfs sub create /fsroot/@/usr/src
btrfs sub create /fsroot/@/var/cache/apt
btrfs sub create /fsroot/@/.snapshots

#snapshots might need different, the proposed one works at least for snapper

btrfs sub snap / /fsroot/@/latestrootfs
btrfs sub set-default <ID of /fsroot/@/latestrootfs> /
btrfs fi sync /

#for home fs is it similar as for root fs

reboot

You can then when you want rollback, set a snapshot to rw  (or rename
latestrootfs, snapshot snapshot to that name ) and make it default
subvol and reboot (or maybe also do some temp chroot tricks, I have
not tried that)

> I have the same problem with my /home/ partition.
>
> Output of "uname -a" (self-compiled kernel):
> Linux debian-linux 4.1.26 #1 SMP Wed Jun 8 18:40:04 CEST 2016 x86_64
> GNU/Linux
>
> Output of "btrfs --version":
> btrfs-progs v4.5.2
>
> Output of "btrfs fi show":
> Label: none  uuid: f778877c-d50b-48c8-8951-6635c6e23c61
>           Total devices 1 FS bytes used 43.70GiB
>           devid    1 size 55.62GiB used 47.03GiB path /dev/sda1
>
> Output of "btrfs fi df /":
> Data, single: total=44.00GiB, used=42.48GiB
> System, single: total=32.00MiB, used=16.00KiB
> Metadata, single: total=3.00GiB, used=1.22GiB
> GlobalReserve, single: total=416.00MiB, used=0.00B
>
> Output of dmesg attached.
>
> Thank you,
> Kai
>
