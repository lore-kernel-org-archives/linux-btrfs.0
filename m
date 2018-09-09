Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f45.google.com ([209.85.167.45]:35156 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbeIIHTG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Sep 2018 03:19:06 -0400
Received: by mail-lf1-f45.google.com with SMTP id q13-v6so14879655lfc.2
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Sep 2018 19:31:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHTTHinoH=TG+6zMw0X8rDAdaou3joc+mo_oZAL918BP1sLwqA@mail.gmail.com>
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
 <CAHTTHimT7m+S4bm1OgZOfmFkk69fc1SPGEvidxwFCHniKL-w6A@mail.gmail.com> <CAHTTHinoH=TG+6zMw0X8rDAdaou3joc+mo_oZAL918BP1sLwqA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 8 Sep 2018 20:31:09 -0600
Message-ID: <CAJCQCtTeOvJDnz8YZpCm86zuqeeTN-7p5kxEycWME+txzqz3tQ@mail.gmail.com>
Subject: Re: btrfs send hung in pipe_wait
To: Stefan Loewen <stefan.loewen@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't see any blocked tasks. I wonder if you were too fast with
sysrq w? Maybe it takes a little bit for the block task to actually
develop?

I suggest also 'btrfs check --mode=lowmem' because that is a separate
implementation of btrfs check that tends to catch different things
than the original. It is slow, however.

-- 
Chris Murphy
