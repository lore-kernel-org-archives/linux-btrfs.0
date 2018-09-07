Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f53.google.com ([209.85.167.53]:33026 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbeIHAAB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 20:00:01 -0400
Received: by mail-lf1-f53.google.com with SMTP id m26-v6so12911619lfb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 12:17:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHTTHinoyvVCq2ejsDDgtzvFZCiyv7RiJnEkjnx+JdVZYB2+4w@mail.gmail.com>
References: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
 <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
 <CAJCQCtQHmk3ViUkynDhsb6_jCjpRHY6dSdZGiDZzg3k=XW9+-A@mail.gmail.com>
 <090f8da0-c29c-da5f-6e5b-ec6961706508@gmail.com> <CAJCQCtTHxM+Bx8akyV+QdYch=y6-0hCf_3r1KonPC2vKsujkxQ@mail.gmail.com>
 <d0223039-5c8f-38db-fe32-0b46b220e699@gmail.com> <CAJCQCtREREvzveNqdahGb8GN62_CJMyeL8GhjxnqmVZqxKiDUA@mail.gmail.com>
 <326f12a3-ee55-0812-5ea6-f54c0362a29b@gmail.com> <CAJCQCtS+ZXzGU0AE=C1iA7yNFrXuRAvZkhssxN40=jPd=x6neA@mail.gmail.com>
 <CAHTTHimqg_wgqs0AXt73YzOv3ga7cAEUvbwMOVVT2JUVaNbsFQ@mail.gmail.com>
 <CAJCQCtSa1-5Zae4_jqqhZk49YQ+6fKG+jgwcG2_uK5+sYfwCbQ@mail.gmail.com> <CAHTTHinoyvVCq2ejsDDgtzvFZCiyv7RiJnEkjnx+JdVZYB2+4w@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 7 Sep 2018 13:17:38 -0600
Message-ID: <CAJCQCtTd7+u3yMtKDshmsw7R1P2bK_JhVqJVKvObNb20uw-6jA@mail.gmail.com>
Subject: Re: btrfs send hung in pipe_wait
To: Stefan Loewen <stefan.loewen@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 7, 2018 at 11:07 AM, Stefan Loewen <stefan.loewen@gmail.com> wrote:
> List of steps:
> - 3.8G iso lays in read-only subvol A
> - I create subvol B and reflink-copy the iso into it.
> - I create a read-only snapshot C of B
> - I "btrfs send --no-data C > /somefile"
> So you got that right, yes.

OK I can't reproduce it. Sending A and C complete instantly with
--no-data, and complete in the same time with a full send/receive. In
my case I used a 4.9G ISO.

I can't think of what local difference accounts for what you're
seeing. There is really nothing special about --reflinks. The extent
and csum data are identical to the original file, and that's the bulk
of the metadata for a given file.

What I can tell you is usually the developers want to see sysrq+w
whenever there are blocked tasks.
https://fedoraproject.org/wiki/QA/Sysrq

You'll want to enable all sysrq functions. And next you'll want three
ssh shells:

1. sudo journalctl -fk
2. sudo -i to become root, and then echo w > /proc/sysrq-trigger but
do not hit return yet
3. sudo btrfs send... to reproduce the problem.

Basically the thing is gonna hang soon after you reproduce the
problem, so you want to get to shell #2 and just hit return rather
than dealing with long delays typing that echo command out. And then
the journal command is so your local terminal captures the sysrq
output because you're gonna kill the VM instead of waiting it out. I
have no idea how to read these things but someone might pick up this
thread and have some idea why these tasks are hanging.




>
> Unfortunately I don't have any way to connect the drive to a SATA port
> directly but I tried to switch out as much of the used setup as
> possible (all changes active at the same time):
> - I got the original (not the clone) HDD out of the enclosure and used
> this adapter to connect it:
> https://www.amazon.de/DIGITUS-Adapterkabel-40pol-480Mbps-schwarz/dp/B007X86VZK
> - I used a different Notebook
> - I ran the test natively on that notebook (instead of from
> VirtualBox. I used VirtualBox for most of the tests as I have to
> force-poweroff the PC everytime the btrfs-send hangs as it is not
> killable)


This problem only happens in VirtualBox? Or it happens on baremetal
also? And we've established it happens with two different source
(send) devices, which means two different Btrfs volumes.

All I can say is you need to keep changing things up, process of
elimination. Rather tedious. Maybe you could try downloading a Fedora
28 ISO, make a boot stick out of it, and try to reproduce with the
same drives. At least that's an easy way to isolate the OS from the
equation.


-- 
Chris Murphy
