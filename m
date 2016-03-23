Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:36834 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbcCWR6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 13:58:17 -0400
Received: by mail-qg0-f49.google.com with SMTP id u110so18473900qge.3
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 10:58:16 -0700 (PDT)
Subject: Re: btrfs ways to travel back in time
To: Vytautas D <vytdau@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAO5K3OeqQUx18gjHNVcOK8=Zo=JLOJhHBJz4jdti73DGakeAfQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56F2D930.7000405@gmail.com>
Date: Wed, 23 Mar 2016 13:58:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAO5K3OeqQUx18gjHNVcOK8=Zo=JLOJhHBJz4jdti73DGakeAfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-23 13:41, Vytautas D wrote:
> I can think of few ways to revert changes with btrfs, but I wonder
> what are the trade-offs between each method and perhaps there is
> already research done on this?
>
> ways to restore a snapshot ( post kernel 3.* ):
> a) via set-default
>   1. btrfs subvolume set-default / $id
>   2. reboot
> b) always mount into snapshot
>   1. mount -o suvol=/.current $disk # at initrd
>   2. btrfs subvol del /.current
>   3. btrfs subvol snapshot /.snapshotA /.current
>   4. reboot
> c) rsync
>   1. rsync $options /.snapshotA /.current
>   2. reboot
>
I can't give much advice on these except to say that the last one listed 
is horribly inefficient and may break things (and use large amounts of 
space).

That said, I can share what I use on my systems to do this.  On all of 
my systems, I intentionally do not use the default subvolume feature, 
and always specify what subvolume to mount.  This allows me to take 
snapshots of the system prior to upgrades (or in other cases where I 
need a snapshot), and then roll back by doing the following:
1. mount LABEL=root /mnt/tmp
2. mv /mnt/tmp/root /mnt/tmp/old-root
3. mv /mnt/tmp/snap1 /mnt/tmp/root
4. touch /mnt/tmp/root/.rollback
3. reboot
6. An custom init script sees the file /.rollback, and then copies over 
any nested subvolumes from the old-root subvolume, renames old-root to 
old-$(date +%FT%T), and deletes /.rollback

This works because mounting with the 'subvol=' mount option only pays 
attention to the path, not the subvolume id or inode.

This can be done on a live system which is actively using the subvolume 
without disrupting normal operation, provided the subvolume itself is 
mounted as part of the FS hierarchy and not implicitly used via nesting. 
  All writes to the mounted subvolume still get sent to the old 
subvolume until the reboot happens (which is usually a good thing).
