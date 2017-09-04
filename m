Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33885 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753764AbdIDQIG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 12:08:06 -0400
Received: by mail-oi0-f51.google.com with SMTP id h70so7018870oic.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Sep 2017 09:08:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170904151154.vkhshc57t2mi2sze@angband.pl>
References: <20170904151154.vkhshc57t2mi2sze@angband.pl>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 4 Sep 2017 19:07:25 +0300
Message-ID: <CAGqmi762p8wKRv3Gz0Z5BABUvKLn7-8XhB6=v-gbdqsGMV8rUg@mail.gmail.com>
Subject: Re: \o/ compsize
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Nick Terrell <terrelln@fb.com>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-04 18:11 GMT+03:00 Adam Borowski <kilobyte@angband.pl>:
> Hi!
> Here's an utility to measure used compression type + ratio on a set of files
> or directories: https://github.com/kilobyte/compsize
>
> It should be of great help for users, and also if you:
> * muck with compression levels
> * add new compression types
> * add heurestics that could err on withholding compression too much
>
> (Thanks for Knorrie and his python-btrfs project that made figuring out the
> ioctls much easier.)
>
> Meow!
> --
> ⢀⣴⠾⠻⢶⣦⠀
> ⣾⠁⢰⠒⠀⣿⡁ Vat kind uf sufficiently advanced technology iz dis!?
> ⢿⡄⠘⠷⠚⠋⠀                                 -- Genghis Ht'rok'din
> ⠈⠳⣄⠀⠀⠀⠀

Packaged to AUR:
https://aur.archlinux.org/packages/compsize-git/

-- 
Have a nice day,
Timofey.
