Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:36534 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbdGYNzT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 09:55:19 -0400
Received: by mail-ua0-f171.google.com with SMTP id k43so66863302uaf.3
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 06:55:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170725135146.GM7140@carfax.org.uk>
References: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
 <20170725134656.GL7140@carfax.org.uk> <20170725135146.GM7140@carfax.org.uk>
From: =?UTF-8?Q?H=C3=A9rikz_Nawarro?= <herikz.nawarro@gmail.com>
Date: Tue, 25 Jul 2017 10:55:18 -0300
Message-ID: <CAD6NJSz0qMYhiqmseOQtG-ytVTck1aZykVe+U1FtXQvTMThs4g@mail.gmail.com>
Subject: Re: btrfs raid assurance
To: Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?Q?H=C3=A9rikz_Nawarro?= <herikz.nawarro@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And btw, my current disk conf is a 1x 500GB, 2x3TB and a 5TB.

2017-07-25 10:51 GMT-03:00 Hugo Mills <hugo@carfax.org.uk>:
> On Tue, Jul 25, 2017 at 01:46:56PM +0000, Hugo Mills wrote:
>> On Tue, Jul 25, 2017 at 09:55:37AM -0300, Hérikz Nawarro wrote:
>> > Hello everyone,
>> >
>> > I'm migrating to btrfs and i would like to know, in a btrfs filesystem
>> > with 4 disks (multiple sizes) with -d raid0 & -m raid1, how many
>> > drives can i lost without losing the entire array?
>
>    Oh, and one other thing -- if you have different-sized devices,
> RAID-0 is probably the wrong thing to be using anyway, as you won't be
> able to use the difference between the largest and second-largest
> device. If you want to use all the space on the available devices,
> then "single" mode is probably better (although you still lose a lot
> of data if a device breaks), or RAID-1 (which will cope well with the
> different sizes as long as the largest device is smaller than the rest
> of them added together).
>
>    You can see about the disk usage in different scenarios with the
> online tool at:
>
> http://carfax.org.uk/btrfs-usage/
>
>    Hugo.
>
> --
> Hugo Mills             | One of these days, I'll catch that man without a
> hugo@... carfax.org.uk | quotation, and he'll look undressed.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                                   Leto Atreides, Dune
