Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:41607 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbeIHOdl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Sep 2018 10:33:41 -0400
Received: by mail-oi0-f51.google.com with SMTP id k12-v6so31676788oiw.8
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Sep 2018 02:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
 <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
 <CAJCQCtQHmk3ViUkynDhsb6_jCjpRHY6dSdZGiDZzg3k=XW9+-A@mail.gmail.com>
 <090f8da0-c29c-da5f-6e5b-ec6961706508@gmail.com> <CAJCQCtTHxM+Bx8akyV+QdYch=y6-0hCf_3r1KonPC2vKsujkxQ@mail.gmail.com>
 <d0223039-5c8f-38db-fe32-0b46b220e699@gmail.com> <CAJCQCtREREvzveNqdahGb8GN62_CJMyeL8GhjxnqmVZqxKiDUA@mail.gmail.com>
 <326f12a3-ee55-0812-5ea6-f54c0362a29b@gmail.com> <CAJCQCtS+ZXzGU0AE=C1iA7yNFrXuRAvZkhssxN40=jPd=x6neA@mail.gmail.com>
 <CAHTTHimqg_wgqs0AXt73YzOv3ga7cAEUvbwMOVVT2JUVaNbsFQ@mail.gmail.com>
 <CAJCQCtSa1-5Zae4_jqqhZk49YQ+6fKG+jgwcG2_uK5+sYfwCbQ@mail.gmail.com>
 <CAHTTHinoyvVCq2ejsDDgtzvFZCiyv7RiJnEkjnx+JdVZYB2+4w@mail.gmail.com>
 <CAJCQCtTd7+u3yMtKDshmsw7R1P2bK_JhVqJVKvObNb20uw-6jA@mail.gmail.com>
 <CAHTTHimT7m+S4bm1OgZOfmFkk69fc1SPGEvidxwFCHniKL-w6A@mail.gmail.com> <CAJCQCtQBwvvbYR3u=EGbRR=rsnBaZK5F=mso3SE_kPwtcXyvHg@mail.gmail.com>
In-Reply-To: <CAJCQCtQBwvvbYR3u=EGbRR=rsnBaZK5F=mso3SE_kPwtcXyvHg@mail.gmail.com>
From: Stefan Loewen <stefan.loewen@gmail.com>
Date: Sat, 8 Sep 2018 11:47:48 +0200
Message-ID: <CAHTTHimDSYZCm7LmpSYkaFjZT-nquraQmr2ftis9wtKup1y-sg@mail.gmail.com>
Subject: Fwd: btrfs send hung in pipe_wait
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And this one as well.

---------- Forwarded message ---------
From: Chris Murphy <lists@colorremedies.com>
Date: Fr., 7. Sep. 2018 um 23:53 Uhr
Subject: Re: btrfs send hung in pipe_wait
To: Stefan Loewen <stefan.loewen@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>


On Fri, Sep 7, 2018 at 3:19 PM, Stefan Loewen <stefan.loewen@gmail.com> wrote:
> Now I also tested with Fedora 28 (linux 4.16) from live-usb (so baremetal).
> Same result.
> Thanks for the pointer towards sys requests. sysrq-w is empty, but I
> sent a bunch of other sysrqs to get stacktraces etc. from the kernel.
> Logs are attached.

Needs a dev to take a look at this, or someone with usb or block
device knowledge to see if something unrelated to btrfs is hung up. I
can't parse it.

Using btrfs-progs 4.17.1, what do you get for 'btrfs check
--mode=lowmem <dev>' ?



--
Chris Murphy
