Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:42318 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753401AbeFIWxb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jun 2018 18:53:31 -0400
Received: by mail-ot0-f193.google.com with SMTP id 92-v6so19749490otw.9
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jun 2018 15:53:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 9 Jun 2018 16:53:30 -0600
Message-ID: <CAJCQCtSjEHaCb-iPa8Z_hC_pnPpC3kGr8cBwOwsknzNH6PGnBA@mail.gmail.com>
Subject: Re: corrupt leaf; unaligned key offset for csum item
To: Simon Kaiser <simon.kaiser@kit.edu>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 9, 2018 at 6:22 AM, Simon Kaiser <simon.kaiser@kit.edu> wrote:
> Hi all,
>
> I'm having trouble with my btrfs volume on a Samsung SSD 840 pro.  On
> startup I immediately get the error
>
> BTRFS critical (device sda5): corrupt leaf: root=1 block=73263579136
> slot=105, unaligned key offset for csum item, have 1271496708 should be
> aligned to 4096
>
> I used to make regular backups, but slacked off recently.  Fixing the
> filesystem isn't essential in any way, but would save me quite some time
> on config tinkering and weeding out vacation photos.  The second of
> which I don't enjoy at all...
>
> On similar issues faulty RAM seemed to be the most prominent cause.  I
> added a third memory module quite recently which could have caused this,
> but I couldn't run memtest long enough yet to verify.
>
> Here's the trimmed dmesg output (full output at
> https://pastebin.com/7XF9i09K)
>
> [    4.062748] BTRFS critical (device sda5): corrupt leaf: root=1 block=73263579136 slot=105, unaligned key offset for csum item, have 1271496708 should be aligned to 4096
> [    4.063806] BTRFS info (device sda5): no csum found for inode 7810710 start 0
> [    4.064260] BTRFS warning (device sda5): csum failed root 257 ino 7810710 off 109201939968 csum 0x5307fa6f expected csum 0x00000000 mirror 1
> [    4.075834] BTRFS info (device sdb3): use lzo compression, level 0
> [    4.075836] BTRFS info (device sdb3): enabling auto defrag
> [    4.075837] BTRFS info (device sdb3): disk space caching is enabled


What are your mount options?

I suggest removing the suspected bad ram first, and then boot off
alternate media:

btrfs insp dump-s -f <dev>

Try to mount with -o ro, and if that doesn't work try -o
ro,norecovery. Read only mount is more tolerant of problems than rw
mount. If either work, then update your backups while you have a
chance. It's easier to backup from ro mount than it is to use 'btrfs
restore'

If neither -o ro nor -o ro,norecovery work try:

-o usebackuproot

There might be some recent changes data loss using that option. But if
you're using the discard mount option, it probably will fail.

If -o ro does not work, but -o ro,norecovery did work, it's a
candidate for 'btrfs rescue zero-log' again there might be some recent
change data loss if you zero the log.

btrfs check --repair is a last resort so I don't recommend it until
you've got a backup some other way.



-- 
Chris Murphy
