Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34929 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcGDSlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 14:41:42 -0400
Received: by mail-oi0-f48.google.com with SMTP id r2so203456054oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 11:41:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 4 Jul 2016 12:41:41 -0600
Message-ID: <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 4, 2016 at 12:09 PM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:

> sudo mount -t btrfs -o ro,recovery /dev/sdc /shares
> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>        missing codepage or helper program, or other error
>
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.


It needs -o degraded, not recovery.

Do not use 'btrfs replace' on raid5 right now, it seems to be
unreliable. If you do not have a backup of this raid5 I highly
recommend that you mount -o ro,degraded and make a backup now before
you do anything else to the file system. Degraded raid56 is really
fragile on Btrfs, and still broadly considered experimental (or at
least has enough caveats and gotchas that it's really just for expert
usage).


> sudo btrfs rescue chunk-recover /dev/sdc
> Scanning: 2517981163520 in dev0, 3166618750976 in dev1Segmentation fault
> (core dumped)

This is not a good idea. Avoid randomly trying things, especially
things that have absolutely nothing to do with your problem.



>
> sudo btrfs filesystem show /dev/sda
> warning, device 3 is missing
> checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
> checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
> bytenr mismatch, want=12678831570944, have=10160133442474442752
> Couldn't read chunk tree
> Label: none  uuid: 2dab74bb-fc73-4c47-a413-a55840f6f71e
>         Total devices 3 FS bytes used 3.80TiB
>         devid    1 size 3.64TiB used 1.92TiB path /dev/sdb
>         devid    2 size 3.64TiB used 1.92TiB path /dev/sda
>         *** Some devices missing
>
> sudo btrfs restore /dev/sda /mnt
> warning, device 3 is missing
> checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
> checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
> bytenr mismatch, want=12678831570944, have=10160133442474442752
> Couldn't read chunk tree
> Could not open root, trying backup super
> warning, device 3 is missing
> warning, device 1 is missing


It's concerning that this says device 1 is missing when 'btrfs fi
show' clearly shows it as not missing. There's a bug here somewhere,
either show is wrong, or restore is wrong. That restore sees two
missing devices means it probably can't reconstruct from parity, and
there will be csum errors. Hopefully that's all that's going on right
now.






-- 
Chris Murphy
