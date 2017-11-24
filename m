Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:40193 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753121AbdKXKQR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 05:16:17 -0500
Received: by mail-vk0-f51.google.com with SMTP id h21so9258116vke.7
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Nov 2017 02:16:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19a5ec80-3860-20b8-cb12-fcb41b21dc00@gmx.com>
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
 <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com> <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
 <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>
 <55e496fe-6a73-b759-ed8c-4f415ddacd1d@gmx.com> <CAKuJGC-SRh=hrF6uo0vRuQd5=61CbPe-mSpuwMA1DcStihY=dg@mail.gmail.com>
 <19a5ec80-3860-20b8-cb12-fcb41b21dc00@gmx.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Fri, 24 Nov 2017 15:45:36 +0530
Message-ID: <CAKuJGC-NaE3J2tu+HEED5fkBs5C=kkkrJqb0QfkTtpdmEdSn9Q@mail.gmail.com>
Subject: Re: misc/021-image-multi-devices fails on latest btrfs-devel/misc-next
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> No, it's not about btrfs-image itself, the flag is introduced long long
> long way ago.
>
Okay.

> It's about kernel change which doesn't allow image with such flag to be
> mounted AFAIK.

No luck yet! It works on 4.14.0
-----
-bash-4.4$ sudo make TEST=021\* test-misc
    [TEST]   misc-tests.sh
    [TEST/misc]   021-image-multi-devices
-bash-4.4$ sudo dmesg
[  162.635824] BTRFS: device fsid f0c92f1b-c1ba-4576-8a07-8ce4f7b5bacd
devid 1 transid 5 /dev/loop0
[  162.672952] BTRFS: device fsid f0c92f1b-c1ba-4576-8a07-8ce4f7b5bacd
devid 2 transid 5 /dev/loop1
[  162.692848] BTRFS info (device loop1): disk space caching is enabled
[  162.695725] BTRFS info (device loop1): has skinny extents
[  162.698003] BTRFS info (device loop1): flagging fs with big metadata feature
[  162.701643] BTRFS info (device loop1): creating UUID tree
[  163.792851] BTRFS warning (device loop0): unrecognized super flag:
17179869184
[  163.796350] BTRFS info (device loop0): disk space caching is enabled
[  163.807644] BTRFS info (device loop0): has skinny extents
[  163.811613] BTRFS info (device loop0): checking UUID tree
[  163.841625] BTRFS error (device loop0): 1 errors while writing supers
[  163.845457] BTRFS: error (device loop0) in write_all_supers:3709:
errno=-5 IO failure (1 errors while writing supers)
[  163.851520] BTRFS info (device loop0): forced readonly
[  163.855184] BTRFS warning (device loop0): Skipping commit of
aborted transaction.
[  163.859121] BTRFS: error (device loop0) in
cleanup_transaction:1873: errno=-5 IO failure
[  163.862577] BTRFS info (device loop0): delayed_refs has NO entry
[  163.865623] BTRFS error (device loop0): commit super ret -5
[  163.868303] BTRFS error (device loop0): cleaner transaction attach
returned -30
-bash-4.4$ uname -a
Linux ip-172-31-33-196.us-west-2.compute.internal 4.14.0 #1 SMP Fri
Nov 24 09:48:11 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
-----

Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org
