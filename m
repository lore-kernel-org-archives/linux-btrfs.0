Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34845 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933265AbcILOJ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 10:09:26 -0400
Received: by mail-vk0-f54.google.com with SMTP id 16so116487138vko.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 07:09:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3e8e686c-9c42-a1e1-a0ac-9eb27208360d@gmail.com>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net> <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com>
 <1771908.LWBdy5fQ5X@merkaba> <3e8e686c-9c42-a1e1-a0ac-9eb27208360d@gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 12 Sep 2016 16:09:23 +0200
Message-ID: <CAPmG0jZprQr8vnasD9E8hmadj3rYXvwkm9Ny6eCwqznbOGzDtA@mail.gmail.com>
Subject: Re: Small fs
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        Imran Geriskovan <imran.geriskovan@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> FWIW, I use BTRFS for /boot, but it's not for snapshotting or even the COW,
> it's for DUP mode and the error recovery it provides.  Most people don't
> think about this if it hasn't happened to them, but if you get a bad read
> from /boot when loading the kernel or initrd, it can essentially nuke your
> whole system.  I run BTRFS for /boot in DUP mode with mixed-bg (because I
> only use 512MB for boot) to mitigate the chance that a failed read has any
> impact, and ensure that if it does, it will refuse to boot instead of
> booting with a corrupted kernel or initrd.

Suppose kernel and initrd are on a BTRFS fs with data, metadata and
system all single profile. Will a bootloader then just continue
booting up a system even when there are csum errors in kernel and/or
initrd files?  Suppose the bootloader is grub2.
