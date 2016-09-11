Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:32806 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756237AbcIKS4Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 14:56:24 -0400
Received: by mail-lf0-f49.google.com with SMTP id h127so74436217lfh.0
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Sep 2016 11:56:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <5440522.9CHaGU5Wjs@merkaba> <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Sun, 11 Sep 2016 21:56:07 +0300
Message-ID: <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com>
Subject: Re: Small fs
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/11/16, Duncan <1i5t5.duncan@cox.net> wrote:
> Martin Steigerwald posted on Sun, 11 Sep 2016 17:32:44 +0200 as excerpted:
>>> What is the smallest recommended fs size for btrfs?
>>> Can we say size should be in multiples of 64MB?
>> Do you want to know the smalled *recommended* or the smallest *possible*
>> size?

In fact both.
I'm reconsidering my options for /boot

> * Metadata, and thus mixed-bg, defaults to DUP mode on a single-device
> filesystem (except on ssd where I actually still use it myself, and
> recommend it except for ssds that do firmware dedupe).  In mixed-mode
> this means two copies of data as well, which halves the usable space.

> IOW, when using mixed-mode, which is recommended under a gig, and dup
> replication which is then the single-device default, effective usable
> space is **HALVED**, so 256 MiB btrfs size becomes 128 MiB usable. (!!)

> * There's also a system chunk to consider.  This too is normally dup mode
> on single device, raid1 on multi.  While it shrinks to some extent with
> size of filesystem, my 256 MiB /boot still has a 15.5 MiB system chunk,
> doubled due to dup mode to 31 MiB.  This is overhead you won't be able to
> use for anything else.
>
> * There's also global reserve.  This is a part of metadata (and thus
> mixed-mode) that cannot be used under normal circumstances either.
> However, unlike normal metadata, the accounting here is single -- it's X
> space reserved no matter the replication type.  On my 256 MiB /boot, it's
> 4 MiB.
>
> So of my 256 MiB btrfs mixed-mode /boot, 31+4=35 MiB is overhead, leaving
> 221 MiB for actual data and metadata.  But due to dup mode that's halved,
> to 110.5 MiB usable space.

That's quite an info.. Thanks a lot..

Just to note again:
Ordinary 127MB btrfs gives "Out of space" around
64MB payload. 128MB is usable to the end.

I'm experimenting with an extracted (and customized) initrd
on /boot. That is, /boot is a "minimal root on its own" which
can switch to real root or do other things. Kernel and modules
at /boot will not support any fs other than btrfs. (Or it may)

It seems a minimally usable root around 10MB is possible.
And it is free of udev and systemd..
