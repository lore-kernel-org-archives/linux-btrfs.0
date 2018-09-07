Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38391 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728973AbeIGUZr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 16:25:47 -0400
Received: by mail-lj1-f193.google.com with SMTP id p6-v6so12666628ljc.5
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 08:44:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHTTHimqg_wgqs0AXt73YzOv3ga7cAEUvbwMOVVT2JUVaNbsFQ@mail.gmail.com>
References: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
 <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
 <CAJCQCtQHmk3ViUkynDhsb6_jCjpRHY6dSdZGiDZzg3k=XW9+-A@mail.gmail.com>
 <090f8da0-c29c-da5f-6e5b-ec6961706508@gmail.com> <CAJCQCtTHxM+Bx8akyV+QdYch=y6-0hCf_3r1KonPC2vKsujkxQ@mail.gmail.com>
 <d0223039-5c8f-38db-fe32-0b46b220e699@gmail.com> <CAJCQCtREREvzveNqdahGb8GN62_CJMyeL8GhjxnqmVZqxKiDUA@mail.gmail.com>
 <326f12a3-ee55-0812-5ea6-f54c0362a29b@gmail.com> <CAJCQCtS+ZXzGU0AE=C1iA7yNFrXuRAvZkhssxN40=jPd=x6neA@mail.gmail.com>
 <CAHTTHimqg_wgqs0AXt73YzOv3ga7cAEUvbwMOVVT2JUVaNbsFQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 7 Sep 2018 09:44:16 -0600
Message-ID: <CAJCQCtSa1-5Zae4_jqqhZk49YQ+6fKG+jgwcG2_uK5+sYfwCbQ@mail.gmail.com>
Subject: Re: btrfs send hung in pipe_wait
To: Stefan Loewen <stefan.loewen@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 7, 2018 at 6:47 AM, Stefan Loewen <stefan.loewen@gmail.com> wrote:
> Well... It seems it's not the hardware.
> I ran a long SMART check which ran through without errors and
> reallocation count is still 0.

That only checks the drive, it's an internal test. It doesn't check
anything else, including connections.

Also you do have a log with a read error and a sector LBA reported. So
there is a hardware issue, it could just be transient.


> So I used clonezilla (partclone.btrfs) to mirror the drive to another
> drive (same model).
> Everything copied over just fine. No I/O error im dmesg.
>
> The new disk shows the same behavior.

So now I'm suspicious of USB behavior. Like I said earlier, when I've
got USB enclosed drives connect to my NUC, regardless of file system,
I routinely get hangs and USB resets. I have to connect all of my USB
enclosed drives to a good USB hub, or I have problems.



> So I created another subvolume, reflinked stuff over and found that it
> is enough to reflink one file, create a read-only snapshot and try to
> btrfs-send that. It's not happening with every file, but there are
> definitely multiple different files. The one I tested with is a 3.8GB
> ISO file.
> Even better:
> 'btrfs send --no-data snap-one > /dev/null'
> (snap-one containing just one iso file) hangs as well.

Do you have a list of steps to make this clear? It sounds like first
you copy a 3.8G ISO file to one subvolume, then reflink copy it into
another subvolume, then snapshot that 2nd subvolume, and try to send
the snapshot? But I want to be clear.

I've got piles of reflinked files in snapshots and they send OK,
although like I said I do get sometimes a 15-30 second hang during
sends.

> Still dmesg shows no IO errors, only "INFO: task btrfs-transacti:541
> blocked for more than 120 seconds." with associated call trace.
> btrfs-send reads some MB in the beginning, writes a few bytes and then
> hangs without further IO.
>
> copying the same file without --reflink, snapshotting and sending
> works without problems.
>
> I guess that pretty much eleminates bad sectors and points towards
> some problem with reflinks / btrfs metadata.

That's pretty weird. I'll keep trying and see if I hit this. What
happens if you downgrade to an older kernel? Either 4.14 or 4.17 or
both. The send code is mainly in the kernel, where the receive code is
mainly in user space tools, for this testing you don't need to
downgrade user space tools. If there's a bug here, I expect it's
kernel.




-- 
Chris Murphy
