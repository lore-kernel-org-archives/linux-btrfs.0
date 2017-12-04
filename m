Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:37904 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752830AbdLDE6J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Dec 2017 23:58:09 -0500
Received: by mail-ot0-f179.google.com with SMTP id p3so13699143oti.5
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Dec 2017 20:58:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171202005338.GA20205@polanet.pl>
References: <20171201161555.GA11892@polanet.pl> <20171201213614.GE29898@carfax.org.uk>
 <20171202005338.GA20205@polanet.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 3 Dec 2017 21:58:07 -0700
Message-ID: <CAJCQCtQd9pbEDOtJmMqZUGaSRM+-2Vs2HnqgycHKDjFZGiK-sA@mail.gmail.com>
Subject: Re: exclusive subvolume space missing
To: Tomasz Pala <gotar@polanet.pl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 1, 2017 at 5:53 PM, Tomasz Pala <gotar@polanet.pl> wrote:

> #  btrfs fi usage /
> Overall:
>     Device size:                 128.00GiB
>     Device allocated:            117.19GiB
>     Device unallocated:           10.81GiB
>     Device missing:                  0.00B
>     Used:                        103.56GiB
>     Free (estimated):             11.19GiB      (min: 11.14GiB)
>     Data ratio:                       1.98
>     Metadata ratio:                   2.00
>     Global reserve:              146.08MiB      (used: 0.00B)
>
> Data,single: Size:1.19GiB, Used:1.18GiB
>    /dev/sda2       1.07GiB
>    /dev/sdb2     132.00MiB

This is asking for trouble. Two devices have single copy data chunks,
if those drives die, you lose that data. But the metadata referring to
those files will survive and Btrfs will keep complaining about them at
every scrub until they're all deleted - there is no command that makes
this easy. You'd have to scrape scrub output, which includes paths to
the missing files, and script something to delete them all.

You should convert this with something like 'btrfs balance start
-dconvert=raid1,soft <mountpoint>'



-- 
Chris Murphy
