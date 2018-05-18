Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:33714 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbeERJgf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 05:36:35 -0400
Received: by mail-ot0-f172.google.com with SMTP id l22-v6so8392685otj.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 02:36:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn7pOa0+1ur9Twr7MoQCweaX7BXtWuWwfECW6z+=be44_w@mail.gmail.com>
References: <CA+X5Wn7pOa0+1ur9Twr7MoQCweaX7BXtWuWwfECW6z+=be44_w@mail.gmail.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Fri, 18 May 2018 05:36:33 -0400
Message-ID: <CA+X5Wn4-Wa3C45Dr0AQWoA0_5Ke-9r=xxNo0yGy4Ah9mkPe=ww@mail.gmail.com>
Subject: Re: btrfs device replace can cause silent or noisy corruption on
 compressed NOCOW/NODATASUM
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2018 at 5:46 AM, james harvey <jamespharvey20@gmail.com> wrote:
> ...
> In short, "btrfs device replace" caused it...
> ...

This should read "btrfs replace".

Ran a 2 year old ISO, archlinux-2016.04.01-dual.iso.  Kernel 4.4.5,
btrfs-progs v4.4.1.  Same behavior as example, so not a (within 2
year) regression.

(Back on current kernel/btrfs...)

Confirmed same behavior using existing device to replace rather than
id, adding a 4th partition to the disk in my example:

# btrfs replace start -B /dev/vda1 /dev/vda4 /mnt
-or even-
# btrfs replace start -Br /dev/vda1 /dev/vda1 /mnt

Realized in my original example, I didn't run "filefrag -v" again to
make sure the physical offsets didn't change.  But, tried the example
again with it, and replace didn't change them.

There's a workaround, before a fix is available, and for anyone who
can't upgrade to a new version once the fix is available:

# btrfs device add /dev/vda4 /mnt
# btrfs device remove /dev/vda1 /mnt

This does more than just make new mirrored copies on /dev/vda4 of the
data that was on /dev/vda1.  At least in my run of this example, it
moves the mirrored copies for the file from physical offsets starting
269952 to 531904, from device ids 1&2 to 3&4.  So, it might take a bit
longer.  But, who cares, it leaves the data properly mirrored and in
compressed form.



I'll also note that even before any of the patches in the past few
days, this is sufficient to re-write the file uncompressed, respecting
its NOCOW attribute:

# cp zero /root/zero
# cp /root/zero zero
# sync
