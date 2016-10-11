Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33804 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752742AbcJKQHK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 12:07:10 -0400
Received: by mail-oi0-f50.google.com with SMTP id t73so29116420oie.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 09:06:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5e8501d223d7$715a9bb0$540fd310$@com>
References: <5cde01d2230f$fa1e3150$ee5a93f0$@com> <CAJCQCtQ0SCZi36RG32NiHVYJRz8gHCtfhWYEqM93y2twX4C4JA@mail.gmail.com>
 <5ce201d22364$96702780$c3507680$@com> <CAJCQCtR_zOd=1hVrKAD_kKfE_EKZQ2omfWQV556Rg=OSbvEd0w@mail.gmail.com>
 <5e8501d223d7$715a9bb0$540fd310$@com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 11 Oct 2016 10:06:53 -0600
Message-ID: <CAJCQCtQ12AZQ9x2ddSSceGHpWYvB7sSVE0qty+=Ln9oibmiHRw@mail.gmail.com>
Subject: Re: raid6 file system in a bad state
To: "Jason D. Michaelson" <jasondmichaelson@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2016 at 9:52 AM, Jason D. Michaelson
<jasondmichaelson@gmail.com> wrote:

>> btrfs rescue super-recover -v <dev>
>
> root@castor:~/logs# btrfs rescue super-recover -v /dev/sda
> All Devices:
>         Device: id = 2, name = /dev/sdh
>         Device: id = 3, name = /dev/sdd
>         Device: id = 5, name = /dev/sdf
>         Device: id = 6, name = /dev/sde
>         Device: id = 4, name = /dev/sdg
>         Device: id = 1, name = /dev/sda
>
> Before Recovering:
>         [All good supers]:
>                 device name = /dev/sdd
>                 superblock bytenr = 65536
>
>                 device name = /dev/sdd
>                 superblock bytenr = 67108864
>
>                 device name = /dev/sdd
>                 superblock bytenr = 274877906944
>
>                 device name = /dev/sdf
>                 superblock bytenr = 65536
>
>                 device name = /dev/sdf
>                 superblock bytenr = 67108864
>
>                 device name = /dev/sdf
>                 superblock bytenr = 274877906944
>
>                 device name = /dev/sde
>                 superblock bytenr = 65536
>
>                 device name = /dev/sde
>                 superblock bytenr = 67108864
>
>                 device name = /dev/sde
>                 superblock bytenr = 274877906944
>
>                 device name = /dev/sdg
>                 superblock bytenr = 65536
>
>                 device name = /dev/sdg
>                 superblock bytenr = 67108864
>
>                 device name = /dev/sdg
>                 superblock bytenr = 274877906944
>
>                 device name = /dev/sda
>                 superblock bytenr = 65536
>
>                 device name = /dev/sda
>                 superblock bytenr = 67108864
>
>                 device name = /dev/sda
>                 superblock bytenr = 274877906944
>
>         [All bad supers]:
>                 device name = /dev/sdh
>                 superblock bytenr = 65536
>
>                 device name = /dev/sdh
>                 superblock bytenr = 67108864
>
>                 device name = /dev/sdh
>                 superblock bytenr = 274877906944
>
>
> Make sure this is a btrfs disk otherwise the tool will destroy other fs, Are you sure? [y/N]: n
> Aborted to recover bad superblocks
>
> I aborted this waiting for instructions on whether to proceed from the list.


Bad superblocks can't be a good thing and would only cause confusion.
I'd think that a known bad superblock would be ignored at mount time
and even by btrfs-find-root, or maybe even replaced like any other
kind of known bad metadata where good copies are available.

btrfs-show-super -f /dev/sda
btrfs-show-super -f /dev/sdh


Find out what the difference is between good and bad supers.


-- 
Chris Murphy
