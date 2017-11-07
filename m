Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:44299 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751994AbdKGMaz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Nov 2017 07:30:55 -0500
Received: by mail-io0-f182.google.com with SMTP id m16so1940035iod.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Nov 2017 04:30:54 -0800 (PST)
Subject: Re: Should cp default to reflink?
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSY+nso=URaU+2-qN2EWrxA7m1djcWhUAJTmjxW0yGa8Q@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d16b6352-976a-7b10-604c-5800bd575c27@gmail.com>
Date: Tue, 7 Nov 2017 07:30:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSY+nso=URaU+2-qN2EWrxA7m1djcWhUAJTmjxW0yGa8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-06 17:37, Chris Murphy wrote:
> I'm doing copies from one subvolume to another, through a mounted top
> level (id5) at /mnt/int.
> 
> This copies the whole file conventionally (no shared extents)
> $ sudo cp /mnt/int/home/chris/Downloads/Fedora-Server-dvd-x86_64-27-1.6.iso
> /mnt/int/root00/var/lib/libvirt/images/
> 
> This is a reflink copy
> $ sudo cp --reflink
> /mnt/int/home/chris/Downloads/Fedora-Server-dvd-x86_64-27-1.6.iso
> /mnt/int/root00/var/lib/libvirt/images/
> 
> This is also a refink copy, with the original removed.
> $ sudo mv /mnt/int/home/chris/Downloads/Fedora-Server-dvd-x86_64-27-1.6.iso
> /mnt/int/root00/var/lib/libvirt/images/
> 
> Seems to me any request to duplicate should be optimized by default
> with an auto reflink when possible, and require an explicit option to
> inhibit.
I would argue that it probably should, with the caveat that it 
absolutely should be well documented.  I've been using an alias to 
achieve this for months now on most of my systems with no issues, so I 
can say with some confidence that it works.  Ideally, I'd love to see a 
similar patch for busybox, but that's not really essential for this 
(though having a quick easy way to call the clone ioctl in btrfs-progs 
itself would be nice as a alternative).

There may however be some wailing and gnashing of teeth from those who 
have convinced themselves that a completely independent copy of a file 
on the same filesystem constitutes a backup and that they need such backups.
