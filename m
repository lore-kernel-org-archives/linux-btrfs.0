Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34158 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752329AbdIAU3T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 16:29:19 -0400
Received: by mail-oi0-f46.google.com with SMTP id w10so10589484oie.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 13:29:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ_hD5DVimZjM5Y54AU6GeruN-T8fCvwKtufJO3=rMwqmU3aKQ@mail.gmail.com>
References: <CAJ_hD5By15sSvur7849XWQ8jkBoGj0cO5vQfY8MguVDCneMX8Q@mail.gmail.com>
 <20170831183302.GB30990@carfax.org.uk> <CAJ_hD5D49amQEq7YMu=d-EhRK-CkJerbT=uAc1+rpg+_12KFsQ@mail.gmail.com>
 <20170831185922.GC30990@carfax.org.uk> <CAJ_hD5DLufKpJPHpvFhsq8fj-oL++=NMkMPEHe9y=dCcsbUwtg@mail.gmail.com>
 <20170831201124.GD30990@carfax.org.uk> <CAJ_hD5DVimZjM5Y54AU6GeruN-T8fCvwKtufJO3=rMwqmU3aKQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 1 Sep 2017 14:29:18 -0600
Message-ID: <CAJCQCtTY6+xRsEVrnr9U9OhJ2DsPuUFqiNeC8cuz47ctViviiA@mail.gmail.com>
Subject: Re: BTRFS critical (device sda2): corrupt leaf, bad key order:
 block=293438636032, root=1, slot=11
To: Eric Wolf <19wolf@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 1, 2017 at 7:38 AM, Eric Wolf <19wolf@gmail.com> wrote:
> Okay,
> I have a hex editor open. Now what? Your instructions seems
> straightforward, but I have no idea what I'm doing.

First step, backup as much as you can, because if you don't know what
you're doing, good chance you make a mistake and break the file
system. So be prepared for making things worse.

Next, you need to get the physical sector(s) for the leaf containing
the error. Use btrfs-map-logical -l <address> for this, where address
is the same one you used before with btrfs-debug-tree. If this is a
default file system, the leaf is 16KiB, that's 32 512 byte sectors.
And btrfs-map-logical will report back LBA based on 512 bytes *if*
this is a 512e drive, which most drives are, but you should make sure.

]$ sudo blockdev --getss /dev/nvme0n1
512

If it's 512 bytes, your bad item is in one of 32 sectors starting from
the LBA reported by btrfs-map-logical. If it's 4096 bytes then it's
one of four sectors starting from that LBA. Find out which sector the
bad key is in, which you have to do looking at hex, literally you will
have to go byte by byte from the beginning, learning how to parse the
on-disk format. And fix the bad item object id as described by Hugo.
And then after you fix that, mount the volume, scrub (or read a file
that will trigger the problem if you can) this time you'll get a bad
csum error instead of the original corrupt leaf error. And that csum
error will tell you what csum it found and what csum it expects. So
now you go back to that first sector, which is where the csum is
stored, find it, and replace it with the expected csum. And maybe (not
sure) the csum error will be in decimal, in which case you'd have to
convert to hex to find the bad one and replace with the good one.

Tedious. Maybe the Hans van Kranenberg's btrfs-python is easier, I have no idea.


-- 
Chris Murphy
